# #1 Deploy to Apprunner (request driven web service)

> this does not work because of lack of support for web sockets in apprunner see https://github.com/aws/apprunner-roadmap/issues/13

- Ensure you are on the GDS VPN
- Assume role into paas-experiments-admin

```
copilot init  --app hello-steampipe \
            	--name hello-steampipe \
            	--type "Request-Driven Web Service" \
             	--dockerfile "./Dockerfile" \
            	--deploy
```

## Logs

19m elapsed

```
Welcome to the Copilot CLI! We're going to walk you through some questions
to help you get set up with a containerized application on AWS. An application is a collection of
containerized services that operate together.

Note: Looks like you're creating an application using credentials set by environment variables.
Copilot will store your application metadata in this account.
We recommend using credentials from named profiles. To learn more:
https://aws.github.io/copilot-cli/docs/credentials/

parse EXPOSE: no EXPOSE statements in Dockerfile ./Dockerfile
Port: 80
Ok great, we'll set up a Request-Driven Web Service named hello-steampipe in application hello-steampipe listening on port 80.

✔ Proposing infrastructure changes for stack hello-steampipe-infrastructure-roles
- Creating the infrastructure for stack hello-steampipe-infrastructure-roles                    [create complete]  [52.9s]
  - A StackSet admin role assumed by CloudFormation to manage regional stacks                   [create complete]  [19.5s]
  - An IAM role assumed by the admin role to create ECR repositories, KMS keys, and S3 buckets  [create complete]  [21.1s]
✔ The directory copilot will hold service manifests for application hello-steampipe.

✔ Wrote the manifest for service hello-steampipe at copilot/hello-steampipe/manifest.yml
Your manifest contains configurations like your container size and port (:80).

✔ Created ECR repositories for service hello-steampipe.


✔ Wrote the manifest for environment test at copilot/environments/test/manifest.yml
✔ Linked account 994429068692 and region eu-west-1 to application hello-steampipe.

✔ Proposing infrastructure changes for the hello-steampipe-test environment.
- Creating the infrastructure for the hello-steampipe-test environment.  [create complete]  [56.9s]
  - An IAM Role for AWS CloudFormation to manage resources               [create complete]  [20.6s]
  - An IAM Role to describe resources in your environment                [create complete]  [24.2s]
✔ Provisioned bootstrap resources for environment test in region eu-west-1 under application hello-steampipe.
✔ Provisioned bootstrap resources for environment test.
✔ Proposing infrastructure changes for the hello-steampipe-test environment.
- Creating the infrastructure for the hello-steampipe-test environment.       [update complete]  [75.2s]
  - An ECS cluster to group your services                                     [create complete]  [7.0s]
  - A security group to allow your containers to talk to each other           [create complete]  [2.9s]
  - An Internet Gateway to connect to the public internet                     [create complete]  [15.2s]
  - Private subnet 1 for resources with no internet access                    [create complete]  [3.3s]
  - Private subnet 2 for resources with no internet access                    [create complete]  [3.3s]
  - A custom route table that directs network traffic for the public subnets  [create complete]  [13.9s]
  - Public subnet 1 for resources that can access the internet                [create complete]  [3.3s]
  - Public subnet 2 for resources that can access the internet                [create complete]  [3.3s]
  - A private DNS namespace for discovering services within the environment   [create complete]  [44.8s]
  - A Virtual Private Cloud to control networking of your AWS resources       [create complete]  [11.5s]
Building your container image: docker build -t 994429068692.dkr.ecr.eu-west-1.amazonaws.com/hello-steampipe/hello-steampipe --platform linux/amd64 /Users/pauldougan/Documents/GitHub/hello-steampipe -f /Users/pauldougan/Documents/GitHub/hello-steampipe/Dockerfile
[+] Building 0.2s (11/11) FINISHED
 => [internal] load build definition from Dockerfile                                                                                                                       0.0s
 => => transferring dockerfile: 280B                                                                                                                                       0.0s
 => [internal] load .dockerignore                                                                                                                                          0.0s
 => => transferring context: 2B                                                                                                                                            0.0s
 => [internal] load metadata for docker.io/turbot/steampipe:latest                                                                                                         0.0s
 => [internal] load build context                                                                                                                                          0.0s
 => => transferring context: 2.17kB                                                                                                                                        0.0s
 => [1/6] FROM docker.io/turbot/steampipe                                                                                                                                  0.0s
 => CACHED [2/6] RUN  steampipe plugin install steampipe csv                                                                                                               0.0s
 => CACHED [3/6] WORKDIR .                                                                                                                                                 0.0s
 => CACHED [4/6] ADD *.sp .                                                                                                                                                0.0s
 => CACHED [5/6] ADD orgs.csv .                                                                                                                                            0.0s
 => CACHED [6/6] ADD config .                                                                                                                                              0.0s
 => exporting to image                                                                                                                                                     0.0s
 => => exporting layers                                                                                                                                                    0.0s
 => => writing image sha256:72abd77aeb59710e53b108ebf881e549aa69d1d64f0d3aca88f824ad803e1424                                                                               0.0s
 => => naming to 994429068692.dkr.ecr.eu-west-1.amazonaws.com/hello-steampipe/hello-steampipe                                                                              0.0s

Use 'docker scan' to run Snyk tests against images to find vulnerabilities and learn how to fix them
Login Succeeded
Using default tag: latest
The push refers to repository [994429068692.dkr.ecr.eu-west-1.amazonaws.com/hello-steampipe/hello-steampipe]
49c7dc87e7a2: Pushed
5ea73b827cd2: Pushed
019bec08250b: Pushed
5f70bf18a086: Pushed
e6e08f98b5e2: Pushed
053a3ab8f42a: Pushed
d93be3415e03: Pushed
64a38f7f5ff7: Pushed
c583bf48ad90: Pushed
389973dd6eb0: Pushed
8f7fbd0226af: Pushed
f93c7a8d0b11: Pushed
09ebdb357ed5: Pushed
✔ Proposing infrastructure changes for stack hello-steampipe-test-hello-steampipe
- Creating the infrastructure for stack hello-steampipe-test-hello-steampipe         [rollback complete]  [693.7s]
  The following resource(s) failed to create: [Service]. Rollback reques
  ted by user.
  - An IAM Role for App Runner to use on your behalf to pull your image from ECR     [delete complete]    [21.6s]
  - An IAM role to control permissions for the containers in your service            [delete complete]    [21.6s]
  - An App Runner service to run and manage your containers                          [delete complete]    [14.0s]
    Resource handler returned message: "null" (RequestToken: 68a711f1-9cf1
    -f117-8095-b4cd3236ff8f, HandlerErrorCode: null)
✘ deploy service hello-steampipe to environment test: deploy service: stack hello-steampipe-test-hello-steampipe did not complete successfully and exited with status ROLLBACK_COMPLETE
make: *** [deploy] Error 1
```

