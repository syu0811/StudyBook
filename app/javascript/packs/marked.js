import marked from 'marked';

window.addEventListener('DOMContentLoaded', function () {
  var raw = document.getElementById('markdown_raw');
  document.getElementById('markdown_render').innerHTML = marked(raw.textContent);
  raw.parentNode.removeChild(raw);
});
