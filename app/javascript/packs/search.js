export function resetPage(url) {
  url.searchParams.set('page', '1');
}

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

