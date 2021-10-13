defmodule ExquiLive.StatsComponent do
  use ExquiLive.Web, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="stats">
      <h1 class="title">Stats</h1>

      <div class="grid grid-cols-6 gap-4 block p-5">
        <div>
          <p class="text-gray-600 uppercase mb-4 text-yellow-400 text-sm">Processed</p>
          <p class="text-gray-800 text-md"><%= @processed %></p>
        </div>
        <div>
          <p class="text-gray-600 uppercase mb-4 text-sm">Busy</p>
          <p class="text-gray-800 text-md"><%= @busy %></p>
        </div>
        <div>
          <p class="text-gray-600 uppercase mb-4 text-sm">Enqueued</p>
          <p class="text-gray-800 text-md"><%= @enqueued %></p>
        </div>
        <div>
          <p class="text-gray-600 uppercase mb-4 text-sm">Retries</p>
          <p class="text-gray-800 text-md"><%= @retries %></p>
        </div>
        <div>
          <p class="mb-4 uppercase text-gray-600">Scheduled</p>
          <p class="text-gray-800 text-md"><%= @scheduled %></p>
        </div>
        <div>
          <p class="text-gray-600 uppercase mb-4 text-red-400 text-sm">Dead</p>
          <p class="text-gray-800 text-md"><%= @dead %></p>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    socket = assign(socket, stats())
    {:ok, assign(socket, assigns)}
  end

  @impl true
  def mount(socket) do
    {:ok, assign(socket, stats())}
  end

  defp stats do
    {:ok, processed} = Exq.Api.stats(Exq.Api, "processed")
    {:ok, failed} = Exq.Api.stats(Exq.Api, "failed")
    {:ok, busy} = Exq.Api.busy(Exq.Api)
    {:ok, scheduled} = Exq.Api.scheduled_size(Exq.Api)
    {:ok, retries} = Exq.Api.retry_size(Exq.Api)
    {:ok, dead} = Exq.Api.failed_size(Exq.Api)
    {:ok, queues} = Exq.Api.queue_size(Exq.Api)

    queue_sizes =
      for {_q, size} <- queues do
        size
      end

    qtotal = "#{Enum.sum(queue_sizes)}"

    [
      processed: processed || 0,
      failed: failed || 0,
      busy: busy || 0,
      scheduled: scheduled || 0,
      dead: dead || 0,
      retries: retries || 0,
      enqueued: qtotal
    ]
  end
end
