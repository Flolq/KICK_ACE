import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "signIn", "qrCode" ]

  connect() {
    if(window.innerWidth >= 768 ) {
      this.signInTarget.innerHTML = ""
      this.signInTarget.insertAdjacentHTML('beforeend', `
      <div class="white">
      <h2>
      This website has been designed for mobile
      </h2>
      <div>
      Please flash this code to Kick some ACE:
      </div>
      </div>
      `)

      console.log(this.qrCodeTarget)

      this.qrCodeTarget.classList.remove("d-none")
    }

  }
}
