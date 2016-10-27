# copy the chefdk for the target build node onto the automate server

remote_file "/opt/delivery/#{node['automate']['chefdk']['redhat']}" do
  source "file:///mnt/share/chef/#{node['automate']['chefdk']['redhat']}"
  owner 'root'
  group 'root'
  mode 00755
  only_if { ::File.directory?("#{node['automate']['kitchen_shared_folder']}") }
  # checksum 'abc123'
end

# install supermarket certificate

bash 'fetch supermarket certificates' do
  user 'root'
  cwd '/var/tmp'
  code <<-EOH
  knife ssl fetch #{node['automate']['supermarket_server_fqdn']}
  EOH
end

# copy supermarket to correct location, where automate expects it

bash 'copy supermarket certificate' do
  user 'root'
  cwd '/var/tmp'
  code <<-EOH
  cp /root/.chef/trusted_certs/*.crt /opt/delivery
  EOH
end

# Copy the myorg_sshkey to builder_ssh.  Need this needs some work
# as it is already on the share from the default recipe
# seems that it is hard coded as "builder_key" for the  install-build-node

remote_file "/etc/delivery/builder_key" do
  source "file:///etc/delivery/#{node['automate']['organisation']}_ssh_key"
  owner 'root'
  group 'root'
  mode 00755
  # checksum 'abc123'
end

# Copy the srv-delviery.pen key to builder_ssh.  Need this needs some work
# as it is already on the share from the default recipe
# seems that it is hard coded as "delivery.pem" for the  install-build-node


remote_file "/etc/delivery/delivery.pem" do
  source "file:///etc/delivery/#{node['automate']['chef_user_private_key']}"
  owner 'root'
  group 'root'
  mode 00755
  # checksum 'abc123'
end


# install build node

bash 'install build node' do
  user 'root'
  cwd '/var/tmp'
  code <<-EOH
  delivery-ctl install-build-node --fqdn "#{node['automate']['build_node']['fqdn']}" --username "#{node['automate']['build_node']['username']}" --password "#{node['automate']['build_node']['password']}" --installer "#{node['automate']['build_node']['installer']}" --port "#{node['automate']['build_node']['port']}"
  EOH
end
