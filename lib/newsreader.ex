defmodule Newsreader do
  @moduledoc """
  Documentation for Newsreader.
  """

  def sources do 
      [
      "https://www.theguardian.com/world/rss",
      "https://www.heraldscotland.com/news/homenews/rss/",
      "http://www.independent.co.uk/news/world/rss",
      "https://www.aljazeera.com/xml/rss/all.xml",
      "https://www.haaretz.com/cmlink/1.4605102",
      "https://xkcd.com/atom.xml",
      "https://www.polygon.com/rss/index.xml",
      "https://feeds.reuters.com/reuters/topNews",
      "https://feeds.wired.com/wired/index",
      "https://www.lemonde.fr/rss/une.xml",
      "https://www.welt.de/feeds/latest.rss",
      "https://www.derstandard.at/rss",
      "http://feeds.washingtonpost.com/rss/world"
    ]
  end

  def proc_get_feed_body({parent, url}) do
    try do 
      {:ok, response} = Mojito.get(url)
      {:ok, rss} = FastRSS.parse(response.body)
      send(parent, {:ok, rss})
    rescue 
      e in MatchError ->
        send(parent, Tuple.append(e.term, url))
    end
  end

  def fetch_feeds_batch(sources) do
    Enum.map(sources, fn i -> 
      spawn(Newsreader, :proc_get_feed_body, [{self(), i}])
    end)
  end

  def aggrigate_feeds(feeds_list \\ []) do
    receive do
      {:ok, response} ->
        aggrigate_feeds([{:ok, response} | feeds_list])
      {:error, error, url} ->
        aggrigate_feeds([{:error, error, url}|feeds_list])
      {:error, error} ->
        aggrigate_feeds([{:error, :xmlhingy, error}|feeds_list])
      after 2_500 -> 
        {:ok, feeds_list}
    end
  end

  def run do
    IO.puts("fetching news sources for you...")
    fetch_feeds_batch(sources)
    IO.puts("got them. Processing now...")
    feeds = aggrigate_feeds
    # |> transform_add_paper_metadata_to_item
    # |> order_story_by_timestamp
    # |> beautify_output
    IO.inspect(feeds)
  end
end
