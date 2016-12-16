require 'board'
require 'ship'

class Game
  def initialize(board1, board2)
    raise ArgumentError, "Invalid board for player 1" unless board1.ready?
    raise ArgumentError, "Invalid board for player 2" unless board2.ready?
    @boards = [board1, board2]
  end

  # Performs an attack en the enemy's board
  #
  # @param player_num [Integer] the current player number, must be 1 or 2
  # @param x [String] the board's x coordinate, must be within 'A' and 'J'
  # @param y [Integer] the board's y coordinate, must be within 1 and 10
  def attack!(player_num, x, y)
    raise ArgumentError, "Invalid player" unless player_num.in?(1..2)
    enemy_board(player_num).attack!(x, y)
  end

  def game_over?
    @boards.any?(:all_sunk?)
  end

  def winner
    player_board(1).all_sunk? ? 2 : 1 if game_over?
  end

  private

  # Given a player number, returns his board
  def player_board(player_num)
    @boards[player_num - 1]
  end

  # Given a player number, returns his enemy's board
  def enemy_board(player_num)
    player_board(player_num == 2 ? 1 : player_num)
  end
end
