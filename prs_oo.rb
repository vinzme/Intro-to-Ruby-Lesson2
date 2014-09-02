# prs_oo.rb
class Hand

  OPTION = { 'P' => 'Paper', 'R' => 'Rock', 'S' => 'Scissors'}

  attr_reader :name, :choice

  def initialize(n)
    @name = n
  end
end


module Winnable

  def winning_message(c,who)
    if who == "P" 
      whois = player.name
    else
      whois = computer.name
    end

    case c
    when "P"
      "Paper beats Rock! #{whois} won!"  
    when "R"
      "Rock beats Scissors! #{whois} won!"
    when "S"
      "Scissors beats Paper! #{whois} won!"
    end
  end
end


class Player < Hand

  def initialize
    @name = enter_name
  end	

  def enter_name
    system 'cls'
    puts "Welcome to Paper, Rock, Scissors Game!"
    puts "Enter your Name:"
    n = gets.chomp.upcase
  end

  def player_choice
 
    begin
      puts "#{name}, choose from : (P - Paper , R - Rock , S - Scissors)"
      @choice = gets.chomp.upcase
    end until OPTION.keys.include?(@choice)
    puts "#{name} chose #{@choice}"
    @choice
  end

end


class Computer < Hand

  def initialize
    @name = "The Computer"
  end

  def computer_choice

    @choice=OPTION.keys.sample
    puts "#{name} chose #{@choice}"
    @choice
  end
end


class Game
  include Winnable

  attr_reader :player, :computer

  def initialize
  	@player = Player.new
  	@computer = Computer.new
  end

  def display_choice
    
    pchoice = player.player_choice
    cchoice = computer.computer_choice
    case pchoice+cchoice 
    
    when "PR", "RS", "SP"
  	  puts winning_message(pchoice,"P")
    when "PP", "RR", "SS"
      puts "It's a tie!"
    else
  	  puts winning_message(cchoice,"C")
    end
  end

  def play
    display_choice
    play_again
  end

  def play_again
    begin
      puts "Play again? [Y/N]"
      answer = gets.chomp.upcase
      if answer == 'Y'
        system 'cls'
        display_choice
      elsif answer == 'N'
        puts "Goodbye #{player.name}"
      end	
    end until answer == 'N'

  end
end

g = Game.new.play