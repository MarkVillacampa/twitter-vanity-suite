def usage
  caller_file = caller_locations.map(&:absolute_path).find { |path| path != __FILE__ }
  lines = File.readlines(caller_file).take_while { |line| line[0] == "#" }
  lines.shift # get rid of the shebang
  lines.map! { |line| line[2..-1] }
  puts lines
end

def usage!
  usage
  exit false
end

usage! if ARGV.empty?

gem "twitter", "~> 7.0"
require "twitter"
require "yaml"

config = YAML.load_file(".twitter-api-creds")

$client = Twitter::REST::Client.new do |twitter|
  twitter.consumer_key        = config["consumer_key"]
  twitter.consumer_secret     = config["consumer_secret"]
  twitter.access_token        = config["access_token"]
  twitter.access_token_secret = config["access_token_secret"]
  if ENV["DEBUG"] == 1
  twitter.proxy               = { host: "127.0.0.1", port: 8888 }
  end
end
