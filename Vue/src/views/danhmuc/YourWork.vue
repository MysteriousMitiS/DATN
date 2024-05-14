<script setup>
import { useVuelidate } from '@vuelidate/core'
import { required } from '@vuelidate/validators'
import moment from 'moment'
import { FilterMatchMode, FilterOperator } from 'primevue/api'
import { inject, onMounted, ref, watch } from 'vue'
import { useToast } from 'vue-toastification'
const axios = inject('axios')
const store = inject('store')
const swal = inject('$swal')
const config = {
  headers: { Authorization: `Bearer ${store.getters.token}` }
}
const filters = ref({
  global: { value: null, matchMode: FilterMatchMode.CONTAINS },
  Name: {
    operator: FilterOperator.AND,
    constraints: [{ value: null, matchMode: FilterMatchMode.STARTS_WITH }]
  },
  Macode: {
    operator: FilterOperator.AND,
    constraints: [{ value: null, matchMode: FilterMatchMode.STARTS_WITH }]
  }
})
const pStatus = ref([
  { name: 'Đang làm', code: 1 },
  { name: 'Chờ duyệt', code: 2 }
])
const pUserW = ref([])
const rules = {
  WorkName: {
    required,
    $errors: [
      {
        $property: 'WorkName',
        $validator: 'required',
        $message: 'Tên công việc không được để trống!'
      }
    ]
  },
  WorkCode: {
    required,
    $errors: [
      {
        $property: 'WorkCode',
        $validator: 'required',
        $message: 'Mã công việc không được để trống!'
      }
    ]
  }
}
const work = ref({
  WorkName: '',
  WorkCode: '',
  WorkStart: null,
  WorkEnd: null,
  WorkCompleted: null,
  WorkStatus: 0,
  WorkDescription: '',
  WorkImage: '',
  STT: 1
})
const workuser = ref({
  WorkId: null,
  WorkRole: 0
})
const isCheckWork = ref(false)
const optionsWork = ref([
  { name: 'Công việc', code: false },
  { name: 'Giám sát', code: true }
])
const userCheck = ref([])
const checkuserlist = ref([])
const selectedLangs = ref()
const submitted = ref(false)
const v$ = useVuelidate(rules, work)
const isSaveWork = ref(false)
const datalists = ref()
const listchecks = ref()
const toast = useToast()
const basedomainURL = baseURL
const checkDelList = ref(false)

const options = ref({
  IsNext: true,
  sort: 'id DESC',
  SearchText: '',
  PageNo: 1,
  PageSize: 10,
  FilterUsers_ID: null,
  loading: true,
  totalRecords: null
})

