require_relative '../lib/pieces'

describe Piece do
  describe '#Piece.add_to_board' do
    let(:positions) { Array.new(8) { Array.new(7, nil)} }
    let(:board) { double('board', positions: positions) }

    it 'assigns pieces to starting position' do
      Rook.add_to_board('white', board)
      expect(board.positions[7][0]).to be_a(Rook)
      Bishop.add_to_board('black', board)
      expect(board.positions[0][2]).to be_a(Bishop)
    end

    it 'returns array of created piece objects' do
      result = Rook.add_to_board('white', board)
      expect(result).to all(be_a(Rook))
      expect(result.length).to eq(2)
    end
  end
end

describe WhitePawn do
end

describe BlackPawn do
end

describe Rook do
  describe '#possible_moves' do
    let(:positions) { Array.new(8) { Array.new(7, nil) } }
    let(:board) { double('board', positions: positions) }

    it 'returns an array of all possible moves on a blank board' do
      a_rook = Rook.new(7, 0, 'white')
      board.positions[7][0] = a_rook
      possible_moves_array = [[6, 0], [5, 0], [4, 0], [3, 0], [2, 0], [1, 0], [0, 0], [7, 1], [7, 2], [7, 3], [7, 4], [7, 5], [7, 6], [7, 7]]
      expect(a_rook.possible_moves(board)).to eq(possible_moves_array)
    end
  end
end