#!/bin/sh

CURRENT_WORKING_DIR=$(pwd)

# Network driver: calico
mkdir calico 
cd calico
curl -o tigera-operator.yaml https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/tigera-operator.yaml
curl -o custom-resources.yaml https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/custom-resources.yaml
kubectl create -f tigera-operator.yaml
dnf -y install yq
yq -e -i '(select(.spec.calicoNetwork.ipPools) | .spec.calicoNetwork.ipPools[0].cidr) = "10.0.0.0/16"' custom-resources.yaml
kubectl create -f custom-resources.yaml
cd $CURRENT_WORKING_DIR

# Block storage: longhorn
mkdir longhorn
cd longhorn
systemctl enable --now iscsid
curl -sSfL https://raw.githubusercontent.com/longhorn/longhorn/v1.6.2/scripts/environment_check.sh | bash
curl -o longhorn.yaml https://raw.githubusercontent.com/longhorn/v1.6.2/deploy/longhorn.yaml
kubectl apply -f longhorn.yaml
cd $CURRENT_WORKING_DIR