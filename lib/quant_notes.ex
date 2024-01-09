defmodule QuantNotes do
  alias QuantNotes.Blog
  use Phoenix.Component
  import Phoenix.HTML

  # html to define post "page"
  def post(assigns) do
    ~H"""
    <.layout>
    <.header></.header>
    <div class="w-3/5 px-8 mx-auto text-wrap flex-wrap items-center">
    <div class="ml-10 mt-16">
    <div class="flex">

    <div class="text-s text-gray mt-24 items-baseline pr-8">

    <div class="items-baseline">
    <%=@post.date%>
    </div>

    <div class="text-gray">
    <%= for tag <- @post.tags do %>
    <%=tag%><%end%>
    </div>

    </div>

    <div class="post-content ml-30">
    <div class=" border-t-4 mb-8 mt-4"><h1 class="text-4xl"><%= @post.title %></h1>
    </div>
    <div class="overflow-y-auto text-wrap"><%=raw @post.body %>
    </div>

    </div>

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
    <.header></.header>
    <div class="w-3/5 px-8 mx-auto items-center">
    <div class="flex ml-36 mt-24">
    <div class="shrink-0">

     <div class="pl-30">
     <ul>
     <div class="border-b-2 mb-6">
      <li class="mb-6"><a class="mb-8 text-3xl pr-2 no-underline decoration-2 hover:underline" href="/about.html">about me</a></li>

      <li class="mb-6"><a class="mb-8 text-3xl pr-2 no-underline decoration-2 hover:underline" href="/CanaanMcKenzie2024BlogVersion.pdf">cv & résumé</a></li>
      </div>
     <li :for={post <- @posts}>

     <div class="flex items-baseline">
     <a class="mb-6 text-3xl no-underline pr-2 decoration-2 hover:underline" href={post.path}>
     <%=post.title%>
     </a>
     <div class="dark:text-gray"><%=post.date%></div>

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
    <div class="w-8/12 mx-auto mb-4">
    <a href="/" class="no-underline hover:underline text-tyrianPurple border-1 border-r border-b border-tyrianPurple dark:border-l dark:border-r dark:border-b dark:border-tyrianPurple">:~$ </a>
    </div>
    """
  end

   def about(assigns) do
    ~H"""
    <.layout>
    <.header></.header>
    <div class="w-3/5 px-8 mx-auto items-center">
    <div class="border-t-4 ml-40 mt-16">
    <h1 class="mb-12 text-4xl">about me</h1>
    <p class="mb-4">My name is Canaan McKenzie.</p>
    <p class="mb-4"> I'm a mechanical engineer turned chemist, turned software engineer. Welcome to my small corner of the internet.</p>
    <p class="mb-4">I work with and write about cryptography, distributed networks, and data.</p>
    <p class="mb-4"> My notes/stories/work around other topics that interest me will (frequently) interject themselves here.</p>
    <div class="border-t-4">
    <h2 class="text-bold text-4xl mb-12">colophon</h2>
    <p class="mb-4">This site is hosted statically on cloudflare. A small elixir/phoenix/tailwindCSS app parses through my markdown files and uploads them with wrangler. The code can be found on <a href="https://github.com/canaanmckenzie/elixir-ssg" class="underline dark:underline decoration-2">github</a>.</p>
    <p class="mb-4">The sitename xavaav.io is a rough transliteration of my first name written in Greek, \(\chi\alpha\nu\alpha\alpha\nu\).</p></div>
    <h2 class="text-bold text-4xl mb-12">reading list</h2>
    <ul class=" text-xl list-disc ml-12 italic">
    <li>The Complete Collection of H. P. Lovecraft (current)</li>
    <li>Razor Girl - Carl Hiaasen &starf;&starf;&starf;</li>
    <li>A Canticle for Leibowitz &starf;&starf;</li>
    <li>Le rouge et le noir - Stendhal &starf;&starf;</li>
    <li>Oryx and Crake - Margaret Atwood  &starf;&starf;&starf;&starf;</li>
    </ul>
    </div>
    </div>
    </.layout>
    """
  end
   # the book ratings
  defp stars(n) do
     String.duplicate(~s(&starf;), n)
   end

  # layout from phoenix
  def layout(assigns) do
    ~H"""
    <html lang="en">
    <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="A place to keep my writing">
    <title>Xavaav</title>
    <script src="https://polyfill.io/v3/polyfill.min.js?features=es6"></script>
    <script id="MathJax-script" async src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js"></script>
    <link rel="stylesheet" href="/assets/app.css"/>
    <link rel="stylesheet" href="/assets/theme.css"/>
    <!--<script type="text/javascript" src="/assets/app.js" />-->
    </head>
    <body class="text-2xl antialiased bg-white dark:bg-white dark:text-sumiBlack">
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
    render_file("about.html", about(%{posts: posts}))
    render_file("assets/theme.css",Makeup.stylesheet(:algol_style,"makeup")) #render code blocks

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
