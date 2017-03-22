module Releases
  class Extension < ::Middleman::Extension
    option :layout, 'release', 'Layout for rendering an individual release'

    def initialize(app, options_hash={}, &block)
      super
    end

    def after_configuration
      @_releases = []
    end

    def releases
      @_releases.sort_by(&:date).reverse
    end

    def manipulate_resource_list(resources)
      resources.each do |resource|
        if resource.path.start_with?('releases/')
          layout = resource.metadata[:options].fetch(:layout, options[:layout]).to_s
          resource.add_metadata(options: { layout: layout })

          @_releases << Instance.from(resource, self)
        end
      end
    end

    helpers do
      def releases_controller
        app.extensions[:releases]
      end

      def current_release
        Releases::Instance.from(current_resource, self)
      end
    end
  end
end
