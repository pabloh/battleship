require 'board'
require 'ship'

class Game
  attr_reader :turn

  def initialize(board1, board2)
    raise ArgumentError, "Invalid board for player 1" unless board1.ready?
    raise ArgumentError, "Invalid board for player 2" unless board2.ready?

    @boards, @turn = [board1, board2], 1
  end

  # Performs an attack on the enemy's board
  #
  # @param player_num [Integer] the current player number, must be his/her turn
  # @param box [Box] a box inside the board
  def attack!(player_num, box)
    raise ArgumentError, "Invalid player" unless player_num == turn

    enemy_board(player_num).attack!(box)
    @turn = other_player(player_num)
  end

  def game_over?
    @boards.any?(&:all_sunk?)
  end

  def winner
    board_for(1).all_sunk? ? 2 : 1 if game_over?
  end

  private

  # Given a player number, returns his enemy's board
  def enemy_board(player_num)
    board_for(other_player(player_num))
  end

   # Given a player number, returns his board
  def board_for(player_num)
    @boards[player_num - 1]
  end

  def other_player(player_num)
    player_num == 2 ? 1 : 2
  end
end
