# the default location for files for our kitchen setup is in a local share
# ~/chef-kits/chef.  This is mounted to /mnt/share/chef on the target vm
# if you alreddy have these in an rpm repo, set source_files to false
# You can also replae file:// with https:// for remote repos.
default['automate']['use_package_manager'] = false
default['automate']['base_package_url'] = 'file:///mnt/share/chef'
default['automate']['kitchen_shared_folder'] = '/mnt/share/chef'
default['delivery_server']['packages']['delivery'] = 'delivery-0.5.370-1.el7.x86_64.rpm'
