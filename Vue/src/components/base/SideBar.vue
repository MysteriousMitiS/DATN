<script setup>
//Import
import { inject, onMounted, ref } from "vue";
//Khai báo biến
const basedomainURL = baseURL;
const store = inject("store");
const swal = inject("$swal");
const axios = inject("axios"); // inject axios
const menu = ref([]);
const loadMenu = () => {
  if (store.state.user.IsQuyen > 3) {
    menu.value = [
      {
        header: "DATN-001",
        hiddenOnCollapse: true,
      },
      {
        href: "/",
        title: "Trang chủ",
        icon: "pi pi-home",
      },
      {
        href: "/project",
        title: "Tất cả dự án",
        icon: "pi pi-bars",
      },
      {
        href: "/yourwork",
        title: "Công việc",
        icon: "pi pi-folder",
      },
        {
        href: "/news",
        title: "Sự kiện - Thông báo",
        icon: "pi pi-instagram",
      },
      {
        href: "/user",
        title: "Nhân sự",
        icon: "pi pi-users",
      },
    
    ];
  }
  else{
    menu.value = [
      {
        header: "DATN-001",
        hiddenOnCollapse: true,
      },
      {
        href: "/",
        title: "Trang chủ",
        icon: "pi pi-home",
      },
      {
        href: "/yourwork",
        title: "Công việc",
        icon: "pi pi-folder",
      },
      {
        href: "/user",
        title: "Thông tin của tôi",
        icon: "pi pi-users",
      },
    ];
  }
};

const appconfig = ref({ version: "1.0" });
//Vue App
onMounted(() => {
  loadMenu();
  return {
    menu,
  };
});
</script>
<template>
  <sidebar-menu :menu="menu" class="vsm_white-theme w-2"  v-if="store.state.user.IsQuyen>3">
    <!-- <template v-slot:header
      ><div class="text-center p-2">
        <Avatar
          v-ripple
          v-bind:image="basedomainURL + store.getters.user.Avartar"
          v-bind:label="store.getters.user.Avartar ? '' : store.getters.user.FName"
          size="large"
          style="background-color: #2196f3; color: #ffffff"
          shape="circle"
        />
      </div>
    </template> -->
    <template v-slot:footer></template>
    <template v-slot:toggle-icon>
      <i class="pi pi-microsoft" style="font-size: 2rem"></i>
      <h5 class="ml-2 hversion">Phiên bản {{ appconfig.version }}</h5>
    </template>
  </sidebar-menu>
</template>
<style scoped>
.AppSideBar {
  background-color: #fff;
}
.vsm_white-theme {
  font-weight: 700;
}
.vsm_collapsed .hversion {
  display: none;
}
</style>
