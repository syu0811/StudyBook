window.setRows = function (textarea, max_line_num = 5) {
  var lines = textarea.value.split('\n');
  var rows = lines.length;
  if (lines.length > max_line_num) {
    var result = '';
    for (var i = 0; i < max_line_num; i++) {
      result += lines[i] += '\n';
    }
    result = result.slice(0, -1);
    textarea.value = result;
    rows--;
  }
  textarea.rows = rows;
};
