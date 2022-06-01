import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["budget", "price", "recap"]

  connect() {
    // console.log("hello from the budget update controller")
  }

  update(event) {
    event.preventDefault()
    let sum = 0
     this.priceTargets.forEach(element => sum = sum +(element.value == "" ? 0 : parseInt(element.value, 10)))
    this.budgetTarget.innerHTML = `${500-sum}`
    if (parseInt(this.budgetTarget.innerHTML, 10) < 0) {
      this.recapTarget.classList.add("text-danger")
    }
    if (parseInt(this.budgetTarget.innerHTML, 10) > 0) {
      this.recapTarget.classList.remove("text-danger")
    }
  }
}
