❯ mkdir terraform
❯ cd terraform
❯ terraform --version
Terraform v1.2.2
on darwin_amd64
> touch terraform.tf
--> add AWS provider
--> SET AWS CREDENTIALS using creds.sh
> aws sts get-caller-identity | jq .
{
  "UserId": "AIDAXJJCFAXZWDLRGZE5L",
  "Account": "500972193267",
  "Arn": "arn:aws:iam::500972193267:user/terraform"
}
❯ terraform init
Initializing the backend...

Initializing provider plugins...
- Finding latest version of hashicorp/aws...
- Installing hashicorp/aws v4.22.0...
- Installed hashicorp/aws v4.22.0 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.
--> Produces .terraform folder that installs providers and .terraform.lock.hcl, which manages terraform lock file
> touch s3.tf
--> add S3 example bucket
> terraform plan
--> show outputs of plan (+/-)
> terraform apply
│ Error: error creating S3 Bucket (dylans-test-bucket): BucketAlreadyExists: The requested bucket name is not available. The bucket namespace is shared by all users of the system. Please select a different name and try again.
│       status code: 409, request id: FV85KJWSC1H2Y12Q, host id: UrJQTDxVPmm5P+y9BRr1nJmTosLtXu8rbI809B37ZZkfw/Df5KQGRLz1ucv0EoLtpw2nSyHlCB0=
--> IF BUCKET NAME CONFLIC -> change `bucket_name` to `bucket_prefix` to append random bucket_prefix
> terraform apply
--> NOTICE THAT bucket is no longer set, only bucket prefix and the actual name will be "known after apply"
--> terraform.tfstate now exists locally! REVIEW
> echo 'Hello!' > test_file.txt
--> add a file to your bucket, referencing the name of the bucket you created (you can copy paste, or reference)
> terraform plan
--> Review plan and notcie what is set before/after an apply, notice the update to terraform state
> terraform state list
aws_s3_bucket.dylans_bucket
aws_s3_object.dylans_object
--> shows all the resources that terraform KNOWS about, right now
--> add acl AND versioning to bucket
> terraform apply -target='aws_s3_bucket_acl.dylans_bucket_acl'
--> will apply targeted changes ONLY to the changed resources (and any dependent resources)
--> now modify s3 object to be dependent on versioniong resource
> terraform apply -target='aws_s3_object.dylans_object'
--> depends_on creates a dependency, and terraform creates version resource before updating object
--> necesssary only when an explcity reference to a resource does not exist (i.e. a hidden dependency)
> terraform state list
aws_s3_bucket.dylans_bucket
aws_s3_bucket_acl.dylans_bucket_acl
aws_s3_bucket_versioning.dylans_bucket_versioning
aws_s3_object.dylans_object
--> NOW lets delete the state file...
> rm terraform.state
> terraform state list
No state file was found!

State management commands require a state file. Run this command
in a directory where Terraform has been run or use the -state flag
to point the command to a specific state location.
> terraform plan
--> no state exists, so terraform thinks these are all NEW resources, even though they exist in AWS, and wants to re-create them all!
--> what do you think will happen when terraform apply is run?
--> Now that we have a bucket, lets move our state to remote state, add terraform state provider
> terraform plan
│ Error: Backend initialization required, please run "terraform init"
│ 
│ Reason: Initial configuration of the requested backend "s3"
│ 
│ The "backend" is the interface that Terraform uses to store state,
│ perform operations, etc. If this message is showing up, it means that the
│ Terraform configuration you're using is using a custom configuration for
│ the Terraform backend.
> terraform init
Do you want to copy existing state to the new backend?

Yes
> terraform plan
what's different?
new file terraform.tfstate.backup
