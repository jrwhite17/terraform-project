# terraform-project
1.	**S3 Bucket with SSE Enabled.**<br />
Module aws-s3
2.	**RDS Security Group**<br />
Module aws-rds
3.	**MySQL RDS in a Private subnet**<br />
Module aws-rds | Input fromt static private_subnet_ids located in Terragrunt env.hcl
4.	**EC2 Security Group**<br />
Module aws-ec2
5.	**EC2 in a Private Subnet**<br />
Module aws-ec2 | Input from static private_subnet_ids located in Terragrunt env.hcl
6.	**EC2 should be able to talk to MySQL**<br />
Module aws-rds | Input from aws-ec2.private_ip for RDS Security Group Ingress Traffic
7.	**ALB that uses ACM for TLS certs.**<br />
Module aws-alb
8.	**EC2 should only allow traffic from ACM.** (Should this be ALB - and not ACM?)<br />
Module aws-ec2 | Input from aws-alb security group id (this security group id will be attached to ec2 and and alb and only allow traffic to itself)
9.	**ELB should only allow access from your IP.**<br />
Module aws-alb | Input from static developer_ip located in Terragrunt terragrunt.hcl

### Goals
1.	**Folder structure and skeleton. Perfection is not necessary.**<br />
See terraform and terragrunt directories and more detailed information below.<br />
**Note:** The **generic-random module** generates a **random deployment_id** for the terraform resources and **random_password** for the database.<br />
The **deployment_id** keeps terraform resource names unique, allowing for multiple deployments in the development environment.<br />
This module is intended to be generic as it's outputs **deployment_id** and **random_password** could be use for other environment specific modules (such as Azure, GCP, VMware, etc.)<br />

2.	**DRY code and achieve maximum reusability.**<br />
See terraform and terragrunt directories. Terragrunt (a wrapper around Terraform) is used to abstract the terraform modules and provide environment specific characteristics for each targeted environment (development, test and production).<br />
An example of this can be found in the **/terrafrom/terragrunt directory**.<br />
The environment folder structure contains AWS Account -> AWS Region -> Specific Environment Configuration.<br />
Terragrunt will orchestrate environment specific inputs and dependencies between the Terraform modules (located in the /terraform/modules directory).

3.	**List of tools to validate terraform code**<br />
- **Visual Studio Code HashiCorp Terraform Extension**<br />
This plugin provides syntax highlighting and autocompletion for the Visual Studio Code IDE. This is very helpful for local development activities.
- **Terragrunt Mock Outputs**<br />
Terragrunt offers a feature that allows users to mock outputs for executing the "Terraform Plan" task. This is a great method for validating input depenedencies between Terraform modules.
- **TFLint (is a Pluggable Terraform Linter)**<br />
This Linter provides a frameworks that alerts on possible errors (like illegal types for cloud providers (AWS/Azure/GCP)), warns about deprecated sytax or unused declarations and enforces best practices and naming conventions.
- **Python/Bash/Other Scripting**<br />
Using a coding/scripting language, we could write tests to validate the end state of the terraform deployment. We could check for characteristics like appropriate ports being accessible on the RDS isntance or network traffic is accessible form the ALB.

4.	**Dev/Test and Prod Deployment folder structure.**<br />
See terragrunt directory.

5.	**Build a CI pipeline that will allow you to target AWS account**<br />
Before building the CI pipelines we need to understand the security and compliance posture of the project. We also need to determine the targeted environment or environment(s).<br />
We also need to develop a deployment strategy that promotes the project through the various environments (development, test and production).<br />
Using Git Branching, we can develop a deployment strategy that accommodates the application/project's new release maturity.<br />
<br />For Example:
    - **Feature1** (environment target: development)
    - **Feature2** (environment target: development)
    - **Feature3** (environment target: development)
    - **Release3** (environment target: test)
    - **Master** (environment target: production)

<br />with.. **Feature1** (development) -> **Release3** (test) -> **Master** (production)
<br />Depending on the scope of the branch, the target environment changes.

After this deployment strategy has been developed, we can create logic for the CI pipeline to retrieve the appropriate authentication method for manipulating the targeted environment.<br />

Assuming the security and compliance posture of this project is minimal, I would recommend using GitHub actions as the CI pipeline orchestration tool/service.<br />
GitHub actions has a large collection of workflow steps that are supported and mainted by both the open source and commercial vendor communities. For example: HashiCorp maintains many GitHub actions for working with Terraform.<br />
GitHub also offers a native solution for authenticating with Amazon Web Services using OpenID Connect. This is very beneficial to our use case since our targeted environment is AWS and we wouldn't have to worry about storing AWS credentials as long-lived GitHub secrets.<br />

We also need to determine how long our development deployments will live. Lets assume that we have automated validation and acceptance testing for the post deployment. With this being the case, we will terminate the terraform resources after validating and acceptance testing has been executed.<br />
Of course, we could always leave the terraform resources up and running for manual validation and acceptance testing. Note: If we were to leave the terraform resources up and running, this will increase the Cloud expenses.<br />

**The basic workflow of the pipeline:**<br />
**Build** - Lint the Terraform Code, Execute a Terragrunt/Terraform Plan<br />
**Deploy** -  Execute a Terragrunt/Terraform Deploy<br />
**Test** - Execute Validation and Acceptance Tests<br />
**Clean Up** - Terragrunt/Terraform Destroy<br />

If we have enough trust in our validation and acceptance tests, we could automate promotion from:<br />
feature -> release -> master branches.<br />

If there are security concerns about using GitHub actions as our pipeline orchestration tool, we could look at some of the native AWS services to orchestrate our CI pipeline.<br />
**AWS offers:**
- **AWS CodeCommit** - Source code repository
- **AWS CodeBuild** - Compiles code and executes tests
- **AWS CodeDeploy** - Automates deployment of artifacts
- **AWS CodePipeline** - Automates release pipelines

These native AWS developer services provide seamless integration with the AWS collection of cloud services.