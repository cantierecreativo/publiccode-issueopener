require "dotenv/load"
require "Octokit"

puts "Initalizing..."

client = Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])
client.auto_paginate = true

user = client.user
puts "Using token from account \"#{user.login}\""

repos = File.readlines(ENV['REPOS_LIST']).each(&:chomp!)
puts "Number of repos with invalid publiccode: #{repos.size}"

repos.each do |repo|
  issues = client.issues(repo, query: {state: 'open'})
  puts "Open issues on \"#{repo}\": #{issues.length}"
end




