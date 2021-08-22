# Managing the maximum number of Pods per Node

## EKS
On Amazon Elastic Kubernetes Service (EKS), the maximum number of pods per node depends on the node type and ranges from 4 to 737.

If you reach the max limit, you will see something like:
```
kubectl get node -o yaml | grep pods
    pods: "17" => this is allocatable pods that can be allocated in node
    pods: "17" => this is how many running pods you have created
```
If you get only one number, it should be allocatable. Another way to count all running pods is to run the following command:
```
kubectl get pods --all-namespaces | grep Running | wc -l
```
Here's the list of max pods per node type:

https://github.com/awslabs/amazon-eks-ami/blob/master/files/eni-max-pods.txt

## GKE
On Google Kubernetes Engine (GKE), the limit is 110 pods per node. check the following URL:

https://github.com/kubernetes/community/blob/master/sig-scalability/configs-and-limits/thresholds.md

## AKS
On Azure Kubernetes Service (AKS), the default limit is 30 pods per node but it can be increased up to 250.
The default maximum number of pods per node varies between kubenet and Azure CNI networking, and the method of cluster deployment.
Check the following URL for more information:

https://docs.microsoft.com/en-us/azure/aks/configure-azure-cni#maximum-pods-per-node
