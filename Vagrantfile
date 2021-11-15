# -*- mode: ruby -*-
# vi: set ft=ruby :

# prereqs
# * vagrant plugin install vagrant-vbguest
# * vagrant plugin install vagrant-reload
# * vagrant plugin install vagrant-host-shell
# * vagrant plugin install vagrant-timezone




Vagrant.configure("2") do |config|

  config.vbguest.installer_options = { allow_kernel_upgrade: true }
  config.vbguest.auto_update = false

  config.timezone.value = "UTC"
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true
  config.vm.define "adfs", autostart: false do |adfs|
    adfs.vbguest.auto_update = true
    adfs.vm.box = "StefanScherer/windows_2019"
    adfs.vm.hostname = "adfs"
    adfs.hostmanager.aliases = %w(adfs.devel)

    adfs.vm.communicator = "winrm"
  #  adfs.vm.network :forwarded_port, guest: 5985, host: 5985, id: "winrm"
  #  adfs.vm.network :forwarded_port, guest: 22, host: 2222, id: "ssh"
    adfs.vm.network :forwarded_port, guest: 443, host: 4443, id: "https"
    adfs.vm.network :private_network, ip: "192.168.38.2"
    adfs.winrm.transport = :plaintext
    adfs.winrm.basic_auth_only = true

    #adfs.vm.provision "shell", path: "scripts/fix-second-network.ps1", privileged: false, args: "192.168.38.2"
    adfs.vm.provision "shell", path: "scripts/adfs-create-domain.ps1", privileged: true

    adfs.vm.provision :host_shell do |host_shell|
      host_shell.inline = 'sleep 10'
    end

    adfs.vm.provision "reload"
    adfs.vm.provision "shell", path: "scripts/adfs-install.ps1", privileged: true

    adfs.vm.provision :host_shell do |host_shell|
      host_shell.inline = 'sleep 10'
    end
    adfs.vm.provision "reload"
    adfs.vm.provision "shell", path: "scripts/adfs-setup.ps1", privileged: true

    adfs.vm.provision :host_shell do |host_shell|
      host_shell.inline = 'sleep 10'
    end
    adfs.vm.provision "reload"

    adfs.vm.provision "shell", path: "scripts/add-adfs-users.ps1", privileged: true
    adfs.vm.provision "shell", path: "scripts/configure-adfs-keycloak-relying-party.ps1", privileged: true

    adfs.vm.provision :shell, path: "scripts/wait-for-ad.ps1", run: "always"


    adfs.vm.provider "virtualbox" do |vb, override|
      vb.gui = true
      vb.customize ["modifyvm", :id, "--memory", 1500]
      vb.customize ["modifyvm", :id, "--cpus", 2]
      vb.customize ["modifyvm", :id, "--vram", "32"]
      vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      vb.customize ["setextradata", "global", "GUI/SuppressMessages", "all" ]
    end
  end
  config.vm.define "keycloak", autostart: false do |kc|
    kc.vm.box = "centos/7"
    kc.vm.provider "virtualbox" do |v|
      v.memory = 512
      v.cpus = 1
    end


    kc.vm.hostname = "keycloak"
    kc.vm.network :private_network, ip: "192.168.38.3"

    kc.vm.provision :shell, path: "scripts/keycloak-setup.sh"
    kc.vm.provision :shell, path: "scripts/keycloak-start.sh", run: "always"
    kc.vm.provision :shell, path: "scripts/keycloak-configure-oidc.sh"

  end
  config.vm.define "react", autostart: false do |r|

    r.vm.box = "centos/7"
    r.vm.provider "virtualbox" do |v|
      v.memory = 512
      v.cpus = 1
    end

    r.vm.hostname = "react"
    r.vm.network :private_network, ip: "192.168.38.4"

    r.vm.provision :shell, path: "scripts/install-react-demo.sh", privileged: true
    r.vm.provision :shell, path: "scripts/start-react-demo.sh", run: "always", privileged: true

  end
end
