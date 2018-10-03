use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :tilex, TilexWeb.Endpoint,
  http: [port: 4000, protocol_options: [max_request_line_length: 8192, max_header_value_length: 8192]],
  url: [scheme: "https", host: "localdev.selleo.com", path: "/til"],
  secret_key_base: "mdTtrt4Y4JrtiTv63NepUe4fs1iSt23VfzKpnXm6mawKl6wN8jEfLfIf2HbyMeKe",
  render_errors: [view: TilexWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Tilex.PubSub, adapter: Phoenix.PubSub.PG2],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    node: [
      "node_modules/brunch/bin/brunch",
      "watch",
      "--stdin",
      cd: Path.expand("../assets", __DIR__)
    ]
  ]

# Watch static and templates for browser reloading.
config :tilex, TilexWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/tilex/web/views/.*(ex)$},
      ~r{lib/tilex/web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :tilex, Tilex.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "tilex_dev",
  hostname: "localhost",
  pool_size: 10

config :tilex, :page_size, 50
config :tilex, :cors_origin, "http://localhost:3000"
config :tilex, :default_twitter_handle, "selleo"
