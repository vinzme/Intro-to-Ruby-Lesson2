# ttt_oo.rb
class Board
  WINNING_STRING = " 123 456 789 147 258 369 159 357 "
  attr_reader :b

  def initialize
    @b = {}
    (1..9).each { |position| @b[position] = ' '}
    @b
  end

  def draw_board
    system 'cls'
    puts " #{b[1]} | #{b[2]} | #{b[3]} "
    puts "-----------"
    puts " #{b[4]} | #{b[5]} | #{b[6]} "
    puts "-----------"
    puts " #{b[7]} | #{b[8]} | #{b[9]} "
  end

  def empty_position
    b.select { |k,v| v == ' '}.keys
  end

  def get_winning_string(s,p,xo)
    while (s.include? p.to_s) && (p != nil)
      s = s[0,s.index(p.to_s)] + xo + s[s.index(p.to_s)+1,s.length-(s.index(p.to_s)+1)]
    end
    s
  end

  def check_winner(w)
    if w.include? 'XXX'
      puts "You Won!"
    elsif 
      if w.include? 'OOO'
        puts "Computer Won!"
      else
        puts "No winner!"
      end
    end
  end
end

class Player
  attr_reader :name, :position

  def initialize(n)
    @name = n
  end
end

class Human < Player

  def initialize
    @name = enter_name
  end	

  def enter_name
    system 'cls'
    puts "Welcome to Tic, Tac, Toe!"
    puts "Enter your Name:"
    n = gets.chomp.upcase
  end

  def player_picks(b)
    begin  
      puts "#{name}, pick a square (1 - 9) :"
      @position = gets.chomp.to_i
      if @position.to_i == 0
        puts "Empty. Select again."
        next
      elsif b.b[@position] != ' '
        puts "Occupied square. Select again."
        next
      end
    end until b.empty_position.include?(@position) 
    b.b[@position] = 'X'
    @position
  end
end

class Computer < Player

  def initialize
    @name = "The Computer"
  end

  def computer_picks(b)
    @position = b.empty_position.sample
    b.b[@position] = 'O'
    @position
  end
end

class Game

  attr_reader :player, :computer, :board

  def initialize
    @player = Human.new
    @computer = Computer.new
  end
  
  def play
    @board = Board.new
    board.draw_board
    win_str = Board::WINNING_STRING
    begin
      pos = player.player_picks(board) 
      win_str = board.get_winning_string(win_str,pos,'X')

      pos = computer.computer_picks(board)
      win_str = board.get_winning_string(win_str,pos,'O')
      
      board.draw_board
    end until (win_str.include? 'XXX') || (win_str.include? 'OOO') || (board.empty_position == [])

    board.check_winner(win_str)  
       
    puts "Do you want to play again?[y/n]"
    gets.chomp.downcase == 'y' ? play : exit
  end
end

g = Game.new.play