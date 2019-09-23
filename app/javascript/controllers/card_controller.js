import { Controller } from "stimulus"
import axios from "axios"

export default class extends Controller {
  async edit(event) {
    event.preventDefault()
    const editPath = event.currentTarget.href

    try {
      const response = await axios.get(editPath)
      document.querySelector('#editor-modal-wrapper').innerHTML = response.data
      document.querySelector('#editor-modal input').focus()
    } catch (error) {
      console.log(error)
    }
  }
}