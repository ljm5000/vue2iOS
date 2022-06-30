/* eslint-disable no-console */
function Request({ method = '', params = {} }) {
  let p;
  try {
    p = window.APPBridges.webToNative({
      params, method
    }).then(data => {
      console.log(data);
      console.log(JSON.stringify(data));
      return [null, data];
    }, err => { console.log(err); return [err, null]; });
  } catch (e) {
    return Promise.reject(() => {
      return [null, e];
    })
  }
  return p;
}

export default Request;
