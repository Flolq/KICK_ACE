import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["player", "budget", "button", "counter", "required"]

  connect() {
  }

    enable(event) {
    event.preventDefault()
    console.log(this.requiredTarget.innerHTML)
    const nb_required = this.requiredTarget.innerHTML
    let values = []
    this.playerTargets.forEach(element => values.push(parseInt(element.value, 10)))
    if ((values.filter((a) => a).length >= nb_required) && (parseInt(this.budgetTarget.innerHTML, 10) > 0)) {
      this.buttonTarget.classList.remove('disabled')
    }
  }

}
