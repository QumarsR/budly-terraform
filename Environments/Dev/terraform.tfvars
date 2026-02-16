# contains the actual values used during deployment
aws_region           = "us-west-1"
vpc_cidr             = "172.31.0.0/16"
public_subnet_cidrs  = ["172.31.16.0/20", "172.31.32.0/20"]
private_subnet_cidrs = ["172.31.48.0/20", "172.31.64.0/20"]
availability_zones   = ["us-west-1a", "us-west-1c"]
db_host              = "test_db_host"
