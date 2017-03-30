require_relative 'board'
require_relative 'tile'
require 'yaml'
class Game
  attr_accessor :board, :safe_revealed, :pos, :action

  def initialize(length, width, bomb_frac = 0.05)
    @board = Board.new(length, width, bomb_frac)
    @safe_revealed = 0
  end

  def flip(tile)
    return if tile.face_up
    tile.face_up = true
    p "tile revealed at #{tile.pos}"
    @safe_revealed += 1
    if no_bomb_nearby?(tile)
      @board.get_neighbors(tile.pos).each{|tile| flip(tile)}
    end
  end

  def no_bomb_nearby?(tile)
    tile.neighbor_count == 0
  end


  def play
    loop do
      @board.render
      get_pos
      get_action
      reveal_pos if @action == 'r'
      flag_pos if @action == 'f'
      save_game if @action == 's'
      load_game if @action == 'l'
      win?
    end
  end

  def save_game
    saved = File.new("ms-saved", "w+")
    saved << @board.to_yaml
    saved.close
    p "game saved"
    exit
  end

  def load_game
    opened = File.open("ms-saved")
    @board = YAML::load(opened)
    p "game loaded"
  end

  def get_pos
    puts "Please input a position"
    @pos = gets.chomp.split(",").map {|el| el.to_i}
  end

  def get_action
    puts "Please input 'f' for flag or 'r' for reveal or 's' for saving the game or 'l' for load"
    @action = gets.chomp
  end

  def flag_pos
    @board[@pos].flag = @board[@pos].flag ? false : true
  end

  def reveal_pos
    if @board[@pos].b_status == "b"
      puts "You LOSE!"
      exit
    else
      flip(@board[@pos])
    end
  end

  def win?
    if @safe_revealed == @board.safe_tile_count
      puts "HURRAAAAAAY, you WIN!"
      @board.render
      sleep(3)
      exit
    end
  end


end


game = Game.new(20, 20)
game.play
