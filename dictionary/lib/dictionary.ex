defmodule Dictionary do

  alias Dictionary.Impl.WordList

  @opaque t :: WordList.t

  @spec start() :: t
  defdelegate start, to: WordList, as: :word_list

  @spec random_word(t) :: String.t
  defdelegate random_word(word_list), to: WordList

  defdelegate words_matching(pattern), to: WordList

  defdelegate words_matching(word_list, pattern), to: WordList

end
