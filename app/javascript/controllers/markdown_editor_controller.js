import EasyMDE from "easymde"
import { replaceEditorSelection } from "../lib/utils.js"

import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "editor" ]

  doSomething(editor) {
    var cm = editor.codemirror

    document.querySelector('#imagemodal').classList.add('is-active')
    document.querySelector('#imagemodal button.button').addEventListener('click', () => {
      document.querySelector('#imagemodal').classList.remove('is-active')
      replaceEditorSelection(cm, null, ["{% 'foobar' | cloudinary_image:'q_50' %}", ''])
    })
  }

  connect() {
    this.easyMDE = new EasyMDE({
      autoDownloadFontAwesome: false,
      spellChecker: false,
      forceSync: true,
      element: this.editorTarget,
      toolbar: [
        {
            name: 'bold',
            action: EasyMDE.toggleBold,
            className: 'fa fa-bold',
            title: 'Bold',
        },
        {
            name: 'italic',
            action: EasyMDE.toggleItalic,
            className: 'fa fa-italic',
            title: 'Italic',
        },
        {
            name: 'strikethrough',
            action: EasyMDE.toggleStrikethrough,
            className: 'fa fa-strikethrough',
            title: 'Strikethrough',
        },
        {
            name: 'heading-1',
            action: EasyMDE.toggleHeading1,
            className: 'fa fa-header fa-heading header-1',
            title: 'Big Heading',
        },
        {
            name: 'heading-2',
            action: EasyMDE.toggleHeading2,
            className: 'fa fa-header fa-heading header-2',
            title: 'Medium Heading',
        },
        {
            name: 'heading-3',
            action: EasyMDE.toggleHeading3,
            className: 'fa fa-header fa-heading header-3',
            title: 'Small Heading',
        },
        '|',
        {
            name: 'code',
            action: EasyMDE.toggleCodeBlock,
            className: 'fa fa-code',
            title: 'Code',
        },
        {
            name: 'quote',
            action: EasyMDE.toggleBlockquote,
            className: 'fa fa-quote-left',
            title: 'Quote'
        },
        {
            name: 'unordered-list',
            action: EasyMDE.toggleUnorderedList,
            className: 'fa fa-list-ul',
            title: 'Generic List'
        },
        {
            name: 'ordered-list',
            action: EasyMDE.toggleOrderedList,
            className: 'fa fa-list-ol',
            title: 'Numbered List'
        },
        {
            name: 'clean-block',
            action: EasyMDE.cleanBlock,
            className: 'fa fa-eraser',
            title: 'Clean block',
        },
        '|',
        {
            name: 'link',
            action: EasyMDE.drawLink,
            className: 'fa fa-link',
            title: 'Create Link'
        },
        {
          name: 'cloudinary',
          action: (editor) => {this.doSomething(editor)},
          className: 'fa fa-image',
          title: 'Insert Cloudinary Image'
        },
        {
            name: 'horizontal-rule',
            action: EasyMDE.drawHorizontalRule,
            className: 'fa fa-minus',
            title: 'Insert Horizontal Line',
        },
        '|',
        {
            name: 'preview',
            action: EasyMDE.togglePreview,
            className: 'fa fa-eye',
            noDisable: true,
            title: 'Toggle Preview'
        },
        {
            name: 'side-by-side',
            action: EasyMDE.toggleSideBySide,
            className: 'fa fa-columns',
            noDisable: true,
            noMobile: true,
            title: 'Toggle Side by Side'
        },
        {
            name: 'fullscreen',
            action: EasyMDE.toggleFullScreen,
            className: 'fa fa-arrows-alt',
            noDisable: true,
            noMobile: true,
            title: 'Toggle Fullscreen'
        },
        '|',
        {
            name: 'undo',
            action: EasyMDE.undo,
            className: 'fa fa-undo',
            noDisable: true,
            title: 'Undo',
        },
        {
            name: 'redo',
            action: EasyMDE.redo,
            className: 'fa fa-repeat fa-redo',
            noDisable: true,
            title: 'Redo',
        },
      ]
    });
  }
}