# OpenTelekomCloud Elastic Load Balancer Terraform Module

[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md)
[![Notice](https://img.shields.io/badge/notice-copyright-blue.svg)](NOTICE)
[![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE)
[![OpenTofu Registry](https://img.shields.io/badge/opentofu-registry-yellow.svg)](https://search.opentofu.org/module/CloudAstro/elb/opentelekomcloud/)

This module is designed to manage **Elastic Load Balancers (ELB)** within OpenTelekomCloud (OTC). It enables flexible configuration options for ELB creation, including listener rules, backend pool setup, health checks, and custom tags for better organization.

## Features

- **Elastic Load Balancer Management**: Automates the creation and management of Elastic Load Balancers within OpenTelekomCloud.
- **Listener Configuration**: Supports the configuration of multiple listeners (HTTP, HTTPS, TCP, etc.) for flexible traffic routing.
- **Backend Pool Management**: Allows the assignment and management of backend servers and server groups.
- **Health Checks**: Enables customizable health checks for backend servers to ensure high availability and resilience.
- **Flexible Network Options**: Supports integration with custom subnets, security groups, and availability zones.

# Setup Requirements

To successfully apply the module, make sure to source the required variables either through the `.envrc` file or use `direnv` to automatically load environment variables for configuration. This step is crucial for proper execution of the module.

You can also use AK/SK authentication (`OS_ACCESS_KEY` and `OS_SECRET_KEY`) as an alternative to `OS_PASSWORD` and `OS_USERNAME` for accessing OpenTelekomCloud.

Ensure the following variables are set up correctly in your `.envrc` file for authentication:

```shell
export OS_USERNAME="USERNAME"
export OS_PASSWORD="PASSWORD"
export OS_DOMAIN_NAME="OTC000xxxx"
export OS_PROJECT_NAME="eu-de_project-name"
export OS_REGION="eu-de"
```

Once the .envrc file is set up, you can source it in your shell by running the following command:

```shell
source .envrc
```

# Example Usage

This example demonstrates how to provision a subnet across multiple availability zones with CIDR block configurations and custom timeouts:
