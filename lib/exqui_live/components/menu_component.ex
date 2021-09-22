defmodule ExquiLive.MenuComponent do
  use ExquiLive.Web, :live_component

  @refresh_options [{"1s", 1}, {"2s", 2}, {"5s", 5}, {"10s", 10}]

  @impl true
  def render(assigns) do
    ~H"""
    <ul class="flex items-center justify-content-center py-4">
      <li class="mr-6">
        <%= live_redirect("Exq UI", to: exqui_live_path(@socket, :home), class: "text-xl text-yellow-500 font-bold" ) %>
      </li>
      <li class="mr-6">
        <%= live_redirect("Queues", to: exqui_live_path(@socket, :queues), class: "py-2 hover:text-yellow-500 #{active_class(exqui_live_path(@socket, :queues), @current_path)}") %>
      </li>
      <li class="mr-6">
        <%= live_redirect("Retries", to: exqui_live_path(@socket, :retries), class: "py-2 hover:text-yellow-500 #{active_class(exqui_live_path(@socket, :retries), @current_path)}") %>
      </li>
      <li class="mr-6">
        <%= live_redirect("Scheduled", to: exqui_live_path(@socket, :scheduled), class: "py-2 hover:text-yellow-500 #{active_class(exqui_live_path(@socket, :scheduled), @current_path)}") %>
      </li>
      <li class="mr-6">
        <%= live_redirect("Failed", to: exqui_live_path(@socket, :all_failed), class: "py-2 hover:text-yellow-500 #{active_class(exqui_live_path(@socket, :all_failed), @current_path)}") %>
      </li>
    </ul>
    """
  end

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  def active_class(path, current_path) do
    if String.starts_with?(current_path, path) do
      "text-yellow-500 border-b-2 border-yellow-500"
    end
  end
end
