# danger-reek

[![Build Status](https://img.shields.io/travis/blooper05/danger-reek.svg?longCache=true&style=flat)](https://travis-ci.org/blooper05/danger-reek)
[![Dependency Status](https://img.shields.io/gemnasium/blooper05/danger-reek.svg?longCache=true&style=flat)](https://gemnasium.com/blooper05/danger-reek)
[![Code Climate](https://img.shields.io/codeclimate/maintainability/blooper05/danger-reek.svg?longCache=true&style=flat)](https://codeclimate.com/github/blooper05/danger-reek)
[![Coverage](https://img.shields.io/codeclimate/c/blooper05/danger-reek.svg?longCache=true&style=flat)](https://codeclimate.com/github/blooper05/danger-reek)
[![Gem Version](https://img.shields.io/gem/v/danger-reek.svg?longCache=true&style=flat)](https://rubygems.org/gems/danger-reek)
[![License](https://img.shields.io/github/license/blooper05/danger-reek.svg?longCache=true&style=flat)](https://github.com/blooper05/danger-reek/blob/master/LICENSE)

A [Danger](https://rubygems.org/gems/danger) plugin for [Reek](https://rubygems.org/gems/reek).

## Installation

    $ gem install danger-reek

## Usage

### reek

Lints Ruby files via [Reek](https://rubygems.org/gems/reek).
Results are sent as inline comments.

<blockquote>Running Reek
  <pre>
# Runs Reek on modified and added files in the PR
reek.lint</pre>
</blockquote>

#### Methods

`lint` - Runs Ruby files through Reek.

## Development

1. Clone this repo
2. Run `bundle install` to setup dependencies.
3. Run `bundle exec rake spec` to run the tests.
4. Use `bundle exec guard` to automatically have tests run as you make changes.
5. Make your changes.
