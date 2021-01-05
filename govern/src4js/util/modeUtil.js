import { notification, Modal } from 'antd';
import * as API from '../apis/card';

/** 
 * 布局init之后对布局js部分渲染
 */
export const initJs = (rightmenu, mainFields, modeField, objthis) => {
    var _initJs = document.getElementById("initJs");
    if (!_initJs) {//如果已经加载过 重新渲染时不重新加载js
        var script = document.createElement('script');
        script.type = "text/javascript";
        script.id = "initJs";
        var initJs = "";

        //加载按钮js
        let urlMap = rightmenu ? rightmenu.url : {};
        if (urlMap) {
            for (let item in urlMap) {
                let hreftarget = urlMap[item].hreftarget;
                initJs += ("var url_id_" + item + " = \"" + hreftarget + "\";");
            }
        }

        //加载必填js
        if (mainFields) {
            let needCheckStr = "";
            for (let item in mainFields) {
                let ismandatory = mainFields[item].ismandatory;
                if (ismandatory == "1") {
                    needCheckStr += (",field" + item);
                }
            }
            initJs += ("var needcheck=\"" + needCheckStr + "\";");
        }
        initJs += "var page;var util;"
        script.innerHTML = initJs;
        document.body.appendChild(script);
        page = objthis;
        util = this;

        let type = objthis.props.type;
        let showReply = objthis.props.showReply;
        if (showReply && type == "0") {//如果是显示布局 并且开启了回复评论 给页面主体表单以及底部评论列表绑定点击隐藏评论区域事件
            jQuery("#modeForm").bind('mousedown', window.modeForm.changeReplyAttr);
            jQuery("#replyList").bind('mousedown', window.modeForm.changeReplyAttr);
        }

        //加载布局js
        let scripts = modeField ? modeField.scripts : "";
        if (scripts) {
            var script = document.createElement('script');
            script.innerHTML = scripts;
            document.body.appendChild(script);
        }
        let jsArr = modeField ? modeField.jsArr : null;
        if (jsArr) {
            for (let j = 0; j < jsArr.length; j++) {
                let jsSrc = jsArr[j];
                var srcJs = document.createElement('script');
                srcJs.type = "text/javascript";
                srcJs.src = jsSrc;
                document.head.appendChild(srcJs);
            }

        }

        //下面添加一个测试按钮调用组建里的元素
        /*var newDiv=document.createElement("div");
        newDiv.id="Chuang";
        newDiv.style.position="absolute";
        newDiv.style.zIndex = "9999";
        newDiv.style.width = "300px";
        newDiv.style.height = "26px";
        newDiv.style.top = (parseInt(document.body.scrollHeight) - 300) / 2 + "px";
        newDiv.style.left = (parseInt(document.body.scrollWidth) - 300) / 2 + "px";
        newDiv.style.background="#FFFFFF";
        newDiv.style.border="solid 1px #FF0000";  
        var e = document.createElement("input");
        e.type = "button";
        e.id="12312";
        e.value = "这是测试加载的小例子";
        var object = newDiv.appendChild(e);
        document.body.appendChild(object);
        jQuery("#12312").click(function(event) {
            _this.addrow("detail_1");
        });*/
        //_thisProp.addrow("detail_1");
    }
}

export const setValue = (id, key, name) => {
    alert(id);
}
/**
 * 表单必填内容校验
 */
export const check_form = (needcheck, mainFields, detailData) => {
    try {
        var nc = needcheck.split(",");
        for (let i = 0; i < nc.length; i++) {
            let id = nc[i];
            if (id != "") {
                let fieldid;
                if (id.indexOf("_") > 0) {
                    let ids = id.split("_");
                    fieldid = ids[0].substring(5);
                } else {
                    fieldid = id.substring(5);
                }
                let field = mainFields[fieldid];
                let fieldname = field.fieldname;
                if (field.detailtable && id.indexOf("_") < 0) {
                    let tablename = field.detailtable;
                    let size = detailData.data[tablename].data.length;
                    for (let j = 0; j < size; j++) {
                        if (!jQuery("#" + id + "_" + j).val()) {
                            printMessage("warning", fieldname + "未填写", "必填内容未填写");
                            //alert(fieldname + "未填写");
                            return false;
                        }
                    }
                } else {
                    if (!jQuery("#" + id).val()) {
                        printMessage("warning", fieldname + "未填写", "必填内容未填写");
                        //alert(fieldname + "未填写");
                        return false;
                    }
                }
            }
        }
    } catch (e) {
        console.log(e);
        return false;
    }
    return true;
}

/**
 * 提示信息
 */
const printMessage = (type, message, title) => {
    if (type == "warning") {
        Modal.warning({
            title: title,
            content: message,
            okText: "ok",
        });
    }

}

/**
 * contains方法 判断数组中是否包含某一元素
 */
export const contains = (arr, obj) => {
    if (!arr)
        return false;
    var i = arr.length;
    while (i--) {
        if (arr[i] === obj) {
            return true;
        }
    }
    return false;
}

/**
 * 获取字段值方法
 */
export const getFieldValue = (fieldid, drowIndex) => {
    let card = Mode.store.getState().card;
    let mainFields = card.mainFields;
    let fieldObj = mainFields[fieldid];
    let detailtable = fieldObj.detailtable;
    if (!!fieldObj) {
        try {
            if (detailtable) {
                let detailData = card.detailData;
                return detailData.data[detailtable].data[drowIndex][fieldid].value;
            } else {
                let mainData = card.mainData;
                return mainData.data[fieldid].value;
            }
        } catch (e) {
            console.log("输入内容有误！", e);
        }
    } else {
        console.log("输入内容有误！");
    }
    return "";
}
//--------------------------------------------------------------------------联动相关js start

