require "middleman-core"

Middleman::Extensions.register :releases do
  require 'releases/instance'
  require 'releases/extension'
  require 'releases/commands/release'

  Releases::Extension
end
