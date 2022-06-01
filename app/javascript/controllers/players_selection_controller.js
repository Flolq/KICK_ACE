import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["team"]


  connect() {
  }

  add(event) {
    event.preventDefault()
    const selection = Selection.new
    const addTag= `<li class="list-group-item d-flex justify-content-between">
    <div>
        ${event.currentTarget.innerHTML}
    </div>
    <div >
      <label for="price"> Your bid </label>
      <input type="number" name="price" id="price" data-action="blur->budget-update#update blur->enable-button#enable" data-budget-update-target="price" data-enable-button-target = "player" required>
    </div
    </li>`
    this.teamTarget.insertAdjacentHTML("beforeend", addTag)
    event.currentTarget.classList.add("d-none")
  }

}
