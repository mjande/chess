class Piece
  def initialize(color, row, column)
    @color = color
    @row = row
    @column = column
  end
end

class WhitePawn < Piece
  attr_reader :color

  def to_s
    '♙'
  end
end

class BlackPawn < Piece
  def to_s
    '♟'
  end
end

class Rook < Piece
  attr_reader :color

  def to_s
    return '♖' if color == 'white'

    '♜' if color == 'black'
  end
end

class Knight < Piece
  attr_reader :color

  def to_s
    return '♘' if color == 'white'

    '♞' if color == 'black'
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
  