# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Webradio is a Rails 8 application that aggregates web radio stations, displays currently playing tracks, and enriches track information via Spotify and ChatGPT APIs. Station metadata is sourced from radio-browser.info.

## Tech Stack

- **Ruby 3.2.9 / Rails 8.0.4** with PostgreSQL
- **Frontend:** HAML templates, Hotwire (Turbo + Stimulus), Bootstrap 5, esbuild
- **Background Jobs:** Solid Queue (runs in Puma process)
- **Caching:** Solid Cache (database-backed)
- **Deployment:** Kamal 2 with Docker
- **External APIs:** OpenAI (ChatGPT), Spotify (rspotify), radio-browser.info, RadioBox

## Common Commands

```bash
# Development
bin/dev                          # Start dev server (Rails + JS + CSS watchers)
bin/rails console                # Rails console

# Testing
bundle exec rspec                # Run all specs
bundle exec rspec spec/models/   # Run model specs
bundle exec rspec spec/services/stream_last_track_spec.rb  # Single file
bundle exec rspec spec/models/station_spec.rb:15           # Single line

# Linting
bundle exec rubocop              # RuboCop (rails-omakase style)
bundle exec rubocop -A           # Auto-correct
bundle exec haml-lint app/views/ # HAML linting
bundle exec brakeman             # Security scan

# Database
bin/rails db:setup               # Create + migrate + seed
bin/rails db:migrate             # Run migrations

# Deployment
kamal deploy                     # Deploy via Kamal
```

## Architecture

### Key Models

- **Station** (`app/models/station.rb`) - Core model for radio stations. Has `url`, `name`, stream metadata flags (`ignore_tracks_from_stream`, `change_track_info_order`), and optional `radiobox`/`browser_info_byuuid` identifiers for external APIs.
- **CurrentTrack** (`app/models/current_track.rb`) - Virtual model (ActiveModel, no database table) representing the currently playing track with `artist`, `title`, `played_at`, `source`.

### Service Objects

All services inherit from `BaseService` which provides `.call` and `.call!` class methods.

- **StreamLastTrack** - Extracts track info from stream ICY metadata or JSON stats endpoints
- **RadioboxLastTrack** - Fetches track info from RadioBox API
- **SpotifyTrack** - Looks up track on Spotify for enrichment
- **TrackInfoChatGPT** - Enriches track info via ChatGPT (model configurable via `CHAT_GPT_MODEL` env var)
- **BrowserInfoUpdater** - Syncs station data from radio-browser.info API
- **TrackSanitizer** - Cleans/normalizes track metadata

### Presenters

- **StationPresenter** (`app/presenters/station_presenter.rb`) - Wraps Station for view rendering. `StationPresenter.wrap(stations)` wraps collections.

### Routes Structure

Stations are the primary resource with nested routes for `current_tracks`, `track_infos`, `album_infos`, and `stream`.

## Testing

- **Framework:** RSpec with FactoryBot, Shoulda Matchers, Capybara
- **Coverage:** SimpleCov (runs locally, disabled in CI)
- **Conventions:** FactoryBot methods included globally, transactional fixtures enabled, spec type inferred from file location

## Environment Variables

Key env vars (managed via Kamal secrets + dotenv locally):
`OPENAI_ACCESS_TOKEN`, `CHAT_GPT_MODEL`, `LASTFM_API_KEY`, `SPOTIFY_CLIENT_ID`, `SPOTIFY_CLIENT_SECRET`, `ROLLBAR_ACCESS_TOKEN`, `DATABASE_HOST`, `DATABASE_PORT`
