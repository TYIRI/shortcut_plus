// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "jquery"
import "jquery-ui/ui/widgets/autocomplete"
import "./tag-it"
import "bootstrap"
import "@fortawesome/fontawesome-free/js/all"
import "./jquery.validationEngine-ja"
import "./jquery.validationEngine"
import "./jquery.validationEngine.handler"
import "./recipes"
import "./edit_comment"
import "./avatar_select"
import "../src/application.scss"


Rails.start()
Turbolinks.start()
ActiveStorage.start()

require("trix")
require("@rails/actiontext")

const images = require.context('../images', true)
const imagePath = (name) => images(name, true)

document.addEventListener('turbolinks:load', function(event){
  if(typeof(gtag) == 'function'){
    gtag('config', 'G-CE5RQMYFRT', {
      'page_title' : event.target.title,
      'page_path': event.data.url.replace(window.location.protocol + "//" + window.location.hostname, "")
    });
  }
})
