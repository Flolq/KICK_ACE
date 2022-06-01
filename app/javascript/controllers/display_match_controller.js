import { Controller } from "stimulus"

export default class extends Controller {
  static targets = []
  static values = {
    key: String,
    playerId: String
  }

  connect() {
    console.log(this.keyValue)
    this.get_match()
  }

  async get_match() {
    const url = `https://api.sportradar.com/tennis/trial/v3/en/competitors/${this.playerIdValue}/summaries.json?api_key=${this.keyValue}`

    await fetch(url, {
      mode: 'no-cors',
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
        "Access-Control-Allow-Origin" : "*",
        "Access-Control-Allow-Credentials" : true
      }
    })
      .then(response => response.json())
      .then(data => console.log(data))
  }
}
