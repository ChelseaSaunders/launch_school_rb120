# Create a module named Transportation that contains three classes: Vehicle,
# Truck, and Car. Truck and Car should both inherit from Vehicle.

module Transportation
  class Vehicle
  end

  class Truck < Vehicle
  end

  class Car < Vehicle
  end
end

=begin
Discussion
Modules are not only useful for grouping common methods together, but they're
also useful for namespacing. Namespacing is where similar classes are grouped
within a module. This makes it easier to recognize the purpose of the contained
classes. Grouping classes in a module can also help avoid collision with classes
of the same name.

We can instantiate a class that's contained in a module by invoking the following:
=end
Transportation::Truck.new
