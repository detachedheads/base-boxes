Racker::Processor.register_template do |t|

  # Define the variables
  t.variables = {
    'current_date'                      => Time.now.strftime("%Y-%m-%d"),
    'disk_size_long'                    => '25600',
    'disk_size_short'                   => '25',
    'execute_command_sudo'              => '',
    'hostname'                          => 'localhost',
    'iso_checksum'                      => '27bd866242ee058b7a5754e83d8ee8403e216b93d130d800852a96f41c34d86a',
    'iso_checksum_type'                 => 'sha256',
    'iso_url'                           => 'http://mirror.rackspace.com/CentOS/7/isos/x86_64/CentOS-7-x86_64-Minimal-1611.iso',
    'config_file'                       => 'kickstart/centos-7.ks',
    'shutdown_command'                  => 'sudo /sbin/shutdown -P now',
  }
end
