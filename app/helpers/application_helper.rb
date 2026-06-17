module ApplicationHelper
  # Minimal inline SVG icon set (stroke-based, 24x24) so the UI has no external
  # icon dependency. Returns an html_safe <svg>.
  ICONS = {
    home: '<path d="M3 11l9-8 9 8"/><path d="M5 10v10h14V10"/>',
    flag: '<path d="M4 21V4"/><path d="M4 4h13l-2 4 2 4H4"/>',
    bolt: '<path d="M13 2L3 14h7l-1 8 10-12h-7z"/>',
    trophy: '<path d="M8 21h8"/><path d="M12 17v4"/><path d="M7 4h10v5a5 5 0 0 1-10 0z"/><path d="M5 5H3v2a3 3 0 0 0 3 3"/><path d="M19 5h2v2a3 3 0 0 1-3 3"/>',
    calendar: '<rect x="3" y="4" width="18" height="18" rx="3"/><path d="M3 10h18M8 2v4M16 2v4"/>',
    user: '<circle cx="12" cy="8" r="4"/><path d="M4 21a8 8 0 0 1 16 0"/>',
    ticket: '<path d="M3 9a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2 2 2 0 0 0 0 6 2 2 0 0 1-2 2H5a2 2 0 0 1-2-2 2 2 0 0 0 0-6z"/>',
    image: '<rect x="3" y="3" width="18" height="18" rx="3"/><circle cx="9" cy="9" r="2"/><path d="M21 15l-5-5L5 21"/>',
    pin: '<path d="M12 21s-7-6.3-7-11a7 7 0 0 1 14 0c0 4.7-7 11-7 11z"/><circle cx="12" cy="10" r="2.5"/>',
    cart: '<circle cx="9" cy="20" r="1.5"/><circle cx="18" cy="20" r="1.5"/><path d="M2 3h3l2.4 12.4a2 2 0 0 0 2 1.6h7.7a2 2 0 0 0 2-1.6L22 7H6"/>',
    chart: '<path d="M4 20V4"/><path d="M4 20h16"/><rect x="7" y="11" width="3" height="6"/><rect x="12" y="7" width="3" height="10"/><rect x="17" y="13" width="3" height="4"/>',
    clock: '<circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 2"/>',
    gauge: '<path d="M12 14l4-4"/><circle cx="12" cy="13" r="9"/><path d="M3 13a9 9 0 0 1 18 0"/>',
    cog: '<circle cx="12" cy="12" r="3"/><path d="M19 12a7 7 0 0 0-.1-1l2-1.5-2-3.4-2.3 1a7 7 0 0 0-1.7-1L14.5 2h-5l-.4 2.6a7 7 0 0 0-1.7 1l-2.3-1-2 3.4L3.1 11a7 7 0 0 0 0 2l-2 1.5 2 3.4 2.3-1a7 7 0 0 0 1.7 1l.4 2.6h5l.4-2.6a7 7 0 0 0 1.7-1l2.3 1 2-3.4-2-1.5a7 7 0 0 0 .1-1z"/>',
    plus: '<path d="M12 5v14M5 12h14"/>',
    menu: '<path d="M4 6h16M4 12h16M4 18h16"/>'
  }.freeze

  def icon(name, css: "h-6 w-6")
    body = ICONS[name.to_sym] || ICONS[:bolt]
    tag.svg(body.html_safe, class: css, viewBox: "0 0 24 24", fill: "none",
            stroke: "currentColor", "stroke-width": "1.7",
            "stroke-linecap": "round", "stroke-linejoin": "round")
  end

  def nav_active?(path)
    current_page?(path) || (path != root_path && request.path.start_with?(path))
  end

  def locale_switcher_options
    I18n.available_locales.map { |l| [l, t("locales.#{l}", default: l.to_s.upcase)] }
  end

  def money(cents, currency = nil)
    Money.new(cents.to_i, currency || Money.default_currency).format
  end
end
