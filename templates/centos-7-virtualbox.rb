BOX_OS          = 'centos-7'
BOX_OS_SHORT    = 'redhat'
BOX_BUILDER     = 'virtualbox'
BOX_NAME        = File.basename(__FILE__, '.rb') 

USER_VARIABLES        = {
  'ansible_playbook' => 'bits/ansible/playbooks/vagrant-box/main.yml',
  'headless'         => 'false',
  'version_description' => '',
}

TEMPLATE_DEFINITIONS  = [
  # Variables
  File.join(VARIABLES_TEMPLATES,        "os/#{BOX_OS}/general.rb"),

  # Builders
  File.join(BUILDER_TEMPLATES,          "#{BOX_BUILDER}/iso.rb"),           # Bring in the virtualbox iso configuration
  File.join(OS_TEMPLATES,               "#{BOX_OS}/#{BOX_BUILDER}/iso.rb"), # Bring in the centos iso configuration

  # Provisioner - Upgrade all packages
  File.join(PROVISIONER_TEMPLATES,      "os/#{BOX_OS_SHORT}/yum-upgrade.rb"),

  # Provisioner - Install Ansible
  File.join(PROVISIONER_TEMPLATES,      "os/#{BOX_OS_SHORT}/install-ansible.rb"),
  
  # Provisioner - Ansible Provisioning
  File.join(PROVISIONER_TEMPLATES,      'ansible/local-playbook.rb'),

  # Provisioner - Uninstall Ansible
  File.join(PROVISIONER_TEMPLATES,      "os/#{BOX_OS_SHORT}/uninstall-ansible.rb"),
  
  # Provisioner - Clean up yum after everything is finished
  File.join(PROVISIONER_TEMPLATES,      "os/#{BOX_OS_SHORT}/yum-clean.rb"),

  # Provisioner - Cleanup
  File.join(PROVISIONER_TEMPLATES,      'os/linux/zero-empty-space.rb'),
]

# If RELEASE is set push to vagrant cloud
TEMPLATE_DEFINITIONS << if ENV['RELEASE']
  File.join(POSTPROCESSOR_TEMPLATES,    'vagrant-cloud/output.rb')        # Configure the vagrant box output
else
  File.join(POSTPROCESSOR_TEMPLATES,    'vagrant/output.rb')              # Configure the vagrant box output
end
