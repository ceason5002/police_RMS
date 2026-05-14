import { Controller } from "@hotwired/stimulus"

const TYPE_COLORS = {
  "Homicide":            "#7C3AED",
  "Assault":             "#DF1B41",
  "Robbery":             "#DF1B41",
  "Domestic Violence":   "#DF1B41",
  "Shots Fired":         "#DF1B41",
  "Burglary":            "#F97316",
  "Motor Vehicle Theft": "#F97316",
  "Theft":               "#F97316",
  "Vehicle Theft":       "#F97316",
  "Vandalism":           "#EAB308",
  "Drug Offense":        "#EAB308",
  "Drug Activity":       "#EAB308",
  "Traffic Accident":    "#3B82F6",
  "DUI":                 "#3B82F6",
  "Missing Person":      "#8B5CF6",
}

function colorFor(type) {
  return TYPE_COLORS[type] || "#64748B"
}

function makeIcon(color) {
  return L.divIcon({
    className: "",
    html: `<div style="width:14px;height:14px;border-radius:50%;background:${color};border:2px solid #fff;box-shadow:0 1px 4px rgba(0,0,0,0.3);"></div>`,
    iconSize: [14, 14],
    iconAnchor: [7, 7],
  })
}

export default class extends Controller {
  static targets = ["typeFilter", "daysFilter", "count"]
  static values  = { dataUrl: String }

  connect() {
    this.map = L.map("community-crime-map").setView([37.8, -96], 4)
    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      attribution: '&copy; OpenStreetMap contributors',
      maxZoom: 18,
    }).addTo(this.map)
    this.markers = []
    this.loadData()
  }

  filter() {
    this.loadData()
  }

  async loadData() {
    const type = this.typeFilterTarget.value
    const days = this.daysFilterTarget.value
    const url  = new URL(this.dataUrlValue, window.location.origin)
    if (type) url.searchParams.set("type", type)
    if (days) url.searchParams.set("days", days)

    try {
      const res  = await fetch(url)
      const data = await res.json()
      this.renderMarkers(data)
    } catch(e) {
      console.error("Crime map fetch failed", e)
    }
  }

  renderMarkers(incidents) {
    this.markers.forEach(m => m.remove())
    this.markers = []

    incidents.forEach(inc => {
      const color  = colorFor(inc.incident_type)
      const marker = L.marker([inc.lat, inc.lng], { icon: makeIcon(color) })
        .bindPopup(`
          <strong>${inc.incident_type}</strong><br>
          ${inc.area}<br>
          <span style="color:#64748B;font-size:12px;">${inc.occurred_at}</span><br>
          <span style="font-size:12px;color:${color};">${inc.status}</span>
        `)
      marker.addTo(this.map)
      this.markers.push(marker)
    })

    this.countTarget.textContent = `Showing ${incidents.length} incident${incidents.length === 1 ? "" : "s"}`
  }

  disconnect() {
    if (this.map) this.map.remove()
  }
}
