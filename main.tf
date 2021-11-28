## ========================================================================== ##
## ========================================================================== ##
locals {
  repositories = defaults(var.repositories, var.repository_defaults)
}

resource "github_repository" "named" {
  for_each = local.repositories

  name               = each.key
  description        = each.value.description
  gitignore_template = each.value.gitignore_template
  license_template   = each.value.license_template
  topics             = each.value.topics
  visibility         = each.value.visibility

  allow_merge_commit     = each.value.allow_merge_commit
  allow_rebase_merge     = each.value.allow_rebase_merge
  allow_squash_merge     = each.value.allow_squash_merge
  archive_on_destroy     = each.value.archive_on_destroy
  auto_init              = each.value.auto_init
  delete_branch_on_merge = each.value.delete_branch_on_merge
  has_issues             = each.value.has_issues
  has_projects           = each.value.has_projects
  has_wiki               = each.value.has_wiki
  homepage_url           = each.value.homepage_url
  is_template            = each.value.is_template
  vulnerability_alerts   = each.value.vulnerability_alerts

  dynamic "template" {
    for_each = each.value.template == null ? [] : [each.value.template]

    content {
      owner      = template.value.owner
      repository = template.value.repository
    }
  }

  lifecycle {
    ignore_changes = [
      ## Allow user changes to the following repository fields by
      ## ignoring any differences in them.
      description,
    ]
  }
}

resource "github_branch_protection" "for" {
  for_each = merge([
    for repoName, repoCfg in local.repositories : merge(
      { for p in repoCfg.protections : "${repoName}:${p.pattern}" => merge(
        p, { repository_id = github_repository.named[repoName].id }
      ) }
    )
  ]...)

  repository_id           = each.value.repository_id
  pattern                 = each.value.pattern
  allows_deletions        = each.value.allows_deletions
  allows_force_pushes     = each.value.allows_force_pushes
  enforce_admins          = each.value.enforce_admins
  push_restrictions       = each.value.push_restrictions
  require_signed_commits  = each.value.require_signed_commits
  required_linear_history = each.value.required_linear_history

  dynamic "required_pull_request_reviews" {
    for_each = each.value.required_pull_request_reviews == null ? [] : [each.value.required_pull_request_reviews]

    content {
      dismiss_stale_reviews           = required_pull_request_reviews.value.dismiss_stale_reviews
      dismissal_restrictions          = required_pull_request_reviews.value.dismissal_restrictions
      require_code_owner_reviews      = required_pull_request_reviews.value.require_code_owner_reviews
      required_approving_review_count = required_pull_request_reviews.value.required_approving_review_count
      restrict_dismissals             = required_pull_request_reviews.value.restrict_dismissals
    }
  }

  dynamic "required_status_checks" {
    for_each = each.value.required_status_checks == null ? [] : [each.value.required_status_checks]

    content {
      contexts = required_status_checks.value.contexts
      strict   = required_status_checks.value.strict
    }
  }
}

## ========================================================================== ##
## ========================================================================== ##
locals {
  teams = defaults(var.teams, var.team_defaults)
}

resource "github_team" "named" {
  for_each = local.teams

  name = each.key

  create_default_maintainer = each.value.create_default_maintainer
  description               = each.value.description
  privacy                   = each.value.privacy

  ## NOTE: Support for parent team pending outcome of https://git.io/JWgNI
  ## parent_team_id = each.value.parent_team
}

resource "github_team_membership" "for" {
  for_each = merge([
    for teamName, teamCfg in local.teams : merge(
      { for userName, userCfg in teamCfg.people : "${teamName}:${userName}" => {
        role = userCfg.role
        team = github_team.named[teamName].id
        user = userName
      } },
    )
  ]...)

  role     = each.value.role
  team_id  = each.value.team
  username = each.value.user
}

resource "github_team_repository" "for" {
  for_each = merge([
    for teamName, teamCfg in local.teams : merge(
      { for repoName, repoCfg in local.repositories : "${teamName}:${repoName}" => {
        perm = teamCfg.permissions
        repo = github_repository.named[repoName].name
        team = github_team.named[teamName].id
      } },
    )
  ]...)

  permission = each.value.perm
  repository = each.value.repo
  team_id    = each.value.team
}
