defmodule ExquiLive.ScheduledLive do
  use ExquiLive.Web, :live_view

  @impl true
  def render(assigns) do
    ~L"""
    <div class="flex my-5 items-center">
      <h1 class="text-2xl text-black font-bold my-5">Scheduled</h1>
      <button phx-click="clear_all" data-confirm="Are you sure?" class="text-sm ml-auto bg-red-300 hover:bg-red-400 py-1 px-2 rounded-sm">Clear all</button>
    </div>
    <div class="rounded-sm overflow-hidden shadow bg-white">
      <table class="table-auto w-full">
        <thead>
          <tr>
            <th class="px-4 py-2 text-left text-gray-600">Queue</th>
            <th class="px-4 py-2 text-left text-gray-600">Worker</th>
            <th class="px-4 py-2 text-left text-gray-600">Arguments</th>
            <th class="px-4 py-2 text-left text-gray-600">Scheduled at</th>
            <th class="px-4 py-2 text-left text-gray-600">Enqueued at</th>
            <th class="px-4 py-2 text-left text-gray-600"></th>
          </tr>
        </thead>
        <tbody>
          <%= for job <- @jobs do %>
            <tr>
              <td class="border px-4 py-2 border-l-0">
                <pre class="text-xs bg-gray-200 p-1 rounded-sm text-gray-600 inline-block"><%= job.queue %></pre>
              </td>
              <td class="border px-4 py-2 ">
                <pre class="text-xs bg-gray-200 p-1 rounded-sm text-gray-600 inline-block"><%= job.class %></pre>
              </td>
              <td class="border px-4 py-2">
                <pre class="text-xs bg-gray-200 p-1 rounded-sm text-gray-600 inline-block"><%= inspect(job.args) %></pre>
              </td>
              <td class="border px-4 py-2 text-sm"><%= job.scheduled_at %></td>
              <td class="border px-4 py-2 text-sm"><%= score_to_time(job.enqueued_at) %></td>
              <td class="border px-4 py-2 border-r-0 text-sm">
                <button phx-click="delete_job" data-confirm="Are you sure?" phx-value-id="<%= job.id %>" class="ml-4 bg-red-300 hover:bg-red-400 py-1 px-2 rounded-sm">Delete</button>
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
    {:ok, assign(socket, jobs: fetch_jobs())}
  end

  @impl true
  def handle_info(:update, socket) do
    send_update(ExquiLive.StatsComponent, id: "stats")
    {:noreply, assign(socket, jobs: fetch_jobs())}
  end

  @impl true
  def handle_event("clear_all", _value, socket) do
    Exq.Api.clear_scheduled(Exq.Api)
    send_update(ExquiLive.StatsComponent, id: "stats")
    {:noreply, assign(socket, jobs: fetch_jobs())}
  end

  @impl true
  def handle_event("delete_job", %{"id" => id}, socket) do
    Exq.Api.remove_scheduled(Exq.Api, id)
    send_update(ExquiLive.StatsComponent, id: "stats")
    {:noreply, assign(socket, jobs: fetch_jobs())}
  end

  defp fetch_jobs do
    {:ok, jobs} = Exq.Api.scheduled_with_scores(Exq.Api)
    map_score_to_jobs(jobs)
  end

  @impl true
  def handle_params(_, uri, socket) do
    %URI{path: path} = URI.parse(uri)
    {:noreply, assign(socket, current_path: path)}
  end
end
