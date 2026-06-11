source "https://rubygems.org"

gem "fastlane"

plugins_path = File.join(File.dirname(__FILE__), "fastlane", "Pluginfile")
eval_string = File.read(plugins_path) if File.exist?(plugins_path)
eval(eval_string) if eval_string

gem "multi_json"