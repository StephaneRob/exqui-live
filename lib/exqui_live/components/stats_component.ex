defmodule ExquiLive.StatsComponent do
  use ExquiLive.Web, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <h1 class="text-xl mb-4 text-black font-bold my-5">Stats</h1>

    <div class="grid grid-cols-6 gap-4 mb-5 p-5 rounded shadow bg-white">
      <div>
        <p class="text-gray-600 uppercase mb-4 text-yellow-400 text-sm">Processed</p>
        <h4 class="text-gray-800 text-md"><%= @processed %></p>
      </div>

      <div>
        <p class="text-gray-600 uppercase mb-4 text-sm">Busy</p>
        <h4 class="text-gray-800 text-md"><%= @busy %></p>
      </div>

      <div>
        <p class="text-gray-600 uppercase mb-4 text-sm">Enqueued</p>
        <h4 class="text-gray-800 text-md"><%= @enqueued %></p>
      </div>

      <div>
        <p class="text-gray-600 uppercase mb-4 text-sm">Retries</p>
        <h4 class="text-gray-800 text-md"><%= @retries %></p>
      </div>

      <div>
        <p class="mb-4 uppercase text-gray-600">Scheduled</p>
        <h4 class="text-gray-800 text-md"><%= @scheduled %></p>
      </div>

      <div>
        <p class="text-gray-600 uppercase mb-4 text-red-400 text-sm">Dead</p>
        <h4 class="text-gray-800 text-md"><%= @dead %></p>
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
