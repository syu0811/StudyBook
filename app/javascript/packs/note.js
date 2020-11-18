window.onChange = function (value) {
  const url = new URL(location);
  url.searchParams.set("category", value);
  location.href = url.toString();
};

window.changePage = function (note_id, my_list_id, index) {
  url = window.location.href.split("?")[0];
  url = url.replace(/[0-9]+$/, note_id) + "?my_list_id=" + my_list_id + "&index=" + index;
  location.href = url.toString();
};

