import Axios from './requests';

window.subscribeMyList = function (e, user_nickname, my_list_id) {
  const request_url = `/users/${user_nickname}/subscribe_my_lists/${my_list_id}`;
  if (e.srcElement.dataset.iscreate == 'true') {
    Axios.post(request_url, {headers: { 'X-Requested-With': 'XMLHttpRequest'} }).then(
      (response) => {
        eval(response.data);
        e.srcElement.dataset.iscreate = 'false';
        e.srcElement.classList.add('subscribe__destroy');
        e.srcElement.classList.remove('subscribe__create');
      }
    );
  } else {
    Axios.delete(request_url, {headers: {'X-Requested-With': 'XMLHttpRequest'}}).then(
      (response) => {
        eval(response.data);
        e.srcElement.dataset.iscreate = 'true';
        e.srcElement.classList.add('subscribe__create');
        e.srcElement.classList.remove('subscribe__destroy');
      }
    );
  }
};
