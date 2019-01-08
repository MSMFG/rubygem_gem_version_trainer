# gem_version_trainer

When installed, this gem plugs into the Rubygem installation mechanism examining gem version specifications for
dependencies, alerting the user if the version specification is 'unsafe' i.e. >, >= rather than ~> specification.

Additionally the trainer can be given a configuration that allows versions to be overridden for certain gems when
encountered.

The purpose is to detect dependencies arriving via unsafe version pinning within continuous delivery pipelines and
to provide some means of pinning whilst awaiting an upstream fix from the gem maintainer.

## Example use

Override behaviour (note in this case there is an overall failure so the warning does not appear)
```
C02T6183G8WL:gem_version_trainer andrew.smith$ gem install sensu-plugin:3.0.0
ERROR:  Error installing sensu-plugin:
  The last version of mixlib-cli (>= 1.5.0) to support your Ruby & RubyGems was 1.7.0. Try installing it with `gem install mixlib-cli -v 1.7.0` and then running the current command again
  mixlib-cli requires Ruby version >= 2.5. The current ruby version is 2.4.0.

C02T6183G8WL:gem_version_trainer andrew.smith$ cat examples/example.yaml 
---
mixlib-cli:
  - "~>1"

C02T6183G8WL:gem_version_trainer andrew.smith$ export VERSION_TRAINER_CONFIG=./examples/example.yaml 
C02T6183G8WL:gem_version_trainer andrew.smith$ gem install sensu-plugin:3.0.0
Fetching: mixlib-cli-1.7.0.gem (100%)
Successfully installed mixlib-cli-1.7.0
Fetching: sensu-plugin-3.0.0.gem (100%)
Successfully installed sensu-plugin-3.0.0
Parsing documentation for mixlib-cli-1.7.0
Installing ri documentation for mixlib-cli-1.7.0
Parsing documentation for sensu-plugin-3.0.0
Installing ri documentation for sensu-plugin-3.0.0
Done installing documentation for mixlib-cli, sensu-plugin after 1 seconds
2 gems installed
```
NOTE: Without specifying VERSION_TRAINER_CONFIG environment variable to locate the YAML config the gem will automatically look at /etc/gem_version_trainer.yaml.

Warning behaviour
```
C02T6183G8WL:gem_version_trainer andrew.smith$ gem install net-sftp
Fetching: net-ssh-5.1.0.gem (100%)
Successfully installed net-ssh-5.1.0
Fetching: net-sftp-2.1.2.gem (100%)
NON specifc install of net-ssh:5.1.0 (requested >= 2.6.5)
Successfully installed net-sftp-2.1.2
Parsing documentation for net-ssh-5.1.0
Installing ri documentation for net-ssh-5.1.0
Parsing documentation for net-sftp-2.1.2
Installing ri documentation for net-sftp-2.1.2
Done installing documentation for net-ssh, net-sftp after 3 seconds
2 gems installed
C02T6183G8WL:gem_version_trainer andrew.smith$ 
```