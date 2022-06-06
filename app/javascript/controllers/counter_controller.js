import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["counter"]

  connect() {
    console.log("hello from the counter controller")
  }

  increment(event) {
    event.preventDefault()
    // console.log(this.counterTarget)
    this.counterTarget.innerHTML = parseInt(this.counterTarget.innerHTML,10) + 1
  }
}
