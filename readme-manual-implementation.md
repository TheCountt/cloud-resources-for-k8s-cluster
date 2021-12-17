## Step 0 - install client tools before bootstrapping the cluster

First, you will need some client tools installed and configurations made on your client workstation:

- **awscli** – is a unified tool to manage your AWS services.
On your local workstation download and install [the latest version of AWS CLI](https://aws.amazon.com/cli/). To configure your AWS CLI, click [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html)

- **kubectl** – this command line utility will be your main control tool to manage your K8s cluster. To install kubectl, click [here](https://kubernetes.io/docs/tasks/tools/)

- **cfssl** – an open source toolkit for everything TLS/SSL from Cloudflare

- **cfssljson** – a program, which takes the JSON output from the cfssl and writes certificates, keys, CSRs, and bundles to disk.

***Installing cfssl and cfssljson on Linux***
```
wget -q --show-progress --https-only --timestamping \
https://storage.googleapis.com/kubernetes-the-hard-way/cfssl/1.4.1/linux/cfssl \

https://storage.googleapis.com/kubernetes-the-hard-way/cfssl/1.4.1/linux/cfssljson

chmod +x cfssl cfssljson

sudo mv cfssl cfssljson /usr/local/bin/
```
## Step 1- cloud resources for kubernetess cluster
We need some machines to run the control plane and the worker nodes. You will provision EC2 Instances required to run your K8s cluster. 

 ### A.  Configure Network Infrastructure ###

**Virtual Private Cloud – VPC**

- Create a directory named `k8s-cluster-from-ground-up`

- Create a VPC and store the ID as a variable:


```
VPC_ID=$(aws ec2 create-vpc \
--cidr-block 172.31.0.0/16 \
--output text --query 'Vpc.VpcId'
)
```
- To store the ID as a variable, we'll store in a temporary variable file. 

    - Run command below to get the value of VPC_ID
    ```
    echo ${VPC_ID}
    ```

    - Run the command below to open file /etc/environment
    ```
    sudo vi /etc/environment
    ```
    - Input the value below
    ```
    VPC_ID=<value>
    ```
    - Make sure the the variable file is executable, if not run command below
    ```
    chmod +x /etc/environment
    ```
    - Run command below to read and execute the content of the file
    ```
    source /etc/environment
    ```

- Tag the VPC so that it is named `k8s-cluster-from-ground-up`. To make this easier, store in a temporary variable. 

    - Run the command below to open file /etc/environment
    ```
    sudo vi /etc/environment
    ```
    - Input the tag below
    ```
    NAME=k8s-cluster-from-ground-up
    ```
    - Now run aws cli command to tag the VPC
    ```
    aws ec2 create-tags \
  --resources ${VPC_ID} \
  --tags Key=Name,Value=${NAME}
  ```
**Domain Name System – DNS**

- Enable DNS support for your VPC
```
aws ec2 modify-vpc-attribute \
--vpc-id ${VPC_ID} \
--enable-dns-support '{"Value": true}'
```
- Enable DNS support for hostnames
```
aws ec2 modify-vpc-attribute \
--vpc-id ${VPC_ID} \
--enable-dns-hostnames '{"Value": true}'
```
**AWS Region**
- Open the variable file `/etc/environment` and paste the variable below, then save and close the file:
```
AWS_REGION=<name_of_region>
```
**Dynamic Host Configuration Protocol – DHCP**

- Configure DHCP Options Set

Dynamic Host Configuration Protocol (DHCP) is a network management protocol used on Internet Protocol networks for automatically assigning IP addresses and other communication parameters to devices connected to the network using a client–server architecture.

AWS automatically creates and associates a DHCP option set for your Amazon VPC upon creation and sets two options:          

    - domain-name-servers (defaults to AmazonProvidedDNS)
    
    - domain-name (defaults to the domain name for your set region). AmazonProvidedDNS is an Amazon Domain Name System (DNS) server, and this option enables DNS for instances to communicate using DNS names.

By default EC2 instances have fully qualified names like *ip-172-50-197-106.eu-central-1.compute.internal.* But you can set your own configuration using an example below:

```
DHCP_OPTION_SET_ID=$(aws ec2 create-dhcp-options \
  --dhcp-configuration \
    "Key=domain-name,Values=$AWS_REGION.compute.internal" \
    "Key=domain-name-servers,Values=AmazonProvidedDNS" \
  --output text --query 'DhcpOptions.DhcpOptionsId')
```
- Tag the DHCP Option set:
```
aws ec2 create-tags \
  --resources ${DHCP_OPTION_SET_ID} \
  --tags Key=Name,Value=${NAME}
  ```
- Open the variable file `/etc/environment` and paste the value of DHCP_OPTION_SET_ID(run the command `echo $DHCP_OPTION_SET_ID` to get its value). Then save and close.

```
DHCP_OPTION_SET_ID=<value of DHCP_OPTION_SET_ID>
```
- Associate the DHCP Option set with the VPC:

```
aws ec2 associate-dhcp-options \
  --dhcp-options-id ${DHCP_OPTION_SET_ID} \
  --vpc-id ${VPC_ID}
```

**Subnet**

- Create the Subnet:

```
SUBNET_ID=$(aws ec2 create-subnet \
  --vpc-id ${VPC_ID} \
  --cidr-block 172.31.0.0/24 \
  --output text --query 'Subnet.SubnetId')
```
- Input the variable into the variable file, `/etc/environment`
```
SUBNET_ID=<subnet_cidr>
```

- Tag it
```
aws ec2 create-tags \
  --resources ${SUBNET_ID} \
  --tags Key=Name,Value=${NAME}
```

**Internet Gateway – IGW**

- Create the Internet Gateway and attach it to the VPC:
```
INTERNET_GATEWAY_ID=$(aws ec2 create-internet-gateway \
  --output text --query 'InternetGateway.InternetGatewayId')
```
```
aws ec2 create-tags \
  --resources ${INTERNET_GATEWAY_ID} \
  --tags Key=Name,Value=${NAME}
```
```
aws ec2 attach-internet-gateway \
  --internet-gateway-id ${INTERNET_GATEWAY_ID} \
  --vpc-id ${VPC_ID}
```
- Input the value of `INTERNET_GATEWAY_ID` into the variable file

**Route tables**

Create route tables, associate the route table to subnet, and create a route to allow external traffic to the Internet through the Internet Gateway:
```
ROUTE_TABLE_ID=$(aws ec2 create-route-table \
  --vpc-id ${VPC_ID} \
  --output text --query 'RouteTable.RouteTableId')
```
```
aws ec2 create-tags \
  --resources ${ROUTE_TABLE_ID} \
  --tags Key=Name,Value=${NAME}
```
```
aws ec2 associate-route-table \
  --route-table-id ${ROUTE_TABLE_ID} \
  --subnet-id ${SUBNET_ID}
```
```
aws ec2 create-route \
  --route-table-id ${ROUTE_TABLE_ID} \
  --destination-cidr-block 0.0.0.0/0 \
  --gateway-id ${INTERNET_GATEWAY_ID}
  ```
- Input the value of `ROUTE_TABLE_ID` into the variable file

### B.  Configure Security Groups ###

**Security Groups**

- Create the security group and store its ID in a variable
```
SECURITY_GROUP_ID=$(aws ec2 create-security-group \
  --group-name ${NAME} \
  --description "Kubernetes cluster security group" \
  --vpc-id ${VPC_ID} \
  --output text --query 'GroupId')
```

- Create the NAME tag for the security group
```
aws ec2 create-tags \
  --resources ${SECURITY_GROUP_ID} \
  --tags Key=Name,Value=${NAME}
```

- Create Inbound traffic for all communication within the subnet to connect on ports used by the master node(s)
```
aws ec2 authorize-security-group-ingress \
    --group-id ${SECURITY_GROUP_ID} \
    --ip-permissions IpProtocol=tcp,FromPort=2379,ToPort=2380,IpRanges='[{CidrIp=172.31.0.0/24}]'
```
- Create Inbound traffic for all communication within the subnet to connect on ports used by the worker nodes
```
aws ec2 authorize-security-group-ingress \
    --group-id ${SECURITY_GROUP_ID} \
    --ip-permissions IpProtocol=tcp,FromPort=30000,ToPort=32767,IpRanges='[{CidrIp=172.31.0.0/24}]'
```
- Create inbound traffic to allow connections to the Kubernetes API Server listening on port 6443
```
aws ec2 authorize-security-group-ingress \
  --group-id ${SECURITY_GROUP_ID} \
  --protocol tcp \
  --port 6443 \
  --cidr 0.0.0.0/0
```

- Create Inbound traffic for SSH from anywhere (***Do not do this in production. Limit access ONLY to IPs or CIDR that MUST connect***)
```
aws ec2 authorize-security-group-ingress \
  --group-id ${SECURITY_GROUP_ID} \
  --protocol tcp \
  --port 22 \
  --cidr 0.0.0.0/0
```
- Create ICMP ingress for all types
```
aws ec2 authorize-security-group-ingress \
  --group-id ${SECURITY_GROUP_ID} \
  --protocol icmp \
  --port -1 \
  --cidr 0.0.0.0/0
```

**Network Load Balancer**

- Create a network Load balancer

```
LOAD_BALANCER_ARN=$(aws elbv2 create-load-balancer \
--name ${NAME} \
--subnets ${SUBNET_ID} \
--scheme internet-facing \
--type network \
--output text --query 'LoadBalancers[].LoadBalancerArn')
```
