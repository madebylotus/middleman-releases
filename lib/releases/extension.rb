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

      resources + [ latest_release_resource ] + latest_release_asset_resources
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
        p.add_metadata(options: { layout: layout }, locals: { latest: true })
      end
    end

    def assets_for_release(release)
      dir = latest_release.path.gsub('index.html', '')

      app.sitemap.resources.select do |resource|
        resource.path.start_with?(dir) && !resource.path.end_with?('index.html')
      end
    end

    def latest_release_asset_resources
      return [] unless latest_release

      assets = assets_for_release(latest_release)
      assets.map do |asset|
        target = asset.path.gsub("/#{ latest_release.tag }/", '/latest/')
        Middleman::Sitemap::ProxyResource.new(app.sitemap, target, asset.path)
      end
    end
  end
end
