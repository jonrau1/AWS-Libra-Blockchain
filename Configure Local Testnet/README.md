# Local Libra Blockchain Network

## Introduction & Housekeeping
This Readme will take you through the steps of building a localized version of the Libra testnet (I will refer to it as a Local Libra Blockchain Network, or a variation of throughout), sharing the necessary files for your remote Clients to connect to it, and executing transactions.

We will be building this on a Single EC2 Instance in the same VPC as your Cloud9 IDE to use RFC1918 Private IP Addresses, and will be permitting traffic using references to Security Groups. You can find out more information on Intra-VPC Routing [Here](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html#RouteTables), and some basic information on Security Groups (essentially, stateful L3/L4 Firewalls) [Here](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html).

We will be using [S3 Buckets](https://aws.amazon.com/s3/) which is an object storage solution, [IAM Users](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users.html) which represent identities of users/entities on AWS and another [EC2 Instance](https://aws.amazon.com/ec2/) which is Cloud-based compute to create our Local Libra Blockchain Network.

In a Production-like Environment, we would do quite a bit more hardening at the OS and Network levels and layer in additional Security controls as well as architect for High Availability, but this will do for some basic testing and familiarization. We would also use stronger Identity-based controls and practices to ensure least privilege and ephemeral access keys, but we will short cut a lot of these security best practices, so go forth at your own risk!!

## Infrastructure Setup
In this Stage, we will create our supporting infrastructure - in this case a single S3 Bucket, an IAM User with permission to Access S3 and an EC2 Instance will be created. Configuration of EC2, and creation of the Local Libra Blockchain Network will take place in different Stages

1. On the Management Console homescreen, scroll down to the Storage section and select **S3**
