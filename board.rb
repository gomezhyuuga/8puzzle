# 8 Puzzle Game
class Board
  attr_reader :cells
  def initialize
    cells = (1..8).to_a
    cells << " "
    @cells = cells.shuffle!
  end

  def to_s
    @cells.each_slice(3) { |row| puts row.join "|" }
  end
end

