resource "aws_vpc" "vpc8" {
    cidr_block = "192.168.0.0/16"
    instance_tenancy = "default"
    enable_dns_hostnames = "true"
    enable_dns_support = "true"
    tags = {
      Name ="terra-vpc"
      env = "dev"
      created = "momo"
    }
}


resource "aws_internet_gateway" "loi" {
    vpc_id = aws_vpc.vpc8.id
  
}
#### public subnet 

resource "aws_subnet" "public1" {
    availability_zone = "us-east-1a"
    cidr_block = "192.168.1.0/24"
    vpc_id = aws_vpc.vpc8.id
     map_public_ip_on_launch = true
    tags = {
      Name = "public1"
      env= "dev"
    }
  
}   


resource "aws_subnet" "public2" {
    availability_zone = "us-east-1b"
    cidr_block = "192.168.2.0/24"
    vpc_id = aws_vpc.vpc8.id
   map_public_ip_on_launch = true
    tags = {
      Name = "public2"
      env= "dev"
    }
  
}

resource "aws_subnet" "private1" {
    availability_zone = "us-east-1a"
    cidr_block = "192.168.3.0/24"
    vpc_id = aws_vpc.vpc8.id
    tags = {
      Name = "private1"
      env= "dev"
    }
  
}

resource "aws_subnet" "private2" {
    availability_zone = "us-east-1b"
    cidr_block = "192.168.4.0/24"
    vpc_id = aws_vpc.vpc8.id
    tags = {
      Name = "private2"
      env= "dev"
    }
  
} 

resource "aws_eip" "eip" {
  
}

resource "aws_nat_gateway" "nate1" {
    allocation_id =  aws_eip.eip.id
  subnet_id = aws_subnet.public1.id
}


###### public route 

resource "aws_route_table" "public1" {
    vpc_id = aws_vpc.vpc8.id
    route {
       cidr_block = "0.0.0.0/0" 
       gateway_id = aws_internet_gateway.loi.id
    }
  
}

resource "aws_route_table" "private" {
    vpc_id = aws_vpc.vpc8.id
    route {
       cidr_block = "0.0.0.0/0" 
       gateway_id = aws_nat_gateway.nate1.id
    }
}


resource "aws_route_table_association" "rtable1" { 
    subnet_id = aws_subnet.private1.id
    route_table_id = aws_route_table.private.id
  
}

resource "aws_route_table_association" "rtable2" { 
    subnet_id = aws_subnet.private2.id
    route_table_id = aws_route_table.private.id
  
}

resource "aws_route_table_association" "rtable3" { 
    subnet_id = aws_subnet.public1.id
    route_table_id = aws_route_table.public1.id
  
}

resource "aws_route_table_association" "rtable4" { 
    subnet_id = aws_subnet.public2.id
    route_table_id = aws_route_table.public1.id
  
}