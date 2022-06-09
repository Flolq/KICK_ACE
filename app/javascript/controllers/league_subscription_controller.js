import { Controller } from "@hotwired/stimulus"
import consumer from "../channels/consumer"

export default class extends Controller {
  static values = { leagueId: Number }
  static targets = ["notification"]

  connect() {
    this.channel = consumer.subscriptions.create(
      { channel: "LeagueChannel", id: this.leagueIdValue },
      { received: data => this.notificationTarget.insertAdjacentHTML("beforeend", data)}
    )
    console.log(`Subscribed to the league with the id ${this.leagueIdValue}.`)
  }
}
