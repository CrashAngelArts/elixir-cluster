defmodule DeeperNetwork.Communication.Messenger do
  @moduledoc """
  Módulo para comunicação distribuída entre nós.
  """

  def broadcast(message, nodes \\ Node.list()) do
    nodes
    |> Enum.each(fn node ->
      send({__MODULE__, node}, {:broadcast, message})
    end)
  end

  def receive_messages do
    receive do
      {:broadcast, message} ->
        IO.puts("Mensagem recebida: #{inspect(message)}")
        receive_messages()
    after
      5000 -> :timeout
    end
  end

  def start_listener do
    spawn(fn -> receive_messages() end)
  end
end
