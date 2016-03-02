mkdir /tmp/k8s
wget https://github.com/kubernetes/kubernetes/archive/v$1.tar.gz -O /tmp/k8s/k8s.tar.gz
cd /tmp/k8s
tar -xvzf k8s.tar.gz
export GOPATH=/tmp/gopath
export PATH=$PATH:$GOPATH/bin
mkdir -p $GOPATH/src/k8s.io
mv kubernetes-$1 $GOPATH/src/k8s.io/kubernetes
cd $GOPATH/src/k8s.io/kubernetes/cmd/kubectl
go get github.com/tools/godep
CGO_ENABLED=0 godep go build -o /bin/kubectl
rm -rf $GOPATH/src /tmp/k8s
