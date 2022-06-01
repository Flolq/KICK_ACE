import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "link" ]

  connect() {
    console.log("Hello")
  }

  toggle() {
    this.linkTarget.classList.toggle("d-none")
  }
}
