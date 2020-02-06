class MasterMind
  def initialize
    intro
    @players = [Player.new, Computer.new]
    init_board
    @short_comp_code = shorten_code(@players[1].code) 
    play_game
  end

  def intro
    puts "Welcome to MasterMind!"
    puts "One player becomes the codemaker, the other the codebreaker."
    puts "The codemaker chooses a pattern of four code pegs. Duplicates and blanks are allowed"
    puts "depending on player choice, so the player could even choose four code pegs of the same"
    puts "color or four blanks. In the instance that blanks are not elected to be a part of the"
    puts "game, the codebreaker may not use blanks in order to establish the final code."
    puts ""
    puts "The codebreaker tries to guess the pattern, in both order and color, within eight to tweleve"
    puts "turns. Each guess is made by placing a row of code pegs on the decoding board. Once played"
    puts "the codemaker provides feedback by playing from zero to four pegs."
    puts ""
    puts "Ready to play? (press enter to continue)"
    step = gets
  end
  def init_board
    @board = []

    12.times do |i|
      @board.push("|   o    |    o    |    o    |    o   | Row: #{i + 1} ")
      @board.push("---------+---------+---------+--------")
    end

    puts @board
  end

  def play_game
    12.times do |i|
      puts "Attempt number: #{i+1}"
      if (win_condition(@players[0].player_guess, @players[1].code))
        break
      else
        puts "Wrong!"
        update_board(i)
        hints(@players[0].attempts[i],@short_comp_code)
      end
    end
    puts "Code maker wins! The code was #{@players[1].code}"
  end

  def win_condition(guess, code)
    if (guess == code)
      puts "The code is solved! The code breaker wins!"
      return true
    else 
      return false
    end
  end

  def update_board(attempt_number)
    @players[0].attempts[attempt_number].downcase!
    @players[0].attempts[attempt_number].gsub!("red", "R")
    @players[0].attempts[attempt_number].gsub!("blue", "B")
    @players[0].attempts[attempt_number].gsub!("green", "G")
    @players[0].attempts[attempt_number].gsub!("yellow", "Y")

    colors = @players[0].attempts[attempt_number].split(" ")
    row_num = (22 - 2 * attempt_number)
    4.times do |i|
      @board[row_num].sub!("o", "#{colors[i]}")
    end

    puts @board
  end

  def hints(guess, code)
    puts "Here are your hints!"
    puts "A black key peg indicates correct color and position."
    puts "A white key peg indicates correct color but incorrect position."
    
    @hint_row = []
    code_copy = code.clone

    for i in 0...4
      if(code[2 * i].match? guess[2 * i])
        @hint_row.push("Black")
        guess[2 * i] = " "
        code_copy[2 * i] = " "
      end
    end

    guess.gsub!(" ", "")
    guess.each_char do |char|
        if (code_copy.include? char)
            code_copy.sub!("#{char}", " ")
            @hint_row.push("white")
        end
    end
    puts @hint_row.inspect
  end

  def shorten_code(code)
    @short_code = code.gsub("red", "R")
    @short_code.gsub!("blue", "B")
    @short_code.gsub!("green", "G")
    @short_code.gsub!("yellow", "Y")
  end
end

class Player
  def initialize
    @attempts = []
  end

  def player_guess
    puts "Please enter your guess of four colors for the code:"
    puts "Available colors are: Red, Blue, Green, and Yellow."
    guess = gets.chomp
    @attempts.push(guess)
    return guess
  end
  attr_accessor :attempts
end

class Computer
  def initialize
    @code = computer_code  
  end

  def computer_code
    computerPegs = []
    #Four pegs, four colors to start. Red, Blue, Green, Yellow
    4.times do |i|
      peg = rand(4)
      if peg == 0
        computerPegs[i] = "red"
      elsif peg == 1
        computerPegs[i] = "blue"
      elsif peg == 2
        computerPegs[i] = "green"
      elsif peg == 3
        computerPegs[i] = "yellow"
      end
    end
    computerPegs = computerPegs.join(" ")
    return computerPegs
  end
   attr_reader :code
end


game = MasterMind.new()
computerPlayer = Computer.new()
