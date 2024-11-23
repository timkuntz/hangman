defmodule AutoClient.Impl.Player do

  @typep game :: Hangman.game
  @typep tally :: Hangman.tally
  @typep unused :: list(String.t)
  @typep state :: { game, tally, unused }

  @spec start() :: :ok
  def start() do
    game = Hangman.new_game()
    tally = Hangman.tally(game)
    interact({ game, tally, available_guesses() })
  end

  @spec interact(state) :: :ok

  def interact({_game, _tally = %{game_state: :won}, _}) do
    IO.puts "Congrats! You won!"
  end

  def interact({_game, tally = %{game_state: :lost}, _}) do
    IO.puts "Wah wah! You lost. The word was #{tally.letters |> Enum.join}"
  end

  def interact({ game, tally, unused }) do
    # IO.inspect game
    # IO.puts "==========="
    IO.puts feedback_for(tally)
    IO.puts current_word(tally)

    { guess, unused } = get_guess(unused, tally)
    { game, tally } = Hangman.make_move(game, guess)
    # IO.inspect tally
    # IO.puts "========"
    interact({ game, tally, unused })
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

  defp available_guesses do
    Enum.map(97..122, fn i -> <<i::utf8>> end)
  end

  defp get_guess(unused, tally) do
    { letter, _count } = tally.letters
      |> List.to_string()
      |> String.replace("_", ".")
      |> Dictionary.words_matching()
      |> most_frequent_letter(tally.used)
    { letter, remove_guess(unused, letter) }
  end

  defp remove_guess(unused, guess) do
    unused |> Enum.reject(fn x -> x == guess end)
  end

  def most_frequent_letter(words, used) do
    words
    |> Enum.flat_map(&String.graphemes/1)
    |> Enum.reject(&Enum.member?(used, &1))
    |> Enum.uniq
    |> Enum.reduce(%{}, fn letter, acc -> Map.put(acc, letter, count_words_containing_letter(words, letter)) end)
    |> Enum.sort(fn {_, countA}, {_, countB} -> countA >= countB end)
    |> List.first()
  end

  defp count_words_containing_letter(words, letter) do
    words
    |> Enum.filter(&String.contains?(&1, letter))
    |> Enum.count()
  end

end
