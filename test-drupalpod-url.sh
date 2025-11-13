#!/bin/bash

# Quick test script to verify DrupalPod URL generation logic

# Test GitHub URL (replace with your actual repo)
GITHUB_REPO_URL="https://github.com/cellear/test-repo.git"

# Convert GitHub URL to branch format
DP_REPO_BRANCH="${GITHUB_REPO_URL%.git}/tree/main"

echo "Original GitHub URL: $GITHUB_REPO_URL"
echo "Branch format: $DP_REPO_BRANCH"

# URL-encode the DP_REPO_BRANCH parameter
ENCODED_REPO=$(echo "$DP_REPO_BRANCH" | sed 's/:/%3A/g; s/\//%2F/g; s/#/%23/g; s/?/%3F/g; s/&/%26/g')

echo "URL-encoded: $ENCODED_REPO"

# Construct DrupalPod URL
DRUPALPOD_URL="https://www.drupalforge.org/drupalpod?DP_APP_ROOT=/var/www/html&DP_WEB_ROOT=/var/www/html/web&DP_REPO_BRANCH=${ENCODED_REPO}&DP_IMAGE=drupalforge/drupalpod:latest"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Generated DrupalPod URL:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "$DRUPALPOD_URL"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Copy the URL above and paste it in your browser to test!"

