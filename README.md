# Terraform Landing Zone for MongoDB Atlas on Azure

> [!IMPORTANT]
> The Terraform Landing Zone for MongoDB Atlas on Azure assumes that you already successfully implemented an Azure landing zone. However, you can use the Terraform Landing Zone for MongoDB Atlas on Azure if your infrastructure doesn't conform to Azure landing zones. For more information, refer to [Cloud Adoption Framework enterprise-scale landing zones](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/enterprise-scale/)
>
> We recommend evaluating whether additional Microsoft security services beyond those listed, e.g Azure Firewall, Defender for DDoS, Defender for Cloud, Microsoft Entra, and Azure Key Vault - are appropriate for your environment. Depending on your architecture and threat model, you may also want to consider among other options:
>
> - [Azure Web Application Firewall (WAF)](https://learn.microsoft.com/en-us/azure/web-application-firewall/overview)
> - [Defender for App Service](https://learn.microsoft.com/en-us/azure/defender-for-cloud/defender-for-app-service-introduction)
> - [Defender for Servers](https://learn.microsoft.com/en-us/azure/defender-for-cloud/defender-for-servers-overview)
> - [Microsoft Entra Global Secure Access (GSA)](https://learn.microsoft.com/en-us/entra/global-secure-access/overview-what-is-global-secure-access)

## Overview

This repository provides a modular Terraform solution for deploying a secure MongoDB Atlas environment on Azure, featuring:

- Private networking and secure connectivity
- DevOps automation for remote state and identity
- End-to-end cluster setup for MongoDB Atlas
- Observability and monitoring infrastructure, including Azure Application Insights and a Metrics Function App for centralized metrics collection
- Automation for provisioning infrastructure, configuring Atlas clusters, and deploying a test application for connectivity validation

It supports both **single-region** and **multi-region** deployments.

The infrastructure can be deployed using the provided GitHub Actions workflows for CI/CD automation (see the [Pipeline Deployment Guide](docs/wiki/Deploy-with-pipeline.md)) or manually with Terraform (see the [Manual Deployment Steps](docs/wiki/Deploy-with-manual-steps.md)). The recommended method is deployment via workflows to ensure full automation, while manual deployment through the CLI remains available as an alternative.

> For step-by-step deployment guidance, see the [deployment guide](docs/wiki/Home.md).

---

## Module Overview

For module-specific details, refer to [Modules.md](./docs/wiki/Modules.md):

- [Application](./modules/application/readme.md): App Service Plan, Web App, and VNet integration.
- [DevOps](./modules/devops/readme.md): Remote state, identity, and automation.
- [MongoDB Atlas Config Single Region](./modules/atlas_config_single_region/readme.md): Atlas project, cluster, and PrivateLink.
- [MongoDB Atlas Config Multi Region](./modules/atlas_config_multi_region/readme.md): Atlas project, cluster, and PrivateLink.
- [MongoDB Marketplace](./modules/mongodb_marketplace/readme.md): Atlas org deployment via Azure Marketplace.
- [Network](./modules/network/readme.md): VNet, subnets, NAT, NSG, and private endpoints.
- [VNet Peering](./modules/vnet_peering/readme.md): Virtual network peering for multi-region connectivity.
- [Observability](./modules/observability/readme.md): Application Insights, and supporting resources for monitoring and metrics collection.

---

## Disclaimer

> **Warning:** Deploying this infrastructure is **NOT free**.
> It provisions paid resources such as a dedicated MongoDB Atlas cluster (minimum M10 tier for Private Endpoints), Azure networking components, and other Azure services. Review pricing details in the [MongoDB Atlas Private Endpoint documentation](https://www.mongodb.com/docs/atlas/security-private-endpoint/) before running `terraform apply`.

This code is provided for demonstration purposes and should not be used in production without thorough testing.
You are responsible for validating the configuration and ensuring it meets your environment's requirements.

For questions or to discuss suitability for your use case, please create an issue in this repository.

By using this repository, you agree to assume all risks and use it at your own discretion. Microsoft and the authors are not liable for damages or losses from its use.
See the [Support section](./SUPPORT.md) for details.

---

## Wiki

Please see the content in the [wiki](docs/wiki/Home.md) for more detailed information about the repo and various other pieces of documentation.

---

## Known Issues

See the [Known Issues page](docs/wiki/KnownIssues.md) for the latest list of limitations, workarounds, and open problems.

---

## Frequently Asked Questions

See the [FAQ](docs/wiki/FAQ.md) for common questions and answers.

---

## Contributing

This project welcomes contributions and suggestions.
Before contributing, you will need to sign the [Microsoft Contributor License Agreement (CLA)](https://cla.opensource.microsoft.com).

Pull requests will be checked automatically by the CLA bot to determine if a CLA is required. Follow its instructions as needed.

We follow the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information, see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or email [opencode@microsoft.com](mailto:opencode@microsoft.com).

> Contribution details can be found in the [wiki](docs/wiki/Contributing.md).

---

## Trademarks

This project may contain trademarks or logos for projects, products, or services.
Authorized use of Microsoft trademarks or logos is subject to and must follow the [Microsoft Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general).
Any use of third-party trademarks or logos is subject to those third parties’ policies.
