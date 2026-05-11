module AdminHelper
  def admin_nav_link(icon, label, path)
    active = current_page?(path) || request.path.start_with?(path.sub(/\/$/, ""))
    bg     = active ? "rgba(99,91,255,0.25)" : "transparent"
    color  = active ? "white" : "rgba(255,255,255,0.6)"
    content_tag(:a, href: path, style: "display:flex;align-items:center;gap:10px;padding:8px 10px;border-radius:6px;text-decoration:none;font-size:13px;font-weight:#{active ? '600' : '500'};color:#{color};background:#{bg};margin-bottom:2px;") do
      content_tag(:span, icon, style: "font-size:14px;") + content_tag(:span, label)
    end
  end
end