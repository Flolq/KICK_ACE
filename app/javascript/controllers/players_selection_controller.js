import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["team"]

  connect() {
  }

  update(event) {
    // console.log(event.detail[2].response)
    const addTag = event.detail[2].response

    this.teamTarget.insertAdjacentHTML("beforeend", addTag)
  }

  disable(event) {
    event.preventDefault()
    event.currentTarget.classList.add("d-none")
  }
}
