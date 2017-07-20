module BB

  def self.validate_template(template)
    load_template_definition(template)
  end

  private

  def self.get_template_definition_filename(definition)
    return File.join(RACKER_TEMPLATES, "#{definition}.rb")
  end

  def self.load_template_definition(definition)
    if template_definition_exists?(definition)
      require get_template_definition_filename(definition)
    else
      raise "Template not found: #{definition}"
    end

    # Box Configuration
    raise 'Malformed template! BOX_BUILDER must be specified'           unless defined?(BOX_BUILDER)
    raise 'Malformed template! BOX_NAME must be specified'              unless defined?(BOX_NAME)
    raise 'Malformed template! BOX_OS must be specified'                unless defined?(BOX_OS)
    
    # User Variables
    raise 'Malformed template! USER_VARIABLES must be specified'        unless defined?(USER_VARIABLES)
    raise 'USER_VARIABLES must be an Array'                             unless USER_VARIABLES.is_a?(Hash) 

    # Template Definition
    raise 'Malformed template! TEMPLATE_DEFINITIONS must be specified'  unless defined?(TEMPLATE_DEFINITIONS)
    raise 'TEMPLATE_DEFINITIONS must be an Array'                       unless TEMPLATE_DEFINITIONS.is_a?(Array) 
    raise 'TEMPLATE_DEFINITIONS must contain atleast 1 entry'           if TEMPLATE_DEFINITIONS.length == 0
  end

  def self.template_definition_exists?(definition)
    return File.exists?(get_template_definition_filename(definition))
  end
end

require_relative 'bb/racker'
