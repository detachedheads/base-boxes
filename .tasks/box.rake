require 'benchmark'
require 'colorize'
require 'filesize'
require 'pathname'

require_relative 'lib/bb'

namespace :box do

  desc 'Build a base-box'
  task :build, :name do |t, args|
    # Validate the template
    BB.validate_template(args.name)

    # Build the Packer template with Racker
    packer_template = BB::Racker.generate_packer_template(TEMPLATE_DEFINITIONS)

    # Merge the user variables with the provider specific ones
    variables = USER_VARIABLES.merge(BB::Racker.generate_provider_specific_variables(args.name))

    # Build the variables string from the template
    expanded_variables = variables.map{ |k,v| "-var #{k}=#{v}"}.join(' ')

    # Build the packer command
    packer_command = "#{PACKER_BIN} build --force #{expanded_variables} \"#{packer_template}\""

    # Print the packer command if in debug mode
    if defined?(::DEBUG) && ::DEBUG
      puts "Packer command to be executed:"
      puts packer_command
      puts
    end

    # Start the Packer run
    puts "Starting Packer @ #{Time.now.inspect}..."
    puts ''
    puts "Packer template is available here: #{packer_template}"
    puts ''
    return_value = nil
    results = Benchmark.measure do
      puts packer_command if DEBUG
      system packer_command
      return_value = $?
    end

    unless return_value.nil?
      time_str = "#{seconds_to_units(results.real)}"

      # Get the resulting box file name
      box_file = BB::Racker.generate_packer_box_name(args.name)  
      
      puts
      puts 'Packing Statistics:'
      puts 'Duration:   ' + (return_value.exitstatus == 0 ? time_str.green : time_str.red)
      
      if File.exists?(box_file) && return_value.exitstatus == 0
        size = File.stat(box_file).size

        # Print the output file size if the pack was successful
        puts "Box Size:   " + Filesize.from("#{size} B").pretty.green
      end

      exit return_value.exitstatus
    end
  end

  desc 'Deploy the artifact to the target repository'
  task :deploy, :name do |t, args|
    # Validate the template
    BB.validate_template(args.name)

    # Build the Packer template with Racker
    packer_template = BB::Racker.generate_packer_template(TEMPLATE_DEFINITIONS)

    
    # # Load and validate the template definition
    # load_and_validate_template_definition(args.box)

    # raise 'The given template is not enabled for S3 deployment' unless S3_DEPLOYABLE

    # # Connect to s3
    # s3 = AWS::S3.new(
    #   :access_key_id      => ENV['AWS_ACCESS_KEY'],
    #   :secret_access_key  => ENV['AWS_SECRET_KEY']
    # )

    # # Get the bucket
    # bucket = s3.buckets[S3_BUCKET]

    # puts "Connected to s3 bucket: #{S3_BUCKET}"

    # # Get the box file name
    # box_file = PE::Racker.generate_packer_box_name(BOX_NAME)

    # # Get the pathname for the boxfile
    # box_file_path = Pathname.new(box_file)

    # puts "Verifying S3 connection..."

    # # Get the s3 object for the file
    # object = bucket.objects[box_file_path.basename]

    # puts "Writing #{box_file_path.basename} to S3..."

    # # Write the file to the bucket
    # results = Benchmark.measure do
    #   object.write(box_file_path)
    # end
  
    # puts "Successfully transferred #{box_file_path.basename} to S3".green
    # puts "#{seconds_to_units(results.real)}".green
  end

  desc 'Inspect the template specified by the given arguments'
  task :inspect, :name do |t, args|
    # Validate the template
    BB.validate_template(args.name)

    # Build the Packer template with Racker
    packer_template = BB::Racker.generate_packer_template(TEMPLATE_DEFINITIONS)

    # Inspect the template
    system "#{PACKER_BIN} inspect \"#{packer_template}\""
  end

  desc 'Launch a given base-box if it exists'
  task :launch, :name do |t, args|
    # Erubis a Vagrantfile using the local box
  end

  desc 'Register the box specified with the local Vagrant'
  task :register, :name do |t, args|
    # Validate the template
    BB.validate_template(args.name)

    # Get the resulting box file name
    box_file = BB::Racker.generate_packer_box_name(args.name)
  
    # Unregister the box with vagrant
    vagrant_unregister(BOX_NAME, BOX_BUILDER)
    
    # Register the box with vagrant
    vagrant_register(BOX_NAME, box_file, BOX_BUILDER)
  end

  desc 'Display the template specified by the given arguments'
  task :template, :name do |t, args|
    require 'json'

    # Validate the template
    BB.validate_template(args.name)

    # Build the Packer template with Racker
    packer_template = BB::Racker.generate_packer_template(TEMPLATE_DEFINITIONS)

    # Print the template
    puts JSON.pretty_generate(JSON.parse(File.read(packer_template)))
  end

  desc 'List the available template definitions'
  task :list do
    Dir.entries(RACKER_TEMPLATES).select do |f|
      # Ignore directories
      next if File.directory? f

      # Output the base box name
      puts File.basename(f, File.extname(f))
    end
  end

  private

  def seconds_to_units(seconds)
    '%d days, %d hours, %d minutes, %d seconds' %
      # the .reverse lets us put the larger units first for readability
      [24,60,60].reverse.inject([seconds]) {|result, unitsize|
        result[0,0] = result.shift.divmod(unitsize)
        result
      }
  end

  def vagrant_register(box_name, box_file, provider)
    system "vagrant box add #{VAGRANT_BOX_PREFIX}#{box_name} #{box_file} --provider #{provider}"
  end

  def vagrant_unregister(box_name, provider)
    system "vagrant box remove #{VAGRANT_BOX_PREFIX}#{box_name} --provider #{provider}"
  end
end

  