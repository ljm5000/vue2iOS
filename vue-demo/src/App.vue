<template>
  <div>123</div>
  <div @click="goToB">Page A</div>
  <div>{{ msg }}</div>
  <img alt="Vue logo" src="./assets/logo.png">
  <HelloWorld msg="Welcome to Your Vue.js App" />
</template>

<script>
import HelloWorld from './components/HelloWorld.vue'
import Request from './components/Request'
import { useRouter } from "vue-router";
//  function sendMsg(){
//       window.webkit.messageHandlers.getDataFormVue.postMessage({
//         title: "this.money", //vue给iOS传值
//     });
//     }
export default {
  setup() {
    const router = useRouter();
    const goToB = () => {
      console.error("gotu")
      router.push({
         name: "AppT",
         params: {
          value: "abcde",
        },
      });
    };
    return {
      goToB,
    };
  },
  name: 'App',
  components: {
    HelloWorld
  },
  data() {
    return {
      msg: ""
    }
  },

  mounted() {
    //Vue的方法给原生调用前，需要把方法挂在Window下面
    window.receiveAPPData = this.receiveAPPData;

    // sendMsg();
  },
  created() {
    this.loadData()

  },
  methods: {
    async loadData() {
      const [error, response] = await Request({ params: { url: "asdf", data: "asdf" }, method: 'asdf' });
      if(error){
        return
      }
      this.msg = response
    },

    receiveAPPData(params) {
      alert(params);
      console.log("接收的数据:" + params);
      // this.$refs.text.innerText = "接收的数据:" + params; //更新值
    },
  }
}
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
