<template>
  <div>page2</div>

</template>

<script>

import { useRoute } from "vue-router";

export default {
    setup() {
    const route = useRoute();
    const getParams = () => {
      return route.params;
    };
    return {
      getParams,
    };
  },
  name: 'AppT',
  components: {

  },
  data() {
    return {
      msg: ""
    }
  },

  mounted() {
  
  },
  created() {
    console.log(`created:` + JSON.stringify(this.getParams()));
    window.webkit.messageHandlers.getDataFormVue.postMessage({
        title:this.getParams(), //vue给iOS传值
    });

  },
  methods: {
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
