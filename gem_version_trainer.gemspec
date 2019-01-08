class << $LOAD_PATH
  def merge!(other)
    replace(self | other)
  end
end

$LOAD_PATH.merge! [File.expand_path('../lib', __FILE__)]

Gem::Specification.new do |spec|
  raise 'RubyGems 2.0 or newer is required.' unless spec.respond_to?(:metadata)
  spec.name = 'gem_version_trainer'
  spec.version = '1.0.0'
  spec.authors = ['Andrew Smith']
  spec.email = ['andrew.smith at moneysupermarket.com']

  spec.summary = 'Determine and address unsafe dependencies included by gem installs'
  spec.description = 'Allows specific gems, when encountered as dependencies to have'\
                     ' version information overridden for safety and alerts unsafe'\
                     'version specifications such as > or >= rather than ~>'
  spec.homepage = 'https://github.com/MSMFG/rubygem_gem_version_trainer'
  spec.license = 'Apache-2.0'
  spec.files = `git ls-files -z`.split("\x0")
end
