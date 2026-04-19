import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "menu"]

  connect() {
    this.onDocumentClick = this.onDocumentClick.bind(this)
    this.onKeydown = this.onKeydown.bind(this)
    document.addEventListener("click", this.onDocumentClick)
    document.addEventListener("keydown", this.onKeydown)
  }

  disconnect() {
    document.removeEventListener("click", this.onDocumentClick)
    document.removeEventListener("keydown", this.onKeydown)
  }

  toggle(event) {
    event.stopPropagation()
    const isOpen = !this.menuTarget.hidden
    isOpen ? this.close() : this.open()
  }

  open() {
    this.menuTarget.hidden = false
    this.buttonTarget.setAttribute("aria-expanded", "true")
  }

  close() {
    this.menuTarget.hidden = true
    this.buttonTarget.setAttribute("aria-expanded", "false")
  }

  onDocumentClick(event) {
    if (!this.element.contains(event.target)) this.close()
  }

  onKeydown(event) {
    if (event.key === "Escape") this.close()
  }
}
