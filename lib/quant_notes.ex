defmodule QuantNotes do
  use Phoenix.Component
  import Phoenix.HTML

  # html to define post "page"
  def post(assigns) do
    ~H"""
    <.layout>
    <%= raw @post.body %>
    </.layout>
    """
  end

  # html for index "page"
  def index(assigns) do
    ~H"""
    <.layout>
    <h1>Xavaav</h1>
    <h2>Writings</h2>
    <ul>
    <li :for={post <- @posts}>
    <a href="{post.path}"><%=post.title%></a>
    </li>
    </ul>
    </.layout>
    """
  end

  # layout from phoenix 
  def layout(assigns) do
    ~H"""
    <html>
    <body>
    <%=render_slot(@inner_block)%>
    </body>
    </html>
    """
  end

  # make an output directory for public facing files (if it doesn't exist)
  @output_dir "./output"
  File.mkdir_p!(@output_dir)

  # collect and render data
  def build() do
    posts = Blog.all_posts()

    render_file("index.html",index(%{posts: posts}))

    for post <- posts do
      dir = Path.dirname(post.path)
      if dir != "." do
        File.mkdir_p!(Path.join([@output_dir,dir]))
      end
      render_file(post.path, post(%{post: post}))
    end
    :ok  # potentially need error handling here if file can't be read etc..
  end

  def render_file(path,rendered) do
    safe = Phoenix.HTML.Safe.to_iodata(rendered)
    output = Path.join([@output_dir,path])
    File.write!(output,safe)
  end
end
