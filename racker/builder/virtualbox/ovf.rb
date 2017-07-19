Racker::Processor.register_template do |t|

  t.builders['builder'] = {
    'boot_wait'                 => '10s',
    'format'                    => 'ova',
    'guest_additions_mode'      => 'disable',
    'headless'                  => '{{ user `headless`}}',
    'http_directory'            => 'bits',
    'http_port_min'             => 20000,
    'http_port_max'             => 21000,
    'output_directory'          => 'output/{{user `vm_name`}}',
    'source_path'               => 'output/packer-{{ user `source_box` }}/packer-{{ user `source_box` }}.ova',
    'ssh_port'                  => 22,
    'ssh_username'              => 'root',
    'ssh_password'              => 'default',
    'ssh_wait_timeout'          => '10000s',
    'shutdown_command'          => '{{user `shutdown_command`}}',
    'type'                      => 'virtualbox-ovf',
    'vboxmanage'                => {
      'memory'  => [ 'modifyvm', '{{.Name}}', '--memory',    '2048' ],
      'cpus'    => [ 'modifyvm', '{{.Name}}', '--cpus',      '2' ],
      'ioapic'  => [ 'modifyvm', '{{.Name}}', '--ioapic',    'on' ]
    },
    'virtualbox_version_file'   => '.vbox_version',
    'vm_name'                   => '{{user `vm_name`}}',
  }
end
