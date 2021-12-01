terraform {
  experiments      = [module_variable_optional_attrs]
  required_providers {
    github = {
      source = "integrations/github"
      version = "~> 4.18.2"
    }
  }
  required_version = "~> 1.0"
}
