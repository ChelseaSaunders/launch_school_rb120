# What would happen if we added a play method to the Bingo class, keeping in
# mind that there is already a method of this name in the Game class that the
# Bingo class inherits from.

class Game
  def play
    "Start the game!"
  end
end

class Bingo < Game
  def rules_of_play
    #rules of play
  end
end

# the Bingo play method would override the Game method.  If a new instance of
# Game was created, play would call the Game play method on that object; if a
# new instance of Bingo was created, play would call the Bingo play method on
# that object.
