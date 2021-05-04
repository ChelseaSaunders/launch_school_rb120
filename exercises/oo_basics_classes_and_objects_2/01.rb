# Modify the following code so that Hello! I'm a cat! is printed when
# Cat.generic_greeting is invoked.

class Cat
  def self.generic_greeting #Need self because it is a CLASS method not INSTANCE
    puts "Hello! I'm a cat!" # method. Could also say Cat.generic_greeting
  end
end

Cat.generic_greeting
