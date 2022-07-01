# frozen_string_literal: true

require_relative '../lib/player'

describe Player do
  let(:board) do
    instance_double('Board', display: nil, update_all_possible_moves: nil)
  end
  let(:move_input) do
    instance_double('MoveInput', piece: Pawn, move_piece: nil, type: nil)
  end

  describe '#play_turn' do
    subject(:player) { described_class.new('white', board) }

    before do
      allow(player).to receive(:gets).and_return('test')
      allow(MoveInput).to receive(:for).and_return(move_input)
    end

    it 'sends #display to board' do
      player.play_turn
      expect(board).to have_received(:display)
    end

    it 'sends message to MoveInput factory' do
      player.play_turn
      expect(MoveInput).to have_received(:for)
    end

    it 'sends #update_all_possible_moves to board' do
      player.play_turn
      expect(board).to have_received(:update_all_possible_moves)
    end
  end
end
