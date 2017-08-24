module Dradis::Plugins::Netsparker
  class Importer < Dradis::Plugins::Upload::Importer

    # The framework will call this function if the user selects this plugin from
    # the dropdown list and uploads a file.
    # @returns true if the operation was successful, false otherwise
    def import(params={})
      file_content    = File.read( params.fetch(:file) )

      logger.info{'Parsing Netsparker output file...'}
      @doc = Nokogiri::XML( file_content )
      logger.info{'Done.'}

      if @doc.xpath('/netsparker').empty?
        error = "No scan results were detected in the uploaded file (/netsparker). Ensure you uploaded an Netsparker XML report."
        logger.fatal{ error }
        content_service.create_note text: error
        return false
      end

      @doc.xpath('/netsparker/target').each do |xml_host|
        process_report_host(xml_host)
      end

      return true
    end # /import

    private

    def process_report_host(xml_host)
      # Create Nodes from the <url> tags
      host_node_label = xml_host.at_xpath('./url').text
      host_node_label = URI.parse(host_node_label).host rescue host_node_label
      logger.info{ "\t\t => Creating new host: #{host_node_label}" }
      host_node = content_service.create_node(label: host_node_label, type: :host)

      @doc.xpath('/netsparker/vulnerability').each do |xml_vuln|
        process_vuln(xml_vuln, host_node)
      end
      
    end

    def process_vuln(xml_vuln, host_node)
      type = xml_vuln.at_xpath('./type').text()

      # Create Issues using the Issue template
      logger.info{ "\t\t => Creating new Issue: #{type}" }

      issue_text = template_service.process_template(template: 'issue', data: xml_vuln)
      issue = content_service.create_issue(text: issue_text, id: type)

      # Create Evidence using the Evidence template
      # Associate the Evidence with the Node and Issue
      logger.info{ "\t\t => Creating new evidence" }
      evidence_content = template_service.process_template(
        template: 'evidence', data: xml_vuln
      )
      content_service.create_evidence(
        issue: issue, node: host_node, content: evidence_content
      )
    end

  end
end
