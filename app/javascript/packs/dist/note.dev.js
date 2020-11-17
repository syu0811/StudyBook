'use strict';

window.onChange = function (value) {
  var url = new URL(location);
  url.searchParams.set('category', value);
  location.href = url.toString();
};