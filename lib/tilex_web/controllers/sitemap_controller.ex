defmodule TilexWeb.SitemapController do
  use TilexWeb, :controller

  def index(conn, _) do
    conn
    |> assign(
      :posts,
      from(
        p in Tilex.Post,
        where: p.is_public in ^show_only_public?(conn)
      )
    )
    |> put_layout(false)
    |> render("sitemap.xml")
  end
end
