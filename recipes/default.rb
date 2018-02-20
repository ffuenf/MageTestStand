#
# Cookbook Name:: mageteststand
# Recipe:: default
#

include_recipe 'chef-sugar'
include_recipe 'php'
include_recipe 'php::xdebug'

ssh_known_hosts_entry 'github.com'

php_fpm "mageteststand" do
  user 'www-data'
  group 'www-data'
  catch_workers_output true
  action :add
end

mysql2_chef_gem 'mageteststand' do
  action :install
end

mysql_service 'mageteststand' do
  version node['mysql']['version']
  bind_address node['mysql']['bind_address']
  port node['mysql']['port']
  initial_root_password node['mysql']['server_root_password']
  action [:create, :start]
end

mysql_client 'mageteststand' do
  action :create
end
