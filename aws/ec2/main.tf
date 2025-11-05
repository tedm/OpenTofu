// this OpenTofu main.tf will create a small ec2 instance into aws, with a public ip, and the nginx web server. 
// You will need to supply an aws keypair below (search for mykeypair)
// before this will run, and have the aws cli installed for your system

// the docs for aws cli install are here: 
// https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

// You may prefer to keep the state on your local system, rather than setting up a remote state S3 bucket and
// dynamo DB table while learning, so you can comment out the backend block if you decide to use local state

// before the website will open, ensure that the Security Group for the ec2 instance has opened port 80 
// (and port 22 if you wish to ssh to it) to your public IP (use whatismyip.com to find). This can be programmed
// easily in OpenTofu for future sessions.

// Be sure to $tofu destroy when you are done, so the instance does not incur fees after your testing

terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.76.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.3"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.6"
    }
  }

// comment this block out, if you prefer to keep the state on local system rather than backend storage
  backend "s3" {
    bucket         = "ted-terraform-tfstate"
    key            = "state/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "ted-tf-lockid"
  }

  required_version = "~> 1.3"
}

# above could go in a terraform.tf file

provider "aws" {
  region = "us-west-2"
}

# above could go in a providers.tf file, and region could be set to var.region, with var.region defined in a variables.tf file, 
# or <environment>.tfvars file, and passed with $terraform apply --var-file=<environment>.tfvars

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "myec2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3a.nano"
  key_name      = "seagl2025" # use aws_key_pair if adding new pub key
  user_data     = <<EOF
#!/bin/bash 
apt-get update -y
apt-get install nginx -y
nginx -v
systemctl start nginx
systemctl enable nginx
chmod 2775 /usr/share/nginx/html 
find /usr/share/nginx/html -type d -exec chmod 2775 {} \;
find /usr/share/nginx/html -type f -exec chmod 0664 {} \;
echo "<h1> Welcome to the SeaGL 2025! Be sure to run tofu destroy when done</h1>" > /var/www/html/index.nginx-debian.html
EOF

  tags = {
    Name = "testubuntuec2"
  }
}


# below should go in an outputs.tf file

output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.myec2.id
}

output "instance_public_ip" {
  description = "EC2 Instance Public IP"
  value       = aws_instance.myec2.public_ip
}
