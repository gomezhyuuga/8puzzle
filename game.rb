require 'highline'
require 'board'
require 'byebug'

class HumanPlayer
  def initialize
    @cli = HighLine.new
  end
  def request_move(board = nil)
    @cli.ask("Choose the number you want to move: ").to_i
  end
end

class BFSSearch
  def initialize
    @visited = Set.new
    @counter = 0
    @queue = []
  end

  def is_goal?(board)
    board.won?
  end
  def succesors(board, backtrack=true)
    states = []

    board.possible_moves.each do |num|
      b = Board.new(board.cells)
      b.move(num)

      can_add = true
      if backtrack
        can_add = b.all_cells != board.all_cells
        can_add &= !@visited.include?(b.all_cells)
      end

      states << b if can_add
    end

    states
  end
  def generate_succesors(state)
    @queue.concat(succesors(state))
  end
  def search(state, backtrack = true)
    loop do
      break if is_goal?(state)

      @visited.add state.all_cells if backtrack

      generate_succesors(state)
      raise "Could not generate states from \n#{state}" if @queue.empty?

      state = @queue.shift
      puts state
      @counter += 1
    end
    return { state: state, movements: @counter }
  end

  def to_s
    "Breadth-First Search Algorithm"
  end
end
class ASearch < BFSSearch
  def generate_succesors(state)
    super
    @queue.sort_by! { |s| heuristic(s) }
  end
  def heuristic(state)
    cells = state.all_cells
    misplaced = 0
    (cells.length - 1).times { |i| misplaced += 1 if cells[i] != (i + 1) }

    misplaced
  end

  def to_s
    "A* Algorithm (Heuristic: misplaced cells)"
  end
end
class AIPlayer
  def initialize(algorithm)
    @ai = algorithm
  end
  def play(board)
    @ai.search(board)
  end
  def to_s
    @ai.to_s
  end
end

class Game
  def initialize(player)
    @board = Board.new [[1,2,3],
                        [4,5,6],
                        [" ",7,8]]
    #@board = Board.new
    @player = player
  end
  def play
    movements = 0
    print_header

    puts "######## INITIAL STATE ########"
    puts @board

    if @player.class == HumanPlayer
      until @board.won?
        move = @player.request_move(@board)
        break if move == "q"

        if @board.can_move?(move)
          @board.move(move)
          movements += 1
        else
          puts "Can't move that place"
        end
        puts @board
      end
    else
      r = @player.play(@board)
      movements = r[:movements]
      @board = r[:state]
    end

    puts "######## GAME FINISHED: FINAL STATE ########"
    puts @board
    puts "Movements: #{movements}"
  end

  private
  def print_header
    header = "######## Welcome ########\n"
    header += %q(
  ______   __________                     .__


 /  __  \  \______   \__ _________________|  |   ____
 >      <   |     ___/  |  \___   /\___   /  | _/ __ \
/   --   \  |    |   |  |  //    /  /    /|  |_\  ___/
\______  /  |____|   |____//_____ \/_____ \____/\___  >
       \/                        \/      \/         \/
    )
    puts header
    print_player
  end
  def print_player
    puts "< Using as player: #{@player} >"
  end
end

modes = %w[human bfs astar]
unless ARGV[0] || modes.index(ARGV[0])
  puts "Usage: rake < human | bfs | astar >"
  exit
end

game = case ARGV[0]
       when "human" then Game.new(HumanPlayer.new)
       when "bfs"   then Game.new(AIPlayer.new(BFSSearch.new))
       when "astar" then Game.new(AIPlayer.new(ASearch.new))
       end
game.play
