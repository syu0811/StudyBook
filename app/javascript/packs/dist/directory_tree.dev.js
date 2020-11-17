'use strict';

window.toggleDirectory = function (e) {
  // var ulist = e.srcElement.parentNode.parentNode.getElementsByTagName('ul');
  var ulist = e.srcElement.parentNode.parentNode.children;

  if (e.srcElement.classList.contains('close') == true) {
    for (var i = 1; i < ulist.length; i++) {
      ulist[i].style.display = 'block';
    }

    e.srcElement.classList.remove('close');
  } else {
    for (var _i = 1; _i < ulist.length; _i++) {
      ulist[_i].style.display = 'none';
    }

    e.srcElement.classList.add('close');
  }
};