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
