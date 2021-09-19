defmodule ExquiLive.ChartComponent do
  use ExquiLive.Web, :live_component

  @impl true
  def mount(socket) do
    {:ok, assign(socket, data: []), temporary_assigns: [data: []]}
  end

  @impl true
  def update(assigns, socket) do
    {:ok, failures, successes} = Exq.Api.realtime_stats(Exq.Api)

    now = (DateTime.utc_now() |> DateTime.to_unix(:millisecond)) / 1000
    start_date = now - 5

    failed =
      Enum.reduce(failures, 0, fn {d, count}, acc ->
        {:ok, d, _} = DateTime.from_iso8601(d)
        date = DateTime.to_unix(d)

        if date - start_date > 0 do
          acc + String.to_integer(count)
        else
          acc
        end
      end)

    success =
      Enum.reduce(successes, 0, fn {d, count}, acc ->
        {:ok, d, _} = DateTime.from_iso8601(d)
        date = DateTime.to_unix(d)

        if date - start_date > 0 do
          acc + String.to_integer(count)
        else
          acc
        end
      end)

    assigns =
      assigns
      |> Map.merge(%{data: [{now, success, failed}]})

    {:ok, assign(socket, assigns)}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <h1 class="text-xl mb-4 text-black font-bold my-5">Real time</h1>
    <div class="rounded-sm overflow-hidden shadow bg-white p-4">
      <div id="chart-<%= @id %>" phx-hook="ChartHook" class="col-12" data-title="<%= @id %>" data-name="<%= @name %>">
        <div class="data">
          <%= for {timestamp, success, failed} <- @data do %>
            <span data-timestamp="<%= timestamp%>" data-success="<%= success %>" data-failed="<%= failed %>"></span>
          <% end %>
        </div>
        <div class="chart-container" phx-update="ignore"><div>
      </div>
    </div>
    """
  end
end
