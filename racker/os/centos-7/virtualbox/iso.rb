Racker::Processor.register_template do |t|

  t.builders['builder'] = {
    'boot_command'              => {
      0 => '<esc><wait> linux ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/{{user `config_file`}} <enter><wait>'
    },
    'guest_os_type'             => 'RedHat_64',
  }
end
