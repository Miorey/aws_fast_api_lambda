# Quick start FastAPI on AWS Lambda with Terraform
The purpose of this project is to help you to quickly deploy a FastAPI
on AWS - Lambda using Terraform. Thanks to [@Sancho66](https://github.com/Sancho66) for his help.

## Pre-requirements
To start you will need to install [terraform](https://www.terraform.io/downloads) and setup
your aws credentials with [aws cli](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).
Today AWS - Lambda, latest python version is 3.8, so this is the one we use.

## Init project
To generate you local venv:
```bash
python3.8 -m venv venv
source venv/bin/activate 
pip install -r requirements.txt
```

## Local run
To start the fast api locally you need to connect to your python venv
and start your api with uvicorn.
Go to `app` directory and execute `uvicorn main:app --reload`

```bash
source venv/bin/activate
cd app
uvicorn main:app --reload
```

Now on http://127.0.0.1:8000 you will have your api and on http://127.0.0.1:8000/docs
the swagger documentation for your api.

## Deploy on AWS
The deployment will creat:
- A random pet name bucket where will be stored the packaged lambda.
- An AWS lambda with your FastAPI.
- An AWS role to be attached to the lambda.
- The AWS API Gateway which will target the lambda.

First you will need to edit your AWS region in my case
`eu-central-1`. To do it edit `infrastructure/variables.tf` and change
the `aws_region` variable value.

To init terraform execute `make init`

Now you just have to execute `make deploy` and it will do the job. 
Answer `yes` to the question `Do you want to perform these actions?`
If everything gone alright at the end you will have something like:

```
Apply complete! Resources: 11 added, 0 changed, 0 destroyed.

Outputs:

api_endpoint = "https://[my_api_subdomain].execute-api.eu-central-1.amazonaws.com"
lambda_bucket_name = "terraform-fast-api-func-[4_pets_name]"
```
By clicking the api_endpoint url you should have
```json
{"status":"OK","message":"Et VOILA !"}
```
as answer.

To access to the swagger of the api you can go to:
https://[my_api_subdomain].execute-api.eu-central-1.amazonaws.com/docs