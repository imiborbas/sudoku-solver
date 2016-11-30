class Grid
  def initialize(rows)
    @rows = rows
  end

  def self.from_string(input)
    new(input
          .each_line
          .map { |line| line.scan(/\d/).map(&:to_i) }
          .select { |row| row.count == 9 })
  end

  def get(x, y)
    @rows[y][x]
  end

  def set(x, y, value)
    @rows[y][x] = value.to_i
  end

  def to_s
    @rows.map { |row| row.join(' ') }.join("\n")
  end

  def pretty
    @rows.map do |row|
      sprintf("%d %d %d |%d %d %d |%d %d %d", row[0], row[1], row[2], row[3], row[4], row[5], row[6], row[7], row[8])
    end.tap do |rows|
      rows
        .insert(3, '------+------+------')
        .insert(7, '------+------+------')
    end.join("\n")
  end

  def row(number)
    @rows[number]
  end

  def column(number)
    @rows.transpose[number]
  end

  def subgroup(x, y)
    from_col = 3 * x
    to_col = 3 * (x + 1)
    from_row = 3 * y
    to_row = 3 * (y + 1)

    (from_row...to_row).flat_map do |row|
      @rows[row][from_col...to_col]
    end
  end

  def complete?
    not @rows.flatten.include?(0)
  end

  def solution_candidates(x, y)
    (1..9).to_a - (row(y) | column(x) | subgroup(x / 3, y / 3))
  end

  def primary_solution_candidates
    (0..8).flat_map do |y|
      (0..8).map { |x| [[x, y], solution_candidates(x, y)] if get(x, y) == 0 }
    end.compact.min_by { |element| element[1].count }
  end

  def copy
    Grid.new(@rows)
  end
end
