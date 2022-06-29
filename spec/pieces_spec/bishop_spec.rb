# frozen_string_literal: true

require_relative '../../lib/library'

describe Bishop do
  describe '#update_possible_moves' do
    let(:board) { Board.new }

    before do
      white_king = King.new(board.square(7, 4), 'white', board)
      black_king = King.new(board.square(0, 4), 'black', board)
      board.instance_variable_set(:@pieces, [white_king, black_king])
    end

    context 'when the board is blank' do
      it 'updates @possible_moves to include all possible moves from the middle of the board' do
        bishop = described_class.new(board.square(4, 4), 'white', board)
        bishop.update_possible_moves
        expect(bishop.possible_moves).to contain_exactly([3, 3], [2, 2], [1, 1], [0, 0], [3, 5], [2, 6], [1, 7], [5, 3], [6, 2], [7, 1], [5, 5], [6, 6], [7, 7])
      end

      it 'updates @possible_moves to include all possible moves from the edge of the board' do
        bishop = described_class.new(board.square(0, 2), 'black', board)
        bishop.update_possible_moves
        expect(bishop.possible_moves).to contain_exactly([1, 1], [2, 0], [1, 3], [2, 4], [3, 5], [4, 6], [5, 7])
      end
    end

    context 'when there are other pieces on the board' do
      subject(:bishop) { described_class.new(board.square(1, 4), 'black', board) }

      before do
        Rook.new(board.square(3, 6), 'white', board)
        Knight.new(board.square(3, 2), 'black', board)
        bishop.update_possible_moves
      end

      it 'returns moves to capture different colored pieces' do
        expect(bishop.possible_moves).to include([3, 6])
      end

      it 'does not return moves occupied by same-colored pieces' do
        expect(bishop.possible_moves).not_to include([3, 2])
      end

      it 'does not return moves past other pieces' do
        expect(bishop.possible_moves).not_to include([4, 1], [4, 7])
      end
    end

    context 'when there is a threat of check' do
      subject(:bishop) { described_class.new(board.square(7, 2), 'white', board) }

      before do
        white_king = King.new(board.square(7, 4), 'white', board)
        black_king = King.new(board.square(0, 4), 'black', board)
        rook = Rook.new(board.square(7, 0), 'black', board)
        board.instance_variable_set(:@pieces, [bishop, white_king, black_king, rook])
        board.update_all_possible_moves
      end

      it 'adds no moves that result in check to @possible_moves' do
        expect(bishop.possible_moves).to be_empty
      end
    end
  end
end
