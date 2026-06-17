import { Controller } from "@hotwired/stimulus"

// Auto-dismisses live notification toasts after a delay.
export default class extends Controller {
  static values = { delay: { type: Number, default: 6000 } }

  connect() {
    this.timeout = setTimeout(() => this.dismiss(), this.delayValue)
  }

  disconnect() { clearTimeout(this.timeout) }

  dismiss() {
    this.element.style.transition = "opacity .4s, transform .4s"
    this.element.style.opacity = "0"
    this.element.style.transform = "translateX(20px)"
    setTimeout(() => this.element.remove(), 400)
  }
}
