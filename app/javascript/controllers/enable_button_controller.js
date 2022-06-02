import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["player", "budget", "button"]

  connect() {
  }

  enable(event) {
    event.preventDefault()
    // console.log (this.playerTargets)
    let values = []
    this.playerTargets.forEach(element => values.push(parseInt(element.value, 10)))
    if ((values.filter((a) => a).length > 7) && (parseInt(this.budgetTarget.innerHTML, 10) > 0)) {
      this.buttonTarget.classList.remove('disabled')
    }
  }

}
