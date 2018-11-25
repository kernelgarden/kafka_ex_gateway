# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure your application as:
#
#     config :publish_service, key: :value
#
# and access this configuration in your application as:
#
#     Application.get_env(:publish_service, :key)
#
# You can also configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env}.exs"

config :kafka_ex,
  brokers: [
    {"localhost", 9092}
  ],
  use_ssl: false,
  commit_threshold: 10,
  commit_interval: 100,
  sync_timeout: 10_000,
  kafka_version: "2.11.2"

config :kafka_ex_gateway,
  consumer_group_name: "publish_service",
  topic_name: "gate-test-03",
  service_name: "PUBLISH_SERVICE",
  service_id: "1",
  max_demand_per_handler: 50,
  max_gen_stage_buffer_size: 10_000,
  gen_stage_consumer_size: 10,
  partition: 0
