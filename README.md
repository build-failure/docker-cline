# Cline CLI Docker Image

[![Build](https://github.com/build-failure/docker-cline/actions/workflows/build-and-publish.yml/badge.svg)](https://github.com/build-failure/docker-cline/actions/workflows/build-and-publish.yml)

Cline CLI Docker image for Cline execution in CI/CD pipelines with Amazon Bedrock as LLM provider.

## Quick Start

```bash
# Pull from Container Registry
docker pull $CI_REGISTRY_IMAGE:latest

# Run interactively
docker run -it \
  -e CLINE_AWS_MODEL_ID="your-model-arn" \
  -e AWS_ACCESS_KEY_ID="your-key" \
  -e AWS_SECRET_ACCESS_KEY="your-secret" \
  $CI_REGISTRY_IMAGE:latest

# Run cline commands directly
docker run --rm \
  -e CLINE_AWS_MODEL_ID="your-model-arn" \
  -e AWS_ACCESS_KEY_ID="your-key" \
  -e AWS_SECRET_ACCESS_KEY="your-secret" \
  $CI_REGISTRY_IMAGE:latest "Create a hello world script"
```

## Environment Variables

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `AWS_ACCESS_KEY_ID` | Yes | - | AWS access key |
| `AWS_SECRET_ACCESS_KEY` | Yes | - | AWS secret key |
| `AWS_SESSION_TOKEN` | No | - | AWS session token (for temporary credentials) |
| `CLINE_AWS_MODEL_ID` | Yes | - | AWS Bedrock model ARN or inference profile |
| `CLINE_AWS_REGION` | No | `us-east-1` | AWS region |

## Features

- **Auto-configured**: Automatic AWS Bedrock setup on container start
- **Cross-region inference**: Enabled by default for global model availability
- **Smart entrypoint**: Pass arguments directly to cline without prefixing
- **Pre-configured**: Optimized settings for autonomous operation

## Image Tags

- `latest` - Latest stable build from main branch
- `<branch-name>` - Build from specific branch
- `<tag-name>` - Build from git tag/release

## Local Testing

For development and testing:

```bash
# Clone and test locally
docker-compose run -it cline bash
```

Create `.env` file for docker-compose:
```env
CLINE_AWS_MODEL_ID="arn:aws:bedrock:us-east-1:account:inference-profile/global.anthropic.claude-3-5-sonnet-20241022-v2:0"
CLINE_AWS_REGION="us-east-1"
```

## Requirements

- AWS Bedrock access with model permissions
- Docker 24.0.5+
- Valid AWS credentials
