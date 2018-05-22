defmodule TilexWeb.ChannelController do
  use TilexWeb, :controller

  alias Guardian.Plug
  alias Tilex.{Channel, Posts}

  plug(
    Plug.EnsureAuthenticated,
    [handler: __MODULE__]
    when action in ~w(new create)a
  )

  def unauthenticated(conn, _) do
    conn
    |> put_status(302)
    |> put_flash(:info, "Authentication required")
    |> redirect(to: "/")
  end

  def show(conn, %{"name" => channel_name} = params) do
    page =
      params
      |> Map.get("page", "1")
      |> String.to_integer()

    {posts, posts_count, channel} = Posts.by_channel(channel_name, page, show_only_public?(conn))

    render(
      conn,
      "show.html",
      posts: posts,
      posts_count: posts_count,
      channel: channel,
      page: page
    )
  end

  def new(conn, _params) do
    changeset = Channel.changeset(%Channel{})

    conn
    |> assign(:changeset, changeset)
    |> render("new.html")
  end

  def create(conn, %{"channel" => channel_params}) do
    changeset =
      %Channel{}
      |> Channel.changeset(Map.put(channel_params, "twitter_hashtag", channel_params["name"]))

    case Repo.insert(changeset) do
      {:ok, _channel} ->
        conn
        |> put_flash(:info, "Channel created")
        |> redirect(to: "/")

      {:error, changeset} ->
        conn
        |> assign(:changeset, changeset)
        |> render("new.html")
    end
  end
end
