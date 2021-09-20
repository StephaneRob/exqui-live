# iex -S mix run dev.exs
Logger.configure(level: :debug)

# Configures the endpoint
Application.put_env(:exqui_live, DemoWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Hu4qQN3iKzTV4fJxhorPQlA/osH9fAMtbtjVS58PFgfw3ja5Z18Q/WSNR9wP4OfW",
  live_view: [signing_salt: "hMegieSe"],
  http: [port: 4000],
  debug_errors: true,
  check_origin: false,
  pubsub_server: Demo.PubSub,
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:default, ~w(--sourcemap=inline --watch)]},
    npx: [
      "tailwindcss",
      "--input=css/app.css",
      "--output=../priv/static/assets/app.css",
      "--postcss",
      "--watch",
      cd: Path.expand("./assets", __DIR__)
    ]
  ],
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"lib/exqui_live/(live|views)/.*(ex)$",
      ~r"lib/exqui_live/templates/.*(ex)$"
    ]
  ]
)

defmodule DemoWeb.Worker.Default do
  def perform do
    :timer.sleep(:rand.uniform(10000))
  end
end

defmodule DemoWeb.Worker.Email do
  def perform do
    :timer.sleep(:rand.uniform(10000))
  end
end

defmodule DemoWeb.Worker.Failed do
  def perform do
    1 / 0
  end
end

defmodule DemoWeb.Enqueuer do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{})
  end

  @impl true
  def init(_) do
    schedule_work()
    {:ok, %{}}
  end

  @impl true
  def handle_info(:enqueue, state) do
    {queue, worker} =
      Enum.random([
        {"default", DemoWeb.Worker.Default},
        {"default", DemoWeb.Worker.Default},
        {"default", DemoWeb.Worker.Default},
        {"failed", DemoWeb.Worker.Failed},
        {"email", DemoWeb.Worker.Email},
        {"email", DemoWeb.Worker.Email},
        {"email", DemoWeb.Worker.Email},
        {"email", DemoWeb.Worker.Email}
      ])

    Exq.enqueue_in(Exq, queue, :rand.uniform(200), worker, [])
    schedule_work()
    {:noreply, state}
  end

  defp schedule_work do
    Process.send_after(self(), :enqueue, :rand.uniform(5000))
  end
end

defmodule DemoWeb.PageController do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, :index) do
    content(conn, """
    <h2>Exqui live dasboard</h2>
    <a href="/exqui" target="_blank">Open Dashboard</a>
    """)
  end

  def call(conn, :hello) do
    name = Map.get(conn.params, "name", "friend")
    content(conn, "<p>Hello, #{name}!</p>")
  end

  defp content(conn, content) do
    conn
    |> put_resp_header("content-type", "text/html")
    |> send_resp(200, "<!doctype html><html><body>#{content}</body></html>")
  end
end

defmodule DemoWeb.Router do
  use Phoenix.Router
  import ExquiLive.Router

  pipeline :browser do
    plug :fetch_session
  end

  scope "/" do
    pipe_through :browser
    get "/", DemoWeb.PageController, :index
    get "/hello", DemoWeb.PageController, :hello
    get "/hello/:name", DemoWeb.PageController, :hello
    exqui_live("/exqui")
  end
end

defmodule DemoWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :exqui_live

  socket "/live", Phoenix.LiveView.Socket
  socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket

  plug Phoenix.LiveReloader
  plug Phoenix.CodeReloader

  plug Plug.Logger

  plug Plug.Session,
    store: :cookie,
    key: "_live_view_key",
    signing_salt: "99gAiOjfkUw1mGm"

  plug Plug.RequestId
  plug DemoWeb.Router
end

Application.ensure_all_started(:os_mon)
Application.put_env(:phoenix, :serve_endpoints, true)

Task.start(fn ->
  children = [
    {Phoenix.PubSub, [name: Demo.PubSub, adapter: Phoenix.PubSub.PG2]},
    DemoWeb.Endpoint,
    DemoWeb.Enqueuer
  ]

  {:ok, _} = Supervisor.start_link(children, strategy: :one_for_one)
  Process.sleep(:infinity)
end)
