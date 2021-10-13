defmodule ExquiLive.MenuComponent do
  use ExquiLive.Web, :live_component

  @refresh_options [{"Stop", nil}, {"1s", 1}, {"2s", 2}, {"5s", 5}, {"10s", 10}]

  @impl true
  def render(assigns) do
    ~H"""
    <ul class="flex items-center justify-content-center py-4">
      <li class="mr-6">
        <%= live_redirect("Exq UI",
            to: exqui_live_path(@socket, :home),
            class: "text-xl text-yellow-500 font-bold" ) %>
      </li>
      <li class="mr-6">
        <%= live_redirect("Queues",
            to: exqui_live_path(@socket, :queues),
            class: "py-2 hover:text-yellow-500 #{active_class(exqui_live_path(@socket, :queues), @current_path)}") %>
      </li>
      <li class="mr-6">
        <%= live_redirect("Retries",
            to: exqui_live_path(@socket, :retries),
            class: "py-2 hover:text-yellow-500 #{active_class(exqui_live_path(@socket, :retries), @current_path)}") %>
      </li>
      <li class="mr-6">
        <%= live_redirect("Scheduled",
            to: exqui_live_path(@socket, :scheduled),
            class: "py-2 hover:text-yellow-500 #{active_class(exqui_live_path(@socket, :scheduled), @current_path)}") %>
      </li>
      <li class="mr-6">
        <%= live_redirect("Failed",
            to: exqui_live_path(@socket, :all_failed),
            class: "py-2 hover:text-yellow-500 #{active_class(exqui_live_path(@socket, :all_failed), @current_path)}") %>
      </li>

      <li class="ml-auto relative inline-block text-gray-700">
        <form phx-change="set_refresh">
          <label class="text-sm">Update every</label>
          <select name="refresh" class="h-7 pl-3 pr-6 text-base placeholder-gray-600 border rounded-lg appearance-none focus:shadow-outline">
            <%= options_for_select(@refresh_options, 2) %>
          </select>
        </form>
        <div class="absolute inset-y-0 right-0 flex items-center px-2 pointer-events-none">
          <svg class="w-4 h-4 fill-current" viewBox="0 0 20 20"><path d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clip-rule="evenodd" fill-rule="evenodd"></path></svg>
        </div>
      </li>
    </ul>
    """
  end

  @impl true
  def mount(socket) do
    {:ok, assign(socket, refresh_options: @refresh_options)}
  end

  def active_class(path, current_path) do
    if String.starts_with?(current_path, path) do
      "text-yellow-500 border-b-2 border-yellow-500"
    end
  end
end
