# frozen_string_literal: true

class Views::Layouts::Sidebar::Event < Views::Base
  def view_template(&block)
    div(class: "flex min-h-screen bg-background") do
      aside(class: "w-64 border-r border-border flex flex-col shrink-0") do
        render_logo
        render_nav
        render_footer
      end
      div(class: "flex-1 overflow-auto p-8") { yield }
    end
  end

  private

  def render_logo
    div(class: "p-4 border-b border-border") do
      a(href: root_path, class: "flex items-center gap-2 text-foreground no-underline") do
        div(class: "h-8 w-8 rounded-full bg-primary flex items-center justify-center text-primary-foreground font-bold") { "W" }
        span(class: "font-semibold") { "Wed Club" }
      end
      if current_event
        p(class: "mt-2 text-xs text-muted-foreground truncate") { current_event.title }
      end
    end
  end

  def render_nav
    nav(class: "flex-1 p-3 space-y-1") do
      p(class: "px-3 pt-2 pb-1 text-xs font-medium text-muted-foreground uppercase tracking-wider") { "Event" }

      if current_event
        nav_link(href: event_path(current_event), label: "Overview", exact: true)
      end
      nav_link(href: guests_path, label: "Guests")
      nav_link(href: guest_categories_path, label: "Guest Categories")

      Separator(class: "my-3")

      p(class: "px-3 pb-1 text-xs font-medium text-muted-foreground uppercase tracking-wider") { "Account" }

      nav_link(href: events_path, label: "Switch Event")
    end
  end

  def render_footer
    div(class: "p-3 border-t border-border") do
      div(class: "flex items-center gap-2 px-2 mb-2") do
        Avatar(size: :sm) do
          AvatarFallback { current_user&.first_name&.first&.upcase }
        end
        span(class: "text-sm font-medium truncate") { current_user&.first_name }
      end
      Form(action: destroy_user_session_path, method: :post, class: "w-full") do
        input(type: :hidden, name: "authenticity_token", value: form_authenticity_token, autocomplete: "off")
        input(type: :hidden, name: "_method", value: "delete")
        Button(type: :submit, variant: :ghost, size: :sm, class: "w-full justify-start text-muted-foreground") { "Sign Out" }
      end
    end
  end

  def nav_link(href:, label:, exact: false)
    current = if exact
      request.path == href
    else
      request.path == href || request.path.start_with?("#{href}/")
    end
    classes = "flex items-center px-3 py-2 text-sm rounded-md no-underline transition-colors "
    classes += if current
      "bg-accent text-accent-foreground font-medium"
    else
      "text-muted-foreground hover:bg-accent/50 hover:text-foreground"
    end
    a(href: href, class: classes) { label }
  end
end
