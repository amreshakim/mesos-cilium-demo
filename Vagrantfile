Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-16.10"
  config.vm.provision "file", source: "./allfiles.tar.gz", destination: "./allfiles.tar.gz"
  config.vm.provision :shell, path: "bootstrap.sh", env: {"HOST_IP" => "192.168.100.10"} 
  config.vm.network "forwarded_port", guest: 8080, host: 8080
  config.vm.network "private_network", ip: "192.168.100.10"
  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
  end
end


