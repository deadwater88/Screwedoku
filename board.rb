require_relative 'tile'
class Board
  attr_reader :length, :width, :total_tiles, :bomb_count, :safe_tile_count, :grid

  def initialize(length, width, bomb_frac = 0.05)
    @length = length
    @width = width
    @total_tiles = length * width
    @bomb_count = (bomb_frac * @total_tiles).to_i
    @safe_tile_count = @total_tiles - @bomb_count
    spawn_board
    set_counts
  end

  def spawn_board
    @grid = []
    @bomb_count.times { @grid << Tile.new("b") }
    @safe_tile_count.times { @grid << Tile.new("s") }
    @grid.shuffle!
    @grid = @grid.each_slice(@width).to_a
  end

  def set_counts
    (0...@length).each do |i|
      (0...@width).each do |j|
        set_neighbor_count(@grid[i][j],[i,j])
        @grid[i][j].pos = [i,j]
      end
    end
  end

  def set_neighbor_count(tile, pos)
    tile.neighbor_count = get_neighbors(pos).map{|tile| tile.b_status}.count("b")
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end


  def get_neighbors(pos)
    row, col = pos
    row_start = [row - 1, 0].max
    row_end = [row + 1, @length -1].min
    col_start = [col - 1, 0].max
    col_end = [col + 1, @width - 1].min
    @grid[row_start..row_end].map{|row| row[col_start..col_end]}.reduce(:+)
  end

  def render
    puts "  " + (0..9).to_a.map{|i| i.to_s * 10}.join("")[0...width]
    puts "  " + ((0..9).to_a.join("") * 10)[0...width]
    @grid.each_with_index do |row, index|
      print index < 10 ?  " " + index.to_s : index.to_s
      puts row.map{|tile| tile.render}.join("")
    end
  end
end
