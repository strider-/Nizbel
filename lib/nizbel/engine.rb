require 'jquery-rails'
require 'haml-rails'
require 'sass-rails'
require 'bootstrap-sass'

module Nizbel
  class Engine < ::Rails::Engine
    isolate_namespace Nizbel

    config.railties_order = [Nizbel::Engine, :main_app, :all]

    config.mount_at = '/nizbel'
    config.host = ''
    config.port = 0
    config.ssl = true
    config.username = ''
    config.password = ''
  end
end
