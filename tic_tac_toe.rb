class Game
    $board = Array.new(3) { Array.new(3, '[ ]') }
    $board.unshift(['  ', '1' , '  2' , '  3'])
    $board[1].unshift('A ')
    $board[2].unshift('B ')
    $board[3].unshift('C ')

    $game_over = false
    $turns = 0

    def self.display_board
        $board.each { |row| puts row.join }
    end

    def self.play
        puts 'Enter first player name: '
        first = gets.chomp
        player_1 = Players.new(first, 'X')
        puts 'End second player name: '
        second = gets.chomp
        player_2 = Players.new(second, 'O')
        until $game_over
            player_1.next_move(player_1)
            $game_over ? break : player_2.next_move(player_2)
        end
    end
end

class Players < Game
    def initialize(name, mark)
        @name = name
        @mark = mark
    end

    def name
        @name.capitalize
    end

    def mark
        @mark
    end

    def next_move(player)
        Game.display_board
        enter_move
        check_winner
        $game_over ? return : $turns += 1
        if $turns == 9
            $game_over = true
            puts "Tie game."
        end
    end

    def replay_move
        puts 'Invalid move. Please try again.'
        enter_move
    end

    def enter_move
        puts "#{self.name}'s turn. Enter next move: "
        move = gets.chomp
        move.length == 2 ? update_board(move) : replay_move
    end

    def update_board(coordinate)
        coord_array = coordinate.upcase.split("")
        row = coord_array[0]
        col = coord_array[1].to_i
        if row == "A" && !invalid_move($board[1][col])
            $board[1][col] = "[#{self.mark}]"
        elsif row == "B" && !invalid_move($board[2][col])
            $board[2][col] = "[#{self.mark}]"
        elsif row == "C" && !invalid_move($board[3][col])
            $board[3][col] = "[#{self.mark}]"
        else
            replay_move
        end
    end

    def invalid_move(board_space)
        return (board_space == "[X]" || board_space == "[O]") ? true : false
    end

    def check_winner
        # Check for row win
        $board.each do |row|
            if game_won(row[1..-1])
                end_game
            end
        end
        
        row = 1
        # Check for column win
        for col in (1..3)
            if game_won([$board[row][col], $board[row + 1][col], $board[row + 2][col]])
                end_game
            end
        end

        # Check for diagonal win
        if game_won([$board[row][row], $board[row + 1][row + 1], $board[row + 2][row + 2]])
            end_game
        elsif game_won([$board[row + 2][row], $board[row + 1][row + 1], $board[row][row + 2]])
            end_game
        end
    end

    def game_won(plays)
        return plays.uniq == ["[#{self.mark}]"] ? true : false
    end

    def end_game
        $game_over = true
        puts "Game over. #{self.name} wins!"
    end
end

Game.play
