require_relative '../lib/pieces'

describe Piece do
  describe '#Piece.add_to_board' do
    let(:position_array) { Array.new(8) { Array.new(7, nil)} }
    let(:board) { double('board', position_array: position_array) }

    it 'assigns pieces to starting position' do
      Rook.add_to_board('white', board)
      expect(board.position_array[7][0]).to eq('♖')
      expect(board.position_array[7][7]).to eq('♖')
    end

    it 'returns array of created piece objects' do
      result = Rook.add_to_board('white', board)
      expect(result).to all(be_a(Rook))
      expect(result.length).to eq(2)
    end
  end
end