/**
 * 所有联动方法 changeFiele中涉及到的所有字段赋值 都使用此方法执行并触发目标字段的所有联动方法
 */
export const changeField = (fieldObj, value, symbol, drowIndex, mainData, detailData, mainFields, page) => {
    const modeField = page.modeField;
    const orderlyjson = page.orderlyjson;
    const detailTable = page.detailTable;

    let fieldid = fieldObj.fieldid;
    try {
        let specialobj = fieldObj.specialobj;
        if (symbol == "emaintable") {//处理字段的值 value未改变直接return 不执行后续方法
            let _value = mainData.data[fieldid].value;
            if (_value == value) {
                return { mainData, detailData, mainFields }
            }
            mainData.data[fieldid].value = value;
            if (specialobj)
                mainData.data[fieldid].specialobj = specialobj;
        } else {
            let _value = detailData.data[symbol].data[drowIndex][fieldid].value;
            if (_value == value) {
                return { mainData, detailData, mainFields }
            }
            detailData.data[symbol].data[drowIndex][fieldid].value = value;
            if (specialobj)
                detailData.data[symbol].data[drowIndex][fieldid].specialobj = specialobj;
        }
    } catch (e) {
        alert(e);
    }
    //每种计算类型单独try catch 防止一种出错所有都无法执行
    try {
        let colcalstr = modeField.colcalstr;
        let colCons = colcalstr[fieldid];
        if (colCons) {//列字段规则
            returnObj = changecolCons(symbol, mainData, colCons, detailData, fieldid, mainFields, page);
            mainData = returnObj.mainData;
            detailData = returnObj.detailData;
            mainFields = returnObj.mainFields;
        }
    } catch (e) { console.log(e); }


    try {
        let rowcalstr = modeField.rowcalstr;
        let rowCons = rowcalstr[fieldid];
        if (rowCons) {//行字段规则
            returnObj = changerowCons(symbol, mainData, rowCons, detailData, mainFields, modeField, drowIndex, page);
            mainData = returnObj.mainData;
            detailData = returnObj.detailData;
            mainFields = returnObj.mainFields;
        }
    } catch (e) { console.log(e); }


    try {
        let formula = orderlyjson.formula;
        let forCons = formula[fieldid];
        if (forCons) {//excel中的公式
            returnObj = changeformula(symbol, drowIndex, forCons, mainData, detailData, mainFields, orderlyjson.etables, fieldObj, page);
            mainData = returnObj.mainData;
            detailData = returnObj.detailData;
            mainFields = returnObj.mainFields;
        }
    } catch (e) { console.log(e); }


    try {
        let inputentry = modeField.inputentry;//字段联动
        let inputCons = inputentry[fieldid];
        if (inputCons) {//字段联动
            returnObj = dataInput(value, symbol, drowIndex, inputCons, mainData, detailData, mainFields, orderlyjson.etables, fieldObj, detailTable, page);
            mainData = returnObj.mainData;
            detailData = returnObj.detailData;
            mainFields = returnObj.mainFields;
        }
    } catch (e) { console.log(e); }

    try {
        let fieldattr = modeField.fieldattr;//字段属性
        let fieldCons = fieldattr[fieldid];
        if (fieldCons) {//字段属性
            returnObj = checkFieldAttr(value, symbol, drowIndex, fieldCons, mainData, detailData, mainFields, orderlyjson.etables, fieldObj, detailTable, page);
            mainData = returnObj.mainData;
            detailData = returnObj.detailData;
            mainFields = returnObj.mainFields;
        }
    } catch (e) { console.log(e); }

    if (fieldObj.htmltype == "5") {//如果是选择框字段
        //首先解析属性联动

        try {
            let linkage = modeField.linkage;
            let linkCons = linkage[fieldid];
            if (linkCons) {//字段属性
                returnObj = checkShowAttr(value, symbol, drowIndex, linkCons, mainData, detailData, mainFields, fieldObj);
                mainData = returnObj.mainData;
                detailData = returnObj.detailData;
                mainFields = returnObj.mainFields;
            }
        } catch (e) { console.log(e); }

        //解析子项联动
        try {
            returnObj = changeSelectItem(fieldObj, symbol, value, drowIndex, mainData, detailData, mainFields, page);
            mainData = returnObj.mainData;
            detailData = returnObj.detailData;
            mainFields = returnObj.mainFields;
        } catch (e) { console.log(e); }
    }

    //触发bindPropertyChange
    try {
        let fieldName = symbol == "emaintable" ? `field${fieldid}` : `field${fieldid}_${drowIndex}`;
        if (fieldName in __propertyChangeFnArray) {
            __propertyChangeFnArray[fieldName].map(fn => {
                try {
                    fn(jQuery("#" + fieldName)[0]);
                } catch (e) { console.log(e); }
            });
        }
    } catch (e) { console.log(e); }
    return { mainData, detailData, mainFields }
}

/**
 * 计算列字段规则
 */
