import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["player", "budget", "button", "secured"]

  connect() {
  }

  enable(event) {
    event.preventDefault()
    const nb_secured_players = parseInt(this.securedTarget.innerHTML,10)
    let values = []
    this.playerTargets.forEach(element => values.push(parseInt(element.value, 10)))
    if ((values.filter((a) => a).length > (7 - nb_secured_players)) && (parseInt(this.budgetTarget.innerHTML, 10) > 0)) {
      this.buttonTarget.classList.remove('disabled')
    }
  }

}
