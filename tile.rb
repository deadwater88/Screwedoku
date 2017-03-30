
class Tile
  attr_accessor :neighbor_count, :face_up, :b_status, :pos, :flag

  def initialize(b_status)
    @b_status = b_status
    @face_up = false
    @flag = false
  end

  def render
    if !@face_up
      @flag ? "F" : "*"
    else
      return "_" if @neighbor_count == 0
      @neighbor_count.to_s
    end
  end

end
