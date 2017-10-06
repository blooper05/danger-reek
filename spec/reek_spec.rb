require File.expand_path('../spec_helper', __FILE__)

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

        context 'with changed files' do
          let(:modified_files) { [Pathname('spec/fixtures/modified_file.rb')] }
          let(:added_files)    { [Pathname('spec/fixtures/added_file.rb')] }

          context 'with code smells' do
            let(:stubbings) { changed_files && code_smells }

            let(:code_smells) do
              linter = ::Reek::Examiner
              args   = { message:     double('Message'),
                         source:      double('Source'),
                         lines:       [double('Line')] }
              smells = [double('Code Smells', args)]
              allow_any_instance_of(linter).to receive(:smells)
                .and_return(smells)
            end

            it 'returns warning reports' do
              expect(dangerfile.status_report[:warnings]).not_to be_empty
            end
          end

          context 'with no code smells' do
            let(:stubbings) { changed_files }

            it 'returns no warning reports' do
              expect(dangerfile.status_report[:warnings]).to be_empty
            end
          end
        end

        context 'with no changed files' do
          let(:stubbings)      { changed_files }
          let(:modified_files) { [] }
          let(:added_files)    { [] }

          it 'returns no warning reports' do
            expect(dangerfile.status_report[:warnings]).to be_empty
          end
        end
      end
    end
  end
end
