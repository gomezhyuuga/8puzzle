require 'minitest/autorun'
require 'board'

class BoardTest < MiniTest::Unit::TestCase
  def setup
    @board = Board.new
  end

  def test_print
    puts ""
    puts @board
  end
  def test_board_initialize
    # Check length
    assert_equal 9, @board.cells.length
    # Contains numbers 1 to 8 and one nil space
    (1..8).each do |num|
      assert @board.cells.index num
    end
    # Check for one empty space
    assert @board.cells.index " "
  end
end