export const changecolCons = (symbol, mainData, colCons, detailData, fieldid, mainFields, page) => {
    let maincalstr = colCons.maincalstr;
    let mf = maincalstr.split("=")[0].replace("mainfield_", "");
    let detailValue = detailData.data[symbol].data;
    let mainFieldObj = mainFields[mf];

    let fieldSumValue = 0;
    const detailtype = mainFieldObj ? mainFieldObj.type : "";
    for (var i = 0; i < detailValue.length; i++) {
        let fieldValue = detailValue[i][fieldid].value;
        if (fieldValue && !isNaN(fieldValue))
            fieldSumValue += parseFloat(fieldValue)
    }
    let decimals = 2;
    if (mainFieldObj && (detailtype == "1" || detailtype == "2"))
        decimals = 0;
    else if (mainFieldObj && (detailtype == "3" || detailtype == "5"))
        decimals = parseInt(mainFieldObj.get("qfws"));
    let thousands = detailtype == "5" ? 1 : 0;
    return changeField(mainFields[mf], FormatFloatValue(fieldSumValue, decimals, thousands), "emaintable", null, mainData, detailData, mainFields, page);
    //mainData.data[mf].value = FormatFloatValue(fieldSumValue, decimals, thousands);
    //return mainData;
}

/**
 * 计算行字段规则
 */
export const changerowCons = (symbol, mainData, rowCons, detailData, mainFields, modeField, drowIndex, page) => {
    let colcalstr = modeField.colcalstr;
    for (let item in rowCons) {
        let cons = rowCons[item];
        var pat = new RegExp("detailfield_\\d+");
        var result;
        do {
            result = pat.exec(cons);
            let fvalue = "";
            if (result) {
                let fid = result[0].replace("detailfield_", "");
                let fidValue = detailData.data[symbol].data[drowIndex][fid].value;
                fvalue = (!fidValue || isNaN(fidValue)) ? "0" : parseFloat(fidValue);
                cons = cons.replace(result, fvalue);
            }
        } while (result != null);
        let changeValue = eval(cons);
        let returnObj = changeField(mainFields[item], changeValue, symbol, drowIndex, mainData, detailData, mainFields, page);
        mainData = returnObj ? returnObj.mainData : mainData;
        detailData = returnObj ? returnObj.detailData : detailData;
        mainFields = returnObj ? returnObj.mainFields : mainFields;
        //detailData.data[symbol].data[drowIndex][item].value = changeValue;
        //let dss = detailData.data[symbol].data;
        //if (colcalstr[item]) {//如果目标字段存在行规则
        //    mainData = changecolCons(symbol, mainData, colcalstr[item], detailData, item, mainFields);
        //}
    }
    return { mainData, detailData, mainFields };
}

/**
 * 行列规则补0方法
 */
export const FormatFloatValue = (realval, decimals, thousands) => {
    //console.log("realval",realval,"decimals",decimals,"thousands",thousands)
    var regnum = /^(-?\d+)(\.\d+)?$/;
    if (!regnum.test(realval)) {
        return realval;
    }
    realval = realval.toString();
    var formatval = "";
    if (decimals === 0) {		//需取整
        formatval = Math.round(parseFloat(realval));
    } else {
        var n = Math.pow(10, decimals);
        formatval = Math.round(parseFloat(realval) * n) / n;
        var pindex = realval.indexOf(".");
        var pointLength = pindex > -1 ? realval.substr(pindex + 1).length : 0;	//当前小数位数
        if (decimals > pointLength) {		//需补零
            if (pindex == -1)
                formatval += ".";
            for (var i = 0; i < decimals - pointLength; i++) {
                formatval += "0";
            }
        }
    }
    formatval = formatval.toString();
    var index = formatval.indexOf(".");
    var intPar = index > -1 ? formatval.substring(0, index) : formatval;
    var pointPar = index > -1 ? formatval.substring(index) : "";
    if (thousands === 1) {				//整数位format成千分位
        var reg1 = /(-?\d+)(\d{3})/;
        while (reg1.test(intPar)) {
            intPar = intPar.replace(reg1, "$1,$2");
        }
    }
    formatval = intPar + pointPar;
    return formatval;
}

//---------------------------------------------------------------解析公式excel布局中的公式start

/**
 * excel布局公式计算
 */
export const changeformula = (symbol, drowIndex, forCons, mainData, detailData, mainFields, etables, TriggerFieldObj, page) => {
    for (let item in forCons) {
        try {
            let formula = forCons[item];
            let destcell = formula.destcell;
            const fieldid = convertCellAttrToFieldid(etables, destcell);
            let formulaTxt = jQuery.trim(formula.formulatxt).substring(1);
            let analysistxt = jQuery.trim(formula.analysistxt).substring(1);
            let cellrange = formula.cellrange;
            let result = '';
            let flag = true;

            if (destcell.indexOf("DETAIL_") === -1) {		//赋值给主表字段
                if ((/DETAIL_\d+\./).test(formulaTxt)) {	//取值字段包含明细表字段
                    const reg = /^(EXCEL_AVERAGE|EXCEL_MIN|EXCEL_MAX)\((\s*(MAIN|TAB_\d+|DETAIL_\d+)\.[A-Z]+\d+\s*(\,)?)+\)$/;
                    if (reg.test(formulaTxt)) {			//求平均、最大、最小特殊处理(例：AVG(明细字段或主字段))
                        result = calculate_detail_special(mainData, detailData, formulaTxt, cellrange, etables, mainFields);
                    } else {
                        result = calculate_detail_sum(mainData, detailData, formulaTxt, cellrange, etables, mainFields);
                    }
                } else {									//取值字段全部为主表字段
                    result = calculate_single(mainData, detailData, formulaTxt, cellrange, etables, mainFields, "-1");
                }
            } else {                                        //赋值给明细表字段
                let detailtable = TriggerFieldObj.detailtable;
                if (formulaTxt.match(/(MAIN|TAB_\d+)\./g) && !detailtable) {//取值字段包含主表字段 并且触发字段为主字段 需计算对应明细所有行记录
                    let returnObj = calculate_detailAllRow(fieldid, mainData, detailData, formulaTxt, cellrange, etables, mainFields, page);
                    mainData = returnObj ? returnObj.mainData : mainData;
                    detailData = returnObj ? returnObj.detailData : detailData;
                    mainFields = returnObj ? returnObj.mainFields : mainFields;
                    flag = false;
                } else {//触发字段为明细字段 暂时只考虑当前表单的联动
                    let fieldObj = mainFields[fieldid];
                    let tablename = fieldObj.detailtable;
                    if (tablename == detailtable) {
                        result = calculate_single(mainData, detailData, formulaTxt, cellrange, etables, mainFields, drowIndex + "");
                    } else {
                        printMessage("warning", "", "公式计算出错，请联系管理员");
                        flag = false;
                    }

                }
            }
            if (flag) {
                let fieldObj = mainFields[fieldid];
                let tablename = fieldObj.detailtable;
                let returnObj;
                if (tablename) {
                    //detailData.data[tablename].data[drowIndex][fieldid].value = result;
                    returnObj = changeField(mainFields[fieldid], result, tablename, drowIndex, mainData, detailData, mainFields, page);
                } else {
                    //mainData.data[fieldid].value = result;
                    returnObj = changeField(mainFields[fieldid], result, "emaintable", null, mainData, detailData, mainFields, page);
                }
                mainData = returnObj ? returnObj.mainData : mainData;
                detailData = returnObj ? returnObj.detailData : detailData;
                mainFields = returnObj ? returnObj.mainFields : mainFields;
            }

        } catch (e) {
            alert(e);
            console.log("9>>>>>formula calculate error: " + e);
        }
    }
    return { mainData, detailData, mainFields };
}

