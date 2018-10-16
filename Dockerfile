FROM ubuntu:latest
ENV GOPATH /go
WORKDIR /go
ENV PATH $PATH:/go/bin

RUN \
  mkdir -p /go /root/out /ansible && \
  apt-get update && \
  apt-get install -y python3 python3-pip git golang-1.10 build-essential \
  libssl-dev libffi-dev python3-dev curl && \
  pip3 install boto boto3 awscli git+https://github.com/ansible/ansible.git@devel && \
  curl -o /usr/local/bin/kubectl https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-07-26/bin/linux/amd64/kubectl && \
  chmod 755 /usr/local/bin/kubectl && \
  cd /go && \
  update-alternatives --install "/usr/bin/go" "go" "/usr/lib/go-1.10/bin/go" 0 && \
  go get -u github.com/kubernetes-sigs/aws-iam-authenticator/cmd/aws-iam-authenticator

COPY printkubeconfig.yaml /ansible/
COPY templates /ansible/templates/

CMD ["ansible-playbook", "/ansible/printkubeconfig.yaml"]
