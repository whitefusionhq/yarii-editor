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
    const cardId = this.element.id

    if (confirm("Are you sure you wish to delete this item?")) {
      this.element.classList.add('dimmed')
      try {
        await this.axios.delete(deletePath)
        document.getElementById(cardId).remove()
        this.refreshPublishingMenu()
      } catch (error) {
        console.log(error)
      }
    }
  }

  async refreshPublishingMenu() {
    try {
      let response = null
      response = await this.axios.get(this.data.get('publishing-menu-path'))
      document.getElementById('publishing-menu').innerHTML = response.data
    } catch (error) {
      console.log(error)
    }
  }
}