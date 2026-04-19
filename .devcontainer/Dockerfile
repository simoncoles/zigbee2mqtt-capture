# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=3.4.9
FROM ghcr.io/rails/devcontainer/images/ruby:$RUBY_VERSION

# Note: npm packages are installed via postCreateCommand in devcontainer.json
# because npm is available only after the Node.js feature is installed
