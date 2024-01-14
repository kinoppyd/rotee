import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="item"
export default class extends Controller {
  static targets = ["name"]

  connect() {
    const elm = this.nameTarget;
    elm.focus();
  }
}