const loadData = (rf) => {
  if (rf) {
    axios
      .post(
        baseURL + '/api/Proc/CallProc',
        {
          proc: 'YourWork_List',
          par: [
            { par: 'm_SearchText', va: options.value.SearchText },
            { par: 'UserName', va: store.getters.user.UserName }
          ]
        },
        config
      )
      .then((response) => {
        let data = JSON.parse(response.data.data)[0]
        if (isFirst.value) isFirst.value = false
        if (data.length > 0) {
          data.forEach((element, i) => {
            if (element.WorkStart != null) {
              element.WorkStart = moment(new Date(element.WorkStart)).format('DD/MM/YYYY ')
            }
            if (element.WorkEnd != null) {
              element.WorkEnd = moment(new Date(element.WorkEnd)).format('DD/MM/YYYY ')
            }

            if (element.WorkCompleted != null) {
              element.WorkCompleted = moment(new Date(element.WorkCompleted)).format('DD/MM/YYYY ')
            }
            element.STT = i + 1
            if (element.WorkStatus != null) {
              if (element.WorkStatus == 0) {
                element.WorkStatus = 'Đã giao'
              }
              if (element.WorkStatus == 1) {
                element.WorkStatus = 'Đang làm'
              }
              if (element.WorkStatus == 2) {
                element.WorkStatus = 'Chờ duyệt'
              }
              if (element.WorkStatus == 3) {
                element.WorkStatus = 'Làm lại'
              }
              if (element.WorkStatus == 4) {
                element.WorkStatus = 'Không hoàn thành'
              }
              if (element.WorkStatus == 5) {
                element.WorkStatus = 'Hoàn thành'
              }
            } else {
              element.WorkStatus = 'Không hoàn thành'
            }
          })
        }
        datalists.value = data

        options.value.loading = false
      })
      .catch((error) => {
        toast.error('Tải dữ liệu không thành công!')
        options.value.loading = false

        if (error && error.status === 401) {
          swal.fire({
            title: 'Error!',
            text: 'Mã token đã hết hạn hoặc không hợp lệ, vui lòng đăng nhập lại!',
            icon: 'error',
            confirmButtonText: 'OK'
          })
          store.commit('gologout')
        }
      })
    axios
      .post(
        baseURL + '/api/Proc/CallProc',
        {
          proc: 'YourCheck_List',
          par: [
            { par: 'm_SearchText', va: options.value.SearchText },
            { par: 'UserName', va: store.getters.user.UserName }
          ]
        },
        config
      )
      .then((response) => {
        let data = JSON.parse(response.data.data)[0]
        if (isFirst.value) isFirst.value = false
        if (data.length > 0) {
          data.forEach((element, i) => {
            if (element.WorkStart != null) {
              element.WorkStart = moment(new Date(element.WorkStart)).format('DD/MM/YYYY ')
            }
            if (element.WorkEnd != null) {
              element.WorkEnd = moment(new Date(element.WorkEnd)).format('DD/MM/YYYY ')
            }

            if (element.WorkCompleted != null) {
              element.WorkCompleted = moment(new Date(element.WorkCompleted)).format('DD/MM/YYYY ')
            }
            element.STT = i + 1
            if (element.WorkStatus != null) {
              if (element.WorkStatus == 0) {
                element.WorkStatus = 'Đã giao'
              }
              if (element.WorkStatus == 1) {
                element.WorkStatus = 'Đang làm'
              }
              if (element.WorkStatus == 2) {
                element.WorkStatus = 'Chờ duyệt'
              }
              if (element.WorkStatus == 3) {
                element.WorkStatus = 'Làm lại'
              }
              if (element.WorkStatus == 4) {
                element.WorkStatus = 'Không hoàn thành'
              }
              if (element.WorkStatus == 5) {
                element.WorkStatus = 'Hoàn thành'
              }
            } else {
              element.WorkStatus = 'Không hoàn thành'
            }
            if (element.CheckResult != null) {
              if (element.CheckResult == -1) {
                element.CheckResult = 'Chưa duyệt'
              }
              if (element.CheckResult == 0) {
                element.CheckResult = 'Không duyệt'
              }
              if (element.CheckResult == 1) {
                element.CheckResult = 'Làm lại'
              }
              if (element.CheckResult == 2) {
                element.CheckResult = 'Đã duyệt'
              }
            }
          })
        }
        console.log('Dữ liệu công việc', data, store.getters.user.UserName)
        listchecks.value = data
        options.value.loading = false
      })
      .catch((error) => {
        toast.error('Tải dữ liệu không thành công!')
        options.value.loading = false

        if (error && error.status === 401) {
          swal.fire({
            title: 'Error!',
            text: 'Mã token đã hết hạn hoặc không hợp lệ, vui lòng đăng nhập lại!',
            icon: 'error',
            confirmButtonText: 'OK'
          })
          store.commit('gologout')
        }
      })
  }
}
//Phân trang dữ liệu
const onPage = (event) => {
  options.value.PageNo = event.page + 1

  loadData(true)
}
//Hiển thị dialog
const headerDialog = ref()
const displayBasic = ref(false)
const openBasic = (str) => {
  submitted.value = false
  work.value = {
    StageId: store.getters.stageid,
    WorkName: '',
    WorkCode: '',
    WorkStart: null,
    WorkEnd: null,
    WorkCompleted: null,
    WorkStatus: 0,
    WorkDescription: '',
    WorkImage: '',
    STT: 1
  }
  workuserShow.value = false
  checkuserShow.value = false
  checkuserDup.value = false
  checkIsmain.value = false
  isSaveWork.value = false
  headerDialog.value = str
  displayBasic.value = true
}
const workuserShow = ref(false)
const checkuserShow = ref(false)
const checkuserDup = ref(false)
const closeDialog = () => {
  work.value = {
    WorkName: '',
    WorkCode: '',
    WorkStart: null,
    WorkEnd: null,
    WorkCompleted: null,
    WorkDescription: '',
    WorkImage: '',
    STT: 1
  }

  workuserShow.value = false
  checkuserShow.value = false
  checkuserDup.value = false
  displayBasic.value = false
}
const closeDialog1 = () => {
  displayCheck.value = false
}
//Lấy file logo
const chonanh = (id) => {
  document.getElementById(id).click()
}
const handleFileUpload = (event) => {
  files = event.target.files
  var output = document.getElementById('logoLang')
  output.src = URL.createObjectURL(event.target.files[0])
  output.onload = function () {
    URL.revokeObjectURL(output.src) // free memory
  }
}
//Thêm bản ghi
let files = []
const saveWork = (isFormValid) => {
  submitted.value = true
  if (!isFormValid) {
    return
  }
  if (workuser.value.UserId == null) {
    workuserShow.value = true
    return
  }
  if (userCheck.value.length == 0) {
    checkuserShow.value = true
    return
  }
  for (let index = 0; index < userCheck.value.length; index++) {
    const element = userCheck.value[index]
    if (element == workuser.value.UserId) {
      checkuserDup.value = true
      return
    }
  }

  if (typeof work.value.WorkStart == 'string') {
    let startDay = work.value.WorkStart.split('/')
    work.value.WorkStart = new Date(startDay[2] + '/' + startDay[1] + '/' + startDay[0])
  }
  if (typeof work.value.WorkEnd == 'string') {
    let startDay = work.value.WorkEnd.split('/')
    work.value.WorkEnd = new Date(startDay[2] + '/' + startDay[1] + '/' + startDay[0])
  }
  if (typeof work.value.WorkCompleted == 'string') {
    let startDay = work.value.WorkCompleted.split('/')
    work.value.WorkCompleted = new Date(startDay[2] + '/' + startDay[1] + '/' + startDay[0])
  }
  let formData = new FormData()
  for (var i = 0; i < files.length; i++) {
    let file = files[i]
    formData.append('WorkImage', file)
  }

  formData.append('work', JSON.stringify(work.value))
  swal.fire({
    width: 110,
    didOpen: () => {
      swal.showLoading()
    }
  })
  if (!isSaveWork.value) {
    ;(async () => {
      await axios
        .post(baseURL + '/api/Works/AddWork', formData, config)
        .then((response) => {
          if (response.data.err != '1') {
            swal.close()
          } else {
            swal.fire({
              title: 'Error!',
              text: response.data.ms,
              icon: 'error',
              confirmButtonText: 'OK'
            })
          }
        })
        .catch((error) => {
          swal.close()
          swal.fire({
            title: 'Error!',
            text: 'Có lỗi xảy ra, vui lòng kiểm tra lại!',
            icon: 'error',
            confirmButtonText: 'OK'
          })
        })
      let arrworkcheck = []
      await axios
        .post(
          baseURL + '/api/Proc/CallProc',
          {
            proc: 'Work_Get',
            par: [{ par: 'WorkCode', va: work.value.WorkCode }]
          },
          config
        )
        .then((response) => {
          let data = JSON.parse(response.data.data)[0]
          checkuserlist.value = []
          workuser.value.WorkId = data[0].WorkId

          for (let index = 0; index < userCheck.value.length; index++) {
            const element = userCheck.value[index]
            arrworkcheck.push({
              WorkId: data[0].WorkId,
              UserId: element,
              CheckResult: 0
            })
            checkuserlist.value.push({
              WorkId: data[0].WorkId,
              UserId: element,
              WorkRole: 1
            })
          }

          checkuserlist.value.push(workuser.value)
        })
        .catch((error) => {
          toast.error('Tải dữ liệu không thành công!')
          options.value.loading = false

          if (error && error.status === 401) {
            swal.fire({
              title: 'Error!',
              text: 'Mã token đã hết hạn hoặc không hợp lệ, vui lòng đăng nhập lại!',
              icon: 'error',
              confirmButtonText: 'OK'
            })
            store.commit('gologout')
          }
        })
      await axios
        .post(baseURL + '/api/WorkUser/AddWorkUser', checkuserlist.value, config)
        .then((response) => {
          if (response.data.err != '1') {
          } else {
            swal.fire({
              title: 'Error!',
              text: response.data.ms,
              icon: 'error',
              confirmButtonText: 'OK'
            })
          }
        })
        .catch((error) => {
          swal.close()
          swal.fire({
            title: 'Error!',
            text: 'Có lỗi xảy ra, vui lòng kiểm tra lại!',
            icon: 'error',
            confirmButtonText: 'OK'
          })
        })

      await axios
        .post(baseURL + '/api/WorkChecks/AddWorkCheck', arrworkcheck, config)
        .then((response) => {
          if (response.data.err != '1') {
            toast.success('Thêm công việc thành công!')
            loadData(true)
            closeDialog()
          } else {
            swal.fire({
              title: 'Error!',
              text: response.data.ms,
              icon: 'error',
              confirmButtonText: 'OK'
            })
          }
        })
        .catch((error) => {
          swal.close()
          swal.fire({
            title: 'Error!',
            text: 'Có lỗi xảy ra, vui lòng kiểm tra lại!',
            icon: 'error',
            confirmButtonText: 'OK'
          })
        })
    })()
  } else {
    let arrworkcheck = []
    checkuserlist.value = []

    for (let index = 0; index < userCheck.value.length; index++) {
      const element = userCheck.value[index]
      arrworkcheck.push({
        WorkId: work.value.WorkId,
        UserId: element,
        CheckResult: 0
      })
      checkuserlist.value.push({
        WorkId: work.value.WorkId,
        UserId: element,
        WorkRole: 1
      })
    }

    checkuserlist.value.push(workuser.value)
    ;(async () => {
      await axios
        .post(baseURL + '/api/WorkChecks/AddWorkCheck', arrworkcheck, config)
        .then((response) => {
          if (response.data.err != '1') {
          } else {
            swal.fire({
              title: 'Error!',
              text: response.data.ms,
              icon: 'error',
              confirmButtonText: 'OK'
            })
          }
        })
        .catch((error) => {
          swal.close()
          swal.fire({
            title: 'Error!',
            text: 'Có lỗi xảy ra, vui lòng kiểm tra lại!',
            icon: 'error',
            confirmButtonText: 'OK'
          })
        })
      await axios
        .post(baseURL + '/api/WorkUser/AddWorkUser', checkuserlist.value, config)
        .then((response) => {
          if (response.data.err != '1') {
          } else {
            swal.fire({
              title: 'Error!',
              text: response.data.ms,
              icon: 'error',
              confirmButtonText: 'OK'
            })
          }
        })
        .catch((error) => {
          swal.close()
          swal.fire({
            title: 'Error!',
            text: 'Có lỗi xảy ra, vui lòng kiểm tra lại!',
            icon: 'error',
            confirmButtonText: 'OK'
          })
        })
      await axios
        .put(baseURL + '/api/Works/UpdateWork', formData, config)
        .then((response) => {
          if (response.data.err != '1') {
            swal.close()
            toast.success('Cập nhật công việc thành công!')
            loadData(true)
            closeDialog()
          } else {
            console.log('LỖI A:', response)
            swal.fire({
              title: 'Error!',
              text: response.data.ms,
              icon: 'error',
              confirmButtonText: 'OK'
            })
          }
        })
        .catch((error) => {
          swal.close()
          swal.fire({
            title: 'Error!',
            text: 'Có lỗi xảy ra, vui lòng kiểm tra lại!',
            icon: 'error',
            confirmButtonText: 'OK'
          })
        })
    })()
  }
}
const saveCheck = (check) => {
  let usercheck = {
    UserId: store.getters.user.UserId,
    WorkId: workcheck.value.WorkId,
    CheckResult: check
  }
  axios
    .put(baseURL + '/api/WorkChecks/UpdateWorkCheck', usercheck, config)
    .then((response) => {
      if (response.data.err != '1') {
        swal.close()
        toast.success('Duyệt công việc thành công!')
        loadData(true)
        closeDialog1()
      } else {
        console.log('LỖI A:', response)
        swal.fire({
          title: 'Error!',
          text: response.data.ms,
          icon: 'error',
          confirmButtonText: 'OK'
        })
      }
    })
    .catch((error) => {
      swal.close()
      swal.fire({
        title: 'Error!',
        text: 'Có lỗi xảy ra, vui lòng kiểm tra lại!',
        icon: 'error',
        confirmButtonText: 'OK'
      })
    })
}
const checkIsmain = ref(true)
const workcheck = ref({
  WorkName: '',
  WorkCode: '',
  WorkStart: null,
  WorkEnd: null,
  WorkCompleted: null,
  WorkDescription: '',
  WorkImage: '',
  STT: 1
})
const displayCheck = ref(false)
const editCheck = (dataWork) => {
  axios
    .post(
      baseURL + '/api/Proc/CallProc',
      {
        proc: 'YourCheck_Get',
        par: [{ par: 'WorkId', va: dataWork.WorkId }]
      },
      config
    )
    .then((response) => {
      let data = JSON.parse(response.data.data)[0]

      if (data != null) {
        workcheck.value = data[0]
        if (workcheck.value.WorkStart != null) {
          let date = workcheck.value.WorkStart.split('T')[0]
          let startDay = date.split('-')
          workcheck.value.WorkStart = startDay[2] + '/' + startDay[1] + '/' + startDay[0]
        }
        if (workcheck.value.WorkEnd != null) {
          let date = workcheck.value.WorkEnd.split('T')[0]
          let startDay = date.split('-')
          workcheck.value.WorkEnd = startDay[2] + '/' + startDay[1] + '/' + startDay[0]
        }
        displayCheck.value = true
      }
    })
    .catch((error) => {
      toast.error('Tải dữ liệu không thành công!')
      options.value.loading = false

      if (error && error.status === 401) {
        swal.fire({
          title: 'Error!',
          text: 'Mã token đã hết hạn hoặc không hợp lệ, vui lòng đăng nhập lại!',
          icon: 'error',
          confirmButtonText: 'OK'
        })
        store.commit('gologout')
      }
    })
}
//Cập nhật bản ghi
const editWork = (dataLang) => {
  submitted.value = false
  work.value = dataLang
  workuser.value.WorkId = dataLang.WorkId
  workuser.value.UserId = dataLang.UserId
  workuser.value.WorkRole = 0
  userCheck.value = []
  if (typeof work.value.WorkStatus == 'string') {
    if (work.value.WorkStatus == 'Đã giao') {
      work.value.WorkStatus = 0
    }
    if (work.value.WorkStatus == 'Đang làm') {
      work.value.WorkStatus = 1
    }
    if (work.value.WorkStatus == 'Chờ duyệt') {
      work.value.WorkStatus = 2
    }
    if (work.value.WorkStatus == 'Làm lại') {
      work.value.WorkStatus = 3
    }
    if (work.value.WorkStatus == 'Không hoàn thành') {
      work.value.WorkStatus = 4
    }
    if (work.value.WorkStatus == 'Hoàn thành') {
      work.value.WorkStatus = 5
    }
  }
  axios
    .post(
      baseURL + '/api/Proc/CallProc',
      {
        proc: 'WorkCheck_Get',
        par: [{ par: 'WorkId', va: dataLang.WorkId }]
      },
      config
    )
    .then((response) => {
      let data = JSON.parse(response.data.data)[0]

      if (data != null) {
        data.forEach((element) => {
          userCheck.value.push(element.UserId)
        })
      }
    })
    .catch((error) => {
      toast.error('Tải dữ liệu không thành công!')
      options.value.loading = false

      if (error && error.status === 401) {
        swal.fire({
          title: 'Error!',
          text: 'Mã token đã hết hạn hoặc không hợp lệ, vui lòng đăng nhập lại!',
          icon: 'error',
          confirmButtonText: 'OK'
        })
        store.commit('gologout')
      }
    })

  headerDialog.value = 'Cập nhật công việc'
  isSaveWork.value = true
  workuserShow.value = false
  checkuserDup.value = false
  checkuserShow.value = false
  displayBasic.value = true
}
//Xóa bản ghi
const delLang = (Lang) => {
  swal
    .fire({
      title: 'Thông báo',
      text: 'Bạn có muốn xoá ngôn ngữ này không!',
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#3085d6',
      cancelButtonColor: '#d33',
      confirmButtonText: 'Có',
      cancelButtonText: 'Không'
    })
    .then((result) => {
      if (result.isConfirmed) {
        swal.fire({
          width: 110,
          didOpen: () => {
            swal.showLoading()
          }
        })
        if (Lang.IsMain) {
          toast.error('Không được xóa ngôn ngữ chính!')
          swal.close()
          return
        }
        axios
          .delete(baseURL + '/api/CMS_Lang/DeleteCMS_Lang', {
            headers: { Authorization: `Bearer ${store.getters.token}` },
            data: Lang != null ? [Lang.ID] : 1
          })
          .then((response) => {
            swal.close()
            if (response.data.err != '1') {
              swal.close()
              toast.success('Xoá ngôn ngữ thành công!')
              loadData(true)
            } else {
              swal.fire({
                title: 'Error!',
                text: response.data.ms,
                icon: 'error',
                confirmButtonText: 'OK'
              })
            }
          })
          .catch((error) => {
            swal.close()
            if (error.status === 401) {
              swal.fire({
                title: 'Error!',
                text: 'Mã token đã hết hạn hoặc không hợp lệ, vui lòng đăng nhập lại!',
                icon: 'error',
                confirmButtonText: 'OK'
              })
            }
          })
      }
    })
}
//Xuất excel
const menuButs = ref()
const itemButs = ref([
  {
    label: 'Xuất Excel',
    icon: 'pi pi-file-excel',
    command: (event) => {
      exportData('ExportExcel')
    }
  }
])
const toggleExport = (event) => {
  menuButs.value.toggle(event)
}
const exportData = (method) => {
  swal.fire({
    width: 110,
    didOpen: () => {
      swal.showLoading()
    }
  })
  axios
    .post(
      baseURL + '/api/Excel/ExportExcel',
      {
        excelname: 'DANH SÁCH CÔNG VIỆC',
        proc: 'MyWork_Export',
        par: [{ par: 'UserName', va: store.getters.user.UserName }]
      },
      config
    )
    .then((response) => {
      swal.close()
      if (response.data.err != '1') {
        swal.close()

        toast.success('Kết xuất Data thành công!')
        window.open(baseURL + response.data.path)
      } else {
        swal.fire({
          title: 'Error!',
          text: response.data.ms,
          icon: 'error',
          confirmButtonText: 'OK'
        })
      }
    })
    .catch((error) => {
      if (error.status === 401) {
        swal.fire({
          title: 'Error!',
          text: 'Mã token đã hết hạn hoặc không hợp lệ, vui lòng đăng nhập lại!',
          icon: 'error',
          confirmButtonText: 'OK'
        })
        store.commit('gologout')
      }
    })
}
const isFirst = ref(true)
const users = ref()
//Tìm kiếm
const searchLang = () => {
  loadData(true)
}

