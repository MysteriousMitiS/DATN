<script setup>
import { ref, inject, onMounted } from "vue";
import { required } from "@vuelidate/validators";
import { useToast } from "vue-toastification";
import { useVuelidate } from "@vuelidate/core";
import { getParent } from "../../util/function";
//init Model
const user = ref({
  UserCode: "",
  Name: "",
  UserName: "",
  Password: "",

  DateOfBirth: null,
  Position: "",
  PhoneNumber: "",
  UserAddress: "",
  Email: "",
  DepartmentName: "",
  salary: "",
  IsAdmin: false,
  Avatar: null,
});
//Valid Form
const submitted = ref(false);
const rules = {
  UserCode: {
    required,
  },
  Name: {
    required,
  },
  UserName: {
    required,
  },
  Password: {
    required,
  },
};
const v$ = useVuelidate(rules, user);
//Khai báo biến
const tdQuyens = [
  { value: 0, text: "Không có quyền (0)" },
  { value: 1, text: "Xem cá nhân (1)" },
  { value: 2, text: "Xem tất cả (2)" },
  { value: 3, text: "Chỉnh sửa cá nhân (3)" },
  { value: 4, text: "Chỉnh sửa tất cả (4)" },
  { value: 5, text: "Duyệt (5)" },
  { value: 6, text: "Full (6)" },
].reverse();
const store = inject("store");
const isAdd = ref(true);
const selectedKey = ref();
const selectedNodes = ref([]);
const filters = ref({});
const options = ref({
  search: "",
  PageNo: 1,
  PageSize: 8,
  FilterUserName: null,
});
const users = ref();
const treeusers = ref();
const displayAddUser = ref(false);
const isFirst = ref(true);
let files = [];
const toast = useToast();
const swal = inject("$swal");
const axios = inject("axios"); // inject axios
const basedomainURL = baseURL;
const layout = ref("grid");
const config = {
  headers: { Authorization: `Bearer ${store.getters.token}` },
};

const tdRoles = ref([
  { value: "Tổng giám đốc ", name: "Tổng giám đốc " },
  { value: "Giám đốc", name: "Giám đốc" },
  { value: "Quản lý", name: "Quản lý" },
  { value: "Nhân viên", name: "Nhân viên" },
]);
const dpRoles = ref([
  { value: "Hội đồng quản trị" },
  { value: "Tài chính" },
  { value: "Kế toán" },
  { value: "Nhân sự" },
  { value: "Marketing" },
]);
const isQuyen = ref([
  { value: 0, name: "Không có quyền (0)" },
  { value: 1, name: "Xem cá nhân (1)" },
  { value: 2, name: "Xem tất cả (2)" },
  { value: 3, name: "Chỉnh sửa cá nhân (3)" },
  { value: 4, name: "Chỉnh sửa tất cả (4)" },
  { value: 5, name: "Duyệt (5)" },
  { value: 6, name: "Full (6)" },
]);
const menuButs = ref();
const menuButMores = ref();
const itemButs = ref([
  {
    label: "Xuất Excel",
    icon: "pi pi-file-excel",
    command: (event) => {
      exportUser("ExportExcel");
    },
  },
]);
const itemButMores = ref([
  {
    label: "Sửa User",
    icon: "pi pi-user-edit",
    command: (event) => {
      editUser(user.value);
    },
  },

  {
    label: "Xoá User",
    icon: "pi pi-trash",
    command: (event) => {
      delUser(user.value);
    },
  },
]);

//Khai báo function
const toggleExport = (event) => {
  menuButs.value.toggle(event);
};
const toggleMores = (event, u) => {
  user.value = u;
  menuButMores.value.toggle(event);
};

