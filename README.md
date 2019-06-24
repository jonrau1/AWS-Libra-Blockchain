![Libra Logo](/../screenshots/screens/libra.png?raw=true "Libra Logo")
# AWS-Libra-Blockchain
Helps you get started working with Libra Blockchain on AWS. You can connect to the Libra Testnet, create your own local Testnet and execute Move contracts by following tutorials starting [Over Here](https://developers.libra.org/docs/my-first-transaction).

This walkthrough will take your through using Amazon [Cloud9](https://aws.amazon.com/cloud9/details/) browser-based Cloud Integrated Development Environment (IDE) which will be built on top of Ubuntu 18.04 (you can additionally choose Amazon Linux 2 if you are familiar with `yum`)

## Creating Cloud9 IDE
1. Log into the AWS Management Console, Scroll down to **Developer Tools** and select Cloud9
![IDE Step 1](/../screenshots/screens/Step1.JPG?raw=true "IDE Step 1")
2. Choose **Create Environment** on the top right-hand side
![IDE Step 2](/../screenshots/screens/Step2.JPG?raw=true "IDE Step 2")
3. Give your Cloud9 IDE an Name and Description, and click **Next Step**
![IDE Step 3](/../screenshots/screens/Step3.JPG?raw=true "IDE Step 3")
4. 
- A: Choose **Create a new instance for environment (EC2)**, under **Instance Type** select whatever you think is appropiate (*t2.small* should be fine), select Ubuntu Server 18.04LTS and leave the **Cost-saving setting** default

- B: Cloud9 will create an AWS managed IAM Service Role, specify what VPC and Subnet you will like to launch your IDE in, ensure the subnets auto-assign a Public IP Address, you can read [more about VPCs here](https://docs.aws.amazon.com/vpc/latest/userguide/getting-started-ipv4.html) and then click **Next Step**

5. 