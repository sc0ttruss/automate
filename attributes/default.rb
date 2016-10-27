# the default location for files for our kitchen setup is in a local share
# ~/chef-kits/chef.  This is mounted to /mnt/share/chef on the target vm
# if you alreddy have these in an rpm repo, set source_files to false
# You can also replae file:// with https:// for remote repos.
default['automate']['use_package_manager'] = false
default['automate']['base_package_url'] = 'file:///mnt/share/chef'
default['automate']['kitchen_shared_folder'] = '/mnt/share/chef'
# default['automate']['base_packate_url'] = 'delivery-0.5.370-1.el7.x86_64.rpm'
default['automate']['packages']['delivery'] = 'delivery-0.5.432-1.el7.x86_64.rpm'
# note the package "name" must match the name used by yum/rpm etc.
# get your package list here https://packages.chef.io/stable/el/7/
default['automate']['enterprise'] = 'myorg'
default['automate']['organisation'] = 'myorg'
default['automate']['delivery_license'] = 'delivery.license'
default['automate']['chef_username'] = 'srv-delivery'
default['automate']['chef_user_private_key'] = 'srv-delivery.pem'
default['automate']['delivery_org_key'] = "#{node['automate']['organisation']}_ssh_key"
default['automate']['url_chef'] = 'https://chef.myorg.chefdemo.net'
default['automate']['url']['delivery'] = 'automate.myorg.chefdemo.net'
# need chefdk, for noww only one target platform ( RHEL 7.2 )
# but will add others over time,  Used by install-build-node command
default['automate']['chefdk']['redhat'] = 'chefdk-0.19.6-1.el7.x86_64.rpm'
# Parameters for build node(s)
default['automate']['build_node']['fqdn'] = 'builder1.myorg.chefdemo.net'
default['automate']['build_node']['username'] = 'vagrant'
default['automate']['build_node']['password'] = 'vagrant'
default['automate']['build_node']['installer'] = "/opt/delviery/#{node['automate']['chefdk']['redhat']}"
default['automate']['build_node']['ssh_identity_file'] = ''
default['automate']['build_node']['port'] = '22'

--fqdn --username --password --installer --ssh-identity-file --port
