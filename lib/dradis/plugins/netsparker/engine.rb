module Dradis::Plugins::Netsparker
  class Engine < ::Rails::Engine
    isolate_namespace Dradis::Plugins::Netsparker

    include ::Dradis::Plugins::Base
    description 'Processes Netsparker XML format'
    provides :upload
  end
end
