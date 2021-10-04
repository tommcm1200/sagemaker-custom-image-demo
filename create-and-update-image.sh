ACCOUNT_ID=XXX # Replace with your AWS account ID
REGION=ap-southeast-2 #Replace with your region
DOMAINID=d-XXX #Replace with your SageMaker Studio domain name.
IMAGE_NAME=tf2kernel #Replace with your Image name

# Using with SageMaker Studio
## Create SageMaker Image with the image in ECR (modify image name as required)
ROLE_ARN='arn:aws:iam::XXX:role/service-role/AmazonSageMaker-ExecutionRole-20210108T140941'

aws --region ${REGION} sagemaker create-image \
    --image-name ${IMAGE_NAME} \
    --role-arn ${ROLE_ARN}

aws --region ${REGION} sagemaker create-image-version \
    --image-name ${IMAGE_NAME} \
    --base-image "${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/smstudio-custom:${IMAGE_NAME}"
    
## Create AppImageConfig for this image (modify AppImageConfigName and KernelSpecs in app-image-config-input.json as needed)
aws --region ${REGION} sagemaker create-app-image-config --cli-input-json file://app-image-config-input.json

## Update the Domain, providing the Image and AppImageConfig
aws --region ${REGION} sagemaker update-domain --domain-id ${DOMAINID} --cli-input-json file://default-user-settings.json


aws --region ${REGION} sagemaker create-app --domain-id ${DOMAINID} --cli-input-json file://create-app.json