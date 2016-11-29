require 'sudoku'

describe Sudoku do
  let(:valid_complete_input) {
    [
      [8, 5, 9, 6, 1, 2, 4, 3, 7],
      [7, 2, 3, 8, 5, 4, 1, 6, 9],
      [1, 6, 4, 3, 7, 9, 5, 2, 8],
      [9, 8, 6, 1, 4, 7, 3, 5, 2],
      [3, 7, 5, 2, 6, 8, 9, 1, 4],
      [2, 4, 1, 5, 9, 3, 7, 8, 6],
      [4, 3, 2, 9, 8, 1, 6, 7, 5],
      [6, 1, 7, 4, 2, 5, 8, 9, 3],
      [5, 9, 8, 7, 3, 6, 2, 4, 1]
    ]
  }

  let(:valid_incomplete_input) {
    [
      [8, 5, 9, 6, 1, 2, 4, 3, 7],
      [7, 2, 3, 8, 5, 4, 1, 6, 9],
      [1, 6, 4, 3, 7, 9, 5, 2, 8],
      [9, 8, 6, 1, 4, 7, 3, 5, 2],
      [3, 7, 5, 2, 0, 8, 9, 1, 4],
      [2, 4, 1, 5, 9, 3, 7, 8, 6],
      [4, 3, 2, 9, 8, 1, 6, 7, 5],
      [6, 1, 7, 4, 2, 5, 8, 9, 3],
      [5, 9, 8, 7, 3, 6, 2, 4, 1]
    ]
  }

  describe '#new' do
    it 'constructs a Sudoku object' do
      sudoku = Sudoku.new(valid_complete_input)

      expect(sudoku.class).to eq(Sudoku)
    end
  end

  describe '#to_s' do
    it 'returns a grid representation of the Sudoku board' do
      board = Sudoku.new(valid_complete_input).to_s

      expect(board).to eq(
        "8 5 9 6 1 2 4 3 7\n" +
        "7 2 3 8 5 4 1 6 9\n" +
        "1 6 4 3 7 9 5 2 8\n" +
        "9 8 6 1 4 7 3 5 2\n" +
        "3 7 5 2 6 8 9 1 4\n" +
        "2 4 1 5 9 3 7 8 6\n" +
        "4 3 2 9 8 1 6 7 5\n" +
        "6 1 7 4 2 5 8 9 3\n" +
        '5 9 8 7 3 6 2 4 1'
      )
    end
  end

  describe '.from_string' do
    let(:input) { File.read(File.expand_path('../fixtures/easy.sudoku', __dir__)) }

    it 'returns a Sudoku instance' do
      sudoku = Sudoku.from_string(input)

      expect(sudoku.class).to eq(Sudoku)
    end

    it 'returns a Sudoku grid containing the same numbers as the input file' do
      board = Sudoku.from_string(input).to_s

      expect(board).to eq(
        "3 0 6 0 1 5 0 0 0\n" +
        "0 0 4 0 0 0 3 0 0\n" +
        "0 0 0 0 6 8 1 9 4\n" +
        "0 8 0 0 0 6 0 0 0\n" +
        "0 0 0 2 4 9 6 0 1\n" +
        "6 4 0 0 0 0 2 0 5\n" +
        "0 0 8 0 0 3 0 1 0\n" +
        "0 3 7 8 9 1 4 6 2\n" +
        '0 2 0 6 0 0 8 0 0'
      )
    end
  end

  describe '#row' do
    it 'returns the specified row' do
      board = Sudoku.new(valid_complete_input)

      expect(board.row(2)).to eq([1, 6, 4, 3, 7, 9, 5, 2, 8])
    end
  end

  describe '#column' do
    it 'returns the specified column' do
      board = Sudoku.new(valid_complete_input)

      expect(board.column(2)).to eq([9, 3, 4, 6, 5, 1, 2, 7, 8])
    end
  end

  describe '#subgroup' do
    it 'returns the specified sub-group' do
      board = Sudoku.new(valid_complete_input)

      expect(board.subgroup(1, 1)).to eq([1, 4, 7, 2, 6, 8, 5, 9, 3])
    end
  end

  describe '#incomplete?' do
    it 'returns false if the input is complete' do
      validator = Sudoku.new(valid_complete_input)

      expect(validator.incomplete?).to eq(false)
    end

    it 'returns true if the input is incomplete' do
      validator = Sudoku.new(valid_incomplete_input)

      expect(validator.incomplete?).to eq(true)
    end
  end
end
