defmodule ExquiLive.QueuesLive do
  use ExquiLive.Web, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <h1 class="title">Queues</h1>
    <div class="block">
      <table class="table-auto w-full">
        <thead>
          <tr>
            <th>Name</th>
            <th>Jobs</th>
          </tr>
        </thead>
        <tbody>
          <%= for queue <- @queues do %>
            <tr>
              <td>
                <%= live_redirect(queue.id, to: exqui_live_path(@socket, :queue, queue.id), class: "hover:text-yellow-500" ) %>
              </td>
              <td><%= queue.size %></td>
              <td>
                <button phx-click="clear_queue" data-confirm="Are you sure?" phx-value-id={queue.id} class="button button-danger">Delete</button>
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
