# Data source to fetch available Availability Zones in the region
# State is set to "available" to only return AZs that are currently available
data "aws_availability_zones" "available" {
  state = "available"
}
