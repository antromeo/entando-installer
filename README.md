## entando-installer

requirements:

- multipass
- kubectl


1) launch instance 

```
multipass launch --name entando --cpus 4 --mem 8G --disk 20G
```

2) install k3s and enable it without sudo

```
multipass exec entando -- bash -c "curl -sfL https://get.k3s.io | INSTALL_K3S_CHANNEL='v1.22.9+k3s1' sh - && sudo chmod 644 /etc/rancher/k3s/k3s.yaml"
```
3) launch install-entando.sh

```
sh install-entando.sh
```