# kcd-2025-sso-workshop

https://docs.google.com/document/d/1ZPqHFBwDncSKHlsI6Ganb9n8ASJoczjzhLN2jHrQBnE/edit


## Install slu

<https://github.com/sikalabs/slu>

```
curl -fsSL https://raw.githubusercontent.com/sikalabs/slu/master/install.sh | sudo sh
```

## Install kubectl, helm, k9s

```
slu install-bin kubectl
slu install-bin helm
slu install-bin k9s
```

Cratete a `k` alias for `kubectl`:

```
ln -s /usr/local/bin/kubectl /usr/local/bin/k
```

## Install RKE2

```
curl -sfL https://get.rke2.io | sh -
```

Disable the default ingress-nginx controller that comes with RKE2:

```
mkdir -p /etc/rancher/rke2/
cat << EOF > /etc/rancher/rke2/config.yaml
disable:
  - rke2-ingress-nginx
EOF
```

```
systemctl enable rke2-server.service --now
```

Copy kubeconfig to your home directory:

```
mkdir -p ~/.kube
cp /etc/rancher/rke2/rke2.yaml ~/.kube/config
```

Try it

```
kubectl get nodes
```

## Install Nginx Ingress Controller

```
helm upgrade --install \
  ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --create-namespace \
  --namespace ingress-nginx \
  --set controller.service.type=ClusterIP \
  --set controller.ingressClassResource.default=true \
  --set controller.kind=DaemonSet \
  --set controller.hostPort.enabled=true \
  --set controller.metrics.enabled=true \
  --set controller.config.use-proxy-protocol=false \
  --wait
```

## Install CertManager and cluster issuer

```
helm upgrade --install \
  cert-manager cert-manager \
  --repo https://charts.jetstack.io \
  --create-namespace \
  --namespace cert-manager \
  --set crds.enabled=true \
  --wait
```

```
cat <<EOF | kubectl apply -f -
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt
spec:
  acme:
    email: lets-encrypt-slu@sikamail.com
    server: https://acme-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      name: letsencrypt-issuer-account-key
    solvers:
      - http01:
          ingress:
            class: nginx
EOF
```

## Install Local Path Provisioner

```
kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/v0.0.31/deploy/local-path-storage.yaml
```

Set as default storage class:

```
kubectl patch storageclass local-path -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
```

## Install Keycloak

```
helm upgrade --install \
  keycloak oci://registry-1.docker.io/bitnamicharts/keycloak \
  --create-namespace \
  --namespace keycloak \
  --values keycloak.values.yaml \
  --wait
```

Go to `https://sso.labX.sikademo.com`.

- Username: `user`
- Password: `bitnami`

## Install Terraform

```
slu install-bin terraform
```

## Apply Terraform configuration

Apply terraform configuration:

```
cd terraform
```

```
terraform init
```

```
terraform apply
```

## Add SSO to Kubernetes

```
mkdir -p /etc/rancher/rke2/
cat << EOF > /etc/rancher/rke2/config.yaml
disable:
  - rke2-ingress-nginx

kube-apiserver-arg:
  - --oidc-issuer-url=https://sso.labX.sikademo.com/realms/kcd
  - --oidc-client-id=kubernetes
  - --oidc-username-claim=email
  - --oidc-groups-claim=groups
EOF
```

```
systemctl restart rke2-server.service
```

## Install oidc-login plugin

```
slu install-bin kubelogin
```

## Create Kubeconfig with SSO

```yaml
users:
- name: sparta-dev
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      args:
      - oidc-login
      - get-token
      - --oidc-issuer-url=https://sso.labX.sikademo.com/realms/kcd
      - --oidc-client-id=kubernetes
      - --oidc-client-secret=xxx
      command: kubectl
      env: null
      interactiveMode: IfAvailable
      provideClusterInfo: false
```