const loadUser = () => {
  axios
    .post(
      baseURL + '/api/Proc/CallProc',
      {
        proc: 'Users_ListWork',
        par: []
      },
      config
    )
    .then((response) => {
      let data = JSON.parse(response.data.data)[0]
      if (data.length > 0) {
        let arr = []
        data.forEach((element) => {
          // if (element.Name == "Administrator") {
          //   workuser.value.UserId = element.UserId;
          //   checkuser.value.push(element.UserId);
          // }
          arr.push({ name: element.Name, code: element.UserId })
        })
        pUserW.value = arr
      } else {
        pUserW.value = []
      }
      if (isFirst.value) isFirst.value = false
      options.value.loading = false
      swal.close()
    })
    .catch((error) => {
      console.log(error)
      if (error && error.status === 401) {
        swal.fire({
          title: 'Error!',
          text: 'Mã token đã hết hạn hoặc không hợp lệ, vui lòng đăng nhập lại!',
          icon: 'error',
          confirmButtonText: 'OK'
        })
      }
    })
}
//Xóa nhiều
const deleteList = () => {
  let listId = new Array(selectedLangs.value.length)

  swal
    .fire({
      title: 'Thông báo',
      text: 'Bạn có muốn danh sách công việc này không!',
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#3085d6',
      cancelButtonColor: '#d33',
      confirmButtonText: 'Có',
      cancelButtonText: 'Không'
    })
    .then((result) => {
      if (result.isConfirmed) {
        swal.fire({
          width: 110,
          didOpen: () => {
            swal.showLoading()
          }
        })

        selectedLangs.value.forEach((item) => {
          listId.push(item.WorkId)
        })
        axios
          .delete(baseURL + '/api/Works/DeleteWork', {
            headers: { Authorization: `Bearer ${store.getters.token}` },
            data: listId != null ? listId : 1
          })
          .then((response) => {
            swal.close()
            if (response.data.err != '1') {
              swal.close()
              toast.success('Xoá danh sách thành công!')
              checkDelList.value = false

              loadData(true)
            } else {
              swal.fire({
                title: 'Error!',
                text: response.data.ms,
                icon: 'error',
                confirmButtonText: 'OK'
              })
            }
          })
          .catch((error) => {
            swal.close()
            if (error.status === 401) {
              swal.fire({
                title: 'Error!',
                text: 'Mã token đã hết hạn hoặc không hợp lệ, vui lòng đăng nhập lại!',
                icon: 'error',
                confirmButtonText: 'OK'
              })
            }
          })
      }
    })
}
watch(selectedLangs, () => {
  if (selectedLangs.value.length > 0) {
    checkDelList.value = true
  } else {
    checkDelList.value = false
  }
})

