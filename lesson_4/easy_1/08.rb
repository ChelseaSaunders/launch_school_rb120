# If we have a class such as the one below:
# You can see in the make_one_year_older method we have used self. What does
# self refer to here?

class Cat
  attr_accessor :type, :age

  def initialize(type)
    @type = type
    @age  = 0
  end

  def make_one_year_older
    self.age += 1
  end
end

# Self refers to the Cat Object?
#Official answer:
# the instance (object) that called the method - the calling object
