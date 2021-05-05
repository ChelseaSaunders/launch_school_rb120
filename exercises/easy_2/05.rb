# What will the following code print?

class Something
  def initialize
    @data = 'Hello'
  end

  def dupdata #Instance method
    @data + @data
  end

  def self.dupdata  #Class method
    'ByeBye'
  end
end

thing = Something.new
puts Something.dupdata #ByeBye
puts thing.dupdata #HelloHello
