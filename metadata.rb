maintainer 'Achim Rosenhagen'
maintainer_email 'a.rosenhagen@ffuenf.de'
license 'Apache 2.0'
description 'installs/configures mageteststand'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
name 'mageteststand'
version '1.0.0'

%w( debian ubuntu ).each do |os|
  supports os
end

%w(
  ssh_known_hosts
  chef-sugar
  dotdeb
  redisio
  mysql
  mysql2_chef_gem
  php
  phpunit
  magerun
  modman
  java
  selenium_grid
).each do |ressource|
  depends ressource
end