{application,bulls,
             [{applications,[kernel,stdlib,elixir,logger,runtime_tools,
                             phoenix,phoenix_html,phoenix_live_reload,
                             phoenix_live_dashboard,telemetry_metrics,
                             telemetry_poller,gettext,jason,plug_cowboy]},
              {description,"bulls"},
              {modules,['Elixir.Bulls','Elixir.Bulls.Application',
                        'Elixir.Bulls.Game','Elixir.BullsWeb',
                        'Elixir.BullsWeb.Endpoint',
                        'Elixir.BullsWeb.ErrorHelpers',
                        'Elixir.BullsWeb.ErrorView',
                        'Elixir.BullsWeb.GameChannel',
                        'Elixir.BullsWeb.Gettext',
                        'Elixir.BullsWeb.LayoutView',
                        'Elixir.BullsWeb.PageController',
                        'Elixir.BullsWeb.PageView','Elixir.BullsWeb.Router',
                        'Elixir.BullsWeb.Router.Helpers',
                        'Elixir.BullsWeb.Telemetry',
                        'Elixir.BullsWeb.UserSocket']},
              {registered,[]},
              {vsn,"0.1.0"},
              {mod,{'Elixir.Bulls.Application',[]}}]}.