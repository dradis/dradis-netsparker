require 'spec_helper'
require 'ostruct'

module Dradis::Plugins
  describe 'Netsparker upload plugin' do
    before(:each) do
      # Stub template service
      templates_dir = File.expand_path('../../templates', __FILE__)
      expect_any_instance_of(TemplateService).to \
        receive(:default_templates_dir).and_return(templates_dir)

      plugin = Dradis::Plugins::Netsparker

      @content_service = Dradis::Plugins::ContentService::Base.new(
        logger: Logger.new(STDOUT),
        plugin: plugin
      )

      @importer = Dradis::Plugins::Netsparker::Importer.new(
        content_service: @content_service
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

    it "creates the expected Node, Issue, and Evidence from the example file" do
      expect(@content_service).to receive(:create_node).with(hash_including label: 'localhost', type: :host)

      expect(@content_service).to receive(:create_issue) do |args|
        expect(args[:text]).to include("#[Title]#\nPassword over http")
        expect(args[:id]).to eq("PasswordOverHttp")
        OpenStruct.new(args)
      end

      expect(@content_service).to receive(:create_evidence) do |args|
        expect(args[:content]).to include("#[Request]#\nbc.. GET /login HTTP/1.1")
        expect(args[:issue].id).to eq("PasswordOverHttp")
        expect(args[:node].label).to eq("localhost")
      end

      @importer.import(file: 'spec/fixtures/files/example.xml')
    end

    it "creates than one instance of Evidence for a single Issue" do
      expect(@content_service).to receive(:create_node).with(hash_including label: 'snorby.org', type: :host)

      expect(@content_service).to receive(:create_issue) do |args|
        expect(args[:text]).to include("#[Title]#\nEmail disclosure")
        expect(args[:id]).to eq("EmailDisclosure")
        OpenStruct.new(args)
      end

      expect(@content_service).to receive(:create_evidence) do |args|
        expect(args[:content]).to include("#[URL]#\nhttps://snorby.org/foo")
        expect(args[:issue].id).to eq("EmailDisclosure")
        expect(args[:node].label).to eq("snorby.org")
      end.once

      expect(@content_service).to receive(:create_evidence) do |args|
        expect(args[:content]).to include("#[URL]#\nhttps://snorby.org/bar")
        expect(args[:issue].id).to eq("EmailDisclosure")
        expect(args[:node].label).to eq("snorby.org")
      end.once

      @importer.import(file: 'spec/fixtures/files/example-evidence.xml')
    end

  end

end
