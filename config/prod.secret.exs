use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or you later on).
config :phoenix_sample_ad_app, PhoenixSampleAdApp.Endpoint,
  secret_key_base: "0a5g8K2jwdGucVxf/OKzQociUgj1f84fypOpTFKZryQyuxchSuphPLmKhvv5YoAu"

# Configure your database
config :phoenix_sample_ad_app, PhoenixSampleAdApp.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "phoenix_sample_ad_app_prod",
  pool_size: 20

config :diver,
  zk: [quorum_spec: "localhost",
       base_path: "/hbase"],
  jvm_args: ["-Djava.awt.headless=true"]
