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
