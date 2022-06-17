require_relative '../lib/player'

describe Player do
  describe '#play_turn' do
    let(:board) { Board.new }
    subject(:player) { described_class.new('white', board) }

    before do
      allow(board).to receive(:display)
      allow(player).to receive(:puts)
      allow(player).to receive(:input_move).and_return([WhitePawn, 5, 3])
    end

    context 'when player inputs a valid move that does not lead to check' do
      let(:piece) { double('piece', nil?: false, move: nil) }

      it 'sends #move to relevant piece' do
        allow(player).to receive(:find_piece).and_return(piece)
        allow(player).to receive(:check?).and_return(false)
        expect(piece).to receive(:move).with(5, 3)
        player.play_turn
      end
    end

    context 'when the player inputs an invalid move' do
      let(:piece) { double('piece', move: nil) }

      it 'loops until a valid move is inputted' do
        allow(piece).to receive(:nil?).and_return(true, false)
        allow(player).to receive(:find_piece).and_return(piece)
        allow(player).to receive(:check?).and_return(false)
        expect(piece).to receive(:nil?).twice
        player.play_turn
      end
    end

    context 'when the player inputs a move that leads to check' do
      let(:piece) { double('piece', move: nil, nil?: false) }

      it 'loops until player inputs a move that does not lead to check' do
        allow(player).to receive(:find_piece).and_return(piece)
        allow(player).to receive(:check?).and_return(true, false)
        expect(piece).to receive(:move).twice
        expect(piece).to receive(:undo_move)
        player.play_turn
      end
    end
  end
end
