require 'solver_grid'
require 'grid'

describe SolverGrid do
  let(:input) { File.read(File.expand_path('../fixtures/hard.sudoku', __dir__)) }

  describe '#new' do
    it 'returns a new SolverGrid' do
      grid = Grid.from_string(input)

      solver_grid = SolverGrid.new(grid)

      expect(solver_grid.class).to eq(SolverGrid)
    end
  end

  describe '#cell' do
    it 'returns the possible values for the given cell' do
      solver_grid = SolverGrid.new(Grid.from_string(input))

      cell = solver_grid.cell(1, 2)

      expect(cell).to eq([1, 5, 6, 8, 9])
    end
  end

  describe '#row' do
    it 'returns an array of the possible values for each cell in the given row' do
      solver_grid = SolverGrid.new(Grid.from_string(input))

      row = solver_grid.row(6)

      expect(row).to eq([[2, 8, 9], [8, 9], [2, 8, 9], [6], [4, 5, 9], [3], [1, 2, 5, 9], [7], [1, 2, 4, 8, 9]])
    end

    it 'returns an array of the possible values for each cell in the given row, except for the specified column' do
      solver_grid = SolverGrid.new(Grid.from_string(input))

      row = solver_grid.row(6, except_column: 3)

      expect(row).to eq([[2, 8, 9], [8, 9], [2, 8, 9], [4, 5, 9], [3], [1, 2, 5, 9], [7], [1, 2, 4, 8, 9]])
    end
  end

  describe '#column' do
    it 'returns an array of the possible values for each cell in the given column' do
      solver_grid = SolverGrid.new(Grid.from_string(input))

      column = solver_grid.column(4)

      expect(column).to eq([
        [2, 3, 6, 9], [2, 4, 5, 6, 9], [2, 3, 4, 5, 6, 9], [3, 4, 5, 7, 9], [8], [1], [4, 5, 9], [4, 7, 9], [5, 7, 9]
      ])
    end

    it 'returns an array of the possible values for each cell in the given column, except for the specified row' do
      solver_grid = SolverGrid.new(Grid.from_string(input))

      column = solver_grid.column(4, except_row: 2)

      expect(column).to eq([
        [2, 3, 6, 9], [2, 4, 5, 6, 9], [3, 4, 5, 7, 9], [8], [1], [4, 5, 9], [4, 7, 9], [5, 7, 9]
      ])
    end
  end

  describe '#subgroup' do
    it 'returns an array of the possible values for each cell in the given subgroup' do
      solver_grid = SolverGrid.new(Grid.from_string(input))

      subgroup = solver_grid.subgroup(2, 1)

      expect(subgroup).to eq([
        [1, 3, 5, 7, 9], [6],             [1, 3, 7, 8, 9],
        [4],             [1, 2, 3, 5, 9], [1, 2, 3, 7, 9],
        [2, 3, 5, 7, 9], [2, 3, 5, 8, 9], [2, 3, 7, 8, 9]
      ])
    end

    it 'returns an array of the possible values for each cell in the given subgroup, except for the specified cell' do
      solver_grid = SolverGrid.new(Grid.from_string(input))

      subgroup = solver_grid.subgroup(2, 1, except_at: [8, 4])

      expect(subgroup).to eq([
        [1, 3, 5, 7, 9], [6],             [1, 3, 7, 8, 9],
        [4],             [1, 2, 3, 5, 9],
        [2, 3, 5, 7, 9], [2, 3, 5, 8, 9], [2, 3, 7, 8, 9]
      ])
    end
  end

  describe '#solve' do
    it 'figures out as many values as possible from the current state of the grid' do
      grid = Grid.from_string(input)

      solver_grid = SolverGrid.new(grid)
      solver_grid.solve

      expect(solver_grid.solution).to eq([
        [4],             [1, 6, 7, 9],       [1, 2, 6, 7, 9],       [1, 3, 9],       [2, 3, 6, 9],       [2, 6, 9],             [8],             [1, 2, 3, 9],    [5],
        [2, 6, 7, 8, 9], [3],                [1, 2, 5, 6, 7, 8, 9], [1, 4, 5, 8, 9], [2, 4, 5, 6, 9],    [2, 4, 5, 6, 8, 9],    [1, 2, 6, 7, 9], [1, 2, 4, 9],    [1, 2, 4, 6, 7, 9],
        [2, 6, 8, 9],    [1, 5, 6, 8, 9],    [1, 2, 5, 6, 8, 9],    [7],             [2, 3, 4, 5, 6, 9], [2, 4, 5, 6, 8, 9],    [1, 2, 3, 6, 9], [1, 2, 3, 4, 9], [1, 2, 3, 4, 6, 9],
        [3, 7, 8, 9],    [2],                [1, 5, 7, 8, 9],       [3, 4, 5, 9],    [3, 4, 5, 7, 9],    [4, 5, 7, 9],          [1, 3, 5, 7, 9], [6],             [1, 3, 7, 8, 9],
        [3, 6, 7, 9],    [1, 5, 6, 7, 9],    [1, 5, 6, 7, 9],       [3, 5, 9],       [8],                [2, 5, 6, 7, 9],       [4],             [1, 2, 3, 5, 9], [1, 2, 3, 7, 9],
        [3, 6, 7, 8, 9], [4],                [5, 6, 7, 8, 9],       [3, 5, 9],       [1],                [2, 5, 6, 7, 9],       [2, 3, 5, 7, 9], [2, 3, 5, 8, 9], [2, 3, 7, 8, 9],
        [2, 8, 9],       [8, 9],             [2, 8, 9],             [6],             [4, 5, 9],          [3],                   [1, 2, 5, 9],    [7],             [1, 2, 4, 8, 9],
        [5],             [6, 7, 8, 9],       [3],                   [2],             [4, 7, 9],          [1],                   [6, 9],          [4, 8, 9],       [4, 6, 8, 9],
        [1],             [6, 7, 8, 9],       [4],                   [5, 8, 9],       [5, 7, 9],          [5, 7, 8, 9],          [2, 3, 5, 6, 9], [2, 3, 5, 8, 9], [2, 3, 6, 8, 9]
      ])
    end

    it 'updates the underlying grid with the newly found values' do
      grid = Grid.from_string(input)

      solver_grid = SolverGrid.new(grid)
      solver_grid.solve

      expect(grid.get(1, 5)).to eq(4)
    end
  end
end
