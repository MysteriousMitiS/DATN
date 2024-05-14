<script setup>
//Import
import { inject, onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { useToast } from 'vue-toastification'
//Khai báo
const router = useRouter()
const axios = inject('axios')
const swal = inject('$swal')
//Khai báo biến
const store = inject('store')
const storetheme = inject('storetheme')

const setTheme = (name) => {
  storetheme.value = name
  localStorage.setItem('storetheme', name)
  visibleSidebarRight.value = false
}
const basedomainURL = baseURL

const menu = ref()
const toast = useToast()
const visibleSidebarRight = ref(false)
const items = ref([
  { label: 'Công việc của bạn', icon: 'pi pi-fw pi-folder', to: '/yourwork' },
  { label: 'Cài đặt', icon: 'pi pi-fw pi-cog', to: '/user' },
  {
    label: 'Đăng xuất',
    icon: 'pi pi-fw pi-power-off',
    command: (event) => {
      logout()
    }
  }
])

//
const logout = () => {
  swal
    .fire({
      title: 'Thông báo',
      text: 'Bạn có muốn đăng xuất khỏi tài khoản này không!',
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#3085d6',
      cancelButtonColor: '#d33',
      confirmButtonText: 'Có',
      cancelButtonText: 'Không'
    })
    .then((result) => {
      if (result.isConfirmed) {
        router.push({
          path: '/'
        })

        store.commit('gologout')
      }
    })
}
const toggle = (event) => {
  //storetheme.value="bootstrap4-dark-blue";
  menu.value.toggle(event)
}

//Vue App
onMounted(() => {
  return {
    menu,
    items
  }
})
</script>
<template>
  <div class="flex flex-row shadow-3 header-bar">
    <Toolbar class="w-full py-0 pl-0">
      <template #start>
        <a href="/" style="text-decoration: none">
          <div class="flex flex-row flex-grow-1 headerbar align-items-center">
            <div class="ml-2 mr-2">
              <img src="../../assets/image/cms.png" height="40" />
            </div>
            <h2 style="font-size: 1.1rem; color: #005a9e; font-weight: bold; text-decoration: none">
              Quản trị công việc
            </h2>
          </div>
        </a>
      </template>
      <template #end>
        <div class="flex flex-none align-items-center justify-content-center btn-togglang">
          <!-- <i
            v-ripple
            class="pi pi-bell mr-4 p-text-secondary"
            style="font-size: 1.5rem"
            v-badge="2"
          ></i> -->
          <Button
            type="button"
            class="shadow-none p-button-text p-1 p-ripple"
            @click="toggle"
            aria-haspopup="true"
            aria-controls="overlay_menu"
          >
            <Avatar
              v-ripple
              v-bind:image="
                store.getters.user.Avatar
                  ? basedomainURL + store.getters.user.Avatar
                  : '/src/assets/image/noimg.jpg'
              "
              v-bind:label="store.getters.user.Avatar ? '' : store.getters.user.Name"
              style="background-color: #2196f3; color: #ffffff"
              shape="circle"
            />
          </Button>

          <Menu id="overlay_menu" ref="menu" :model="items" :popup="true" />
        </div>
      </template>
    </Toolbar>
  </div>
  <Sidebar
    v-model:visible="visibleSidebarRight"
    :baseZIndex="1000"
    style="width: 360px"
    position="right"
  >
    <h2 class="align-items-center justify-content-center">
      Cấu hình Theme
      <Button icon="pi pi-palette" @click="setTheme('saga-blue')" class="p-button-rounded" />
    </h2>

    <div v-for="(value, name) in skin" :key="name">
      <h5>{{ name }}</h5>
      <div class="grid col-12">
        <div
          class="col-3 align-items-center justify-content-center text-center"
          v-for="item in value"
          :key="item.name"
          @click="setTheme(item.name)"
        >
          <Avatar class="divskin" v-bind:image="item.icon" size="xlarge" />
          <h5>{{ item.title }}</h5>
        </div>
      </div>
    </div>
  </Sidebar>
</template>
<style scoped>
.headerbar {
  background-color: #fff;
  height: 50px;
}
.divskin:hover {
  cursor: pointer;
  background-color: #eee;
}
</style>
