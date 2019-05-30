Racker::Processor.register_template do |t|

  # Define the variables
  t.variables = {
    'current_date'                      => Time.now.strftime("%Y-%m-%d"),
    'disk_size_long'                    => '25600',
    'disk_size_short'                   => '25',
    'execute_command_sudo'              => '',
    'hostname'                          => 'localhost',
    'iso_checksum'                      => 'a2cb36dc010d98ad9253ea5ad5a07fd6b409e3412c48f1860536970b073c98f5',
    'iso_checksum_type'                 => 'sha256',
    'iso_url'                           => 'http://cdimage.ubuntu.com/ubuntu/releases/bionic/release/ubuntu-18.04.2-server-amd64.iso',
    'config_file'                       => 'preseed/ubuntu-18.04.cfg',
    'shutdown_command'                  => 'sudo systemctl poweroff',
    'vagrant_cloud_token'               => '{{ env `VAGRANT_CLOUD_TOKEN`}}',
    'version'                           => '1.0.{{isotime "20060102"}}',
  }
end
