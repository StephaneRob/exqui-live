defmodule ExquiLive.HomeLive do
  use ExquiLive.Web, :live_view

  @impl true
  def render(assigns) do
    ~L"""
    <h1>Coucou</h1>
    """
  end

  @impl true
  def mount(_params, _, socket) do
    {:ok, socket}
  end
end
