// base dependency library, it should be only shared by `admin.js` and `application.js`.
import "jquery";
import "bootstrap/dist/js/bootstrap";

import RailsUjs from "@rails/ujs";
import Turbolinks from "turbolinks";
import * as ActiveStorage from "@rails/activestorage";
import "channels";

// require.context("../images", true);
const images = require.context("../images", true);
const imagePath = name => images(name, true);

RailsUjs.start();
Turbolinks.start();
ActiveStorage.start();

$(document).on("turbolinks:load", function () {
  $('[data-toggle="tooltip"]').tooltip();
});

import "./bootstrap_custom.js";
import "./google_analytics.js";
import "./receta_form.js";
import "../styles/application";