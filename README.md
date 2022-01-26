## Repository idea
Implement infrastructure as code (IaC) for a simple web application that runs on AWS Lambda that prints the request header, method, and body.

#### Inside the Repository

The repository contains 3 directories :
-  code : where we host our code. The name of the file is ‘prog.py’, you can change the name.
- Terraform : is where we host our terraform files, you need to change the following depends on your settings:-

	1. Region.
	2. AccountId.
	3.  Rest_api (API Gatewway name).
	4.  Resource_name and the code_file (if you changed the name of the code file ‘prog.py’) in the values.tfvar file.
	5. You need to create S3 bucket to store the terraform state if not done before and change the bucket, key and region of the s3 section in the ‘provider.tf’ file.

-  .github/workflow/main.yaml : containes the pipeline code. The last step can be deleted, it only stores the zipped file of the code as an artifact.


**Note :-**
- you need to configure AWS_ACCESS_KEY_ID &  AWS_SECRET_ACCESS_KEY  , Settings > Secrets and click on  « New Repository Secret »

- the pipeline will be triggered only when there is changes in the code (not terraform or workflows files)

- You need to have the right permissions (role, lambda and API gateway)
