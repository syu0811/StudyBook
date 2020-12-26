// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require('@rails/ujs').start();
require('@rails/activestorage').start();
require('channels');
// load images
require.context('../images/', true);

import 'bootstrap';
import '../stylesheets/application';
import './marked';
import './my_lists';
import './my_list_notes';
import './text_area';
import './note';
import './directory_tree';
import './subscribe_my_list';
import './search';
import './search_tags';
import './user';
import './user_study_graph';
import './user_notes_category_ratio_graph';

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

window.getStyleSheetValue = function (element, property) {
  if (!element || !property) {
    return null;
  }
  var style = window.getComputedStyle(element);
  var value = style.getPropertyValue(property);
  return value;
};
