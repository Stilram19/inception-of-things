#!/bin/bash

# waiting for the server VM to copy the token to the shared synced folder
while [ ! -f /vagrant/node-token ]; do
  sleep 1
done

# storing the token into TOKEN variable
TOKEN=$(cat /vagrant/node-token)

# installing k3s in agent mode (passing the environmental variables to sh to specify the server VM ip address and the token to join the cluster)
# using 192.168.56.111 as the server worker ip address
# using eth1 for pod networking 
curl -sfL https://get.k3s.io | K3S_URL="https://192.168.56.110:6443" K3S_TOKEN="$TOKEN" INSTALL_K3S_EXEC="agent --node-ip 192.168.56.111 --flannel-iface eth1" sh -
