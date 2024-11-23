defmodule Dictionary do

  # this is a "module attribute"
  # it is evaluated at compile time
  @word_list "assets/words.txt"
    |> File.read!()
    |> String.split(~r/\n/, trim: true)

  def random_word do
    @word_list
    |> Enum.random()
  end

  def words_matching(pattern) do
    @word_list
    |> Enum.filter(&String.match?(&1, ~r/^#{pattern}$/))
  end

  def words_matching(words, pattern) do
    words
    |> Enum.filter(&String.match?(&1, ~r/^#{pattern}$/))
  end

end
