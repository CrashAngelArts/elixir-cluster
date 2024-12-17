defmodule DeeperNetwork.Storage.DistributedStore do
  @moduledoc """
  Armazenamento distribuído simples usando tabelas ETS.
  """
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_opts) do
    # Cria uma tabela ETS distribuída
    :ets.new(:distributed_store, [:named_table, :public, :set])
    {:ok, %{}}
  end

  def write(key, value) do
    :ets.insert(:distributed_store, {key, value})
  end

  def read(key) do
    case :ets.lookup(:distributed_store, key) do
      [{^key, value}] -> {:ok, value}
      [] -> {:error, :not_found}
    end
  end

  def delete(key) do
    :ets.delete(:distributed_store, key)
  end

  def list_keys do
    :ets.tab2list(:distributed_store)
    |> Enum.map(fn {key, _} -> key end)
  end
end
