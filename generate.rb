#! /usr/bin/env brew ruby
$LOAD_PATH.unshift *Tap.cmd_directories
require "dracula-yaml-json"
require_relative "curl_output"

branch = "035644d03a1d49f429e43415c0c95d3ff0d19904"
py = curl_output "https://raw.githubusercontent.com/dracula/pygments/#{branch}/dracula.py"

i = py.stdout.lines.index "class DraculaStyle(Style):\n"
content = py.stdout.lines[i+1..].join
                   .tr("=", ":")
                   .gsub(/([.\w]+)\s*([=:])/, '"\1"\2')
                   .gsub(/"$/, '",')
                   .gsub(/",(\n\s*})/m, '"\1')

pygments = JSON.parse("{#{content}}").with_indifferent_access
pygments.deep_transform_values! { |value| value.to_s.sub(/\h{3,6}/) { $&.upcase }}

Homebrew.dracula_yaml_json do |theme, (*, value)|
  theme[:identifier] = theme[:name]
  theme[:syntaxColors] = pygments[:styles]
  value.deep_transform_values!(&:to_s) if value.is_a? Hash
  next theme
end
