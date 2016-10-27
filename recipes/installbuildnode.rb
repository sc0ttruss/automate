# copy the chefdk for the target build node onto the automate server

remote_file "/opt/delivery/#{node['automate']['chefdk']['redhat']}" do
  source "file:///mnt/share/chef/#{node['automate']['chefdk']['redhat']}"
  owner 'root'
  group 'root'
  mode 00755
  only_if { ::File.directory?("#{node['automate']['kitchen_shared_folder']}") }
  # checksum 'abc123'
end

# install build node

bash 'reconfigure delivery' do
  user 'root'
  cwd '/var/tmp'
  code <<-EOH
  delivery-ctl install-build-node --fqdn "#{node['automate']['build_node']['fqdn']}" --username "#{node['automate']['build_node']['username']}" --password "#{node['automate']['build_node']['password']}" --installer "#{node['automate']['build_node']['installer']}" --ssh-identity-file "#{node['automate']['build_node']['ssh_identity_file']}" --port "#{node['automate']['build_node']['port']}"
  EOH
end
