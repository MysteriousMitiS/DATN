<script setup>
import { ref, inject, onMounted, watch } from "vue";
import { useToast } from "vue-toastification";
import { required } from "@vuelidate/validators";
import { useVuelidate } from "@vuelidate/core";
import moment from "moment";
import { useRouter, useRoute } from "vue-router";
//Khai báo
const router = useRouter();
const route = useRoute();
const axios = inject("axios");
const store = inject("store");
const swal = inject("$swal");
const toast = useToast();
const Project = ref({
  ProjectCode: "",
  ProjectName: "",
  ProjectStatus: 0,
  ProjectStart: null,
  ProjectEnd: null,
  ProjectCompleted: null,
  ProjectDescription: "",
});
const Stage = ref({
  StageCode: "",
  StageTarget: "",
  StageStatus: 0,
  StageStart: null,
  StageEnd: null,
  StageCompleted: null,
  StageDescription: "",
});

const rules = {
  ProjectCode: {
    required,
    $errors: [
      {
        $property: "ProjectCode",
        $validator: "required",
        $message: "Mã dự án không được để trống!",
      },
    ],
  },
  ProjectName: {
    required,
    $errors: [
      {
        $property: "ProjectName",
        $validator: "required",
        $message: "Tên dự án không được để trống!",
      },
    ],
  },
};
const v$ = useVuelidate(rules, Project);
const config = {
  headers: { Authorization: `Bearer ${store.getters.token}` },
};
const projects = ref();

