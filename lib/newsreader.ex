defmodule Newsreader do
  @moduledoc """
  Documentation for Newsreader.
  """

  @sources [
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

  def get_atom_feeds() do
    @sources
    |> Task.async_stream(&Mojito.get/1)
    |> Enum.into([], fn {:ok, res} -> res end)
  end

  def run do
    IO.puts("fetching news sources for you...")
    feeds = get_atom_feeds()
    IO.inspect(feeds)
  end
end
