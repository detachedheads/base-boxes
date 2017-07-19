Racker::Processor.register_template do |t|

  # Define the variables
  t.variables = {
    'current_date'                      => Time.now.strftime("%Y-%m-%d"),
    'disk_size_long'                    => '25600',
    'disk_size_short'                   => '25',
    'execute_command_sudo'              => '',
    'hostname'                          => 'localhost',
    'iso_checksum'                      => '737ae7041212c628de5751d15c3016058b0e833fdc32e7420209b76ca3d0a535',
    'iso_checksum_type'                 => 'sha256',
    'iso_url'                           => 'http://releases.ubuntu.com/16.04/ubuntu-16.04.2-server-amd64.iso',
    'config_file'                       => 'preseed/ubuntu-16.04.cfg',
    'shutdown_command'                  => 'sudo systemctl poweroff',
  }
end
