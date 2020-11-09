window.onChange = function (value) {
  const url = new URL(location);
  url.searchParams.set('category', value);
  location.href = url.toString();
};
