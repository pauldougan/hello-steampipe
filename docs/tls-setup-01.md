# TLS setup

a log of the first attempt to set up TLS for the deployed app (2022-10-14 17:00)

## 1. create app

Prepare a `hello-steampipe` app to hold all the infrastructure and the apps.

`copilot app init hello-steampipe --resource-tags department=GDS,team=govuk-paas,owner=paul.dougan --domain experiments.cloudpipelineapps.digital`

> note the use of the --domain parameter which triggers the set up of TLS
```

Note: The account does not seem to own the domain that you entered.
Please make sure that experiments.cloudpipelineapps.digital is registered with Route53 in your account, or that your hosted zone has the appropriate NS records.
To transfer domain registration in Route53, see:
https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/domain-transfer-to-route-53.html
To update the NS records in your hosted zone, see:
https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/SOA-NSrecords.html#NSrecords
Note: Looks like you're creating an application using credentials set by environment variables.
Copilot will store your application metadata in this account.
We recommend using credentials from named profiles. To learn more:
https://aws.github.io/copilot-cli/docs/credentials/

✔ Proposing infrastructure changes for stack hello-steampipe-infrastructure-roles
- Creating the infrastructure for stack hello-steampipe-infrastructure-roles                                          [create complete]  [120.1s]
  - A StackSet admin role assumed by CloudFormation to manage regional stacks                                         [create complete]  [22.0s]
  - Add NS records to delegate responsibility to the hello-steampipe.experiments.cloudpipelineapps.digital subdomain  [create complete]  [63.8s]
  - A hosted zone for hello-steampipe.experiments.cloudpipelineapps.digital                                           [create complete]  [43.3s]
  - A DNS delegation role to allow accounts: 994429068692 to manage your domain                                       [create complete]  [21.7s]
  - An IAM role assumed by the admin role to create ECR repositories, KMS keys, and S3 buckets                        [create complete]  [24.9s]
✔ The directory copilot will hold service manifests for application hello-steampipe.

Recommended follow-up action:
  - Run `copilot init` to add a new service or job to your application.
```

## 2. create 'dev' environment

Configure a `dev` environment to develop in 

`copilot env init -n dev --container-insights`

```
Credential source: Enter temporary credentials
AWS Access Key ID: ****************6V2Q
AWS Secret Access Key: ****************bexQ
AWS Session Token: ****************yQ==
Default environment configuration? Yes, use default.
✔ Manifest file for environment dev already exists at copilot/environments/dev/manifest.yml, skipping writing it.
- Update regional resources with stack set "hello-steampipe-infrastructure"  [succeeded]  [0.0s]
- Update regional resources with stack set "hello-steampipe-infrastructure"  [succeeded]        [127.8s]
  - Update resources in region "eu-west-1"                                   [create complete]  [124.3s]
    - KMS key to encrypt pipeline artifacts between stages                   [create complete]  [120.9s]
    - S3 Bucket to store local artifacts                                     [create complete]  [1.6s]
✔ Proposing infrastructure changes for the hello-steampipe-dev environment.
- Creating the infrastructure for the hello-steampipe-dev environment.  [create complete]  [59.6s]
  - An IAM Role for AWS CloudFormation to manage resources              [create complete]  [27.7s]
  - An IAM Role to describe resources in your environment               [create complete]  [25.2s]
✔ Provisioned bootstrap resources for environment dev in region eu-west-1 under application hello-steampipe.
Recommended follow-up actions:
  - Update your manifest copilot/environments/dev/manifest.yml to change the defaults.
  - Run `copilot env deploy --name dev` to deploy your environment.
```

## 3. deploy 'dev' environment

Deploy the `dev` environment and set up the infrastructure

`copilot env deploy -n dev`
```
✔ Proposing infrastructure changes for the hello-steampipe-dev environment.
- Creating the infrastructure for the hello-steampipe-dev environment.               [update rollback complete]  [851.1s]
  The following resource(s) failed to create: [HTTPSCert].
  - An ECS cluster to group your services                                            [delete complete]           [6.5s]
  - An IAM role to manage certificates and Route53 hosted zones                      [delete complete]           [2.4s]
  - Delegate DNS for environment subdomain                                           [delete complete]           [37.4s]
  - A Route 53 Hosted Zone for the environment's subdomain                           [delete complete]           [47.7s]
  - A security group to allow your containers to talk to each other                  [delete complete]           [0.0s]
  - Request and validate an ACM certificate for your domain                          [delete complete]           [35.1s]
    Received response status [FAILED] from custom resource. Message return
    ed: Resource is not in the state certificateValidated (Log: /aws/lambd
    a/hello-steampipe-dev-CertificateValidationFunction-vlxObmRAYsbH/2022/
    10/14/[$LATEST]d97d9b5da3054885a25bff4d9b3c1e03) (RequestId: 0cf81a35-
    b5b6-4703-9615-bdbd11e3e0f1)
  - An Internet Gateway to connect to the public internet                            [delete complete]           [2.6s]
  - Private subnet 1 for resources with no internet access                           [delete complete]           [2.9s]
  - Private subnet 2 for resources with no internet access                           [delete complete]           [2.9s]
  - A custom route table that directs network traffic for the public subnets         [delete complete]           [2.3s]
  - Public subnet 1 for resources that can access the internet                       [delete complete]           [2.3s]
  - Public subnet 2 for resources that can access the internet                       [delete complete]           [2.3s]
  - A private DNS namespace for discovering services within the environment          [delete complete]           [44.5s]
  - A Virtual Private Cloud to control networking of your AWS resources              [delete complete]           [4.1s]
✘ deploy environment dev: stack hello-steampipe-dev did not complete successfully and exited with status UPDATE_ROLLBACK_COMPLETE
dev
About

  Name        dev
  Region      eu-west-1
  Account ID  994429068692

Workloads

  Name    Type
  ----    ----

Tags

  Key                  Value
  ---                  -----
  copilot-application  hello-steampipe
  copilot-environment  dev
  department           GDS
  owner                paul.dougan
  team                 govuk-paas
```


