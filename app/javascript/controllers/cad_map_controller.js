import { Controller } from "@hotwired/stimulus"

const PRIORITY_COLORS = {
  1: "#DF1B41",
  2: "#F97316",
  3: "#EAB308",
  4: "#3B82F6",
  5: "#8898AA"
}

export default class extends Controller {
  static values = { callsUrl: String }

  connect() {
    const L = window.L
    if (!L) return

    this.map = L.map(this.element).setView([39.8283, -98.5795], 5)

    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      attribution: "© OpenStreetMap contributors",
      maxZoom: 19
    }).addTo(this.map)

    this.markers = {}
    this.loadCalls()
    this.pollTimer = setInterval(() => this.loadCalls(), 20000)
  }

  loadCalls() {
    if (!this.hasCallsUrlValue) return
    fetch(this.callsUrlValue, { headers: { Accept: "application/json" } })
      .then(r => r.json())
      .then(calls => this.renderMarkers(calls))
      .catch(() => {})
  }

  renderMarkers(calls) {
    const L = window.L

    const activeIds = new Set(calls.map(c => String(c.id)))

    Object.keys(this.markers).forEach(id => {
      if (!activeIds.has(id)) {
        this.markers[id].remove()
        delete this.markers[id]
      }
    })

    calls.forEach(call => {
      if (!call.latitude || !call.longitude) return

      const id     = String(call.id)
      const color  = PRIORITY_COLORS[call.priority] || "#8898AA"
      const latLng = [parseFloat(call.latitude), parseFloat(call.longitude)]

      if (this.markers[id]) {
        this.markers[id].setLatLng(latLng)
        this.markers[id].setPopupContent(this.buildPopup(call))
      } else {
        const icon = L.divIcon({
          className: "",
          html: `<div style="
            background:${color};
            width:18px;height:18px;
            border-radius:50%;
            border:3px solid rgba(255,255,255,0.9);
            box-shadow:0 2px 6px rgba(0,0,0,0.45);
            cursor:pointer;
          "></div>`,
          iconSize: [18, 18],
          iconAnchor: [9, 9]
        })

        const marker = L.marker(latLng, { icon })
        marker.bindPopup(this.buildPopup(call), { maxWidth: 260 })
        marker.addTo(this.map)
        this.markers[id] = marker
      }
    })

    if (calls.some(c => c.latitude && c.longitude) && Object.keys(this.markers).length > 0) {
      const group = L.featureGroup(Object.values(this.markers))
      if (Object.keys(this.markers).length === 1) {
        this.map.setView(group.getBounds().getCenter(), 13)
      } else {
        try { this.map.fitBounds(group.getBounds().pad(0.2)) } catch (_) {}
      }
    }
  }

  buildPopup(call) {
    const units = call.units && call.units.length ? call.units.join(", ") : "None assigned"
    const color = PRIORITY_COLORS[call.priority] || "#8898AA"
    return `
      <div style="font-size:13px;min-width:200px;">
        <div style="font-weight:700;font-size:14px;margin-bottom:6px;color:#0A2540;">
          ${call.call_number}
        </div>
        <div style="display:flex;gap:8px;align-items:center;margin-bottom:6px;">
          <span style="background:${color};color:${call.priority === 3 ? '#000' : '#fff'};padding:2px 8px;border-radius:100px;font-size:11px;font-weight:700;">
            P${call.priority}
          </span>
          <span style="color:#425466;">${call.call_type}</span>
        </div>
        <div style="color:#425466;margin-bottom:3px;">📍 ${call.location}</div>
        <div style="color:#8898AA;font-size:12px;margin-bottom:3px;">Status: ${call.status}</div>
        <div style="color:#8898AA;font-size:12px;margin-bottom:10px;">Units: ${units}</div>
        <a href="/cad/calls/${call.id}"
           style="display:inline-block;background:#635BFF;color:#fff;padding:5px 14px;border-radius:5px;text-decoration:none;font-size:12px;font-weight:600;">
          View Call →
        </a>
      </div>
    `
  }

  disconnect() {
    clearInterval(this.pollTimer)
    if (this.map) this.map.remove()
  }
}
