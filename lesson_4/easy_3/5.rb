# If I have the following class:
class Television
  def self.manufacturer
    # method logic
  end

  def model
    # method logic
  end
end

# What would happen if I called the methods like shown below?
tv = Television.new
tv.manufacturer # won't work because manutacturer is a class method
tv.model # will execute code from model method

Television.manufacturer # will execute code from self.manufacturer method
Television.model # wont work because model is an instance method
