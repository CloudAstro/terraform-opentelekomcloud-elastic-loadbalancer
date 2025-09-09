## 🌐 Additional Information  

This module provides a flexible and robust way to manage Elastic Load Balancers (ELB) within OpenTelekomCloud, supporting advanced load balancing features such as multi-protocol listeners, backend pool management, health checks, and resource tagging.  
It can be used for both standalone ELB deployments and as a scalable component within larger cloud architectures.

## 📚 Resources

- [Terraform OpenTelekomCloud ELB Resource](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/lb_loadbalancer_v2)  
- [OpenTelekomCloud Elastic Load Balancer Overview](https://docs.otc.t-systems.com/elastic-load-balancing/index.html)  
- [Terraform OpenTelekomCloud Provider](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs)  

## ⚠️ Notes  

- Ensure that the ELB type (internal/external) matches your network and security requirements.  
- Proper configuration of listeners and health checks is essential for high availability and performance.  
- Use tagging to simplify cost tracking and resource organization in your environment.  
- Check OpenTelekomCloud documentation for region-specific ELB limitations, quotas, and best practices.

## 🧾 License  

This module is released under the **Apache 2.0 License**. See the [LICENSE](./LICENSE) file for full details.
