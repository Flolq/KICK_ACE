import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "link" ]

  connect() {

  }

  toggle() {
    this.linkTarget.classList.toggle("d-none")
  }
}
