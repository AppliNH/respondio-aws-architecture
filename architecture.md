# Details regarding this architecture

## Known limitations and areas for improvement

This architecture remains a debut blueprint, not 100% complete, that answers the requested assessment.

Due to some missing details regarding the kind of webapp that should be deployed on the web server, but also the expected load, I wasn't able to add more elements to the proposed architecture.

However, it's still a good debut blueprint to build more later.

- This does not setup HTTPS communication, which is an important matter.
- The values for the EC2 scaling group are subject to change, based on the expected workload.
- Route 53 requires to register a domain, the one used here is just an example.
- Location is currently set to eu-west-3 for my tests, but ap-southeast-1 would make more sense for you (Asia Pacific- Singapore).
- More validators can be added for modules input variable in the Terraform project, but I kept it simple for this assessment.
- The terraform project structure fits the need here, but can be subject to change depending on the context (more app, more environments). It's still a good working example, and a good blueprint.
- I could have solved the assessment with a Kubernetes architecture hosted on EKS as well, but as you were directly mentionning "EC2" in the instructions I've decided to make things this way.
- The RDS database could be tuned better to fit workload requirements.
- RDS database credentials can and should be stored in the **AWS Secrets Manager**. This can be achieved within the terraform project.

## Architecture Details

This cloud architecture proposition is optimized at different layers in order to ensure :

- high availability
- good security : minimal access to ressources achieved using IAM roles & policies.

This architecture starts with a VPC.

All the resources that can be attached to a VPC (EC2, RDS, ELB, etc) are attached to this VPC.

The VPC is configured with **two public and two private subnets**, distributed in **two availability zones**, ensuring **high availability**.

The **two public subnets** are routed to an **internet gateway**, which is a necessary setup for the **ELB LoadBalancer**.

The **two private subnets** are used by the **EC2 Scaling group**, and the **RDS database** (which is currently set to be a mysql database).

The **ELB**, **RDS** and **EC2 Scaling group** have a **proper security group for each of them**, limiting the ingress and egress traffic to a few ports (this still has to be tuned based on the original requirements).

Intially, I had placed the **EC2 Scaling group** in a **"placement group"** setting, with the mode set to **"partition"**.

This setting helps to reduce the likelihood of correlated hardware failures ([source here](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/placement-groups.html)), thus allowing a better availability of the application.

However, I've eventually found this decision over-engineered for the current use, as we're deploying a single workload on a single VPC, which doesn't need to be paired to another workload on another VPC.

Regarding the IAM Roles and policies, everything is set up to give minimal access to resources.

The role assigned to the EC2 pool allows to :

- Perform CRUD operations on a **single named database of the RDS ressource**.
- Interact with a single **S3 Bucket**.
- Write logs in **Cloudwatch**.

Lastly, the **ELB** is attached to the **EC2 scaling group** which allows to distribute the workload to the **EC2 instances pool**, and **Route53** have a basic DNS configuration using the settings of the LoadBalancer that has been previously provisioned.

## Tools : Terraform and Packer

I've chosen **Terraform** to provision this cloud architecture, as it is a standard tool in the industry as well as the most appropriate one to replicate an infrastructure.

Regarding the webservers configuration deployment, I've chosen to use a combination of **Packer + Ansible** to build a **Machine Image (AMI) containing a nginx installation**.

**This AMI can be then be pushed to the AWS EBS, and used to provision EC2 instances with the Terraform project.**

You will find more details about this in the Readme's located [here](./terraform/Readme.md) and [here](./packer/Readme.md).
