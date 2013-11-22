Vagrant.configure("2") do |config|
  config.vm.box = "precise32"
  config.vm.define :neo01 do |neo|   
    neo.vm.network :private_network, ip: "192.168.100.101"
    neo.vm.network :forwarded_port, host: 4569, guest: 8080
  end
  config.vm.provision :shell, :path => "deploy/deploy.sh"
end
