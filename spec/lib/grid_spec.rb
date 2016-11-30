require 'grid'

describe Grid do
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

  let(:input_from_file) { File.read(File.expand_path('../fixtures/easy.sudoku', __dir__)) }

  describe '#new' do
    it 'constructs a Grid object' do
      grid = Grid.new(valid_complete_input)

      expect(grid.class).to eq(Grid)
    end
  end

  describe '#to_s' do
    it 'returns a string representation of the Grid' do
      grid = Grid.new(valid_complete_input).to_s

      expect(grid).to eq(
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

  describe '#pretty' do
    it 'returns a formatted string representation of the Grid' do
      grid = Grid.new(valid_complete_input).pretty

      expect(grid).to eq(
        "8 5 9 |6 1 2 |4 3 7\n" +
        "7 2 3 |8 5 4 |1 6 9\n" +
        "1 6 4 |3 7 9 |5 2 8\n" +
        "------+------+------\n" +
        "9 8 6 |1 4 7 |3 5 2\n" +
        "3 7 5 |2 6 8 |9 1 4\n" +
        "2 4 1 |5 9 3 |7 8 6\n" +
        "------+------+------\n" +
        "4 3 2 |9 8 1 |6 7 5\n" +
        "6 1 7 |4 2 5 |8 9 3\n" +
        '5 9 8 |7 3 6 |2 4 1'
      )
    end
  end

  describe '.from_string' do
    it 'returns a Grid instance' do
      grid = Grid.from_string(input_from_file)

      expect(grid.class).to eq(Grid)
    end

    it 'returns a Grid containing the same numbers as the input file' do
      grid = Grid.from_string(input_from_file).to_s

      expect(grid).to eq(
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

  describe '#get' do
    it 'returns the value at the specified cell' do
      grid = Grid.new(valid_complete_input)

      expect(grid.get(2, 3)).to eq(6)
    end

    it 'returns the value at the specified cell' do
      grid = Grid.from_string(input_from_file)

      expect(grid.get(5, 7)).to eq(1)
    end
  end

  describe '#set' do
    it 'sets the value at the specified cell' do
      grid = Grid.new(valid_complete_input)

      grid.set(2, 3, 7)

      expect(grid.get(2, 3)).to eq(7)
    end
  end

  describe '#row' do
    it 'returns the specified row' do
      grid = Grid.new(valid_complete_input)

      expect(grid.row(2)).to eq([1, 6, 4, 3, 7, 9, 5, 2, 8])
    end
  end

  describe '#column' do
    it 'returns the specified column' do
      grid = Grid.new(valid_complete_input)

      expect(grid.column(2)).to eq([9, 3, 4, 6, 5, 1, 2, 7, 8])
    end
  end

  describe '#subgroup' do
    it 'returns the specified sub-group' do
      grid = Grid.new(valid_complete_input)

      expect(grid.subgroup(1, 1)).to eq([1, 4, 7, 2, 6, 8, 5, 9, 3])
    end
  end

  describe '#complete?' do
    it 'returns true if the input is complete' do
      grid = Grid.new(valid_complete_input)

      expect(grid.complete?).to eq(true)
    end

    it 'returns false if the input is incomplete' do
      grid = Grid.new(valid_incomplete_input)

      expect(grid.complete?).to eq(false)
    end
  end

  describe '#cell_solution_candidates' do
    it 'returns the possible values for a given cell of the grid' do
      grid = Grid.new(valid_incomplete_input)

      expect(grid.cell_solution_candidates(4, 4)).to eq([6])
    end

    it 'returns the possible values for a given cell of the grid' do
      grid = Grid.from_string(input_from_file)

      expect(grid.cell_solution_candidates(0, 7)).to eq([5])
    end
  end

  describe '#all_solution_candidates' do
    it 'returns the coordinates, and the solution candidates of all cells with zero value' do
      grid = Grid.new([
        [8, 5, 9, 6, 1, 2, 4, 3, 7],
        [7, 2, 3, 8, 5, 4, 1, 6, 9],
        [1, 6, 4, 3, 7, 9, 5, 2, 8],
        [9, 8, 6, 1, 4, 7, 3, 5, 2],
        [3, 7, 5, 2, 0, 8, 0, 1, 4],
        [2, 4, 1, 5, 0, 3, 0, 8, 6],
        [4, 3, 2, 9, 8, 1, 6, 7, 5],
        [6, 1, 7, 4, 2, 5, 8, 9, 3],
        [5, 9, 8, 7, 3, 6, 2, 4, 1]
      ])

      expect(grid.all_solution_candidates).to eq([Grid::SolutionCandidate.new(6, 4, [9]),
                                                  Grid::SolutionCandidate.new(4, 5, [9]),
                                                  Grid::SolutionCandidate.new(4, 4, [6, 9]),
                                                  Grid::SolutionCandidate.new(6, 5, [7, 9])])
    end
  end

  describe '#copy' do
    it 'returns a copy of itself that has the same values' do
      grid1 = Grid.from_string(input_from_file)

      grid2 = grid1.copy

      expect(grid2.to_s).to eq(grid1.to_s)
    end

    it 'returns a new Grid instance' do
      grid1 = Grid.from_string(input_from_file)

      grid2 = grid1.copy

      expect(grid2).not_to equal(grid1)
    end

    it 'is independent from the original grid' do
      grid1 = Grid.from_string(input_from_file)

      grid2 = grid1.copy
      grid2.set(2, 1, 3)

      expect(grid1.get(2, 1)).to eq(4)
    end
  end
end
