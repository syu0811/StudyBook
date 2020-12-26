import { resetPage } from './search';

function setSearchTagURL(tags = ['']) {
  let url = new URL(location);
  url.searchParams.set('tags', tags.join(','));
  resetPage(url);
  window.history.pushState(null, null, url.toString());
  location.href = url.toString();
}

function setTags(searchTags, tagName) {
  let addHtml = `<div class="tag-search__tag" data-tag-name="${tagName}" onclick="removeSearchTag(event)">${tagName}</div>`;
  searchTags.insertAdjacentHTML('beforeend', addHtml);
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
  setTags(searchTags, tagName);
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

window.addEventListener('DOMContentLoaded', function () {
  let searchTags = document.getElementById('search_tags');
  if(searchTags == undefined) {
    return;
  }

  let url = new URL(location);
  if(url.searchParams.get('tags') == '') return;
  let tags = url.searchParams.get('tags').split(',');
  for(let tagName of tags) {
    setTags(searchTags, tagName);
  }
});
