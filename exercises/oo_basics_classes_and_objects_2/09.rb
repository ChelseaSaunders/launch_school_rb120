# Using the following code, add a method named share_secret that prints the
# value of @secret when invoked.

class Person
  attr_writer :secret

  def share_secret
    puts secret
  end

  private

  attr_reader :secret #this means outside you can't call person1.secret, only
                      # the share_secret method...because secret can only be
                      # accessed inside the person class definition
end

person1 = Person.new
person1.secret = 'Shh.. this is a secret!'
person1.share_secret
