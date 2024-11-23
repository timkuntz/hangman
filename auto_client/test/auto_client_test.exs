defmodule AutoClientTest do
  use ExUnit.Case
  doctest AutoClient

  alias AutoClient.Impl.Player

  @test_words ["allpe", "angpe", "awxye", "banana", "cat", "dog", "elephant", "dice", "fish", "hippopotamus"]

  test ".most_frequent_letter" do
    pattern = "a...e"
    matches = @test_words |> Dictionary.words_matching(pattern)
    assert Player.most_frequent_letter(matches, ["a", "e"]) == {"p", 2}
  end

end

