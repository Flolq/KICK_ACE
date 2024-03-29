import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["input"];
  static values = {
    feedbackText: String
  }

  copy(event) {
    this.inputTarget.select()
    // console.log("hello");
    document.execCommand('copy');
    event.currentTarget.disabled = true;
    event.currentTarget.innerText = this.feedbackTextValue;
  }
}
