#!/usr/bin/env bash

#############################
# Author: B M Prajwal
# Date: 11th Jan, 2025
# Version: v1
# Description: This script will list the collaborators of repository
#############################

# Github URL
API_URL="https://api.github.com"

# Github username and token
USERNAME=$username
TOKEN=$token

# User and Repository information
REPO_OWNER=$1
REPO_NAME=$2

# function to make a GET request to the GitHub API
function github_api_get {
        local endpoint="$1"
        local url="${API_URL}/${endpoint}"

	# Send a GET request to the GitHub API with authentication
	curl -s -u "${USERNAME}:${TOKEN}" "$url"
}

# function to get the list of users with read access to the repository
function list_users_with_read_access {
	local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"

	# Fetch the list of collaborators on the repository
	collaborators="$(github_api_get "$endpoint" | jq -r '.[] | select(.permissions.pull == true) | .login' )"

	# Display the list of collaborators with the read access
	if [[ -z "$collaborators" ]]; then
		echo "No users with read access found for ${REPO_OWNER}/${REPO_NAME}"
	else
		echo "Users with read access to ${REPO_OWNER}/${REPO_NAME}"
		echo "$collaborators"
	fi
}

# Main Script
echo "Listing users with read access to ${REPO_OWNER}/${REPO_NAME}"
list_users_with_read_access
