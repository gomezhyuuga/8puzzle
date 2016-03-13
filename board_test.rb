require 'minitest/autorun'
require 'set'
require 'board'

class BoardTest < MiniTest::Unit::TestCase
  def setup
    @board = Board.new
  end

  def test_print
    puts @board
  end
  def test_board_initialize
    # Check length
    assert_equal 3, @board.cells.length
    @board.cells.each { |row| assert_equal 3, row.length }
    # Contains numbers 1 to 8 and one nil space
    (1..8).each do |num|
      assert @board.all_cells.index num
    end
    # Check for one empty space
    assert @board.all_cells.index " "
  end
  def test_blank_position
    @board.cells = self.mock_cells # [0][0]
    assert_equal [0, 0], @board.blank_position
    @board.cells = self.mock_cells_blank_at row: 0, col: 1
    assert_equal [0, 1], @board.blank_position
    @board.cells = self.mock_cells_blank_at row: 0, col: 2
    assert_equal [0, 2], @board.blank_position

    @board.cells = self.mock_cells_blank_at row: 1, col: 0
    assert_equal [1, 0], @board.blank_position
    @board.cells = self.mock_cells_blank_at row: 1, col: 1
    assert_equal [1, 1], @board.blank_position
    @board.cells = self.mock_cells_blank_at row: 1, col: 2
    assert_equal [1, 2], @board.blank_position

    @board.cells = self.mock_cells_blank_at row: 2, col: 0
    assert_equal [2, 0], @board.blank_position
    @board.cells = self.mock_cells_blank_at row: 2, col: 1
    assert_equal [2, 1], @board.blank_position
    @board.cells = self.mock_cells_blank_at row: 2, col: 2
    assert_equal [2, 2], @board.blank_position
  end
  def test_possible_moves
    # Blank = [0][0]
    @board.cells = self.mock_cells
    assert_equal self.mock_moves.subtract([:up, :left]), @board.possible_moves
    # Blank = [0][1]
    @board.cells = self.mock_cells_blank_at row: 0, col: 1
    assert_equal self.mock_moves.subtract([:up]), @board.possible_moves
    # Blank = [0][2]
    @board.cells = self.mock_cells_blank_at row: 0, col: 2
    assert_equal self.mock_moves.subtract([:up, :right]), @board.possible_moves
    # Blank = [1][0]
    @board.cells = self.mock_cells_blank_at row: 1, col: 0
    assert_equal self.mock_moves.subtract([:left]), @board.possible_moves
    # Blank = [1][1]
    @board.cells = self.mock_cells_blank_at row: 1, col: 1
    assert_equal self.mock_moves, @board.possible_moves
    # Blank = [1][2]
    @board.cells = self.mock_cells_blank_at row: 1, col: 2
    assert_equal self.mock_moves.subtract([:right]), @board.possible_moves
    # Blank = [2][0]
    @board.cells = self.mock_cells_blank_at row: 2, col: 0
    assert_equal self.mock_moves.subtract([:down, :left]), @board.possible_moves
    # Blank = [2][1]
    @board.cells = self.mock_cells_blank_at row: 2, col: 1
    assert_equal self.mock_moves.subtract([:down]), @board.possible_moves
    # Blank = [2][2]
    @board.cells = self.mock_cells_blank_at row: 2, col: 2
    assert_equal self.mock_moves.subtract([:down, :right]), @board.possible_moves
  end
    def mock_moves
      %i[up down left right].to_set
    end
    def mock_cells
      self.mock_cells_blank_at
    end
    def mock_cells_blank_at(row: 0, col: 0)
      cells = [[" ", 1, 2],
               [3, 4, 5],
               [6, 7, 8]]
      n = cells[row][col]
      cells[row][col] = " "
      cells[0][0] = n
      cells
    end
end
