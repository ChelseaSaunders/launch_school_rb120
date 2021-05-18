# What could we add to the class below to access the instance variable @volume?

class Cube
  attr_reader :volume

  def initialize(volume)
    @volume = volume
  end
end

cube = Cube.new(12)
p cube.volume

# attr_reader :volume

=begin
official answer:

class Cube
  def initialize(volume)
    @volume = volume
  end

  def get_volume
    @volume
  end
end

=end
