import * as API from '../apis/govern';
import Constants from '../constants/ActionTypes';
import { message, Modal, Button } from 'antd';
import WeaTools from '../plugin/wea-tools';

const confirm = Modal.confirm;
export const menuBase = (params) => {
    return (dispatch, getState) => {
        //const action = API.menuBase(params).
        API.menuBase(params).then(({ api_errormsg, api_status, Menu, categorys, countMap, loginUser, needInit }) => {
            if (needInit) {
                confirm({
                    title: '系统提示',
                    content: '环境未初始化，是否初始化数据？',
                    onOk() {
                        dispatch({
                            type: Constants.GOVERN_LOADINIT,
                            spinning: true
                        });
                        API.initSet().then(({}) => {
                            window.location.reload();
                        });
                    },
                    onCancel() { },
                });
            }
            dispatch({
                type: Constants.GOVERN_MENU,
                Menus: Menu,
                loginUser:loginUser
            });
        });
    }
}

export const initPortal = (params) => {
    return (dispatch, getState) => {
        //const action = API.menuBase(params).
        API.initPortal(params).then(({ api_errormsg, api_status, categorys, countMap, portalLink }) => {
            dispatch({
                type: Constants.GOVERN_PORTAL,
                categorys: categorys,
                countMap: countMap,
                portalLink: portalLink,
            });
        });
    }
}


export const getAssignTasks = (params) => {
    return (dispatch, getState) => {
        API.getAssignTasks(params).then(({ api_errormsg, api_status, taskDate, total, current, pagesize, taskLink, projectLink }) => {
            dispatch({
                type: Constants.GOVERN_TASKSEARCH,
                taskDate,
                total,
                current,
                pagesize,
                projectLink,
                taskLink
            });
        });
    }
}

export const getGovernorList = (params) => {
    return (dispatch, getState) => {
        API.getGovernorList(params).then(({ api_errormsg, api_status, taskList, total, current, pagesize ,taskLink, projectLink}) => {
            dispatch({
                type: Constants.GOVERN_LIST,
                taskList,
                total,
                current,
                pagesize,
                projectLink,
                taskLink
            });
        });
    }
}

export const getCateGory = (params) => {
    return (dispatch, getState) => {
        API.getCateGory(params).then(({ api_errormsg, api_status, categoryList, allCount, flowid }) => {
            dispatch({
                type: Constants.GOVERN_CATEGOTYLIST,
                categoryList,
                allCount,
                flowid
            });
        });
    }
}

export const getTaskStatusGroup = (params) => {
    return (dispatch, getState) => {
        API.getTaskStatusGroup(params).then(({ api_errormsg, api_status, taskStatusList, allCount}) => {
            dispatch({
                type: Constants.GOVERN_TASKSTATUSLIST,
                taskStatusList,
                allCount,
            });
        });
    }
}

export const getAssignTaskStatus = (params) => {
    return (dispatch, getState) => {
        API.getAssignTaskStatus(params).then(({ api_errormsg, api_status, assigngroup}) => {
            dispatch({
                type: Constants.GOVERN_ASSIGNGROUP,
                assigngroup,
            });
        });
    }
}

export const getMyTask = (params) => {
    return (dispatch, getState) => {
        API.getMyTask(params).then(({ api_errormsg, api_status, taskDate, total, current, pagesize, taskLink, projectLink }) => {
            dispatch({
                type: Constants.GOVERN_TASKSEARCH,
                taskDate,
                total,
                current,
                pagesize,
                projectLink,
                taskLink
            });
        });
    }
}

export const reportMyTask = (params) => {
    console.log("---------------", params);
    return (dispatch, getState) => {
        API.reportMyTask(params).then(({ api_errormsg, api_status, newrequestid, flowid }) => {
            if (api_status == true && newrequestid > 0) {
                WeaTools.onUrl("taskView" + newrequestid, "汇报表单", "/workflow/request/ViewRequest.jsp?requestid=" + newrequestid + "&_workflowid=" + flowid + "&_workflowtype=&isovertime=0");
            } else {
                message.error(api_errormsg);
            }
        });
    }
}

export const reminderProject = (params) => {
    return (dispatch, getState) => {
        API.reminderProject(params).then(({ api_errormsg, api_status, newrequestid, flowid }) => {
            console.log("------------------newrequestid:", newrequestid);
            if (api_status == true && newrequestid > 0) {
                WeaTools.onUrl("triggerFlow" + newrequestid, "催办流程", "/workflow/request/ViewRequest.jsp?requestid=" + newrequestid + "&_workflowid=" + flowid + "&_workflowtype=&isovertime=0");
            } else {
                message.error(api_errormsg);
            }
        });
    }
}


export const governorPostpone = (params) => {
    return (dispatch, getState) => {
        API.governorPostpone(params).then(({ api_errormsg, api_status, newrequestid, flowid }) => {
            console.log("------------------newrequestid:", newrequestid);
            if (api_status == true && newrequestid > 0) {
                WeaTools.onUrl("changeFlow" + newrequestid, "变更流程", "/workflow/request/ViewRequest.jsp?requestid=" + newrequestid + "&_workflowid=" + flowid + "&field19048=111111");
            } else {
                message.error(api_errormsg);
            }
        });
    }
}

export const updateParm = (params) => {
    // console.log("updateParm params.setId " + params.setId)
    let setId = params.setId;
    return (dispatch, getState) => {
        dispatch({
            type: Constants.GOVERN_SETTING,
            setId: setId,
        });
    }
}

export const buttonShow = (params) => {
    return (dispatch, getState) => {
        API.buttonShow(params).then(({ api_errormsg, api_status,buttons,btnames}) => {
            dispatch({
                type: Constants.GOVERN_BUTTON,
                buttons:buttons,
                btnames:btnames
            });
        });
    }
}

export const getTableTitle = (params) => {
    return (dispatch, getState) => {
        API.getTableTitle(params).then(({ api_errormsg, api_status,titles}) => {
            dispatch({
                type: Constants.GOVERN_TITLE,
                titles:titles
            });
        });
    }
}




