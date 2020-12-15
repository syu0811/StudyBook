import Axios from 'axios';

export function resetPage(url) {
  url.searchParams.set('page', '1');
}

export function ajax(url) {
  window.history.pushState(null, null, url.toString());
  Axios.get(url.toString(), {headers: {'X-Requested-With': 'XMLHttpRequest'}}).then(response => {
    eval(response.data);
  });
}

window.setParams = function(key, value) {
  let url = new URL(location);
  url.searchParams.set(key, value);
  window.history.pushState(null, null, url.toString());
};

window.onChange = function (value) {
  let url = new URL(location);
  url.searchParams.set('category', value);
  resetPage(url);
  location.href = url.toString();
};

window.setSortParams = function (value) {
  let url = new URL(location);
  url.searchParams.set('order', value);
  resetPage(url);
  location.href = url.toString();
};

window.setSearchParams = function (e) {
  let url = new URL(location);
  url.searchParams.set('q', e.srcElement.children.search_field.value);
  resetPage(url);
  location.href = url.toString();
  e.preventDefault();
};

window.setCategoryParamsAjax = function (value) {
  let url = new URL(location);
  url.searchParams.set('category', value);
  resetPage(url);
  ajax(url);
};

window.setSortParamsAjax = function (value) {
  let url = new URL(location);
  url.searchParams.set('order', value);
  resetPage(url);
  ajax(url);
};

window.setSearchParamsAjax = function (e) {
  let url = new URL(location);
  url.searchParams.set('q', e.srcElement.children.search_field.value);
  resetPage(url);
  ajax(url);
  e.preventDefault();
};
