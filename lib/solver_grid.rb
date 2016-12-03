class SolverGrid
  attr_accessor :solution

  def initialize(grid)
    @grid = grid
    update_possible_values
  end

  def cell(x, y)
    solution[y * 9 + x]
  end

  def row(y, except_column: nil)
    (0..8).select { |i| i != except_column }.map { |x| cell(x, y) }
  end

  def column(x, except_row: nil)
    (0..8).select { |i| i != except_row }.map { |y| cell(x, y) }
  end

  def subgroup(i, j, except_at: nil)
    from_x = 3 * i
    to_x = 3 * (i + 1)
    from_y = 3 * j
    to_y = 3 * (j + 1)

    (from_y...to_y).flat_map do |y|
      (from_x...to_x).map { |x| cell(x, y) if [x, y] != except_at }
    end.compact
  end

  private

  def update_possible_values
    @solution = (0..80).map { |i| possible_cell_values(i % 9, i / 9) }
  end

  def possible_cell_values(x, y)
    grid.get(x, y).tap do |value|
      return [value] if value > 0
    end

    (1..9).to_a - (grid.row(y) | grid.column(x) | grid.subgroup(x / 3, y / 3))
  end

  def grid
    @grid
  end
end
