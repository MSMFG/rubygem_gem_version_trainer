require 'rubygems/dependency'
require 'yaml'

# Extend Gem module
module Gem
  VERSION_CONFIG = 'VERSION_TRAINER_CONFIG'.freeze
  VERSION_TRAINER_CONFIG = '/etc/gem_version_trainer.yaml'.freeze

  begin
    @trainer_overides = YAML.load_file(
      ENV[VERSION_CONFIG] ||
      VERSION_TRAINER_CONFIG
    )
  rescue StandardError
    @trainer_overides = {}
  end

  def self.trainer_overrides
    @trainer_overides
  end

  def self.trainer_installed
    @trainer_installed ||= {}
  end

  # Monkey patch through subclassing
  class Dependency < remove_const(:Dependency)
    # Translate requirements from table
    def initialize(name, *requirements)
      new_req = Gem.trainer_overrides[name]
      new_req &&= [new_req]
      requirements = new_req || requirements
      super
    end
  end
end

# This works because the dependencies are satisifed bottom up
Gem.post_install do |installer|
  spec = installer.spec
  Gem.trainer_installed[spec.name] = spec.version
  # Perform analysis of gems installed by our dependencies
  spec.dependencies.each do |dep|
    name = dep.name
    next if Gem.trainer_overrides[name]
    next unless (ver = Gem.trainer_installed[name])

    req = dep.requirement
    next if req.specific?

    warn "NON specifc install of #{name}:#{ver} (requested #{req})"
  end
end
