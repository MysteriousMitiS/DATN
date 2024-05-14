<script setup>
import { useVuelidate } from '@vuelidate/core'
import { required } from '@vuelidate/validators'
import { FilterMatchMode, FilterOperator } from 'primevue/api'
import { inject, onMounted, ref, watch } from 'vue'
import { useToast } from 'vue-toastification'

import ClassicEditor from '@ckeditor/ckeditor5-build-classic'

//Khai báo
const axios = inject('axios')
const store = inject('store')
const swal = inject('$swal')
const basedomainURL = baseURL
const selectedNews = ref()
const checkDelList = ref(false)
const rules = {
  News_Name: {
    required,
    $errors: [
      {
        $property: 'News_Name',
        $validator: 'required',
        $message: 'Tên tin tức không được để trống!'
      }
    ]
  },
  Details: {
    required,
    $errors: [
      {
        $property: 'Details',
        $validator: 'required',
        $message: 'Nội dung tin tức không được để trống!'
      }
    ]
  }
}

const editor = ref(ClassicEditor)
const editorConfig = ref({
  toolbar: [
    'heading',
    'bold',
    'italic',
    'underline',
    'Link',
    '|',
    'alignment',
    'bulletedList',
    'numberedList',
    '|',
    'fontColor',
    'fontBackgroundColor',
    'fontFamily',
    'fontSize',
    'highlight',
    '|',
    'insertImage',
    'mediaEmbed',
    'horizontalLine',
    '|',
    'insertTable',
    'tableColumn',
    'tableRow',
    'mergeTableCells',
    '|',

    'imageStyle:inline',
    'imageStyle:block',
    'imageStyle:side',
    'toggleImageCaption',
    'imageTextAlternative',
    '|',

    'strikethrough',
    'outdent',
    'indent',
    '|',
    'codeBlock',
    'linkImage',
    'blockQuote',
    'code',
    'subscript',
    'superscript',
    '|',
    'undo',
    'redo',
    'findAndReplace'
  ],
  indentBlock: {
    offset: 1,
    unit: 'em'
  },
  removePlugins: ['MediaEmbedToolbar']
})

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
        excelname: 'DANH SÁCH TIN TỨC',
        proc: 'News_ListExport',
        par: [{ par: 'Search', va: options.value.SearchText }]
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
//Xóa tin tức

