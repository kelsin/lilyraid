yaml_config = YAML.load_file("#{Rails.root}/config/config.yml") || {}
CONFIG = (yaml_config['default'] || {}).symbolize_keys.merge((yaml_config[Rails.root] || {}).symbolize_keys)
