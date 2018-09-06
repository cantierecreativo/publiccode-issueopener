#!/usr/bin/env ruby
require "bundler/setup"
require "dotenv/load"
require "octokit"

def open_issue(repo)
  puts "Openening Publiccode issue in the repo \"#{repo}\"..."

  body = <<EOF
  We should decide what to put in here!
  Maybe the link to the editor/validator.
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

repos = File.readlines(ENV["REPOS_LIST"]).each(&:chomp!)
puts "Number of repos got from list: #{repos.size}"

repos.each do |repo|
  begin
    issues = @client.issues(repo, query: {state: 'open', creator: user.login})
    # puts "Open issues on \"#{repo}\": #{issues.length} from \"#{user.login}\""
  
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

