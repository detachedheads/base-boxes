# Disable echoing of sh commands (sh command output will still be displayed)
RakeFileUtils.verbose_flag  = false

# The root directory of this project 
ROOT_DIR = File.expand_path(File.join(File.dirname(__FILE__), '../..'))

# Directories
BOXES_DIR                   = File.join(ROOT_DIR,  'boxes')
BUILDER_TEMPLATES           = File.join(ROOT_DIR,  'racker/builder')
OS_TEMPLATES                = File.join(ROOT_DIR,  'racker/os')
POSTPROCESSOR_TEMPLATES     = File.join(ROOT_DIR,  'racker/postprocessor')
PROVISIONER_TEMPLATES       = File.join(ROOT_DIR,  'racker/provisioner')
RACKER_TEMPLATES            = File.join(ROOT_DIR,  'templates')
VARIABLES_TEMPLATES         = File.join(ROOT_DIR,  'racker/variables')

# Binaries
PACKER_BIN                  = 'packer'
RACKER_BIN                  = 'racker'

# Vagrant Box
VAGRANT_BOX_PREFIX          = 'detachedheads/'

# Flag to determine if debugging is enabled
DEBUG                       = false

# Enable packer debugging
ENV['PACKER_LOG']           = '1' if DEBUG

# Set the TMPDIR packer will use
ENV['TMPDIR']               =  "#{ENV['HOME']}/tmp"

# Create the temp dir
mkdir_p ENV['TMPDIR']
