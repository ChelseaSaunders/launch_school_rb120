# If we have this code:

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

# What happens in each of the following cases:

# 1:
hello = Hello.new
hello.hi
# => outputs "Hello", returns nil

# 2:
hello = Hello.new
hello.bye
# NoMethodError

# 3:
hello = Hello.new
hello.greet
# Wrong Number of Arguments error

# 4:
hello = Hello.new
hello.greet("Goodbye")
# outputs "Goodbye", returns nil

# 5:
Hello.hi
# NoMethodError, hi is an instance method not a class method
