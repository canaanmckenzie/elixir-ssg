
defmodule QuantNotes do
  alias QuantNotes.Blog
  use Phoenix.Component
  import Phoenix.HTML

  # html to define post "page"
  def post(assigns) do
    ~H"""
    <.layout>
    <div class="p-6 max-w-md mx-auto flex items-center">
     <div class="shrink-0">
      <div class="article-header mb-4">
       <h1 class="text-3xl font-bold"><%= @post.title %></h1>
      </div>
      <div class="max-w-md mx-auto">
       <%= raw @post.body %>
      </div>
     </div>
    </div>
    </.layout>
    """
  end

  # html for index "page"
  def index(assigns) do
    ~H"""
    <.layout>
    <div class="p-6 max-w-md mx-auto flex items-center">
     <div class="shrink-0">
      <div class="mb-4">
       <h1 class="text-3xl font-bold">Writings</h1>
      </div>
      <div class="max-w-md mx-auto">
       <ul>
       <li :for={post <- @posts}>
       <div class="flex items-center">
       <div class="text-xs text-slate-600"><%=post.date%></div>
       <div class="p-2">
          <a class="bg-yellow-300 border-yellow-600 border-b rounded" href={post.path}>
          <%=post.title%>
          </a>
        </div>
       </div>
        </li>
      </ul>
     </div>
    </div>
    </div>
    </.layout>
    """
  end

  # layout from phoenix 
  def layout(assigns) do
    ~H"""
    <html>
    <head>
    <link rel="stylesheet" href="/assets/app.css"/>
    <script type="text/javascript" src="/assets/app.js" />
    </head>
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

    render_file("index.html", index(%{posts: posts}))

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
