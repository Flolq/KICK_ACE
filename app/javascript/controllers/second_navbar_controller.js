import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "league" ]
  static values = { name: String }

  connect() {
    this.leagueTargets.forEach(element => {
      if (element.innerText === this.nameValue) {
        element.classList.add("active")
      }
    })
  }

  active(event) {
    this.leagueTargets.forEach( element => element.classList.remove("active"))
    // console.log(event)
    event.target.classList.add("active")
  }
}
