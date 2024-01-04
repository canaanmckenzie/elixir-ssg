
defmodule QuantNotes do
  alias QuantNotes.Blog
  use Phoenix.Component
  import Phoenix.HTML

  # html to define post "page"
  def post(assigns) do
    ~H"""
    <.layout>
    <div class="mt-10 w-1/2 px-8 mx-auto text-wrap flex-wrap items-center">
    <.header></.header>
    <div class="mx-auto shrink-0">
    <div class="text-center article-header mb-4"><h1 class="text-4xl font-bold"><%= @post.title %></h1></div>
    <div class="mb-2 flex items-end">
    <div class="pr-2">
    <div class="mb-auto">
    <%=@post.author%>&middot
    </div>
    </div>
    <div class="text-slate-600">
    <%=@post.date%> |
    </div>
    <div class="px-2 text-slate-400">
    <%= for tag <- @post.tags do %>
    <%=tag%><%end%>
    </div>
    </div>
    <div><%=raw @post.body %></div>
    </div>
    </div>
    </.layout>
    """
  end

  # html for index "page"
  def index(assigns) do
    ~H"""
    <.layout>
    <div class="mt-10 w-1/2 px-8 mx-auto overflow-auto items-center">
    <.header></.header>

    <div class="mb-6">Hi, I'm Canaan, \(\chi\alpha\nu\alpha\alpha\nu\) (Greek). I focus on Type, as in Typography, and in Type Theory, and work on text processing and digital typography for all the languages around the world.
    </div>

    <div class="flex">
    <div class="shrink-0">

     <div class="mb-4">
     <h1 class="text-2xl font-bold">Writings</h1>
     </div>

     <div class="pl-10">

     <ul>
     <li :for={post <- @posts}>

     <div class="flex items-center">
     <div class="text-xs dark:text-slate-400"><%=post.date%></div>

     <a class="px-7 underline decoration-0 hover:decoration-neonblue" href={post.path}>
     <%=post.title%>
     </a>

     </div>


     </li>
     </ul>
     </div>


     </div>
     </div>
     </div>
     </.layout>
    """
  end

  def header(assigns) do
    ~H"""
    <div class="items-center p-4">
    <a href="/" title="home">
    <h1 class="mb-8 text-4xl font-bold text-center">\(\chi\alpha\nu\alpha\alpha\nu\).io
    </h1>
    </a>
    </div>
    """
  end

  # layout from phoenix 
  def layout(assigns) do
    ~H"""
    <html>
    <head>
    <script src="https://polyfill.io/v3/polyfill.min.js?features=es6"></script>
    <script id="MathJax-script" async src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js"></script>
    <link rel="stylesheet" href="/assets/app.css"/>
    <link rel="stylesheet" href="/assets/theme.css"/>
    <script type="text/javascript" src="/assets/app.js" />
    </head>
    <body class="antialiased bg-sumiblack dark:bg-sumiblack dark:text-pearl">
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
    render_file("assets/theme.css",Makeup.stylesheet(:native_style,"makeup")) #render code blocks

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
