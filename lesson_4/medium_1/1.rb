# Ben asked Alyssa to code review the following code:

class BankAccount
  attr_reader :balance

  def initialize(starting_balance)
    @balance = starting_balance
  end

  def positive_balance?
    balance >= 0
  end
end

# Alyssa glanced over the code quickly and said - "It looks fine, except that
# you forgot to put the @ before balance when you refer to the balance instance
# variable in the body of the positive_balance? method."

# "Not so fast", Ben replied. "What I'm doing here is valid - I'm not missing an
#  @!"

# Who is right, Ben or Alyssa, and why?

# Ben is right, you don't need the @ because of the attr_reader :balance in the
# first line, which creates a method, balance that returns @balance.  So when
# methods inside the class call balance it returns @balance
