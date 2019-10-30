import { Controller } from "stimulus"
import axios from "axios"

export default class extends Controller {
  async more(event) {
    event.preventDefault()
    const button = event.currentTarget
    const path = event.currentTarget.href
    button.classList.add('is-loading')

    try {
      const response = await axios.get(path)
      const listContents = document.createElement('template')
      listContents.innerHTML = response.data
      const listId = this.element.id.split('-')[1]
      const list = document.getElementById('list-' + listId)
      console.log(list, this.element, listContents)
      list.insertBefore(listContents.content.cloneNode(true), this.element)
      
      let nextPage = path.match(/page=(\d+)/)[1]
      nextPage = parseInt(nextPage, 10) + 1
      button.href = button.href.replace(/page=(\d+)/, "page=" + nextPage)
      button.classList.remove('is-loading')

      if (response.data.includes("data-list-done=\"true\"")) {
        button.remove()
      }
    } catch (error) {
      button.classList.remove('is-loading')
      console.error(error)
    }
  }
}