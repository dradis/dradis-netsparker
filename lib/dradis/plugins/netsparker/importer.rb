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

      @doc.xpath('/netsparker/vulnerability').each do |xml_vuln|
        process_vulnerability(xml_vuln)
      end

      return true
    end # /import

    private
    def process_vulnerability(xml_vuln)
      type = xml_vuln.at_xpath('./type').text()

      logger.info{ "\t\t => Creating new issue (type: #{type})" }

      issue_text = template_service.process_template(template: 'issue', data: xml_vuln)
      issue = content_service.create_issue(text: issue_text, id: type + rand(3).to_s)
    end
  end
end
