# PSEUDO CODE FOR A BLACKJACK GAME
#
# MAIN GAME PREPARATION
require 'pry'

player = {name: nil, purse: nil, hand: [], bet: nil}
dealer = {hand: []}
# ask number of player(s)

print 'Please enter your name => '
player[:name] = gets.chomp

print 'What is the amount of your initial purse? => '
player[:purse] = gets.chomp.to_i

def create_deck
  faces = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, "J", "Q", "K", "A"]
  suits = ["H", "D", "S", "C"]
  faces.product(suits)
end

def value(hand)
  value = 0
  aces_counter = 0

  hand.each do |card|
    if card[0].is_a? Integer
      value += card[0]
    elsif card[0] == "J" || card[0] == "Q" || card[0] == "K"
      value += 10
    elsif card[0] == "A"
      value += 11
      aces_counter += 1
    end
  end

  while value > 21 && aces_counter > 0
    value -= 10
    aces_counter -= 1
  end

  return value
end

def read_card(card)
  suit = nil
  face = nil

  case card[0]
  when 1 then face = "One"
  when 2 then face = "Two"
  when 3 then face = "Three"
  when 4 then face = "Four"
  when 5 then face = "Five"
  when 6 then face = "Six"
  when 7 then face = "Seven"
  when 8 then face = "Eight"
  when 9 then face = "Nine"
  when 10 then face = "Ten"
  when "J" then face = "Jack"
  when "Q" then face = "Queen"
  when "K" then face = "King"
  when "A" then face = "Ace"
  end

  case card[1]
  when "H" then suit = "Hearts"
  when "D" then suit = "Diamonds"
  when "S" then suit = "Spades"
  when "C" then suit = "Clubs"
  end

  return "#{face} of #{suit}"
end

def read_hand(hand)
  puts "Your cards are:"
  hand.each do |card| 
    puts read_card(card)
  end
  puts "Your hand's value is #{value(hand)}."
end

def blackjack?(hand)
  value(hand) == 21 && hand.length == 2 ? true : false
end

def bust?(hand)
  value(hand) > 21 ? true : false
end

def pay(player,bet_multiple)
  player[:purse] += (player[:bet] * bet_multiple).to_i
end

deck = create_deck
deck.shuffle!

print 'Enter your bet => '
player[:bet] = gets.chomp.to_i
player[:purse] -= player[:bet] 

player[:hand] << deck.pop
dealer[:hand] << deck.pop
player[:hand] << deck.pop
dealer[:hand] << deck.pop

puts "Dealer first card is #{read_card(dealer[:hand][0])}."

if blackjack?(dealer[:hand]) && blackjack?(player[:hand]) == false
  puts "Dealer has blackjack. You lose."
  puts "Dealer's cards are #{read_hand(dealer[:hand])}."
end

until bust?player[:hand] || player_action == "s"
  read_hand(player[:hand])
  print "Actions: (h)it, (s)tay => "# TODO s(u)rrender, (d)ouble-down, s(p)lit
  player_action = gets.chomp.downcase

  case player_action
  when "h"
    player[:hand] << deck.pop
  when "s"
    break
  end
end

while value(dealer[:hand]) > 17
  dealer[:hand] << deck.pop
end

if bust?(dealer[:hand])
  puts "Dealer busted!"
  if blackjack?(player[:hand])
    pay(player, 2.5)
    puts "Blackjack! You win #{(player[:bet] * 1.5).to_i}!"
  else
    pay(player, 2)
    puts "You win #{player[:bet] * 1}!"
  end
end

if blackjack?(player[:hand]) && blackjack?(dealer[:hand]) == false
  pay(player, 2.5)
  puts "Blackjack! You win #{(player[:bet] * 1.5).to_i}!"
  player[:bet] = 0
elsif value(player[:hand]) > value(dealer[:hand])
  pay(player, 2)
  puts "You win #{player[:bet] * 1}!"
  player[:bet] = 0
elsif value(player[:hand]) == value(dealer[:hand])
  pay(player, 1)
  puts "Tie! Receive your #{player[:bet]} bet back!"
  player[:bet] = 0
elsif value(player[:hand]) < value(dealer[:hand])
  puts "You lose #{player[:bet]}!"
  player[:bet] = 0
end
