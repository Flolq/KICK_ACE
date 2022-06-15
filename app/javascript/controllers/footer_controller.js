import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "mobileFooter", "computerFooter" ]

  connect() {
    if(window.innerWidth >= 768 ) {
      this.mobileFooterTarget.classList.add("d-none")
      this.computerFooterTarget.classList.remove("d-none")
    }
  }

  changeFooter() {
    console.log(self.innerWidth)
    if(self.innerWidth >= 768 ) {
      this.mobileFooterTarget.classList.add("d-none")
      this.computerFooterTarget.classList.remove("d-none")
    } else {
      this.mobileFooterTarget.classList.remove("d-none")
      this.computerFooterTarget.classList.add("d-none")
    }
  }
}
