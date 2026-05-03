# HCP Terraform — Runbook

Sets up HCP Terraform from scratch. The same procedure handles disaster recovery.

The procedure has three phases: (1) create the org and bootstrap workspace against local state, (2) install the GitHub App via the UI, (3) apply the rest of the state.

## Prerequisites

- [Terraform CLI installed locally](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- [HCP Terraform account](https://app.terraform.io/login)
- The `sabr` GitHub repository exists because the `sabr-github` workspace is VCS-connected to that repo. Create it if it does not exist.
- A GitHub fine-grained personal access token (PAT) for the `sabr` repo with **Administration: Read and write** permission.

## Steps

### 1. Create the HCP Terraform account

Sign up at https://app.terraform.io and verify the email used. Do not create an organization - terraform will do that for you.

### 2. Authenticate the CLI

Run

```bash
terraform login
```

to create a user token in the HCP Terraform account. This token will be used to apply all the [HCP Terraform resources](/infra/hcp-terraform).

Follow the browser prompts. This puts an API token in `~/.terraform.d/credentials.tfrc.json`.

### 3 Create provider tokens and local vars file

First, create a fine-grained personal access token (PAT) in GitHub:

1. Go to **Profile Picture → Settings → Developer settings → Personal access tokens → Fine-grained tokens**
2. Create token scoped to the `sabr` repository.
3. Grant repository permission **Administration: Read and write**
4. Copy the token value

In `infra/hcp-terraform`, create a `secrets.auto.tfvars` file. In that file, paste `github_token = "<token>"`.

Then, create a personal access token in Supabase:

1. Go **Dashboard → Account preferences → Access Tokens**
2. Generate a new token. The name does not matter. Keep the default 30 day expiry time.
3. Copy the token value

Paste that value in `secrets.auto.tfvars` as `sabr_supabase_prod_access_token = "<token>"`. Then get the organization id from the value after `org` in the supabase URL and paste that as `sabr_supabase_organization_id = <org id>`.

### 4. Create the org and bootstrap workspace using local state

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

### 5. Migrate state to HCP Terraform

While still in the `hcp-terraform` directory, run

```bash
terraform init
```

Answer `yes` when prompted to move state. Then clean up local state files with

```bash
rm terraform.tfstate terraform.tfstate.backup
```

### 6. Connect the GitHub App

In the [HCP Terraform UI](https://app.terraform.io/login):

1. Click **User profile picture → Account settings → Tokens → Create a GitHub App token**
2. Follow the UI prompts to authenticate the GitHub App using your user. When finished, you should see a token in HCP Terraform that begins with `ghaot`.
3. Click **Choose an organization → sabs-apps → bootstrap → Settings → Version Control → Connect to version control → Version Control Workflow → GitHub App**
4. Authorize via the popup. Choose the repo that hosts this code. After authorizing, you should automatically be advanced to the next step in the flow.
5. Do NOT continue with the flow. Go back to **User profile picture → Account settings → Tokens**. You should see a GitHub App Installation Id. If so, GitHub App has been setup successfully.

You can also confirm the install succeeded by visiting https://github.com/settings/installations, which should now list "Terraform Cloud".

### 7. Apply the rest of the terraform

```bash
terraform apply
```

The `tfe_github_app_installation` data source will now resolve and all remaining resources create cleanly.
