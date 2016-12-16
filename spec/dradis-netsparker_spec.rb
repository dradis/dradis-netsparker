require 'spec_helper'
require 'ostruct'

module Dradis::Plugins
  describe 'Netsparker upload plugin' do
    before(:each) do
      # Stub template service
      templates_dir = File.expand_path('../../templates', __FILE__)
      allow_any_instance_of(TemplateService).to \
        receive(:default_templates_dir).and_return(templates_dir)

      @content_service = ContentService.new(plugin: Netsparker)
      template_service = TemplateService.new(plugin: Netsparker)

      @importer = Netsparker::Importer.new(
        content_service: @content_service,
        template_service: template_service
      )

      # Stub dradis-plugins methods
      #
      # They return their argument hashes as objects mimicking
      # Nodes, Issues, etc
      allow(@content_service).to receive(:create_node) do |args|
        OpenStruct.new(args)
      end
      allow(@content_service).to receive(:create_note) do |args|
        OpenStruct.new(args)
      end
      allow(@content_service).to receive(:create_issue) do |args|
        OpenStruct.new(args)
      end
      allow(@content_service).to receive(:create_evidence) do |args|
        OpenStruct.new(args)
      end
    end

    it "creates nodes, issues, notes and an evidences as needed" do
      pending
    end

  end
end
