module Dradis::Plugins::Netsparker
  class Engine < ::Rails::Engine
    isolate_namespace Dradis::Plugins::Netsparker

    include ::Dradis::Plugins::Base
    description 'Processes Netsparker XML format'
    provides :upload

    # Configuring the gem
    # class Configuration < Core::Configurator
    #   configure :namespace => 'burp'
    #   setting :category, :default => 'Burp Scanner output'
    #   setting :author, :default => 'Burp Scanner plugin'
    # end
  end
end
