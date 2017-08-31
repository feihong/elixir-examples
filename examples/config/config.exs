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

config :examples, BusinessLicense,
  target_activities: [
    "Preparation of Food and Dining on Premise With Seating",
    "Sale of Food Prepared Onsite With Dining Area"
  ],
  target_neighborhoods: [
    "Bridgeport",
    "Chinatown"
  ],
  keywords: [
    "china",
    "chinese",
    "mandarin",
    "canton",
    "wah",
    "happiness",
    "phoenix",
    "dragon",
  ]

import_config "auth.exs"
