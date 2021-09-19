defmodule ExquiLive.MenuLive do
  use ExquiLive.Web, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <ul class="flex items-center justify-content-center py-4">
      <li class="mr-6">
        <%= live_redirect("Exq UI", to: exqui_live_path(@socket, :home), class: "text-xl text-yellow-400 font-bold" ) %>
      </li>
      <li class="mr-6">
        <a href="" class="hover:text-yellow-800">Scheduled</a>
      </li>
    </ul>
    """
  end

  @impl true
  def mount(_params, _, socket) do
    {:ok, socket}
  end
end
