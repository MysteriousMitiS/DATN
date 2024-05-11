<script setup>
import { ref, inject, onMounted, watch } from "vue";
import LoginView from "./LoginView.vue";
import "@fullcalendar/core/vdom";
import FullCalendar from "@fullcalendar/vue3";
import dayGridPlugin from "@fullcalendar/daygrid";
import timeGridPlugin from "@fullcalendar/timegrid";
import interactionPlugin from "@fullcalendar/interaction";
import { useToast } from "vue-toastification";
import { required } from "@vuelidate/validators";
import { useVuelidate } from "@vuelidate/core";
import moment from "moment";
import { useRouter, useRoute } from "vue-router";

const store = inject("store");
const router = useRouter();
const route = useRoute();
const axios = inject("axios");
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
const basedomainURL = baseURL;
const config = {
  headers: { Authorization: `Bearer ${store.getters.token}` },
};
const tinTuc = ref();
const displayDetails = ref(false);
const openDetails = (data) => {
  displayDetails.value = true;
  tinTuc.value = data;
};
const closeDetails = () => {
  displayDetails.value = false;
  tinTuc.value = {};
};
const options = ref({
  SearchText: "",
  searchTextStage: "",
  loading: true,
  PageSize: 10,
  loading: true,
});
const expandedRows = ref([]);
const projects = ref();
const renderTree = (Project, Stage, Work) => {
  let arrChils = [];
  Project.forEach((item) => {
    Stage.filter((x) => x.ProjectId == item.ProjectId).forEach((m) => {
      if (!item.children) item.children = [];
      let work = [];
      Work.filter((y) => y.StageId == m.StageId).forEach((n) => {
        work.push({
          id: n.WorkId,
          title: n.WorkName,
          start: n.WorkStart,
          end: n.WorkEnd,
        });
      });
      if (!m.children) m.children = {};
      let calendar = {
        plugins: [dayGridPlugin, timeGridPlugin, interactionPlugin],
        initialDate: new Date(),
        headerToolbar: {
          left: "prev,next today",
          center: "title",
          right: "dayGridMonth,timeGridWeek,timeGridDay",
        },
        editable: true,
        selectable: true,
        selectMirror: true,
        dayMaxEvents: true,
        initialEvents: work,
      };
      m.children = calendar;
      item.children.push(m);
    });
    arrChils.push(item);
  });
  projects.value = arrChils;
};
const loadProjectData = (rf) => {
  if (rf) {
    (async () => {
      const res = await axios
        .post(
          baseURL + "/api/Proc/CallProc",
          {
            proc: "Project_List_User",
            par: [
              { par: "m_SearchText", va: options.value.SearchText },
              { par: "UserName", va: store.getters.user.UserName },
            ],
          },
          config
        )
        .then((response) => {
          let data = JSON.parse(response.data.data)[0];

          options.value.loading = false;
          if (data.length > 0) {
            data.forEach((element) => {
              if (element.ProjectStart != null) {
                element.ProjectStart = moment(
                  new Date(element.ProjectStart)
                ).format("YYYY-MM-DD");
              }
              if (element.ProjectEnd != null) {
                element.ProjectEnd = moment(
                  new Date(element.ProjectEnd)
                ).format("YYYY-MM-DD");
              }
              if (element.ProjectCompleted != null) {
                element.ProjectCompleted = moment(
                  new Date(element.ProjectCompleted)
                ).format("YYYY-MM-DD");
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

          options.value.loading = false;
          data.forEach((element) => {
            if (element.StageStart != null) {
              element.StageStart = moment(new Date(element.StageStart)).format(
                "YYYY-MM-DD"
              );
            }
            if (element.StageEnd != null) {
              element.StageEnd = moment(new Date(element.StageEnd)).format(
                "YYYY-MM-DD"
              );
            }
            if (element.StageCompleted != null) {
              element.StageCompleted = moment(
                new Date(element.StageCompleted)
              ).format("YYYY-MM-DD");
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

      const res2 = await axios
        .post(
          baseURL + "/api/Proc/CallProc",
          {
            proc: "Work_List",
            par: [
              { par: "m_SearchText", va: options.value.SearchText },
              { par: "StageId", va: null },
            ],
          },
          config
        )
        .then((response) => {
          let data = JSON.parse(response.data.data)[0];
          if (data.length > 0) {
            data.forEach((element, i) => {
              if (element.WorkStart != null) {
                element.WorkStart = moment(new Date(element.WorkStart)).format(
                  "YYYY-MM-DD"
                );
              }
              if (element.WorkEnd != null) {
                element.WorkEnd = moment(new Date(element.WorkEnd)).format(
                  "YYYY-MM-DD"
                );
              }
              if (element.WorkCompleted != null) {
                element.WorkCompleted = moment(
                  new Date(element.WorkCompleted)
                ).format("YYYY-MM-DD");
              }
              element.STT = i + 1;
              if (element.WorkStatus != null) {
                if (element.WorkStatus == 0) {
                  element.WorkStatus = "Đã giao";
                }
                if (element.WorkStatus == 1) {
                  element.WorkStatus = "Đang làm";
                }
                if (element.WorkStatus == 2) {
                  element.WorkStatus = "Chờ duyệt";
                }
                if (element.WorkStatus == 3) {
                  element.WorkStatus = "Làm lại";
                }
                if (element.WorkStatus == 4) {
                  element.WorkStatus = "Không hoàn thành";
                }
                if (element.WorkStatus == 5) {
                  element.WorkStatus = "Hoàn thành";
                }
              } else {
                element.WorkStatus = "Chưa hoàn thành";
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
      renderTree(res, res1, res2);

      options.value.loading = false;
    })();
  }
};
const listYourWork = ref({
  plugins: [dayGridPlugin, timeGridPlugin, interactionPlugin],
  initialDate: new Date(),
  headerToolbar: {
    left: "prev,next",
    center: "title",
    right: "dayGridMonth,timeGridWeek",
  },
  editable: true,
  selectable: true,
  selectMirror: true,
  dayMaxEvents: true,
  initialEvents: [],
});
const checkLoad = ref(false);
const loadYourWork = () => {
  (async () => {
    await axios
      .post(
        baseURL + "/api/Proc/CallProc",
        {
          proc: "YourWork_List",
          par: [
            { par: "m_SearchText", va: options.value.SearchText },
            { par: "UserName", va: store.getters.user.UserName },
          ],
        },
        config
      )
      .then((response) => {
        let data = JSON.parse(response.data.data)[0];

        if (data.length > 0) {
          data.forEach((element, i) => {
            if (element.WorkStart != null) {
              element.WorkStart = moment(new Date(element.WorkStart)).format(
                "YYYY-MM-DD"
              );
            }
            if (element.WorkEnd != null) {
              element.WorkEnd = moment(new Date(element.WorkEnd)).format(
                "YYYY-MM-DD"
              );
            }

            if (element.WorkCompleted != null) {
              element.WorkCompleted = moment(
                new Date(element.WorkCompleted)
              ).format("YYYY-MM-DD");
            }
            listYourWork.value.initialEvents.push({
              id: element.WorkId,
              title: element.WorkName,
              start: element.WorkStart,
              end: element.WorkEnd,
            });
          });
          checkLoad.value = true;
        }
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
  })();
};
const listnews = ref();

const listnotifi = ref();
const loadNotifiData = () => {
  axios
    .post(
      baseURL + "/api/Proc/CallProc",
      {
        proc: "Notification_List_Show",
        par: [
          { par: "Search", va: options.value.SearchText },
          { par: "PageNo", va: 1 },
          { par: "PageSize", va: 3 },
        ],
      },
      config
    )
    .then((response) => {
      let data = JSON.parse(response.data.data)[0];
      if (data.length > 0) {
        data.forEach((element, i) => {
          element.STT = i + 1;
          if (element.StartDate != null) {
            var date = element.StartDate.split("T")[0];
            var startDay = date.split("-");
            element.StartDate =
              startDay[2] + "/" + startDay[1] + "/" + startDay[0];
          }
          if (element.EndDate != null) {
            var date1 = element.EndDate.split("T")[0];
            var endDay = date1.split("-");
            element.EndDate = endDay[2] + "/" + endDay[1] + "/" + endDay[0];
          }
        });

        listnotifi.value = data;
      }
      options.value.loading = false;
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
};
const loadNewsData = () => {
  axios
    .post(
      baseURL + "/api/Proc/CallProc",
      {
        proc: "News_List_Show",
        par: [
          { par: "Search", va: options.value.SearchText },
          { par: "PageNo", va: 1 },
          { par: "PageSize", va: 4 },
        ],
      },
      config
    )
    .then((response) => {
      let data = JSON.parse(response.data.data)[0];
      if (data.length > 0) {
        data.forEach((element, i) => {
          element.STT = i + 1;
          if (element.StartDate != null) {
            var date = element.StartDate.split("T")[0];
            var startDay = date.split("-");
            element.StartDate =
              startDay[2] + "/" + startDay[1] + "/" + startDay[0];
          }
          if (element.EndDate != null) {
            var date1 = element.EndDate.split("T")[0];
            var endDay = date1.split("-");
            element.EndDate = endDay[2] + "/" + endDay[1] + "/" + endDay[0];
          }
        });
        listnews.value = data;
      }
      options.value.loading = false;
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
};

onMounted(() => {
  console.log("USER", store.state.user);
  loadYourWork();
  loadProjectData(true);
  loadNewsData();
  loadNotifiData();
  return {
    options,
  };
});
</script>
<template>
  <LoginView v-if="!store.getters.islogin" />
  <div class="" v-if="store.getters.islogin">
    <div class="flex overflow-auto">
      <div class="w-8 p-3">
        <div>
          <div class="text-center"><h2>Dự án của bạn</h2></div>
          <!-- <FullCalendar v-if="helk"  :options="fullcalendar" /> -->
          <div>
            <Accordion :multiple="false">
              <AccordionTab
                v-for="item in projects"
                :key="item.ProjectId"
                :header="item.ProjectName"
              >
                <DataTable
                  :value="item.children"
                  responsiveLayout="scroll"
                  scrollHeight="flex"
                  :scrollable="true"
                  :showGridlines="true"
                  columnResizeMode="fit"
                  class="w-full"
                  v-model:expandedRows="expandedRows"
                >
                  <Column
                    class="
                      align-items-center
                      justify-content-center
                      text-center
                    "
                    headerStyle="background-color:#B9D3EE;text-align:center;max-width:70px;height:50px;"
                    bodyStyle="background-color:#FFEFD5;text-align:center;max-width:70px"
                    :expander="true"
                  />
                  <Column
                    headerStyle="background-color:#B9D3EE; text-align:center;max-width:150px;height:50px"
                    bodyStyle="background-color:#FFEFD5;text-align:center;max-width:150px"
                    class="
                      align-items-center
                      justify-content-center
                      text-center
                    "
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
                  <template #expansion="slotProps">
                    <div class="w-full">
                      <FullCalendar :options="slotProps.data.children" />
                    </div>
                  </template>
                </DataTable>
              </AccordionTab>
            </Accordion>
          </div>
        </div>
        <div class="flex">
          <div class="w-full">
            <div class="text-center">
              <h2>Tin tức nội bộ</h2>
            </div>
            <div style="display: grid; grid-template-columns: repeat(2, 1fr)">
              <div
                class="w-full relative p-4"
                v-for="item in listnews"
                :key="item.NewsId"
              >
                <div style="cursor: pointer">
                  <img
                    @click="openDetails(item)"
                    class="w-full"
                    :src="
                      item.Image
                        ? basedomainURL + item.Image
                        : '/src/assets/image/fails.png'
                    "
                    alt=""
                  />
                </div>
                <div class="col-12" style="cursor: pointer">
                  <h3 class="p-0 m-0" @click="openDetails(item)">
                    {{ item.News_Name }}
                  </h3>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="w-4 p-3">
        <div class="surface-100 overflow-auto mt-2">
          <div class="surface-100 w-full">
            <div class="text-center">
              <a href="/yourwork" style="text-decoration: none"
                ><h2>Công việc của bạn</h2></a
              >
            </div>
            <div>
              <FullCalendar v-if="checkLoad" :options="listYourWork" />
            </div>
          </div>
          <div>
            <div class="text-center"><h2>Thông báo</h2></div>
            <div v-for="item in listnotifi" :key="item.NewsId">
              <div class="col-12 flex w-full relative">
                <div class="col-4">
                  <img
                    @click="openDetails(item)"
                    class="w-full"
                    :src="
                      item.Image
                        ? basedomainURL + item.Image
                        : '/src/assets/image/fails.png'
                    "
                    alt=""
                  />
                </div>
                <div class="col-8">
                  <h3 class="p-0 m-0" @click="openDetails(item)">
                    {{ item.News_Name }}
                  </h3>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <Dialog
    header="Chi tiết tin tức"
    v-model:visible="displayDetails"
    :maximizable="true"
    :style="{ width: '60vw' }"
  >
    <form>
      <div class="grid formgrid m-2">
        <div class="field col-12 md:col-12">
          <h1>{{ tinTuc.News_Name }}</h1>
        </div>
        <div class="field col-12 md:col-12">
          <span style="color: cornflowerblue; fon-size: 14px"
            >{{ tinTuc.CreateBy }},</span
          >
          <i style="padding: 0px 12px" class="pi pi-clock"></i
          ><span>Ngày: {{ tinTuc.StartDate }}</span>
        </div>
        <div class="field col-12 md:col-12">
          <hr />
        </div>
        <div class="field col-12 md:col-12">
          <h3>{{ tinTuc.Contents }}</h3>
        </div>
        <div
          v-if="tinTuc.Image ? true : false"
          class="d-avatar-news field col-12 md:col-12"
        >
          <img v-bind:src="basedomainURL + tinTuc.Image" class="relative" />
        </div>
        <div style="padding: 0px 24px" class="field col-12 md:col-12">
          <p v-html="tinTuc.Details" style="font-size: 16px"></p>
        </div>
      </div>
    </form>
    <template #footer>
      <Button @click="closeDetails" label="Đóng" icon="pi pi-times" autofocus />
    </template>
  </Dialog>
</template>
<style scoped>
</style>
