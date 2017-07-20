require 'tempfile'

module BB
  class Racker

    def self.generate_packer_box_name(box_name)
      return File.join(BOXES_DIR,"#{box_name}.box")
    end

    def self.generate_packer_template(template_definitions)
      # Create a temp file
      file = Tempfile.new('packer')

      puts template_definitions.join(' ') if defined?(::DEBUG) && ::DEBUG
      
      # Generate the packer template from the template definition
      Kernel::system "#{::RACKER_BIN} --quiet #{template_definitions.join(' ')} #{file.path}"

      # Return the path to the file
      return file.path
    end

    def self.generate_provider_specific_variables(box_name)
      case ::BOX_BUILDER
      when 'virtualbox'
        {
          'bb_box_name'     => ::BOX_NAME,
          'bb_output_file'  => generate_packer_box_name(box_name),
          'bb_vm_name'      => "bb-#{BOX_NAME}",
        }
      else
        {}
      end  
    end
  end
end
