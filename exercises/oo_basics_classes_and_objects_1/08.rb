# Using the code from the previous exercise, add a setter method named #name.
# Then, rename kitty to 'Luna' and invoke #greet again.

class Cat
  attr_writer :name
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def greet
    puts "Hello! My name is #{name}!"
  end
end

kitty = Cat.new('Sophie')
kitty.greet
kitty.name = 'Luna' # = not passed as arg ()
kitty.greet
