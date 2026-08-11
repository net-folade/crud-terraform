# The tflint job in CI installed no rulesets before this file existed, so it only
# ever ran tflint's built-in syntax checks. These plugins are what make it a real lint.

config {
  # Modules are linted directly by --recursive, so there is no need to follow
  # module calls from the env roots and lint the same files twice.
  call_module_type = "none"
}

plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

plugin "aws" {
  enabled = true
  version = "0.48.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}
