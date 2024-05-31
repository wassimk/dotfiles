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
  expires_at_input = Date.parse(ARGV[0].chomp) rescue nil
  unless expires_at_input
    puts "Provide the busy expiration, the day you're back to work, as an argument in the format YYYY-MM-DD. E.g., 2024-06-14"
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

def set_github_status(expires_at)
  gh_access_token = `op read "op://Private/GitHub - Profile/credential"`.chomp
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
set_github_status(expires_at)
