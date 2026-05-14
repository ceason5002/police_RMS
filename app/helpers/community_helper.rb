module CommunityHelper
  def active_comm_link(path, exact: false)
    if exact
      request.path == path ? "comm-nav-link--active" : ""
    else
      request.path.start_with?(path) ? "comm-nav-link--active" : ""
    end
  end
end
