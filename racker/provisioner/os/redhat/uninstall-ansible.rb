Racker::Processor.register_template do |t|
  
  t.provisioners = {
    799 => {
      'uninstall-ansible' => {
        'type'            => 'shell',
        'execute_command' => "chmod +x {{ .Path }}; {{ .Vars }} {{user `execute_command_sudo`}} '{{ .Path }}'",
        'script'          => 'bits/scripts/os/redhat/uninstall-ansible.sh'
      },
    },
  }
end
