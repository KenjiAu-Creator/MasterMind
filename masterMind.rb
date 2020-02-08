class MasterMind
  def initialize
    intro
    game_choices
    init_board
    play_game(@opponent)
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

  def game_choices
    puts "How many players (1 or 2)?"
    players_choice = gets.chomp.to_i
    case players_choice
    when 1
      @opponent = "computer"
      @players = [Player.new, Computer.new]
      puts "Do you wish to be the code breaker or the code maker?"
      player_choice = gets.chomp
      case player_choice
      when "code breaker"
        @code = @players[1].code
        @code_breaker = @players[0]
      when "code maker"
        @code = @players[0].make_code
        @code_breaker = @players[1]
      end
    when 2
      @opponent = "human"
      @players = [Player.new, Player.new]
      puts "Is player 1 the code maker or the code breaker?"
      player_choice = gets.chomp
      case player_choice
      when "code breaker"
        @code = @players[1].make_code
        @code_breaker = @players[0]
      when "code maker"
        @code = @players[0].make_code
        @code_breaker = @players[1]
      end
    end
  end
  

  def init_board
    @board = []

    12.times do |i|
      @board.push("|   o    |    o    |    o    |    o   | Row: #{i + 1} ")
      @board.push("---------+---------+---------+--------")
    end

    puts @board
  end

  def play_game(opponent)
    if opponent == "human"
      12.times do |i|
        @guess = @code_breaker.guess
        puts "Attempt number: #{i+1}"
        if (i == 11)
          puts "Code maker wins! The code was #{@code}"
          break
        elsif (win_condition(@guess, @code))
          break
        else
          update_board(i)
          puts "Incorrect!"
          hints(@code_breaker.attempts[i],@code)
        end
      end
    elsif opponent == "computer"
      12.times do |i|
        if (i == 0)
          @guess = @code_breaker.guess.clone
        elsif (i == 11)
          puts "Code maker wins! The code was #{@code}"
          break
        end

        if win_condition(@guess, @code)
          puts "Code Breaker wins!"
          break
        else
          update_board(i)
          puts "Incorrect!"
          @last_hint = hints(@code_breaker.attempts[i], @code).clone
          if @code_breaker === @players[1]
            @guess = update_guess(@code_breaker.attempts[i], @last_hint)
          else
            @guess = @code_breaker.guess
          end
        end
      end
    end
  end

  def update_guess(guess, last_hint)
    new_guess = Array.new
    guess = guess.split(" ")
    puts guess.inspect
    for i in 0..3
      puts i
      if last_hint[i] == "Black"
        puts "Hihi"
        new_guess[i] = guess[i]
      else
        computer_rand = rand(4)
        if computer_rand == 0
          new_guess[i] = ("R")
        elsif computer_rand == 1
          new_guess[i] = ("B")
        elsif computer_rand == 2
          new_guess[i] = ("G")
        elsif computer_rand == 3
          new_guess[i] = ("Y")
        end
      end
    end
    puts "This is the new_guess"
    puts new_guess.inspect
    new_guess = new_guess.join(" ")
    puts new_guess
    @code_breaker.attempts.push(new_guess)
    return new_guess
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
    # @code_breaker.attempts[attempt_number].downcase!
    # @code_breaker.attempts[attempt_number].gsub!("red", "R")
    # @code_breaker.attempts[attempt_number].gsub!("blue", "B")
    # @code_breaker.attempts[attempt_number].gsub!("green", "G")
    # @code_breaker.attempts[attempt_number].gsub!("yellow", "Y")

    colors = @code_breaker.attempts[attempt_number].split(" ")
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
    
    @hint_row = Array.new
    code_copy = code.gsub(" ", "")

    # human breaker solution
    guess_copy = guess.gsub(" ", "")
    puts "This is the code"
    puts code_copy
    puts "This is the guess"
    puts guess_copy

    for i in 0...4
      if(guess_copy[i].match? code_copy[i])
        @hint_row[i] = ("Black")
        guess_copy[i] = " "
        code_copy[i] = " "
      else
        @hint_row[i] = ""
      end
    end

    code_copy.gsub!(" ", "")

    guess_copy.each_char do |char|
        if (code_copy.include? char)
            code_copy.sub!("#{char}", "")
            @hint_row[guess_copy.index(char)] = ("White")
        end
    end
    puts @hint_row.inspect
    return @hint_row
  end
end

class Player
  def initialize
    @attempts = []
    @code = ""
  end

  def guess
    puts "Please enter your guess of four colors for the code:"
    puts "Available colors are: Red, Blue, Green, and Yellow."
    player_guess = gets.chomp
    @attempts.push(player_guess)
    return player_guess
  end

  def make_code
    puts "Please enter your four color secret code. Colors to choose from are:"
    puts "Red, Blue, Green, and Yellow."
    @code = gets.chomp
  end

  attr_accessor :attempts, :code
end

class Computer
  def initialize
    @code = computer_code 
    @attempts = []
    @computer_guess = guess 
  end

  def computer_code
    computerPegs = []
    #Four pegs, four colors to start. Red, Blue, Green, Yellow
    4.times do |i|
      peg = rand(4)
      if peg == 0
        computerPegs[i] = "R"
      elsif peg == 1
        computerPegs[i] = "B"
      elsif peg == 2
        computerPegs[i] = "G"
      elsif peg == 3
        computerPegs[i] = "Y"
      end
    end
    computerPegs = computerPegs.join(" ")
    return computerPegs
  end

  def guess
    computer_guess = []
    4.times do |i|
      computer_rand = rand(4)
      if computer_rand == 0
        computer_guess.push("R")
      elsif computer_rand == 1
        computer_guess.push("B")
      elsif computer_rand == 2
        computer_guess.push("G")
      elsif computer_rand == 3
        computer_guess.push("Y")
      end
    end

    computer_guess = computer_guess.join(" ")
    @attempts.push(computer_guess)
    return computer_guess
  end

  attr_reader :code, :attempts, :computer_guess
end


game = MasterMind.new()
