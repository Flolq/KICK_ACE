import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["content", "drag", "stats"]

  revealContent() {
    this.contentTarget.classList.toggle("d-none")
    this.dragTarget.classList.toggle("d-none")
    this.statsTarget.classList.toggle("d-none")
  }

  removeContent() {
    this.contentTarget.classList.add("d-none")
    this.dragTarget.classList.remove("d-none")
    this.statsTarget.classList.remove("d-none")
  }
}
