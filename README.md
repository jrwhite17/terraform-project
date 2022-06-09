# terraform-project
1.	S3 Bucket with SSE Enabled.
2.	RDS Security Group
3.	MySQL RDS in a Private subnet
4.	EC2 Security Group
5.	EC2 in a Private Subnet
6.	EC2 should be able to talk to MySQL
7.	ALB that uses ACM for TLS certs.
8.	EC2 should only allow traffic from ACM.
9.	ELB should only allow access from your IP.

### Goals
1.	Folder structure and skeleton. Perfection is not necessary.
- See terraform and terragrunt directories

2.	DRY code and achieve maximum reusability.
- See terraform and terragrunt directories

3.	List of tools to validate terraform code


4.	Dev/Test and Prod Deployment folder structure.
- See terragrunt directory

5.	Build a CI pipeline that will allow you to target AWS account

