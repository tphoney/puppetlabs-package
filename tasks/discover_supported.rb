#!/opt/puppetlabs/puppet/bin/ruby
# frozen_string_literal: true

require 'puppet'
require 'open3'
require 'fileutils'

begin
  require_relative '../../ruby_task_helper/files/task_helper.rb'
  require_relative '../lib/task_helper'
rescue LoadError
  # include location for unit tests
  require 'fixtures/modules/ruby_task_helper/files/task_helper.rb'
  require 'fixtures/modules/comply/lib/task_helper'
end

# DiscoverSupported task
class DiscoverSupported < TaskHelper
  def task(operation: 'create', **_kwargs)
    modules_to_match = { puppetlabs_apache: [%r{^httpd$}], puppetlabs_mysql: [%r{mariadb-server}] }

    result = get_resource('package')
    recommendation_string = ''
    modules_to_match.each do |module_name, value|
      value.each do |matcher|
        result.each do |resource|
          next unless resource.title&.match?(matcher)
          recommendation_string = if recommendation_string == ''
                                    module_name
                                  else
                                    "#{recommendation_string},  #{module_name}"
                                  end
          # puts "#{resource.title} is installed"
        end
      end
    end
    if recommendation_string == ''
      puts 'sorry no recommendations'
    else
      puts "Recommending:\n#{recommendation_string}"
    end
  end
end

if $PROGRAM_NAME == __FILE__
  DiscoverSupported.run
end
