# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Tilex.Repo.insert!(%Tilex.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Tilex.{Channel, Developer, Post, Repo}

Repo.delete_all(Post)
Repo.delete_all(Channel)
Repo.delete_all(Developer)

phoenix_channel = Repo.insert!(%Channel{name: "html", twitter_hashtag: "html"})
phoenix_channel = Repo.insert!(%Channel{name: "ruby", twitter_hashtag: "ruby"})
phoenix_channel = Repo.insert!(%Channel{name: "rails", twitter_hashtag: "rails"})
phoenix_channel = Repo.insert!(%Channel{name: "javascript", twitter_hashtag: "javascript"})
phoenix_channel = Repo.insert!(%Channel{name: "nodejs", twitter_hashtag: "nodejs"})
phoenix_channel = Repo.insert!(%Channel{name: "react", twitter_hashtag: "react"})
phoenix_channel = Repo.insert!(%Channel{name: "sql", twitter_hashtag: "sql"})
phoenix_channel = Repo.insert!(%Channel{name: "elasticsearch", twitter_hashtag: "elasticsearch"})
phoenix_channel = Repo.insert!(%Channel{name: "mongodb", twitter_hashtag: "mongodb"})
phoenix_channel = Repo.insert!(%Channel{name: "heroku", twitter_hashtag: "heroku"})
phoenix_channel = Repo.insert!(%Channel{name: "aws", twitter_hashtag: "aws"})
phoenix_channel = Repo.insert!(%Channel{name: "angular", twitter_hashtag: "angular"})
phoenix_channel = Repo.insert!(%Channel{name: "ember", twitter_hashtag: "ember"})
phoenix_channel = Repo.insert!(%Channel{name: "phoenix", twitter_hashtag: "phoenix"})
elixir_channel = Repo.insert!(%Channel{name: "elixir", twitter_hashtag: "myelixirstatus"})
erlang_channel = Repo.insert!(%Channel{name: "erlang", twitter_hashtag: "erlang"})

# developer =
  # Repo.insert!(%Developer{email: "developer@hashrocket.com", username: "rickyrocketeer"})

# 1..100
# |> Enum.each(fn _i ->
#      Repo.insert!(%Post{
#        title: "Observing Change",
#        body: "A Gold Master Test in Practice",
#        channel: phoenix_channel,
#        developer: developer,
#        slug: Post.generate_slug(),
#      })

#      Repo.insert!(%Post{
#        title: "Controlling Your Test Environment",
#        body: "Slow browser integration tests are a hard problem",
#        channel: elixir_channel,
#        developer: developer,
#        slug: Post.generate_slug(),
#        is_public: true
#      })

#      Repo.insert!(%Post{
#        title: "Testing Elixir",
#        body: "A Rubyist's Journey",
#        channel: erlang_channel,
#        developer: developer,
#        slug: Post.generate_slug()
#      })
#    end)
