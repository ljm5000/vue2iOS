import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
window.APPBridges = {
    __callbackCollections__: {},
    usePromise: true,
    __throwException__: function (name, message) {
      throw new Error(name, message);
    }
  };
  window.APPBridges.webToNative = function (message, cb) {
    var uniqueCallbackid = 'callback__' + Date.now() + Math.floor(Math.random() * 100000);
    if (this.usePromise) {
      var that = this;
      return new Promise(function (resolve, reject) {
        that.__callbackCollections__[uniqueCallbackid] = function (err, data) {
          if (err) {
            reject(err);
            return;
          }
          resolve(data);
        };
        message.callbackid = uniqueCallbackid;
        window.webkit.messageHandlers.webToNative.postMessage(message);
      })
    }
    if (cb) {
      this.__callbackCollections__[uniqueCallbackid] = cb;
      message.callbackid = uniqueCallbackid;
    }
    window.webkit.messageHandlers.webToNative.postMessage(message);
  };
createApp(App).use(router).mount('#app')