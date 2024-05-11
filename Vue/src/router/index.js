import { createRouter, createWebHistory } from "vue-router";
const HomeView = () =>
    import ('../views/HomeView.vue')
const UserView = () =>
    import ('../views/hethong/UserView.vue')

const LoginView = () =>
    import ('../views/LoginView.vue')
const ProjectView = () =>
    import ('../views/danhmuc/ProjectView.vue')
const WorkView = () =>
    import ('../views/danhmuc/WorkView.vue')
const NewsView = () =>
    import ('../views/danhmuc/News.vue')
const YourWork = () =>
    import ('../views/danhmuc/YourWork.vue')
const router = createRouter({
    history: createWebHistory(
        import.meta.env.BASE_URL),
    routes: [{
            path: "/",
            name: "home",
            component: HomeView,
        },
        //Danh mục

        {
            path: "/project",
            name: "project",
            component: ProjectView,
        },
        {
            path: "/work",
            name: "work",
            component: WorkView,
        },
        {
            path: "/yourwork",
            name: "yourwork",
            component: YourWork,
        },
        {
            path: "/news",
            name: "news",
            component: NewsView,
        },






        {
            path: "/user",
            name: "user",
            component: UserView,
        },

        {
            path: "/login",
            name: "login",
            component: LoginView,
        },

    ],
});

export default router;