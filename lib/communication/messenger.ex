defmodule DeeperNetwork.Communication.Messenger do
  use GenServer

  @moduledoc """
  Módulo para comunicação distribuída entre nós.
  """

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    # Inicia o listener quando o GenServer iniciar
    {:ok, _pid} = Task.Supervisor.start_child(
      DeeperNetwork.Communication.ListenerSupervisor, 
      fn -> receive_messages() end
    )
    {:ok, %{}}
  end

  def broadcast(message, nodes \\ Node.list()) do
    nodes
    |> Enum.each(fn node ->
      send({__MODULE__, node}, {:broadcast, message, Node.self()})
    end)
    :ok
  end

  def receive_messages do
    receive do
      {:broadcast, message, from_node} ->
        IO.puts("📨 Mensagem recebida de #{from_node}: #{inspect(message)}")
        receive_messages()
    after
      5000 -> :timeout
    end
  end
end
