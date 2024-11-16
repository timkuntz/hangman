defmodule Hangman do

  # alias Hangman.Impl.Game, as: Game
  alias Hangman.Impl.Game
  alias Hangman.Type

  @opaque game :: Game.t

  @spec new_game() :: game
  defdelegate new_game, to: Game
  # def new_game do
  #   Game.new_game()
  # end

  @spec make_move(game, String.t) :: { game, Type.tally }
  defdelegate make_move(game, guess), to: Game

end
