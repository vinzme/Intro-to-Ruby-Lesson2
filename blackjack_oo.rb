# blackjack_oo.rb
require 'pry'

class Card

  attr_accessor :suit, :value

  def initialize(suit, value)
    @suit = suit
    @value = value
  end

  def to_s
    "The #{value} of #{suit_name}"
  end

  def suit_name
    case suit
      when "S" then "Spades"
      when "H" then "Hearts"
      when "C" then "Clubs"
      when "D" then "Diamond"
    end
  end
end


class Deck
  attr_accessor :cards

  def initialize
    num_deck = 0
    while ![1,2,3,4,5,6].include? num_deck
      puts "Enter no. of deck [1 - 6] :"
      num_deck = gets.chomp.to_i
    end
    @cards = []
    ["S", "H", "C", "D"].each do |suit|
      ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"].each do |value|
        @cards << Card.new(suit, value)
      end
    end
    @cards = @cards * num_deck
    deck_shuffle
  end

  def deck_shuffle
    cards.shuffle!
  end

  def deal_one
    cards.pop
  end
    
end


module Hand
  def show_hand
    puts "  #{name}'s Hand ---"
    cards.each do |card|
      puts "=> #{card}"
    end
    puts "=> Total: #{total}"
  end  

  def total

    values = cards.map { |card| card.value }

    total = 0

    values.each do |value|
      if value == "A"
        total += 11
      else
        total += (value.to_i == 0 ? 10 : value.to_i)
      end
    end

    values.select { |value| value == "A" }.count.times do
    break if total <= 21
    total -= 10
    end
    total
  end

  def add_card(new_card)
    cards << new_card
  end  


  def add_card(new_card)
    cards << new_card
  end

  def is_busted?
    total > 21
  end
end

class Player
  include Hand

  attr_accessor :name, :cards

  def initialize
    puts "Enter your name: "
    @name = gets.chomp
    @cards = []
  end

  def show_flop
    show_hand
  end
end

class Dealer
  include Hand

  attr_accessor :name, :cards

  def initialize
    @name = "Dealer "
    @cards = []
  end

  def show_flop
    puts "   Dealer's Hand ---"
    puts "=> First card is hidden."
    puts "=> Second card is #{cards[1]}"
  end
end


class Blackjack

  attr_accessor :deck, :player, :dealer

  def initialize
    @deck = Deck.new
    @player = Player.new
    @dealer = Dealer.new   
  end

  def deal_cards
    player.add_card(deck.deal_one)
    dealer.add_card(deck.deal_one)
    player.add_card(deck.deal_one)
    dealer.add_card(deck.deal_one)
  end

  def show_flop
    player.show_flop
    dealer.show_flop
  end

  def instant_blackjack?(player_or_dealer)
    if player_or_dealer.total == 21
      if player_or_dealer.is_a?(Dealer)
        dealer.show_hand
        puts "Sorry, dealer hits blackjack. #{player.name} loses."	
      elsif player_or_dealer.is_a?(Player)
        dealer.show_hand
        puts "Blackjack! Congratulations, #{player.name} wins!" 
      else
        dealer.show_hand
        puts "It's a tie."
      end
      play_again?
    end
  end 

  def busted?(player_or_dealer)
    if player_or_dealer.is_busted?
      if player_or_dealer.is_a?(Dealer)
        dealer.show_hand
        puts "Dealer busted. #{player.name} wins!"
      else
        player.show_hand
        puts "Sorry, #{player.name} busted. #{player.name} loses."
      end	
      play_again?
    end
  end

  def player_turn
    puts "#{player.name}'s turn:" 

    while !player.is_busted?
      puts "Hit or Stand?"
      hit_or_stand = gets.chomp.downcase

      if !["hit", "stand"].include?(hit_or_stand)
        puts "Error: Please choose: \"hit\" or \"stand\"?"
        next
      end

      if hit_or_stand == "stand"
        puts "#{player.name} stays in the game."
        break
      end

      new_card = deck.deal_one
      puts "Dealing new card for #{player.name}: #{new_card}"
      player.add_card(new_card)
      puts "#{player.name}'s total is now #{player.total}."     

      busted?(player)
    end  
  end

  def dealer_turn
    puts "Dealer's turn:"

    while dealer.total < 17
      new_card = deck.deal_one
      puts "Dealing card for dealer: #{new_card}"
      dealer.add_card(new_card)

      busted?(dealer)
    end
    dealer.show_hand
    puts "Dealer stays at #{dealer.total}."
  end

  def winner
    if player.total <= 21 && dealer.total <= 21
      if player.total > dealer.total
        puts "----"
        puts "Dealer loses. #{player.name} wins!"
      elsif dealer.total > player.total
        puts "----"
        puts "Dealer wins. #{player.name} loses."
      else
        player.total == dealer.total
        puts "----"
        puts "It's a tie!"
      end
    end
    play_again?
  end

  def play_again?
    puts " "
    puts "would you like to play again? [Yes or No]"
    play_again = gets.chomp.downcase 
    if play_again == "yes"
      puts "Starting new game:"
       
      #deck = Deck.new
     
      player.cards = []
      dealer.cards = []
      start_game
    elsif play_again == "no"
      puts "Goodbye!"
      exit
    else
      puts "Please answer \"yes\" or \"no\"."
    end
  end

  def start_game
    deal_cards
    show_flop
    instant_blackjack?(player)
    instant_blackjack?(dealer)
    player_turn
    dealer_turn
    winner
  end
end

game = Blackjack.new
game.start_game