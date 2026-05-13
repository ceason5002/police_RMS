import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { interval: { type: Number, default: 20000 } }

  connect() {
    this.timer = setInterval(() => this.refresh(), this.intervalValue)
  }

  refresh() {
    const callsFrame = document.getElementById("active-calls-frame")
    const unitsFrame = document.getElementById("unit-board-frame")
    callsFrame?.reload()
    unitsFrame?.reload()
  }

  disconnect() {
    clearInterval(this.timer)
  }
}
