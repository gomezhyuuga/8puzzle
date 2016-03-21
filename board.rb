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
    self.position_of " "
  end

  def move(number)
    raise ArgumentError.new("Can't move that cell") unless self.can_move?(number)

    b_row, b_col = self.blank_position
    c_row, c_col  = self.position_of(number)
    @cells[b_row][b_col] = number
    @cells[c_row][c_col] = " "

    [b_row, b_col]
  end

  def can_move?(number)
    position = self.position_of(number)
    moves = self.possible_moves
    moves.index(position) ? true : false
  end

  def possible_moves
    row, col = self.blank_position
    moves = []
    self.possible_direction_moves.each do |move|
      case move
      when :up then moves << [row - 1, col]
      when :down then moves << [row + 1, col]
      when :left then moves << [row, col - 1]
      when :right then moves << [row, col + 1]
      end
    end
    moves.sort
  end

  def possible_direction_moves
    moves = %i[up down left right].to_set
    row, col = self.blank_position

    moves.delete(:left) if col == 0
    moves.delete(:right) if col == 2
    moves.delete(:up) if row == 0
    moves.delete(:down) if row == 2

    moves
  end
  def position_of(number)
    number = " " if number == :blank
    index = self.all_cells.index number
    [index / 3, index % 3]
  end

  def to_s
    @cells.map { |row| row.join "|" }.join "\n"
  end
end