/**
 * 单条/单行公式计算
 */
const calculate_single = (mainData, detailData, formulaTxt, cellrange, etables, mainFields, drowIndex) => {
    let _formulaTxt = replaceFormula(mainData, detailData, cellrange, formulaTxt, drowIndex, etables, mainFields, true);
    return eval(_formulaTxt);
}

/**
 * 明细列求平均/最大赋值主字段，特殊公式处理
 */
const calculate_detail_special = (mainData, detailData, formulaTxt, cellrange, etables, mainFields) => {
    let _formulaTxt = replaceFormula(mainData, detailData, cellrange, formulaTxt, "all", etables, mainFields, true);
    return eval(_formulaTxt);
}

/**
 * 明细所有行公式计算--赋值字段为明细字段，触发字段为主表字段；明细表每条记录都需经过公式计算再赋值 
 * 还需要在公式计算时对默认添加明细行的默认值进行赋值为只有主表字段联动的结果 提供给添加明细时赋默认值
 */
const calculate_detailAllRow = (destFieldid, mainData, detailData, formulaTxt, cellrange, etables, mainFields, page) => {
    let tablename = mainFields[destFieldid].detailtable;
    let rowIndex = detailData.data[tablename].data.length;
    for (let i = 0; i < rowIndex; i++) {
        try {
            var formulaTxt_clone = formulaTxt;
            formulaTxt_clone = replaceFormula(mainData, detailData, cellrange, formulaTxt, i + "", etables, mainFields, true);
            var calculateResult = eval(formulaTxt_clone);
            //detailData.data[tablename].data[i][destFieldid].value = calculateResult;
            let returnObj = changeField(mainFields[destFieldid], calculateResult, tablename, i, mainData, detailData, mainFields, page)
            mainData = returnObj ? returnObj.mainData : mainData;
            detailData = returnObj ? returnObj.detailData : detailData;
            mainFields = returnObj ? returnObj.mainFields : mainFields;
            if (!detailData.data[tablename].defaultValue) {
                detailData.data[tablename].defaultValue = {};
            }
            detailData.data[tablename].defaultValue[destFieldid] = calculateResult;
        } catch (e) { }
    }
    return { mainData, detailData, mainFields };
}

/**
 * 明细作为取值字段的公式，计算明细每一行公式结果，再合计赋值主字段(修复之前主字段明细字段合计错误问题、多个明细同时合计错误问题)
 */
const calculate_detail_sum = (mainData, detailData, formulaTxt, cellrange, etables, mainFields) => {
    let sumResult = 0;
    const reg = /(DETAIL_\d+)/g;
    allRowIndex = 0;
    formulaTxt.match(reg).map(detail => {
        let detailMark = detail.toLowerCase();
        let curRowIndex = detailData.data[detailMark].data.length;
        if (curRowIndex > allRowIndex) {
            allRowIndex = curRowIndex;
        }
    });
    //此处的处理逻辑有bug  原有布局公式计算方式 cellrange中含有多个明细表的字段操作时 默认只用第一个明细表的rowindex做明细index数量
    //沿用部分原有计算逻辑，当含有多个明细时候 取明细行数量最多的子表的rowindex做循环  不存在的子表字段按照空值处理 
    for (let i = 0; i < allRowIndex; i++) {
        try {
            let _formulaTxt = replaceFormula(mainData, detailData, cellrange, formulaTxt, i + "", etables, mainFields, i == 0);
            const singleRowResult = eval(_formulaTxt);
            if (!isNaN(parseFloat(singleRowResult))) {	//非法数值结果
                sumResult = rewrite_add(sumResult, singleRowResult);
            }
        } catch (ev) {
            alert(ev);
        }
    }
    return sumResult;
}

/**
 * 替换公式，单元格标示替换成对应字段值
 */
