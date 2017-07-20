# Disable echoing of sh commands (sh command output will still be displayed)
RakeFileUtils.verbose_flag  = false

# Directories
BOXES_DIR                   = File.join('.',  'boxes')
BUILDER_TEMPLATES           = File.join('.',  'racker/builder')
OS_TEMPLATES                = File.join('.',  'racker/os')
POSTPROCESSOR_TEMPLATES     = File.join('.',  'racker/postprocessor')
PROVISIONER_TEMPLATES       = File.join('.',  'racker/provisioner')
RACKER_TEMPLATES            = File.join('.',  'templates')
VARIABLES_TEMPLATES         = File.join('.',  'racker/variables')

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
