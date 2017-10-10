defmodule Fw.NetworkManager do
  use GenServer
  require Logger

  def start_link(iface) do
    GenServer.start_link(__MODULE__, iface)
  end

  def init(iface) do
    Mdns.Server.add_service(%Mdns.Server.Service{
      domain: "nerves.local",
      data: :ip,
      ttl: 120,
      type: :a
    })

    Logger.debug "Start Network Manager"
    :os.cmd 'epmd -daemon'
    SystemRegistry.register
    {:ok, {iface, nil}}
  end

  def handle_info({:system_registry, :global, registry}, {iface, current}) do
    ip = get_in(registry, ipv4_address_key(iface))
    if ip != current do
      Logger.debug "IP Address Changed"
      configure_mdns(ip)
    end
    {:noreply, {iface, ip}}
  end

  defp configure_mdns(ip) do
    Logger.debug "Reconfiguring mDNS IP: #{inspect ip}"
    ip =
      String.split(ip, ".")
      |> Enum.map(&parse_int/1)
      |> List.to_tuple

    Mdns.Server.stop()
    Mdns.Server.start(interface: ip)
    Mdns.Server.set_ip(ip)
  end

  defp ipv4_address_key(iface) do
    [:state, :network_interface, iface, :ipv4_address]
  end

  defp parse_int(str) do
    {int, _} = Integer.parse(str)
    int
  end
end
