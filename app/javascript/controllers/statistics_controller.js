import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["content", "drag", "stats"]

  connect() {

  }

  revealContent(event) {
    const e = event.params.playerId

    let content = this.contentTargets.find( div => div.dataset.statisticsPlayerId == e )

    content.classList.toggle("d-none")
    this.dragTarget.classList.toggle("d-none")
    this.statsTarget.classList.toggle("d-none")
  }

  removeContent() {
    this.contentTargets.forEach(content => content.classList.add("d-none"))
    this.dragTarget.classList.remove("d-none")
    this.statsTarget.classList.remove("d-none")
  }
}
