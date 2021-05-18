class Greeting
  def greet(message)
    puts message
  end
end

class Hello < Greeting
  def hi
    greet("Hello")
  end
end

class Goodbye < Greeting
  def bye
    greet("Goodbye")
  end
end

# If we call Hello.hi we get an error message. How would you fix this?

# can make hi a class method:

#   def self.hi
#     greeting = Greeting.new # have to do weird thing bc greet is instance
#     greeting.greet("Hello") # method not class method
# # end

# Or can create an instance of Hello and call hi on instance
# hi = Hello.new
# hi.hi
