module Releases
  class Extension < ::Middleman::Extension
    option :layout, 'release', 'Layout for rendering an individual release'
    option :releases_dir, 'releases', 'Directory containing releases'

    expose_to_template :releases, :latest_release

    def initialize(app, options_hash={}, &block)
      super
    end

    def after_configuration
      @_releases = []
    end

    def releases
      @_releases.sort_by(&:date).reverse
    end

    def latest_release
      releases.first
    end

    def manipulate_resource_list(resources)
      @_releases = []

      resources.each do |resource|
        if resource.path =~ %r{#{options[:releases_dir]}\/v.*\/index\.html}
          layout = resource.metadata[:options].fetch(:layout, options[:layout]).to_s
          resource.add_metadata(options: { layout: layout })

          @_releases << Instance.from(resource, self)
        end
      end

      resources + [ latest_release_resource ]
    end

    helpers do
      def releases_controller
        app.extensions[:releases]
      end

      def current_release
        Releases::Instance.from(current_resource, self)
      end
    end

    private

    def latest_release_resource
      return unless latest_release

      Middleman::Sitemap::ProxyResource.new(app.sitemap, "#{ options[:releases_dir] }/latest/index.html", latest_release.path).tap do |p|
        layout = options[:layout].to_s
        p.add_metadata(options: { layout: layout })
      end
    end
  end
end
