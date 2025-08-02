# Main entry point for the VPC infrastructure
# All resources are organized in separate files:
# - networking.tf: VPC, subnets, routing, NAT gateways
# - security.tf: Security groups
# - monitoring.tf: VPC Flow Logs and CloudWatch
# - endpoints.tf: VPC endpoints for cost optimization
# - data.tf: Data sources
# - variable.tf: Input variables
# - provider.tf: Provider configuration
# - output.tf: Output values

# =============================================================================
# ADDITIONAL RESOURCES FOR FURTHER CUSTOMIZATION
# =============================================================================

# SECURITY & COMPLIANCE
# - aws_network_acl: Subnet-level firewall rules
# - aws_network_acl_rule: Individual ACL rules
# - aws_config_configuration_recorder: Compliance monitoring
# - aws_guardduty_detector: Threat detection
# - aws_securityhub_account: Centralized security findings

# CONNECTIVITY
# - aws_vpn_gateway: On-premises VPN connectivity
# - aws_customer_gateway: VPN endpoint configuration
# - aws_vpn_connection: Site-to-site VPN tunnel
# - aws_ec2_transit_gateway: Multi-VPC connectivity hub
# - aws_ec2_transit_gateway_vpc_attachment: VPC connections to TGW
# - aws_dx_gateway: Direct Connect gateway
# - aws_vpc_peering_connection: VPC-to-VPC connectivity

# DNS & SERVICE DISCOVERY
# - aws_route53_zone: Private hosted zone for internal DNS
# - aws_route53_resolver_rule: DNS forwarding rules
# - aws_service_discovery_private_dns_namespace: ECS/EKS service discovery

# ADDITIONAL VPC ENDPOINTS
# - aws_vpc_endpoint (ECR): Container registry access
# - aws_vpc_endpoint (SSM): Systems Manager access
# - aws_vpc_endpoint (Secrets Manager): Secrets access
# - aws_vpc_endpoint (KMS): Key management access
# - aws_vpc_endpoint (CloudWatch Logs): Logging access
# - aws_vpc_endpoint (STS): Security token service access

# LOAD BALANCING
# - aws_lb: Application/Network Load Balancer
# - aws_lb_target_group: Load balancer targets
# - aws_lb_listener: Traffic routing rules
# - aws_lb_listener_rule: Advanced routing conditions

# AUTO SCALING & COMPUTE
# - aws_launch_template: EC2 instance templates
# - aws_autoscaling_group: Dynamic instance scaling
# - aws_ecs_cluster: Container orchestration
# - aws_eks_cluster: Kubernetes cluster
# - aws_eks_node_group: EKS worker nodes

# DATABASE & STORAGE
# - aws_db_subnet_group: RDS subnet configuration
# - aws_db_instance: RDS database instances
# - aws_elasticache_subnet_group: Redis/Memcached subnets
# - aws_elasticache_cluster: In-memory caching
# - aws_efs_file_system: Shared file system
# - aws_efs_mount_target: EFS access points

# MONITORING & ALERTING
# - aws_cloudwatch_metric_alarm: Metric-based alerts
# - aws_sns_topic: Notification system
# - aws_lambda_function: Event-driven compute
# - aws_cloudwatch_event_rule: Event routing
# - aws_cloudwatch_dashboard: Custom monitoring dashboards

# WAF & DDOS PROTECTION
# - aws_wafv2_web_acl: Web application firewall
# - aws_shield_protection: DDoS protection
# - aws_wafv2_rate_based_rule: Traffic throttling

# COST OPTIMIZATION
# - aws_spot_fleet_request: Cost-effective compute
# - aws_ec2_capacity_reservation: Reserved capacity
# - aws_savingsplans_plan: Compute cost reduction

# BACKUP & DISASTER RECOVERY
# - aws_backup_vault: Centralized backup storage
# - aws_backup_plan: Automated backup schedules
# - aws_backup_selection: Resource backup selection

# CONTAINER SERVICES
# - aws_ecs_service: ECS service definitions
# - aws_ecs_task_definition: Container task specifications
# - aws_ecr_repository: Container image registry

# SERVERLESS
# - aws_api_gateway_rest_api: REST API gateway
# - aws_lambda_function: Serverless functions
# - aws_dynamodb_table: NoSQL database tables

# IDENTITY & ACCESS
# - aws_iam_role: Service roles
# - aws_iam_policy: Custom policies
# - aws_iam_instance_profile: EC2 instance roles

# SECRETS MANAGEMENT
# - aws_secretsmanager_secret: Application secrets
# - aws_kms_key: Encryption keys
# - aws_ssm_parameter: Configuration parameters