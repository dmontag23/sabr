# HCP Terraform — Runbook

Sets up or recovers the HCP Terraform stack in `infra/hcp-terraform`.

The procedure has three phases:

1. Create org & bootstrap workspace in local state.
2. Connect GitHub App via the HCP Terraform UI.
3. Apply the rest of the state in HCP Terraform.

## Prerequisites

- [Terraform CLI installed locally](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- [HCP Terraform account](https://app.terraform.io/login)
- The `sabr` GitHub repository exists (this is needed because the `sabr-github` workspace connects to it via VCS).
- A GitHub personal access token (PAT) for the `sabr` repo with:
  - **Administration: Read and write**
  - **Secrets: Read and write**
  - **Environments: Read and write**

## Steps

### 1) Create the HCP Terraform account

Sign up at https://app.terraform.io and verify the email used. Do not create an organization - terraform will do that for you.

### 2) Authenticate the CLI

Run

```bash
terraform login
```

to create a user token in the HCP Terraform account. This token is used by the Terraform CLI for this stack.

Follow the browser prompts. This puts an API token in `~/.terraform.d/credentials.tfrc.json`.

### 3) Create provider tokens and local vars file

First, create a fine-grained personal access token (PAT) in GitHub:

1. Go to **Profile Picture → Settings → Developer settings → Personal access tokens → Fine-grained tokens**
2. Create token scoped to the `sabr` repository.
3. Grant repository permissions:
   - **Administration: Read and write**
   - **Secrets: Read and write**
   - **Environments: Read and write**
4. Copy the token value

In `infra/hcp-terraform`, create a `secrets.auto.tfvars` file. In that file, paste:

```hcl
github_token = "<your github token>"
```

Then, create a personal access token in Supabase:

1. Go **Dashboard → Account preferences → Access Tokens**
2. Generate a new token. The name does not matter. Keep the default 30 day expiry time.
3. Copy the token value for pasting into `secrets.auto.tfvars` (see below).

Next, create an API key in Resend:

1. Go to **API keys** in the Resend navbar.
2. Create an API key with **Full access** permissions. The name does not matter and leave the Domain field blank.
3. Copy the key value for pasting into `secrets.auto.tfvars` (see below).

In `secrets.auto.tfvars`, paste the values as:

```hcl
supabase_access_token    = "<token>"
supabase_organization_id = "<org_id>"
resend_api_key           = "<resend api key>"
production_required_reviewer_username = "<github prod approver username>"
```

`supabase_access_token` is shared by all Supabase workspaces and passed to the GitHub stack.
`supabase_organization_id` is the Supabase `org_...` id.

### 4) Create org & bootstrap workspace in local state

The HCP Terraform org doesn't exist yet, so the cloud backend can't be used yet.

Run

```bash
cd infra/hcp-terraform
rm -rf .terraform/
terraform init -backend=false
terraform apply \
 -target=tfe_organization.sabs_apps \
 -target=tfe_workspace.bootstrap \
 -target=tfe_workspace_settings.bootstrap
```

Terraform shows a `-target` warning. This is expected; the bootstrap flow is an exception to most terraform flows.

### 5) Migrate state to HCP Terraform

While still in the `hcp-terraform` directory, run

```bash
terraform init
```

Answer `yes` when prompted to move state. Then clean up local state files with

```bash
rm terraform.tfstate terraform.tfstate.backup
```

### 6) Connect the GitHub App

In the [HCP Terraform UI](https://app.terraform.io/login):

1. Click **User profile picture → Account settings → Tokens → Create a GitHub App token**
2. Follow the UI prompts to authenticate the GitHub App using your user. When finished, you should see a token in HCP Terraform that begins with `ghaot`.
3. Click **Choose an organization → sabs-apps → bootstrap → Settings → Version Control → Connect to version control → Version Control Workflow → GitHub App**
4. Authorize via the popup. Choose the repo that hosts this code. After authorizing, you should automatically be advanced to the next step in the flow.
5. Do NOT continue with the flow. Go back to **User profile picture → Account settings → Tokens**. You should see a GitHub App Installation Id. If so, GitHub App has been setup successfully.

You can also confirm the install succeeded by visiting https://github.com/settings/installations, which should now list "Terraform Cloud".

### 7) Apply the rest of the terraform stack

```bash
terraform apply
```

The `tfe_github_app_installation` data source will now resolve and all remaining resources create cleanly.
The apply generates an organization token for `sabs-apps` and injects it as:

- `TFE_TOKEN` in `sabr-github`
- `TFE_TOKEN` in the Supabase shared variable set (`sabr-supabase-shared-variables`)

### 8) Verify created workspaces

After `terraform apply`, confirm these HCP Terraform workspaces exist:

- `bootstrap`
- `sabr-github`
- `sabr-resend`
- `sabr-supabase-staging`
- `sabr-supabase-production`

Both Supabase workspaces should receive the following shared variables from `sabr-supabase-shared-variables`:

- `organization_id`
- `SUPABASE_ACCESS_TOKEN`
- `TFE_TOKEN`

Each Supabase workspace should also have its own `project_name` Terraform variable:

- staging: `sabr-staging`
- production: `sabr-production`

`sabr-github` should contain:

- the `GITHUB_TOKEN` environment variable
- the `TFE_TOKEN` environment variable
- the `supabase_access_token` terraform variable
- the `production_required_reviewer_username` terraform variable

`sabr-resend` should contain:

- the `RESEND_API_KEY` environment variable

Verify that the following run triggers exist:

- from `sabr-resend` to both Supabase workspaces
- from `sabr-resend` to `sabr-github`
- from both Supabase workspaces to `sabr-github`

## Disaster recovery notes

- After HCP recovery, re-run `terraform apply` in the following directories in this order:
  1. [infra/resend](/infra/resend/)
  2. [infra/supabase](/infra/supabase/)
  3. [infra/github](/infra/github/)
