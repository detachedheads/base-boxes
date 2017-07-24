Racker::Processor.register_template do |t|
  
  t.provisioners = {
    925 => {
      'apt-upgrade' => {
        'type'            => 'shell',
        'execute_command' => "chmod +x {{ .Path }}; {{ .Vars }} {{user `execute_command_sudo`}} '{{ .Path }}'",
        'script'          => 'bits/scripts/os/redhat/yum-clean.sh'
      },
    },
  }
end
