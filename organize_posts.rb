#!/usr/bin/env ruby

require 'fileutils'
require 'yaml'

# Directory containing posts
POSTS_DIR = '_posts'

# Create year directories if they don't exist
def create_year_dirs
  # Get all markdown files
  posts = Dir.glob(File.join(POSTS_DIR, '*.{md,markdown}'))

  # Extract years from filenames and create unique directories
  years = posts.map { |post| post.match(/(\d{4})-\d{2}-\d{2}/)[1] }.uniq

  years.each do |year|
    year_dir = File.join(POSTS_DIR, year)
    FileUtils.mkdir_p(year_dir) unless Dir.exist?(year_dir)
  end

  years
end

# Move files to their respective year directories
def organize_files
  posts = Dir.glob(File.join(POSTS_DIR, '*.{md,markdown}'))

  posts.each do |post|
    if match = post.match(/(\d{4})-\d{2}-\d{2}/)
      year = match[1]
      filename = File.basename(post)
      target_dir = File.join(POSTS_DIR, year)
      target_path = File.join(target_dir, filename)

      # Move file if it's not already in the correct directory
      if File.dirname(post) != target_dir
        puts "Moving #{filename} to #{target_dir}"
        FileUtils.mv(post, target_path)
      end
    end
  end
end

# Main execution
begin
  puts "Creating year directories..."
  years = create_year_dirs
  puts "Created directories for years: #{years.join(', ')}"

  puts "\nOrganizing files..."
  organize_files
  puts "Files organized successfully!"
rescue => e
  puts "Error: #{e.message}"
  exit 1
end