defmodule ExquiLive.AllFailedLive do
  use ExquiLive.Web, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex items-center">
      <h1 class="text-xl text-black font-bold my-5">Failed</h1>
      <button phx-click="delete_all" data-confirm="Are you sure?" class="text-sm ml-auto bg-red-300 hover:bg-red-400 py-1 px-2 rounded-sm">Delete all</button>
    </div>
    <div class="rounded-sm overflow-hidden shadow bg-white">
      <table class="table-auto w-full">
        <thead>
          <tr>
            <th class="px-4 py-2 text-left text-gray-600">Worker</th>
            <th class="px-4 py-2 text-left text-gray-600">Arguments</th>
            <th class="px-4 py-2 text-left text-gray-600">Failed at</th>
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
              <td class="border px-4 py-2 text-sm"><%= score_to_time(job.failed_at) %></td>
              <td class="border px-4 py-2 border-l-0 text-center">
                <%= live_redirect("See", to: exqui_live_path(@socket, :failed, job.jid), class: "text-sm bg-yellow-300 hover:bg-yellow-400 py-1 px-2 rounded-sm" ) %>
              </td>
            </tr>
          <% end %>
        </tbody>
      </table>
    </div>
    """
  end

  @impl true
  def mount(_, _, socket) do
    {:ok, assign(socket, jobs: failed())}
  end

  @impl true
  def handle_event("delete_all", _value, socket) do
    Exq.Api.clear_failed(Exq.Api)
    {:noreply, assign(socket, jobs: failed())}
  end

  defp failed do
    {:ok, jobs} = Exq.Api.failed(Exq.Api)
    map_jid_to_id(jobs)
  end

  @impl true
  def handle_params(_, uri, socket) do
    %URI{path: path} = URI.parse(uri)
    {:noreply, assign(socket, current_path: path)}
  end
end
