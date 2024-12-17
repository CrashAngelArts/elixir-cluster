defmodule DeeperNetwork.Communication.MessengerSupervisor do
  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    children = [
      {Task.Supervisor, name: DeeperNetwork.Communication.ListenerSupervisor},
      {DeeperNetwork.Communication.Messenger, []}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
