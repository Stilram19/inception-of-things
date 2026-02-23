#!/bin/bash

# install k3s, set INSTALL_K3S_EXEC to install in controller mode
# setting the read permission for all users (to be able to run kubectl without sudo)
# using 192.168.56.110 as the server's ip address in k3s
# using eth1 for pod networking
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --write-kubeconfig-mode 644 --node-ip 192.168.56.110 --flannel-iface eth1" sh -

# wait for k3s to be ready
while ! kubectl get nodes 2>/dev/null | grep -q "Ready"; do
  sleep 1
done

# apply manifests
kubectl apply -f /vagrant/confs/
