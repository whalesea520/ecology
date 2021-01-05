export const getCellAttr = (cellObj,cellColAttrs,rowHeight) =>{
    let cellAttr = {};
    let styleObj = {};
    let innerStyleObj = {};
    let className = "";

    //单元格边框
    appendBorder(cellObj, styleObj);
    //单元格样式
    appendStyle(cellObj, styleObj, innerStyleObj, false);
    const financial = cellObj && cellObj["financial"];
    //财务格式所在单元格div增加高度100%
    if(financial && (financial.indexOf("1-")>-1 || financial.indexOf("2-")>-1)){
        styleObj["height"] = rowHeight + "px";
        innerStyleObj["height"] = "100%";
    }
    //列自定义属性
    if(cellColAttrs && cellColAttrs.get("hide")==="y")
        styleObj["display"] = "none";
    if(cellColAttrs && cellColAttrs.get("class"))
        className += " "+cellColAttrs.get("class");
    //单元格自定义属性
    const cusattrs = cellObj["attrs"];
    cusattrs && appendCusAttrObj(cellAttr, cusattrs, innerStyleObj);
    
    cellAttr.styleObj = styleObj;
    cellAttr.innerStyleObj = innerStyleObj;
    cellAttr.class = className;
    return cellAttr;
}

export const getMcCellAttr = (cellObj) =>{
    let mcCellAttr = {};
    let styleObj = {};
    let innerStyleObj = {};

    //单元格样式
    appendStyle(cellObj, styleObj, innerStyleObj, true);
    for(var key in styleObj){
        if(key !== "text-align" && key != "vertical-align")
            innerStyleObj[key] = styleObj[key];
    }
    //自定义属性
    const cusattrs = cellObj.attrs;
    cusattrs && appendCusAttrObj(mcCellAttr, cusattrs, innerStyleObj);

    mcCellAttr.innerStyleObj = innerStyleObj;
    return mcCellAttr;
}

export const getRowAttr = (rowHeight, rowCusAttr) =>{
    let rowAttr = {};
    rowAttr.id = rowCusAttr ? rowCusAttr.get("id") : "";
    rowAttr.name = rowCusAttr ? rowCusAttr.get("name") : "";
    rowAttr.class = rowCusAttr ? rowCusAttr.get("class") : "";
    let styleObj = {};
    styleObj["height"] = rowHeight;
    if(rowCusAttr && rowCusAttr.get("hide")==="y")
        styleObj["display"] = "none";
    if(rowCusAttr && rowCusAttr.get("style"))
        appendCusAttrStyle(styleObj, rowCusAttr.get("style"));
    rowAttr.styleObj = styleObj;
    return rowAttr;
}


const appendBorder = (cellObj, styleObj)=>{
    const eBorder = cellObj["eborder"];
    const etype = cellObj && cellObj["etype"];
    eBorder && eBorder.map((v,k)=>{
        const kind = v["kind"];
        if(etype === "7" && (kind === "top" || kind === "bottom"))  //明细所在区域不解析上下边框
            return true;
        if(v["color"])
            styleObj["border-"+kind+"-color"] = v["color"];
        const borderstyle = v["style"] ? parseInt(v["style"]) : 0;
        if(borderstyle === 0){
        }else if(borderstyle === 2){
            styleObj["border-"+kind+"-width"] = "2px";
            styleObj["border-"+kind+"-style"] = "solid";
        }else if(borderstyle === 3){
            styleObj["border-"+kind+"-width"] = "1px";
            styleObj["border-"+kind+"-style"] = "dashed";
        }else if(borderstyle === 5){
            styleObj["border-"+kind+"-width"] = "3px";
            styleObj["border-"+kind+"-style"] = "solid";
        }else if(borderstyle === 6){
            styleObj["border-"+kind+"-width"] = "3px";
            styleObj["border-"+kind+"-style"] = "double";
        }else if(borderstyle === 7){
            styleObj["border-"+kind+"-width"] = "1px";
            styleObj["border-"+kind+"-style"] = "dotted";
        }else if(borderstyle === 8){
            styleObj["border-"+kind+"-width"] = "2px";
            styleObj["border-"+kind+"-style"] = "dashed";
        }else{
            styleObj["border-"+kind+"-width"] = "1px";
            styleObj["border-"+kind+"-style"] = "solid";
        }
        styleObj["vertical-align"] = "middle";
    })
    return styleObj;
}

const appendStyle = (cellObj, styleObj, innerStyleObj, isMc) => {
    const etype = cellObj && cellObj["etype"];
    if(etype === "7" || etype === "12")
        return;
    //背景色
    if(cellObj["backgroundColor"])
        styleObj["backgroundColor"] = cellObj["backgroundColor"];
    //单元格图片
    if(etype === "6"){
        styleObj["backgroundImage"] = "url('"+cellObj["field"]+"') !important";
        styleObj["backgroundRepeat"] = "no-repeat !important";
    }
    const font = cellObj["font"];
    if(font) {
        if(font["text-align"]) styleObj["text-align"] = font["text-align"];
        if(font["vertical-align"]) styleObj["vertical-align"] = font["vertical-align"];
        if(font["bold"]=="true") innerStyleObj["font-weight"] = "bold";
        if(font["italic"]=="true") innerStyleObj["font-style"] = "italic";
        if(font["underline"]=="true") innerStyleObj["text-decoration"] = "underline";
        if(font["deleteline"]=="true") innerStyleObj["text-decoration"] = "line-through";
        if(font["font-size"]) styleObj["font-size"] = font["font-size"];
        if(font["font-size"]) innerStyleObj["font-size"] = font["font-size"];
        if(font["color"]) styleObj["color"] = font["color"];
        if(font["font-family"]) styleObj["font-family"] = font["font-family"];
    }
    //默认样式
    if(!styleObj["text-align"])     styleObj["text-align"] = "left";
    if(!styleObj["vertical-align"])  styleObj["vertical-align"] = isMc?"middle":"top";
    if(!innerStyleObj["font-size"])  innerStyleObj["font-size"] = "9pt";
    if(!innerStyleObj["font-family"])    innerStyleObj["font-family"] = "Microsoft YaHei";
    //缩进
    let etxtindent = cellObj["etxtindent"];
    if(etxtindent && etxtindent !== "0"){
        etxtindent = parseFloat(etxtindent)*8 + "px";
        if(styleObj["text-align"] === "left")
            styleObj["padding-left"] = etxtindent;
        else if(styleObj["text-align"] === "right")
            styleObj["padding-right"] = etxtindent;
    }
    innerStyleObj["word-break"] = "break-all";
    innerStyleObj["word-wrap"] = "break-word";
}

const appendCusAttrObj = (obj, cusattrs, styleObj) =>{
    if(!cusattrs)
        return;
    if(cusattrs.get("hide")==="y")
        styleObj["display"] = "none";
    if(cusattrs.get("id"))
        obj.cusid = cusattrs.get("id");
    if(cusattrs.get("name"))
        obj.cusname = cusattrs.get("name");
    if(cusattrs.get("class"))
        obj.cusclass = cusattrs.get("class");
    if(cusattrs.get("style"))
        appendCusAttrStyle(styleObj, cusattrs.get("style"));
}

const appendCusAttrStyle = (styleObj, cusstylestr) => {
    let styleArr = cusstylestr.split(";");
    for(let i=0; i<styleArr.length; i++){
        let item = styleArr[i];
        let itemArr = item.split(":");
        if(itemArr.length >= 2)
            styleObj[itemArr[0]] = itemArr[1];
    }
    return styleObj;
}