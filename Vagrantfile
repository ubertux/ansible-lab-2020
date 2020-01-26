# -*- mode: ruby -*-
# vi: set ft=ruby :
VAGRANTFILE_API_VERSION = "2"

lab = {
	"lab-ansible1" => { :box => "centos/8" , :dns => "ansible1.example.com" , :ip => "192.168.4.201", :cpus => 1, :mem => 1024, :script => "centos-managed.sh" },
	"lab-ansible2" => { :box => "centos/8" , :dns => "ansible2.example.com" , :ip => "192.168.4.202", :cpus => 1, :mem => 1024, :script => "centos-managed.sh" },
	"lab-ansible3" => { :box => "centos/8" , :dns => "ansible3.example.com" , :ip => "192.168.4.203", :cpus => 1, :mem => 1024, :script => "centos-managed.sh" },
	"lab-ansible4" => { :box => "ubuntu/bionic64" , :dns => "ansible4.example.com" , :ip => "192.168.4.204", :cpus => 1, :mem => 1024, :script => "ubu-managed.sh" },
	"lab-control" => { :box => "centos/8" , :dns => "control.example.com" , :ip => "192.168.4.200", :cpus => 1, :mem => 1024, :script => "control.sh" },
}

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.ssh.insert_key = false
  config.ssh.forward_agent= true
  config.ssh.forward_x11 = true
  check_guest_additions = false
  functional_vboxsf     = false
  lab.each_with_index do |(lab_node, info), index|
    config.vm.define lab_node do |cfg|
      cfg.vm.provider :virtualbox do |vb, override|
        cfg.vm.box = "#{info[:box]}"
        vb.memory = "#{info[:mem]}"
        vb.cpus = "#{info[:cpus]}"
        cfg.vm.provision "#{lab_node}", type: "shell", path: "#{info[:script]}"
        override.vm.network :private_network, ip: "#{info[:ip]}", :mode => 'bridge'
        override.vm.hostname =  "#{info[:dns]}"
        vb.name = lab_node
        vb.customize ["modifyvm", :id, "--hwvirtex", "on"]
      end # end provider
    end # end config
  end # end lab
end