const handleFileUpload = (event) => {
  files = event.target.files;
  var output = document.getElementById("userAnh");
  output.src = URL.createObjectURL(event.target.files[0]);
  output.onload = function () {
    URL.revokeObjectURL(output.src); // free memory
  };
};
const headerUser = ref();
//Show Modal
const showModalAddUser = (header) => {
  submitted.value = false;
  headerUser.value = header;
  selectCapcha.value = {};
  user.value = {
    IsAdmin: false,
    Avatar: null,
  };
  displayAddUser.value = true;
};
const chonanh = (id) => {
  document.getElementById(id).click();
};
const closedisplayAddUser = () => {
  displayAddUser.value = false;
};
//Thêm sửa xoá
const onRefersh = () => {
  options.value = {
    search: "",
    PageNo: 1,
    PageSize: 8,
    FilterUserName: null,
  };
  loadUser(true);
};
const onSearch = () => {
  options.value.PageNo = 1;
  options.value.PageSize = 8;
  loadUser(true);
};
const donvis = ref();
const treedonvis = ref();
const selectCapcha = ref();
const loadCount = () => {
  axios
    .post(
      baseURL + "/api/Proc/CallProc",
      {
        proc: "Users_Count",
        par: [
          { par: "Search", va: options.value.search },
          { par: "UserName", va: options.value.UserName },
          { par: "IsAdmin", va: options.value.IsAdmin },
        ],
      },
      config
    )
    .then((response) => {
      let data = JSON.parse(response.data.data)[0];
      if (data.length > 0) {
        options.value.totalRecords = data[0].totalRecords;
      }
    })
    .catch((error) => {});
};
const onPage = (event) => {
  options.value.PageNo = event.page + 1;
  options.value.PageSize = event.rows;
  loadUser(true);
};
const loadUser = (rf) => {
  if(store.state.user.IsQuyen>3){
  if (rf) {
    options.value.loading = true;
    swal.fire({
      width: 110,
      didOpen: () => {
        swal.showLoading();
      },
    });
    if (options.value.PageNo == 1) loadCount();
  }
  axios
    .post(
      baseURL + "/api/Proc/CallProc",
      {
        proc: "Users_List",
        par: [
          { par: "Search", va: options.value.search },
          { par: "UserName", va: options.value.UserName },
          { par: "IsAdmin", va: options.value.IsAdmin },
          { par: "PageNo", va: options.value.PageNo },
          { par: "PageSize", va: options.value.PageSize },
        ],
      },
      config
    )
    .then((response) => {
      let data = JSON.parse(response.data.data)[0];
      if (data.length > 0) {
        console.log("Dữ liệu", data);
        users.value = data;
      } else {
        users.value = [];
      }
      if (isFirst.value) isFirst.value = false;
      if (rf) {
        options.value.loading = false;
        swal.close();
      }
    })
    .catch((error) => {
      console.log(error);
      if (error && error.status === 401) {
        swal.fire({
          title: "Error!",
          text: "Mã token đã hết hạn hoặc không hợp lệ, vui lòng đăng nhập lại!",
          icon: "error",
          confirmButtonText: "OK",
        });
      }
    });
  }
  else{
    console.log("ss");
    axios
    .post(
      baseURL + "/api/Proc/CallProc",
      {
        proc: "Users_Get",
        par: [
         
          { par: "UserName", va: store.state.user.UserName },
         
        ],
      },
      config
    )
    .then((response) => {
      let data = JSON.parse(response.data.data)[0];
        console.log("Dữ liệu", data);
        user.value = data[0];
        options.value.loading = false;
        isAdd.value=false;
        swal.close();
      
    })
    .catch((error) => {
      console.log(error);
      if (error && error.status === 401) {
        swal.fire({
          title: "Error!",
          text: "Mã token đã hết hạn hoặc không hợp lệ, vui lòng đăng nhập lại!",
          icon: "error",
          confirmButtonText: "OK",
        });
      }
    });
  }
};
const editUser = (md) => {
  submitted.value = false;
  isAdd.value = false;
  headerUser.value = "Cập nhật thông tin";
  swal.fire({
    width: 110,
    didOpen: () => {
      swal.showLoading();
    },
  });
  displayAddUser.value = true;
  axios
    .post(
      baseURL + "/api/Proc/CallProc",
      {
        proc: "Users_List",
        par: [
          { par: "Search", va: null },
          { par: "UserName", va: md.UserName },
          { par: "IsAdmin", va: null },
        ],
      },
      config
    )
    .then((response) => {
      swal.close();
      let data = JSON.parse(response.data.data);
      if (data.length > 0) {
        user.value = data[0][0];
      }
    })
    .catch((error) => {
      if (error.status === 401) {
        swal.fire({
          title: "Error!",
          text: "Mã token đã hết hạn hoặc không hợp lệ, vui lòng đăng nhập lại!",
          icon: "error",
          confirmButtonText: "OK",
        });
      }
    });
};
const handleSubmit = (isFormValid) => {
  submitted.value = true;
  if (!isFormValid) {
    return;
  }
  addUser();
};
const addUser = () => {
  let formData = new FormData();
  for (var i = 0; i < files.length; i++) {
    let file = files[i];
    formData.append("anh", file);
  }
  formData.append("user", JSON.stringify(user.value));
  swal.fire({
    width: 110,
    didOpen: () => {
      swal.showLoading();
    },
  });
  axios({
    method: isAdd.value == false ? "put" : "post",
    url:
      baseURL +
      `/api/Users/${isAdd.value == false ? "Update_Users" : "Add_Users"}`,
    data: formData,
    headers: {
      Authorization: `Bearer ${store.getters.token}`,
    },
  })
    .then((response) => {
      if (response.data.err != "1") {
        swal.close();
        toast.success("Cập nhật User thành công!");
        loadUser();
        closedisplayAddUser();
      } else {
        swal.fire({
          title: "Error!",
          text: response.data.ms,
          icon: "error",
          confirmButtonText: "OK",
        });
      }
    })
    .catch((error) => {
      swal.close();
      swal.fire({
        title: "Error!",
        text: "Có lỗi xảy ra, vui lòng kiểm tra lại!",
        icon: "error",
        confirmButtonText: "OK",
      });
    });
};

