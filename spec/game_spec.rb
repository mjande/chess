require_relative '../lib/library'

describe Game do
  subject(:game) { described_class.new }
  let(:white_player) do
    double('white_player', play_turn: nil, check?: false, checkmate?: true, check_message: nil, checkmate_message: nil)
  end
  let(:black_player) do
    double('black_player', play_turn: nil, check?: false, checkmate?: true, check_message: nil, checkmate_message: nil)
  end

  before do
    game.instance_variable_set(:@white_player, white_player)
    game.instance_variable_set(:@black_player, black_player)
  end

  describe '#play_game' do
    before do
      allow(game).to receive(:end_game)
    end

    it 'sends #check_message to white_player if white player is in check' do
      allow(white_player).to receive(:check?).and_return(true)
      expect(white_player).to receive(:check_message)
      game.play_game
    end

    it 'sends #play_turn to white_player' do
      expect(white_player).to receive(:play_turn)
      game.play_game
    end

    it 'exits the loop if black_player is in checkmate' do
      allow(black_player).to receive(:checkmate?).and_return(true)
      expect(game).to receive(:end_game)
      game.play_game
    end

    it 'sends #check_message to black_player if black player is in check' do
      allow(black_player).to receive(:checkmate?).and_return(false)
      allow(black_player).to receive(:check?).and_return(true)
      expect(black_player).to receive(:check_message)
      game.play_game
    end

    it 'sends #play_turn to black_player' do
      allow(black_player).to receive(:checkmate?).and_return(false)
      expect(black_player).to receive(:play_turn)
      game.play_game
    end

    it 'exits the loop if white_player is in checkmate' do
      allow(black_player).to receive(:checkmate?).and_return(false)
      allow(white_player).to receive(:checkmate?).and_return(true)
      expect(game).to receive(:end_game)
      game.play_game
    end
  end

  describe '#end_game' do
    before do
      allow(game).to receive(:play_again)
    end

    it 'sends #win_message to white_player if black_player ends in checkmate' do
      allow(white_player).to receive(:checkmate?).and_return(false)
      allow(black_player).to receive(:checkmate?).and_return(true)
      expect(white_player).to receive(:win_message)
      game.end_game
    end

    it 'sends #win_message to black_player if white_player ends in checkmate' do
      allow(black_player).to receive(:checkmate?).and_return(false)
      allow(white_player).to receive(:checkmate?).and_return(true)
      expect(black_player).to receive(:win_message)
      game.end_game
    end
  end

  describe '#play_again?' do
    it 'sends #play_again_input to white_player' do
      expect(white_player).to receive(:play_again_input)
      game.play_again
    end
  end
end