const replaceFormula = (mainData, detailData, cellrange, formulatxt, rowid, etables, mainFields, flag) => {
    jQuery.each(cellrange, function (index, cellattr) {
        //console.log(cellattr,formulatxt);
        let cellValue = "";
        const fieldid = convertCellAttrToFieldid(etables, cellattr);
        if (rowid === "all" && cellattr.indexOf("DETAIL_") > -1) {	//需替换明细所有行字段
            let groupid = getGroupid(cellattr);
            let fieldObj = mainFields[fieldid];
            let tablename = fieldObj.detailtable;
            for (let i = 0; i < detailData.data[tablename].data.length; i++) {
                let _cellValue = detailData.data[tablename].data[i][fieldid].value;
                _cellValue = _cellValue ? _cellValue : "\"emptyval\"";
                if (i != 0) _cellValue = "," + _cellValue;
                cellValue += _cellValue;
            }
        } else {
            let fieldObj = mainFields[fieldid];
            let tablename = fieldObj.detailtable;
            if (tablename) {
                try {
                    cellValue = detailData.data[tablename].data[rowid][fieldid].value;
                    cellValue = cellValue ? cellValue : "\"emptyval\"";
                } catch (e) {
                    cellValue = "\"emptyval\"";
                }
            } else {
                //cellValue = rowid=="0"?(mainData[fieldid].value?mainData[fieldid].value:"emptyval"):"emptyval";
                if (flag) {
                    //console.log("mainData",mainData);
                    cellValue = mainData.data[fieldid].value;
                    cellValue = cellValue ? cellValue : "\"emptyval\"";
                } else {
                    cellValue = "\"emptyval\"";
                }
            }
        }
        if (cellValue == "") cellValue = "\"" + cellValue + "\"";
        var curindex = -1;
        while (formulatxt.indexOf(cellattr) > curindex) {
            curindex = formulatxt.indexOf(cellattr);
            var str1 = formulatxt.substring(0, curindex);
            var str2 = formulatxt.substring(curindex + cellattr.length);
            var reg = /^[0-9]$/;
            var nextchar = str2.substr(0, 1);
            if (reg.test(nextchar)) continue;
            formulatxt = str1 + cellValue + str2;
        }
    });
    return formulatxt;
}

/**
 * 公式标示转换成单元格标示(例：DETAIL_1.C4------>detail_1_4_3)
 */
const convertCellAttrToFieldid = (etables, cellAttr) => {
    const fa = cellAttr.split("\.");
    const symbol = fa[0] == "MAIN" ? "emaintable" : fa[0].toLowerCase();
    const tObj = etables[symbol];
    const letter = fa[1];
    const rowid = parseInt(letter.match(/\d+$/)[0]) - 1;
    const colid = convertCharToInt(letter.match(/^[a-zA-Z]+/)[0]) - 1;
    let id = rowid + "," + colid;
    let fieldObj = tObj[id];
    return fieldObj.field;
}

/**
 * 字母转数字
 */
const convertCharToInt = (value) => {
    let rtn = 0;
    let powIndex = 0;
    for (let i = value.length - 1; i >= 0; i--) {
        let tmpInt = value[i].charCodeAt() - 64;
        rtn += Math.pow(26, powIndex) * tmpInt;
        powIndex++;
    }
    return rtn;
}

/**
 * 获取属于哪个明细表groupid
 */
function getGroupid(cellattr) {
    var idx = cellattr.indexOf("DETAIL_");
    if (cellattr.indexOf("DETAIL_") == -1)
        return -1;
    var groupid = cellattr.substring(idx + 7, cellattr.indexOf("."));
    return parseInt(groupid) - 1;
}

/**
 * JS parseFloat求和精度不一致问题解决
 */
function rewrite_add(arg1, arg2) {
    var r1 = 0, r2 = 0;
    try {
        r1 = arg1.toString().split(".")[1].length;
    } catch (e) { }
    try {
        r2 = arg2.toString().split(".")[1].length;
    } catch (e) { }
    var m = Math.pow(10, Math.max(r1, r2));
    return (arg1 * m + arg2 * m) / m;
}

/**
 * 求和
 */
function EXCEL_SUM() {
    var result = 0;
    //console.log("-----------",arguments);
    for (var i = 0; i < arguments.length; i++) {
        var par = arguments[i];
        //console.log("***************"+par);
        if (!isNaN(parseFloat(par))) {
            //result += parseFloat(par);
            result = rewrite_add(result, par);
        }
    }
    return result;
}

/**
 * 求平均数
 */
function EXCEL_AVERAGE() {
    var count = 0;
    var sumVal = 0;
    for (var i = 0; i < arguments.length; i++) {
        var par = arguments[i];
        if (!isNaN(parseFloat(par))) {
            //sumVal += parseFloat(par);
            sumVal = rewrite_add(sumVal, par);
            count++;
        }
    }
    if (count > 0) {
        return parseFloat(sumVal / count);
    } else {
        throw new Error("EXCEL_AVERAGE divisor is zero");
    }
}

/**
 * 求绝对值
 */
function EXCEL_ABS() {
    if (arguments.length == 1) {
        var par = arguments[0];
        if (!isNaN(parseFloat(par))) {
            var result = Math.abs(parseFloat(par));
            return result;
        } else {
            throw new Error("EXCEL_ABS arguments value is not a number");
        }
    } else {
        throw new Error("EXCEL_ABS arguments number must equal one");
    }
}

/**
 * 精度计算
 */
