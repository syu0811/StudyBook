import marked from 'marked';
import hljs from 'highlight.js';

marked.setOptions({
  langPrefix: 'hljs language-',
  highlight: function(code, lang) {
    return hljs.highlightAuto(code, [lang]).value;
  }
});

window.addEventListener('DOMContentLoaded', function () {
  var raw = document.getElementById('markdown_raw');
  if(raw == null) return;
  document.getElementById('markdown_render').innerHTML = marked(raw.textContent);
  raw.parentNode.removeChild(raw);
});
