# Given the following code, modify #start_engine in Truck by appending 'Drive
# fast, please!' to the return value of #start_engine in Vehicle. The 'fast' in
# 'Drive fast, please!' should be the value of speed.

class Vehicle
  def start_engine
    'Ready to go!'
  end
end

class Truck < Vehicle
  def start_engine(speed)
    super() + " Drive #{speed} please!" #NEED the () after super or does not
  end                                   #work because super does not take arg's
end                                     #and it will try to pass the arg to
                                        #super if you dont have the parenthesis
truck1 = Truck.new
puts truck1.start_engine('fast')
