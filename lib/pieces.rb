class Piece
  def initialize(color)
    @color = color
  end
end

class Pawn < Piece
  attr_reader :color

  def to_s
    '♙' if color == 'white'
    '♟' if color == 'black'
  end
end

class Rook < Piece
  attr_reader :color

  def to_s
    '♖' if color == 'white'
    '♜' if color == 'black'
  end
end

class Knight < Piece
  attr_reader :color

  def to_s
    '♘' if color == 'white'
    '♞' if color == 'black'
  end
end

class Bishop < Piece
  attr_reader :color

  def to_s
    '♗' if color == 'white'
    '♝' if color == 'black'
  end
end

class Queen < Piece
  attr_reader :color

  def to_s
    '♕' if color == 'white'
    '♛' if color == 'black'
  end
end

class King < Piece
  attr_reader :color
  
  def to_s
    '♔' if color == 'white'
    '♚' if color == 'black'
  end
end
  