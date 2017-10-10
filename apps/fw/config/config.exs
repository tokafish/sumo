# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Customize the firmware. Uncomment all or parts of the following
# to add files to the root filesystem or modify the firmware
# archive.

# config :nerves, :firmware,
#   rootfs_additions: "config/rootfs_additions",
#   fwup_conf: "config/fwup.conf"

# Import target specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
# Uncomment to use target specific configurations

# import_config "#{Mix.Project.config[:target]}.exs"

config :nerves_network, regulatory_domain: "US"

config :ui, Ui.Endpoint,
  http: [port: 80],
  url: [host: "localhost", port: 80],
  secret_key_base: "1az3kt9RcTWrukpvKMZ92JP6yn3SIMGFdFWnJJkRuljY3rq1YlEDjDSa2DqbnF0m",
  root: Path.dirname(__DIR__),
  server: true,
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: Nerves.PubSub],
  code_reloader: false

config :logger, level: :info

config :bootloader,
  init: [:nerves_runtime, :nerves_network],
  app: :fw

key_mgmt = System.get_env("NERVES_NETWORK_KEY_MGMT") || "WPA-PSK"

config :nerves_network, :default,
  wlan0: [
    ssid: System.get_env("NERVES_NETWORK_SSID"),
    psk: System.get_env("NERVES_NETWORK_PSK"),
    key_mgmt: String.to_atom(key_mgmt)
  ]

config :nerves_firmware_ssh,
  authorized_keys: [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDEVZHqJ9jssPD6bf+D+3iWk7Ww2dAKwBleXsizxtnYuF9uqBz+vlfe4m9o71C5EsxHOFhpyf56gSclQgn+2n2dxhi7XufDztCVLLN4WGrV1l2lUdI3btt45W6t3myit5rcznO7pPxwMNNn+4basqWZK3pP0sT0U2CiYEQvhaQ3QceDsUHkYi7dhJ3d5qftrMYttKo5NoayctDZ1LlM/aN3q7x7NcRpkdgzrkBCAajc4b0hjwJ2qLmTAmafhYTXgJiGsOh0H1XfGZqHJBnlIIHQLu3PBCBdudjLvStcmo8Vw7tMLypPBtPjmVVOwrKI3XK5EUPs/X0iMiuHIf1FEsWn tfisher@tfisher-mbp.corp.dropbox.com"
  ]