const isFirst = ref(true);
const basedomainURL = baseURL;
const options = ref({
  SearchText: "",
  searchTextStage: "",
  loading: true,
  PageSize: 10,
  loading: true,
});
const pStatus = ref([
  { name: "Chưa hoàn thành", code: 0 },
  { name: "Đã hoàn thành", code: 1 },
  { name: "Không hoàn thành", code: -1 },
]);
const checkImage = ref(false);
const expandedRows = ref([]);
const displayBasic = ref(false);
const displayBasic1 = ref(false);
const headerDialog = ref();
const headerDialog1 = ref();
const checkLang = ref(true);
const checkPagenator = ref(false);
const showThumbnails = ref(false);
const images = ref([]);
const submitted = ref(false);
const isSaveProject = ref(false);
const isSaveStage = ref(false);
const selectedProjects = ref();
const selectedStage = ref();
const checkSlideShowImg = ref(false);
const isShowBtnAdd = ref(true);
const isDeleteListSlide = ref(false);
const isDeleteListImg = ref(false);
const checkTrangthai = ref(false);
//Method
const showWork = (data) => {
  store.commit("setIdStage", data.StageId);
  store.commit("setCheckStage", true);
  router.push({
    name: "work",
  });
};
//thêm ảnh
const saveStage = () => {
  if (!isSaveStage.value) {
    axios
      .post(baseURL + "/api/Stages/AddStage", Stage.value, config)
      .then((response) => {
        if (response.data.err != "1") {
          swal.close();
          toast.success("Thêm giai đoạn thành công!");
          loadProjectData(true);
          closeDialog1();
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
  } else {
    if (typeof Stage.value.StageStart == "string") {
      var startDay = Stage.value.StageStart.split("/");
      Stage.value.StageStart = new Date(
        startDay[2] + "/" + startDay[1] + "/" + startDay[0]
      );
    }
    if (typeof Stage.value.StageStart == "string") {
      var startDay = Stage.value.StageStart.split("/");
      Stage.value.StageStart = new Date(
        startDay[2] + "/" + startDay[1] + "/" + startDay[0]
      );
    }
    if (typeof Stage.value.StageEnd == "string") {
      var startDay = Stage.value.StageEnd.split("/");
      Stage.value.StageEnd = new Date(
        startDay[2] + "/" + startDay[1] + "/" + startDay[0]
      );
    }
    if (typeof Stage.value.StageCompleted == "string") {
      var startDay = Stage.value.StageCompleted.split("/");
      Stage.value.StageCompleted = new Date(
        startDay[2] + "/" + startDay[1] + "/" + startDay[0]
      );
    }

    axios
      .put(baseURL + "/api/Stages/UpdateStage", Stage.value, config)
      .then((response) => {
        if (response.data.err != "1") {
          swal.close();
          toast.success("Sửa giai đoạn thành công!");

          loadProjectData(true);
          closeDialog1();
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
  }
};
// Tìm ảnh
const searchStage = (value) => {
  (async () => {
    const res = await axios
      .post(
        baseURL + "/api/Proc/CallProc",
        {
          proc: "Project_List",
          par: [{ par: "m_SearchText", va: options.value.SearchText }],
        },
        config
      )
      .then((response) => {
        let data = JSON.parse(response.data.data)[0];
        if (isFirst.value) isFirst.value = false;
        options.value.loading = false;
        return data;
      })
      .catch((error) => {
        toast.error("Tải dữ liệu không thành công!");
        options.value.loading = false;

        if (error && error.status === 401) {
          swal.fire({
            title: "Error!",
            text: "Mã token đã hết hạn hoặc không hợp lệ, vui lòng đăng nhập lại!",
            icon: "error",
            confirmButtonText: "OK",
          });
          store.commit("gologout");
        }
      });
    const res1 = await axios
      .post(
        baseURL + "/api/Proc/CallProc",
        {
          proc: "Stage_ListWithId",
          par: [
            { par: "m_SearchText", va: options.value.searchTextStage },
            { par: "Id", va: value.ProjectId },
          ],
        },
        config
      )
      .then((response) => {
        let data = JSON.parse(response.data.data)[0];
        if (isFirst.value) isFirst.value = false;
        options.value.loading = false;
        return data;
      })
      .catch((error) => {
        toast.error("Tải dữ liệu không thành công!");
        options.value.loading = false;

        if (error && error.status === 401) {
          swal.fire({
            title: "Error!",
            text: "Mã token đã hết hạn hoặc không hợp lệ, vui lòng đăng nhập lại!",
            icon: "error",
            confirmButtonText: "OK",
          });
          store.commit("gologout");
        }
      });
    renderTree(res, res1);
    options.value.loading = false;
  })();
};
//Xóa bản ghi
const deleleProject = (project2) => {
  swal
    .fire({
      title: "Thông báo",
      text: "Bạn có muốn xoá dự án này không!",
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
          .delete(baseURL + "/api/Projects/DeleteProject", {
            headers: { Authorization: `Bearer ${store.getters.token}` },
            data: project2 != null ? [project2.ProjectId] : 1,
          })
          .then((response) => {
            swal.close();
            if (response.data.err != "1") {
              swal.close();
              toast.success("Xoá dự án thành công!");
              loadProjectData(true);
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
const deleteStage = (value) => {
  swal
    .fire({
      title: "Thông báo",
      text: "Bạn có muốn xoá giai đoạn này không!",
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
          .delete(baseURL + "/api/Stages/DeleteStage", {
            headers: { Authorization: `Bearer ${store.getters.token}` },
            data: value != null ? [value.StageId] : 1,
          })
          .then((response) => {
            swal.close();
            if (response.data.err != "1") {
              swal.close();
              toast.success("Xoá giai đoạn thành công!");
              loadProjectData(true);
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

//Xóa nhiều
const deleteListProject = () => {
  let listId = new Array(selectedProjects.length);

  swal
    .fire({
      title: "Thông báo",
      text: "Bạn có muốn xoá danh sách dự án này không!",
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
        selectedProjects.value.forEach((item) => {
          listId.push(item.ProjectId);
        });
        axios
          .delete(baseURL + "/api/Projects/DeleteProject", {
            headers: { Authorization: `Bearer ${store.getters.token}` },
            data: listId != null ? listId : 1,
          })
          .then((response) => {
            swal.close();
            if (response.data.err != "1") {
              swal.close();
              toast.success("Xoá danh sách dự án thành công!");
              isDeleteListSlide.value = false;
              loadProjectData(true);
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
const deleteListStage = () => {
  let listId = new Array(selectedStage.length);

  swal
    .fire({
      title: "Thông báo",
      text: "Bạn có muốn xoá danh sách giai đoạn này không!",
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
        selectedStage.value.forEach((item) => {
          listId.push(item.StageId);
        });
        axios
          .delete(baseURL + "/api/Stages/DeleteStage", {
            headers: { Authorization: `Bearer ${store.getters.token}` },
            data: listId != null ? listId : 1,
          })
          .then((response) => {
            swal.close();
            if (response.data.err != "1") {
              swal.close();
              toast.success("Xoá danh sách giai đoạn thành công!");
              isDeleteListImg.value = false;
              loadProjectData(true);
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
watch(selectedProjects, () => {
  if (selectedProjects.value.length > 0) {
    isDeleteListSlide.value = true;
  } else {
    isDeleteListSlide.value = false;
  }
});
watch(selectedStage, () => {
  if (selectedStage.value.length > 0) {
    isDeleteListImg.value = true;
  } else {
    isDeleteListImg.value = false;
  }
});

watch(projects, () => {
  if (projects.value.length > options.value.PageSize) {
    checkPagenator.value = true;
  } else {
    checkPagenator.value = false;
  }
});
watch(
  () => store.getters.langid,
  function () {
    loadProjectData(true);
  }
);

//Xuất excel
const menuButs = ref();
const itemButs = ref([
  {
    label: "Xuất Excel",
    icon: "pi pi-file-excel",
    command: (event) => {
      exportData("ExportExcel");
    },
  },
]);
const toggleExport = (event) => {
  menuButs.value.toggle(event);
};
const exportData = (method) => {
  swal.fire({
    width: 110,
    didOpen: () => {
      swal.showLoading();
    },
  });
  axios
    .post(
      baseURL + "/api/Excel/ExportExcel",
      {
        excelname: "DANH SÁCH DỰ ÁN",
        proc: "Project_ListExport",
        par: [{ par: "Search", va: options.value.SearchText }],
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
        store.commit("gologout");
      }
    });
};

//Sửa bản ghi
const editProject = (project1) => {
  submitted.value = false;
  if (project1.ProjectStatus != null) {
    if (project1.ProjectStatus == "Chưa hoàn thành") {
      project1.ProjectStatus = 0;
    }
    if (project1.ProjectStatus == "Hoàn thành") {
      project1.ProjectStatus = 1;
    }
    if (project1.ProjectStatus == "Không hoàn thành") {
      project1.ProjectStatus = -1;
    }
  }
  Project.value = project1;
  headerDialog.value = "Sửa dự án";
  isSaveProject.value = true;
  displayBasic.value = true;
};
//Thêm slide
const saveProject = (isFormValid) => {
  submitted.value = true;
  
  if (!isFormValid) {
    return;
  }
  if (!isSaveProject.value) {
    axios
      .post(baseURL + "/api/Projects/AddProject", Project.value, config)
      .then((response) => {
        if (response.data.err != "1") {
          swal.close();
          toast.success("Thêm dự án thành công!");
          loadProjectData(true);
          closeDialog();
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
  } else {
    axios
      .put(baseURL + "/api/Projects/UpdateProject", Project.value, config)
      .then((response) => {
        if (response.data.err != "1") {
          swal.close();
          toast.success("Sửa dự án thành công!");
          loadProjectData(true);
          closeDialog();
        } else {
          console.log("LỖI A:", response);
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
  }
};

const listImages = ref([]);
const idImageSelected = ref(1);
const openBasic = (str) => {
  Project.value = {};
  headerDialog.value = str;
  submitted.value = false;
  checkLang.value = true;
  isSaveProject.value = false;
  displayBasic.value = true;
};
const idSlideShowSelected = ref();
const openBasic1 = (str, value, check) => {
  if (check) {
    Stage.value = {
      ProjectId: value.ProjectId,
      StageCode: "",
      StageTarget: "",
      StageStatus: 0,
      StageStart: null,
      StageEnd: null,
      StageCompleted: null,
      StageDescription: "",
    };
    isSaveStage.value = false;
  } else {
    if (value.StageStatus != null) {
      if (value.StageStatus == "Chưa hoàn thành") {
        value.StageStatus = 0;
      }
      if (value.StageStatus == "Hoàn thành") {
        value.StageStatus = 1;
      }
      if (value.StageStatus == "Không hoàn thành") {
        value.StageStatus = -1;
      }
    }

    Stage.value = value;
    Stage.value.StageCompleted = null;
    isSaveStage.value = true;
  }
  headerDialog1.value = str;
  displayBasic1.value = true;
};

const closeDialog = () => {
  displayBasic.value = false;
};
const closeDialog1 = () => {
  images.value = [];
  displayBasic1.value = false;
};

const renderTree = (Project, Stage) => {
  let arrChils = [];
  Project.forEach((item) => {
    Stage.filter((x) => x.ProjectId == item.ProjectId).forEach((m) => {
      if (!item.children) item.children = [];
      item.children.push(m);
    });
    arrChils.push(item);
  });
  projects.value = arrChils;
};
//Lấy dữ liệu SlideShow
const loadProjectData = (rf) => {
  if (rf) {
    (async () => {
      const res = await axios
        .post(
          baseURL + "/api/Proc/CallProc",
          {
            proc: "Project_List",
            par: [{ par: "m_SearchText", va: options.value.SearchText }],
          },
          config
        )
        .then((response) => {
          let data = JSON.parse(response.data.data)[0];

          if (isFirst.value) isFirst.value = false;
          options.value.loading = false;
          if (data.length > 0) {
            data.forEach((element) => {
              if (element.ProjectStart != null) {
                element.ProjectStart = moment(
                  new Date(element.ProjectStart)
                ).format("DD/MM/YYYY ");
              }
              if (element.ProjectEnd != null) {
                element.ProjectEnd = moment(
                  new Date(element.ProjectEnd)
                ).format("DD/MM/YYYY ");
              }
              if (element.ProjectCompleted != null) {
                element.ProjectCompleted = moment(
                  new Date(element.ProjectCompleted)
                ).format("DD/MM/YYYY ");
              }

              if (element.ProjectStatus != null) {
                if (element.ProjectStatus == 0) {
                  element.ProjectStatus = "Chưa hoàn thành";
                }
                if (element.ProjectStatus == 1) {
                  element.ProjectStatus = "Hoàn thành";
                }
                if (element.ProjectStatus == -1) {
                  element.ProjectStatus = "Không hoàn thành";
                }
              } else {
                element.ProjectStatus = "Chưa hoàn thành";
              }
            });
          }
          return data;
        })
        .catch((error) => {
          toast.error("Tải dữ liệu không thành công!");
          options.value.loading = false;

          if (error && error.status === 401) {
            swal.fire({
              title: "Error!",
              text: "Mã token đã hết hạn hoặc không hợp lệ, vui lòng đăng nhập lại!",
              icon: "error",
              confirmButtonText: "OK",
            });
            store.commit("gologout");
          }
        });
      const res1 = await axios
        .post(
          baseURL + "/api/Proc/CallProc",
          {
            proc: "Stage_List",
            par: [{ par: "m_SearchText", va: options.value.SearchText }],
          },
          config
        )
        .then((response) => {
          let data = JSON.parse(response.data.data)[0];

          if (isFirst.value) isFirst.value = false;
          options.value.loading = false;
          data.forEach((element) => {
            if (element.StageStart != null) {
              element.StageStart = moment(new Date(element.StageStart)).format(
                "DD/MM/YYYY "
              );
            }
            if (element.StageEnd != null) {
              element.StageEnd = moment(new Date(element.StageEnd)).format(
                "DD/MM/YYYY "
              );
            }
            if (element.StageCompleted != null) {
              element.StageCompleted = moment(
                new Date(element.StageCompleted)
              ).format("DD/MM/YYYY ");
            }
            if (element.StageStatus != null) {
              if (element.StageStatus == 0) {
                element.StageStatus = "Chưa hoàn thành";
              }
              if (element.StageStatus == 1) {
                element.StageStatus = "Hoàn thành";
              }
              if (element.StageStatus == -1) {
                element.StageStatus = "Không hoàn thành";
              }
            } else {
              element.StageStatus = "Chưa hoàn thành";
            }
          });

          return data;
        })
        .catch((error) => {
          toast.error("Tải dữ liệu không thành công!");
          options.value.loading = false;

          if (error && error.status === 401) {
            swal.fire({
              title: "Error!",
              text: "Mã token đã hết hạn hoặc không hợp lệ, vui lòng đăng nhập lại!",
              icon: "error",
              confirmButtonText: "OK",
            });
            store.commit("gologout");
          }
        });

      renderTree(res, res1);

      options.value.loading = false;
    })();
  }
};

onMounted(() => {
  loadProjectData(true);

  return {
    loadProjectData,
    projects,
  };
});
</script>

<template>
  <div class="d-container">
    <div class="d-lang-header">
      <h3 class="d-module-title"><i class="pi pi-bars"></i> Danh sách dự án</h3>
    </div>
    <Toolbar class="d-toolbar">
      <template #start>
        <span class="p-input-icon-left">
          <i class="pi pi-search" />
          <InputText
            v-model="options.SearchText"
            @keyup="loadProjectData(true)"
            type="text"
            spellcheck="false"
            placeholder="Tìm kiếm"
          />
        </span>
      </template>

      <template #end>
        <Button
          v-if="isDeleteListSlide"
          @click="deleteListProject"
          label="Xóa"
          icon="pi pi-trash"
          class="mr-2 p-button-danger"
        />
        <Button
          @click="openBasic('Thêm dự án')"
          label="Thêm dự án"
          icon="pi pi-plus"
          class="mr-2"
        />
        <Button
          class="mr-2 p-button-outlined p-button-secondary"
          icon="pi pi-refresh"
          @click="loadProjectData(true)"
        />

        <Button
          @click="toggleExport"
          label="Export"
          icon="pi pi-file-excel"
          class="mr-2 p-button-outlined p-button-secondary"
          aria-haspopup="true"
          aria-controls="overlay_Export"
        />

        <Menu
          id="overlay_Export"
          ref="menuButs"
          :model="itemButs"
          :popup="true"
        />
      </template>
    </Toolbar>

    <div class="d-lang-table">
      <DataTable
        :value="projects"
        dataKey="ProjectId"
        responsiveLayout="scroll"
        v-model:expandedRows="expandedRows"
        :paginator="checkPagenator"
        v-model:rows="options.PageSize"
        :loading="options.loading"
        paginatorTemplate="  FirstPageLink PrevPageLink PageLinks NextPageLink LastPageLink  RowsPerPageDropdown"
        :rowsPerPageOptions="[10, 20, 50, 100]"
        scrollHeight="flex"
        :scrollable="true"
        columnResizeMode="fit"
        v-model:selection="selectedProjects"
        :showGridlines="true"
      >
        <Column
          selectionMode="multiple"
          class="align-items-center justify-content-center text-center"
          headerStyle="text-align:center;max-width:70px;height:50px;"
          bodyStyle="text-align:center;max-width:70px"
        />
        <Column
          class="align-items-center justify-content-center text-center"
          headerStyle="text-align:center;max-width:70px;height:50px;"
          bodyStyle="text-align:center;max-width:70px"
          :expander="true"
        />
        <Column
          class="align-items-center justify-content-center text-center"
          headerStyle="text-align:center;max-width:150px;height:50px;"
          bodyStyle="text-align:center;max-width:150px"
          field="ProjectCode"
          header="Mã dự án"
          sortable
        ></Column>
        <Column
          sortable
          field="ProjectName"
          header="Tên dự án"
          headerStyle="height:50px;"
        ></Column>

        <Column
          headerStyle="text-align:center;max-width:150px;height:50px"
          bodyStyle="text-align:center;max-width:150px"
          class="align-items-center justify-content-center text-center"
          field="ProjectStart"
          header="Ngày bắt đầu"
        ></Column>

        <Column
          headerStyle="text-align:center;max-width:150px;height:50px"
          bodyStyle="text-align:center;max-width:150px"
          class="align-items-center justify-content-center text-center"
          field="ProjectEnd"
          header="Ngày kết thúc"
        ></Column>

        <Column
          headerStyle="text-align:center;max-width:200px;height:50px"
          bodyStyle="text-align:center;max-width:200px"
          class="align-items-center justify-content-center text-center"
          field="ProjectStatus"
          header="Trạng thái"
        ></Column>
        <Column
          headerStyle="text-align:center;height:50px;max-width:200px"
          bodyStyle="text-align:center;max-width:200px"
          class="align-items-center justify-content-center text-center"
          header="Chức năng"
        >
          <template #body="project">
            <Button
              @click="openBasic1('Thêm giai đoạn', project.data, true)"
              class="d-btn-function d-btn-add"
              type="button"
              icon="pi pi-plus-circle"
            ></Button>
            <Button
              @click="editProject(project.data)"
              class="d-btn-function d-btn-edit"
              type="button"
              icon="pi pi-pencil"
            ></Button>
            <Button
              @click="deleleProject(project.data)"
              class="d-btn-function d-btn-delete"
              type="button"
              icon="pi pi-trash"
            ></Button>
          </template>
        </Column>
        <template #expansion="slotProps">
          <div style="width: 100%" class="orders-subtable">
            <h2>Giai đoạn dự án</h2>
            <Toolbar class="d-toolbar-img">
              <template #start>
                <span class="p-input-icon-left">
                  <i class="pi pi-search" />
                  <InputText
                    v-model="options.searchTextStage"
                    @keyup="searchStage(slotProps.data)"
                    type="text"
                    spellcheck="false"
                    placeholder="Tìm kiếm"
                  />
                </span>
              </template>

              <template #end>
                <Button
                  v-if="isDeleteListImg"
                  @click="deleteListStage"
                  label="Xóa"
                  icon="pi pi-trash"
                  class="mr-2 p-button-danger"
                />
                <Button
                  @click="openBasic1('Thêm giai đoạn', slotProps.data, true)"
                  label="Thêm Giai đoạn"
                  icon="pi pi-plus"
                  class="mr-2"
                />
              </template>
            </Toolbar>
            <DataTable
              :value="slotProps.data.children"
              responsiveLayout="scroll"
              scrollHeight="flex"
              :scrollable="true"
              :showGridlines="true"
              columnResizeMode="fit"
              v-model:selection="selectedStage"
              class="w-full"
            >
              <Column
                selectionMode="multiple"
                class="align-items-center justify-content-center text-center"
                headerStyle="background-color:#B9D3EE;text-align:center;max-width:50px;height:50px"
                bodyStyle="background-color:#FFEFD5;text-align:center;max-width:50px"
              ></Column>

              <Column
                headerStyle="background-color:#B9D3EE; text-align:center;max-width:150px;height:50px"
                bodyStyle="background-color:#FFEFD5;text-align:center;max-width:150px"
                class="align-items-center justify-content-center text-center"
                field="StageCode"
                header="Giai đoạn"
                sortable
              ></Column>
              <Column
                headerStyle=" background-color:#B9D3EE;height:50px"
                body-style="background-color:#FFEFD5;"
                field="StageTarget"
                header="Mục tiêu"
                sortable
              ></Column>
              <Column
                headerStyle="background-color:#B9D3EE;text-align:center;max-width:150px;height:50px;"
                bodyStyle="background-color:#FFEFD5;text-align:center;max-width:150px"
                field="StageStart"
                header="Ngày bắt đầu"
              ></Column>
              <Column
                headerStyle="background-color:#B9D3EE;text-align:center;max-width:150px;height:50px;"
                bodyStyle="background-color:#FFEFD5;text-align:center;max-width:150px"
                field="StageEnd"
                header="Ngày kết thúc"
              ></Column>
              <Column
                headerStyle="background-color:#B9D3EE;text-align:center;max-width:200px;height:50px;"
                bodyStyle="background-color:#FFEFD5;text-align:center;max-width:200px"
                class="align-items-center justify-content-center text-center"
                field="StageStatus"
                header="Trạng thái"
              >
              </Column>
              <Column
                headerStyle="background-color:#B9D3EE;text-align:center;height:50px;max-width:300px"
                bodyStyle="background-color:#FFEFD5;text-align:center;max-width:300px"
                class="align-items-center justify-content-center text-center"
                field="StageDescription"
                header="Mô tả"
              ></Column>

              <Column
                headerStyle="background-color:#B9D3EE;text-align:center;max-width:200px;height:50px"
                bodyStyle="background-color:#FFEFD5;text-align:center;max-width:200px"
                header="Chức năng"
              >
                <template #body="data">
                  <Button
                    @click="showWork(data.data)"
                    class="d-btn-function d-btn-add"
                    type="button"
                    icon="pi pi-arrow-right"
                  ></Button>
                  <Button
                    @click="openBasic1('Sửa giai đoạn', data.data, false)"
                    class="d-btn-function d-btn-edit"
                    type="button"
                    icon="pi pi-pencil"
                  ></Button>
                  <Button
                    @click="deleteStage(data.data)"
                    class="d-btn-function d-btn-delete"
                    type="button"
                    icon="pi pi-trash"
                  ></Button>
                </template>
              </Column>
            </DataTable>
          </div>
        </template>
        <template #empty>
          <div
            class="
              align-items-center
              justify-content-center
              p-4
              text-center
              m-auto
            "
            v-if="!isFirst"
          >
            <img src="../../assets/background/nodata.png" height="144" />
            <h3 class="m-1">Không có dữ liệu</h3>
          </div>
        </template>
      </DataTable>
    </div>
  </div>

  <Dialog
    :header="headerDialog"
    v-model:visible="displayBasic"
    :style="{ width: '40vw' }"
    :maximizable="true"
  >
    <form>
      <div class="grid formgrid m-2">
        <div class="field col-12 md:col-12">
          <label class="col-12 text-left p-0"
            >Mã dự án <span class="redsao">(*)</span></label
          >
          <InputText
            v-model="Project.ProjectCode"
            spellcheck="false"
            class="col-12 ip36"
            :class="{ 'p-invalid': v$.ProjectCode.$invalid && submitted }"
          />
        </div>
        <div class="field col-12 md:col-12">
          <div class="col-3 text-left"></div>
          <small
            v-if="
              (v$.ProjectCode.$invalid && submitted) ||
              v$.ProjectCode.$pending.$response
            "
            class="col-9 p-0 p-error"
          >
            <span class="col-12 p-0">{{
              v$.ProjectCode.required.$message
                .replace("Value", "Mã dự án")
                .replace("is required", "không được để trống")
            }}</span>
          </small>
        </div>
        <div class="field col-12 md:col-12">
          <label class="col-12 text-left p-0"
            >Tên dự án <span class="redsao">(*)</span></label
          >
          <InputText
            v-model="Project.ProjectName"
            spellcheck="false"
            class="col-12 ip36"
            :class="{ 'p-invalid': v$.ProjectName.$invalid && submitted }"
          />
        </div>
        <div class="field col-12 md:col-12">
          <div class="col-3 text-left"></div>
          <small
            v-if="
              (v$.ProjectName.$invalid && submitted) ||
              v$.ProjectName.$pending.$response
            "
            class="col-9 p-0 p-error"
          >
            <span class="col-12 p-0">{{
              v$.ProjectName.required.$message
                .replace("Value", "Tên dự án")
                .replace("is required", "không được để trống")
            }}</span>
          </small>
        </div>
        <div style="display: flex" class="p-0 col-12 field md:col-12 m-0">
          <div class="field col-6 md:col-6">
            <label class="col-12 text-left p-0">Ngày bắt đầu </label>
            <Calendar
              class="col-12 p-0"
              id="basic"
              v-model="Project.ProjectStart"
              autocomplete="on"
              :minDate="new Date()"
            />
          </div>
          <div class="field col-6 md:col-6">
            <label class="col-12 text-left p-0">Ngày kết thúc</label>
            <Calendar
              class="col-12 p-0"
              id="basic"
              v-model="Project.ProjectEnd"
              autocomplete="on"
              :minDate="new Date()"
            />
          </div>
        </div>

        <div class="field col-12 md:col-12 pt-0 mt-0">
          <label class="col-12 text-left p-0">Mô tả</label>

          <Textarea
            v-model="Project.ProjectDescription"
            :autoResize="true"
            rows="3"
            cols="30"
            spellcheck="false"
            class="col-12 ip36"
          />
        </div>
        <div class="field col-12 p-0 flex" v-if="isSaveProject">
          <div class="field col-6 md:col-6">
            <label class="col-12 text-left p-0">Ngày hoàn thành</label>
            <Calendar
              class="col-12 p-0"
              id="basic"
              v-model="Project.ProjectCompleted"
              autocomplete="on"
              :minDate="new Date(Project.ProjectStart)"
            />
          </div>
          <div class="field col-6">
            <label class="col-12 text-left p-0">Trạng thái </label>
            <span>
              <Dropdown
                class="col-12"
                v-model="Project.ProjectStatus"
                :options="pStatus"
                optionLabel="name"
                optionValue="code"
              />
            </span>
          </div>
        </div>
      </div>
    </form>
    <template #footer>
      <Button
        @click="closeDialog"
        label="Hủy"
        icon="pi pi-times"
        class="p-button-text"
      />

      <Button
        @click="saveProject(!v$.$invalid)"
        label="Lưu"
        icon="pi pi-check"
        autofocus
      />
    </template>
  </Dialog>
  <Dialog
    :header="headerDialog1"
    v-model:visible="displayBasic1"
    :style="{ width: '50vw' }"
    :maximizable="true"
  >
    <form>
      <div class="grid formgrid m-2">
        <div class="field col-12 md:col-12">
          <label class="col-12 text-left p-0"
            >Mã giai đoạn <span class="redsao">(*)</span></label
          >
          <InputText
            v-model="Stage.StageCode"
            spellcheck="false"
            class="col-12 ip36"
          />
        </div>
        <div class="field col-12 md:col-12">
          <div class="col-3 text-left"></div>
        </div>
        <div class="field col-12 md:col-12">
          <label class="col-12 text-left p-0"
            >Mục tiêu<span class="redsao">(*)</span></label
          >
          <InputText
            v-model="Stage.StageTarget"
            spellcheck="false"
            class="col-12 ip36"
          />
        </div>

        <div style="display: flex" class="p-0 col-12 field md:col-12 m-0">
          <div class="field col-6 md:col-6">
            <label class="col-12 text-left p-0">Ngày bắt đầu </label>
            <Calendar
              class="col-12 p-0"
              id="basic"
              v-model="Stage.StageStart"
              autocomplete="on"
              :minDate="new Date()"
            />
          </div>
          <div class="field col-6 md:col-6">
            <label class="col-12 text-left p-0">Ngày kết thúc</label>
            <Calendar
              class="col-12 p-0"
              id="basic"
              v-model="Stage.StageEnd"
              autocomplete="on"
              :minDate="new Date()"
            />
          </div>
        </div>

        <div class="field col-12 md:col-12 pt-0 mt-0">
          <label class="col-12 text-left p-0">Mô tả</label>

          <Textarea
            v-model="Stage.StageDescription"
            :autoResize="true"
            rows="3"
            cols="30"
            spellcheck="false"
            class="col-12 ip36"
          />
        </div>
        <div class="field col-12 p-0 flex" v-if="isSaveStage">
          <div class="field col-6 md:col-6">
            <label class="col-12 text-left p-0">Ngày hoàn thành</label>
            <Calendar
              class="col-12 p-0"
              id="basic"
              v-model="Stage.StageCompleted"
              autocomplete="on"
              :minDate="new Date(Project.ProjectStart)"
            />
          </div>
          <div class="field col-6">
            <label class="col-12 text-left p-0">Trạng thái </label>
            <span>
              <Dropdown
                class="col-12"
                v-model="Stage.StageStatus"
                :options="pStatus"
                optionLabel="name"
                optionValue="code"
              />
            </span>
          </div>
        </div>
      </div>
    </form>
    <template #footer>
      <Button
        @click="closeDialog1"
        label="Hủy"
        icon="pi pi-times"
        class="p-button-text"
      />

      <Button @click="saveStage()" label="Lưu" icon="pi pi-check" autofocus />
    </template>
  </Dialog>
</template>
<style scoped>
.d-container {
  background-color: #f5f5f5;
}

.d-lang-header {
  background-color: #ffff;
  padding: 12px 8px 0px 8px;
  margin: 8px 8px 0px 8px;
  height: 33px;
}
.d-lang-header h3,
i {
  font-weight: 600;
}
.d-module-title {
  margin: 0;
}
.d-lang-table {
  margin: 0px 8px 0px 8px;
  height: calc(100vh - 167px);
}

.d-toolbar {
  border: unset;
  outline: unset;
  background-color: #fff;
  margin: 0px 8px 0px 8px;
}
.d-toolbar-img {
  border: unset;
  outline: unset;
  background-color: #fff;
  margin: 0px 8px 0px 0px;
  padding-left: 0px;
}
.d-btn-function {
  border-radius: 50%;
  margin-left: 6px;
}
.d-btn-delete {
  background-color: rgb(237, 114, 84);
  border: 1px solid rgb(214, 125, 125);
}
.d-btn-delete:hover {
  background-color: rgb(255, 0, 0);
  border: 1px solid rgb(214, 125, 125);
}
.d-btn-add {
  background-color: rgb(5, 194, 33);
  border: 1px solid rgb(17, 132, 75);
}
.d-btn-add:hover {
  background-color: rgb(125, 221, 150);
  border: 1px solid rgb(214, 125, 125);
}
.d-btn-edit:hover {
  background-color: rgb(63, 46, 252);
}
.option-lang {
  display: flex;
}
.option-lang div {
  line-height: 20px;
  padding-left: 12px;
}
.option-lang img {
  width: 30px;
  height: 20px;
}
.dropdown-lang {
  height: 38px;
}
.ipnone {
  display: none;
}
.btn-add-img {
  margin-top: 16px;
  width: 100%;
  height: 50px;
}
</style>
<style lang="scss" scoped>
::v-deep(.p-galleria-content) {
  .p-galleria-item-wrapper {
    height: 100%;
  }
  .p-galleria-thumbnail-container {
    padding: 6px 2px;
    background-color: rgb(195, 195, 195);
  }
  .p-galleria-thumbnail-next {
    display: none;
  }
  .p-galleria-thumbnail-prev {
    display: none;
  }
}
</style>