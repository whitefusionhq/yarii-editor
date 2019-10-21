import { Controller } from "stimulus"
import axios from "axios"

export default class extends Controller {
  async open(event) {
    event.preventDefault()
    const path = this.element.href

    try {
      const response = await axios.get(path)
      document.querySelector('#commit-modal-wrapper').innerHTML = response.data
      document.querySelector('#commit-modal input').focus()
    } catch (error) {
      console.error(error)
    }
  }
}