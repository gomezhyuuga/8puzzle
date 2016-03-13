# 8 Puzzle Game
class Board
  attr_reader :cells
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
  def to_s
    @cells.map { |row| row.join "|" }.join "\n"
  end
end

