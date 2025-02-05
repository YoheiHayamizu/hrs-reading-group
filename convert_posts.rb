#!/usr/bin/env ruby

require 'yaml'
require 'date'

def format_date(date_value)
  return nil if date_value.nil?
  if date_value.is_a?(Time) || date_value.is_a?(Date)
    date_value.strftime('%Y-%m-%d %H:%M:%S %z')
  else
    date_value.to_s  # If it's already a string, just return it
  end
end

def process_post(file_path)
  content = File.read(file_path)

  # Split front matter and body
  if content =~ /\A(---\s*\n.*?\n?)^(---\s*$\n?)/m
    front_matter = $1
    body = content[$1.length + $2.length..-1]

    # Parse YAML with date handling
    yaml_data = YAML.load(front_matter, permitted_classes: [Date, Time])

    # Convert dates to strings safely
    yaml_data['date'] = format_date(yaml_data['date']) if yaml_data['date']
    yaml_data['published'] = format_date(yaml_data['published']) if yaml_data['published']
    # title should be string that has double quotes
    yaml_data['title'] = yaml_data['title'].to_s

    # Create new front matter
    new_front_matter = yaml_data.to_yaml

    # Combine front matter and body
    new_content = "#{new_front_matter}---\n#{body}"

    # Write back to file
    File.write(file_path, new_content)
    puts "Processed: #{file_path}"
  end
rescue => e
  puts "Error processing #{file_path}: #{e.message}"
  puts e.backtrace
end

# Process all markdown files in _posts directory
Dir.glob('_posts/*.{md,markdown}') do |post_file|
  process_post(post_file)
end