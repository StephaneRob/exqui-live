defmodule ExquiLive.QueuesLive do
  use ExquiLive.Web, :live_view

  @impl true
  def render(assigns) do
    ~L"""
    <h1 class="text-2xl mb-4 text-black font-bold my-5">Queues</h1>
    <div class="rounded-sm overflow-hidden shadow bg-white">
      <table class="table-auto w-full">
        <thead>
          <tr>
            <th class="px-4 py-2 text-left text-gray-600">Name</th>
            <th class="px-4 py-2 text-left text-gray-600">Jobs</th>
            <th class="px-4 py-2 text-left text-gray-600">Jobs</th>
          </tr>
        </thead>
        <tbody>
          <%= for queue <- @queues do %>
            <tr>
              <td class="border px-4 py-2 border-l-0">
                <%= live_redirect(queue.id, to: exqui_live_path(@socket, :queue, queue.id), class: "hover:text-yellow-500" ) %>
              </td>
              <td class="border px-4 py-2"><%= queue.size %></td>
              <td class="border px-4 py-2 border-r-0 text-sm text-right">
              <button phx-click="clear_queue" data-confirm="Are you sure?" phx-value-id="<%= queue.id %>" class="ml-4 bg-red-300 hover:bg-red-400 py-1 px-2 rounded-sm">Delete</button>
            </td>
            </tr>
          <% end %>
        </tbody>
      </table>
    </div>
    """
  end

  @impl true
  def mount(_params, _, socket) do
    if connected?(socket), do: :timer.send_interval(4000, self(), :update)
    {:ok, assign(socket, queues: queues())}
  end

  @impl true
  def handle_info(:update, socket) do
    send_update(ExquiLive.StatsComponent, id: "stats")
    {:noreply, assign(socket, queues: queues())}
  end

  @impl true
  def handle_event("clear_queue", %{"id" => id}, socket) do
    Exq.Api.remove_queue(Exq.Api, id)
    send_update(ExquiLive.StatsComponent, id: "stats")
    {:noreply, assign(socket, jobs: queues())}
  end

  @impl true
  def handle_params(_, uri, socket) do
    %URI{path: path} = URI.parse(uri)
    {:noreply, assign(socket, current_path: path)}
  end

  defp queues do
    {:ok, queues} = Exq.Api.queue_size(Exq.Api)
    for {q, size} <- queues, do: %{id: q, size: size}
  end
end
