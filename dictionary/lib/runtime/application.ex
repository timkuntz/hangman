defmodule Dictionary.Runtime.Application do

  use Application

  def start(_type, _args) do
    children = [
      {Dictionary.Runtime.Server, []}
    ]

    options = [ 
      strategy: :one_for_one,
      name: Dictionary.Runtime.Supervisor
    ]

    Supervisor.start_link(children, options)
  end

end
