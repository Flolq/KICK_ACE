import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "league" ]

  connect() {
    this.leagueTargets[0].classList.add("active")
  }

  active(event) {
    this.leagueTargets.forEach( element => element.classList.remove("active"))
    console.log(event)
    event.target.classList.add("active")
  }
}
