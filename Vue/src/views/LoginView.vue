<script setup>
import { inject, onMounted, ref } from "vue";
import { decr } from "../util/function";
const axios = inject("axios"); // inject axios
const user = ref({ UserName: "", Password: "" });
const errors = ref({ UserName: "", Password: "" });
const store = inject("store");
const swal = inject("$swal");
const cryoptojs = inject("cryptojs");
const checkForm = () => {
  if (!user.value.UserName) {
    errors.value.UserName = "Tên đăng nhập không được để trống!";
  } else {
    errors.value.UserName = "";
  }
  if (!user.value.Password) {
    errors.value.Password = "Mật khẩu không được để trống!";
  } else if (user.value.Password.length < 8) {
    errors.value.Password = "Mật khẩu không được ít hơn 8 ký tự!";
  } else {
    errors.value.Password = "";
  }
};
const login = () => {
  checkForm();
  let form = document.getElementsByName("frlogin")[0];
  let check = form.checkValidity();
  if (!check) {
    return false;
  }
  // Light theme
  swal.fire({
    width: 110,
    didOpen: () => {
      swal.showLoading();
    },
  });
  axios
    .post(baseURL + "/api/Login/Login", user.value)
    .then((response) => {
      if (response.data.err != "1") {
      
        localStorage.setItem("tk", response.data.data);
        localStorage.setItem("u", response.data.u);
        store.commit("setuser", JSON.parse(decr(response.data.u, SecretKey, cryoptojs)));
        store.commit("settoken", response.data.data);
        store.commit("setislogin", true);
       
        swal.close();
      } else {
        console.log(response);
        swal.fire({
          title: "Error!",
          text: response.data.ms,
          icon: "error",
          confirmButtonText: "OK",
        });
      }
    })
    .catch((error) => {
      swal.fire({
        title: "Error!",
        text: "Có lỗi xảy ra, vui lòng kiểm tra lại!",
        icon: "error",
        confirmButtonText: "OK",
      });
    });
};
onMounted(() => {
  return {
    checkForm,
    login,
    user,
    errors,
  };
});
</script>
<template>
  <div class="login-container">
    <div class="login-bg"><img src="../assets/image/background.jpg" /></div>
    <div class="box-login">
      <div class="login-form">
        <form name="frlogin">
          <div class="mb-3">
            <h1>Đăng nhập</h1>
          </div>
          <div class="field">
            <label for="UserName">Tên đăng nhập</label>
            <InputText
              id="UserName"
              type="text"
              v-model="user.UserName"
              @input="checkForm"
              v-bind:class="errors.UserName != '' ? 'invalid' : ''"
              autocomplete="off"
              required
            />
            <InlineMessage severity="error" v-if="errors.UserName != ''">{{
              errors.UserName
            }}</InlineMessage>
          </div>
          <div class="field">
            <label for="Password">Mật khẩu</label>
            <Password
              id="Password"
              v-model="user.Password"
              @input="checkForm"
              v-bind:class="errors.Password != 'w-full' ? 'w-full invalid' : ''"
              autocomplete="off"
              required
              toggleMask
              :feedback="false"
            >
            </Password>
            <InlineMessage severity="error" v-if="errors.Password != ''">{{
              errors.Password
            }}</InlineMessage>
          </div>
          <Button label="Đăng nhập" @click="login()" />
        </form>
      </div>
    </div>
  </div>
</template>
<style scoped>
.invalid {
  color: red;
  margin: 5px 0;
  font-size: 13px;
}

input.invalid {
  border: 1px solid red;
}

.login-container {
  display: flex;
  width: 100vw;
  height: 100vh;
  overflow: hidden;
}

.login-bg {
  width: 100vw;
  height: 100vh;
}

.login-bg > img {
 object-fit: cover;
  width: calc(100% - 480px);
  height: 100%;
}

.box-login {
  background-color: rgba(121, 204, 186, 0.8);
  flex: 1;
  display: block;
  padding: 50px;
  position: absolute;
  right: 0;
  height: 100%;
  min-width: 480px;
}

.login-form {
  align-items: center;
  vertical-align: middle;
  max-width: 480px;
  margin: auto;
  margin-top: calc(50vh - 209px);
}

.login-form > button {
  width: 100%;
  margin-top: 20px;
}

.login-form h1 {
  font-size: 20pt;
  margin-bottom: 20px;
}
.field * {
  display: block;
}
.field label {
  margin: 1rem 0;
}
.p-inputtext {
  display: block;
  margin-bottom: 0.5rem;
  width: 100%;
}
.p-inputtext:last-child {
  margin-bottom: 0;
}
.login-form button {
  width: 100%;
  margin-top: 2rem;
}
</style>
