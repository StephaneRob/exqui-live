defmodule ExquiLive.FailedLive do
  use ExquiLive.Web, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex items-center">
      <h1 class="text-xl text-black font-bold my-5">Failed</h1>
      <button phx-click="delete" data-confirm="Are you sure?" class="text-sm ml-auto bg-red-300 hover:bg-red-400 py-1 px-2 rounded-sm">Delete</button>
    </div>
    <div class="rounded-sm overflow-hidden shadow bg-white">
      <table class="table-auto w-full">
        <tbody>
          <tr>
            <td class="border px-4 py-2 border-l-0">
              Worker
            </td>
            <td class="border px-4 py-2">
              <pre class="text-xs bg-gray-200 p-1 rounded-sm text-gray-600 inline-block"><%= @job.class %></pre>
            </td>
          </tr>
          <tr>
            <td class="border px-4 py-2 border-l-0">
              Args
            </td>
            <td class="border px-4 py-2">
              <pre class="text-xs bg-gray-200 p-1 rounded-sm text-gray-600 inline-block"><%= inspect(@job.args) %></pre>
            </td>
          </tr>
          <tr>
            <td class="border px-4 py-2 border-l-0">
              Failed at
            </td>
            <td class="border px-4 py-2">
              <pre class="text-xs bg-gray-200 p-1 rounded-sm text-gray-600 inline-block"><%= score_to_time(@job.failed_at) %></pre>
            </td>
          </tr>
          <tr>
            <td class="border px-4 py-2 border-l-0">
              Error
            </td>
            <td class="border px-4 py-2">
              <code><pre class="text-xs bg-gray-200 p-1 rounded-sm text-gray-600 inline-block"><%= @job.error_message %></pre></code>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    """
  end

  @impl true
  def mount(%{"jid" => jid}, _, socket) do
    {:ok, assign(socket, jid: jid, job: failed(jid))}
  end

  @impl true
  def handle_info(:update, socket) do
    {:noreply, assign(socket, job: failed(socket.assigns.jid))}
  end

  @impl true
  def handle_event("delete", _value, socket) do
    Exq.Api.remove_failed(Exq.Api, socket.assigns.jid)
    {:noreply, push_redirect(socket, to: exqui_live_path(socket, :all_failed))}
  end

  defp failed(jid) do
    {:ok, job} = Exq.Api.find_failed(Exq.Api, jid)
    job
  end

  @impl true
  def handle_params(_, uri, socket) do
    %URI{path: path} = URI.parse(uri)
    {:noreply, assign(socket, current_path: path)}
  end
end
