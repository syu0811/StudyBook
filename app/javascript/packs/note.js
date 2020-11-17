window.onChange = function (value) {
  const url = new URL(location);
  url.searchParams.set("category", value);
  location.href = url.toString();
};

window.changePage = function (note_id, my_list_id, index) {
  url = window.location.href.split("?")[0];
  url = url.replace(/[0-9]+$/, note_id) + "?my_list_id=" + my_list_id + "&index=" + index
  location.href = url.toString();
};

window.changeIndex = function (my_list_id, index, next) {
  const url = new URL(location);
  url.searchParams.set("my_list_id", my_list_id);
  if (next){
    url.searchParams.set("index", Number(index) + 1);
  }else{
    url.searchParams.set("index", Number(index) - 1);
  }
  location.href = url.toString();
};