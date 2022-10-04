require_relative '../../lib/library'

describe MoveInput do
  describe '#self.for' do
    let(:board) { Board.new }

    it 'returns new MoveInput object for normal input' do
      expect(described_class.for('Nc3', 'white', board)).to be_a(described_class)
    end

    it 'returns new PawnMoveInput object for pawn input' do
      expect(MoveInput.for('a3', 'white', board)).to be_a(PawnMoveInput)
    end

    it 'returns MultiPieceMoveInput object for input with two or more possible pieces' do
      expect(MoveInput.for('Rhh3', 'white', board)).to be_a(MultiPieceMoveInput)
    end

    it 'returns PawnPromotionMoveInput object for pawn promotion input' do
      expect(MoveInput.for('b8Q', 'white', board)).to be_a(PawnPromotionMoveInput)
    end

    it 'returns PawnCaptureMoveInput object for pawn capture input' do
      expect(MoveInput.for('exd4', 'white', board)).to be_a(PawnCaptureMoveInput)
    end

    it 'returns CheckMoveInput object for check input' do
      expect(MoveInput.for('Rc7+', 'white', board)).to be_a(CheckMoveInput)
    end

    it 'returns CheckMoveInput object for checkmate input' do
      expect(MoveInput.for('Rc7++', 'white', board)).to be_a(CheckMoveInput)
    end

    it 'returns OtherMoveInput object for draw input' do
      expect(MoveInput.for('=', 'white', board)).to be_a(OtherMoveInput)
    end

    it 'returns OtherMoveInput object for save input' do
      expect(MoveInput.for('save', 'white', board)).to be_a(OtherMoveInput)
    end

    it 'returns InvalidMoveInput object for invalid input' do
      expect(MoveInput.for('ggg', 'white', board)).to be_a(InvalidMoveInput)
    end
  end

  describe '#find_piece' do
    let(:board) { Board.new}
    subject(:input) { described_class.new('Nc3', 'white', board) }
    
    context 'when there is only one piece with a matching move' do
      let(:knight) { instance_double('Knight', possible_moves: [[5, 2]], 
                                     color: 'white') }

      before do 
        allow(knight).to receive(:instance_of?).with(Knight).and_return(true)
        board.instance_variable_set(:@pieces, [knight])
      end

      it 'returns the matching piece' do
        expect(input.find_piece(Knight, 'white')).to eq(knight)
      end
    end

    context 'there are two or more pieces with a matching move' do
      let(:knight1) { instance_double('Knight', possible_moves: [[5, 2]], 
                                      color: 'white') }
      let(:knight2) { instance_double('Knight', possible_moves: [[5, 2]], 
                                      color: 'white') }

      before do
        allow(knight1).to receive(:instance_of?).with(Knight).and_return(true)
        allow(knight2).to receive(:instance_of?).with(Knight).and_return(true)
        board.instance_variable_set(:@pieces, [knight1, knight2])
      end

      it 'returns an array of matching pieces' do
        expect(input.find_piece(Knight, 'white')).to eq([knight1, knight2])
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