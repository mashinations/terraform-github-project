terraform {
  experiments = [module_variable_optional_attrs]
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 4.21.0"
    }
  }
  required_version = "~> 1.0"
}
