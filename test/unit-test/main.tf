locals {
  repo_settings = {
    archive_on_destroy     = false,
    delete_branch_on_merge = true,
    visibility             = "public",

    protections = [{
      pattern                = "main",
      allows_deletions       = false,
      allows_force_pushes    = false,
      enforce_admins         = true,
      require_signed_commits = true,
      required_pull_request_reviews = {
        dismiss_stale_reviews           = true,
        require_code_owner_reviews      = true,
        required_approving_review_count = 1,
        restrict_dismissals             = true,
      },
      required_status_checks = {
        strict = true,
      },
    }],
  }

  team_settings = {
    create_default_maintainer = false
    description               = "Managed by Terraform",
    privacy                   = "closed"
  }
}

module "terraform-github-test" {
  source = "../../"

  repositories = {
    "terraform-github-test-repo-alpha" = local.repo_settings
    "terraform-github-test-repo-delta" = local.repo_settings
  }
  teams = {
    "terraform-github-test-team-admin" = merge(local.team_settings, {
      people = {
        "jrmash" = { email = "2574997+jrmash@users.noreply.github.com", role = "maintainer" },
      },
      permissions = "admin",
    })
    "terraform-github-test-team-pull" = merge(local.team_settings, {
      people = {
        "jrmash-qa" = { email = "76767818+jrmash-qa@users.noreply.github.com", role = "maintainer" },
      },
      permissions = "pull",
    })
  }
}