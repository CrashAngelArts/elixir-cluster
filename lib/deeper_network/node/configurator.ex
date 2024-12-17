defmodule DeeperNetwork.Node.Configurator do
  @moduledoc """
  Responsável por configurar e gerenciar a inicialização dos nós distribuídos.
  """

  def setup(node_name, cookie, ip \\ nil) do
    # Se IP não for fornecido, tenta pegar IP público
    ip = ip || get_public_ip()

    # Inicia o kernel de rede com nome do nó
    :net_kernel.start([String.to_atom("#{node_name}@#{ip}"), :longnames])

    # Define o cookie de segurança
    :erlang.set_cookie(Node.self(), String.to_atom(cookie))

    {:ok, node_name}
  end

  def connect_nodes(nodes) do
    nodes
    |> Enum.map(&String.to_atom/1)
    |> Enum.each(fn node ->
      case Node.connect(node) do
        true ->
          IO.puts(" Conectado a #{node}")
          DeeperNetwork.Communication.Messenger.debug("Nó conectado: #{node}")
        false ->
          IO.puts(" Falha ao conectar #{node}")
          DeeperNetwork.Communication.Messenger.error("Falha na conexão com nó: #{node}")
      end
    end)

    Node.list()
  end

  def get_connected_nodes do
    Node.list()
  end

  # Função para obter IP público
  defp get_public_ip do
    case :inet.getifaddrs() do
      {:ok, interfaces} ->
        interfaces
        |> Enum.find_value(fn {_name, opts} ->
          case Keyword.get(opts, :addr) do
            {a, b, c, d} when a != 127 -> "#{a}.#{b}.#{c}.#{d}"
            _ -> nil
          end
        end)
      _ -> "localhost"
    end
  end

  # Função para descoberta de nós via DNS ou arquivo de configuração
  def discover_nodes(discovery_method \\ :file) do
    case discovery_method do
      :dns -> discover_nodes_dns()
      :file -> discover_nodes_file()
      _ -> []
    end
  end

  defp discover_nodes_dns do
    # Implementação de descoberta via DNS SRV
    []  # Placeholder
  end

  defp discover_nodes_file do
    # Ler lista de nós de um arquivo de configuração
    Path.expand("~/cluster_nodes.txt")
    |> File.read!()
    |> String.split("\n", trim: true)
  end
end
