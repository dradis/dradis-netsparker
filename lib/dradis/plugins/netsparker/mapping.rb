module Dradis::Plugins::Netsparker
  module Mapping
    def self.default_mapping
      {
        'evidence' => {
          'URL' => '{{ netsparker[evidence.url] }}',
          'Request' => 'bc.. {{ netsparker[evidence.rawrequest] }}',
          'Response' => 'bc.. {{ netsparker[evidence.rawresponse] }}',
          'VulnerableParameter' => 'bc. {{ netsparker[evidence.vulnerableparameter] }}',
          'VulnerableParameterType' => 'bc. {{ netsparker[evidence.vulnerableparametertype] }}',
          'VulnerableParameterValue' => 'bc. {{ netsparker[evidence.vulnerableparametervalue] }}'
        },
        'issue' => {
          'Title' => '{{ netsparker[issue.title] }}',
          'Severity' => '{{ netsparker[issue.severity] }}',
          'Certainty' => '{{ netsparker[issue.certainty] }}',
          'Description' => '{{ netsparker[issue.description] }}',
          'Remedy' => '{{ netsparker[issue.remedy] }}'
        }
      }
    end
  end
end
