defmodule HangmanImplGameTest do
  use ExUnit.Case

  alias Hangman.Impl.Game

  test "new game returns structure" do
    game = Game.new_game

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
  end

  test "new game returns correct word" do
    game = Game.new_game("wombat")

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert game.letters == ~w(w o m b a t)
  end

  test "state doesn't change if game won or lost" do
    for state <- [:won, :lost] do
      game = Game.new_game("wombat")
      game = Map.put(game, :game_state, state)

      { new_game, _tally } = Game.make_move(game, "x")

      assert new_game == game
    end
  end

  test "a duplicate guess is reported" do
    game = Game.new_game("wombat")
    { game, _tally } = Game.make_move(game, "x")
    assert game.game_state != :already_used

    { game, _tally } = Game.make_move(game, "y")
    assert game.game_state != :already_used

    { game, _tally } = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end

  test "we record used letters" do
    game = Game.new_game("wombat")
    { game, _tally } = Game.make_move(game, "x")
    { game, _tally } = Game.make_move(game, "y")
    { game, _tally } = Game.make_move(game, "x")
    assert MapSet.equal?(game.used, MapSet.new(["x", "y"]))
  end

  test "we recognize a letter in the word" do
    game = Game.new_game("wombat")

    { _game, tally } = Game.make_move(game, "m")
    assert tally.game_state == :good_guess

    { _game, tally } = Game.make_move(game, "t")
    assert tally.game_state == :good_guess
  end

  test "we recognize a letter not in the word" do
    game = Game.new_game("wombat")

    { _game, tally } = Game.make_move(game, "x")
    assert tally.game_state == :bad_guess

    { _game, tally } = Game.make_move(game, "t")
    assert tally.game_state == :good_guess

    { _game, tally } = Game.make_move(game, "y")
    assert tally.game_state == :bad_guess
  end

  test "the guess is a lowercase ASCII character" do
    game = Game.new_game("wombat")

    { _game, tally } = Game.make_move(game, "ab")
    assert tally.game_state == :invalid_guess

    { _game, tally } = Game.make_move(game, "X")
    assert tally.game_state == :invalid_guess

    { _game, tally } = Game.make_move(game, ".")
    assert tally.game_state == :invalid_guess
  end

  # word is "hello"
  test "can handle a sequence of moves" do
    [
      [ "a", :bad_guess,     6, ["_", "_", "_", "_", "_"], [ "a" ]],
      [ "a", :already_used,  6, ["_", "_", "_", "_", "_"], [ "a" ]],
      [ "e", :good_guess,    6, ["_", "e", "_", "_", "_"], [ "a", "e" ]],
      [ "x", :bad_guess,     5, ["_", "e", "_", "_", "_"], [ "a", "e", "x" ]],
    ] |> test_moves()
  end

  test "can win a game" do
    [
      [ "a", :bad_guess,     6, ["_", "_", "_", "_", "_"], [ "a" ]],
      [ "e", :good_guess,    6, ["_", "e", "_", "_", "_"], [ "a", "e" ]],
      [ "l", :good_guess,    6, ["_", "e", "l", "l", "_"], [ "a", "e", "l" ]],
      [ "h", :good_guess,    6, ["h", "e", "l", "l", "_"], [ "a", "e", "h", "l" ]],
      [ "y", :bad_guess,     5, ["h", "e", "l", "l", "_"], [ "a", "e", "h", "l", "y" ]],
      [ "o", :won,           5, ["h", "e", "l", "l", "o"], [ "a", "e", "h", "l", "o", "y" ]],
    ] |> test_moves()
  end

  test "can lose a game" do
    [
      [ "a", :bad_guess,     6, ["_", "_", "_", "_", "_"], [ "a" ]],
      [ "b", :bad_guess,     5, ["_", "_", "_", "_", "_"], [ "a", "b" ]],
      [ "c", :bad_guess,     4, ["_", "_", "_", "_", "_"], [ "a", "b", "c" ]],
      [ "d", :bad_guess,     3, ["_", "_", "_", "_", "_"], [ "a", "b", "c", "d" ]],
      [ "f", :bad_guess,     2, ["_", "_", "_", "_", "_"], [ "a", "b", "c", "d", "f" ]],
      [ "g", :bad_guess,     1, ["_", "_", "_", "_", "_"], [ "a", "b", "c", "d", "f", "g" ]],
      [ "i", :lost,          0, ["h", "e", "l", "l", "o"], [ "a", "b", "c", "d", "f", "g", "i" ]],
   ] |> test_moves()
  end

  defp test_moves(script) do
    game = Game.new_game("hello")
    Enum.reduce(script, game, &check_one_move/2)
  end

  defp check_one_move([ guess, state, turns, letters, used ], game) do
    { game, tally } = Game.make_move(game, guess)

    assert tally.game_state == state
    assert tally.turns_left == turns
    assert tally.letters == letters
    assert tally.used == used

    game
  end

end

