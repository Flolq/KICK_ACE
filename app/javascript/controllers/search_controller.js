import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["input","players","form"]

  connect() {
    // console.log("hello from the search controller")
    // console.log(this.inputTarget)
    // console.log(this.formTarget)
    // console.log(this.playersTarget)
  }

  update() {
    const url = `${this.formTarget.action}?query=${this.inputTarget.value}&commit=Search`
      fetch(url, { headers: { "Accept": "text/plain" } })
        .then(response => response.text())
        .then((data) => {
        this.playersTarget.innerHTML = data
      })


  }

}
