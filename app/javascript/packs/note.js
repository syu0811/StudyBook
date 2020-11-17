window.onChange = function (value) {
  const url = new URL(location);
  url.searchParams.set('category', value);
  location.href = url.toString();
};

window.onClick = function () {
  const url = new URL(location);
  url.searchParams.set('my_list_id', 1);
  i = Number(url.searchParams.get("index"));
  if (i == null){
    url.searchParams.set('index', 1);
  }
  else{
    url.searchParams.set('index', i + 1);
  }
  
  location.href = url.toString();
};

