import { Controller } from "@hotwired/stimulus"

// Live-updates the booking total as the customer picks a session + party size.
export default class extends Controller {
  static targets = ["session", "party", "total"]

  connect() { this.recalc() }

  recalc() {
    const selected = this.sessionTargets.find((el) => el.checked)
    const price = selected ? parseInt(selected.dataset.price || "0", 10) : 0
    const party = Math.max(1, parseInt(this.hasPartyTarget ? this.partyTarget.value : "1", 10) || 1)
    const cents = price * party
    if (this.hasTotalTarget) {
      this.totalTarget.textContent = cents ? this.format(cents) : "—"
    }
  }

  format(cents) {
    return new Intl.NumberFormat(document.documentElement.lang || "fr", {
      style: "currency",
      currency: "EUR"
    }).format(cents / 100)
  }
}
