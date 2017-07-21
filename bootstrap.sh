r!/usr/bin/env bash

apt-get update
#apt-get -y upgrade
#install new kernel?

apt -y install docker.io

curl -sL http://repos.mesosphere.com/ubuntu/pool/main/m/mesos/mesos_1.3.0-2.0.3.ubuntu1610_amd64.deb > /tmp/mesos_1.3.0-2.0.3.ubuntu1610_amd64.deb
apt -y install /tmp/mesos_1.3.0-2.0.3.ubuntu1610_amd64.deb

# remove openjdk-9 as it conflicts with zookeeper
# removing openjdk-9 will install openjdk-8 automatically
apt -y remove openjdk-9-jre-headless

echo "zk://localhost:2181/mesos" >> /etc/mesos/zk
echo "/var/lib/mesos" >> /etc/mesos/work_dir

curl -sL http://downloads.mesosphere.com/marathon/v1.4.5/marathon-1.4.5.tgz | tar -xz
mv marathon-1.4.5 marathon

# allow default user to use docker
usermod -aG docker vagrant

curl -sL https://github.com/docker/compose/releases/download/1.14.0/docker-compose-`uname -s`-`uname -m` > /usr/bin/docker-compose
chmod a+x /usr/bin/docker-compose

service zookeeper restart

# for some reason mesos-slave does not really work well with cilium
# we will use mesos-agent instead
service mesos-slave stop

service mesos-master restart

tar xzvf allfiles.tar.gz
rm allfiles.tar.gz

IFACE=enp0s3 docker-compose up -d

while [[ -z $cilium_docker ]]; do
        sleep 1
        cilium_docker=$(docker ps -a -q --filter="ancestor=cilium/cilium:latest" --filter="status=running")
done

# copy cilium from container to host
mkdir /home/vagrant/bin
docker cp $cilium_docker:/usr/bin/cilium bin/cilium
docker exec $cilium_docker ./cni-install.sh
echo 'PATH=$PATH:/home/vagrant/bin' >> /home/vagrant/.bashrc

chown -R vagrant:vagrant /home/vagrant/
