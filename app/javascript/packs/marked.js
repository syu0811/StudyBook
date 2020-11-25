import marked from 'marked';
import hljs from 'highlight.js';

window.addEventListener('DOMContentLoaded', function () {
  marked.setOptions({
    // code要素にdefaultで付くlangage-を削除
    // langPrefix: '',
    langPrefix: 'hljs language-',
    // highlightjsを使用したハイライト処理を追加
    highlight: function(code, lang) {
      return hljs.highlightAuto(code, [lang]).value;
    }
  });
  var raw = document.getElementById('markdown_raw');
  document.getElementById('markdown_render').innerHTML = marked(raw.textContent);
  raw.parentNode.removeChild(raw);
});
