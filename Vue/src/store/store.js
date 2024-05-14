import { useRouter } from 'vue-router'
import { createStore } from 'vuex'
//Khai báo
var routers = useRouter()
export const store = createStore({
  state: {
    islogin: false,
    background:
      localStorage.getItem('background') ||
      'https://primefaces.org/primevue/img/window.6b46439b.jpg',
    isDock: localStorage.getItem('isDock') == 'true',
    user: {
      IsQuyen: 0
    },
    token: null,
    urlLang: '/Portals/Lang/VietNam.png',
    idNews: null,
    idStage: null,
    checkStage: false
  },
  getters: {
    stageid: (state) => state.idStage,
    checkStage: (state) => state.checkStage,
    islogin: (state) => state.islogin,
    user: (state) => state.user,
    token: (state) => state.token,
    isDock: (state) => state.isDock,
    background: (state) => state.background
  },
  mutations: {
    setCheckStage(state, v1) {
      state.checkStage = v1
    },
    setIdStage(state, v1) {
      state.idStage = v1
    },
    setIdNews(state, v1) {
      state.idNews = v1
    },
    setislogin(state, vl) {
      state.islogin = vl
    },
    setisDock(state, vl) {
      state.isDock = vl
      localStorage.setItem('isDock', vl)
    },
    setbackground(state, vl) {
      state.background = vl
      localStorage.setItem('background', vl)
    },
    setuser(state, vl) {
      state.user = vl
    },
    settoken(state, vl) {
      state.token = vl
    },
    gologout(state) {
      localStorage.removeItem('tk')
      state.token = null
      state.islogin = false
      state.user = null
      // if (router) {
      //     console.log("222333444", router);
      //     routers.push({
      //         name: "home",
      //     });
      //     //router.push({ path: "/home" });
      // }
    }
  }
})
