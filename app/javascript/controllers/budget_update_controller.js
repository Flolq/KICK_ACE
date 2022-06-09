import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["budget", "price", "recap", "max"]

  connect() {
    // console.log("hello from the budget update controller")
  }

  update(event) {
    event.preventDefault()
    const max_budget = parseInt(this.maxTarget.innerHTML, 0)
    // console.log(max_budget)
    let sum = 0
     this.priceTargets.forEach(element => sum = sum +(element.value == "" ? 0 : parseInt(element.value, 10)))
    this.budgetTarget.innerHTML = `${max_budget-sum} m€`
    if (parseInt(this.budgetTarget.innerHTML, 10) < 0) {
      this.recapTarget.classList.add("text-danger")
    }
    if (parseInt(this.budgetTarget.innerHTML, 10) > 0) {
      this.recapTarget.classList.remove("text-danger")
    }
  }
}