# #2 Deploy to ECS/Fargate (request driven web service)

> this works

- Ensure you are on the GDS VPN
- Assume role into paas-experiments-admin

```
copilot init  --app hello-steampipe \
            	--name hello-steampipe \
            	--type "Load Balanced Web Service" \
             	--dockerfile "./Dockerfile" \
            	--deploy
```

## logs

```
Welcome to the Copilot CLI! We're going to walk you through some questions
to help you get set up with a containerized application on AWS. An application is a collection of
containerized services that operate together.

Note: Looks like you're creating an application using credentials set by environment variables.
Copilot will store your application metadata in this account.
We recommend using credentials from named profiles. To learn more:
https://aws.github.io/copilot-cli/docs/credentials/

parse EXPOSE: no EXPOSE statements in Dockerfile ./Dockerfile
Port: 8080
Ok great, we'll set up a Load Balanced Web Service named hello-steampipe in application hello-steampipe listening on port 8080.

- Creating the infrastructure for stack hello-steampipe-infrastructure-roles                    [create complete]   [61.4s]
  - A StackSet admin role assumed by CloudFormation to manage regional stacks                   [create complete]   [25.4s]
  - An IAM role assumed by the admin role to create ECR repositories, KMS keys, and S3 buckets  [create complete]   [27.7s]
✔ The directory copilot will hold service manifests for application hello-steampipe.

✔ Wrote the manifest for service hello-steampipe at copilot/hello-steampipe/manifest.yml
Your manifest contains configurations like your container size and port (:8080).

- Update regional resources with stack set "hello-steampipe-infrastructure"  [succeeded]         [0.0s]

✔ Wrote the manifest for environment test at copilot/environments/test/manifest.yml
- Update regional resources with stack set "hello-steampipe-infrastructure"  [succeeded]         [0.0s]
- Update regional resources with stack set "hello-steampipe-infrastructure"  [succeeded]           [130.4s]
  - Update resources in region "eu-west-1"                                   [create complete]     [125.1s]
    - ECR container image repository for "hello-steampipe"                   [create in progress]  [130.6s]
    - KMS key to encrypt pipeline artifacts between stages                   [create complete]     [121.5s]
    - S3 Bucket to store local artifacts                                     [create in progress]  [107.1s]
- Creating the infrastructure for the hello-steampipe-test environment.  [create complete]   [56.2s]
  - An IAM Role for AWS CloudFormation to manage resources               [create complete]   [24.1s]
  - An IAM Role to describe resources in your environment                [create complete]   [21.5s]
✔ Provisioned bootstrap resources for environment test in region eu-west-1 under application hello-steampipe.
✔ Provisioned bootstrap resources for environment test.
- Creating the infrastructure for the hello-steampipe-test environment.       [update complete]   [80.4s]
  - An ECS cluster to group your services                                     [create complete]   [7.2s]
  - A security group to allow your containers to talk to each other           [create complete]   [1.1s]
  - An Internet Gateway to connect to the public internet                     [create complete]   [16.3s]
  - Private subnet 1 for resources with no internet access                    [create complete]   [3.0s]
  - Private subnet 2 for resources with no internet access                    [create complete]   [3.0s]
  - A custom route table that directs network traffic for the public subnets  [create complete]   [11.5s]
  - Public subnet 1 for resources that can access the internet                [create complete]   [3.0s]
  - Public subnet 2 for resources that can access the internet                [create complete]   [4.8s]
  - A private DNS namespace for discovering services within the environment   [create complete]   [47.6s]
  - A Virtual Private Cloud to control networking of your AWS resources       [create complete]   [16.3s]
[+] Building 0.2s (11/11) FINISHED
 => [internal] load build definition from Dockerfile                                                                                                                                      0.0s
 => => transferring dockerfile: 37B                                                                                                                                                       0.0s
 => [internal] load .dockerignore                                                                                                                                                         0.0s
 => => transferring context: 2B                                                                                                                                                           0.0s
 => [internal] load metadata for docker.io/turbot/steampipe:latest                                                                                                                        0.0s
 => [1/6] FROM docker.io/turbot/steampipe                                                                                                                                                 0.0s
 => [internal] load build context                                                                                                                                                         0.0s
 => => transferring context: 439B                                                                                                                                                         0.0s
 => CACHED [2/6] RUN  steampipe plugin install steampipe csv                                                                                                                              0.0s
 => CACHED [3/6] WORKDIR .                                                                                                                                                                0.0s
 => [4/6] ADD *.sp .                                                                                                                                                                      0.0s
 => [5/6] ADD orgs.csv .                                                                                                                                                                  0.0s
 => [6/6] ADD config .                                                                                                                                                                    0.0s
 => exporting to image                                                                                                                                                                    0.0s
 => => exporting layers                                                                                                                                                                   0.0s
 => => writing image sha256:061ac5fc0517879346d986a1425b78cb9c6f4980cbe02aa151524b29cda696e3                                                                                              0.0s
 => => naming to 994429068692.dkr.ecr.eu-west-1.amazonaws.com/hello-steampipe/hello-steampipe                                                                                             0.0s

Use 'docker scan' to run Snyk tests against images to find vulnerabilities and learn how to fix them
Login Succeeded
Using default tag: latest
The push refers to repository [994429068692.dkr.ecr.eu-west-1.amazonaws.com/hello-steampipe/hello-steampipe]
f764938a12d4: Pushed
c7c099fa0b0c: Pushed
e970913ea004: Pushed
5f70bf18a086: Pushed
e6e08f98b5e2: Pushed
053a3ab8f42a: Pushed
d93be3415e03: Pushed
64a38f7f5ff7: Pushed
c583bf48ad90: Pushed
389973dd6eb0: Pushed
8f7fbd0226af: Pushed
f93c7a8d0b11: Pushed
09ebdb357ed5: Pushed
latest: digest: sha256:13abf1d6421b4bc271918f209e382fafcbfb4939ddc2ab6ac8a6e835ed473077 size: 3239
- Creating the infrastructure for stack hello-steampipe-test-hello-steampipe      [create complete]     [262.7s]
  - Service discovery for your services to communicate within the VPC             [create complete]     [2.1s]
  - Update your environment's shared resources                                    [update complete]     [113.1s]
    - A security group for your load balancer allowing HTTP traffic               [create complete]     [7.1s]
    - An Application Load Balancer to distribute public traffic to your services  [create complete]     [91.3s]
    - A load balancer listener to route HTTP traffic                              [create in progress]  [122.8s]
  - An IAM role to update your environment stack                                  [create complete]     [22.6s]
  - An IAM Role for the Fargate agent to make AWS API calls on your behalf        [create complete]     [22.6s]
  - A HTTP listener rule for forwarding HTTP traffic                              [create complete]     [1.8s]
  - A custom resource assigning priority for HTTP listener rules                  [create complete]     [0.0s]
  - A CloudWatch log group to hold your service logs                              [create complete]     [2.1s]
  - An IAM Role to describe load balancer rules for assigning a priority          [create complete]     [22.6s]
  - An ECS service to run and maintain your tasks in the environment cluster      [create complete]     [77.2s]
    Deployments
               Revision  Rollout      Desired  Running  Failed  Pending
      PRIMARY  1         [completed]  1        1        0       0
  - A target group to connect the load balancer to your service                   [create complete]     [0.0s]
  - An ECS task definition to group your containers and run them on ECS           [create complete]     [1.1s]
  - An IAM role to control permissions for the containers in your tasks           [create complete]     [22.6s]
✔ Deployed service hello-steampipe.
Recommended follow-up action:
  - You can access your service at http://hello-Publi-1VEHI3R44LUA4-765409388.eu-west-1.elb.amazonaws.com over the internet.
- Be a part of the Copilot ✨community✨!
  Ask or answer a question, submit a feature request...
  Visit 👉 https://aws.github.io/copilot-cli/community/get-involved/ to see how!

```
