#!/usr/bin/env ruby
#
# Script sets the GitHub busy status to "On vacation" with the specified expiration date.
# Usage: ./set-github-status.rb 2024-06-14
# Get new emojis by inspecting them in the GitHub emoji picker.
#

require 'date'
require 'json'
require 'net/http'

def get_expiration_date
  begin
    expires_at_input = Date.parse(ARGV[0].chomp)
  rescue ArgumentError
    puts "Provide your busy status expiration, the day you're back to work, as an argument in the format YYYY-MM-DD."
    exit
  end

  puts "You have entered the date as: #{expires_at_input}. Is this correct? (yes/no)"
  confirmation = STDIN.gets.chomp.downcase

  if confirmation != 'yes'
    puts "Re-run the script with the correct date."
    exit
  end

  expires_at_input
end

def get_github_access_token
  gh_access_token = `op read "op://Private/GitHub - Profile/credential"`.chomp
  if gh_access_token.empty?
    puts "Failed to retrieve GitHub access token."
    exit
  end
  gh_access_token
end

def set_github_status(expires_at, gh_access_token)
  expires_at = "#{expires_at}T00:00:00Z"

  query = {
    query: 'mutation ($status: ChangeUserStatusInput!) { changeUserStatus(input: $status) { clientMutationId } }',
    variables: {
      status: {
        message: 'On vacation',
        emoji: ':beach_umbrella:',
        limitedAvailability: true,
        expiresAt: expires_at
      }
    }
  }.to_json

  http = Net::HTTP.new('api.github.com', 443)
  http.use_ssl = true

  request = Net::HTTP::Post.new('/graphql', {
    'Authorization' => "bearer #{gh_access_token}",
    'Content-Type' => 'application/json'
  })
  request.body = query

  begin
    response = http.request(request)
    puts response.code == '200' ? "GitHub status updated successfully." : "GitHub status update failed with error code: #{response.code}"
  rescue => e
    puts "An error occurred while updating the GitHub status: #{e.message}"
  end
end

expires_at = get_expiration_date
gh_access_token = get_github_access_token
set_github_status(expires_at, gh_access_token)
