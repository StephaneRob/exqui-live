defmodule ExquiLive.RetriesLive do
  use ExquiLive.Web, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex items-center">
      <h1 class="text-xl text-black font-bold my-5">Retries</h1>
      <button phx-click="delete_all" data-confirm="Are you sure?" class="text-sm ml-auto bg-red-300 hover:bg-red-400 py-1 px-2 rounded-sm">Delete all</button>
    </div>
    <div class="rounded-sm overflow-hidden shadow bg-white">
      <table class="table-auto w-full">
        <thead>
          <tr>
            <th class="px-4 py-2 text-left text-gray-600">Queue</th>
            <th class="px-4 py-2 text-left text-gray-600">Worker</th>
            <th class="px-4 py-2 text-left text-gray-600">Arguments</th>
            <th class="px-4 py-2 text-left text-gray-600">Retry Count</th>
            <th class="px-4 py-2 text-left text-gray-600">Failed at</th>
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
              <td class="border px-4 py-2 text-sm"><%= job.retry_count %>/<%= job.retry %></td>
              <td class="border px-4 py-2 text-sm"><%= job.failed_at %></td>
              <td class="border px-4 py-2 text-sm"><%= score_to_time(job.enqueued_at) %></td>
              <td class="border px-4 py-2 border-r-0 text-sm text-right">
                <button phx-click="retry_job" data-confirm="Are you sure?" phx-value-id={job.id} class="ml-2 bg-yellow-300 hover:bg-yellow-400 py-1 px-2 rounded-sm">Retry</button>
                <button phx-click="delete_job" data-confirm="Are you sure?" phx-value-id={job.id} class="ml-2 bg-red-300 hover:bg-red-400 py-1 px-2 rounded-sm">Delete</button>
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
    {:ok, assign(socket, jobs: fetch_jobs(), refresh: 2)}
  end

  @impl true
  def handle_info(:update, socket) do
    {:noreply, assign(socket, jobs: fetch_jobs())}
  end

  @impl true
  def handle_event("delete_all", _value, socket) do
    Exq.Api.clear_retries(Exq.Api)
    {:noreply, assign(socket, jobs: fetch_jobs())}
  end

  @impl true
  def handle_event("delete_job", %{"id" => id}, socket) do
    Exq.Api.remove_retry(Exq.Api, id)
    {:noreply, assign(socket, jobs: fetch_jobs())}
  end

  @impl true
  def handle_event("retry_job", %{"id" => id}, socket) do
    Exq.Api.retry_job(Exq.Api, id)
    {:noreply, assign(socket, jobs: fetch_jobs())}
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

  defp fetch_jobs do
    {:ok, retries} = Exq.Api.retries(Exq.Api)

    retries
    |> map_jid_to_id()
    |> convert_results_to_times(:failed_at)
  end

  @impl true
  def handle_params(_, uri, socket) do
    %URI{path: path} = URI.parse(uri)
    {:noreply, assign(socket, current_path: path)}
  end
end