const delUser = (md) => {
  swal
    .fire({
      title: "Thông báo",
      text: "Bạn có muốn xoá người dùng này không!",
      icon: "warning",
      showCancelButton: true,
      confirmButtonColor: "#3085d6",
      cancelButtonColor: "#d33",
      confirmButtonText: "Có",
      cancelButtonText: "Không",
    })
    .then((result) => {
      if (result.isConfirmed) {
        swal.fire({
          width: 110,
          didOpen: () => {
            swal.showLoading();
          },
        });
        axios
          .delete(baseURL + "/api/Users/Del_Users", {
            headers: { Authorization: `Bearer ${store.getters.token}` },
            data: md != null ? [md.UserName] : selectedNodes.value,
          })
          .then((response) => {
            swal.close();
            if (response.data.err != "1") {
              swal.close();
              toast.success("Xoá User thành công!");
              loadUser();
              if (!md) selectedNodes.value = [];
            } else {
              swal.fire({
                title: "Error!",
                text: response.data.ms,
                icon: "error",
                confirmButtonText: "OK",
              });
            }
          })
          .catch((error) => {
            swal.close();
            if (error.status === 401) {
              swal.fire({
                title: "Error!",
                text: "Mã token đã hết hạn hoặc không hợp lệ, vui lòng đăng nhập lại!",
                icon: "error",
                confirmButtonText: "OK",
              });
            }
          });
      }
    });
};

const exportUser = (method) => {
  swal.fire({
    width: 110,
    didOpen: () => {
      swal.showLoading();
    },
  });
  axios
    .post(
      baseURL + "/api/Excel/" + method,
      {
        excelname: "DANH SÁCH NGƯỜI DÙNG",
        proc: "Users_ListExport",
        par: [],
      },
      config
    )
    .then((response) => {
      swal.close();
      if (response.data.err != "1") {
        swal.close();
        toast.success("Kết xuất Data thành công!");
        window.open(baseURL + response.data.path);
      } else {
        swal.fire({
          title: "Error!",
          text: response.data.ms,
          icon: "error",
          confirmButtonText: "OK",
        });
      }
    })
    .catch((error) => {
      if (error.status === 401) {
        swal.fire({
          title: "Error!",
          text: "Mã token đã hết hạn hoặc không hợp lệ, vui lòng đăng nhập lại!",
          icon: "error",
          confirmButtonText: "OK",
        });
      }
    });
};

