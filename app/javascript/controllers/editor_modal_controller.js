import { Controller } from "stimulus"
import axios from "axios"
import { axiosPostable } from "../lib/utils"

export default class extends Controller {
  static targets = [ "additionalFields", "status" ]
  
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

    this.element.querySelector('.modal-card-body > form').classList.add('dimmed')
    this.element.querySelector('button[data-action="editor-modal#save"]').classList.add('is-loading')
    this.statusTarget.classList.add('in-progress')
    this.statusTarget.innerHTML = "Generating Preview…"

    try {
      let response = null
      if (httpMethod == 'post') {
        response = await this.axios.post(savePath, data)
        const newCard = document.createElement('template')
        newCard.innerHTML = response.data.document_html
        console.log("new card!", newCard)
        const list = document.getElementById('list-' + this.data.get('content-model'))
        console.log("list!", list)
        list.prepend(newCard.content.cloneNode(true))

        console.log("done!")
      } else if (httpMethod == 'put') {
        response = await this.axios.put(savePath, data)
        const updatedCard = response.data.document_html
        document.getElementById(this.data.get('content-model') + '-' + this.data.get('model-id')).outerHTML = updatedCard
      }
      console.log('about to refresh')
      this.refreshPublishingMenu()
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

  async refreshPublishingMenu() {
    console.log("running the axios…")
    try {
      let response = null
      response = await this.axios.get(this.data.get('publishing-menu-path'))
      console.log("got the axios!", response)
      document.getElementById('publishing-menu').innerHTML = response.data
    } catch (error) {
      console.log(error)
    }
  }
}
