# frozen_string_literal: true

require 'puppet'

def local_key(type, name)
  [type, name].join('/')
end

def get_resource(type, name = nil)
  key = local_key(type, name)
  Puppet.settings.initialize_app_defaults(Puppet::Settings.app_defaults_for_run_mode(Puppet::Util::RunMode[:user]))
  Puppet::ApplicationSupport.push_application_context(Puppet::Util::RunMode[:user])
  Puppet.lookup(:current_environment)
  resources = if name.nil?
                Puppet::Resource.indirection.search(key, {})
              else
                [Puppet::Resource.indirection.find(key)]
              end
  resources
end
