defmodule DeeperNetwork.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      DeeperNetwork.Communication.MessengerSupervisor
    ]

    opts = [strategy: :one_for_one, name: DeeperNetwork.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
