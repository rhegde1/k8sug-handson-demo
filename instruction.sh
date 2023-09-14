# Credit to learnk8s.io & learn.microsoft.com

# Install terraform
macOS "Install terraform" "brew install terraform"
windowsOS "Install terraform" "choco install terraform"
linuxOS "Install terraform" "sudo apt-get install terraform"

# Install kubectl
macOS "Install kubectl" "brew install kubectl"
windowsOS "Install kubectl" "choco install kubernetes-cli"
linuxOS "Install kubectl" "sudo apt-get install kubectl"

#install az cli
macOS "Install az cli" "brew install azure-cli"
windowsOS "Install az cli" "choco install azure-cli"
linuxOS "Install az cli" "curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash"

# login to azure
az login
az account set --subscription $SUBSCRIPTION_ID

# create service service_principal
az ad sp create-for-rbac --name k8sug-handsonAKS --role contributor --scopes /subscriptions/$SUBSCRIPTION_ID ---> replace it with your subscription id

Service principal needs to have CONTRIBUTOR ACCESS to the subscription or else you will get below error:
// 
Planning failed. Terraform encountered an error while generating this plan.

╷
│ Error: Unable to list provider registration status, it is possible that this is due to invalid credentials or the service principal does not have permission to use the Resource Manager API, Azure error: resources.ProvidersClient#List: Failure responding to request: StatusCode=403 -- Original Error: autorest/azure: Service returned an error. Status=403 Code="AuthorizationFailed" Message="The client '9c8369b6-bba5-4010-b694-e75aa396fdf6' with object id '9c8369b6-bba5-4010-b694-e75aa396fdf6' does not have authorization to perform action 'Microsoft.Resources/subscriptions/providers/read' over scope '/subscriptions/78506f2d-32b3-4404-909a-02d41d22092b' or the scope is invalid. If access was recently granted, please refresh your credentials."
│ 
│   with provider["registry.terraform.io/hashicorp/azurerm"],
│   on providers.tf line 10, in provider "azurerm":
│   10: provider "azurerm" {
\\

# output of above command will look like this
{
  "appId": "xxxxx-xxxxx-xxxxx-xxxxx-xxxx",
  "displayName": "azure-cli-2023-09-14-03-25-56",
  "password": "xxxxx-xxxxx-xxxxx-xxxxx-xxxx",
  "tenant": "xxxxx-xxxxx-xxxxx-xxxxx-xxxx"
}

# Export Credentials to Environment Variables
export ARM_CLIENT_ID= <appId>
export ARM_SUBSCRIPTION_ID= <subscriptionId>
export ARM_TENANT_ID= <tenantId>
export ARM_CLIENT_SECRET= <password>

# Provisioning an AKS cluster with Terraform
# Instead of writing the code to create the infrastructure, you define a plan of what you want to be executed, and you let Terraform create the resources on your behalf.
# The plan isn't written in YAML, though.
# Instead Terraform uses a language called HCL - HashiCorp Configuration Language.
# In other words, you use HCL to declare the infrastructure you want to be deployed, and Terraform executes the instructions.

# terraform code is already created for you in this repo, navigate to the folder
cd k8sug-handson-demo/terraform

# initialize terraform
terraform init

# Format terraform code
terraform fmt --recursive <This  command with --recursive flag will format all the files in the directory>

# validate terraform code
terraform validate

# plan terraform code
terraform plan

# apply terraform code
terraform apply

# get kubernetes credentials
az aks get-credentials --resource-group aks-rg --name aksdemoclus1

# verify kubernetes cluster
kubectl get nodes

# inspect the cluster pods
kubectl get nodes --kubeconfig kubeconfig

# deploy sample hello world application
kubectl apply -f K8SUG-Handson-Demo/yaml/hello-world.yaml

# verify application
kubectl get pods

# port forward application
kubectl port-forward hello-kubernetes-7f76b879bf-lt4l9 8080:8080 ---> replace hello-kubernetes-7f76b879bf-lt4l9 with your pod name

Test the hello world application locally using --> http://localhost:8080

# Exposing the application with kubectl port-forward is an excellent way to test the app quickly, but it isn't a long-term solution.
# If you wish to route live traffic to the Pod, you should have a more permanent solution.
# In Kubernetes, you can use a Service of type: LoadBalancer to start up a load balancer to expose your Pods.

kubectl apply -f ../yaml/service-loadbalancer.yaml
kubectl get svc

# The load balancer that you created earlier serves one service at a time.
# Also, it has no option to provide intelligent routing based on paths.
# So if you have multiple services that need to be exposed, you will need to create the same number of load balancers.
# Imagine having ten applications that have to be exposed.
# If you use a Service of type: LoadBalancer for each of them, you might end up with ten different L4 Load Balancers.


# Update AKS cluster by adding one more node
Update terraform code to add one more node using "node_count" flag

#In Azure, the Ingress add-on installs Ingress Nginx.
# On top of that, enabling the add-on also installs the ExternalDNS that can be used to manage DNS entries automatically.
# As soon as you install the add-on, Azure creates an L4 Load Balancer and configures it to route traffic to the Ingress Nginx.
# When you submit an Ingress manifest to Kubernetes, the Ingress controller reconfigures itself to route traffic to that Service (and Pods).
# We will add ingress controller to our cluster

# Update terraform code to add ingress controller using "http_application_routing_enabled" flag
/ Just uncomment the following lines in main.tf file
# http_application_routing_enabled = true
/

# Format terraform code
terraform fmt --recursive <This  command with --recursive flag will format all the files in the directory>

# validate terraform code
terraform validate

# plan terraform code
terraform plan

# apply terraform code
terraform apply

# destroy terraform code
terraform destroy








