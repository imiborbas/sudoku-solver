class SolverGrid
  UnsolvedCell = Struct.new(:x, :y, :possible_values)

  attr_accessor :solution

  def initialize(grid)
    @grid = grid
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

  def box(i, j, except_at: nil)
    from_x = 3 * i
    to_x = 3 * (i + 1)
    from_y = 3 * j
    to_y = 3 * (j + 1)

    (from_y...to_y).flat_map do |y|
      (from_x...to_x).map { |x| cell(x, y) if [x, y] != except_at }
    end.compact
  end

  def attempt!
    update_possible_values!
    all_cells.each do |x, y|
      solve_cell(x, y).tap do |value|
        update_cell!(x, y, value) if value
      end
    end
  end

  def easiest_unsolved_cell
    all_cells
      .map { |x, y| UnsolvedCell.new(x, y, cell(x, y)) }
      .select { |cell| cell.possible_values.size > 1 }
      .sort_by { |cell| cell.possible_values.size }
      .first
  end

  def solvable?
    solution.select { |values| values.empty? }.empty?
  end

  private

  def all_cells
    (0..8).flat_map { |y| (0..8).map { |x| [x, y] } }
  end

  def solve_cell(x, y)
    return false if cell(x, y).size == 1

    solve_unit(cell(x, y), row(y, except_column: x)).tap do |values|
      return values.first if values.size == 1
    end

    solve_unit(cell(x, y), column(x, except_row: y)).tap do |values|
      return values.first if values.size == 1
    end

    solve_unit(cell(x, y), box(x / 3, y / 3, except_at: [x, y])).tap do |values|
      return values.first if values.size == 1
    end

    false
  end

  def solve_unit(cell_values, unit_values)
    unit_values.inject(cell_values) { |intersection, current| intersection - current }
  end

  def update_cell!(x, y, value)
    grid.set(x, y, value)
    update_possible_values!
  end

  def update_possible_values!
    @solution = all_cells.map do |x, y|
      possible_cell_values(x, y).tap { |values| grid.set(x, y, values.first) if values.size == 1 }
    end
  end

  def possible_cell_values(x, y)
    grid.get(x, y).tap do |value|
      return [value] if value > 0
    end

    (1..9).to_a - (grid.row(y) | grid.column(x) | grid.box(x / 3, y / 3))
  end

  def grid
    @grid
  end
end
