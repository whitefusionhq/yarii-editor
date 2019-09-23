import { Controller } from "stimulus"
import axios from "axios"
import { axiosPostable } from "../lib/utils"

export default class extends Controller {
  static targets = [ "additionalFields" ]
  
  initialize() {
    this.axios = axiosPostable(axios)
  }

  connect() {
    // We'll handle saving ourselves. Disable normal form operation
    this.element.querySelector('.modal-card-body > form').addEventListener('submit', event => {
      event.preventDefault()
    })
  }
  async save() {
    const form = this.element.querySelector('.modal-card-body > form');
    const data = new FormData(form);

    const savePath = this.data.get('path')
    const httpMethod = this.data.get('http-method')

    try {
      let response = null
      if (httpMethod == 'post') {
        response = await this.axios.post(savePath, data)
      } else if (httpMethod == 'put') {
        response = await this.axios.put(savePath, data)
      }
      this.closeModal()
    } catch (error) {
      alert("I'm sorry, I ran into trouble communicating with the server. Please copy your content to another text editor to preserve your work if this problem persists.")
      console.log(error)
    }
  }

  cancel() {
    this.closeModal()
  }

  closeModal() {
    this.element.remove()
  }
  
  showAdditionalFields() {
    this.additionalFieldsTarget.classList.remove('is-hidden')
  }
}
