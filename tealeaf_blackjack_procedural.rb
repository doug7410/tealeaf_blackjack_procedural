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
deck = create_deck

deck.shuffle!

def value(hand)
  value = 0
  aces_value = 0

  hand.each do |card|
    if card[0].is_a? Integer
      value += card[0]
    elsif card[0] == "J" || card[0] == "Q" || card[0] == "K"
      value += 10
    elsif card[0] == "A"
      aces_value += 11
    end
  end

  while aces_value + value > 21
    aces_value -= 11
    aces_value += 1
  end

  return value + aces_value
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

print 'Enter your bet => '
player[:bet] = gets.chomp.to_i
player[:purse] -= player[:bet] 

player[:hand] << deck.pop
dealer[:hand] << deck.pop
player[:hand] << deck.pop
dealer[:hand] << deck.pop

puts "Dealer first card is #{read_card(dealer[:hand][0])}."

def blackjack?(hand)
  value(hand) == 21 && hand.length == 2 ? true : false
end

if blackjack?(dealer[:hand]) && blackjack?(player[:hand]) == false
  puts "Dealer has blackjack. You lose."
  puts "Dealer's cards are #{read_hand(dealer[:hand])}."
end

def bust?(hand)
  value(hand) > 21 ? true : false
end

# PLAYER(S) TURN (loop until all players have finished playing)
# figure out value of hand and show to player 
# player chooses option of play (loop)
  # hit means dealer delivers next card in deck to player
    # if player busts (hand value goes over 21) the player loses the bet against the dealer and the dealer discards the player's hand
  # stay means it's now the turn of the next player or the dealer (last player)
  # double down means the player doubles the bet & receives one more (final) card - can only happen once in the beginning of the player turn
# split means that the player splits the hand & adds a matching bet thus playing two hands and not one - in order to split the player must have matching pair of cards
  # surrender means the player folds the hand (plays no more) and receives half the bet
#
# DEALER TURN
# dealer hits until his hand value is 17 or greater
  # an ace in the dealer's hand is always counted as 11 if possible without the dealer going over 21
  # if the dealer busts then all plays are paid to remaining players
#
# COMPARE HAND VALUES AGAINST DEALER & PAY OUT BETS
# if a player's hand has blackjack & dealer doesn't then the player is paid 3:2 on his original bet
# if a player's hand is higher than the dealer then the player is paid 1:1 on the his original bet
# if a player's hand is lower than the dealer then the player loses the bet
