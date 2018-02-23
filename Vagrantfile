$setup = <<SCRIPT
  sed -i 's/http.us.debian/ftp.de.debian/g' /etc/apt/sources.list
  sed -i 's/http.us.archive/ftp.de.archive/g' /etc/apt/sources.list
  sed -i 's/us.archive.ubuntu.com/de.archive.ubuntu.com/g' /etc/apt/sources.list
  echo 'Europe/Berlin' | sudo tee /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata >/dev/null
  apt-get update -y -qq
SCRIPT

$mageteststand = <<SCRIPT
  export SKIP_CLEANUP=true
  export WORKSPACE="/vagrant"
  export MAGENTO_VERSION="magento-ce-1.9.3.4"
  export MAGENTO_DB_HOST="127.0.0.1"
  export MAGENTO_DB_PORT="3306"
  export MAGENTO_DB_USER="root"
  export MAGENTO_DB_PASS="mageteststand"
  export MAGENTO_DB_NAME="mageteststand"
  export MAGEDOWNLOAD_ID="YOUR-ID"
  export MAGEDOWNLOAD_TOKEN="YOUR-SECRET-TOKEN"
  curl -sSL https://raw.githubusercontent.com/ffuenf/MageTestStand/master/setup.sh | bash
SCRIPT

$provision = true

Vagrant.configure('2') do |config|
  # vagrant-berkshelf
  config.berkshelf.berksfile_path = 'Berksfile' if Vagrant.has_plugin?('vagrant-berkshelf')
  config.berkshelf.enabled = true if Vagrant.has_plugin?('vagrant-berkshelf')

  # network
  config.vm.network 'private_network', ip: '10.0.0.50'

  # basebox
  config.vm.box = 'ffuenf/debian-9.2.1-amd64'

  # virtualbox options
  config.vm.provider 'virtualbox' do |v|
    v.gui = false
    v.customize ['modifyvm', :id, '--memory', 2048]
    v.customize ['modifyvm', :id, '--cpus', 2]
    v.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
    v.customize ['modifyvm', :id, '--natdnsproxy1', 'on']
    v.customize ['guestproperty', 'set', :id, '--timesync-set-threshold', 10000]
  end

  # setup
  config.vm.provision 'shell', inline: $setup

  # chef
  if $provision then
    config.vm.provision 'chef_zero' do |chef|
      chef.version = '12.21.26'
      chef.provisioning_path = '/tmp/vagrant-chef'
      chef.file_cache_path = '/var/chef/cache'
      chef.cookbooks_path = ['.']
      chef.roles_path = '.'
      chef.nodes_path = '.'
      chef.environments_path = '.'
      chef.add_recipe 'mageteststand'
      chef.json = {
        "php" => {
          "xdebug" => {
            "cli" => {
              "enabled" => "true"
            }
          }
        },
        "dotdeb" => {
          "php_version" => "7.0"
        },
        "mysql" => {
          "version" => "5.7",
          "bind_address" => "127.0.0.1",
          "port" => "3306",
          "server_root_password" => "mageteststand"
        }
      }
    end
  end
  config.vm.provision 'shell', inline: $mageteststand
end
