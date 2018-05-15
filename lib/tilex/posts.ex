defmodule Tilex.Posts do
  import Ecto.Query

  alias Ecto.Adapters.SQL
  alias Tilex.{Channel, Developer, Post, Repo}

  def all(page, only_public?: only_public?) do
    page
    |> posts(only_public?: only_public?)
    |> Repo.all()
  end

  def by_channel(channel_name, page, only_public?) do
    channel = Repo.get_by!(Channel, name: channel_name)

    query =
      page
      |> posts(only_public?: only_public?)
      |> where([p], p.channel_id == ^channel.id)

    posts_count =
      Repo.one(
        from(
          p in "posts",
          where: p.channel_id == ^channel.id and p.is_public in ^is_public_in(only_public?),
          select: fragment("count(*)")
        )
      )

    {Repo.all(query), posts_count, channel}
  end

  def by_developer(username, limit: limit, only_public?: only_public?) do
    query =
      from(
        p in Post,
        order_by: [desc: p.inserted_at],
        join: d in assoc(p, :developer),
        limit: ^limit,
        where: d.username == ^username and p.is_public in ^is_public_in(only_public?)
      )

    Repo.all(query)
  end

  def by_developer(username, page, only_public?: only_public?) do
    developer = Repo.get_by!(Developer, username: username)

    query =
      page
      |> posts(only_public?: only_public?)
      |> where([p], p.developer_id == ^developer.id)

    posts_count =
      Repo.one(
        from(
          p in "posts",
          where: p.developer_id == ^developer.id and p.is_public in ^is_public_in(only_public?),
          select: fragment("count(*)")
        )
      )

    {Repo.all(query), posts_count, developer}
  end

  def by_search(search_query, page, only_public?: only_public?) do
    sql = """
      select p.* from posts p
        join developers d on d.id = p.developer_id
        join channels c on c.id = p.channel_id
        join lateral (
          select ts_rank_cd(
            setweight(to_tsvector('english', p.title), 'A')
            ||
            setweight(to_tsvector('english', d.username), 'B')
            ||
            setweight(to_tsvector('english', c.name), 'B')
            ||
            setweight(to_tsvector('english', p.body), 'C')
            ,
            plainto_tsquery('english', $1)
          ) as rank
        ) ranks on true
        where ranks.rank > 0 and p.is_public = ANY($2)
        order by ranks.rank desc, p.inserted_at desc
    """

    results = SQL.query!(Repo, sql, [search_query, is_public_in(only_public?)])

    posts =
      results.rows
      |> Enum.map(&Repo.load(Post, {results.columns, &1}))
      |> Repo.preload(:developer)
      |> Repo.preload(:channel)

    offset = (page - 1) * Application.get_env(:tilex, :page_size)
    limit = Application.get_env(:tilex, :page_size) + 1

    {Enum.slice(posts, offset..(offset + limit)), Enum.count(posts)}
  end

  defp posts(page, only_public?: only_public?) do
    offset = (page - 1) * Application.get_env(:tilex, :page_size)
    limit = Application.get_env(:tilex, :page_size) + 1

    from(
      p in Post,
      order_by: [desc: p.inserted_at],
      join: c in assoc(p, :channel),
      join: d in assoc(p, :developer),
      where: p.is_public in ^is_public_in(only_public?),
      preload: [channel: c, developer: d],
      limit: ^limit,
      offset: ^offset
    )
  end

  defp is_public_in(true), do: [true]
  defp is_public_in(false), do: [true, false]
end
