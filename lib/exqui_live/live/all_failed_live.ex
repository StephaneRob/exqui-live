defmodule ExquiLive.AllFailedLive do
  use ExquiLive.Web, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex items-center">
      <h1 class="title">Failed</h1>
      <button phx-click="delete_all" data-confirm="Are you sure?" class="button button-danger">Delete all</button>
    </div>
    <div class="block">
      <table class="table-auto w-full">
        <thead>
          <tr>
            <th>Worker</th>
            <th>Arguments</th>
            <th>Failed at</th>
          </tr>
        </thead>
        <tbody>
          <%= for job <- @jobs do %>
            <tr>
              <td>
                <pre class="code"><%= job.class %></pre>
              </td>
              <td>
                <pre class="code"><%= inspect(job.args) %></pre>
              </td>
              <td><%= score_to_time(job.failed_at) %></td>
              <td>
                <%= live_redirect("See", to: exqui_live_path(@socket, :failed, job.jid), class: "button button-primary button-full" ) %>
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
    {:ok, assign(socket, jobs: failed(), refresh: 2)}
  end

  @impl true
  def handle_event("delete_all", _value, socket) do
    Exq.Api.clear_failed(Exq.Api)
    {:noreply, assign(socket, jobs: failed())}
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
