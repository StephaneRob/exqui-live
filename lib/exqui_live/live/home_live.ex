defmodule ExquiLive.HomeLive do
  use ExquiLive.Web, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <div class="">
      <%= live_component @socket, ExquiLive.StatsComponent, id: "stats", name: "Stats" %>
    </div>

    <div>
      <%= live_component @socket, ExquiLive.ChartComponent, id: "real_time", name: "Real time" %>
    </div>
    """
  end

  @impl true
  def mount(_params, _, socket) do
    if connected?(socket),
      do: :timer.send_interval(Map.get(socket.assigns, :refresh, 2) * 1000, self(), :update)

    {:ok, socket}
  end

  @impl true
  def handle_info(:update, socket) do
    send_update(ExquiLive.StatsComponent, id: "stats")
    send_update(ExquiLive.ChartComponent, id: "real_time")
    {:noreply, socket}
  end

  @impl true
  def handle_params(_, uri, socket) do
    %URI{path: path} = URI.parse(uri)
    {:noreply, assign(socket, current_path: path)}
  end
end
