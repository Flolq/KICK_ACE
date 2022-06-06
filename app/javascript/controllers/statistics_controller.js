import { Controller } from "stimulus"

export default class extends Controller {
  static values = {
    player: String
  }

  static targets = ["content", "drag", "stats"]

  connect() {

  }

  revealContent(event) {
    // this.contentTargets.classList.toggle("d-none")
    // console.log(event.params)
    // this.element.insertAdjacentHTML('beforeend',
    // `
    // <div class="card-statistics" data-statistics-target="content" data-statistics-player-value="<%= player.id %>">
    //     <div><h3>Statistics this year</h3></div>
    //     <div>
    //       <p>Date of birth: <%= player.date_of_birth %></p>
    //       <p>Competitions played: <%= player.competitions_played %></p>
    //       <p>Competitions won: <%= player.competitions_won %></p>
    //       <p>Matches played: <%= player.matches_played %></p>
    //       <p>Matches won: <%= player.matches_won %></p>
    //       <p>Points earned: <%= selection.player_points %> points</p>
    //     </div>
    //   </div>
    // `)
    this.contentTarget.classList.toggle("d-none")
    this.dragTarget.classList.toggle("d-none")
    this.statsTarget.classList.toggle("d-none")
  }

  removeContent() {
    this.contentTarget.classList.add("d-none")
    this.dragTarget.classList.remove("d-none")
    this.statsTarget.classList.remove("d-none")
  }
}
