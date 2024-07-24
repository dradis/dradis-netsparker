module Dradis::Plugins::Netsparker
  module Mapping
    DEFAULT_MAPPING = {
      evidence: {
        'ExtraInformation' => '{{ netsparker[evidence.extrainformation] }}',
        'URL' => '{{ netsparker[evidence.url] }}',
        'Request' => 'bc.. {{ netsparker[evidence.rawrequest] }}',
        'Response' => 'bc.. {{ netsparker[evidence.rawresponse] }}',
        'VulnerableParameter' => 'bc. {{ netsparker[evidence.vulnerableparameter] }}',
        'VulnerableParameterType' => 'bc. {{ netsparker[evidence.vulnerableparametertype] }}',
        'VulnerableParameterValue' => 'bc. {{ netsparker[evidence.vulnerableparametervalue] }}'
      },
      issue: {
        'Title' => '{{ netsparker[issue.title] }}',
        'Severity' => '{{ netsparker[issue.severity] }}',
        'Certainty' => '{{ netsparker[issue.certainty] }}',
        'Description' => '{{ netsparker[issue.description] }}',
        'Remedy' => '{{ netsparker[issue.remedy] }}'
      }
    }.freeze

    SOURCE_FIELDS = {
      evidence: [
        'evidence.extrainformation',
        'evidence.rawrequest',
        'evidence.rawresponse',
        'evidence.url',
        'evidence.vulnerableparameter',
        'evidence.vulnerableparametertype',
        'evidence.vulnerableparametervalue'
      ],
      issue: [
        'issue.actions_to_take',
        'issue.certainty',
        'issue.classification_asvs40',
        'issue.classification_capec',
        'issue.classification_cvss_vector',
        'issue.classification_cvss_base_value',
        'issue.classification_cvss_base_severity',
        'issue.classification_cvss_environmental_value',
        'issue.classification_cvss_environmental_severity',
        'issue.classification_cvss_temporal_value',
        'issue.classification_cvss_temporal_severity',
        'issue.classification_cwe',
        'issue.classification_disastig',
        'issue.classification_hipaa',
        'issue.classification_iso27001',
        'issue.classification_nistsp80053',
        'issue.classification_owasp2013',
        'issue.classification_owasp2017',
        'issue.classification_owasp2021',
        'issue.classification_owasppc',
        'issue.classification_pci31',
        'issue.classification_pci32',
        'issue.classification_wasc',
        'issue.description',
        'issue.external_references',
        'issue.extrainformation',
        'issue.impact',
        'issue.knownvulnerabilities',
        'issue.remedy',
        'issue.remedy_references',
        'issue.required_skills_for_exploitation',
        'issue.severity',
        'issue.title',
        'issue.type'
      ]
    }.freeze
  end
end
