Racker::Processor.register_template do |t|
  
  t.postprocessors['postprocessor'] = [
    {
      'compression_level'   => 7,
      'keep_input_artifact' => false,
      'output'              => '{{user `bb_output_file`}}',
      'type'                => 'vagrant',
    },  
    {
      'access_token'        => '{{ user `vagrant_cloud_token`}}',
      'box_tag'             => 'detachedheads/{{ user `bb_box_name`}}',
      'no_release'          => 'true',
      'type'                => 'vagrant-cloud',
      'version'             => '{{ user `version`}}',
    }
  ]
 end
