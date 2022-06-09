import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["content", "drag", "points"]

  connect() {

  }

  revealContent(event) {
    const e = event.params.playerId

    let content = this.contentTargets.find( div => div.dataset.statisticsPlayerId == e )

    content.classList.toggle("d-none")
    this.dragTarget.classList.toggle("d-none")

    // const animateValue = (obj, start, end, duration) => {
    //   let startTimestamp = null;
    //   const step = (timestamp) => {
    //     if (!startTimestamp) startTimestamp = timestamp;
    //     const progress = Math.min((timestamp - startTimestamp) / duration, 1);
    //     obj.innerHTML = Math.floor(progress * (end - start) + start);
    //     if (progress < 1) {
    //       window.requestAnimationFrame(step);
    //     }
    //   };
    //   window.requestAnimationFrame(step);
    // }

    // const obj = this.pointsTarget;
    // animateValue(obj, 0, 100, 1000);
  }

  removeContent() {
    this.contentTargets.forEach(content => content.classList.add("d-none"))
    this.dragTarget.classList.remove("d-none")
  }
}
