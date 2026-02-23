#!/bin/bash

# install k3s, set INSTALL_K3S_EXEC to install in controller mode
# setting the read permission for all users (to be able to run kubectl without sudo)
# using 192.168.56.110 as the server's ip address in k3s
# using eth1 for pod networking
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --write-kubeconfig-mode 644 --node-ip 192.168.56.110 --flannel-iface eth1" sh -

# wait until node-token file gets created
while [ ! -f /var/lib/rancher/k3s/server/node-token ]; do
  sleep 1
done

# copy the token into the shared synced folder, so the worker VM can find it and join the cluster
cp /var/lib/rancher/k3s/server/node-token /vagrant/node-token
