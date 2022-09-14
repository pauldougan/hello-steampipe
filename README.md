# hello-steampipe

![](docs/screenshot.png)

run a minimal [Steampipe](https://steampipe.io) dashboard on AWS using [AWS Copilot CLI](https://aws.github.io/copilot-cli/) to explore our options for deployment

# Deployment options

- the option to deploy using apprunner using the [`Request-Driven Web Service`](https://aws.github.io/copilot-cli/docs/concepts/services/#request-driven-web-service) approach does not work because of the need to use web sockets, we were able to see the landing page but were unable to render the dashboard
- we deployed the app from the dockerfile using [`Load Balanced Web Service`](https://aws.github.io/copilot-cli/docs/concepts/services/#load-balanced-web-service) and confirmed that it deploys to ECS with fargate


