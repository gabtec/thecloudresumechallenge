# The Cloud Resume Challenge

[@cloudresumechallenge.dev](https://cloudresumechallenge.dev/docs/the-challenge/aws/)

Hello,
my name is **Gabriel** and this is my solution for the challenge.

## Disclaimer

<span style="background:orange">
If you're planning to see how I solve this challenge, and are willing to follow allong, you have to be aware that using AWS Cloud may have some costs $$$.
</span>

## Getting started

### Tools

- Terraform
- GitHub Actions
- AWS
- Javascript and NodeJS

## Pre-Condition

Have a domain name registered
In my case I registered at dominios.pt

I used Terraform to create a Route53 DNS zone, to manage it.
This gives me 4 nameservers, that I used to setup my domain register at dominios.pt.

I need this setup and working, in order to be able to validate certificates with DNS challenge.

Also, this is a one time setup. No need to change it.

### Strategy

I decided to brake the challenge in separate deployable parts.
I did this to solve dependencies issues, and deployment times.
**1:** the frontend must call the backend to get visits counter, so we need backend url
**2:** the frontend must use a custom domain, so I had to register a domain (which I did outside aws, and therefore I need Route53 nameservers url's to configure my domain register provider). Also this is a relative static and durable setup
**3:** deploying a cloudfront cdn takes some time, so I keep it to last. Also I had some issues with custom certificates (it is required that certificate for cloudfront is created in N. Virginia region)

Having this in consideration,
I structured my project in 3 main parts,
each one with it's own terraform IaC code.

```sh
.
└── my_project/
  ├── backend/
  │ ├── api
  │ └── terraform
  ├── frontend/
  │ ├── website
  │ └── terraform
  └── network/
  ├── a_setup_domain/
  │ └── terraform
  └── b_setup_cdn/
  └── terraform
```

### Update...

As I continue my learning path, I created a second branch "v2", where I structured my **terraform** code using **modules**.
I will annotate the diferences, ahead.

### Getting Started

#### --> AWS Credentials

Create the necessary files/credentials to access the cloud provider:

On AWS create a new user.
Then select that user and on "security credentials > Access Keys" create an access key.
Select "Application running outside AWS" since it will be used by terraform.
This will give you two things:
1- Access key
2- Secret Access Key

(save them)

Select your user again and add him the built_in policy of "AdministratorAccess".

Create a profile:

```sh
# create a folder
$ mkdir ~/.aws

# create the file
$ nano credentials

# add this content
#  [my-aws-profile]
#  aws_access_key_id = <use your value>
#  aws_secret_access_key = <use your value>
#
# save and exit
```

No we can use this crdentials in terraform aws provider:

```tf
provider "aws" {
  region = "us-west-1"                              # replace with yours
  profile = "my-aws-profile"                        # replace with yours
  shared_credentials_files = ["~/.aws/credentials"] # replace with yours
}
```

#### --> (branch v2) In root terraform folder, do...

**Requirement**
You must have a Route53 hosted zone created, and you domain nameservers updated.

On **branch v2**, terraform will query the hosted_zone_id, using data resource, but in branch v1 you have to set that value in terraform.tfvars file.

Init terraform (to download required dependencies)

```sh
# enter terraform folder
$ cd terraform

# init
$ terraform init

# deploy infrastructure
$ terraform plan

# And that's it.
# If you are following branch v2, you don't have to do anything more

# If you are following branch v1, continue reading
```

#### --> (branch v1) You have to deploy each part individually, so in each project sub folder, do...

Init terraform (to download required dependencies)

```sh
# enter terraform folder
$ cd terraform

# init
$ terraform init

# deploy infrastructure
$ terraform plan
```

#### --> (branch v1) Part 1: backend

after terraform it, you should be able to test.
terraform will show one output **"api_base_url"**
use it with curl:

```sh
# PUT /visits + body = { "count": 10 }
# the last .../visits is the endpoint defined in api gateway routes
$ curl -X PUT -H "Content-Type: application/json" -d '{"count":18}' <outputs_api_base_url>/visits
# r/ "Put item 18 OK"

# GET /visits
# the last .../visits is the endpoint defined in api gateway routes
$ curl <outputs_api_base_url>/visits
# r/ {"id":"gabtec.fun","visitsCount": 18}
```

```sh
# CORS issues ?!
# check that you don't miss cors configs when setting up "aws_apigatewayv2_api" resource
# and also in lambda response headers (js code)
```

#### --> (branch v1) Part 2: frontend

after terraform it, you should be able to test.
terraform will show one output **"bucket_url"** and **"bucket_regional_name"**
use it with your browser:

```sh
# browser:
$ http://<outputs_bucker_url>

# in part 3 we will be using a custom domain, but for now,
# this bucket_url will do
```

#### --> (branch v1) Part 3: network

Until now, with part 1 (backend) and part 2 (frontend) we have a fully functional service
BUT...
we do not have http**s** and also we are not using a **custom domain**.

So,
first I registered a domain: gabtec.fun
I did it outside aws, in dominios.pt
(I will need to setup in their services the Route53 nameservers that will manage my dns)

We also have to create and validate a **ssl certificate**,
and we will setup a CloudFront **content delivery network** (cdn).

This last one (cdn) may take some time to deploy and became available, so be patient...

##### ----> Before terraform apply...

we need to setup part 3 "terraform.tfvars" with the previous outputs infos

##### ----> Sub part a) setup domain

after terraform it, we should have a DNS zone and we can setup our nameservers at the domain registry

This is not expected to change, so it's "set and forget"

NOTE: this can take some time to propagate

terraform will also output **"route53_zone_id"** needed for next step

##### ----> Sub part b) setup CDN (CloudFront)

This will create a CDN CloudFront Distribution, add a new "A" record on my domain zone to point my custom domain to cdn url

This part requires a acme certificate issued and validated.
I had some issues with this:

- the first one, the fact that the certificate must be issued in N. Virginia region ???
- the second, terraform created it and output success, but I was not able to use it or see it in aws dashboard ???
- I wasn't understanding it right, and I wasn't creating the CNAME DNS records for the validation challenge (which I have to setup with terraform)
- **SO** I created it manually and validated it, then I passed it as a terraform var

:warning: Don't forget to set it
:white_check_mark: This is fixed in branch v2

Start this part (branch v1) by setting up terraform.tfvars with:

```sh
# aws_s3_bucket_website_configuration.*.website_endpoint
BUCKET_WEBSITE_URL   = "<bucket-name>.s3-website-<region>.amazonaws.com"
# aws_s3_bucket.*.bucket_regional_domain_name
BUCKET_REGIONAL_NAME = "<bucket-name>.s3.<region>.amazonaws.com"
# aws_route53_zone.*.zone_id
ROUTE53_ZONE_ID      = "the-zone-id-from-setp-3.1"
# aws_acme_certificate (in N. Virginia region)
CERTIFICATE_ARN     = "sdasdasdasdasd"
```

After terraform it, we should be able to access the website resume with our custom domain.
and...

```sh
# verify dns with
$ dns-sd -G v4 <my-domain.com>
```

# :construction: CONCLUSION :mag:

This was a lot of content.
But I think But I think I've achieved the main goals.
Of course some more improvements may be done.
I didn't invest much more time in complete automated CI/CD because to be able to call terraform using github actions, I'll need to have my terraform state file in a central repo (like Terraform Cloud).
That will allow me to create a CI/CD runner machine, pull the state, run terraform, save new state, and destroy runner.
For now I just run it locally and just put some mock tests in github actions pipeline.

Best,
Gabriel
