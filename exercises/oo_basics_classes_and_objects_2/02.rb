# Using the following code, add an instance method named #rename that renames
# kitty when invoked.

class Cat
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def rename(new_name)
    self.name = new_name # do NOT use @name--that is _initializing_ an instance
  end                    # variable, not modifying it
end

kitty = Cat.new('Sophie')
p kitty.name
kitty.rename('Chloe')
p kitty.name
