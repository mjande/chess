# frozen_string_literal: true

require_relative 'library'

# The Player class focuses on methods that interact with the player, as well as
# handling the loops and procedures for check input and procceding through the
# player's turn.
class Player
  attr_reader :color, :board, :draw
  attr_accessor :save

  def initialize(color, board)
    @color = color
    @board = board
    @draw = false
    @save = false
  end

  def play_turn
    puts board.display
    input = input_move
    input.move_piece
    check_for_special_input(input.type)
    board.update_all_possible_moves
  end

  def special_move(input)
    pawn_special_move(input.type)
    castling_special_move(input.type)
    other_special_move(input.type)
  end

  def check_for_special_input(type)
    case type
    when 'draw'
      draw_offer_message
    when 'save'
      @save = true
    end
  end

  def input_move
    loop do
      puts "#{color.capitalize}, input the coordinates of your next move."
      puts "You may also enter '=' to offer a draw, or 'save' to save your game."
      input_string = gets.chomp
      input = MoveInput.for(input_string, color, board)
      return input if move_validation(input)
    end
  end

  def move_validation(input)
    if input.piece.is_a?(Array)
      puts 'There are two or more pieces with that move.'
      puts 'Please indicate which piece using standard chess notation (Rdf8).'
    elsif input.instance_of?(InvalidMoveInput)
      puts 'Invalid move. Please use chess notation ("a1" or "Kc6"), or enter "save" to save or "=" to draw.'
    elsif input.piece.nil?
      puts 'There is not a piece that is able to make that move.'
    else
      true
    end
  end

  def king
    board.pieces.find { |piece| piece.instance_of?(King) && piece.color == color }
  end

  def check?
    king.check?
  end

  def checkmate?
    king.checkmate?
  end

  def check_message
    puts "Check! #{color.capitalize}, you must get your king out of check."
  end

  def win_message
    puts "Checkmate! #{color.capitalize}, you win!"
  end

  def draw_offer_message
    puts "#{color}, would you like to offer a draw? (Y or N)"
    response = gets.chomp
    return unless response == 'Y'

    @draw = true
  end

  def draw_acceptance_message
    puts "#{color}, your opponent has offered a draw. Do you accept? (Y or N)"
    response = gets.chomp
    return unless response == 'Y'

    @draw == true
  end

  def tie_message
    puts 'The game ended in a draw!'
  end

  def play_again_input
    puts 'Would you like to play again? (Y or N)'
    response = gets.chomp.upcase
    if response == 'Y'
      true
    else
      puts 'Thanks for playing!'
      false
    end
  end
end
