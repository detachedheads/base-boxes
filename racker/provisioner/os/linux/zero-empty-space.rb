Racker::Processor.register_template do |t|
  
  t.provisioners = {
    900 => {
      'zero-empty-space' => {
        'type'            => 'shell',
        'execute_command' => "chmod +x {{ .Path }}; {{ .Vars }} {{user `execute_command_sudo`}} '{{ .Path }}'",
        'script'          => 'bits/scripts/os/linux/zero-empty-space.sh',
      },
    }
  }
end
