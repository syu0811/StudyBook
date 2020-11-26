window.onChange = function (value) {
  let url = new URL(location);
  url.searchParams.set('category', value);
  location.href = url.toString();
};

window.setSortParams = function (value) {
  let url = new URL(location);
  url.searchParams.set('order', value);
  location.href = url.toString();
};

window.changePage = function (note_id, my_list_id, index) {
  let url = window.location.href.split('?')[0];
  url = url.replace(/[0-9]+$/, note_id) + '?index=' + index + '&my_list_id=' + my_list_id;
  location.href = url.toString();
};


