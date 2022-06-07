import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["counter", "players"]

  connect() {
    // console.log("hello from disable add controller")
  }

  disable(event) {
    event.preventDefault()
    // console.log(this.playersTargets)
    // console.log(this.counterTarget)
    const nb_left_players = parseInt(this.counterTarget.innerHTML,10)
    // console.log(nb_left_players)
    if (nb_left_players <= 1) {
      this.playersTargets.forEach ((target) => {
        target.classList.add('d-none')
      })
    }
  }
}
