import Sortable from 'sortablejs';
import { resetPage } from './search';

window.addMyListNote = function (e, note_id, my_list_id) {
  const type = e.srcElement.checked ? 'POST' : 'DELETE';

  $.ajaxPrefilter((options, originalOptions, jqXHR) => {
    if (!options.crossDomain) {
      const token = $('meta[name="csrf-token"]').attr('content');
      if (token) {
        return jqXHR.setRequestHeader('X-CSRF-Token', token);
      }
    }
  });

  $.ajax({
    url: '/my_list_notes',
    type: type,
    data: { note_id: note_id, my_list_id: my_list_id },
    dataType: 'script',
  });
};

document.addEventListener('DOMContentLoaded', function () {
  var el = document.getElementById('my_list_notes');
  if(el == null) return;
  if (el.dataset.sortable == 'true') {
    Sortable.create(el, {
      onEnd: function (e) {
        $.ajaxPrefilter((options, originalOptions, jqXHR) => {
          if (!options.crossDomain) {
            const token = $('meta[name="csrf-token"]').attr('content');
            if (token) {
              return jqXHR.setRequestHeader('X-CSRF-Token', token);
            }
          }
        });

        $.ajax({
          url: `/my_list_notes/${e.item.dataset.id}`,
          type: 'PATCH',
          data: { my_list_note: { index: e.newIndex } },
          dataType: 'json',
        });
      },
    });
  }
});

window.setUserMyListParams = function(e) {
  let url = new URL(location);
  url.searchParams.set('user', e.target.checked);
  resetPage(url);
  location.href = url.toString();
};
