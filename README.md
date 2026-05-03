# sabr

A finance app for the people you share life with.

Once again, my boyfriend made me name this app after him. Send help.

# Repo Structure

The [app](app) directory contains the code for the mobile application, while the [supabase](supabase) directory contains all of the backend code (deployed on [supabase](https://supabase.com/)). All infrastructure is setup with Terraform in the [infra](infra) directory.

# Local setup (macOS, Homebrew)

Run

```bash
brew install pre-commit terraform tflint jq
```

Install Node and pnpm for the app ([see the app README](app/README.md)), then from `app/` run `pnpm install`. This registers the Git hooks. Then, from the **repo root**, run:

```bash
pre-commit install-hooks
```

On `git commit`, hooks run lint-staged & typecheck in `app/`, then `pre-commit run`.
