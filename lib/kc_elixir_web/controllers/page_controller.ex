defmodule KcElixirWeb.PageController do
  use KcElixirWeb, :controller

  @meetups [
    %{
      datetime: [
        ~N{2019-03-07 18:00:00},
        ~N{2019-03-07 20:00:00}
      ],
      image_url: "http://placekitten.com/200/200",
      topic: "Chemanalysis: Dialyzing Elixir",
      location: %{
        url: "https://goo.gl/maps/cYJFK7eXG362",
        address: "8500 Shawnee Mission Pkwy Mission, KS 66202",
        venue: "Company Kitchen"
      },
      description: """
      No one wants to ship bugs in a production system, especially embarrassing
      ones! Dialyzer is a post-compilation type-checker that has found more bugs
      in my code than I can count, saving me a lot of time and frustration. This
      talk will discuss briefly what Dialyzer is, how to use it in Elixir
      projects, and go in-depth on three bugs it helped me find in the Elixir
      compiler and standard library.
      """
    }
  ]

  def index(conn, _params) do
    render(conn, "index.html", meetups: Enum.map(@meetups, &englishify/1))
  end

  def englishify(meetup) do
    # [dt_from, dt_to] = meetup.datetime |> Enum.map(&DateTime.from_naive!(&1, "America/Chicago"))
    [dt_from, dt_to] = meetup.datetime |> Enum.map(&DateTime.from_naive!(&1, "Etc/UTC"))

    # TODO: exclude dates that in the past

    dt_from |> IO.inspect()

    from = Timex.format!(dt_from, "{WDfull}, {Mfull} {D}, {YYYY} - {h12}:{m} {AM}")
    to = Timex.format!(dt_to, "{h12}:{m} {AM}")

    meetup
    |> Map.merge(%{
      date_of: Timex.format!(dt_from, "{WDfull}, {Mfull} {D}, {YYYY}"),
      datetime_description: "#{from} to #{to}",
      location_description: "#{meetup.location.venue} - #{meetup.location.address}"
    })
  end
end
