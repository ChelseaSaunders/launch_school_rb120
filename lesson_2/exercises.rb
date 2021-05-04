class Person
  attr_accessor :name

  def initialize(name)
    @name = name
  end
end

bob = Person.new('bob')
bob.name                  # => 'bob'
bob.name = 'Robert'
bob.name                  # => 'Robert'

class Person
  attr_accessor :first_name, :last_name

  def initialize(first_name)
    @first_name = first_name
    @last_name = ''
  end

  def name
    @last_name.length == 0 ? @first_name : @first_name + ' ' + @last_name
  end

end

bob = Person.new('Robert')
bob.name                  # => 'Robert'
bob.first_name            # => 'Robert'
bob.last_name             # => ''
bob.last_name = 'Smith'
bob.name                  # => 'Robert Smith'

class Person
  attr_accessor :first_name, :last_name

  def initialize(full_name)
    @first_name = full_name.split[0]
    @last_name = full_name.split.length > 1 ? full_name.split[1] : ''
  end

  def name=(full_name)
    @first_name = full_name.split[0]
    @last_name = full_name.split.length > 1 ? full_name.split[1] : ''
  end

  def name
    "#{@first_name} #{@last_name}".strip
  end
end


bob = Person.new('Robert')
bob.name                  # => 'Robert'
bob.first_name            # => 'Robert'
bob.last_name             # => ''
bob.last_name = 'Smith'
bob.name                  # => 'Robert Smith'
bob.name = "John Adams"
bob.first_name            # => 'John'
bob.last_name             # => 'Adams'

class Person
  attr_accessor :first_name, :last_name

  def initialize(full_name)
    parse_full_name(full_name)
  end

  def name
    "#{first_name} #{last_name}".strip
  end

  def name=(full_name)
    parse_full_name(full_name)
  end

  def to_s
    name
  end

  private

  def parse_full_name(full_name)
    parts = full_name.split
    self.first_name = parts.first
    self.last_name = parts.size > 1 ? parts.last : ''
  end
end

bob = Person.new('Robert Smith')
rob = Person.new('Robert Smith')

bob.name == rob.name # NOT bob == rob --diff objects but same string
##############################################
=begin
Class based inheritance works great when it's used to model hierarchical
domains. Let's take a look at a few practice problems. Suppose we're building a
software system for a pet hotel business, so our classes deal with pets.

Given this class:
=end

# Let's create a few more methods for our Dog class.

class Pet
  def run
    'running!'
  end

  def jump
    'jumping!'
  end
end

class Dog < Pet
  def speak
    'bark!'
  end

  def swim
    'swimming!'
  end

  def fetch
    'fetching!'
  end
end

class Cat < Pet
  def speak
    'meow!'
  end
end

teddy = Dog.new
puts teddy.speak           # => "bark!"
puts teddy.swim           # => "swimming!"

=begin
One problem is that we need to keep track of different breeds of dogs, since
they have slightly different behaviors. For example, bulldogs can't swim, but
all other dogs can.

Create a sub-class from Dog called Bulldog overriding the swim method to return
"can't swim!"
=end

class Bulldog < Dog
  def swim
    "can't swim!"
  end
end

jaws = Bulldog.new
p jaws.swim
