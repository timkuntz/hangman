defmodule AutoClient do

  @spec start() :: :ok
  defdelegate start(), to: AutoClient.Impl.Player 

end
