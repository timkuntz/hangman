defmodule Dictionary.Runtime.Server do

  @type t :: pid()

  @me __MODULE__

  use Agent

  alias Dictionary.Impl.WordList

  def start_link(_args) do
    Agent.start_link(&WordList.word_list/0, name: @me)
  end

  def random_word() do
    # test supervisor restart
    # if :rand.uniform() < 0.33 do
    #   Agent.get(@me, fn _ -> exit(:boom) end)
    # end
    Agent.get(@me, &WordList.random_word/1)
  end

  def words_matching(pattern) do
    Agent.get(@me, fn words ->
      WordList.words_matching(words, pattern)
    end)
  end
end
