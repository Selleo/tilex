defmodule TilexWeb.Router do
  use TilexWeb, :router

  @auth_controller Application.get_env(:tilex, :auth_controller)
  @cors_origin Application.get_env(:tilex, :cors_origin)

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(Tilex.Plug.BasicAuth)
    plug(Tilex.Plug.FormatInjector)
  end

  pipeline :browser_auth do
    plug(Guardian.Plug.VerifySession)
    plug(Guardian.Plug.LoadResource)
  end

  pipeline :api do
    if @cors_origin do
      plug(CORSPlug, origin: @cors_origin)
    end

    plug(:accepts, ["json"])
  end

  scope "/api", TilexWeb do
    pipe_through([:api])

    get("/developer_posts.json", Api.DeveloperPostController, :index)
  end

  get("/rss", TilexWeb.FeedController, :index)

  scope "/", TilexWeb do
    pipe_through([:browser, :browser_auth])

    get("/admin", @auth_controller, :index)
    delete("/auth/logout", AuthController, :delete)
    get("/auth/:provider", AuthController, :request)
    get("/auth/:provider/callback", AuthController, :callback)
    post("/auth/:provider/callback", AuthController, :callback)

    get("/statistics", StatsController, :index)

    get("/sitemap.xml", SitemapController, :index)
    get("/manifest.json", WebManifestController, :index)
    get("/random", PostController, :random)

    # TODO: :new and :create aren't related to :show here, they should be in a different controller
    get("/:name", ChannelController, :show)
    get("/channels/new", ChannelController, :new)
    post("/channels", ChannelController, :create)

    get("/authors/:name", DeveloperController, :show)
    get("/profile/edit", DeveloperController, :edit)
    put("/profile/edit", DeveloperController, :update)

    get("/", PostController, :index)
    resources("/posts", PostController, except: [:delete], param: "titled_slug")
    resources("/posts", PostController, only: [:delete])
    post("/posts/:slug/like.json", PostController, :like)
    post("/posts/:slug/unlike.json", PostController, :unlike)
  end
end
