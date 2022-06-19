require_relative 'library'

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
    loop do
      puts "If you like to save, quit, or call for a draw, type 'options'."
      input = input_move
      input.piece.move(input.row, input.column) unless special_move(input)
      board.update_all_possible_moves
      break unless check?

      puts 'That move places your king in check. Try again.'
      input.piece.undo_move
      board.update_all_possible_moves
    end
  end

  def special_move(input)
    piece = input.piece
    if piece.instance_of?(Pawn) && piece.en_passant?(input.column)
      piece.en_passant_capture(input.column)
    elsif input.type == 'kingside_castling'
      piece.kingside_castle_move
    elsif input.type == 'queenside_castling'
      piece.queenside_castle_move
    elsif input.type == 'promotion'
      piece.promote(input)
    elsif input.type == 'draw'
      draw_offer_message
    elsif input.type == 'save'
      @save = true
    end
  end

  def input_move
    loop do
      puts "#{color.capitalize}, input the coordinates of your next move."
      input_string = gets.chomp
      input = MoveInput.for(input_string, color, board)
      if input.piece.is_a?(Array)
        puts 'There are two or more pieces with that move.'
        puts 'Please indicate which piece using standard chess notation (Rdf8).'
      elsif input.instance_of?(InvalidMoveInput)
        puts 'Invalid move. Please use chess notation ("a1" or "Kc6"), or enter "save" to save or "=" to draw.'
      elsif input.piece.nil?
        puts 'There is not a piece that is able to make that move.'
      else
        return input
      end
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
