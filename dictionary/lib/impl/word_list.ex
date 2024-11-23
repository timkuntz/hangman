defmodule Dictionary.Impl.WordList do

  @type t :: list(String.t)

  @spec word_list() :: t
  def word_list() do
    "assets/words.txt"
    |> File.read!()
    |> String.split(~r/\n/, trim: true)
  end

  @spec random_word(t) :: String.t
  def random_word(word_list) do
    word_list
    |> Enum.random()
  end

  def words_matching(pattern) do
    word_list()
    |> Enum.filter(&String.match?(&1, ~r/^#{pattern}$/))
  end

  def words_matching(words, pattern) do
    words
    |> Enum.filter(&String.match?(&1, ~r/^#{pattern}$/))
  end

end
