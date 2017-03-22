module Releases
  class Extension < ::Middleman::Extension
    def initialize(app, options_hash={}, &block)
      super
    end

    def after_configuration
      @_releases = []
    end

    def releases
      @_releases.sort_by(&:date).reverse
    end

    helpers do
      def releases_controller
        app.extensions[:releases]
      end

      def current_release
        Releases::Instance.from(current_resource)
      end
    end
  end
end
