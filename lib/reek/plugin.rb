require 'reek'

module Danger
  # This is your plugin class. Any attributes or methods you expose here will
  # be available from within your Dangerfile.
  #
  # To be published on the Danger plugins site, you will need to have
  # the public interface documented. Danger uses [YARD](http://yardoc.org/)
  # for generating documentation from your plugin source, and you can verify
  # by running `danger plugins lint` or `bundle exec rake spec`.
  #
  # You should replace these comments with a public description of your library.
  #
  # @example Ensure people are well warned about merging on Mondays
  #
  #          my_plugin.warn_on_mondays
  #
  # @see  blooper05/danger-reek
  # @tags monday, weekends, time, rattata
  #
  class DangerReek < Plugin
    # A method that you can call from your Dangerfile
    # @return   [Array<String>]
    #
    def lint
      files_to_lint = fetch_files_to_lint
      code_smells   = run_linter(files_to_lint)
      warn_each_line(code_smells)
    end

    private

    def run_linter(files_to_lint)
      files_to_lint.flat_map do |file|
        examiner = ::Reek::Examiner.new(file)
        examiner.smells
      end
    end

    def fetch_files_to_lint
      files = git.modified_files + git.added_files
      Array(files.map { |file| Pathname(file) })
    end

    def warn_each_line(code_smells)
      code_smells.each do |smell|
        smell.lines.each do |line|
          warn(smell.message, file: smell.source, line: line)
        end
      end
    end
  end
end
