defmodule DictionaryTest do
  use ExUnit.Case
  doctest Dictionary

  @test_words ["apple", "angle", "awake", "banana", "cat", "dog", "elephant", "dice", "fish", "hippopotamus"]

  test ".words_matching" do
    matches = @test_words |> Dictionary.words_matching("a...e")
    assert matches == ["apple", "angle", "awake"]

    matches = @test_words |> Dictionary.words_matching(".i..")
    assert matches == ["dice", "fish"]
  end

end

