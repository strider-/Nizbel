module Nizbel
  class ReleaseRegex < ActiveRecord::Base
    attr_accessible :active, :regex, :options, :description

    validate :good_regex

    def self.from_php_regex(php_regex_str)
      trailing_options = [/\/i?S?\s*$/, '']
      leading_slash = [/^\/\^/, '^']
      php_named_groups = [/\(\?P/, '(?']

      ReleaseRegex.new do |rr|
        rr.options = Regexp::IGNORECASE if php_regex_str.match(trailing_options[0])
        rr.regex = php_regex_str
                     .gsub(*trailing_options)
                     .gsub(*leading_slash)
                     .gsub(*php_named_groups)
      end
    end

    def to_regexp
      Regexp.new(self.regex, self.options) rescue nil
    end

    protected

    def good_regex
      errors.add(:regex, 'invalid expression!') if to_regexp.nil?
    end
  end
end