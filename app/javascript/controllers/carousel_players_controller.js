import { Controller } from "stimulus"

export default class extends Controller {
  // static targets = ["budget", "price", "recap"]

  connect() {
    console.log('hello')
    // dragger(window);
    // const transition = new Transitioner();
    // const leftBtn = document.querySelector(".carousel__controls--left");
    // const rightBtn = document.querySelector(".carousel__controls--right");

    // window.carousel = new CircleCarousel(
    //   document.querySelector(".carousel_players"),
    //   () => (window.innerWidth) / 4
    // );

    // leftBtn.onclick = () => {
    //   carousel.rotateLeft();
    //   carousel.drawElements();
    // };

    // rightBtn.onclick = () => {
    //   carousel.rotateRight();
    //   carousel.drawElements();
    // };

    // onDrag(({ distanceX }) => {
    //   const r = -distanceX / (carousel.radius * (Math.PI / 2));

    //   carousel.rotation = Math.round(r / carousel.sA) * carousel.sA;
    //   carousel.rotated = r;

    //   carousel.updateItems(r);
    // });

    // onDragEnd(() => {
    //   carousel.rotate();
    // });
  }

}