const delNews = (News) => {
  swal
    .fire({
      title: 'Thông báo',
      text: 'Bạn có muốn xoá tin tức này không!',
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

        axios
          .delete(baseURL + '/api/News/DeleteNews', {
            headers: { Authorization: `Bearer ${store.getters.token}` },
            data: News != null ? [News.News_ID] : 1
          })
          .then((response) => {
            swal.close()
            if (response.data.err != '1') {
              swal.close()
              toast.success('Xoá tin tức thành công!')
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

const filters = ref({
  global: { value: null, matchMode: FilterMatchMode.CONTAINS },
  News_Name: {
    operator: FilterOperator.AND,
    constraints: [{ value: null, matchMode: FilterMatchMode.STARTS_WITH }]
  },
  StartDate: {
    operator: FilterOperator.AND,
    constraints: [{ value: null, matchMode: FilterMatchMode.DATE_IS }]
  },
  IsHot: {
    operator: FilterOperator.AND,
    constraints: [{ value: null, matchMode: FilterMatchMode.EQUALS }]
  },
  Trangthai: {
    operator: FilterOperator.AND,
    constraints: [{ value: null, matchMode: FilterMatchMode.EQUALS }]
  }
})
//Phân trang dữ liệu
const onPage = (event) => {
  options.value.PageNo = event.page + 1
  loadData()
}
const filterSQL = ref([])
const isDynamicSQL = ref(false)
const loadDataSQL = () => {
  let data = {
    next: options.value.IsNext,
    sqlO: options.value.sort,
    Search: options.value.SearchText,
    PageNo: options.value.PageNo,
    PageSize: options.value.PageSize,
    fieldSQLS: filterSQL.value
  }

  options.value.loading = true
  axios
    .post(baseURL + '/api/SQL/FilterCMS_News', data, config)
    .then((response) => {
      let dt = JSON.parse(response.data.data)

      let data = dt[0]

      if (data.length > 0) {
        data.forEach((element) => {
          if (element.StartDate != null) {
            let date = element.StartDate.split('T')
            let dateStart = date[0].split('-')
            element.StartDate = dateStart[2] + '/' + dateStart[1] + '/' + dateStart[0]
          }
          if (element.EndDate != null) {
            let date1 = element.EndDate.split('T')
            let dateEnd = date1[0].split('-')
            element.EndDate = dateEnd[2] + '/' + dateEnd[1] + '/' + dateEnd[0]
          }
        })

        datalists.value = data
      } else {
        datalists.value = []
      }
      if (isFirst.value) isFirst.value = false
      options.value.loading = false
      //Show Count nếu có
      if (dt.length == 2) {
        options.value.totalRecords = dt[1][0].totalRecords
      }
    })
    .catch((error) => {
      options.value.loading = false
      toast.error('Tải dữ liệu không thành công!')

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
//Sort
const onSort = (event) => {
  options.value.sort = event.sortField + (event.sortOrder == 1 ? ' ASC' : ' DESC')
  if (event.sortField != 'News_ID') {
    options.value.sort += ',News_ID ' + (event.sortOrder == 1 ? ' ASC' : ' DESC')
  }
  isDynamicSQL.value = true

  loadData()
}
const onFilter = (event) => {
  filterSQL.value = []

  for (const [key, value] of Object.entries(event.filters)) {
    if (key != 'global') {
      let obj = {
        key: key,
        filteroperator: value.operator,
        filterconstraints: value.constraints
      }
      if (value.value && value.value.length > 0) {
        obj.filteroperator = value.matchMode
        obj.filterconstraints = []
        value.value.forEach(function (vl) {
          obj.filterconstraints.push({ value: vl[obj.key] })
        })
      } else if (value.matchMode) {
        obj.filteroperator = 'and'
        obj.filterconstraints = [value]
      }
      if (obj.filterconstraints && obj.filterconstraints.filter((x) => x.value != null).length > 0)
        filterSQL.value.push(obj)
    }
  }

  options.value.PageNo = 1
  options.value.id = null
  isDynamicSQL.value = true
  loadData()
}
//DropDown

const onDropDown = (value) => {
  let data = {
    IntID: value.News_ID,
    TextID: value.News_ID + '',
    IntTrangthai: value.Trangthai,
    BitTrangthai: false
  }
  axios
    .put(baseURL + '/api/News/Update_Trangthai', data, config)
    .then((response) => {
      if (response.data.err != '1') {
        swal.close()
        toast.success('Sửa trạng thái thành công!')
        loadData(true)
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
//Xóa nhiều
const deleteList = () => {
  let listId = new Array(selectedNews.value.length)

  swal
    .fire({
      title: 'Thông báo',
      text: 'Bạn có muốn xóa danh sách tin tức này không!',
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
        selectedNews.value.forEach((item) => {
          listId.push(item.News_ID)
        })
        axios
          .delete(baseURL + '/api/News/DeleteNews', {
            headers: { Authorization: `Bearer ${store.getters.token}` },
            data: listId != null ? listId : 1
          })
          .then((response) => {
            swal.close()
            if (response.data.err != '1') {
              swal.close()
              toast.success('Xoá tin tức thành công!')
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
//Lấy file ảnh
const chonanh = (id) => {
  document.getElementById(id).click()
}
let files = []
const handleFileUpload = (event) => {
  files = event.target.files
  var output = document.getElementById('logoLang')
  output.src = URL.createObjectURL(event.target.files[0])
  output.onload = function () {
    URL.revokeObjectURL(output.src) // free memory
  }
}
const toast = useToast()
const isFirst = ref(true)
const datalists = ref()
const isSaveNews = ref(false)
const sttNews = ref(1)
const config = {
  headers: { Authorization: `Bearer ${store.getters.token}` }
}
const submitted = ref(false)
const options = ref({
  IsNext: true,
  sort: 'News_ID DESC',
  SearchText: '',
  PageNo: 1,
  PageSize: 10,

  loading: true,
  totalRecords: null
})
const tinTuc = ref({
  STT: 1,
  News_Name: '',
  Contents: '',
  Details: '',
  Image: '',
  NewType: 0,
  Keywords: '',

  StartDate: '',
  EndDate: null,
  Trangthai: false
})
const v$ = useVuelidate(rules, tinTuc)
const loaiTinTuc = ref([
  { name: 'Tin bình thường', code: 0 },
  { name: 'Tin ảnh', code: 1 },
  { name: 'Tin video', code: -1 }
])
const trangThai = ref([
  { name: 'Chưa duyệt', code: 0 },
  { name: 'Đã duyệt', code: 1 },
  { name: 'Không duyệt', code: -1 }
])
const loaiTin = ref([
  { name: 'Tin tức', code: 0 },
  { name: 'Thông báo', code: 1 }
])
const danhMuc = ref()
//METHOD
const displayDetails = ref(false)
const openDetails = (data) => {
  displayDetails.value = true
  tinTuc.value = data
}
const closeDetails = () => {
  displayDetails.value = false
  tinTuc.value = {}
}
const loadCount = () => {
  axios
    .post(
      baseURL + '/api/Proc/CallProc',
      {
        proc: 'News_Count',
        par: [
          { par: 'News_ID', va: options.value.News_ID },
          { par: 'Search', va: options.value.SearchText }
        ]
      },
      config
    )
    .then((response) => {
      let data = JSON.parse(response.data.data)[0]
      if (data.length > 0) {
        options.value.totalRecords = data[0].totalRecords
        sttNews.value = data[0].totalRecords + 1
      }
    })
    .catch((error) => {})
}
const saveNews = (isFormValid) => {
  submitted.value = true
  if (!isFormValid) {
    return
  }
  if (typeof tinTuc.value.StartDate == 'string') {
    var startDay = tinTuc.value.StartDate.split('/')
    tinTuc.value.StartDate = new Date(startDay[2] + '/' + startDay[1] + '/' + startDay[0])
  }
  if (typeof tinTuc.value.EndDate == 'string') {
    var endDay = tinTuc.value.EndDate.split('/')
    tinTuc.value.EndDate = new Date(endDay[2] + '/' + endDay[1] + '/' + endDay[0])
  }
  let formData = new FormData()
  for (var i = 0; i < files.length; i++) {
    let file = files[i]
    formData.append('image', file)
  }
  formData.append('tintuc', JSON.stringify(tinTuc.value))
  swal.fire({
    width: 110,
    didOpen: () => {
      swal.showLoading()
    }
  })
  if (!isSaveNews.value) {
    axios
      .post(baseURL + '/api/News/AddNews', formData, config)
      .then((response) => {
        if (response.data.err != '1') {
          swal.close()
          toast.success('Thêm tin tức thành công!')
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
  } else {
    axios
      .put(baseURL + '/api/News/UpdateNews', formData, config)
      .then((response) => {
        if (response.data.err != '1') {
          swal.close()
          toast.success('Sửa tin tức thành công!')
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
  }
}
watch(selectedNews, () => {
  if (selectedNews.value.length > 0) {
    checkDelList.value = true
  } else {
    checkDelList.value = false
  }
})
const StartDateConvert = ref(new Date('1970/01/01'))
//Sửa bản ghi
const editNews = (data) => {
  submitted.value = false
  files.value = []
  if (typeof data.StartDate == 'string') {
    var startDay = data.StartDate.split('/')
    StartDateConvert.value = new Date(startDay[2] + '/' + startDay[1] + '/' + startDay[0])
  }
  if (data.Keywords != null && data.Keywords.length > 1) {
    if (!Array.isArray(data.Keywords)) {
      data.Keywords = data.Keywords.split(',')
    }
  }

  tinTuc.value = data
  headerDialog.value = 'Sửa tin tức'
  isSaveNews.value = true
  displayBasic.value = true
}
//Hiển thị dialog
const headerDialog = ref()
const displayBasic = ref(false)
const danhMucAdd = ref()
const openBasic = (str) => {
  tinTuc.value = {
    NewType: 0,
    Trangthai: 0,
    STT: sttNews.value
  }
  files.value = []
  submitted.value = false
  headerDialog.value = str
  isSaveNews.value = false
  displayBasic.value = true
}
const closeDialog = () => {
  displayBasic.value = false
}
const listMenu = ref()
const relateNew = ref([])
const loadData = (rf) => {
  if (isDynamicSQL.value) {
    loadDataSQL()
    return false
  }
  options.value.loading = true

  if (rf) {
    loadCount()
  }
  axios
    .post(
      baseURL + '/api/Proc/CallProc',
      {
        proc: 'News_List',
        par: [
          { par: 'Search', va: options.value.SearchText },
          { par: 'PageNo', va: options.value.PageNo },
          { par: 'PageSize', va: options.value.PageSize }
        ]
      },
      config
    )
    .then((response) => {
      let data = JSON.parse(response.data.data)[0]
      if (data.length > 0) {
        relateNew.value = []
        data.forEach((element, i) => {
          element.STT = i + 1
          if (element.StartDate != null) {
            var date = element.StartDate.split('T')[0]
            var startDay = date.split('-')
            element.StartDate = startDay[2] + '/' + startDay[1] + '/' + startDay[0]
          }
          if (element.EndDate != null) {
            var date1 = element.EndDate.split('T')[0]
            var endDay = date1.split('-')
            element.EndDate = endDay[2] + '/' + endDay[1] + '/' + endDay[0]
          }
          relateNew.value.push({
            name: element.News_Name,
            code: element.News_ID
          })
        })
        Array.from(new Set(relateNew.value))

        datalists.value = data
        console.log('Dữ liệu', relateNew.value)
      } else {
        datalists.value = []
      }
      if (isFirst.value) isFirst.value = false
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

const filterButs = ref()
const itemfilterButs = ref([
  {
    label: 'Trạng thái',
    check: false
  }
])

//Khai báo function
const toggleFilter = (event) => {
  if (showFilter.value) {
    showFilter.value = false
  } else {
    showFilter.value = true
  }
}
const filterTrangthai = ref()
const showFilter = ref(false)
const reFilterNews = () => {
  filterTrangthai.value = null
  filterNews()
  showFilter.value = false
}
const filterNews = () => {
  filterSQL.value = []
  let arr = []
  let obj = {}
  let obj1 = {}
  if (filterTrangthai.value != null) {
    obj1.key = 'Trangthai'
    obj1.filteroperator = 'and'
    arr = []
    arr.push({
      matchMode: 'equals',
      value: filterTrangthai.value
    })
    obj1.filterconstraints = arr
    filterSQL.value.push(obj1)
  }

  options.value.PageNo = 1
  options.value.id = null
  isDynamicSQL.value = true
  showFilter.value = false
  loadData()
}
//Tìm kiếm
const searchNews = () => {
  isDynamicSQL.value = false

  loadData(true)
}
onMounted(() => {
  loadData(true)
  return {
    isFirst,
    options,
    danhMuc
  }
})
</script>

<template>
  <div class="d-container">
    <div class="d-lang-header">
      <h3 class="d-module-title">
        <i class="pi pi-id-card"></i> Danh sách tin tức ({{ options.totalRecords }})
      </h3>
    </div>
    <Toolbar class="d-toolbar">
      <template #start>
        <span class="p-input-icon-left">
          <i class="pi pi-search" />
          <InputText
            v-model="options.SearchText"
            @keypress.enter="searchNews()"
            type="text"
            spellcheck="false"
            placeholder="Tìm kiếm"
          />
          <Button
            class="ml-2 p-button-outlined p-button-secondary"
            icon="pi pi-filter"
            @click="toggleFilter"
            aria-haspopup="true"
            aria-controls="overlay_filter"
          />
          <Menu
            style="width: 260px; position: absolute; z-index: 1000"
            id="overlay_filter"
            ref="filterButs"
            :model="itemfilterButs"
            v-if="showFilter"
          >
            <template #item="{ item }">
              <div class="grid formgrid m-2">
                <div class="field col-12 md:col-12">
                  <div v-if="item.check" style="display: flex" class="col-12 p-0"></div>
                  <span v-else>
                    {{ item.label }}:
                    <Dropdown
                      v-model="filterTrangthai"
                      :options="trangThai"
                      optionLabel="name"
                      optionValue="code"
                      placeholder="Trạng thái"
                    />

                    <Toolbar class="toolbar-filter">
                      <template #start>
                        <Button
                          @click="reFilterNews"
                          class="p-button-outlined"
                          label="Xóa"
                        ></Button>
                      </template>
                      <template #end>
                        <Button @click="filterNews" label="Lọc"></Button>
                      </template>
                    </Toolbar>
                  </span>
                </div>
              </div>
            </template>
          </Menu>
        </span>
      </template>

      <template #end>
        <Button
          v-if="checkDelList"
          @click="deleteList()"
          label="Xóa"
          icon="pi pi-trash"
          class="mr-2 p-button-danger"
        />
        <Button
          @click="openBasic('Thêm tin tức')"
          label="Thêm tin tức"
          icon="pi pi-plus"
          class="mr-2"
        />
        <Button
          class="mr-2 p-button-outlined p-button-secondary"
          icon="pi pi-refresh"
          @click="loadData(true)"
        />

        <Button
          label="Export"
          icon="pi pi-file-excel"
          class="mr-2 p-button-outlined p-button-secondary"
          aria-haspopup="true"
          aria-controls="overlay_Export"
          @click="toggleExport"
        />
        <Menu id="overlay_Export" ref="menuButs" :model="itemButs" :popup="true" />
      </template>
    </Toolbar>
    <div class="d-lang-table">
      <DataTable
        class="w-full p-datatable-sm e-sm"
        @page="onPage($event)"
        @filter="onFilter($event)"
        @sort="onSort($event)"
        v-model:filters="filters"
        filterDisplay="menu"
        filterMode="lenient"
        dataKey="News_ID"
        responsiveLayout="scroll"
        :scrollable="true"
        scrollHeight="flex"
        :showGridlines="true"
        :rows="options.PageSize"
        :lazy="true"
        :value="datalists"
        :loading="options.loading"
        :paginator="options.totalRecords > options.PageSize"
        :totalRecords="options.totalRecords"
        v-model:selection="selectedNews"
      >
        <Column
          class="align-items-center justify-content-center text-center"
          headerStyle="text-align:center;max-width:50px;height:50px"
          bodyStyle="text-align:center;max-width:50px"
          selectionMode="multiple"
        >
        </Column>
        <Column
          class="align-items-center justify-content-center text-center"
          headerStyle="text-align:center;max-width:70px;height:50px"
          bodyStyle="text-align:center;max-width:70px"
          field="STT"
          header="STT"
        ></Column>
        <Column
          headerStyle="text-align:left;height:50px"
          bodyStyle="text-align:left;"
          field="News_Name"
          header="Tin tức"
        >
          <template #filter="{ filterModel }">
            <InputText
              type="text"
              v-model="filterModel.value"
              class="p-column-filter"
              placeholder="Từ khoá"
            />
          </template>
        </Column>
        <Column
          class="align-items-center justify-content-center text-center"
          headerStyle="text-align:center;max-width:120px;height:50px"
          bodyStyle="text-align:center;max-width:120px"
          field="Image"
          header="Ảnh đại diện"
        >
          <template #body="data">
            <img
              style="object-fit: contain; border: unset; outline: unset"
              width="150"
              height="50"
              alt=" "
              v-bind:src="
                data.data.Image ? basedomainURL + data.data.Image : '/src/assets/image/fails.png'
              "
            />
          </template>
        </Column>
        <Column
          class="align-items-center justify-content-center text-center"
          headerStyle="text-align:center;max-width:200px;height:50px"
          bodyStyle="text-align:center;max-width:200px"
          field="StartDate"
          header="Ngày đăng"
        >
        </Column>
        <Column
          class="align-items-center justify-content-center text-center"
          headerStyle="text-align:center;max-width:150px;height:50px"
          bodyStyle="text-align:center;max-width:150px"
          field="CreateBy"
          header="Người đăng"
        ></Column>

        <Column
          class="align-items-center justify-content-center text-center"
          headerStyle="text-align:center;max-width:180px;height:50px"
          bodyStyle="text-align:center;max-width:180px"
          field="Trangthai"
          header="Trạng thái"
        >
          <template #body="data">
            <Dropdown
              @change="onDropDown(data.data)"
              class="col-11"
              v-model="data.data.Trangthai"
              :options="trangThai"
              optionLabel="name"
              optionValue="code"
            />
          </template>
        </Column>
        <Column
          class="align-items-center justify-content-center text-center"
          headerStyle="text-align:center;max-width:150px;height:50px"
          bodyStyle="text-align:center;max-width:150px"
          header="Chức năng"
        >
          <template #body="News">
            <Button
              @click="openDetails(News.data)"
              class="d-btn-function d-btn-infor"
              type="button"
              icon="pi pi-info-circle"
            ></Button>
            <Button
              @click="editNews(News.data)"
              class="d-btn-function d-btn-edit"
              type="button"
              icon="pi pi-pencil"
            ></Button>
            <Button
              class="d-btn-function d-btn-delete"
              type="button"
              icon="pi pi-trash"
              @click="delNews(News.data)"
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
          <span style="color: cornflowerblue; fon-size: 14px">{{ tinTuc.CreateBy }},</span>
          <i style="padding: 0px 12px" class="pi pi-clock"></i
          ><span>Ngày: {{ tinTuc.StartDate }}</span>
        </div>
        <div class="field col-12 md:col-12">
          <hr />
        </div>
        <div class="field col-12 md:col-12">
          <h3>{{ tinTuc.Contents }}</h3>
        </div>
        <div v-if="tinTuc.Image ? true : false" class="d-avatar-news field col-12 md:col-12">
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
  <Dialog
    @hide="closeDialog"
    :header="headerDialog"
    v-model:visible="displayBasic"
    :maximizable="true"
    :style="{ width: '60vw' }"
  >
    <form>
      <div class="grid formgrid m-2">
        <div style="display: flex" class="field col-12 md:col-12">
          <div class="col-8 p-0">
            <div class="col-12 p-0">
              <div class="col-4 text-left p-0 pb-2">
                Tên tin tức <span class="redsao">(*)</span>
              </div>
              <InputText v-model="tinTuc.News_Name" spellcheck="false" class="col-11 ip36" />

              <div class="col-4 text-left"></div>
              <small
                v-if="(v$.News_Name.$invalid && submitted) || v$.News_Name.$pending.$response"
                class="col-8 p-error p-0"
              >
                <span class="col-12 p-0">{{
                  v$.News_Name.required.$message
                    .replace('Value', 'Tên tin tức')
                    .replace('is required', 'không được để trống')
                }}</span>
              </small>
            </div>
            <div class="col-12 p-0">
              <label class="col-12 text-left p-0 pb-2">Mô tả</label>
              <div></div>
              <Textarea
                v-model="tinTuc.Contents"
                :autoResize="true"
                rows="3"
                cols="30"
                spellcheck="false"
                class="col-11 ip36"
              />
            </div>
          </div>

          <div class="col-4 p-0 pb-2">
            <label class="col-12 text-left p-0">Ảnh đại diện</label>

            <div class="inputanh" @click="chonanh('AnhLang')">
              <img
                id="logoLang"
                v-bind:src="
                  tinTuc.Image ? basedomainURL + tinTuc.Image : '/src/assets/image/noimg.jpg'
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

        <div class="field col-12 md:col-12">
          <label class="col-12 text-left p-0">Nội dung <span class="redsao">(*)</span></label>
          <span class="col-12 ip36">
            <ckeditor :editor="editor" :config="editorConfig" v-model="tinTuc.Details"></ckeditor
          ></span>

          <div class="col-4 text-left"></div>
          <small
            v-if="(v$.Details.$invalid && submitted) || v$.Details.$pending.$response"
            class="col-8 p-error p-0"
          >
            <span class="col-12 p-0">{{
              v$.Details.required.$message
                .replace('Value', 'Nội dung tin tức')
                .replace('is required', 'không được để trống')
            }}</span>
          </small>
        </div>
        <div style="display: flex" class="field col-12 md:col-12">
          <div class="col-3 p-0">
            <div class="col-12 text-left p-0 pb-2">Trạng thái</div>
            <span>
              <Dropdown
                class="col-11"
                v-model="tinTuc.Trangthai"
                :options="trangThai"
                optionLabel="name"
                optionValue="code"
                :disabled="!isSaveNews"
            /></span>
          </div>
          <div class="col-3 p-0">
            <div class="col-12 text-left p-0 pb-2">Ngày đăng</div>
            <Calendar
              class="col-11 p-0"
              id="basic"
              v-model="tinTuc.StartDate"
              autocomplete="on"
              :minDate="new Date()"
            />
          </div>
          <div class="col-3 p-0">
            <div class="col-12 text-left p-0 pb-2">Ngày hết hạn</div>
            <Calendar :minDate="new Date()" class="col-12" id="basic" v-model="tinTuc.EndDate" />
          </div>
          <div class="col-3">
            <div class="col-12 text-left p-0 pb-2">Loại tin</div>
            <Dropdown
              class="col-12"
              v-model="tinTuc.IsType"
              :options="loaiTin"
              optionLabel="name"
              optionValue="code"
            />
          </div>
        </div>
      </div>
    </form>
    <template #footer>
      <Button label="Hủy" icon="pi pi-times" @click="closeDialog()" class="p-button-text" />

      <Button @click="saveNews(!v$.$invalid)" label="Lưu" icon="pi pi-check" autofocus />
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
.d-btn-infor {
  background-color: rgb(56, 180, 187);
  border: 1px solid rgb(106, 173, 139);
}
.d-btn-infor:hover {
  background-color: rgb(125, 221, 150);
  border: 1px solid rgb(214, 125, 125);
}
.d-btn-edit:hover {
  background-color: rgb(63, 46, 252);
}
.inputanh {
  border: 1px solid #ccc;
  width: 248px;
  height: 124px;
  cursor: pointer;
  margin-top: 8px;
  padding: 1px;
}
.ipnone {
  display: none;
}
.inputanh img {
  object-fit: contain;
  background-color: #eeeeee;
  width: 100%;
  height: 100%;
}
.d-avatar-news {
  position: relative;
  width: 100%;
  height: 350px;
}
.d-avatar-news img {
  position: absolute;
  top: 50%;
  width: 100%;
  left: 50%;
  height: 350px;
  transform: translate(-50%, -50%);
  object-fit: contain;
}
.toolbar-filter {
  border: unset;
  outline: unset;
  background-color: #fff;
  padding-bottom: 0px;
}
</style>
