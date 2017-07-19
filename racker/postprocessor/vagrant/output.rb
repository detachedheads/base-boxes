Racker::Processor.register_template do |t|
  
  t.postprocessors['postprocessor'] = {
    'compression_level'   => 7,
    'keep_input_artifact' => false,
    'output'              => '{{user `bb_output_file`}}',
    'type'                => 'vagrant',
  }
end
