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
    dataLoading:true,
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
    // console.log("action:",action);
    switch (action.type) {
        case Constants.LIST_SET_DATA:
            return objectAssign({}, state, {
                datas: action.datas,
                count: action.count
            });
        case Constants.LIST_SET_FIELD:
            return objectAssign({}, state, {
                fields: action.fields
            });
        case Constants.SEARCH_ADVANCE_VISIBLE:
            const { searchAdvanceVisible } = action;
            return objectAssign({}, state, {
                searchAdvanceVisible
            });
        case Constants.SEARCH_BASE:
            const { baseset } = action;
            return objectAssign({}, state, {
                baseset
            });
        case Constants.SEARCH_FIELDS:
            const { fields } = action;
            return objectAssign({}, state, {
                fields,
            });
        case Constants.SEARCH_DATAS:
            const { datas, current, pageSize, total } = action;
            return objectAssign({}, state, {
                datas, current, pageSize, total
            });
        case Constants.SEARCH_LOADING:
            const { loading,dataLoading } = action;
            return objectAssign({}, state, {
                loading, dataLoading
            });
        default:
            return state
    }
}