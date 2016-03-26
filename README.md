# 8-puzzle game

## Run
If you are using bundler, run:
```
$ bundle install
```

If not, you must install the next dependecies;
```
$ gem install highline minitest byebug
```

Run the game with:
```
$ rake < human | bfs | astar >
```

Example:

```
$ rake astar                                                           
ruby -I . -w game.rb astar
######## Welcome ########

  ______   __________                     .__


 /  __  \  \______   \__ _________________|  |   ____
 >      <   |     ___/  |  \___   /\___   /  | _/ __ \
/   --   \  |    |   |  |  //    /  /    /|  |_\  ___/
\______  /  |____|   |____//_____ \/_____ \____/\___  >
       \/                        \/      \/         \/
    
< Using as player: A* Algorithm (Heuristic: misplaced cells) >
######## INITIAL STATE ########
1|2|3
4|5|6
 |7|8

1|2|3
4|5|6
7| |8

1|2|3
4|5|6
7|8| 

######## GAME FINISHED: FINAL STATE ########
1|2|3
4|5|6
7|8| 

Movements: 2
```

## Requirements
- Ruby 2.2.1
- Rake

## Search Algorithms
- Breadth-First Search
- A*
