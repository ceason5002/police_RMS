module CadHelper
  def cad_nav_link(icon, label, path)
    active = current_page?(path) || request.path.start_with?(path.chomp("/"))
    bg     = active ? "rgba(99,91,255,0.25)" : "transparent"
    color  = active ? "white" : "rgba(255,255,255,0.65)"
    weight = active ? "600" : "500"
    content_tag(:a, href: path,
      style: "display:flex;align-items:center;gap:9px;padding:7px 10px;border-radius:6px;" \
             "text-decoration:none;font-size:13px;font-weight:#{weight};color:#{color};" \
             "background:#{bg};margin-bottom:2px;transition:background 0.15s;") do
      content_tag(:span, label)
    end
  end

  def priority_badge(priority)
    labels = { 1 => "P1", 2 => "P2", 3 => "P3", 4 => "P4", 5 => "P5" }
    css    = {
      1 => "background:#DF1B41;color:#fff",
      2 => "background:#F97316;color:#fff",
      3 => "background:#EAB308;color:#000",
      4 => "background:#3B82F6;color:#fff",
      5 => "background:#8898AA;color:#fff"
    }
    content_tag(:span, labels[priority] || priority,
      class: "badge",
      style: "#{css[priority]};min-width:32px;justify-content:center;font-weight:700;")
  end

  def call_status_badge(status)
    css = {
      "Pending"    => "badge-yellow",
      "Dispatched" => "badge-blue",
      "On Scene"   => "badge-purple",
      "Cleared"    => "badge-green"
    }
    content_tag(:span, status, class: "badge #{css[status] || 'badge-gray'}")
  end

  def unit_status_badge(status)
    content_tag(:span, status, class: "badge #{CadUnit.new(status: status).status_badge_class}")
  end

  def bolo_status_badge(bolo)
    content_tag(:span, bolo.status, class: "badge #{bolo.status_badge_class}")
  end

  def priority_row_style(priority)
    border_colors = {
      1 => "#DF1B41",
      2 => "#F97316",
      3 => "#EAB308",
      4 => "#3B82F6",
      5 => "#8898AA"
    }
    "border-left: 4px solid #{border_colors[priority] || '#E3E8EF'};"
  end
end
