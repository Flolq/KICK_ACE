import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["counter", "players"]

  connect() {
    console.log("hello from disable add controller")
  }

  disable(event) {
    event.preventDefault()
    console.log(this.playersTargets)
    console.log(this.counterTarget)
    const nb_secured_players = parseInt(this.counterTarget.innerHTML,10)
    if (nb_secured_players >=7) {
      this.playersTargets.forEach ((target) => {
        target.classList.add('d-none')
      })
    }
  }
}
