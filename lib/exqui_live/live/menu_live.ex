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
        <%= live_redirect("Queues", to: exqui_live_path(@socket, :queues), class: "hover:text-yellow-500" ) %>
      </li>
      <li class="mr-6">
        <%= live_redirect("Retries", to: exqui_live_path(@socket, :retries), class: "hover:text-yellow-500" ) %>
      </li>
      <li class="mr-6">
        <%= live_redirect("Scheduled", to: exqui_live_path(@socket, :scheduled), class: "hover:text-yellow-500" ) %>
      </li>
    </ul>
    """
  end

  @impl true
  def mount(_params, _, socket) do
    {:ok, socket}
  end
end
