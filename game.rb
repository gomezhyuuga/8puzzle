require 'highline'
require 'board'
require 'byebug'

$visited = Set.new

def is_goal?(board)
  board.won?
end
def succesors(initial_board)
  states = []
  (1..8).to_a.each do |num|
    board = Board.new(initial_board.cells)
    if board.can_move?(num)
      board.move(num)
      #byebug
      can_add = board.all_cells != initial_board.all_cells
      can_add &= !$visited.include?(board.all_cells)
      states << board if can_add
      #if board.all_cells != initial_board.all_cells
    end
  end
  states
end
def bfs(start_state)
  queue = []
  state = start_state
  counter = 0

  loop do
    break if is_goal?(state)

    $visited.add state.all_cells
    queue.concat(succesors(state))
    raise "Could not generate states" if queue.empty?

    state = queue.shift
    counter += 1
  end

  return { state: state, movements: counter }
end

CLI = HighLine.new
def ask_answer
  CLI.ask "Choose the number you want to move: "
end

game = Board.new
puts "###### Initial state ######"
puts game

result = bfs(game)

puts "###### Final state ######"
puts result[:state]
puts "Total of movements: #{result[:movements]}"

