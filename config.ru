# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)

use Rack::GoogleAnalytics, :tracker => 'UA-29670145-1'

$cache = Memcache.new
config.middleware.use Rack::Cache, :metastore => $cache, :entitystore => 'file:tmp/cache/entity'

run Dansledur::Application
