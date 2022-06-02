require_relative '../lib/library'

describe Game do
  describe '#check?' do
    subject(:game) { described_class.new }
    let(:board) { Board.new }

    context 'when white is in check' do
      before do
        white_king = King.new(7, 4, 'white', board)
        game.instance_variable_set(:@white_pieces, [white_king])
        rook = Rook.new(1, 4, 'black', board)
        black_king = King.new(0, 4, 'black', board)
        game.instance_variable_set(:@black_pieces, [black_king, rook])
      end

      it 'returns white' do
        expect(game.check?).to eq('white')
      end
    end
    
    context 'when black is in check' do

      before do
        white_king = King.new(7, 4, 'white', board)
        bishop = Bishop.new(3, 1, 'white', board)
        game.instance_variable_set(:@white_pieces, [white_king, bishop])
        black_king = King.new(0, 4, 'black', board)
        game.instance_variable_set(:@black_pieces, [black_king])
      end

      it 'returns black if black is in check' do
        expect(game.check?).to eq('black')
      end
    end

    context 'there is no check' do
      it 'returns false' do
        white_king = King.new(7, 4, 'white', board)
        game.instance_variable_set(:@white_pieces, [white_king])
        black_king = King.new(0, 4, 'black', board)
        game.instance_variable_set(:@black_pieces, [black_king])
        expect(game.check?).to be_falsey
      end
    end
  end
end