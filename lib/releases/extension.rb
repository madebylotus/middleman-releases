module Releases
  class Extension < ::Middleman::Extension
    option :layout, 'release', 'Layout for rendering an individual release'
    option :releases_dir, 'releases', 'Directory containing releases'

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
        if resource.path.match(%r{#{ options.releases_dir }/v.*\.html})
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

      def latest_release
        releases.first
      end
    end
  end
end
