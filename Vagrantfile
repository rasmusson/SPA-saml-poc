# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define "adfs", autostart: false do |cfg|
    cfg.vm.box = "StefanScherer/windows_2019"
    cfg.vm.hostname = "adfs"

    cfg.vm.communicator = "winrm"
    cfg.vm.network :forwarded_port, guest: 5985, host: 5985, id: "winrm", auto_correct: true
    cfg.vm.network :forwarded_port, guest: 22, host: 2222, id: "ssh", auto_correct: true
    cfg.vm.network :forwarded_port, guest: 3389, host: 3389, id: "rdp", auto_correct: true
    cfg.vm.network :private_network, ip: "192.168.1.3", gateway: "192.168.1.1"

    cfg.vm.provision "shell", path: "scripts/adfs-setup", privileged: true

    cfg.vm.provider "virtualbox" do |vb, override|
      vb.gui = true
      vb.customize ["modifyvm", :id, "--memory", 768]
      vb.customize ["modifyvm", :id, "--cpus", 1]
      vb.customize ["modifyvm", :id, "--vram", "32"]
      vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      vb.customize ["setextradata", "global", "GUI/SuppressMessages", "all" ]
    end
  end
  config.vm.define "keycloak", autostart: false do |cfg|

    config.vm.box = "centos/7"
    config.vm.provider "virtualbox" do |v|
      v.memory = 2048
      v.cpus = 2
    end

    config.vm.hostname = "keycloak"
    config.vm.network "forwarded_port", guest: 9990, host: 9990
    config.vm.network "forwarded_port", guest: 8080, host: 8080

  config.vm.provision :shell, path: "scripts/keycloak-setup.sh"
  config.vm.provision :shell, path: "scripts/keycloak-start.sh", run: "always"

  end
end
