import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["content", "drag", "stats"]
  static values = {
    player: String
  }

  connect() {

  }

  revealContent() {
    this.contentTarget.classList.toggle("d-none")
    this.dragTarget.classList.toggle("d-none")
    this.statsTarget.classList.toggle("d-none")
    console.log(this.playerValue)
  }

  removeContent() {
    this.contentTarget.classList.add("d-none")
    this.dragTarget.classList.remove("d-none")
    this.statsTarget.classList.remove("d-none")
  }
}
