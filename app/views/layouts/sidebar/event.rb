# frozen_string_literal: true

class Views::Layouts::Sidebar::Event < Views::Base
  def view_template(&block)
    SidebarWrapper(class: "h-svh") do
      Sidebar(collapsible: :icon) do
        SidebarHeader { render_logo }
        SidebarContent { render_nav }
        SidebarFooter { render_footer }
        SidebarRail()
      end
      SidebarInset(class: "overflow-auto p-8") do
        SidebarTrigger(class: "mb-4 -ml-1")
        render_flash
        yield
      end
    end
  end

  private

  def render_logo
    a(href: root_path, class: "flex items-center gap-2 text-sidebar-foreground no-underline") do
      div(class: "h-8 w-8 rounded-full bg-primary flex items-center justify-center text-primary-foreground font-bold shrink-0") { "W" }
      span(class: "font-semibold group-data-[collapsible=icon]:hidden") { "Wed Club" }
    end
    if current_event
      p(class: "text-xs text-sidebar-foreground/70 truncate px-2 group-data-[collapsible=icon]:hidden") { current_event.title }
    end
  end

  def render_nav
    SidebarGroup do
      SidebarGroupLabel { "Event" }
      SidebarGroupContent do
        SidebarMenu do
          if current_event
            SidebarMenuItem do
              SidebarMenuButton(as: :a, href: event_path(current_event), active: active_link?(event_path(current_event), exact: true)) do
                heroicon "squares-2x2", variant: :outline, options: { class: "size-4" }
                span { "Overview" }
              end
            end
          end
          SidebarMenuItem do
            SidebarMenuButton(as: :a, href: guests_path, active: active_link?(guests_path)) do
              heroicon "users", variant: :outline, options: { class: "size-4" }
              span { "Guests" }
            end
          end
          SidebarMenuItem do
            SidebarMenuButton(as: :a, href: guest_categories_path, active: active_link?(guest_categories_path)) do
              heroicon "tag", variant: :outline, options: { class: "size-4" }
              span { "Guest Categories" }
            end
          end
          SidebarMenuItem do
            SidebarMenuButton(as: :a, href: event_venues_path, active: active_link?(event_venues_path)) do
              heroicon "map-pin", variant: :outline, options: { class: "size-4" }
              span { "Venues" }
            end
          end
        end
      end
    end

    SidebarSeparator()

    SidebarGroup do
      SidebarGroupLabel { "Account" }
      SidebarGroupContent do
        SidebarMenu do
          SidebarMenuItem do
            SidebarMenuButton(as: :a, href: events_path, active: active_link?(events_path)) do
              heroicon "arrows-right-left", variant: :outline, options: { class: "size-4" }
              span { "Switch Event" }
            end
          end
        end
      end
    end
  end

  def render_footer
    div(class: "flex items-center gap-2 px-2 mb-2") do
      Avatar(size: :sm) do
        AvatarFallback { current_user&.first_name&.first&.upcase }
      end
      span(class: "text-sm font-medium truncate group-data-[collapsible=icon]:hidden") { current_user&.first_name }
    end
    Form(action: destroy_user_session_path, method: :post, class: "w-full group-data-[collapsible=icon]:hidden") do
      input(type: :hidden, name: "authenticity_token", value: form_authenticity_token, autocomplete: "off")
      input(type: :hidden, name: "_method", value: "delete")
      Button(type: :submit, variant: :ghost, size: :sm, class: "w-full justify-start text-muted-foreground") { "Sign Out" }
    end
  end

  def active_link?(href, exact: false)
    exact ? request.path == href : request.path == href || request.path.start_with?("#{href}/")
  end
end
