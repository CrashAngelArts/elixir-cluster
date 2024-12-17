defmodule DeeperNetwork.Communication.Messenger do
  use GenServer
  require Logger

  @moduledoc """
  Módulo para comunicação distribuída entre nós.
  """

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    {:ok, %{}}
  end

  def broadcast(message, nodes \\ Node.list()) do
    nodes
    |> Enum.each(fn node ->
      send({__MODULE__, node}, {:broadcast, message, Node.self()})
    end)
    :ok
  end

  @impl true
  def handle_info({:broadcast, message, from_node}, state) do
    # Mensagem colorida com ícone
    colored_message = [
      :bright, :green, "📨 ",
      :reset, :blue, "Mensagem de ",
      :bright, :magenta, "#{from_node}",
      :reset, :white, ": ",
      :bright, :cyan, "#{inspect(message)}",
      :reset
    ]

    # Usar IO.puts para cores
    IO.puts(IO.ANSI.format(colored_message))

    # Opcional: Logging para registros
    #Logger.info("Broadcast received from #{from_node}: #{inspect(message)}")

    {:noreply, state}
  end

  # Fallback para mensagens inesperadas com cor de erro
  @impl true
  def handle_info(msg, state) do
    error_message = [
      :bright, :red, "⚠️ Mensagem inesperada: ",
      :reset, :yellow, "#{inspect(msg)}",
      :reset
    ]

    IO.puts(IO.ANSI.format(error_message))
    Logger.warn("Unexpected message: #{inspect(msg)}")

    {:noreply, state}
  end

  # Funções auxiliares para debug colorido
  def debug(message, color \\ :green) do
    colored_debug = [
      :bright, color, "🔍 DEBUG: ",
      :reset, :white, "#{inspect(message)}",
      :reset
    ]
    IO.puts(IO.ANSI.format(colored_debug))
  end

  def warn(message) do
    colored_warn = [
      :bright, :yellow, "⚠️ WARN: ",
      :reset, :white, "#{inspect(message)}",
      :reset
    ]
    IO.puts(IO.ANSI.format(colored_warn))
  end

  def error(message) do
    colored_error = [
      :bright, :red, "❌ ERROR: ",
      :reset, :white, "#{inspect(message)}",
      :reset
    ]
    IO.puts(IO.ANSI.format(colored_error))
  end
end
