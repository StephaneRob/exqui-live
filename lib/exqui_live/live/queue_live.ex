defmodule ExquiLive.QueueLive do
  use ExquiLive.Web, :live_view

  @impl true
  def render(assigns) do
    ~L"""
    <h1 class="text-2xl mb-4 text-black font-bold my-5">Queue: <span class="text-gray-700"><%= @queue.id %></span></h1>
    <div class="rounded-sm overflow-hidden shadow bg-white">
      <table class="table-auto w-full">
        <thead>
          <tr>
            <th class="px-4 py-2 text-left text-gray-600">Worker</th>
            <th class="px-4 py-2 text-left text-gray-600">Arguments</th>
            <th class="px-4 py-2 text-left text-gray-600">Enqueued at</th>
          </tr>
        </thead>
        <tbody>
          <%= for job <- @jobs do %>
            <tr>
              <td class="border px-4 py-2 border-l-0">
                <pre class="text-xs bg-gray-200 p-1 rounded-sm text-gray-600 inline-block"><%= job.class %></pre>
              </td>
              <td class="border px-4 py-2">
                <pre class="text-xs bg-gray-200 p-1 rounded-sm text-gray-600 inline-block"><%= inspect(job.args) %></pre>
              </td>
              <td class="border px-4 py-2 border-r-0 text-sm"><%= score_to_time(job.enqueued_at) %></td>
            </tr>
          <% end %>
        </tbody>
      </table>
    </div>
    """
  end

  @impl true
  def mount(%{"name" => id}, _, socket) do
    if connected?(socket), do: :timer.send_interval(4000, self(), :update)
    {queue, jobs} = queue(id)
    {:ok, assign(socket, queue: queue, jobs: jobs)}
  end

  @impl true
  def handle_info(:update, socket) do
    {queue, jobs} = queue(socket.assigns.queue.id)
    {:noreply, assign(socket, queue: queue, jobs: jobs)}
  end

  defp queue(id) do
    {:ok, jobs} = Exq.Api.jobs(Exq.Api, id)
    jobs_structs = map_jid_to_id(jobs)
    job_ids = for j <- jobs_structs, do: Map.get(j, :id)
    {%{id: id, job_ids: job_ids, partial: false}, map_jid_to_id(jobs)}
  end
end
