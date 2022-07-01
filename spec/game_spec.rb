require_relative '../lib/library'

describe Game do
  subject(:game) { described_class.new }

  let(:white_player) do
    instance_double('Player', play_turn: nil, check?: false, checkmate?: true,
                              check_message: nil, win_message: nil, draw: nil,
                              save: nil, play_again_input: nil)
  end
  let(:black_player) do
    instance_double('Player', play_turn: nil, check?: false, checkmate?: true,
                              check_message: nil, win_message: nil, draw: nil,
                              save: nil)
  end
  let(:board) do
    instance_double('Board', log_position: nil, no_possible_moves?: false,
                             dead_position?: nil, threefold_repetition?: nil,
                             moves_since_capture: 0)
  end

  before do
    game.instance_variable_set(:@white_player, white_player)
    allow(white_player).to receive(:checkmate?).and_return(false, true)
    game.instance_variable_set(:@black_player, black_player)
    allow(black_player).to receive(:checkmate?).and_return(false, true)
    game.instance_variable_set(:@board, board)
  end

  describe '#play_game' do
    before do
      game.instance_variable_set(:@next_player, white_player)
    end

    it 'sends #check_message to white_player if white player is in check' do
      allow(white_player).to receive(:check?).and_return(true)
      game.play_game
      expect(white_player).to have_received(:check_message)
    end

    it 'sends #play_turn to white_player' do
      game.play_game
      expect(white_player).to have_received(:play_turn)
    end

    it 'sends #check_message to black_player if black player is in check' do
      allow(black_player).to receive(:checkmate?).and_return(false)
      allow(black_player).to receive(:check?).and_return(true)
      game.play_game
      expect(black_player).to have_received(:check_message)
    end

    it 'sends #play_turn to black_player' do
      allow(black_player).to receive(:checkmate?).and_return(false)
      game.play_game
      expect(black_player).to have_received(:play_turn)
    end
  end

  describe '#end_game' do
    it 'sends #win_message to white_player if black_player ends in checkmate' do
      allow(white_player).to receive(:checkmate?).and_return(false)
      allow(black_player).to receive(:checkmate?).and_return(true)
      game.end_game
      expect(white_player).to have_received(:win_message)
    end

    it 'sends #win_message to black_player if white_player ends in checkmate' do
      allow(black_player).to receive(:checkmate?).and_return(false)
      allow(white_player).to receive(:checkmate?).and_return(true)
      game.end_game
      expect(black_player).to have_received(:win_message)
    end
  end

  describe '#play_again?' do
    it 'sends #play_again_input to white_player' do
      game.play_again
      expect(white_player).to have_received(:play_again_input)
    end
  end
end
