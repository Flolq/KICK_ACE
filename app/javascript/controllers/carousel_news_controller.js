import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "news", "precedent", "next" ]

  position = 1;

  connect() {
  }

  slideLeft() {
    this.newsTargets[this.position].classList.add("d-none")
    console.log(this.newsTargets[this.position]);
    this.nextTarget.removeAttribute("disabled", "")
    this.nextTarget.classList.add("carousel-btn")
    this.nextTarget.classList.remove("disabled-carousel-btn")
    if (this.position === 0) {
      this.precedentTarget.setAttribute("disabled", "")
      this.precedentTarget.classList.remove("carousel-btn")
      this.precedentTarget.classList.add("disabled-carousel-btn")
    }

    this.newsTargets[this.position].classList.remove("d-none")
  }

  slideRight() {
    this.newsTargets[this.position].classList.add("d-none")
    this.position = this.position + 1;
    this.precedentTarget.removeAttribute("disabled", "")
    this.precedentTarget.classList.add("carousel-btn")
    this.precedentTarget.classList.remove("disabled-carousel-btn")
    if (this.position === this.newsTargets.length - 1) {
      this.nextTarget.setAttribute("disabled", "")
      this.nextTarget.classList.remove("carousel-btn")
      this.nextTarget.classList.add("disabled-carousel-btn")
    }

    this.newsTargets[this.position].classList.remove("d-none")
  }
}
