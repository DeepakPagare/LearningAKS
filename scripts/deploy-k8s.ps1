Write-Host "Deploying Kubernetes resources..." -ForegroundColor Cyan

$k8s = Join-Path $PSScriptRoot "..\k8s"

kubectl apply -f "$k8s\namespace.yaml"

kubectl apply -f "$k8s\configmaps"
kubectl apply -f "$k8s\secrets"

kubectl apply -f "$k8s\authapi"
kubectl apply -f "$k8s\paymentapi"
kubectl apply -f "$k8s\orderapi"

kubectl apply -f "$k8s\ingress"
kubectl apply -f "$k8s\hpa"

Write-Host ""
Write-Host "Deployment completed." -ForegroundColor Green
Write-Host ""

kubectl get pods -n microservices
kubectl get svc -n microservices
kubectl get ingress -n microservices