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
