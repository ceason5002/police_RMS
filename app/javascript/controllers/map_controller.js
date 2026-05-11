import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "latitude", "longitude", "search", "suggestions", "streetAddress", "city", "state", "zipCode"]

  connect() {
    const L = window.L
    if (!L) return

    const lat = parseFloat(this.latitudeTarget.value) || 39.8283
    const lng = parseFloat(this.longitudeTarget.value) || -98.5795
    const zoom = this.latitudeTarget.value ? 14 : 4

    this.map = L.map(this.containerTarget).setView([lat, lng], zoom)

    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      attribution: "© OpenStreetMap contributors"
    }).addTo(this.map)

    if (this.latitudeTarget.value) {
      this.placeMarker(lat, lng)
    }

    this.map.on("click", (e) => {
      this.placeMarker(e.latlng.lat, e.latlng.lng)
      this.latitudeTarget.value = e.latlng.lat
      this.longitudeTarget.value = e.latlng.lng
      this.reverseGeocode(e.latlng.lat, e.latlng.lng)
    })

    this.debounceTimer = null
    document.addEventListener("click", this.handleOutsideClick.bind(this))
  }

  search() {
    clearTimeout(this.debounceTimer)
    const query = this.searchTarget.value.trim()
    if (query.length < 3) { this.hideSuggestions(); return }
    this.debounceTimer = setTimeout(() => this.fetchSuggestions(query), 350)
  }

  fetchSuggestions(query) {
    fetch(`https://nominatim.openstreetmap.org/search?format=json&q=${encodeURIComponent(query)}&addressdetails=1&limit=6&countrycodes=us`)
      .then(r => r.json())
      .then(results => this.showSuggestions(results))
      .catch(() => {})
  }

  showSuggestions(results) {
    this.suggestionsTarget.innerHTML = ""
    if (!results.length) { this.hideSuggestions(); return }

    results.forEach(result => {
      const item = document.createElement("div")
      item.style.cssText = "padding: 8px 12px; cursor: pointer; border-bottom: 1px solid #eee; font-size: 13px;"
      item.textContent = result.display_name
      item.addEventListener("mouseenter", () => item.style.background = "#f5f5f5")
      item.addEventListener("mouseleave", () => item.style.background = "white")
      item.addEventListener("mousedown", (e) => { e.preventDefault(); this.selectResult(result) })
      this.suggestionsTarget.appendChild(item)
    })

    this.suggestionsTarget.style.display = "block"
  }

  hideSuggestions() {
    this.suggestionsTarget.style.display = "none"
    this.suggestionsTarget.innerHTML = ""
  }

  selectResult(result) {
    const addr = result.address || {}
    const house = addr.house_number || ""
    const road = addr.road || addr.pedestrian || addr.footway || ""
    const street = [house, road].filter(Boolean).join(" ")
    const city = addr.city || addr.town || addr.village || addr.hamlet || addr.county || ""

    this.streetAddressTarget.value = street
    this.cityTarget.value = city
    this.stateTarget.value = addr.state || ""
    this.zipCodeTarget.value = addr.postcode || ""
    this.searchTarget.value = result.display_name

    const lat = parseFloat(result.lat)
    const lng = parseFloat(result.lon)
    this.latitudeTarget.value = lat
    this.longitudeTarget.value = lng
    this.placeMarker(lat, lng)
    this.map.setView([lat, lng], 16)
    this.hideSuggestions()
  }

  placeMarker(lat, lng) {
    if (this.marker) {
      this.marker.setLatLng([lat, lng])
    } else {
      this.marker = window.L.marker([lat, lng], { draggable: true }).addTo(this.map)
      this.marker.on("dragend", (e) => {
        const pos = e.target.getLatLng()
        this.latitudeTarget.value = pos.lat
        this.longitudeTarget.value = pos.lng
        this.reverseGeocode(pos.lat, pos.lng)
      })
    }
  }

  reverseGeocode(lat, lng) {
    fetch(`https://nominatim.openstreetmap.org/reverse?format=json&lat=${lat}&lon=${lng}&addressdetails=1`)
      .then(r => r.json())
      .then(data => {
        if (!data.address) return
        const addr = data.address
        const house = addr.house_number || ""
        const road = addr.road || addr.pedestrian || addr.footway || ""
        this.streetAddressTarget.value = [house, road].filter(Boolean).join(" ")
        this.cityTarget.value = addr.city || addr.town || addr.village || addr.hamlet || addr.county || ""
        this.stateTarget.value = addr.state || ""
        this.zipCodeTarget.value = addr.postcode || ""
        this.searchTarget.value = data.display_name || ""
      })
      .catch(() => {})
  }

  handleOutsideClick(e) {
    if (!this.element.contains(e.target)) this.hideSuggestions()
  }

  disconnect() {
    document.removeEventListener("click", this.handleOutsideClick.bind(this))
    if (this.map) this.map.remove()
  }
}
