import { Controller } from "stimulus"
import axios from "axios"
import { axiosPostable } from "../lib/utils"

export default class extends Controller {
  initialize() {
    this.axios = axiosPostable(axios)
  }
  
  connect() {
    this.checkingInterval = setInterval(this.checkBuildingStatus.bind(this), 5000)
  }

  async checkBuildingStatus() {
    try {
      let response = await this.axios.get(this.data.get('path'))
      if (response.data.updated) {
        this.element.classList.remove('is-warning')
        this.element.classList.add('is-success')
        this.element.innerHTML = 'Public Website Updated!'
        clearInterval(this.checkingInterval)
        setTimeout(() => { this.element.remove() }, 8000)
      }
    } catch (error) {
      console.error(error)
    }
  }
}