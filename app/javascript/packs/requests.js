import axios from 'axios';

export default {
  request (method, url, options) {
    var promise = null;
    var params = {};
    var headers = {};

    if (options.params) {
      // リクエストパラメーターのセット
      params = options.params;
    }
    if (options.headers) {
      // カスタムヘッダーのセット
      headers = options.headers;
    }
    if (options.auth) {
      // ヘッダーにAuthorizationをセット
      var authenticateToken = localStorage.getItem('AuthenticationToken');
      var authorization_header = { Authorization: authenticateToken };
      headers = Object.assign(headers, authorization_header);
    }
    // RailsのCSRFトークンをセット
    const token = document.getElementsByName('csrf-token')[0].getAttribute('content');
    headers['X-CSRF-TOKEN'] = token;

    promise = axios({
      method: method,
      url: url,
      data: params,
      headers: headers
    });
    promise.catch(function() {
      return console.log(promise);
    });
    return promise;
  },
  get (url, options = {}) {
    return this.request('get', url, options);
  },
  post (url, options = {}) {
    return this.request('post', url, options);
  },
  patch (url, options = {}) {
    return this.request('patch', url, options);
  },
  delete (url, options = {}) {
    return this.request('delete', url, options);
  }
};
