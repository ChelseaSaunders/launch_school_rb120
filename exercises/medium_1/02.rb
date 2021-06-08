# A fixed-length array is an array that always has a fixed number of elements.
# Write a class that implements a fixed-length array, and provides the necessary
# methods to support the following code:

class FixedArray
  attr_accessor :fixed_array

  def initialize(num)
    @fixed_array = Array.new(num)
  end


  def [](index)
    fixed_array.fetch(index) #need to use the .fetch method instead of [], because fetch throws the error...?
  end

  def []=(index, element)
    self[index] #This is what causes the error/exception?
    fixed_array[index] = element
  end

  def to_a
    fixed_array.clone
  end

  def to_s
    "#{fixed_array}"
  end
end

 fixed_array = FixedArray.new(5)
# puts fixed_array[3] == nil
# puts fixed_array.to_a == [nil] * 5

# fixed_array[3] = 'a'
# puts fixed_array[3] == 'a'
# puts fixed_array.to_a == [nil, nil, nil, 'a', nil]

# fixed_array[1] = 'b'
# puts fixed_array[1] == 'b'
# puts fixed_array.to_a == [nil, 'b', nil, 'a', nil]

# fixed_array[1] = 'c'
# puts fixed_array[1] == 'c'
# puts fixed_array.to_a == [nil, 'c', nil, 'a', nil]

# fixed_array[4] = 'd'
# puts fixed_array[4] == 'd'
# puts fixed_array.to_a == [nil, 'c', nil, 'a', 'd']
# puts fixed_array.to_s == '[nil, "c", nil, "a", "d"]'

# puts fixed_array[-1] == 'd'
# puts fixed_array[-4] == 'c'

begin
  fixed_array[6]
  puts false
rescue IndexError
  puts true
end

# begin
#   fixed_array[-7] = 3
#   puts false
# rescue IndexError
#   puts true
# end

begin
  fixed_array[7] = 3
  puts false
rescue IndexError
  puts true
end
