# Load Yaml File
yaml_config = HashWithIndifferentAccess.new(YAML.load_file("#{Rails.root}/config/config.yml"))

# Merge defaults with environment specific
CONFIG = yaml_config['default'].merge(yaml_config[Rails.root] || {})
