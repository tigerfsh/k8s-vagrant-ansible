sudo sed -i '/ swap / s/^/#/' /etc/fstab
sudo swapoff -a
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak

sudo tee /etc/apt/sources.list <<-'EOF'
deb http://mirrors.aliyun.com/ubuntu/ xenial main
deb-src http://mirrors.aliyun.com/ubuntu/ xenial main

deb http://mirrors.aliyun.com/ubuntu/ xenial-updates main
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-updates main

deb http://mirrors.aliyun.com/ubuntu/ xenial universe
deb-src http://mirrors.aliyun.com/ubuntu/ xenial universe
deb http://mirrors.aliyun.com/ubuntu/ xenial-updates universe
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-updates universe

deb http://mirrors.aliyun.com/ubuntu/ xenial-security main
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-security main
deb http://mirrors.aliyun.com/ubuntu/ xenial-security universe
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-security universe
EOF

sudo apt-get update
sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common

curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get -y update
sudo apt-get -y install docker-ce


sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
"exec-opts": ["native.cgroupdriver=systemd"],
"log-driver": "json-file",
"log-opts": {
   "max-size": "100m"
},
"storage-driver": "overlay2",
"registry-mirrors": [
   "https://dockerhub.azk8s.cn",
   "https://hub-mirror.c.163.com"
]
}
EOF

sudo systemctl daemon-reload
sudo systemctl restart docker

sudo apt-get update

sudo curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | sudo apt-key add - 
sudo tee /etc/apt/sources.list.d/kubernetes.list <<-'EOF'
deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
EOF


sudo apt update 
sudo apt-get install -y kubelet kubeadm kubectl

sudo kubeadm init --image-repository registry.aliyuncs.com/google_containers --apiserver-advertise-address="192.168.50.10" --apiserver-cert-extra-sans="192.168.50.10"  --node-name k8s-master --pod-network-cidr=192.168.0.0/16

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# curl https://127.0.0.1:6443 -k

# Using this!
# sudo docker load -i calico_cni.tar
# sudo docker load -i calico_contro.tar
# sudo docker load -i calico_node.tar
# sudo docker load -i calico_pod.tar
# kubectl apply -f calico.yaml 

# Droped!
# kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml


# kubectl get pods --all-namespaces
# kubectl taint nodes --all node-role.kubernetes.io/master-

# kubeadm token create --print-join-command

# master节点默认不参与调度
# 查询命令：kubectl describe  nodes k8s-master |grep Taints
# 恢复调度：kubectl taint nodes k8s-master  node-role.kubernetes.io/master:NoSchedule-
# 让master节点不参与调度：kubectl taint nodes k8s-master  node-role.kubernetes.io/master:NoSchedule
