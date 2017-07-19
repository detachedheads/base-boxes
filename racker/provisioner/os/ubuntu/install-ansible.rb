Racker::Processor.register_template do |t|
  
  t.provisioners = {
    400 => {
      'install-ansible' => {
        'type'            => 'shell',
        'execute_command' => "chmod +x {{ .Path }}; {{ .Vars }} {{user `execute_command_sudo`}} '{{ .Path }}'",
        'script'          => 'bits/scripts/os/ubuntu/install-ansible.sh'
      },
    },
  }
end
