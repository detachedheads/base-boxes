Racker::Processor.register_template do |t|
  
  t.provisioners = {
    500 => {
      'ansible-playbook' => {
        'type'            => 'ansible-local',
        #'galaxy_file'     => 'bits/ansible/galaxy.yml',
        'playbook_dir'    => 'bits/ansible',
        'playbook_file'   => '{{user `ansible_playbook`}}',
      },
    },
  }
end
