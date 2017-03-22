module Releases
  class Instance
    attr_accessor :controller, :resource, :tag

    def self.from(resource, controller)
      tag = resource.data[:tag]

      new(controller, resource, tag: tag)
    end

    def initialize(controller, resource, attributes = {})
      @controller = controller
      @resource = resource

      attributes.each do |key, value|
        self.public_send("#{ key }=", value)
      end
    end

    def title
      resource.data[:title].presence || tag
    end

    def body
      resource.render(layout: false)
    end

    def date
      return @_date if @_date

      frontmatter_date = resource.data['date']

      # First get the date from frontmatter
      if frontmatter_date.is_a? Time
        @_date = frontmatter_date.in_time_zone
      else
        @_date = Time.zone.parse(frontmatter_date.to_s)
      end

      @_date
    end
  end
end
