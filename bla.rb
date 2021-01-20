# frozen_string_literal: true

require 'isotree'
require 'outliertree'
require 'pry'
require 'pp'

# data = [
#   { department: 'Books',  sale: false, price: 2.50 },
#   { department: 'Books',  sale: true,  price: 3.00 },
#   { department: 'Books',  sale: true,  price: 3.00 },
#   { department: 'Books',  sale: true,  price: 3.00 },
#   { department: 'Movies', sale: false, price: 10.00 },
# ]

# puts "sample data #{data}"

# puts 'isolation forest'
# model = IsoTree::IsolationForest.new
# model.fit(data)

# jim = model.predict(data)

# puts jim

# puts 'outlier tree'

# model = OutlierTree.new
# model.fit(data)

# jim = model.outliers(data)
# puts jim

def average_resource(data)
  # find all the possible keys in the arrays, make an array
  total_keys = []
  data.each do |resource|
    k = resource.keys
    total_keys += k
  end
  total_keys = total_keys.uniq
  # puts "totalKeys #{total_keys}"
  returned_resource = {}
  # iterate over resources find the most common value
  total_keys.each do |key_to_check|
    value_list = []
    data.each do |resource|
      value_list.push(resource[key_to_check])
    end
    #  puts "#{key_to_check} #{value_list}"
    avg = value_list.max_by { |bla| value_list.count(bla) }
    returned_resource[key_to_check] = avg
  end
  returned_resource
end

data = [

  {
    status: 'installed',
     version: '1.0.1e-57.el6',
     latest: '1.0.1e-58.el6_10'
  },
  {
    status: 'installed',
     version: '1.0.2k-12.el7',
     latest: '1:1.0.2k-21.el7_9'
  },
  {
    status: 'installed',
     version: '1.0.2k-12.el7',
     latest: '1:1.0.2k-21.el7_9'
  },
  {
    status: 'installed',
     version: '1.0.1e-57.el6',
     latest: '1.0.1e-58.el6_10'
  },
  {
    status: 'installed',
     version: '1.0.2k-12.el7',
     latest: '1:1.0.2k-21.el7_9'
  },
]
puts "\nResources for Openssl\n"
pp data

puts "\nIsolation forest"
model = IsoTree::IsolationForest.new
model.fit(data)

isolation_forest = model.predict(data)

puts isolation_forest

puts "\nOutlier tree\n"

model = OutlierTree.new
model.fit(data)

outlier_tree = model.outliers(data)

if outlier_tree.empty?
  puts 'no numeric values to analyse'
else
  puts outlier_tree
end

puts "\nAverage resource\n"

average = average_resource(data)

pp average
