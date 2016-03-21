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
  def test_possible_direction_moves
    # Blank = [0][0]
    @board.cells = self.mock_cells
    assert_equal self.mock_moves.subtract([:up, :left]), @board.possible_direction_moves
    # Blank = [0][1]
    @board.cells = self.mock_cells_blank_at row: 0, col: 1
    assert_equal self.mock_moves.subtract([:up]), @board.possible_direction_moves
    # Blank = [0][2]
    @board.cells = self.mock_cells_blank_at row: 0, col: 2
    assert_equal self.mock_moves.subtract([:up, :right]), @board.possible_direction_moves
    # Blank = [1][0]
    @board.cells = self.mock_cells_blank_at row: 1, col: 0
    assert_equal self.mock_moves.subtract([:left]), @board.possible_direction_moves
    # Blank = [1][1]
    @board.cells = self.mock_cells_blank_at row: 1, col: 1
    assert_equal self.mock_moves, @board.possible_direction_moves
    # Blank = [1][2]
    @board.cells = self.mock_cells_blank_at row: 1, col: 2
    assert_equal self.mock_moves.subtract([:right]), @board.possible_direction_moves
    # Blank = [2][0]
    @board.cells = self.mock_cells_blank_at row: 2, col: 0
    assert_equal self.mock_moves.subtract([:down, :left]), @board.possible_direction_moves
    # Blank = [2][1]
    @board.cells = self.mock_cells_blank_at row: 2, col: 1
    assert_equal self.mock_moves.subtract([:down]), @board.possible_direction_moves
    # Blank = [2][2]
    @board.cells = self.mock_cells_blank_at row: 2, col: 2
    assert_equal self.mock_moves.subtract([:down, :right]), @board.possible_direction_moves
  end
  def test_position_of
    @board.cells = mock_cells
    assert_equal [0, 0], @board.position_of(:blank)
    assert_equal [0, 1], @board.position_of(1)
    assert_equal [0, 2], @board.position_of(2)
    assert_equal [1, 0], @board.position_of(3)
    assert_equal [1, 1], @board.position_of(4)
    assert_equal [1, 2], @board.position_of(5)
    assert_equal [2, 0], @board.position_of(6)
    assert_equal [2, 1], @board.position_of(7)
    assert_equal [2, 2], @board.position_of(8)
  end

  def test_can_move?
    @board.cells = mock_cells
    # Initially can only move 2 and 3
    cant_move = (1..8).to_a - [1, 3]
    cant_move.each { |num| assert !@board.can_move?(num) }
    [1, 3].each { |num| assert @board.can_move?(num) }
  end

  #def check_move(board, number)
    #blank_pos = board.blank_position
    #assert_equal blank_pos, board.position_of(number)
  #end
  #def test_moves
    #@board.cells = mock_cells

    #@board.move(1) # | |1|2| => |1| |2|
    #check_move(@board, 1)
    #@board.move(2) # |1| |2| => |1|2| |
    #check_move(@board, 2)
    ## |1|2| | ==> |1|2|5|
    ## |3|4|5| ==> |3|4| |
    #@board.move(5)
    #check_move(@board, 5)
    ## |1|2|5| ==> |1|2|5|
    ## |3|4| | ==> |3| |4|
    #@board.move(4)
    #check_move(@board, 4)
    ## |1|2|5| ==> |1|2|5|
    ## |3| |4| ==> |3|7|4|
    ## |6|7|8| ==> |6| |8|
    #@board.move(7)
    #check_move(@board, 7)
    ## |1|2|5| ==> |1|2|5|
    ## |3|7|4| ==> |3|7|4|
    ## |6| |8| ==> |6|8| |
    #@board.move(8)
    #check_move(@board, 8)
  #end
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
