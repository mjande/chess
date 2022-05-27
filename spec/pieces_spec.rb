require_relative '../lib/pieces'

describe Piece do
  describe '#Piece.add_to_board' do
    let(:positions) { Array.new(8) { Array.new(7, nil)} }
    let(:board) { double('board', positions: positions) }

    it 'assigns pieces to starting position' do
      Rook.add_to_board('white', board)
      expect(board.positions[7][0]).to eq(' ♜ '.colorize(:white))
      Bishop.add_to_board('black', board)
      expect(board.positions[0][2]).to eq(' ♝ '.colorize(:black))
    end

    it 'returns array of created piece objects' do
      result = Rook.add_to_board('white', board)
      expect(result).to all(be_a(Rook))
      expect(result.length).to eq(2)
    end
  end
end
