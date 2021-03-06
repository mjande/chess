# frozen_string_literal: true

require_relative '../../lib/library'

describe Bishop do
  let(:board) { Board.new }

  describe '#update_possible_moves' do
    before do
      white_king = King.new(7, 4, 'white', board)
      black_king = King.new(0, 4, 'black', board)
      board.instance_variable_set(:@pieces, [white_king, black_king])
    end

    context 'when the board is blank' do
      let(:center_bishop) { described_class.new(4, 4, 'white', board) }
      let(:edge_bishop) { described_class.new(0, 2, 'black', board) }

      it 'updates possible moves from middle of the board' do
        center_bishop.update_possible_moves
        expect(center_bishop.possible_moves).to contain_exactly(
          [3, 3], [2, 2], [1, 1], [0, 0], [3, 5], [2, 6], [1, 7], [5, 3],
          [6, 2], [7, 1], [5, 5], [6, 6], [7, 7]
        )
      end

      it 'updates possible moves from the edge of the board' do
        edge_bishop.update_possible_moves
        expect(edge_bishop.possible_moves).to contain_exactly(
          [1, 1], [2, 0], [1, 3], [2, 4], [3, 5], [4, 6], [5, 7]
        )
      end
    end

    context 'when there are other pieces on the board' do
      subject(:bishop) { described_class.new(1, 4, 'black', board) }

      before do
        Rook.new(3, 6, 'white', board)
        Knight.new(3, 2, 'black', board)
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
      subject(:bishop) { described_class.new(7, 2, 'white', board) }

      before do
        white_king = King.new(7, 4, 'white', board)
        black_king = King.new(0, 4, 'black', board)
        rook = Rook.new(7, 0, 'black', board)
        board.instance_variable_set(:@pieces, [bishop, white_king, black_king,
                                               rook])
        board.update_all_possible_moves
      end

      it 'adds no moves that result in check to @possible_moves' do
        expect(bishop.possible_moves).to be_empty
      end
    end
  end
end
