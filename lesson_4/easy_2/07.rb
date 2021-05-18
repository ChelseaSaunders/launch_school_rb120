# Explain what the @@cats_count variable does and how it works. What code would
# you need to write to test your theory?

class Cat
  @@cats_count = 0

  def initialize(type)
    @type = type
    @age  = 0
    @@cats_count += 1
  end

  def self.cats_count
    @@cats_count
  end
end

# The @@cats_count variable count the number of instances there are of the Cat
# class. It is initialized to 0 and 1 is added every time a new Cat object is
# instanciated. To test, you could instantiate multiple objects and call
# Cat.cats_count after each new object to ensure the number matched the number
# of instances of Cat objects.
