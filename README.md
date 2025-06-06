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
