require 'rubygems/dependency'

# Extend Gem module
module Gem
  # May need this..
  # [["!= 1.3.0", "~> 1.1"], :runtime]
  MATCHES = {
    'mixlib-cli' => [
      ['~>1'], :runtime
    ]
  }

  def self.trainer_overrides
    MATCHES
  end

  def self.trainer_installed
    @specs_installed ||= {}
  end

  # Monkey patch through subclassing
  class Dependency < remove_const(:Dependency)

    # Translate requirements from table
    def initialize(name, *requirements)
      requirements = Gem.trainer_overrides[name] || requirements
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