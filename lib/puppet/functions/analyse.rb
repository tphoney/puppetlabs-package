# frozen_string_literal: true

require 'isotree'
require 'outliertree'
require 'pp'

# @summary Returns error details
#
#   Returns error details

Puppet::Functions.create_function(:analyse) do
  # @param result_hash
  # @return [String] Returns error string
  # @example
  #  analyse('[a, hash, of, errors]')
  dispatch :analyse do
    param 'ResultSet', :result_hash

    optional_param 'Boolean', :allow_exit_code2
  end

  def isolation_forest(data)
    machines = []
    data.each do |machine|
      machines.push(machine[1])
    end

    model = IsoTree::IsolationForest.new
    model.fit(machines)
    isolation_forest = model.predict(machines)

    puts data[0]
    puts "\nIsolation forest"
    data.each_with_index do |element, index|
      puts "#{element.first} #{isolation_forest[index]}"
    end
  end

  def outlier_tree(data)
    machines = []
    data.each do |machine|
      machines.push(machine[1])
    end

    model = OutlierTree.new
    model.fit(machines)
    outlier_tree = model.outliers(machines)

    puts "\nOutlier tree"

    if outlier_tree.empty?
      puts 'no numeric values to analyse'
    else
      puts outlier_tree
    end
  end

  def average_resource(data)
    machines = []
    data.each do |machine|
      machines.push(machine[1])
    end
    # find all the possible keys in the arrays, make an array
    total_keys = []
    machines.each do |resource|
      k = resource.keys
      total_keys += k
    end
    total_keys = total_keys.uniq
    # puts "totalKeys #{total_keys}"

    returned_resource = {}
    # iterate over resources find the most common value
    total_keys.each do |key_to_check|
      value_list = []
      machines.each do |resource|
        value_list.push(resource[key_to_check])
      end
      # puts "#{key_to_check} #{value_list}"
      avg = value_list.max_by { |bla| value_list.count(bla) }
      returned_resource[key_to_check] = avg
    end
    puts "\nAverage resource"
    puts returned_resource
  end

  def analyse(result_hash)
    build_hash = {}
    result_hash.each do |target_raw|
      target = target_raw.to_data
      build_hash[target['target']] = target['value']
    end
    puts 'Raw data'
    pp build_hash
    isolation_forest(build_hash)
    outlier_tree(build_hash)
    average_resource(build_hash)
  end
end
