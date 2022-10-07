#!/bin/bash
read -p "Enter istance name: (default: entando)" instancename
instancename="${instancename:=entando}"

echo "select instance name: $instancename"
ent attach-vm $instancename

tags=$(git ls-remote --tags https://github.com/entando/entando-releases.git | sed -E 's|.*refs/tags/(.+)|\1|')
echo "TAGS AVAILABLES:\n$tags"

lasttag=$(echo $tags | awk '{print $NF}')
read -p "Enter version: (default: $lasttag)" version
version="${version:=$lasttag}"
echo "select version: $version"

ip=$(multipass list | grep -i "$instancename" | awk '{print $3}')
multipass exec $instancename -- sudo kubectl config view --raw | sed -e "s|127.0.0.1|$ip|"  > ~/.kube/config

mkdir -p temp
wget -P ./temp "https://raw.githubusercontent.com/entando/entando-releases/$version/dist/ge-1-1-6/namespace-scoped-deployment/cluster-resources.yaml" 
wget -P ./temp "https://raw.githubusercontent.com/entando/entando-releases/$version/dist/ge-1-1-6/namespace-scoped-deployment/namespace-resources.yaml"
wget -P ./temp "https://raw.githubusercontent.com/antromeo/entando-installer/main/entandoapp.yml"
sed -i "s|\$IP|$ip|" ./temp/entandoapp.yml

kubectl delete namespace entando
kubectl create namespace entando
kubectl apply -f ./temp/cluster-resources.yaml
kubectl apply -f ./temp/namespace-resources.yaml -n entando
kubectl apply -f ./temp/entandoapp.yml -n entando

[ -d temp ] && rm -r temp