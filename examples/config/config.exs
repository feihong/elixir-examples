# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :examples,
  keywords: [
    "china",
    "chinese",
    "taiwan",
    "hong kong",
    "mandarin",
    "cantonese",
    "chinatown"
  ]

config :examples, Facebook,
  pages: [
    "ChineseFineArts",
    "ccamuseum",
    "windmilldramaclub",
    "ChicagoChinatownChamberofCommerce",
    "siskelfilmcenter",
    "musicboxchicago",
    "sophiaschoicepresents",
    "faaimous",
    "chicagofilmfestival",
    "ChicagoCulturalCenter"
  ]

import_config "auth.exs"
