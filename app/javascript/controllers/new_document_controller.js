import { Controller } from "stimulus"
import axios from "axios"

export default class extends Controller {
  async open() {
    const newPath = this.data.get('path')

    try {
      const response = await axios.get(newPath)
      document.querySelector('#editor-modal-wrapper').innerHTML = response.data
      document.querySelector('#editor-modal input').focus()
    } catch (error) {
      console.log(error)
    }
  }
}