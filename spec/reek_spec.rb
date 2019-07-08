# frozen_string_literal: true

require File.expand_path('spec_helper', __dir__)

module Danger
  describe Danger::DangerReek do
    it 'should be a plugin' do
      expect(Danger::DangerReek.new(nil)).to be_a Danger::Plugin
    end

    describe 'with Dangerfile' do
      let(:dangerfile) { testing_dangerfile }
      let(:reek)       { dangerfile.reek }

      describe '#lint' do
        subject { reek.lint }

        before { stubbings }
        before { subject }

        let(:changed_files) do
          git = reek.git
          expect(git).to receive(:modified_files).and_return(modified_files)
          expect(git).to receive(:added_files).and_return(added_files)
        end

        let(:status_reports)    { dangerfile.status_report[:warnings] }
        let(:violation_reports) { dangerfile.violation_report[:warnings] }

        let(:source_locator) do
          pathnames = (modified_files + added_files).map { |file| Pathname.new(file) }
          locator_double = double(::Reek::Source::SourceLocator, sources: pathnames)

          allow(::Reek::Source::SourceLocator).to receive(:new)
            .with(an_instance_of(Array),
                  configuration: an_instance_of(::Reek::Configuration::AppConfiguration))
            .and_return(locator_double)

          expect(locator_double).to receive(:sources)
        end

        context 'with changed files' do
          let(:modified_files) { %w(spec/fixtures/modified_file.rb) }
          let(:added_files)    { %w(spec/fixtures/added_file.rb) }

          context 'with code smells' do
            let(:stubbings) { source_locator && changed_files && code_smells }

            let(:code_smells) do
              linter = ::Reek::Examiner
              smells = [double('Code Smells', message: smell_message,
                                              source:  source,
                                              lines:   lines)]
              allow_any_instance_of(linter).to receive(:smells)
                .and_return(smells)
            end

            let(:smell_message) { 'smell message' }
            let(:source)        { 'path/to/file' }
            let(:lines)         { [123] }

            it 'returns warning reports' do
              message   = 'Smell message'
              violation = Violation.new(message, false, 'path/to/file', 123)
              expect(status_reports).to eq([message] * 2)
              expect(violation_reports).to eq([violation] * 2)
            end
          end

          context 'with no code smells' do
            let(:stubbings) { source_locator && changed_files }

            it 'returns no warning reports' do
              expect(status_reports).to be_empty
              expect(violation_reports).to be_empty
            end
          end
        end

        context 'with no changed files' do
          let(:stubbings)      { source_locator && changed_files }
          let(:modified_files) { [] }
          let(:added_files)    { [] }

          it 'returns no warning reports' do
            expect(status_reports).to be_empty
            expect(violation_reports).to be_empty
          end
        end
      end
    end
  end
end
