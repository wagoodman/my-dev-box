# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'
settings = YAML.load_file(File.join(__dir__, 'vagrant.yml'))

localpath = settings[:synced_folder][:localpath]
guestpath = settings[:synced_folder][:guestpath]
if settings.key?(:hardware)
  cpus = settings[:hardware][:cpus]
  memory = settings[:hardware][:memory]
else
  cpus = 1
  memory = 4096
end

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Ubuntu 14.04
config.vm.box = "ubuntu/trusty64"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:4000" will access port 80 on the guest machine.
  config.vm.network :forwarded_port, guest: 80, host: 4000

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network :private_network, ip: "192.168.33.10"

  # The hostname the machine should have. If set to a string, the hostname
  # will be set on boot.
  #config.vm.hostname = "vm.example.com"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network :public_network

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  config.ssh.forward_agent = true

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.

  config.vm.synced_folder localpath, guestpath

  config.vm.provider :virtualbox do |vb|
    # Use VBoxManage to customize the VM. For example to change memory:
    vb.cpus = cpus
    vb.memory = memory
    vb.customize ["modifyvm", :id, "--ioapic", "on"]
  end

  config.omnibus.chef_version = "11.12.8"

  # Enable provisioning with chef solo, specifying a cookbooks path, roles
  # path, and data_bags path (all relative to this Vagrantfile), and adding
  # some recipes and/or roles.

  config.vm.provision :chef_solo do |chef|
    # custom JSON attributes:
    chef.json = {
	"java" => {
        "install_flavor" => "oracle",
        "jdk_version" => "8",
        "oracle" => {"accept_oracle_download_terms" => true}
      },
  	"postgresql" => {
        "version" => "9.3",
        "apt_distribution" => "trusty",
				"conf" => {
        "listen_addresses" => "*",
        "log_error_verbosity" => "verbose",
        "log_connections" => "on",
        "log_min_error_statement" => "info",
        "log_min_duration_statement" => "0"
        },
            "pg_hba" =>[
          { "type" => "local", "db" => "all", "user" => "postgres", "addr" => nil, "method" => "ident"},
          { "type" => "local", "db" => "all", "user" => "all", "addr" => nil, "method" => "ident"},
          { "type" => "host", "db" => "all", "user" => "all", "addr" => "0.0.0.0/0", "method" => "md5"},
          { "type" => "host", "db" => "all", "user" => "all", "addr" => "::1/128", "method" => "md5"},
          { "type" => "local", "db" => "all", "user" => "all", "addr" => nil, "method" => "ident"},
        ]
      },
	     "rvm" => {"default_ruby" => "ruby-2.1.2"},
    }

    chef.add_recipe "apt"
    chef.add_recipe "build-essential"
    chef.add_recipe "java"
    chef.add_recipe "postgresql::client"
    chef.add_recipe "postgresql::server"
    chef.add_recipe "python"
    chef.add_recipe "yum"
    chef.add_recipe "rvm::system"
    chef.add_recipe "rvm::vagrant"
    chef.add_recipe "ruby_dev"
    chef.add_recipe "passenger_nginx"
    chef.add_recipe "nodejs"
    chef.add_recipe "phantomjs"
    chef.add_recipe "libreoffice"
  end

end
