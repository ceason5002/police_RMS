import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel", "messages", "input"]

  toggle() {
    this.panelTarget.hidden = !this.panelTarget.hidden
    if (!this.panelTarget.hidden) {
      this.inputTarget.focus()
    }
  }

  close() {
    this.panelTarget.hidden = true
  }

  async send() {
    const message = this.inputTarget.value.trim()
    if (!message) return

    this.inputTarget.value = ""
    this.appendMessage(message, "user")
    const typing = this.appendMessage("...", "bot")

    try {
      const res  = await fetch(this.chatUrl(), {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')?.content || "",
        },
        body: JSON.stringify({ message }),
      })
      const data = await res.json()
      typing.textContent = data.reply || "Sorry, I couldn't respond."
    } catch(e) {
      typing.textContent = "Connection error. Please call (555) 555-0100."
    }

    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight
  }

  appendMessage(text, role) {
    const div = document.createElement("div")
    div.className = `comm-chat-msg comm-chat-msg--${role}`
    div.textContent = text
    this.messagesTarget.appendChild(div)
    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight
    return div
  }

  chatUrl() {
    return document.querySelector("meta[name='community-chat-url']")?.content
      || "/community/chat"
  }
}