function EXCEL_ROUND() {
    if (arguments.length == 2) {
        var result = 0;
        var par1 = arguments[0];
        var par2 = arguments[1];
        if (!isNaN(parseFloat(par1))) {
            par1 = parseFloat(par1);
        } else {
            throw new Error("EXCEL_ROUND first argument value is not a number");
        }
        if (isInt(par2)) {
            par2 = parseInt(par2);
        } else {
            throw new Error("EXCEL_ROUND second argument value is not a int");
        }
        result = par1.toFixed(par2);
        return result;
    } else {
        throw new Error("EXCEL_ROUND arguments number must equal two");
    }
}

/**
 * 条件判断
 */
function EXCEL_IF() {
    if (arguments.length == 3) {
        if (eval(arguments[0])) {
            return arguments[1];
        } else {
            return arguments[2];
        }
    } else {
        throw new Error("EXCEL_IF arguments number must equal three");
    }
}

/**
 * 求最大值
 */
function EXCEL_MAX() {
    var result;
    for (var i = 0; i < arguments.length; i++) {
        var par = arguments[i];
        if (!isNaN(parseFloat(par))) {
            if (result == null) {
                result = parseFloat(par);
            } else {
                if (parseFloat(par) > result)
                    result = parseFloat(par);
            }
        }
    }
    if (result != null) {
        return result;
    } else {
        throw new Error("EXCEL_MAX arguments value must contain a number");
    }
}

/**
 * 求最小值
 */
function EXCEL_MIN() {
    var result;
    for (var i = 0; i < arguments.length; i++) {
        var par = arguments[i];
        if (!isNaN(parseFloat(par))) {
            if (result == null) {
                result = parseFloat(par);
            } else {
                if (parseFloat(par) < result)
                    result = parseFloat(par);
            }
        }
    }
    if (result != null) {
        return result;
    } else {
        throw new Error("EXCEL_MIN arguments value must contain a number");
    }
}

//---------------------------------------------------------------解析公式excel布局中的公式end

/**
 * 解析字段联动
 */
export const dataInput = (value, symbol, drowIndex, inputCons, mainData, detailData, mainFields, etables, fieldObj, detailTable, page) => {
    for (let i = 0; i < inputCons.length; i++) {
        let dataInputObj = inputCons[i];
        let id = dataInputObj.id;
        API.dataInput({ value, id, data: symbol == "emaintable" ? JSON.stringify(mainData.data) : JSON.stringify(detailData.data[symbol].data[drowIndex]) }).then(({ data, api_errormsg, api_status }) => {
            try {
                if (api_status) {
                    for (let item in data) {
                        let dataObj = data[item];
                        if (item == "emaintable") {//主表字段联动结果是主表的
                            for (let field in dataObj) {
                                let value = dataObj[field];
                                returnObj = changeField(mainFields[field], value, "emaintable", null, mainData, detailData, mainFields, page);
                                mainData = returnObj.mainData;
                                detailData = returnObj.detailData;
                                mainFields = returnObj.mainFields;
                                //mainData.data[field].value = value;//主表字段赋值
                            }
                        } else if (item == "detailData") {//明细表自身联动
                            for (let field in dataObj) {
                                let value = dataObj[field];
                                returnObj = changeField(mainFields[field], value, symbol, drowIndex, mainData, detailData, mainFields, page);
                                mainData = returnObj.mainData;
                                detailData = returnObj.detailData;
                                mainFields = returnObj.mainFields;
                            }
                        } else {//主表字段联动结果是明细的
                            let rowCount = detailData.data[item].data.length;
                            let i = 0;
                            for (; i < dataObj.length; i++) {
                                let rowObj = dataObj[i];
                                let addObj = JSON.parse(detailTable[item].addObj);
                                var key = (rowCount + i) + "";
                                addObj.index = key;
                                detailData.data[item].data.push(addObj);//子表方式修改，先加行 再赋值，触发联动事件
                                for (let field in rowObj) {
                                    let value = rowObj[field];
                                    //addObj[field].value = value;
                                    let returnObj = changeField(mainFields[field], value, item, rowCount + i, mainData, detailData, mainFields, page);
                                    mainData = returnObj.mainData;
                                    detailData = returnObj.detailData;
                                    mainFields = returnObj.mainFields;
                                }
                            }
                            detailData.data[item].size = (parseInt(rowCount) + i);
                            let drs = detailData.detailRowSize;
                            detailData.detailRowSize = (parseInt(drs) + 1);
                        }
                    }
                    page.forceUpdate();//字段联动方法异步执行，强制重新渲染
                }
            } catch (e) {
                alert(e);
            }

        });
    }
    return { mainData, detailData, mainFields }
}


/**
 * 解析字段属性
 */
