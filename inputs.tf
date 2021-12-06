## ========================================================================== ##
## ========================================================================== ##
variable "repository_defaults" {
  default = {
    archive_on_destroy     = true,
    delete_branch_on_merge = true,
  }
}

variable "repositories" {
  default = {}
  type = map(object({
    description            = optional(string)
    gitignore_template     = optional(string)
    license_template       = optional(string)
    topics                 = optional(set(string))
    visibility             = optional(string)
    allow_merge_commit     = optional(bool)
    allow_rebase_merge     = optional(bool)
    allow_squash_merge     = optional(bool)
    archive_on_destroy     = optional(bool)
    auto_init              = optional(bool)
    delete_branch_on_merge = optional(bool)
    has_issues             = optional(bool)
    has_projects           = optional(bool)
    has_wiki               = optional(bool)
    homepage_url           = optional(string)
    is_template            = optional(bool)
    vulnerability_alerts   = optional(bool)

    protections = optional(list(object({
      pattern                 = string
      allows_deletions        = optional(bool)
      allows_force_pushes     = optional(bool)
      enforce_admins          = optional(bool)
      push_restrictions       = optional(set(string))
      require_signed_commits  = optional(bool)
      required_linear_history = optional(bool)

      required_pull_request_reviews = optional(object({
        dismiss_stale_reviews           = optional(bool)
        dismissal_restrictions          = optional(set(number))
        require_code_owner_reviews      = optional(bool)
        required_approving_review_count = optional(number)
        restrict_dismissals             = optional(bool)
      }))
      required_status_checks = optional(object({
        contexts = optional(set(string))
        strict   = optional(bool)
      }))
    })))

    template = optional(object({
      owner      = string
      repository = string
    }))
  }))
}

## ========================================================================== ##
## ========================================================================== ##
variable "team_defaults" {
  default = {
    create_default_maintainer = false,
    description               = "Managed by Terraform",
    people = {
      role = "member"
    },
    permissions = "pull",
    privacy     = "closed"
  }
}

variable "teams" {
  default = {}
  type = map(object({
    people = map(object({
      email = string,
      role  = optional(string),
    }))

    create_default_maintainer = optional(bool),
    description               = optional(string),
    privacy                   = optional(string),
    permissions               = optional(string),
  }))
}