const displayPhongban = ref(false);
onMounted(() => {
  //init
  loadUser(true);
});
</script>
<template>
  <div
    class="main-layout flex-grow-1"
    style="height: calc(100vh - 52px)"
    v-if="store.getters.islogin"
  >
    <div v-if="store.state.user.IsQuyen > 3">
      <DataView
        v-if="!displayPhongban"
        class="w-full h-full e-sm flex flex-column"
        :lazy="true"
        :value="users"
        :layout="layout"
        :loading="options.loading"
        :paginator="true"
        :rows="options.PageSize"
        :totalRecords="options.totalRecords"
        :pageLinkSize="options.PageSize"
        @page="onPage($event)"
        paginatorTemplate="FirstPageLink PrevPageLink PageLinks NextPageLink LastPageLink  RowsPerPageDropdown"
        :rowsPerPageOptions="[8, 12, 20, 50, 100]"
        currentPageReportTemplate=""
        responsiveLayout="scroll"
        :scrollable="true"
      >
        <template #header>
          <h3 class="module-title mt-0 ml-1 mb-2">
            <i class="pi pi-users"></i> Người dùng
            <span v-if="options.totalRecords > 0"
              >({{ options.totalRecords }})</span
            >
          </h3>
          <Toolbar class="w-full custoolbar">
            <template #start>
              <span class="p-input-icon-left ml-2">
                <i class="pi pi-search" />
                <InputText
                  type="text"
                  class="p-inputtext-sm"
                  spellcheck="false"
                  v-model="options.search"
                  placeholder="Tìm kiếm"
                  v-on:keyup.enter="onSearch"
                />
              </span>
            </template>

            <template #end>
              <DataViewLayoutOptions v-model="layout" />

              <Button
                class="
                  mr-2
                  ml-2
                  p-button-sm p-button-outlined p-button-secondary
                "
                icon="pi pi-refresh"
                @click="onRefersh"
              />
              <Button
                label="Xoá"
                icon="pi pi-trash"
                class="mr-2 p-button-danger"
                v-if="selectedNodes.length > 0"
                @click="delUser"
              />
              <Button
                label="Export"
                icon="pi pi-file-excel"
                class="mr-2 p-button-sm p-button-outlined p-button-secondary"
                @click="toggleExport"
                aria-haspopup="true"
                aria-controls="overlay_Export"
              />
              <Menu
                id="overlay_Export"
                ref="menuButs"
                :model="itemButs"
                :popup="true"
              />
              <Button
                label="Thêm người dùng"
                icon="pi pi-plus"
                class="mr-2 p-button-sm"
                @click="showModalAddUser('Thêm người dùng')"
              />
            </template>
          </Toolbar>
        </template>
        <template #grid="slotProps">
          <div class="col-12 md:col-3 p-2">
            <Card class="no-paddcontent">
              <template #title>
                <div style="position: relative">
                  <div
                    class="
                      align-items-center
                      justify-content-center
                      text-center
                    "
                  >
                    <Avatar
                      label=""
                      v-bind:image="
                        slotProps.data.Avatar
                          ? basedomainURL + slotProps.data.Avatar
                          : '/src/assets/image/noimg.jpg'
                      "
                      style="
                        background-color: #2196f3;
                        color: #ffffff;
                        width: 5rem;
                        height: 5rem;
                      "
                      class="mr-2 text-600"
                      size="large"
                      shape="circle"
                    />
                  </div>
                  <Button
                    style="position: absolute; right: 0px; top: 0px"
                    icon="pi pi-ellipsis-h"
                    class="p-button-rounded p-button-text ml-2"
                    @click="toggleMores($event, slotProps.data)"
                    aria-haspopup="true"
                    aria-controls="overlay_More"
                  />
                  <Menu
                    id="overlay_More"
                    ref="menuButMores"
                    :model="itemButMores"
                    :popup="true"
                  />
                </div>
              </template>
              <template #content>
                <div class="text-center">
                  <Button
                    class="p-button-text m-auto block"
                    style="color: inherit"
                    ><h3 class="m-0">
                      {{ slotProps.data.Name }}
                    </h3></Button
                  >
                </div>
              </template>
            </Card>
          </div>
        </template>
        <template #list="slotProps">
          <div class="p-2 w-full" style="background-color: #fff">
            <div class="flex align-items-center justify-content-center">
              <Avatar
                label=""
                v-bind:image="
                  slotProps.data.Avatar
                    ? basedomainURL + slotProps.data.Avatar
                    : '/src/assets/image/noimg.jpg'
                "
                style="background-color: #2196f3; color: #ffffff"
                class="mr-2"
                size="large"
                shape="circle"
              />
              <div class="flex flex-column flex-grow-1">
                <Button
                  class="p-button-text p-0"
                  style="color: inherit; padding: 0 !important"
                  @click="editUser(slotProps.data)"
                  ><h3 class="mb-1 mt-0">
                    {{ slotProps.data.Name }}
                  </h3></Button
                >
                <i style="font-size: 10pt; color: #999"
                  >{{ slotProps.data.UserName }} |
                  {{ slotProps.data.PhoneNumber }}</i
                >
                <i style="font-size: 10pt; color: #999">{{
                  slotProps.data.Email
                }}</i>
              </div>
              <Button
                icon="pi pi-ellipsis-h"
                class="p-button-outlined p-button-secondary ml-2"
                @click="toggleMores($event, slotProps.data)"
                aria-haspopup="true"
                aria-controls="overlay_More"
              />
              <Menu
                id="overlay_More"
                ref="menuButMores"
                :model="itemButMores"
                :popup="true"
              />
            </div>
          </div>
        </template>
        <template #empty>
          <div
            class="align-items-center justify-content-center p-4 text-center"
            v-if="!isFirst"
          >
            <img src="../../assets/background/nodata.png" height="144" />
            <h3 class="m-1">Không có dữ liệu</h3>
          </div>
        </template>
      </DataView>
    </div>
    <div v-else>
      <form @submit.prevent="handleSubmit(!v$.$invalid)">
        <div class="grid formgrid m-2 p-8">
          <div class="field col-12 md:col-12">
            <label class="col-2 text-left"
              >Mã <span class="redsao">(*)</span></label
            >
            <InputText
              spellcheck="false"
              v-bind:disabled="true"
              class="col-10 ip36"
              v-model="user.UserCode"
              :class="{ 'p-invalid': v$.UserCode.$invalid && submitted }"
            />
          </div>
          <small
            v-if="
              (v$.UserCode.$invalid && submitted) ||
              v$.UserCode.$pending.$response
            "
            class="col-10 p-error"
          >
            <div class="field col-12 md:col-12">
              <label class="col-2 text-left"></label>
              <span class="col-10 pl-3">{{
                v$.UserCode.required.$message
                  .replace("Value", "Mã người dùng")
                  .replace("is required", "không được để trống")
              }}</span>
            </div></small
          >
          <div class="field col-12 md:col-12">
            <label class="col-2 text-left"
              >Họ tên <span class="redsao">(*)</span></label
            >
            <InputText
              spellcheck="false"
              class="col-10 ip36"
              v-model="user.Name"
              :class="{ 'p-invalid': v$.Name.$invalid && submitted }"
            />
          </div>
          <small
            v-if="(v$.Name.$invalid && submitted) || v$.Name.$pending.$response"
            class="col-10 p-error"
          >
            <div class="field col-12 md:col-12">
              <label class="col-2 text-left"></label>
              <span class="col-10 pl-3">{{
                v$.Name.required.$message
                  .replace("Value", "Tên người dùng")
                  .replace("is required", "không được để trống")
              }}</span>
            </div></small
          >
          <div class="field col-12 md:col-12">
            <label class="col-2 text-left"
              >Username <span class="redsao">(*)</span></label
            >
            <InputText
              spellcheck="false"
              class="col-10 ip36"
              v-model="user.UserName"
              :class="{ 'p-invalid': v$.UserName.$invalid && submitted }"
            />
          </div>
          <small
            v-if="
              (v$.UserName.$invalid && submitted) ||
              v$.UserName.$pending.$response
            "
            class="col-10 p-error"
          >
            <div class="field col-12 md:col-12">
              <label class="col-2 text-left"></label>
              <span class="col-10 pl-3">{{
                v$.UserName.required.$message
                  .replace("Value", "Tên đăng nhập")
                  .replace("is required", "không được để trống")
              }}</span>
            </div></small
          >
          <div class="field col-12 md:col-12">
            <label class="col-2 text-left"
              >Password <span class="redsao">(*)</span></label
            >
            <Password
              :class="{ 'p-invalid': v$.Password.$invalid && submitted }"
              v-model="user.Password"
              toggleMask
            >
              <template #header>
                <h6>Chọn mật khẩu</h6>
              </template>
              <template #footer="sp">
                {{ sp.level }}
                <Divider />
                <p class="mt-2">Gợi ý</p>
                <ul class="pl-2 ml-2 mt-0" style="line-height: 1.5">
                  <li>Có ít nhất 1 chữ thường</li>
                  <li>Có ít nhất 1 chữ hoa</li>
                  <li>Có ít nhất 1 ký tự số</li>
                  <li>Tối thiểu 8 ký tự</li>
                </ul>
              </template>
            </Password>
            <small
              v-if="
                (v$.Password.$invalid && submitted) ||
                v$.Password.$pending.$response
              "
              class="col-10 p-error"
            >
              <div class="field col-12 md:col-12">
                <label class="col-2 text-left"></label>
                <span class="col-10 pl-3">{{
                  v$.Password.required.$message
                    .replace("Value", "Mật khẩu")
                    .replace("is required", "không được để trống")
                }}</span>
              </div></small
            >
          </div>
          <div class="field col-12 md:col-12">
            <label class="col-2 text-left">Chức vụ</label>
            <Dropdown
              class="col-10"
              v-model="user.Position"
              :disabled="true"
              :options="tdRoles"
              optionLabel="name"
              optionValue="value"
              placeholder="Chọn chức vụ"
            />
          </div>
          <div class="field col-12 md:col-12">
            <label class="col-2 text-left">Phòng ban</label>
            <Dropdown
              class="col-10"
              v-model="user.DepartmentName"
              :disabled="true"
              :options="dpRoles"
              optionLabel="value"
              optionValue="value"
              placeholder="Chọn phòng ban"
            />
          </div>

          <div class="col-8">
            <div class="field">
              <label class="col-3 text-left">SĐT</label>
              <InputText
                class="col-9 ip36"
                spellcheck="false"
                v-model="user.PhoneNumber"
              />
            </div>
            <div class="field">
              <label class="col-3 text-left">Email</label>
              <InputText
                class="col-9 ip36"
                spellcheck="false"
                v-model="user.Email"
              />
            </div>
          </div>
          <div class="col-4">
            <div class="field">
              <label class="col-12 text-left p-0">Ảnh đại diện</label>
              <div class="inputanh" @click="chonanh('AnhUser')">
                <img
                  id="userAnh"
                  v-bind:src="
                    user.Avatar
                      ? basedomainURL + user.Avatar
                      : '/src/assets/image/noimg.jpg'
                  "
                />
              </div>
              <input
                class="ipnone"
                id="AnhUser"
                type="file"
                accept="image/*"
                @change="handleFileUpload"
              />
            </div>
          </div>
          <div class="col-12 text-center">
          
                  <Button
                    label="Lưu"
                    icon="pi pi-save"
                    @click="handleSubmit(!v$.$invalid)"
                  />
          </div>
        </div>
      </form>
    </div>
  </div>
  <Dialog
    :header="headerUser"
    v-model:visible="displayAddUser"
    :style="{ width: '760px', zIndex: 1000 }"
    :maximizable="true"
    :autoZIndex="false"
    :modal="true"
  >
    <form @submit.prevent="handleSubmit(!v$.$invalid)">
      <div class="grid formgrid m-2">
        <div class="field col-12 md:col-12">
          <label class="col-2 text-left"
            >Mã <span class="redsao">(*)</span></label
          >
          <InputText
            spellcheck="false"
            v-bind:disabled="!isAdd"
            class="col-10 ip36"
            v-model="user.UserCode"
            :class="{ 'p-invalid': v$.UserCode.$invalid && submitted }"
          />
        </div>
        <small
          v-if="
            (v$.UserCode.$invalid && submitted) ||
            v$.UserCode.$pending.$response
          "
          class="col-10 p-error"
        >
          <div class="field col-12 md:col-12">
            <label class="col-2 text-left"></label>
            <span class="col-10 pl-3">{{
              v$.UserCode.required.$message
                .replace("Value", "Mã người dùng")
                .replace("is required", "không được để trống")
            }}</span>
          </div></small
        >
        <div class="field col-12 md:col-12">
          <label class="col-2 text-left"
            >Họ tên <span class="redsao">(*)</span></label
          >
          <InputText
            spellcheck="false"
            class="col-10 ip36"
            v-model="user.Name"
            :class="{ 'p-invalid': v$.Name.$invalid && submitted }"
          />
        </div>
        <small
          v-if="(v$.Name.$invalid && submitted) || v$.Name.$pending.$response"
          class="col-10 p-error"
        >
          <div class="field col-12 md:col-12">
            <label class="col-2 text-left"></label>
            <span class="col-10 pl-3">{{
              v$.Name.required.$message
                .replace("Value", "Tên người dùng")
                .replace("is required", "không được để trống")
            }}</span>
          </div></small
        >
        <div class="field col-12 md:col-12">
          <label class="col-2 text-left"
            >Username <span class="redsao">(*)</span></label
          >
          <InputText
            spellcheck="false"
            class="col-10 ip36"
            v-model="user.UserName"
            :class="{ 'p-invalid': v$.UserName.$invalid && submitted }"
          />
        </div>
        <small
          v-if="
            (v$.UserName.$invalid && submitted) ||
            v$.UserName.$pending.$response
          "
          class="col-10 p-error"
        >
          <div class="field col-12 md:col-12">
            <label class="col-2 text-left"></label>
            <span class="col-10 pl-3">{{
              v$.UserName.required.$message
                .replace("Value", "Tên đăng nhập")
                .replace("is required", "không được để trống")
            }}</span>
          </div></small
        >
        <div class="field col-12 md:col-12">
          <label class="col-2 text-left"
            >Password <span class="redsao">(*)</span></label
          >
          <Password
            :class="{ 'p-invalid': v$.Password.$invalid && submitted }"
            v-model="user.Password"
            toggleMask
          >
            <template #header>
              <h6>Chọn mật khẩu</h6>
            </template>
            <template #footer="sp">
              {{ sp.level }}
              <Divider />
              <p class="mt-2">Gợi ý</p>
              <ul class="pl-2 ml-2 mt-0" style="line-height: 1.5">
                <li>Có ít nhất 1 chữ thường</li>
                <li>Có ít nhất 1 chữ hoa</li>
                <li>Có ít nhất 1 ký tự số</li>
                <li>Tối thiểu 8 ký tự</li>
              </ul>
            </template>
          </Password>
          <small
            v-if="
              (v$.Password.$invalid && submitted) ||
              v$.Password.$pending.$response
            "
            class="col-10 p-error"
          >
            <div class="field col-12 md:col-12">
              <label class="col-2 text-left"></label>
              <span class="col-10 pl-3">{{
                v$.Password.required.$message
                  .replace("Value", "Mật khẩu")
                  .replace("is required", "không được để trống")
              }}</span>
            </div></small
          >
        </div>
        <div class="field col-12 md:col-12">
          <label class="col-2 text-left">Chức vụ</label>
          <Dropdown
            class="col-10"
            v-model="user.Position"
            :options="tdRoles"
            optionLabel="name"
            optionValue="value"
            placeholder="Chọn chức vụ"
          />
        </div>
        <div class="field col-12 md:col-12">
          <label class="col-2 text-left">Phòng ban</label>
          <Dropdown
            class="col-10"
            v-model="user.DepartmentName"
            :options="dpRoles"
            optionLabel="value"
            optionValue="value"
            placeholder="Chọn phòng ban"
          />
        </div>

        <div class="col-8">
          <div class="field">
            <label class="col-3 text-left">SĐT</label>
            <InputText
              class="col-9 ip36"
              spellcheck="false"
              v-model="user.PhoneNumber"
            />
          </div>
          <div class="field">
            <label class="col-3 text-left">Email</label>
            <InputText
              class="col-9 ip36"
              spellcheck="false"
              v-model="user.Email"
            />
          </div>
          <div class="field">
            <label style="vertical-align: text-bottom" class="col-3 text-left"
              >Admin</label
            >
            <InputSwitch class="col-2" v-model="user.IsAdmin" />
            <label
              v-if="!user.IsAdmin"
              style="vertical-align: text-bottom"
              class="col-2 text-center"
              >Quyền</label
            >
            <Dropdown
              v-if="!user.IsAdmin"
              style="vertical-align: text-bottom"
              class="col-5 p-0 ml-3"
              v-model="user.DepartmentName"
              :options="isQuyen"
              optionLabel="name"
              optionValue="value"
              placeholder="Phân quyền"
            />
          </div>
        </div>
        <div class="col-4">
          <div class="field">
            <label class="col-12 text-left p-0">Ảnh đại diện</label>
            <div class="inputanh" @click="chonanh('AnhUser')">
              <img
                id="userAnh"
                v-bind:src="
                  user.Avatar
                    ? basedomainURL + user.Avatar
                    : '/src/assets/image/noimg.jpg'
                "
              />
            </div>
            <input
              class="ipnone"
              id="AnhUser"
              type="file"
              accept="image/*"
              @change="handleFileUpload"
            />
          </div>
        </div>
      </div>
    </form>
    <template #footer>
      <Button
        label="Huỷ"
        icon="pi pi-times"
        @click="closedisplayAddUser"
        class="p-button-raised p-button-secondary"
      />
      <Button
        label="Lưu"
        icon="pi pi-save"
        @click="handleSubmit(!v$.$invalid)"
      />
    </template>
  </Dialog>
</template>
<style scoped>
.p-chip.custom-chip {
  background: var(--primary-color);
  color: var(--primary-color-text);
  font-size: 00.875rem;
}
.p-chip.chip-success {
  background: #689f38;
}
.p-chip.chip-danger {
  background: #d32f2f;
}
.p-chip.chip-warning {
  background: #fbc02d;
}
.chippb {
  background-color: #4285f4;
  color: #fff;
  font-size: 0.875rem;
}
.ipnone {
  display: none;
}
.inputanh {
  border: 1px solid #ccc;
  width: 96px;
  height: 96px;
  cursor: pointer;
  padding: 1px;
}
.inputanh img {
  object-fit: cover;
  width: 100%;
  height: 100%;
}
.roletrue {
  background-color: orange;
  padding: 5px 10px;
  margin: 5px auto;
  width: max-content;
  border-radius: 5px;
  margin-bottom: 10px;
  height: fit-content;
  color: #fff;
  font-size: 0.875rem;
}
.rolefalse {
  background-color: #eee;
  padding: 5px 10px;
  margin: 5px auto;
  width: max-content;
  border-radius: 5px;
  margin-bottom: 10px;
  height: fit-content;
  font-size: 0.875rem;
}
</style>
