# ExquiLive

<img src="https://github.com/StephaneRob/exqui-live/raw/main/guides/images/dashboard.png" alt="Exq UI">

UI for exq job processing library built with phoenix LiveView

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `exqui_live` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:exqui_live, "~> 0.1.0"}
  ]
end
```

### Configure LiveView

The dashboard is built on top of LiveView. If LiveView is already installed in your app, feel free to skip this section.

```elixir
# config/config.exs
config :my_app, MyAppWeb.Endpoint,
  live_view: [signing_salt: "SECRET_SALT"]
```

Then add the Phoenix.LiveView.Socket declaration to your endpoint:

```elixir
socket "/live", Phoenix.LiveView.Socket
```

### Add dashboard access

```elixir
# lib/my_app_web/router.ex
use MyAppWeb, :router
import ExquiLive.Router

...

if Mix.env() == :dev do
  scope "/" do
    pipe_through :browser
    exqui_live "/exqui"
  end
end
```
