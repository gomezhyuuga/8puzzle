# 8 Puzzle Game
require 'set'

class Board
  attr_accessor :cells

  def initialize
    @cells = []
    cells = (1..8).to_a
    cells << " "
    cells.shuffle!
    cells.each_slice(3) { |row| @cells << row }
  end

  def all_cells
    @cells.flatten
  end

  def blank_position
    index = self.all_cells.index " "

    [index / 3, index % 3]
  end

  def possible_moves
    moves = %i[up down left right].to_set
    row, col = self.blank_position

    moves.delete(:left) if col == 0
    moves.delete(:right) if col == 2
    moves.delete(:up) if row == 0
    moves.delete(:down) if row == 2

    moves
  end

  def to_s
    @cells.map { |row| row.join "|" }.join "\n"
  end
end

