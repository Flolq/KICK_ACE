import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["input","players"]

  connect() {
    console.log("hello from the search controller")
  }

  search() {
    console.log(this.inputTarget.value)
    const results = Player.where("first_name LIKE ? OR last_name LIKE ?", `%${this.inputTarget.value}%`, `%${this.inputTarget.value}%`)
//     players.each do |player| %>
//     <li class="list-group-item" data-action="click->players-selection#add click->enable-button#enable"  > <%= player.first_name %>  <%= player.last_name %> - Min. price: <%= player.min_price %> </li>
//  end

  }

}
