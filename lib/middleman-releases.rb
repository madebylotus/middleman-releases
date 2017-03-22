require "middleman-core"

Middleman::Extensions.register :releases do
  require 'releases/instance'
  require 'releases/extension'

  Releases::Extension
end
