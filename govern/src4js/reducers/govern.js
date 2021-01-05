import Constants from '../constants/ActionTypes'

import objectAssign from 'object-assign'

const initialState = {
    datakey: 'SDFHU_1245SDFSJDH',
    baseset: {},
    datas: [],
    fields: [],
    operates: [],
    sortParams: [],
    selectedRowKeys: [],
    loading: true,
    dataLoading: true,
    colSetVisible: false,
    colSetdatas: [],
    colSetKeys: [],
    count: 0,
    current: 1,
    pageSize: 10,
    searchAdvanceVisible: false
}
//init初始化值要和return值格式相同，否则assign后变成空了
export default (state = initialState, action) => {
    switch (action.type) {
        case Constants.GOVERN_MENU:
            return objectAssign({}, state, {
                Menus: action.Menus,
                loginUser:action.loginUser
            });
        case Constants.GOVERN_LOADINIT:
            return objectAssign({}, state, {
                spinning: action.spinning
            });
        case Constants.GOVERN_TASKSEARCH:
            return objectAssign({}, state, {
                taskDate: action.taskDate,
                total: action.total,
                current: action.current,
                pagesize: action.pagesize,
                projectLink: action.projectLink,
                taskLink: action.taskLink
            });
        case Constants.GOVERN_LIST:
            return objectAssign({}, state, {
                taskList: action.taskList,
                total: action.total,
                current: action.current,
                pagesize: action.pagesize,
                projectLink: action.projectLink,
                taskLink: action.taskLink
            });
        case Constants.GOVERN_CATEGOTYLIST:
            return objectAssign({}, state, {
                categoryList: action.categoryList,
                allCount: action.allCount,
                flowid: action.flowid,
            });
        case Constants.GOVERN_TASKSTATUSLIST:
            return objectAssign({}, state, {
                taskStatusList: action.taskStatusList,
                allCount: action.allCount,
            });
        case Constants.GOVERN_ASSIGNGROUP:
            return objectAssign({}, state, {
                assigngroup: action.assigngroup
            });
        case Constants.GOVERN_MYTASK:
            return objectAssign({}, state, {
                taskDate: action.taskDate,
                total: action.total,
                current: action.current,
                pagesize: action.pagesize,
                showSearchAd: action.showSearchAd
            });
        case Constants.GOVERN_PORTAL:
            return objectAssign({}, state, {
                categorys: action.categorys,
                countMap: action.countMap,
                portalLink: action.portalLink
            });
        case Constants.GOVERN_SETTING:
            return objectAssign({}, state, {
                setId: action.setId,
            });
        case Constants.GOVERN_BUTTON:
            return objectAssign({}, state, {
                buttons: action.buttons,
                btnames:action.btnames,
        }); 
        case Constants.GOVERN_TITLE:
            return objectAssign({}, state, {
                titles: action.titles,
        });            
        default:
            return state
    }
}