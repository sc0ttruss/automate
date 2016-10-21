#
# Cookbook Name:: automate
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# install rpm package(s)
node['automate']['packages'].each do |name, versioned_name|
  unless node['automate']['use_package_manager']
    remote_file "/var/tmp/#{versioned_name}" do
      source "#{node['automate']['base_package_url']}/#{versioned_name}"
    end
  end
  package name do
    unless node['automate']['use_package_manager']
      source "/var/tmp/#{versioned_name}"
    end
    action :install
  end
end # Loop

# Getting and installing a license file

directory '/var/opt/delivery/license' do
  action :create
end


remote_file '/var/opt/delivery/license/delivery.license' do
  source "#{node['automate']['base_package_url']}/delivery.license"
  owner 'root'
  group 'root'
end

directory '/etc/delivery' do
  owner 'root'
  group 'root'
  mode 00755
  recursive true
  action :create
end

# Create a basic Delivery Configuration

template '/etc/delivery/delivery.rb' do
  source 'delivery.rb.erb'
  owner 'root'
  group 'root'
  mode 00755
end

remote_file '/etc/delivery/srv-delivery.pem' do
  # source 'http://myfile'
  source "#{node['automate']['base_package_url']}/srv-delivery.pem"
  owner 'root'
  group 'root'
  mode 00755
  # checksum 'abc123'
end

bash 'reconfigure delivery' do
  user 'root'
  cwd '/var/tmp'
  code <<-EOH
  delivery-ctl reconfigure
  EOH
end

# Creating the Delivery Enterprise/Org(s)

bash 'generate Enterprise SSH credentials' do
  user 'root'
  cwd '/var/tmp'
  code <<-EOH
  cd /etc/delivery
  ssh-keygen -f #{node['automate']['organisation']}_ssh_key
  EOH
  not_if { ::File.exist? "/etc/delivery/#{node['automate']['organisation']}_ssh_key" }
end

# copy credentials somewhere safe, needs more work,
# will be fine in testkitchen, but nowhere else

remote_file "/mnt/share/chef/#{node['automate']['organisation']}_ssh_key.pub" do
  # source 'http://myfile'
  source "file:///etc/delivery/#{node['automate']['organisation']}_ssh_key.pub"
  owner 'root'
  group 'root'
  mode 00755
  # checksum 'abc123'
end

remote_file "/mnt/share/chef/#{node['automate']['organisation']}_ssh_key" do
  # source 'http://myfile'
  source "file:///etc/delivery/#{node['automate']['organisation']}_ssh_key"
  owner 'root'
  group 'root'
  mode 00755
  # checksum 'abc123'
end

# Copy the myorg key to builder_ssh.  Need to fix this on docs and build node

remote_file "/mnt/share/chef/builder_key" do
  # source 'http://myfile'
  source "file:///etc/delivery/#{node['automate']['organisation']}_ssh_key"
  owner 'root'
  group 'root'
  mode 00755
  # checksum 'abc123'
end

# Create the Enterprise

bash 'create the delivery Enterprise' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  delivery-ctl create-enterprise #{node['automate']['organisation']} --ssh-pub-key-file=/etc/delivery/#{node['automate']['organisation']}_ssh_key.pub > /etc/delivery/passwords.txt
  EOH
  not_if "delivery-ctl list-enterprises |grep #{node['automate']['organisation']}"
end

remote_file '/mnt/share/chef/passwords.txt' do
  source 'file:///etc/delivery/passwords.txt'
  owner 'root'
  group 'root'
  mode 00755
  only_if { ::File.directory?("#{node['automate']['kitchen_shared_folder']}") }
  # checksum 'abc123'
end

# Create the enterprise User, delivery

bash 'create the delivery Enterprise user' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  delivery-ctl create-user #{node['automate']['enterprise']} srv-delivery > /etc/delivery/deliverypassword.txt
  EOH
  # not_if "delivery-ctl list-enterprises |grep #{node['automate']['organisation']}"
end

remote_file '/mnt/share/chef/deliverypassword.txt' do
  source 'file:///etc/delivery/deliverypassword.txt'
  owner 'root'
  group 'root'
  mode 00755
  only_if { ::File.directory?("#{node['automate']['kitchen_shared_folder']}") }
    # checksum 'abc123'
  end
