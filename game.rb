require 'highline'
require 'board'
require 'byebug'

class Game
  attr_accessor :board
  def initialize()
    @board = Board.new
  end
end
CLI = HighLine.new

def ask_answer
  CLI.ask "Choose the number you want to move: "
end

game = Board.new
counter = 0
until game.won?
  puts game
  movement = ask_answer.to_i
  #byebug
  next unless game.can_move?(movement)

  game.move(movement)
  counter += 1
end
puts game
puts "YOU WIN!!"
puts "Movements: #{counter}"
