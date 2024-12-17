# elixir-cluster

iex --sname node1@127.0.0.1 -S mix
iex --sname node2@127.0.0.1 -S mix

Node.connect(:"node1@127.0.0.1")
DeeperNetwork.Communication.Messenger.broadcast("Olá do nó 2!", [:"node1@127.0.0.1"])