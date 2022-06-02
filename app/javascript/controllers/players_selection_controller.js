import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["team", "players"]

  connect() {
  }

  update(event) {
    const addTag = event.detail[2].response
    this.teamTarget.insertAdjacentHTML("beforeend", addTag)
  }

  remove(event) {
    event.preventDefault()
    event.currentTarget.classList.add("d-none")
  }
}
