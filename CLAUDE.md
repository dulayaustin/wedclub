# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

**Setup:**
```bash
bin/setup          # Install deps, prepare DB, start dev server
bin/setup --reset  # Same but resets the database
```

**Development:**
```bash
bin/dev            # Start all processes (web server + Tailwind watcher)
```

**Testing:**
```bash
bundle exec rspec               # Run all tests
bundle exec rspec spec/models/  # Run a specific directory
bundle exec rspec spec/models/guest_spec.rb  # Run a single file
```

**Linting & Security:**
```bash
bin/rubocop           # Lint Ruby code (omakase style)
bin/brakeman          # Static security analysis
bin/bundler-audit     # Check gems for vulnerabilities
bin/importmap audit   # Check JS dependencies for vulnerabilities
```

## Architecture

**Stack:** Rails 8.1, PostgreSQL, Tailwind CSS, Hotwire (Turbo + Stimulus), importmap (no Node/bundler), Phlex views, RubyUI components.

**View layer (Phlex-based):** Views are Ruby classes, not ERB templates. The hierarchy is:
- `Components::Base < Phlex::HTML` — base for all components, includes `RubyUI` and route helpers
- `Views::Base < Components::Base` — base for all page views

All components live in `app/components/`. RubyUI components (buttons, forms, tables, badges, etc.) are in `app/components/ruby_ui/` and are auto-included in every component/view via `include RubyUI` in `Components::Base`.

**Background jobs/cache/cable:** All backed by PostgreSQL via `solid_queue`, `solid_cache`, `solid_cable` — no Redis needed.

**Testing:** RSpec with FactoryBot, Faker, Shoulda Matchers, and Capybara for system tests. Factories in `spec/factories/`.

**Deployment:** Kamal (Docker-based). Config in `config/deploy.yml`.
