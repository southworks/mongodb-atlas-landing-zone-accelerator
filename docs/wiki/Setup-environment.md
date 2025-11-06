# Environment Setup

This document describes the required environment variables, prerequisites, and setup steps for running Terraform and automation pipelines.

---

## Table of Contents

- [Variable Overview](#variable-overview)
- [Setting Environment Variables Locally](#setting-environment-variables-locally)
- [Pipeline / CI Setup](#pipeline--ci-setup)
- [Terraform version](#terraform-version)
- [Additional Notes](#additional-notes)

---

## Variable Overview

| Variable                        | When to Set                                      | Purpose                                       |
|----------------------------------|--------------------------------------------------|-----------------------------------------------|
| `ARM_SUBSCRIPTION_ID`            | Before any step (including step 00-devops)        | Azure subscription for all resources          |
| `MONGODB_ATLAS_PUBLIC_API_KEY`   | After creating Atlas org (after step 00-devops)   | MongoDB Atlas API access (from step 01 onward)|
| `MONGODB_ATLAS_PRIVATE_API_KEY`  | After creating Atlas org (after step 00-devops)   | MongoDB Atlas API access (from step 01 onward)|

---

## Setting Environment Variables Locally

Set the required variables in your terminal session before running Terraform or automation scripts.

### macOS/Linux or Bash on Windows

```bash
export ARM_SUBSCRIPTION_ID="<your-subscription-id>"
# After step 00-devops:
export MONGODB_ATLAS_PUBLIC_API_KEY="<ATLAS_PUBLIC_KEY>"
export MONGODB_ATLAS_PRIVATE_API_KEY="<ATLAS_PRIVATE_KEY>"
```

### Windows (Command Prompt)

```bat
set ARM_SUBSCRIPTION_ID=<your-subscription-id>
:: After step 00-devops:
set MONGODB_ATLAS_PUBLIC_API_KEY=<ATLAS_PUBLIC_KEY>
set MONGODB_ATLAS_PRIVATE_API_KEY=<ATLAS_PRIVATE_KEY>
```

### Windows (PowerShell)

```powershell
$env:ARM_SUBSCRIPTION_ID = "<your-subscription-id>"
# After step 00-devops:
$env:MONGODB_ATLAS_PUBLIC_API_KEY = "<ATLAS_PUBLIC_KEY>"
$env:MONGODB_ATLAS_PRIVATE_API_KEY = "<ATLAS_PRIVATE_KEY>"
```

## Terraform variables

For local development, each template provides a `local.tfvars.template` file with the required variables.
To configure variables for your environment:

1. Copy the template in the same directory and rename it to `local.tfvars`.
2. Edit `local.tfvars` and update the values to match your environment.

These `local.tfvars` files will be used when deploying with manual steps.

> Do not commit your `local.tfvars` files. They are intended for local use only and are excluded via `.gitignore`.

---

## Pipeline / CI Setup

### GitHub Environment Requirements

You must create a GitHub environment named `dev` in your repository settings. See the [Creating a GitHub Environment](https://docs.github.com/en/actions/how-tos/deploy/configure-and-manage-deployments/manage-environments#creating-an-environment) documentation for instructions.

In this environment, set the following:

- **Secrets:**
  - `MONGODB_ATLAS_PUBLIC_API_KEY` (Atlas public API key, [see MongoDB docs](https://www.mongodb.com/docs/atlas/configure-api-access-org/) for API key creation guidance)
  - `MONGODB_ATLAS_PRIVATE_API_KEY` (Atlas private API key, [see MongoDB docs](https://www.mongodb.com/docs/atlas/configure-api-access-org/) for API key creation guidance)
  - `TF_VAR_mongo_atlas_client_id` (Atlas client ID, to generate this value, please follow the [Mongo Atlas Metrics guide](./MongoAtlasMetrics_deployment_steps.md))
  - `TF_VAR_mongo_atlas_client_secret` (Atlas client secret, to generate this value, please follow the [Mongo Atlas Metrics guide](./MongoAtlasMetrics_deployment_steps.md))
  - `TF_VAR_org_id` (Atlas org ID)
- **Variables:**
  - `ARM_CLIENT_ID` (Managed identity's Client Id)
  - `ARM_SUBSCRIPTION_ID` (The subscription Id where the resources will be created)
  - `ARM_TENANT_ID` (The tenant Id of the subscription where the resources will be created)
  - `TF_VAR_project_name` (Atlas project name)
  - `TF_VAR_cluster_name` (Atlas cluster name)
  - `TF_VAR_resource_group_name_tfstate` (Name of Resource Group for TF state)
  - `TF_VAR_storage_account_name_tfstate` (Name of Storage Account for TF state)
  - `TF_VAR_container_name_tfstate` (Name of Container for TF state)
  - `TF_VAR_key_name_tfstate` (Name of devops' TF state key)
  - `FUNCTION_APP_NAME` (Name of the Function App created in Infrastructure step for the Mongo Atlas Metrics)
  - `INFRA_RG_NAME` (Name of the Resource Group created for the Infrastructure resources)

  #### The variable below is optional, just in case you want to deploy the test db connection app

  - `TF_VAR_key_name_infra_tfstate` (Name of Key for Infra's TF state)
  - `APP_RG_NAME` (Name of the Resource Group created for the Application step resources)
  - `APP_WEBAPPS` (Comma-separated string value of Web App names. Use a single name for single-region deployments, and multiple names for multi-region deployments. This value can only be set after running the Application step, where the Web Apps are deployed.)

- **Important:**
  - You will find the org id in the organization's settings as shown below:
  ![org_id](../images/org_id.png)

---

## Terraform version

Terraform version is pinned in `.terraform-version`:

- Local: install [`tfenv`](https://github.com/tfutils/tfenv) or [`asdf`](https://asdf-vm.com/) for automatic switching.
- Pipelines: read `.terraform-version` dynamically.

To upgrade:

1. Update `.terraform-version`
2. Update `terraform.tf` _required_version_ for modules and templates
3. Pipelines and local envs will automatically use the new version.

---

## Additional Notes

- Each environment (`dev`, `test`, `prod`, etc.) should have its own folder under `envs/` inside the respective single-region or multi-region folder.
- Never hardcode sensitive values (such as API keys or subscription IDs) directly in code or version control.

---
