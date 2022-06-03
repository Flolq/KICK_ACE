import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["team"]

  connect() {
  }

  update(event) {
    const addTag = event.detail[2].response
    this.teamTarget.insertAdjacentHTML("beforeend", addTag)
  }

  disable(event) {
    event.preventDefault()
    // console.log(this.iconTarget).
    console.log(event.currentTarget)
    event.currentTarget.classList.add("d-none")
  }
}
