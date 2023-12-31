defmodule QuantNotes.Post do 
  @enforce_keys [:id, :author, :title, :body, :description, :tags, :date, :path]
  defstruct [:id, :author, :title, :body, :description, :tags, :date, :path]

  def build(filename, attrs, body) do
    path = Path.rootname(filename)
    [year, month_day_id] = path |> Path.split() |> Enum.take(-2) # add error handling here for robustness 
    path = path <> ".html"
    [month, day, id] = String.split(month_day_id,"-", parts: 3) # error handling for robustness 
    date = Date.from_iso8601!("#{year}-#{month}-#{day}")
    struct!(__MODULE__,[id: id, date: date, body: body, path: path] ++
    Map.to_list(attrs))
  end
end
