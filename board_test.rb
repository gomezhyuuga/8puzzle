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
  def test_possible_moves
    @board.cells = self.mock_cells
    assert_equal [1, 3], @board.possible_moves

    @board.cells = self.mock_cells_blank_at row: 2, col: 2
    assert_equal [5, 7], @board.possible_moves
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

    # With incorrect positions
    assert !@board.can_move?(9), "Can't move a non existent cell"
    assert !@board.can_move?(" "), 'Can not move the blank space'
    assert !@board.can_move?(0), "Can't move a non existent cell"
    assert !@board.can_move?("sad"), "Can't move a non existent cell"


    # Initially can only move 2 and 3
    cant_move = (1..8).to_a - [1, 3]
    cant_move.each { |num| assert !@board.can_move?(num), "Moving #{num}" }
    [1, 3].each { |num| assert @board.can_move?(num), "Moving #{num}" }

    # |7|1|2|
    # |3|4|5|
    # |6| |8|
    @board.cells = mock_cells_blank_at row: 2, col: 1
    cant_move = [7, 1, 2, 3, 5]
    cant_move.each { |num| assert !@board.can_move?(num), "Moving #{num}" }
    [4, 6, 8].each { |num| assert @board.can_move?(num), "Moving #{num}" }

    # |4|1|2|
    # |3| |5|
    # |6|7|8|
    @board.cells = mock_cells_blank_at row: 1, col: 1
    cant_move = [4, 2, 6, 8]
    cant_move.each { |num| assert !@board.can_move?(num), "Moving #{num}" }
    [1, 3, 5, 7].each { |num| assert @board.can_move?(num), "Moving #{num}" }
  end

  def check_move(board, number)
    blank_pos = board.blank_position
    assert_equal blank_pos, board.position_of(number)
  end
  def test_move
    @board.cells = mock_cells

    [1, 2, 5, 4, 7, 8].each do |cell|
      b_pos = @board.blank_position
      n_pos = @board.position_of(cell)
      @board.move(cell)
      assert_equal b_pos, @board.position_of(cell)
      assert_equal n_pos, @board.blank_position
    end
    #@board.move(1) # | |1|2| => |1| |2|
    #@board.move(2) # |1| |2| => |1|2| |
    # |1|2| | ==> |1|2|5|
    # |3|4|5| ==> |3|4| |
    #@board.move(5)
    # |1|2|5| ==> |1|2|5|
    # |3|4| | ==> |3| |4|
    #@board.move(4)
    # |1|2|5| ==> |1|2|5|
    # |3| |4| ==> |3|7|4|
    # |6|7|8| ==> |6| |8|
    #@board.move(7)
    # |1|2|5| ==> |1|2|5|
    # |3|7|4| ==> |3|7|4|
    # |6| |8| ==> |6|8| |
    #@board.move(8)

    # Can't move 2, 4-8
    @board.cells = mock_cells
    cant_move = [2] + (4..8).to_a
    cant_move.each do |cell|
      exp = assert_raises(ArgumentError) do
        @board.move(cell)
      end
      assert_equal "Can't move that cell (#{cell})", exp.message
    end
  end

  def test_won?
    @board.cells = mock_cells
    assert !@board.won?, 'Should not have won'
    @board.cells = [[1, 2, 3],
                    [4, 5, 6],
                    [7, 8, " "]]
    assert @board.won?, 'Shoud have won'
  end

  # HELPER METHODS
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
