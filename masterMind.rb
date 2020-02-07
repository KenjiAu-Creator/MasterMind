class Game
  def initialize
    @MM = MasterMind.new
    @MM.intro
    @MM.game_choices
    @MM.init_board 
    @MM.play_game
  end
end

class MasterMind
  def initialize
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
    num_of_players = gets.chomp.to_i
    case num_of_players
    when 1
        @players = [Human.new, Computer.new]
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
      @players = [Human.new, Human.new]
      puts "Is player 1 the code maker or the code breaker?"
      player_choice = gets.chomp
      case player_choice
      when "code breaker"
        puts "Code maker:"
        @code = @players[1].make_code
        @code_breaker = @players[0]
      when "code maker"
        puts "This part is for the code maker:"
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

  def play_game
    12.times do |i|
      puts "Attempt number: #{i+1}"
      if (i == 11)
       puts "Code maker wins! The code was #{@code}"
       break
      elsif (win_condition(@code_breaker.guess, @code))
        break
      else
        puts "Wrong!"
        update_board(i)
        @last_hint = hints(@code_breaker.attempts[i],@code)
      end
    end
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
    @code_breaker.attempts[attempt_number].downcase!
    @code_breaker.attempts[attempt_number].gsub!("red", "R")
    @code_breaker.attempts[attempt_number].gsub!("blue", "B")
    @code_breaker.attempts[attempt_number].gsub!("green", "G")
    @code_breaker.attempts[attempt_number].gsub!("yellow", "Y")

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
    
    @hint_row = ["", "", "", ""]
    code_copy = shorten_code(code)
    guess.gsub!(" ", "")
    for i in 0...4
      if(guess[i].match? code_copy[i])
        @hint_row[i] = ("Black")
        guess[i] = " "
        code_copy[i] = " "
      end
    end

    code_copy.gsub!(" ", "")
    guess.gsub!(" ", "")

    guess.each_char do |char|
        if (code_copy.include? char)
            code_copy.sub!("#{char}", " ")
            @hint_row[guess.index(char)] = ("White")
        end
    end
    puts @hint_row.inspect
    @hint = @hint_row
    return @hint_row
  end

  def shorten_code(code)
    @short_code = code.gsub("red", "R")
    @short_code.gsub!("blue", "B")
    @short_code.gsub!("green", "G")
    @short_code.gsub!("yellow", "Y")
    @short_code.gsub!(" ", "")
  end

  attr_reader :hint
end

class Player
end

class Human < Player
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
    puts "Red, Blue, Green and Yellow."
    @code = gets.chomp
    # Include statesment to ensure four valid colors.
  end

  attr_accessor(:attempts, :code)
end

class Computer < Player
  def initialize
    @code = computer_code
    @attempts = []
    @last_guess = ""
    @computer_guess = guess
  end

  def computer_code
    computerPegs = []
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

  def guess
    if (@last_guess == "")
      @last_guess = initial_guess
    else
      puts "Oops"
      puts @MM.inspect
      x = gets
      return update_guess(@last_guess, @MM.hint)
    end
  end

  def initial_guess
    computer_guess = []
    4.times do |i|
      computer_rand = rand(4)
      if computer_rand == 0
        computer_guess.push("Red")
      elsif computer_rand == 1
        computer_guess.push("Blue")
      elsif computer_rand == 2
        computer_guess.push("Green")
      elsif computer_rand == 3
        computer_guess.push("Yellow")
      end
    end

    computer_guess = computer_guess.join(" ")
    @attempts.push(computer_guess)
    return computer_guess
  end

  def update_guess(last_guess, hints)
    new_guess = ["", "", "", ""]
    hints.each_with_index do |color, index|
      if color == "Black"
        new_guess[index] = last_guess[index].clone
      elsif color == ""
        guess = rand(4)
        if guess == 0
          new_guess[index] = "Red"
        elsif guess == 1
          new_guess[index] = "Blue"
        elsif guess == 2
          new_guess[index] = "Green"
        elsif guess == 3
          new_guess[index] = "Yellow"
        end
      end
    end
  end

  attr_reader :code, :attempts, :computer_guess
end


game = Game.new()