export const checkFieldAttr = (value, symbol, drowIndex, fieldCons, mainData, detailData, mainFields, etables, fieldObj, detailTable, page) => {
    for (let item in fieldCons) {
        let obj = fieldCons[item];
        let field = mainFields[item];
        let valueObj;
        let fieldType = 0;
        let detailtable = field.detailtable;
        if (detailtable) {//联动字段为明细表
            let data = symbol == "emaintable" ? detailData.data[field.detailtable] : detailData.data[field.detailtable].data[drowIndex];
            fieldType = symbol == "emaintable" ? 2 : 1;
            valueObj = { ...mainData.data, ...data };
        } else {
            valueObj = mainData.data;
        }

        let id = obj.id;
        let caltype = obj.caltype;
        let htmltype = field ? field.htmltype : "";
        let detailtype = field ? field.type : "";
        if (caltype == "2") {//字段赋值目前只支持主表字段（原有规则）
            let attrcontent = obj.attrcontent;
            let index = attrcontent.indexOf("doFieldMath(\"");
            if (index > -1) {
                attrcontent = attrcontent.substring(index + 13);
                index = attrcontent.lastIndexOf("\")");
                if (index > -1) {
                    attrcontent = attrcontent.substring(0, index);
                }
                const reg = /\$\d+\$/g;
                attrcontent.match(reg).map(detail => {
                    let fid = detail.replace(/\$/g, "");
                    let value = mainData.data[fid].value;
                    if (isNaN(parseFloat(value))) {
                        value = "0";
                    }
                    attrcontent = attrcontent.replace(detail, value);
                });
                let fieldValue;
                try {
                    fieldValue = eval(attrcontent);
                } catch (e) { }
                let returnObj = changeField(field, fieldValue, "emaintable", null, mainData, detailData, mainFields, page);
                mainData = returnObj.mainData;
                detailData = returnObj.detailData;
                mainFields = returnObj.mainFields;
            }
        } else {
            API.fieldAttr({ id, fieldType, fields: JSON.stringify(mainFields), data: JSON.stringify(valueObj), field: JSON.stringify(field) }).then(({ data, api_errormsg, api_status }) => {
                if (api_status) {
                    let name;
                    let key;
                    if (fieldType != "2") {
                        if (data.length > 0) {
                            name = data[0].name;
                            key = data[0].key;
                        }
                    }
                    if (htmltype == "3") {//浏览框字段单独处理
                        if (detailtable && symbol == "emaintable") {//当赋值字段是明细表字段时候 需要先判断是从主表字段的联动还是从明细字段的联动（实际设置中 只有sql字段支持这种配置 日期计算明细表关联主表字段）
                            let size = data.length;
                            for (let j = 0; j < size; j++) {
                                name = data[j].name;
                                key = data[j].key;

                                let keys = key.split(",");
                                let names = name.replace(/&nbsp;/g, ",").split(",");
                                let replaceDatas = new Array();
                                let showname = "";
                                for (let i = 0; i < keys.length; i++) {
                                    showname += "," + names[i];
                                    replaceDatas.push({ id: keys[i], name: names[i] })
                                }
                                if (showname)
                                    showname = showname.substring(1);
                                let specialobj = {
                                    showname: showname,
                                    replaceDatas: replaceDatas
                                }
                                field.specialobj = specialobj;

                                let returnObj = changeField(field, keys, detailtable, j, mainData, detailData, mainFields, page);
                                mainData = returnObj.mainData;
                                detailData = returnObj.detailData;
                                mainFields = returnObj.mainFields;
                            }
                        } else {
                            if (name) {
                                let keys = key.split(",");
                                let names = name.replace(/&nbsp;/g, ",").split(",");
                                let replaceDatas = new Array();
                                let showname = "";
                                for (let i = 0; i < keys.length; i++) {
                                    showname += "," + names[i];
                                    replaceDatas.push({ id: keys[i], name: names[i] })
                                }
                                if (showname)
                                    showname = showname.substring(1);
                                let specialobj = {
                                    showname: showname,
                                    replaceDatas: replaceDatas
                                }
                                field.specialobj = specialobj;
                                if (detailtable) {//当赋值字段是明细表字段时候 需要先判断是从主表字段的联动还是从明细字段的联动（实际设置中 只有sql字段支持这种配置 日期计算明细表关联主表字段）
                                    if (symbol != "emaintable") {//联动字段是明细时 只修改当前行的字段值
                                        let returnObj = changeField(field, keys, detailtable, drowIndex, mainData, detailData, mainFields, page);
                                        mainData = returnObj.mainData;
                                        detailData = returnObj.detailData;
                                        mainFields = returnObj.mainFields;
                                    }
                                } else {
                                    let returnObj = changeField(field, keys, "emaintable", null, mainData, detailData, mainFields, page);
                                    mainData = returnObj.mainData;
                                    detailData = returnObj.detailData;
                                    mainFields = returnObj.mainFields;
                                }
                            }
                        }
                    } else {//选择框字段跟其他字段一起处理 区别是选择框需要传key 而文本字段传name
                        if (detailtable) {//当赋值字段是明细表字段时候 需要先判断是从主表字段的联动还是从明细字段的联动
                            if (symbol == "emaintable") {//联动字段是主表时 修改所有明细对应字段
                                let size = data.length;
                                for (let j = 0; j < size; j++) {
                                    name = data[j].name;
                                    key = data[j].key;
                                    let returnObj = changeField(field, htmltype == "5" ? key : name, detailtable, j, mainData, detailData, mainFields, page);
                                    mainData = returnObj.mainData;
                                    detailData = returnObj.detailData;
                                    mainFields = returnObj.mainFields;
                                }
                            } else {//联动字段是明细时 只修改当前行的字段值
                                let returnObj = changeField(field, htmltype == "5" ? key : name, detailtable, drowIndex, mainData, detailData, mainFields, page);
                                mainData = returnObj.mainData;
                                detailData = returnObj.detailData;
                                mainFields = returnObj.mainFields;
                            }
                        } else {
                            let returnObj = changeField(field, htmltype == "5" ? key : name, "emaintable", null, mainData, detailData, mainFields, page);
                            mainData = returnObj.mainData;
                            detailData = returnObj.detailData;
                            mainFields = returnObj.mainFields;
                        }
                    }
                    page.forceUpdate();//强制重新渲染
                }
            });
        }
    }
    return { mainData, detailData, mainFields }
}

/**
 * 属性联动方法 属性联动中设置的参数 attrEdit，attrHide，attrView，attrMandatory 优先级高于 mainFields中默认的显示参数 isedit等
 */
