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

      # @doc.xpath('/ScanGroup/Scan').each do |xml_scan|
      #   process_scan(xml_scan)
      # end

      return true
    end # /import

    private
  end
end