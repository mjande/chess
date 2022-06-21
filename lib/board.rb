require 'colorize'

class Board
  attr_reader :data_array, :pieces
  attr_accessor :moves_since_capture

  def initialize
    @data_array = Array.new(8) { Array.new(8, nil) }
    @pieces = []
    @log = []
    @moves_since_capture = 0
  end

  def add_starting_pieces
    piece_types = [Rook, Knight, Bishop, Queen, King, Pawn]
    piece_types.each do |piece_type|
      piece_type.add_white_pieces_to_board(self)
      piece_type.add_black_pieces_to_board(self)
    end
  end

  def update_all_possible_moves
    pieces.each(&:update_possible_moves)
    pieces.select { |piece| piece.instance_of?(King) }.each(&:update_possible_moves)
  end

  def no_possible_moves?(player)
    player_pieces = pieces.select { |piece| piece.color == player.color }
    player_pieces.all? { |piece| piece.possible_moves.empty? }
  end

  def dead_position?
    case pieces.length
    when 4
      dead_bishops_position?
    when 3
      knight_count = pieces.count { |piece| piece.instance_of?(Knight) }
      bishop_count = pieces.count { |piece| piece.instance_of?(Bishop) }
      knight_count == 1 || bishop_count == 1
    end
  end

  def threefold_repetition?
    current_board = @log[-1]
    repetitions = @log.count { |board_layout| board_layout == current_board }
    repetitions > 2
  end

  def clone
    YAML.load(YAML.dump(self))
  end

  def add_background_color(array)
    array.map.with_index do |row, row_index|
      row.map.with_index do |position, column_index|
        if row_index.even?
          if column_index.even?
            position.to_s.colorize(background: :white)
          else
            position.to_s.colorize(background: :light_black)
          end
        elsif row_index.odd?
          if column_index.even?
            position.to_s.colorize(background: :light_black)
          else
            position.to_s.colorize(background: :white)
          end
        end
      end
    end
  end

  def display
    column_labels = '   a  b  c  d  e  f  g  h   '

    printable_board = clean_rows

    printable_board + column_labels
  end

  def clean_rows
    clean_rows = data_array.map do |row|
      row.map { |position| position.nil? ? '   ' : position }
    end

    clean_rows = add_background_color(clean_rows)

    row_number = 8
    clean_rows.each do |row|
      row.unshift("#{row_number} ")
      row.push("\n")
      row_number -= 1
    end

    clean_rows.join
  end

  def log_position
    @log << display
  end

  def on_the_board?(row, column)
    row.between?(0, 7) && column.between?(0, 7)
  end

  def open?(row, column)
    return unless on_the_board?(row, column)

    [row, column] if data_array[row][column].nil?
  end

  def different_color?(row, column, color)
    return unless on_the_board?(row, column) && !open?(row, column)

    piece = data_array[row][column]
    [row, column] if piece.color != color
  end

  def at_position(row, column)
    data_array[row][column]
  end

  def clear_position(row, column)
    data_array[row][column] = nil
  end

  def add_to_position(row, column, piece)
    data_array[row][column] = piece
  end

  private

  def dead_bishops_position?
    bishops = pieces.select { |piece| piece.instance_of?(Bishop) }
    return unless bishops.length == 2

    bishops[0].territory == bishops[1].territory
  end
end