export const checkShowAttr = (value, symbol, drowIndex, linkCons, mainData, detailData, mainFields, fieldObj) => {

    if (fieldObj.detailtable) {
        let valueLinkage = linkCons[value]
        let tablename = fieldObj.detailtable;
        let viewattr = valueLinkage ? valueLinkage.viewattr : "";
        let changefieldids = "";
        if (valueLinkage) {
            changefieldids = valueLinkage.changefieldids;
        } else {//没有找到 复原所有字段
            for (let item0 in linkCons) {
                changefieldids += ("," + linkCons[item0].changefieldids)
            }
            changefieldids = changefieldids.substring(1);
        }
        let cfa = changefieldids.split(",");

        for (let i = 0; i < cfa.length; i++) {
            let cfid = cfa[i];
            detailData.data[tablename].data[drowIndex][cfid].attrEdit = (viewattr == "") ? mainFields[cfid].isedit : ((viewattr == "3" || viewattr == "4") ? "0" : "1");
            detailData.data[tablename].data[drowIndex][cfid].attrHide = (viewattr == "") ? mainFields[cfid].ishide : (viewattr == "4" ? "1" : "0");
            detailData.data[tablename].data[drowIndex][cfid].attrView = (viewattr == "") ? mainFields[cfid].isview : (viewattr == "4" ? "0" : "1");
            let mandatory = mainFields[cfid].attrMandatory;
            let _mandatory = (viewattr == "") ? mainFields[cfid].ismandatory : (viewattr == "2" ? "1" : "0");
            if (_mandatory != mandatory) {
                if (_mandatory == "1" && needcheck.indexOf("field" + cfid + "_" + drowIndex) < 0) {
                    needcheck += ",field" + cfid + "_" + drowIndex;
                } else if (_mandatory == "0") {
                    needcheck = needcheck.replace(",field" + cfid + "_" + drowIndex, "");
                }
            }
            detailData.data[tablename].data[drowIndex][cfid].attrMandatory = (viewattr == "") ? mainFields[cfid].ismandatory : (viewattr == "2" ? "1" : "0");
        }
    } else {
        let valueLinkage = linkCons[value]
        let viewattr = valueLinkage ? valueLinkage.viewattr : "";
        let changefieldids = "";
        if (valueLinkage) {
            changefieldids = valueLinkage.changefieldids;
        } else {//没有找到 复原所有字段
            for (let item0 in linkCons) {
                changefieldids += ("," + linkCons[item0].changefieldids)
            }
            changefieldids = changefieldids.substring(1);
        }
        let cfa = changefieldids.split(",");
        for (let i = 0; i < cfa.length; i++) {
            let cfid = cfa[i];
            mainFields[cfid].attrEdit = (viewattr == "") ? mainFields[cfid].isedit : ((viewattr == "3" || viewattr == "4") ? "0" : "1");
            mainFields[cfid].attrHide = (viewattr == "") ? mainFields[cfid].ishide : (viewattr == "4" ? "1" : "0");
            mainFields[cfid].attrView = (viewattr == "") ? mainFields[cfid].isview : (viewattr == "4" ? "0" : "1");
            let mandatory = mainFields[cfid].attrMandatory;
            let _mandatory = (viewattr == "") ? mainFields[cfid].ismandatory : (viewattr == "2" ? "1" : "0");
            if (_mandatory != mandatory) {
                if (_mandatory == "1" && needcheck.indexOf("field" + cfid) < 0) {
                    needcheck += ",field" + cfid;
                } else if (_mandatory == "0") {
                    needcheck = needcheck.replace(",field" + cfid, "");
                }
            }
            mainFields[cfid].attrMandatory = (viewattr == "") ? mainFields[cfid].ismandatory : (viewattr == "2" ? "1" : "0");
        }
    }

    return { mainData, detailData, mainFields };
}


/**
 * 选择框子项联动
 */
export const changeSelectItem = (fieldObj, symbol, value, drowIndex, mainData, detailData, mainFields, page) => {
    let selectAttr = fieldObj ? fieldObj.selectAttr : {};
    let childfieldid = selectAttr.childfieldid ? selectAttr.childfieldid : 0;
    if (childfieldid != 0) {
        if (symbol == "emaintable") {
            mainData.data[childfieldid].pValue = value;
            let cvalue = mainData.data[childfieldid].value;
            if (!contains(mainFields[childfieldid + ""].valueObj[value], cvalue)) {
                let returnObj = changeField(mainFields[childfieldid + ""], "", "emaintable", null, mainData, detailData, mainFields, page);
                mainData = returnObj ? returnObj.mainData : mainData;
                detailData = returnObj ? returnObj.detailData : detailData;
                mainFields = returnObj ? returnObj.mainFields : mainFields;
                //mainData.data[childfieldid].value = "";
            }
        } else {
            detailData.data[symbol].data[drowIndex][childfieldid].pValue = value;
            let cvalue = detailData.data[symbol].data[drowIndex][childfieldid].value;
            if (!contains(mainFields[childfieldid + ""].valueObj[value], cvalue)) {
                let returnObj = changeField(mainFields[childfieldid + ""], "", symbol, drowIndex, mainData, detailData, mainFields, page);
                mainData = returnObj ? returnObj.mainData : mainData;
                detailData = returnObj ? returnObj.detailData : detailData;
                mainFields = returnObj ? returnObj.mainFields : mainFields;
                //detailData.data[symbol].data[drowIndex][childfieldid].value = "";
            }
        }
    }
    return { mainData, detailData, mainFields }
}


//--------------------------------------------------------------------------联动相关js end