module Bark
  def bark
    puts "Woof"
  end
end

class MyPets
  include Bark
end

aubrey = MyPets.new

=begin
Create a class called MyCar. When you initialize a new instance or object of the
class, allow the user to define some instance variables that tell us the year,
color, and model of the car. Create an instance variable that is set to 0
during instantiation of the object to track the current speed of the car as
well. Create instance methods that allow the car to speed up, brake, and shut
the car off.
=end

=begin
Add an accessor method to your MyCar class to change and view the color of your
car. Then add an accessor method that allows you to view, but not modify, the
year of your car.
=end

=begin
Add a class method to your MyCar class that calculates the gas mileage of any
car.
=end

=begin
Override the to_s method to create a user friendly print out of your object.
=end

=begin
Create a superclass called Vehicle for your MyCar class to inherit from and move
the behavior that isn't specific to the MyCar class to the superclass. Create a
constant in your MyCar class that stores information about the vehicle that
makes it different from other types of Vehicles.

Then create a new class called MyTruck that inherits from your superclass that
also has a constant defined that separates it from the MyCar class in some way.
=end

=begin
Add a class variable to your superclass that can keep track of the number of
objects created that inherit from the superclass. Create a method to print out
the value of this class variable as well.
=end

=begin
Create a module that you can mix in to ONE of your subclasses that describes a
behavior unique to that subclass.
=end

=begin
Print to the screen your method lookup for the classes that you have created.
=end

=begin
Move all of the methods from the MyCar class that also pertain to the MyTruck
class into the Vehicle class. Make sure that all of your previous method calls
are working when you are finished.
=end

=begin
Write a method called age that calls a private method to calculate the age of
the vehicle. Make sure the private method is not available from outside of the
class. You'll need to use Ruby's built-in Time class to help.
=end

module Haulable
  def hauling(object)
    puts "This truck is hauling #{object}."
  end
end

class Vehicle
  attr_accessor :color, :model, :speed
  attr_reader :year

  @@number_of_vehicles = 0

  def initialize(y, c, m)
    @year = y
    @color = c
    @model = m
    @speed = 0
    @@number_of_vehicles += 1
  end

  def self.number_of_vehicles
    puts "There are #{@@number_of_vehicles} vehicles."
  end

  def speed_up(num)
    @speed += num
  end

  def brake(num)
    @speed -= num
  end

  def shut_off
    @speed = 0
  end

  def spray_paint(new_color)
    @color = new_color
    puts "Your #{self.model} looks great in #{@color}!"
  end

  def self.gas_mileage(gallons_of_gas, miles_traveled)
    puts "Your gas mileage is #{miles_traveled / gallons_of_gas}."
  end

  def age
    puts "Your #{self.model} is #{total_years} years old."
  end

  private

  def total_years
    Time.now.year - self.year.to_i
  end
end

class MyCar < Vehicle
  PASSENGERS = 5

  def to_s
    "This car is a #{@year} #{@color} #{@model}."
  end
end

class MyTruck < Vehicle
  PASSENGERS = 3

  include Haulable

  def to_s
    "This truck is a #{@year} #{@color} #{@model}."
  end
end

matrix = MyCar.new("2008", 'silver', 'toyota matrix')

puts MyCar.ancestors#  for method lookup

four_by_four = MyTruck.new("2001", "red", "ford escalade")

four_by_four.spray_paint('blue')
matrix.spray_paint('green')
puts matrix
puts four_by_four
matrix.age
four_by_four.age
=begin
When running the following code:

class Person
  attr_reader :name
  def initialize(name)
    @name = name
  end
end

bob = Person.new("Steve")
bob.name = "Bob"

we get the following error:

test.rb:9:in `<main>': undefined method `name=' for
  #<Person:0x007fef41838a28 @name="Steve"> (NoMethodError)

=end

class Person
  attr_accessor :name #needs to be accessor for read/write or writer for write-only
  def initialize(name)
    @name = name
  end
end

bob = Person.new("Steve")
bob.name = "Bob"

=begin
Create a class 'Student' with attributes name and grade. Do NOT make the grade
getter public, so joe.grade will raise an error. Create a better_grade_than?
method, that you can call like so
=end

class Student
  def initialize(name, grade)
    @name = name
    @grade = grade
  end

  def better_grade_than?(other_student)
    grade > other_student.grade
  end

  protected

  def grade
    @grade
  end
end

joe = Student.new("Joe", 90)
bob = Student.new("Bob", 84)
puts "Well done!" if joe.better_grade_than?(bob)
