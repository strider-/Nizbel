require 'nizbel/engine'
require 'rails/generators/actions'

module Nizbel
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      include Rails::Generators::Actions

      def install_to_host_app
        config = Nizbel::Engine.config

        # add the route for the engine
        route("# Mount Nizbel at #{config.mount_at}\n  mount Nizbel::Engine, :at => '#{config.mount_at}'")
        # install the migrations to the host app
        rake("nizbel:install:migrations")
        # run the migrations, only for the engine
        rake("db:migrate SCOPE=nizbel")
        # seed the db for the engine
        Nizbel::Engine.load_seed
      end
    end
  end
end