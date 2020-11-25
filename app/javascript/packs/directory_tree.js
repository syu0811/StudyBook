window.toggleDirectory = function (e) {
  var ulist = e.srcElement.parentNode.parentNode.children;
  if (e.srcElement.classList.contains('close') == true) {
    for (let i = 1; i < ulist.length; i++) {
      ulist[i].style.display = 'block';
    }
    e.srcElement.classList.remove('close');
  } else {
    for (let i = 1; i < ulist.length; i++) {
      ulist[i].style.display = 'none';
    }
    e.srcElement.classList.add('close');
  }
};
