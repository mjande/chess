require_relative '../../lib/library'

describe MultiPieceMoveInput do
  describe '#find_piece' do
    let(:board) { Board.new}
    subject(:input) { described_class.new('Nbc3', 'white', board) }
    
    context 'when there is only one piece with a matching move' do
      let(:knight) { instance_double('Knight', possible_moves: [[5, 2]], 
                                     color: 'white') }

      before do 
        allow(knight).to receive(:instance_of?)
        allow(knight).to receive(:instance_of?).with(Knight).and_return(true)
        board.instance_variable_set(:@pieces, [knight])
      end

      it 'returns the matching piece' do
        expect(input.find_piece(Knight, 'white')).to eq(knight)
      end
    end

    context 'there are two or more pieces with a matching move' do
      let(:knight1) { double('knight', row: 7, column: 6, 
                                      possible_moves: [[5, 2]], color: 'white') }
      let(:knight2) { double('knight', row: 7, column: 1, 
                    possible_moves: [[5, 2]], 
                                      color: 'white') }

      before do
        allow(knight1).to receive(:instance_of?).with(Knight).and_return(true)
        allow(knight2).to receive(:instance_of?).with(Knight).and_return(true)
        board.instance_variable_set(:@pieces, [knight1, knight2])
      end

      it 'returns find matching piece based on origin' do
        expect(input.find_piece(Knight, 'white')).to eq(knight2)
      end
    end

    context 'there are no pieces with a matching move' do
      let(:rook) { instance_double('Rook', possible_moves: [1, 1], 
                                   color: 'white') }

      before do
        allow(rook).to receive(:instance_of?)
        allow(rook).to receive(:instance_of?).with(Rook).and_return(true)
        board.instance_variable_set(:@pieces, [rook])
      end

      it 'returns nil' do
        expect(input.find_piece(Knight, 'white')).to be_nil
      end
    end
  end
end
    