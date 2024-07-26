module Dradis
  module Plugins
    module Netsparker
      # Returns the version of the currently loaded Netsparker as a <tt>Gem::Version</tt>
      def self.gem_version
        Gem::Version.new VERSION::STRING
      end

      module VERSION
        MAJOR = 4
        MINOR = 13
        TINY = 0
        PRE = nil

        STRING = [MAJOR, MINOR, TINY, PRE].compact.join(".")
      end
    end
  end
end
