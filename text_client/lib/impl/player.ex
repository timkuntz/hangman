defmodule TextClient.Impl.Player do

  @typep game :: Hangman.game
  @typep tally :: Hangman.tally
  @typep state :: { game, tally }

  @spec start() :: :ok
  def start() do
    game = Hangman.new_game()
    tally = Hangman.tally(game)
    interact({ game, tally })
  end

  @spec interact(state) :: :ok

  def interact({_game, _tally = %{game_state: :won}}) do
    IO.puts "Congrats! You won!"
  end

  def interact({_game, tally = %{game_state: :lost}}) do
    IO.puts "Wah wah! You lost. The word was #{tally.letters |> Enum.join}"
  end

  def interact({ game, tally }) do
    IO.puts feedback_for(tally)
    IO.puts current_word(tally)

    Hangman.make_move(game, get_guess())
    |> interact()
  end

  defp feedback_for(tally = %{ game_state: :initializing}) do
    "Welcome! I'm thinking of a #{tally.letters |> length} letter word."
  end

  defp feedback_for(_tally = %{ game_state: :good_guess}), do: "Good guess!"
  defp feedback_for(_tally = %{ game_state: :bad_guess}), do: "That letter is not in the word."
  defp feedback_for(_tally = %{ game_state: :already_used}), do: "That letter has already been used."
  defp feedback_for(_tally = %{ game_state: :invalid_guess}), do: "Your guess must be a single lowercase letter; a to z"

  defp current_word(tally) do
    [
      "Word so far: ", IO.ANSI.yellow(), tally.letters |> Enum.join(" "), IO.ANSI.reset(),
      "  turns left: ", tally.turns_left |> to_string,
      "  used so far: ", tally.used |> Enum.join(", "),
    ]
  end

  defp get_guess() do
    IO.gets("Next letter: ") |> String.trim() |> String.downcase()
  end

end
