defmodule KcElixirWeb.PageController do
  use KcElixirWeb, :controller

  @meetups [
    %{
      datetime: [
        ~N{2020-04-02 18:00:00},
        ~N{2020-04-02 20:00:00}
      ],
      speaker: %{
        name: "Sean Cribbs"
      },
      topic: "TLA+",
      location: %{
        url: "",
        address: "",
        venue: ""
      },
      description: """
      Sean's presentation will start at 6:30pm.

      https://en.wikipedia.org/wiki/TLA%2B

      Please use the following to join.
      KC Elixir - April 2020
      Thursday, Apr 2, 2020 06:00 PM Central Time (US and Canada)

      https://zoom.us/j/808755034 / Meeting ID: 808 755 034

      One tap mobile
      +13126266799,,808755034# US (Chicago)
      +16465588656,,808755034# US (New York)Dial by your location
      +1 312 626 6799 US (Chicago)
      +1 646 558 8656 US (New York)
      +1 346 248 7799 US (Houston)
      +1 669 900 6833 US (San Jose)
      +1 253 215 8782 US
      +1 301 715 8592 US
      Meeting ID: 808 755 034

      Find your local number: https://zoom.us/u/acIuseHlXN
      You can join our group's Slack by going to http://kcelixir-slack.herokuapp.com/.
      """,
      sponsors: [
        %{ name: "Postmates", image: "postmates.png", url: "https://postmates.com" },
      ]
    }
  ]

  def index(conn, _params) do
    render(conn, "index.html", meetups: Enum.map(@meetups, &englishify/1))
  end

  def englishify(meetup) do
    # [dt_from, dt_to] = meetup.datetime |> Enum.map(&DateTime.from_naive!(&1, "America/Chicago"))
    [dt_from, dt_to] = meetup.datetime |> Enum.map(&DateTime.from_naive!(&1, "Etc/UTC"))

    # TODO: exclude dates from the past?

    # dt_from |> IO.inspect()

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
