Racker::Processor.register_template do |t|
  
  t.builders['builder'] = {
    'boot_wait'                 => '10s',
    'disk_size'                 => '{{user `disk_size_long`}}',
    'format'                    => 'ova',
    'guest_additions_path'      => 'VBoxGuestAdditions.iso',
    # This needs to be specified by an OS_TEMPLATE
    'guest_os_type'             => nil,
    'hard_drive_interface'      => 'sata',
    'headless'                  => '{{ user `headless`}}',
    'iso_checksum'              => '{{user `iso_checksum`}}',
    'iso_checksum_type'         => '{{user `iso_checksum_type`}}',
    'iso_url'                   => '{{user `iso_url`}}',
    'http_directory'            => 'bits',
    'http_port_min'             => 20000,
    'http_port_max'             => 21000,
    'output_directory'          => 'output/{{user `bb_vm_name`}}',
    'ssh_port'                  => 22,
    'ssh_username'              => 'root',
    'ssh_password'              => 'default',
    'ssh_wait_timeout'          => '10000s',
    'shutdown_command'          => '{{user `shutdown_command`}}',
    'type'                      => 'virtualbox-iso',
    'vboxmanage'                => {
      'memory'  => [ 'modifyvm', '{{.Name}}', '--memory',    '2048' ],
      'cpus'    => [ 'modifyvm', '{{.Name}}', '--cpus',      '2' ],
      'ioapic'  => [ 'modifyvm', '{{.Name}}', '--ioapic',    'on' ]
    },
    'virtualbox_version_file'   => '.vbox_version',
  }
end