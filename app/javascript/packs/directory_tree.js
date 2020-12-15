import { resetPage, ajax } from './search';
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

function setActiveDirectoryClass(value) {
  let directoryId = (value == '') ? 'directory_notes' : `directory_${value}`;
  window.activeDirectoryElement = document.getElementById(directoryId);
  if(window.activeDirectoryElement) {
    window.activeDirectoryElement.classList.add('active-content');
  }
}
window.setDirectoryPathParamsAjax = function (value) {
  if(window.activeDirectoryElement) {
    window.activeDirectoryElement.classList.remove('active-content');
  }
  setActiveDirectoryClass(value);
  let url = new URL(location);
  url.searchParams.set('directory_path', value);
  resetPage(url);
  ajax(url);
};

document.addEventListener('DOMContentLoaded', function () {
  let url = new URL(location);
  setActiveDirectoryClass(url.searchParams.get('directory_path'));
});
