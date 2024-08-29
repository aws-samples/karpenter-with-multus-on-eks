#!/usr/bin/bash
# Install kubectl
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.30.2/2024-07-12/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$HOME/bin:$PATH
echo 'export PATH=$HOME/bin:$PATH' >> ~/.bash_profile
kubectl version --client

# Update aws cli
cd ~
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

sudo yum -y install jq gettext bash-completion 
# Install yq for yaml processing
echo 'yq() {
  docker run --rm -i -v "${PWD}":/workdir mikefarah/yq "$@"
}' | tee -a ~/.bashrc && source ~/.bashrc

# Verify binaries are in the path
for command in kubectl jq envsubst aws
  do
    which $command &>/dev/null && echo "$command in path" || echo "$command NOT FOUND"
  done

# Enable kubectl bash_completion
kubectl completion bash >>  ~/.bash_completion
#. /etc/profile.d/bash_completion.sh
. ~/.bash_completion

# Install eksctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
sudo cp /usr/local/bin/eksctl  /home/cloudshell-user/bin


# Confirm the eksctl command works:
eksctl version

# Enable eksctl bash completion
eksctl completion bash >> ~/.bash_completion
#. /etc/profile.d/bash_completion.sh
. ~/.bash_completion

# Install helm
export VERIFY_CHECKSUM=false
curl -sSL https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

helm version --short

# Enable bash completion for helm
helm completion bash >> ~/.bash_completion
#. /etc/profile.d/bash_completion.sh
. ~/.bash_completion
source <(helm completion bash)
sudo cp /usr/local/bin/helm  /home/cloudshell-user/bin

# Install nc tool
sudo yum -y install nc

# aws cli command completion
complete -C '/usr/local/bin/aws_completer' aws >> ~/.bashrc
