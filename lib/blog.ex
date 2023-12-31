defmodule QuantNotes.Blog do
  alias QuantNotes.Post

  # parse posts/YEAR/MONTH-DAY-ID.md into Post struct
  use NimblePublisher,
    build: Post,
    from: "./posts/**/*.md",
    as: :posts,
    highlighters: [:makeup_elixir, :makeup_erlang]

  @posts Enum.sort_by(@posts, & &1.date, {:desc, Date})

  # export them
  def all_posts, do: @posts
end
