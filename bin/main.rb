#!/usr/bin/env ruby
require "bundler/setup"
require "dotenv/load"
require "octokit"
require "open3"

def open_issue(repo)
  puts "Openening Publiccode issue in the repo \"#{repo}\"..."

  api_url = "https://api.github.com/repos/#{repo}/contents/publiccode.yml"

  body = <<EOF
  The publiccode.yml file contained in the repo is not valid.
  You can try to fix it with the [editor](https://publiccode-editor.developers.italia.it/)
  Use the \"Upload\" button and paste this url:
  `#{api_url}`
EOF

  @client.create_issue(
    repo, 
    "[publiccode] There\'s a problem with the publiccode.yml file",
    body
  )
  puts "Issue created successfully in the repo \"#{repo}\"..."
end

puts "Initalizing..."

@client = Octokit::Client.new(access_token: ENV["GITHUB_ACCESS_TOKEN"])
@client.auto_paginate = true

user = @client.user
puts "Using token from account \"#{user.login}\""

## Shameful hack FIXME - It seems Ruby is somehow unable to read files from
## filesystem when running this script inside Docker
stdout, stderr, status = Open3.capture3("cat #{ENV["REPOS_LIST"]}")
yaml_files = stdout.split(/[\r\n]+/).uniq!

## Method 1, not working in Docker
# yaml_files = File.readlines(ENV["REPOS_LIST"]).each(&:chomp!)

## Method 2, not working in Docker
# file = File.open(ENV["REPOS_LIST"], "r")
# yaml_files = file.read.split(/[\r\n]+/)

puts "Bad yaml files got from list: #{yaml_files.inspect}"

if yaml_files != nil
  yaml_files.each do |yaml_file|
    repo = yaml_file.split("/")[3,2].join("/")
    begin
      issues = @client.issues(repo, query: {state: 'open', creator: user.login})
    
      if issues.any? {|issue| issue.title.include?("[publiccode]") }
        puts "Open Publiccode issue already present in the repo \"#{repo}\""
      else
        open_issue(repo)
      end
  
    rescue StandardError => e
      puts "------------ Error with repo \"#{repo}\": ------------"
      puts e.message
      puts e.backtrace.join("\n")
      puts "------------------------------------------------------"
    end
  end
end

puts "Truncating bad yaml list file"
system "truncate -s 0 #{ENV["REPOS_LIST"]}"

