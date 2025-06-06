# kcd-2025-sso-workshop

## Connect to the lab

I've prepared lab VMs for you.

You can open code-server `https://codeX.sikademo.com` where `X` is your lab number.

You can also use ssh to connect to the lab VM using `ssh root@labX.sikademo.com`

Password for the root user and code-server is `kcd2025`.

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
