require 'middleman-core/cli'
require 'date'

module Middleman
  module Cli

    ##
    # This class provides an "release" command for the middleman CLI.
    #
    # @usage bundle exec middleman release --help
    # @usage bundle exec middleman release v3.1.4
    # @usage bundle exec middleman release v3.1.4  --date "2017-03-19 4:00pm EST" --edit
    #
    ##
    class Release < ::Thor::Group
      include Thor::Actions

      check_unknown_options!

      # Template files are relative to this file
      # @return [String]
      def self.source_root
        File.dirname( __FILE__ )
      end

      argument :tag, type: :string

      class_option "date",
      aliases: "-d",
      desc:    "The date to create the post with (defaults to now)"

      class_option "edit",
      aliases: "-e",
      desc:    "Edit the newly created software release",
      default: false,
      type:    :boolean

      def release
        @tag   = tag
        @date  = options[:date] ? ::Time.zone.parse(options[:date]) : Time.zone.now

        app = ::Middleman::Application.new do
          config[:mode]              = :config
          config[:disable_sitemap]   = true
          config[:watcher_disable]   = true
          config[:exit_before_ready] = true
        end

        releases_manager = app.extensions[:releases]

        release_dir_name       = @tag
        absolute_release_path = File.join( app.source_dir, releases_manager.options.releases_dir, release_dir_name, "index.html.markdown" )

        template releases_manager.options.new_release_template, absolute_release_path

        # Edit option process
        if options[ :edit ]
          editor = ENV.fetch('MM_EDITOR', ENV.fetch('EDITOR', nil ))

          if editor
            system( "#{ editor } #{ absolute_release_path }" )
          else
            throw "Could not find a suitable editor. Try setting the environment variable MM_EDITOR."
          end
        end
      end

      protected

      # Add to CLI
      Base.register(self, 'release', 'release TAG [options]', 'Create a new software release')
    end
  end
end
