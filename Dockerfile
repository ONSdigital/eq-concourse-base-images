FROM gcr.io/google.com/cloudsdktool/cloud-sdk:alpine AS builder_cloud_sdk

FROM alpine:3.19 AS builder_terraform
ENV TERRAFORM_VERSION=1.7.3

# Install terraform
RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
RUN unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip
RUN mv terraform /usr/local/bin/terraform

FROM alpine:3.19
# Add gcloud to the path
ENV PATH /google-cloud-sdk/bin:$PATH

# Install dependencies
RUN apk add --no-cache python3 bash jq git

# Copy binaries from the builder
COPY --from=builder_cloud_sdk google-cloud-sdk/lib /google-cloud-sdk/lib
COPY --from=builder_cloud_sdk google-cloud-sdk/bin/gcloud google-cloud-sdk/bin/gcloud
COPY --from=builder_terraform /usr/local/bin/terraform /usr/local/bin/terraform

# Update gcloud config
RUN gcloud config set core/disable_usage_reporting true && \
    gcloud config set component_manager/disable_update_check true && \
    gcloud config set metrics/environment github_docker_image

# Set the default configuration directory
VOLUME ["/root/.config"]