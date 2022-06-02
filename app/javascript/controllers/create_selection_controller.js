import { Controller } from "stimulus"

export default class extends Controller {
  static targets = []

  connect() {
    console.log("hello from the create selection controller")
  }

  create(event) {
    event.preventDefault()
    // console.log("hello from the METHOD in create selection controller")
    // console.log(this.formTargets)
    this.element.submit()
  }
}
