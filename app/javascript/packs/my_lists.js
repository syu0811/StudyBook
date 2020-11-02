window.addMyListNote = function (e, note_id, my_list_id) {
  const type = e.srcElement.checked ? "POST" : "DELETE";

  $.ajaxPrefilter((options, originalOptions, jqXHR) => {
    if (!options.crossDomain) {
      const token = $('meta[name="csrf-token"]').attr("content");
      if (token) {
        return jqXHR.setRequestHeader("X-CSRF-Token", token);
      }
    }
  });

  $.ajax({
    url: `/my_list_notes`,
    type: type,
    data: { note_id: note_id, my_list_id: my_list_id },
    dataType: "script"
  })
};
