module Dradis::Plugins::Netsparker
  # This processor defers to ::Netsparker::Vulnerability for the issue and
  # evidence templates.
  class FieldProcessor < Dradis::Plugins::Upload::FieldProcessor

    def post_initialize(args={})
      @netsparker_object = Netsparker::Vulnerability.new(data)
    end

    def value(args={})
      field = args[:field]

      # fields in the template are of the form <foo>.<field>, where <foo>
      # is common across all fields for a given template (and meaningless).
      _, name = field.split('.')

      @netsparker_object.try(name) || 'n/a'
    end
  end

end
