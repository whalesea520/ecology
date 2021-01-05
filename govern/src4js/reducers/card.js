import Constants from '../constants/ActionTypes'

import objectAssign from 'object-assign'

const initialState = {
    datakey: 'SDFHU_1245SDFSJDH',
    isRight: false,
    isEdit: false,
    isDel: false,
    MaxShare: 0,
    isexcel: false,
    layoutid: 0,
    uploadfieldids: [],
    mainFields: [],
    detailTable: [],
    rowcalstr: [],
    colcalstr: [],
    inputentry: [],
    linkage: [],
    defaultvalue: [],
    mainData: [],
    detailData: [],
    RCMenuHeight: 0,
    cornerMenu: [],
    RCMenu: [],
    url: [],
    flagExcute: false,
    flagImport: false,
    flagShare: false,
    flagTrigger: false,
    flagSubmit: false,
    logData: []
}
//init初始化值要和return值格式相同，否则assign后变成空了
export default (state = initialState, action) => {
    // console.log("action:",action);
    switch (action.type) {
        case Constants.CARD_RIGHT:
            return objectAssign({}, state, {
                isRight: action.isRight,
                isEdit: action.isEdit,
                isDel: action.isDel,
                MaxShare: action.isRight
            });
        case Constants.CARD_LAYOUTEXCEL:
            const { base, main: mainData, detail: detailData } = action;
            return objectAssign({}, state, {
                /*isexcel: action.isexcel,
                datajson: action.datajson,
                layoutid: action.layoutid,
                isImportDetail: action.isImportDetail,
                modename: action.modename,
                modedesc: action.modedesc,
                custompage: action.custompage,
                mainFields: action.mainFields,
                detailTable: action.detailTable*/
                ...base,
                mainData,
                detailData
            });
        case Constants.CARD_PAGEINIT:
            return objectAssign({}, state, {
                ...action.base
            });
        case Constants.CARD_FIELDLOAD:
            const newState = objectAssign({}, state, {
                mainData: action.mainData,
                detailData: action.detailData,
                mainFields: action.mainFields
            });
            return newState;
        case Constants.CARD_REPLYLOAD:
            return objectAssign({}, state, {
                replyData: action.replyData,
                replyType: action.replyType,
                top: action.top,
                replyIndex: action.replyIndex
            });
        case Constants.CARD_REPLSHOWDROP:
            return objectAssign({}, state, {
                showType: action.showType
            });
        case Constants.CARD_REPLYCONDITION:
            return objectAssign({}, state, {
                showType: action.showType,
                replySearchData: action.replySearchData
            });
        case Constants.CARD_REPLYLISTLOAD:
            return objectAssign({}, state, {
                replyList: action.replyList,
                showType: action.showType,
                replyType: action.replyType,
                replySearchData: action.replySearchData,
                replyIndex: action.replyIndex,
                replyListData: action.replyListData,
                dataLength: action.dataLength
            });
        case Constants.CARD_REPLYEDIT:
            return objectAssign({}, state, {
                replyListData: action.replyListData,
                replyIndex: action.replyIndex,
                replyType: action.replyType
            });
        case Constants.CARD_REPLYSHOWMORE:
            return objectAssign({}, state, {
                dataLength: action.dataLength
            });
        case Constants.CARD_REPLYLISTDATA:
            return objectAssign({}, state, {
                replyListData: action.replyListData
            });

        case Constants.CARD_LAYOUTHTML:
            return objectAssign({}, state, {
                isexcel: action.isexcel,
                billid: action.billid,
                uploadfieldids: action.uploadfieldids,
                trrigerdetailbuttonfield: action.trrigerdetailbuttonfield,
                jsStr: action.jsStr,
                htmlHiddenElementsb: action.htmlHiddenElementsb,
                needcheck: action.needcheck,
                selectfieldvalue: action.selectfieldvalue,
                isMapLayout: action.isMapLayout,
                hasHtmlMode: action.hasHtmlMode,
                formhtml: action.formhtml,
                layoutversion: action.layoutcss,
                layoutcss: action.layoutcss,
                layoutid: action.layoutid,
                isImportDetail: action.isImportDetail,
                modename: action.modename,
                modedesc: action.modedesc,
                custompage: action.custompage,
                mainFields: action.mainFields,
                detailTable: action.detailTable
            });
        case Constants.CARD_LAYOUTFIELD:
            return objectAssign({}, state, {
                mainFields: action.mainFields,
                detailTable: action.detailTable
            });
        case Constants.CARD_MODEFIELD:
            return objectAssign({}, state, {
                rowcalstr: action.rowcalstr,
                colcalstr: action.colcalstr,
                inputentry: action.inputentry,
                linkage: action.linkage,
                defaultvalue: action.defaultvalue
            });
        case Constants.CARD_MAINDATA:
            return objectAssign({}, state, {
                mainData: action.data
            });
        case Constants.CARD_DETAILDATA:
            return objectAssign({}, state, {
                detailData: action.data
            });
        case Constants.CARD_RIGHTMENU:
            return objectAssign({}, state, {
                RCMenuHeight: action.RCMenuHeight,
                RCMenu: action.RCMenu,
                url: action.url,
                cornerMenu: action.cornerMenu
            });
        case Constants.CARD_MENUACTION:
            return objectAssign({}, state, {
                flagExcute: action.flag
            });
        case Constants.CARD_REPLY:
            return objectAssign({}, state, {
                replyList: action.replyList
            });
        case Constants.CARD_DOCUBMIT:
            return objectAssign({}, state, {
                returnJs: action.returnJs,
                flagSubmit: action.flag
            });
        case Constants.CARD_MODELOG:
            return objectAssign({}, state, {
                logDate: action.logDate
            });
        case Constants.CARD_IMPORT:
            return objectAssign({}, state, {
                returnJs: action.returnJs,
                flagImport: action.count
            });
        case Constants.CARD_SHAREDATA:
            return objectAssign({}, state, {
                flagShare: action.flag
            });
        case Constants.CARD_TRIGGER:
            return objectAssign({}, state, {
                flagTrigger: action.flag
            });
        default:
            return state
    }
}