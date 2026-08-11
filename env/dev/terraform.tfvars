# Global Dev env values
project_id = "gcp-tf-proj"
region     = "asia-south1"


#network values , /24 for dev non overlapping subnets

network_name    = "three-tier-dev-vpc"
web_subnet_cidr = "10.0.1.0/24"
app_subnet_cidr = "10.0.2.0/24"
db_subnet_cidr  = "10.0.3.0/24"

# Nat and routing values
enable_cloud_nat = true
routing_mode     = "GLOBAL"

