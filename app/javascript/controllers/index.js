// Load all the controllers within this directory and all subdirectories. 
// Controller files must be named *_controller.js.

import { Application } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"

const application = Application.start()
const context = require.context("controllers", true, /_controller\.js$/)
application.load(definitionsFromContext(context))



// NOTHING WORKING HERE SO FAR

function smoothScroll (node, left) {
  document.body.scrollTo({'top': 0, behavior: 'smooth' })
  return node.scrollTo({'left': left, behavior: 'smooth' })
}

document.addEventListener('DOMContentLoaded', function() {
  window.scroller = document.querySelector('.scroll')
})

window.currentList = 0
window.totalLists = 5

function next() {
  currentList += 1

  scrollToLeft = Math.floor(window.scroller.scrollWidth * (window.currentList / window.totalLists)) 
  smoothScroll(window.scroller, scrollToLeft)
}
function previous() {
  currentList -= 1

  scrollToLeft = Math.floor(window.scroller.scrollWidth * (window.currentList / window.totalLists)) 
  smoothScroll(window.scroller, scrollToLeft)
}
