require 'rails_helper'
require 'ostruct'

require File.expand_path('../../../dradis-plugins/spec/support/spec_macros.rb', __FILE__)

include Dradis::Plugins::SpecMacros

module Dradis::Plugins
  describe 'Netsparker upload plugin' do
    before(:each) do
      @fixtures_dir = File.expand_path('../fixtures/files/', __FILE__)

      stub_content_service(Dradis::Plugins::Netsparker)

      @importer = Dradis::Plugins::Netsparker::Importer.new(
        content_service: @content_service
      )
    end

    it 'creates the expected Node, Issue, and Evidence from the example file' do
      expect(@content_service).to receive(:create_node).with(hash_including label: 'localhost', type: :host)

      expect(@content_service).to receive(:create_issue) do |args|
        expect(args[:text]).to include('All sensitive data should be transferred over HTTPS rather than HTTP')
        expect(args[:id]).to eq('PasswordOverHttp')
        OpenStruct.new(args)
      end

      expect(@content_service).to receive(:create_evidence) do |args|
        expect(args[:content]).to include("#[Request]#\nbc.. GET /login HTTP/1.1")
        expect(args[:issue].id).to eq('PasswordOverHttp')
        expect(args[:node].label).to eq('localhost')
      end

      @importer.import(file: @fixtures_dir + '/example.xml')
    end

    it 'creates than one instance of Evidence for a single Issue' do
      expect(@content_service).to receive(:create_node).with(hash_including label: 'snorby.org', type: :host)

      expect(@content_service).to receive(:create_issue) do |args|
        expect(args[:text]).to include("#[Severity]#\nInformation")
        expect(args[:id]).to eq('EmailDisclosure')
        OpenStruct.new(args)
      end

      expect(@content_service).to receive(:create_evidence) do |args|
        expect(args[:content]).to include("#[URL]#\nhttps://snorby.org/foo")
        expect(args[:issue].id).to eq('EmailDisclosure')
        expect(args[:node].label).to eq('snorby.org')
      end.once

      expect(@content_service).to receive(:create_evidence) do |args|
        expect(args[:content]).to include("#[URL]#\nhttps://snorby.org/bar")
        expect(args[:issue].id).to eq('EmailDisclosure')
        expect(args[:node].label).to eq('snorby.org')
      end.once

      @importer.import(file: @fixtures_dir + '/example-evidence.xml')
    end

    it 'creates multiple nodes for additional websites' do
      expect(@content_service).to receive(:create_node).with(hash_including label: 'snorby.org', type: :host)
      expect(@content_service).to receive(:create_node).with(hash_including label: 'example.com', type: :host)

      @importer.import(file: @fixtures_dir + '/multiple-nodes.xml')
    end
  end
end
