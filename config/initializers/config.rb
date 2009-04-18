CONFIG = YAML.load_file("#{RAILS_ROOT}/config/config.yml") || {}
CONFIG = (CONFIG['default'] || {}).symbolize_keys.merge((CONFIG[RAILS_ENV] || {}).symbolize_keys)