const hideRequired = () => {
  if (workuser.value.UserId != null) {
    workuserShow.value = false
  }
  if (userCheck.value.length > 0) {
    workuserShow.value = false
  }
}

onMounted(() => {
  loadData(true)
  loadUser()

  return {
    datalists,
    options,
    onPage,
    loadData,
    openBasic,
    closeDialog,
    basedomainURL,
    handleFileUpload,
    saveWork,
    isFirst,
    searchLang,
    selectedLangs
  }
})
</script>
<template>
  <div v-if="!isCheckWork">
    <div class="d-container">
      <div class="surface-0 ml-2 pt-1">
        <h3><i class="pi pi-folder"></i> Công việc của bạn</h3>
      </div>

      <Toolbar class="d-toolbar">
        <template #start>
          <span class="p-input-icon-left">
            <i class="pi pi-search" />
            <InputText
              v-model="options.SearchText"
              @keyup="searchLang"
              type="text"
              spellcheck="false"
              placeholder="Tìm kiếm"
            />
          </span>
        </template>

        <template #end>
          <SelectButton
            class="mr-2"
            v-model="isCheckWork"
            :options="optionsWork"
            optionLabel="name"
            optionValue="code"
          />
          <Button
            v-if="checkDelList"
            @click="deleteList()"
            label="Xóa"
            icon="pi pi-trash"
            class="mr-2 p-button-danger"
          />

          <Button
            @click="loadData(true)"
            class="mr-2 p-button-outlined p-button-secondary"
            icon="pi pi-refresh"
          />

          <Button
            label="Export"
            icon="pi pi-file-excel"
            class="mr-2 p-button-outlined p-button-secondary"
            @click="toggleExport"
            aria-haspopup="true"
            aria-controls="overlay_Export"
          />
          <Menu id="overlay_Export" ref="menuButs" :model="itemButs" :popup="true" />
        </template>
      </Toolbar>
      <div class="d-lang-table">
        <DataTable
          v-model:filters="filters"
          filterDisplay="menu"
          filterMode="lenient"
          :filters="filters"
          :globalFilterFields="['Name', 'Macode']"
          :scrollable="true"
          scrollHeight="flex"
          :showGridlines="true"
          columnResizeMode="fit"
          :lazy="true"
          :totalRecords="options.totalRecords"
          :loading="options.loading"
          :reorderableColumns="true"
          :value="datalists"
          :paginator="true"
          v-model:rows="options.PageSize"
          paginatorTemplate="  FirstPageLink PrevPageLink PageLinks NextPageLink LastPageLink  RowsPerPageDropdown"
          :rowsPerPageOptions="[5, 10, 20, 50, 100]"
          dataKey="WorkId"
          responsiveLayout="scroll"
          v-model:selection="selectedLangs"
        >
          <Column
            class="align-items-center justify-content-center text-center"
            headerStyle="text-align:center;max-width:70px;height:50px"
            bodyStyle="text-align:center;max-width:70px"
            selectionMode="multiple"
          >
          </Column>

          <Column
            field="STT"
            header="STT"
            class="align-items-center justify-content-center text-center"
            headerStyle="text-align:center;max-width:70px;height:50px"
            bodyStyle="text-align:center;max-width:70px"
          ></Column>
          <Column field="ProjectName" header="Tên dự án" headerStyle="height:50px"> </Column>
          <Column field="StageTarget" header="Giai đoạn" headerStyle="height:50px"> </Column>
          <Column field="WorkName" header="Tên công việc" headerStyle="height:50px"> </Column>

          <Column
            field="WorkImage"
            header="Ảnh đại diện"
            headerStyle="text-align:center;max-width:150px;height:50px"
            bodyStyle="text-align:center;max-width:150px"
            class="align-items-center justify-content-center text-center"
          >
            <template #body="logo">
              <img
                style="object-fit: fill; border: unset; outline: unset"
                width="60"
                height="40"
                alt=" "
                v-bind:src="
                  logo.data.WorkImage
                    ? basedomainURL + logo.data.WorkImage
                    : '/src/assets/image/fails.png'
                "
              />
            </template>
          </Column>
          <Column
            field="WorkStatus"
            header="Trạng thái"
            headerStyle="text-align:center;max-width:200px;height:50px"
            bodyStyle="text-align:center;max-width:200px"
            class="align-items-center justify-content-center text-center"
          >
          </Column>

          <Column
            header="Chức năng"
            class="align-items-center justify-content-center text-center"
            headerStyle="text-align:center;max-width:120px;height:50px"
            bodyStyle="text-align:center;max-width:120px"
          >
            <template #body="Lang">
              <Button
                @click="editWork(Lang.data)"
                class="d-btn-function d-btn-edit"
                type="button"
                icon="pi pi-pencil"
              ></Button>
              <Button
                class="d-btn-function d-btn-delete"
                type="button"
                icon="pi pi-trash"
                @click="delLang(Lang.data)"
              ></Button>
            </template>
          </Column>
          <template #empty>
            <div
              class="align-items-center justify-content-center p-4 text-center m-auto"
              v-if="!isFirst"
            >
              <img src="../../assets/background/nodata.png" height="144" />
              <h3 class="m-1">Không có dữ liệu</h3>
            </div>
          </template>
        </DataTable>
      </div>
      <Dialog
        :header="headerDialog"
        v-model:visible="displayBasic"
        :style="{ width: '50vw' }"
        :closable="false"
      >
        <form>
          <div class="grid formgrid m-2">
            <div class="field flex col-12 md:col-12 mb-0">
              <div class="field col-9 md:col-9 pt-5 mb-0">
                <div class="field col-12 md:col-12 p-0">
                  <label class="col-4 text-left p-0"
                    >Mã công việc <span class="redsao">(*)</span></label
                  >
                  <InputText
                    disabled
                    v-model="work.WorkCode"
                    spellcheck="false"
                    class="col-8 ip36"
                    :class="{ 'p-invalid': v$.WorkCode.$invalid && submitted }"
                  />
                </div>
                <div style="display: flex" class="field col-12 md:col-12">
                  <div class="col-4 text-left"></div>
                  <small
                    v-if="(v$.WorkCode.$invalid && submitted) || v$.WorkCode.$pending.$response"
                    class="col-8 p-error"
                  >
                    <span class="col-12 p-0">{{
                      v$.WorkCode.required.$message
                        .replace('Value', 'Mã công việc')
                        .replace('is required', 'không được để trống')
                    }}</span>
                  </small>
                </div>

                <div class="field col-12 md:col-12 p-0">
                  <label class="col-4 text-left p-0"
                    >Tên công việc<span class="redsao">(*)</span></label
                  >
                  <InputText
                    disabled
                    v-model="work.WorkName"
                    spellcheck="false"
                    class="col-8 ip36"
                    :class="{ 'p-invalid': v$.WorkName.$invalid && submitted }"
                  />
                </div>
                <div style="display: flex" class="field col-12 md:col-12">
                  <div class="col-4 text-left"></div>
                  <small
                    v-if="(v$.WorkName.$invalid && submitted) || v$.WorkName.$pending.$response"
                    class="col-8 p-error"
                  >
                    <span class="col-12 p-0">{{
                      v$.WorkName.required.$message
                        .replace('Value', 'Tên công việc')
                        .replace('is required', 'không được để trống')
                    }}</span>
                  </small>
                </div>
              </div>
              <div class="col-3">
                <div class="field">
                  <label class="col-12 text-rigth p-0">Ảnh đại diện</label>
                  <div class="inputanh" @click="chonanh('AnhLang')">
                    <img
                      id="logoLang"
                      v-bind:src="
                        work.WorkImage
                          ? basedomainURL + work.WorkImage
                          : '/src/assets/image/noimg.jpg'
                      "
                    />
                  </div>
                  <input
                    class="ipnone"
                    id="AnhLang"
                    type="file"
                    accept="image/*"
                    @change="handleFileUpload"
                  />
                </div>
              </div>
            </div>

            <div style="display: flex" class="col-12 field md:col-12 p-0">
              <div class="field col-6 md:col-6 p-0">
                <label class="col-6 text-left">Ngày bắt đầu </label>
                <Calendar disabled v-model="work.WorkStart" class="col-6 ip36 p-0" />
              </div>
              <div class="field col-6 md:col-6 p-0">
                <label class="col-5 text-left">Ngày kết thúc </label>
                <Calendar disabled v-model="work.WorkEnd" class="col-7 ip36 p-0" />
              </div>
            </div>
            <div v-if="isSaveWork" class="col-12 flex field md:col-12">
              <div class="field col-6 md:col-6 p-0">
                <label class="col-6 text-left">Ngày hoàn thành </label>
                <Calendar disabled v-model="work.WorkCompleted" class="col-6 ip36 p-0" />
              </div>
              <div class="field col-6 md:col-6 p-0">
                <label class="col-5 text-left">Trạng thái</label>
                <Dropdown
                  class="col-7"
                  v-model="work.WorkStatus"
                  :options="pStatus"
                  optionLabel="name"
                  optionValue="code"
                />
              </div>
            </div>

            <div class="col-12 field md:col-12 p-0">
              <div class="col-6 flex">
                <label class="col-6 text-left">Số thứ tự </label>
                <InputNumber disabled v-model="work.STT" class="col-6 p-0 ml-2" />
              </div>
            </div>
            <!-- <div class="col-12 flex field md:col-12 p-0">
            <div class="field col-6 md:col-6">
              <label class="col-6 text-left">Người thực hiện</label>
              <Dropdown
                @change="hideRequired()"
                class="col-6 p-0"
                v-model="workuser.UserId"
                :options="pUserW"
                optionLabel="name"
                :filter="true"
                optionValue="code"
              />
              <div style="display: flex" class="field col-12 md:col-12 p-0">
                <small v-if="workuserShow" class="col-12 p-error">
                  <span class="col-12 p-0"
                    >Người thực hiện không được phép trống</span
                  >
                </small>
              </div>
            </div>
            <div class="field col-6 md:col-6">
              <label class="col-5 text-left p-0">Người giám sát</label>
              <MultiSelect
                @change="hideRequired()"
                v-model="userCheck"
                :options="pUserW"
                optionLabel="name"
                class="col-7 p-0"
                :filter="true"
                optionValue="code"
              />
              <div style="display: flex" class="field col-12 md:col-12 p-0">
                <small v-if="checkuserShow" class="col-12 p-error p-0">
                  <span class="col-12 p-0"
                    >Người giám sát không được phép trống</span
                  >
                </small>
                <small v-if="checkuserDup" class="col-12 p-error p-0">
                  <span class="col-12 p-0"
                    >Người giám sát không trùng với người thực hiện</span
                  >
                </small>
              </div>
            </div>
          </div> -->
            <div class="field flex col-12 md:col-12">
              <label class="col-3 text-left">Nội dung</label>

              <Textarea
                v-model="work.WorkDescription"
                :autoResize="true"
                rows="3"
                cols="30"
                spellcheck="false"
                class="col-9 ip36"
              />
            </div>
          </div>
        </form>
        <template #footer>
          <Button
            label="Hủy"
            icon="pi pi-times"
            @click="closeDialog(), loadData(true)"
            class="p-button-text"
          />

          <Button label="Lưu" icon="pi pi-check" @click="saveWork(!v$.$invalid)" autofocus />
        </template>
      </Dialog>
    </div>
  </div>
  <div v-if="isCheckWork">
    <div class="d-container">
      <div class="surface-0 ml-2 pt-1">
        <h3><i class="pi pi-folder"></i> Giám sát công việc</h3>
      </div>

      <Toolbar class="d-toolbar">
        <template #start>
          <span class="p-input-icon-left">
            <i class="pi pi-search" />
            <InputText
              v-model="options.SearchText"
              @keyup="searchLang"
              type="text"
              spellcheck="false"
              placeholder="Tìm kiếm"
            />
          </span>
        </template>

        <template #end>
          <SelectButton
            class="mr-2"
            v-model="isCheckWork"
            :options="optionsWork"
            optionLabel="name"
            optionValue="code"
          />
          <Button
            v-if="checkDelList"
            @click="deleteList()"
            label="Xóa"
            icon="pi pi-trash"
            class="mr-2 p-button-danger"
          />

          <Button
            @click="loadData(true)"
            class="mr-2 p-button-outlined p-button-secondary"
            icon="pi pi-refresh"
          />

          <Button
            label="Export"
            icon="pi pi-file-excel"
            class="mr-2 p-button-outlined p-button-secondary"
            @click="toggleExport"
            aria-haspopup="true"
            aria-controls="overlay_Export"
          />
          <Menu id="overlay_Export" ref="menuButs" :model="itemButs" :popup="true" />
        </template>
      </Toolbar>
      <div class="d-lang-table">
        <DataTable
          v-model:filters="filters"
          filterDisplay="menu"
          filterMode="lenient"
          :filters="filters"
          :globalFilterFields="['Name', 'Macode']"
          :scrollable="true"
          scrollHeight="flex"
          :showGridlines="true"
          columnResizeMode="fit"
          :lazy="true"
          :totalRecords="options.totalRecords"
          :loading="options.loading"
          :reorderableColumns="true"
          :value="listchecks"
          :paginator="true"
          v-model:rows="options.PageSize"
          paginatorTemplate="  FirstPageLink PrevPageLink PageLinks NextPageLink LastPageLink  RowsPerPageDropdown"
          :rowsPerPageOptions="[5, 10, 20, 50, 100]"
          dataKey="WorkId"
          responsiveLayout="scroll"
          v-model:selection="selectedLangs"
        >
          <Column
            class="align-items-center justify-content-center text-center"
            headerStyle="text-align:center;max-width:70px;height:50px"
            bodyStyle="text-align:center;max-width:70px"
            selectionMode="multiple"
          >
          </Column>

          <Column
            field="STT"
            header="STT"
            class="align-items-center justify-content-center text-center"
            headerStyle="text-align:center;max-width:70px;height:50px"
            bodyStyle="text-align:center;max-width:70px"
          ></Column>
          <Column
            field="WorkCode"
            header="Mã"
            class="align-items-center justify-content-center text-center"
            headerStyle="text-align:center;max-width:150px;height:50px"
            bodyStyle="text-align:center;max-width:150px"
          ></Column>
          <Column field="WorkName" header="Tên công việc" headerStyle="height:50px"> </Column>
          <Column
            field="WorkImage"
            header="Ảnh đại diện"
            headerStyle="text-align:center;max-width:150px;height:50px"
            bodyStyle="text-align:center;max-width:150px"
            class="align-items-center justify-content-center text-center"
          >
            <template #body="logo">
              <img
                style="object-fit: fill; border: unset; outline: unset"
                width="60"
                height="40"
                alt=" "
                v-bind:src="
                  logo.data.WorkImage
                    ? basedomainURL + logo.data.WorkImage
                    : '/src/assets/image/fails.png'
                "
              />
            </template>
          </Column>
          <Column
            field="WorkStatus"
            header="Trạng thái công việc"
            headerStyle="text-align:center;max-width:200px;height:50px"
            bodyStyle="text-align:center;max-width:200px"
            class="align-items-center justify-content-center text-center"
          >
          </Column>
          <Column
            field="CheckResult"
            header="Trạng thái duyệt"
            headerStyle="text-align:center;max-width:200px;height:50px"
            bodyStyle="text-align:center;max-width:200px"
            class="align-items-center justify-content-center text-center"
          >
          </Column>

          <Column
            header="Chức năng"
            class="align-items-center justify-content-center text-center"
            headerStyle="text-align:center;max-width:120px;height:50px"
            bodyStyle="text-align:center;max-width:120px"
          >
            <template #body="Lang">
              <Button
                @click="editCheck(Lang.data)"
                class="d-btn-function d-btn-edit"
                type="button"
                icon="pi pi-pencil"
              ></Button>
              <Button
                class="d-btn-function d-btn-delete"
                type="button"
                icon="pi pi-trash"
                @click="delLang(Lang.data)"
              ></Button>
            </template>
          </Column>
          <template #empty>
            <div
              class="align-items-center justify-content-center p-4 text-center m-auto"
              v-if="!isFirst"
            >
              <img src="../../assets/background/nodata.png" height="144" />
              <h3 class="m-1">Không có dữ liệu</h3>
            </div>
          </template>
        </DataTable>
      </div>
      <Dialog header="Kiểm tra công việc" v-model:visible="displayCheck" :style="{ width: '50vw' }">
        <form>
          <div class="grid formgrid m-2">
            <div class="field col-12 md:col-12 mb-0">
              <div class="field col-12" v-if="workcheck.WorkImage">
                <img
                  class="w-full"
                  id="logoLang"
                  v-bind:src="workcheck.WorkImage ? basedomainURL + workcheck.WorkImage : ''"
                />
              </div>
              <div class="col-12 field">
                <label class="col-4 text-left p-0">Mã công việc: {{ workcheck.WorkCode }}</label>
              </div>
              <div class="col-12 field">
                <label class="col-4 text-left p-0">Công việc: {{ workcheck.WorkName }}</label>
              </div>
              <div class="col-12 field flex">
                <label class="col-6 text-left p-0">Ngày bắt đầu: {{ workcheck.WorkStart }}</label>
                <label class="col-6 text-left p-0">Ngày kết thúc: {{ workcheck.WorkEnd }}</label>
              </div>
              <div class="col-12 field flex">
                <label style="vertical-align: text-bottom" class="col-3 text-left p-0 pt-2"
                  >Người thực hiện:
                </label>
                <Dropdown
                  class="col-9 p-0"
                  v-model="workcheck.UserId"
                  :options="pUserW"
                  optionLabel="name"
                  optionValue="code"
                  :disabled="true"
                />
              </div>
              <div class="col-12 field flex">
                <label class="text-left p-0">Nội dung:{{ workcheck.WorkDescription }} </label>
              </div>
            </div>
          </div>
        </form>
        <template #footer>
          <Button label="Hủy" icon="pi pi-times" @click="closeDialog" class="p-button-secondary" />
          <Button
            icon="pi pi-ban"
            label="Không duyệt"
            class="p-button-danger"
            @click="saveCheck(0)"
          />
          <Button
            icon="pi pi-replay"
            label="Làm lại"
            class="p-button-warning"
            @click="saveCheck(1)"
          />
          <Button
            class="p-button-success"
            label="Duyệt"
            icon="pi pi-check"
            @click="saveCheck(2)"
            autofocus
          />
        </template>
      </Dialog>
    </div>
  </div>
</template>

<style scoped>
.d-container {
  background-color: #f5f5f5;
}

.d-lang-header {
  background-color: #ffff;
  padding: 8px 8px 8px 8px;
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
.d-toolbar {
  border: unset;
  outline: unset;
  background-color: #fff;
  margin: 0px 8px 0px 8px;
}
.d-lang-table {
  margin: 0px 8px 0px 8px;
  height: calc(100vh - 187px);
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
.d-btn-edit:hover {
  background-color: rgb(63, 46, 252);
}
.inputanh {
  border: 1px solid #ccc;
  width: 164px;
  height: 108px;
  cursor: pointer;
  padding: 1px;
}
.ipnone {
  display: none;
}
.inputanh img {
  object-fit: cover;
  width: 100%;
  height: 100%;
}
</style>
