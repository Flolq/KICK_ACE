import Sortable from 'sortablejs';
import { Controller } from "stimulus"
import { csrfToken } from "@rails/ujs"

export default class extends Controller {
  static targets = [ 'team' ]

  connect() {
    console.log("still here")

    const el = this.teamTarget

    const sortable = new Sortable(el, {
      onEnd: function(evt) {
        const patch_url = evt.item.firstElementChild.getAttribute("data-sortable-update-url")

        fetch(patch_url, {
          method: "PATCH",
          headers: { "Accept": "text/plain", "X-CSRF-Token": csrfToken() },
          body: evt.oldIndex
        })
          .then(response => response.text())
          .then((data) => {
            console.log(data)
          })
      }
    })
  }
}
