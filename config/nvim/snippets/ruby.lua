return {
  parse("rl", "also loaded!!")
}, {
  parse("autotrig", "autotriggered, if enabled")
}

-- snip({
--   trig = "rl",
--   namr = "Rails Logger",
--   dscr = "Write to the configured Rails log files"
-- },
--   {
--     text({ "Rails.logger.info '#' * 50", "Rails.logger.info '#' * 50" }), insert(1, "data"), text({ "Rails.logger.info '#' * 50" }) })
