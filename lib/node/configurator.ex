defmodule DeeperNetwork.Node.Configurator do
  @moduledoc """
  Responsável por configurar e gerenciar a inicialização dos nós distribuídos.
  """

  def setup(node_name, cookie) do
    # Inicia o kernel de rede com nome do nó
    :net_kernel.start([String.to_atom(node_name), :longnames])
    
    # Define o cookie de segurança
    :erlang.set_cookie(Node.self(), String.to_atom(cookie))
    
    {:ok, node_name}
  end

  def connect_nodes(nodes) do
    nodes
    |> Enum.map(&String.to_atom/1)
    |> Enum.each(fn node ->
      case Node.connect(node) do
        true -> IO.puts("Conectado a #{node}")
        false -> IO.puts("Falha ao conectar #{node}")
      end
    end)

    Node.list()
  end

  def get_connected_nodes do
    Node.list()
  end
end
