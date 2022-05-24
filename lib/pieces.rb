class Piece
  def initialize(row, column)
    @row = row
    @column = column
  end
end

class WhitePawn < Piece
  START = [[6, 0], [6, 1], [6, 2], [6, 3], [6, 4], [6, 5], [6, 6], [6, 7]]

  def self.create_pieces(board)
    pawns = []
    START.each do |position|
      row = position[0]
      column = position[1]
      pawn = new(row, column)
      pawns << pawn
      board.position_array[row][column] = '♙'
    end
    pawns
  end
end

class BlackPawn < Piece
  START = [[1, 0], [1, 1], [1, 2], [1, 3], [1, 4], [1, 5], [1, 6], [1, 7]]

  def self.create_pieces(board)
    pawns = []
    START.each do |position|
      row = position[0]
      column = position[1]
      pawn = new(row, column)
      pawns << pawn
      board.position_array[row][column] = '♟'
    end
    pawns
  end
end

class Rook < Piece
  WHITE_START = [[7, 0], [7, 7]]
  BLACK_START = [[0, 0], [0, 7]]

  def self.create_pieces(color, board)
    rooks = []
    if color == 'white'
      starting_positions = WHITE_START
      symbol = '♖'
    else
      starting_positions = BLACK_START
      symbol = '♜'
    end

    starting_positions.each do |position|
      row = position[0]
      column = position[1]
      rook = new(row, column)
      rooks << rook
      board.position_array[row][column] = symbol
    end
    rooks
  end
end

class Knight < Piece
  WHITE_START = [[7, 1], [7, 6]]
  BLACK_START = [[0, 1], [0, 6]]

  def self.create_pieces(color, board)
    knights = []
    if color == 'white'
      starting_positions = WHITE_START
      symbol = '♘'
    else
      starting_positions = BLACK_START
      symbol = '♞'
    end

    starting_positions.each do |position|
      row = position[0]
      column = position[1]
      knight = new(row, column)
      knights << knight
      board.position_array[row][column] = symbol
    end
    knights
  end
end

class Bishop < Piece
  attr_reader :color

  def to_s
    return '♗' if color == 'white'

    '♝' if color == 'black'
  end
end

class Queen < Piece
  attr_reader :color

  def to_s
    return '♕' if color == 'white'

    '♛' if color == 'black'
  end
end

class King < Piece
  attr_reader :color

  def to_s
    return '♔' if color == 'white'

    '♚' if color == 'black'
  end
end
  