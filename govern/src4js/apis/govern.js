import WeaTools from '../plugin/wea-tools';

export const url = "/govern/interfaces/governAction.jsp?";
export const taskUrl = "/govern/interfaces/governTaskAction.jsp?";

export const menuBase = (params) => {
    return WeaTools.callApi(`${url}action=menuBase`, 'POST', params);
}
export const getAssignTasks = (params) => {
    return WeaTools.callApi(`${url}action=getAssignTasks`, 'POST', params);
}
export const getGovernorList = (params) => {
    return WeaTools.callApi(`${url}action=getGovernorList`, 'POST', params);
}
export const getCateGory = (params) => {
    return WeaTools.callApi(`${url}action=getCateGory`, 'POST', params);
}
export const getMyTask = (params) => {
    return WeaTools.callApi(`${url}action=getMyTasks`, 'POST', params);
}
export const initPortal = (params) => {
    return WeaTools.callApi(`${url}action=initPortal`, 'POST', params);
}
export const reportMyTask = (params) => {
    return WeaTools.callApi(`${url}action=reportMyTask`, 'POST', params);
}
export const reminderProject = (params) => {
    return WeaTools.callApi(`${url}action=reminderProject`, 'POST', params);
}
export const governorPostpone = (params) => {
    return WeaTools.callApi(`${url}action=governorPostpone`, 'POST', params);
}
export const getTaskStatusGroup = (params) => {
    return WeaTools.callApi(`${url}action=getTaskStatusGroup`, 'POST', params);
}
export const getAssignTaskStatus = (params) => {
    return WeaTools.callApi(`${url}action=assignTaskStatus`, 'POST', params);
}
export const buttonShow = (params) => {
    return WeaTools.callApi(`${url}action=buttons`, 'POST', params);
}
export const getTableTitle = (params) => {
    return WeaTools.callApi(`${url}action=titles`, 'POST', params);
}
export const initSet = (params) => {
    return WeaTools.callApi('/govern/interfaces/governInit.jsp', 'POST', params);
}

