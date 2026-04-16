# ArgoCD 설친
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

kubectl create ns argocd

helm upgrade -i argocd argo/argo-cd \
  --namespace argocd \
  -f values-argocd.yaml \
  --version 9.4.17

# Apps 설치 (Secret X)
kubectl apply -f ../apps/traefik.yaml
kubectl apply -f ../apps/sealed-secrets.yaml

# Sealed Secrets 업데이트
kubeseal -f ../manifests/postgres/secret.yaml --controller-namespace kube-system --controller-name sealed-secrets --format yaml -w ../manifests/postgres/sealed-secret.yaml
kubeseal -f ../manifests/memos/secret.yaml --controller-namespace kube-system --controller-name sealed-secrets --format yaml -w ../manifests/memos/sealed-secret.yaml
kubeseal -f ../manifests/mysql/secret.yaml --controller-namespace kube-system --controller-name sealed-secrets --format yaml -w ../manifests/mysql/sealed-secret.yaml
kubeseal -f ../manifests/ghost/secret.yaml --controller-namespace kube-system --controller-name sealed-secrets --format yaml -w ../manifests/ghost/sealed-secret.yaml
kubeseal -f ../manifests/xray/secret.yaml --controller-namespace kube-system --controller-name sealed-secrets --format yaml -w ../manifests/xray/sealed-secret.yaml

# Apps 설치
kubectl apply -f ../apps/postgres.yaml
kubectl apply -f ../apps/memos.yaml
kubectl apply -f ../apps/mysql.yaml
kubectl apply -f ../apps/ghost.yaml
kubectl apply -f ../apps/xray.yaml