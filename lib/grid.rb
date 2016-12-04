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
    @rows[y][x] = value
  end

  def to_s
    @rows
      .map { |row| sprintf('%d %d %d |%d %d %d |%d %d %d', *row) }
      .insert(3, '------+------+------')
      .insert(7, '------+------+------')
      .join("\n")
  end

  def row(y)
    @rows[y]
  end

  def column(x)
    @rows.transpose[x]
  end

  def box(i, j)
    from_x = 3 * i
    to_x = 3 * (i + 1)
    from_y = 3 * j
    to_y = 3 * (j + 1)

    (from_y...to_y).flat_map do |y|
      @rows[y][from_x...to_x]
    end
  end

  def complete?
    !@rows.flatten.include?(0)
  end

  def copy
    Grid.from_string(to_s)
  end
end
