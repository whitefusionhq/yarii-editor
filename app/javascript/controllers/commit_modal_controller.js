import { Controller } from "stimulus"
import axios from "axios"
import { axiosPostable } from "../lib/utils"

export default class extends Controller {
  static targets = [ "status" ]
  
  initialize() {
    this.axios = axiosPostable(axios)
  }

  connect() {
    // We'll handle saving ourselves. Disable normal form operation
    this.element.querySelector('.modal-card-body > form').addEventListener('submit', event => {
      event.preventDefault()
    })
  }
  async commit() {
    const form = this.element.querySelector('.modal-card-body > form');
    const data = new FormData(form);

    this.element.querySelector('.modal-card-body > form').classList.add('dimmed')
    this.element.querySelector('button[data-action="commit-modal#commit"]').classList.add('is-loading')
    this.statusTarget.classList.add('in-progress')
    this.statusTarget.innerHTML = "Pushing Updates…"

    try {
      let response = null
      response = await this.axios.post(this.data.get('path'), data)
      this.refreshPublishingMenu()
      this.closeModal()
    } catch (error) {
      alert("I'm sorry, I ran into trouble communicating with the server. Try pushing again in a moment.")
      console.log(error)
    }
  }

  cancel() {
    this.closeModal()
  }

  closeModal() {
    this.element.remove()
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