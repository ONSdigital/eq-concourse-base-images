FROM gcr.io/google.com/cloudsdktool/cloud-sdk:alpine AS builder_cloud_sdk

FROM alpine:3.19 AS builder_tfenv

# Install tfenv
RUN apk add --no-cache bash git curl && \
    git clone --depth=1 https://github.com/tfutils/tfenv.git /tfenv

FROM alpine:3.19
# Add gcloud and tfenv to the path
ENV PATH /google-cloud-sdk/bin:$PATH
ENV PATH /tfenv/bin:$PATH

# Install dependencies
RUN apk add --no-cache python3 bash jq curl

# Copy binaries from the builders
COPY --from=builder_cloud_sdk google-cloud-sdk/lib /google-cloud-sdk/lib
COPY --from=builder_cloud_sdk google-cloud-sdk/bin/gcloud google-cloud-sdk/bin/gcloud
COPY --from=builder_tfenv /tfenv /tfenv

# Update gcloud config and install terraform version
RUN gcloud config set core/disable_usage_reporting true && \
    gcloud config set component_manager/disable_update_check true && \
    gcloud config set metrics/environment github_docker_image && \
    tfenv install 1.7.3

# Set the default configuration directory
VOLUME ["/root/.config"]