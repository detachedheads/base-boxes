Racker::Processor.register_template do |t|

  t.builders['builder'] = {
    'boot_command'              => {
      0  => '<enter><wait>',
      1  => '<f6><esc>',
      2  => '<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>',
      3  => '<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>',
      4  => '<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>',
      5  => '<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>',
      6  => '<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>',
      7  => '<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>',
      8  => '<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>',
      9  => '<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>',
      10 => '<bs><bs><bs>',
      11 => '/install/vmlinuz ',
      12 => 'initrd=/install/initrd.gz ',
      13 => 'net.ifnames=0 ',
      14 => 'auto-install/enable=true ',
      15 => 'debconf/priority=critical ',
      16 => 'preseed/url=http://{{.HTTPIP}}:{{.HTTPPort}}/{{user `config_file`}}',
      17  => '<enter>'
    },
    'guest_os_type'             => 'ubuntu-64',
  }
end
