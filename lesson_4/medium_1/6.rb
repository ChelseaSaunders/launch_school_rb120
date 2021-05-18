# If we have these two methods:
class Computer
  attr_accessor :template

  def create_template
    @template = "template 14231"
  end

  def show_template
    template
  end
end
 # above is preferred

# and
class Computer
  attr_accessor :template

  def create_template
    self.template = "template 14231"
  end

  def show_template
    self.template
  end
end

# What is the difference in the way the code works?

=begin
There's actually no difference in the result, only in the way each example
accomplishes the task. Compare both show_template methods. We can see in the
first example that it works fine without self, therefore, self isn't needed in
the second example. This is because show_template invokes the getter method
template, which doesn't require self, unlike the setter method.

Both examples are technically fine, however, the general rule from the Ruby
style guide is to "Avoid self where not required."
=end
