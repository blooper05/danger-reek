# frozen_string_literal: true

require 'reek'
require 'reek/cli/options'
require 'reek/source/source_locator'

module Danger
  # Lints Ruby files via [Reek](https://rubygems.org/gems/reek).
  # Results are sent as inline comments.
  #
  # @example Running Reek
  #
  #          # Runs Reek on modified and added files in the PR
  #          reek.lint
  #
  # @see  blooper05/danger-reek
  # @tags ruby, reek, lint
  class DangerReek < Plugin
    # Runs Ruby files through Reek.
    # @param   [Hash] config
    # @return [Array<Reek::SmellWarning, nil>]
    def lint(config = {})
      @force_exclusion = config[:force_exclusion] || false
      @configuration = ::Reek::Configuration::AppConfiguration.from_path(nil)
      files_to_lint = fetch_files_to_lint
      code_smells   = run_linter(files_to_lint)
      warn_each_line(code_smells)
    end

    private

    def run_linter(files_to_lint)
      files_to_lint.flat_map do |file|
        next if ignore_file?(file)

        examiner = ::Reek::Examiner.new(file, configuration: @configuration)
        examiner.smells
      end.compact
    end

    def fetch_files_to_lint
      files = git.modified_files + git.added_files
      ::Reek::Source::SourceLocator.new(files).sources
    end

    def warn_each_line(code_smells)
      code_smells.each do |smell|
        message = smell.message.capitalize
        source  = smell.source
        smell.lines.each do |line|
          warn(message, file: source, line: line)
        end
      end
    end

    def ignore_file?(file)
      if @force_exclusion
        file.ascend.any? do |ascendant|
          @configuration.path_excluded?(ascendant)
        end
      else
        @configuration.path_excluded?(file)
      end
    end
  end
end
