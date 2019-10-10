import { Controller } from "stimulus"
import axios from "axios"
import { axiosPostable } from "../lib/utils"

export default class extends Controller {
  initialize() {
    this.axios = axiosPostable(axios)
  }

  async edit(event) {
    event.preventDefault()
    const editPath = event.currentTarget.href

    try {
      const response = await this.axios.get(editPath, {headers: {'Accept': 'text/html'}})
      document.querySelector('#editor-modal-wrapper').innerHTML = response.data
      document.querySelector('#editor-modal input').focus()
    } catch (error) {
      console.log(error)
    }
  }

  async destroy(event) {
    event.preventDefault()
    const deletePath = event.currentTarget.href
    const cardId = event.currentTarget.dataset.cardId

    if (confirm("Are you sure you wish to delete this item?")) {
      try {
        await this.axios.delete(deletePath)
        document.getElementById(cardId).remove()
      } catch (error) {
        console.log(error)
      }
    }
  }
}