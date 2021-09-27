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
    if connected?(socket), do: schedule_update(socket)
    {:ok, assign(socket, refresh: 2)}
  end

  @impl true
  def handle_info(:update, socket) do
    send_update(ExquiLive.StatsComponent, id: "stats")
    send_update(ExquiLive.ChartComponent, id: "real_time")
    schedule_update(socket)
    {:noreply, socket}
  end

  @impl true
  def handle_event("set_refresh", %{"refresh" => ""}, socket) do
    handle_event("set_refresh", %{"refresh" => nil}, socket)
  end

  @impl true
  def handle_event("set_refresh", %{"refresh" => refresh}, socket) do
    current_refresh = socket.assigns[:refresh]
    new_refresh = if is_nil(refresh), do: refresh, else: String.to_integer(refresh)
    socket = assign(socket, refresh: new_refresh)

    if is_nil(current_refresh) and not is_nil(refresh) do
      schedule_update(socket)
    end

    {:noreply, socket}
  end

  @impl true
  def handle_params(_, uri, socket) do
    %URI{path: path} = URI.parse(uri)
    {:noreply, assign(socket, current_path: path)}
  end
end
