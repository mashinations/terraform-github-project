# terraform-github-project
[![license][license-badge]][license-link]
[![terraform][terraform-badge]][terraform-link]
[![provider-github][provider-github-badge]][provider-github-link]

A Terraform module for holistically managing large GitHub projectsin a single organization.

_**Attention:** This module makes use of experimental features introduced in [Terraform] v1.0.0 and contains temporary workarounds for shortcomings in those features. Until the experimental flag is removed from these features, this module will remain in an alpha state and may change dramatically from the current implementaiton._

### Features

- Create and manage repositories
  - Support for defining branch protections
- Create and manage teams
  - Support for managing member access
  - Support for managing repository permissions

### Getting Started
```hcl
module "project" {
  source = "github.com/mashinations/terraform-github-project"

  repositories = {
    "example-repository" = {
      ## Configuration arguments for 'github_repository'

      protections = [
        { ## Configuration arguments for 'github_branch_protection' },
        { ## Configuration arguments for 'github_branch_protection' },
      ]
    }
  }

  teams = {
    "example-team" = {
      ## Configuration arguments for 'github_team', except 'parent_team_id'

      people = {
        ## Configuration arguments for 'github_team_membership'
      }

      ## Configuration arguments for 'github_team_repository', exxcept for
      ## 'repository' and 'team_id'.
    }
  }
}
```


<!-- References -->

[license-badge]: https://img.shields.io/badge/license-Apache%202.0-E4682A?logo=apache&style=for-the-badge
[license-link]: https://opensource.org/licenses/Apache-2.0
[provider-github-badge]: https://img.shields.io/badge/GH-4.21+-4078c0?logo=github&style=for-the-badge
[provider-github-link]: https://registry.terraform.io/providers/integrations/github/latest
[terraform-badge]: https://img.shields.io/badge/terraform-1.x-844FBA.svg?logo=terraform&style=for-the-badge
[terraform-link]: https://github.com/hashicorp/terraform/releases
