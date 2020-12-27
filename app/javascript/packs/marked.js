import marked from 'marked';
import hljs from 'highlight.js';

window.addEventListener('DOMContentLoaded', function () {
  marked.setOptions({
    langPrefix: 'hljs language-',
    highlight: function(code, lang) {
      return hljs.highlightAuto(code, [lang]).value;
    }
  });
  var raw = document.getElementById('markdown_raw');
  document.getElementById('markdown_render').innerHTML = marked(raw.textContent);
  raw.parentNode.removeChild(raw);
});
