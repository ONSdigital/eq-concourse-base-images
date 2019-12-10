# eQ Infrastructure Build Image


This repo holds the Dockerfile and the pipeline to build and publish the infrastructure base image to a container registry. 


## Docker
The Dockerfile can be built using:
```bash
docker build -t eq-infrastructure-build-image:latest .
```

## Concourse

### Login

Authenticate with concourse using:

```
fly --taget <TARGET_NAME>  login --concourse-url <CONCOURSE_URL>
```

## Development Environments

### Prerequisites
You must have a project with a *Google Container Registry (GCR)* already set up to be able to push built images.
Set your registry in *variables.yaml* to `eu.gcr.io/<gcp_project_id>`. The `gcp_project_id` should be the ID of the GCP project under which the container registry is hosted.

### Deployment process

To ***create*** a pipeline to deploy your own infrastructure build image, you can do so as follows:

1. Set the `docker_registry` and `slack_channel_name` variable in *variables.yaml* *(copied from variables.yaml.example)*.

1. Upload your pipeline to Concourse using a command like:

    ```
    fly -t <TAGET_NAME> set-pipeline -p <PIPELINE_NAME> -c <PIPELINE_CONFIG_FILE> --load-vars-from variables.yaml
    ```

1. Navigate to the Concourse UI and unpause your pipeline to trigger the builds. Alternatively, you can run:
    ```
    fly -t <TARGET_NAME> unpause-pipeline -p <PIPELINE_NAME>
    ```

---

To ***destroy*** your pipeline, you can run the following command:
```
fly -t <TARGET_NAME> destroy-pipeline -p <PIPELINE_NAME>
```

---

## Secrets

Secrets are currently hooked into Kubernetes secrets, which are available on the cluster. To get a full list of secrets available for use within the pipeline, you can log in to the cluster and get the secrets.

Log in to the cluster using:
```
gcloud container clusters get-credentials <CLUSTER_NAME> --region <REGION> --project <GCP_PROJECT_ID>
```
Get the [Kubernetees secrets](https://kubernetes.io/docs/concepts/configuration/secret/) using:
```bash
kubectl --namespace=concourse-main get secrets
```

## Slack

Pipeline deployment notifications are alerted to the slack channel defined by `slack_channel_name` in *variables.yaml*. *(Do not include the `#`).*
