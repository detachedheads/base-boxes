require 'rubygems'

# Load our rake configuration
require File.expand_path('../.tasks/config/config', __FILE__)

# Load our tasks
Dir[ File.join(File.dirname(__FILE__), '.tasks', '*.rake') ].sort.each do |f|
  load f
end
