import Axios from './requests';

function setSearchTagURL(tags = ['']) {
  let url = new URL(location);
  url.searchParams.set('tags', tags.join(','));
  window.history.pushState(null, null, url.toString());
  Axios.get(url.toString(), {headers: {'X-Requested-With': 'XMLHttpRequest'}}).then(response => {
    eval(response.data);
  });
}

window.addSearchTag = function (e) {
  e.preventDefault();
  let tagName = e.srcElement.children[0].value;
  let searchTags = document.getElementById('search_tags');
  for(let tag of searchTags.children) {
    if(tag.dataset.tagName == tagName) {
      return;
    }
  }
  let addHtml = `<div class="tag-search__tag" data-tag-name="${tagName}" onclick="removeSearchTag(event)">${tagName}</div>`;
  searchTags.insertAdjacentHTML('beforeend', addHtml);
  e.srcElement.children[0].value = '';
  let tags = [];
  for(let tag of searchTags.children) {
    tags.push(tag.dataset.tagName);
  }
  setSearchTagURL(tags);
};

window.removeSearchTag = function(e) {
  e.srcElement.remove();
  let searchTags = document.getElementById('search_tags');
  let tags = [];
  for(let tag of searchTags.children) {
    tags.push(tag.dataset.tagName);
  }
  setSearchTagURL(tags);
};
