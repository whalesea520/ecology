import FormLayout from './FormLayout'

class FormTabLayout extends React.Component {

    render() {
        let _this = this;
        const { style, tab } = this.props;
        if (!style) return (<div></div>)
        const { etables, tableInfo, mainFields, detailTable, mainData, detailData, modeField, cellInfo, cellid } = this.props;
        const { functionAttr, orderlyjson, modeInfo, type } = this.props;
        let defShow = 0;
        let tabArr = new Array();
        for (let k in tab) {
            let v = tab[k];
            if (k.indexOf("order") === 0) {
                const arr = v ? v.split(",") : [];
                tabArr.push({
                    id: arr[0] ? arr[0] : "",
                    name: arr[1] ? arr[1] : ""
                });
            }
            if (k === "defshow") {
                defShow = v;
            }
        }
        const taId = "tabarea_" + cellid.replace(",", "_");
        return (
            <div className={taId}>
                <div className="tab_top">
                    <div className="tab_movebtn tab_turnleft" style={{ display: "none" }}></div>
                    <div className="tab_head" style={{ width: "100%" }}>
                        <div className="t_area xrepeat"
                            style={{
                                backgroundImage: "url(" + style["image_bg"] + ") !important",
                                width: "100%"
                            }}>
                            {
                                tabArr.map((v, k) => {
                                    let tabArrInner = new Array();
                                    const sel = k === defShow ? "sel" : "unsel";
                                    let middleStyle = {
                                        backgroundImage: "url('" + style[sel + "_bgmiddle"] + "')!important",
                                        fontSize: style[sel + "_fontsize"] + "px !important",
                                        color: style[sel + "_color"] + " !important",
                                        fontFamily: style[sel + "_family"] + " !important"
                                    };
                                    if (style && style[sel + "_bold"] == "1")
                                        middleStyle["font-weight"] = "bold !important";
                                    if (style && style[sel + "_italic"] == "1")
                                        middleStyle["font-style"] = "italic !important";
                                    tabArrInner.push(
                                        <div id={v.id} className={"t_" + sel} onClick={_this.changeTab.bind(this, v.id, tabArr, taId, style)}>
                                            <div className={"t_" + sel + "_left norepeat"}
                                                style={{
                                                    backgroundImage: "url('" + style[sel + "_bgleft"] + "')!important",
                                                    width: style[sel + "_bgleftwidth"] + "px !important"
                                                }}></div>
                                            <div className={"t_" + sel + "_middle xrepeat lineheight30"} style={middleStyle}>
                                                <span>{v.name}</span>
                                            </div>
                                            <div className={"t_" + sel + "_right norepeat"}
                                                style={{
                                                    backgroundImage: "url('" + style[sel + "_bgright"] + "')!important",
                                                    width: style[sel + "_bgrightwidth"] + "px !important"
                                                }}></div>
                                        </div>
                                    );
                                    if (k !== tabArr.length - 1) {
                                        tabArrInner.push(<div className="t_sep norepeat" style={{ width: style["image_sepwidth"] + "px !important" }}></div>);
                                    }
                                    return tabArrInner;
                                })
                            }
                        </div>
                    </div>
                    <div className="tab_movebtn tab_turnright" style={{ display: "none" }}></div>
                </div>
                <div className="tab_bottom">
                    {
                        tabArr.map((v, k) => {
                            const isSel = k === defShow;
                            const tabObj = etables[v.id];
                            let rowheads = tabObj["rowheads"];
                            const colheads = tabObj["colheads"];
                            const ec = tabObj["ec"];
                            const ecMap = {};
                            const backgroundImage = tabObj["backgroundImage"]
                            const floatingObjectArray = tabObj["floatingObjectArray"];

                            for (let i = 0, l = ec.length; i < l; i++) {
                                let cellObj = ec[i];
                                if (cellObj.etype === "8") {
                                    headRow = parseInt(v.id.split(",")[0]);
                                }
                                if (cellObj.etype === "9") {
                                    bodyRow = parseInt(v.id.split(",")[0]);
                                }
                                let key = cellObj.id;
                                ecMap[key] = cellObj;
                            }
                            return (
                                <div className="tab_content" id={v.id + "_content"} style={!isSel ? { display: "none" } : {}}>
                                    <FormLayout
                                        symbol="tabtable"
                                        className="excelTabTable tablefixed"
                                        modeInfo={modeInfo}
                                        type={type}
                                        mainFields={mainFields}
                                        detailTable={detailTable}
                                        mainData={mainData}
                                        detailData={detailData}
                                        functionAttr={functionAttr}
                                        modeField={modeField}
                                        orderlyjson={orderlyjson}
                                        etables={etables}
                                        colheads={colheads}
                                        rowheads={rowheads}
                                        ecMap={ecMap}
                                        cellInfo={cellInfo}
                                        style={{ width: "100%" }}
                                        backgroundImage={backgroundImage}
                                        floatingObjectArray={floatingObjectArray} />
                                </div>
                            )
                        })
                    }
                </div>
            </div>
        )
    }

    changeTab(id, tabArr, tabAreaClass, styleJson) {
        //console.log("switchTab id:",id," tabAreaClass:",tabAreaClass," styleJson:",styleJson," obj:",jQuery("#"+id));
        switchTab(tabAreaClass, styleJson, jQuery("#" + id));
        // tabArr.map((v,k)=>{
        //     if(v.id!==id) {
        //         jQuery("#"+v.id+"_content").hide();
        //     }
        //     else {
        //         jQuery("#"+v.id+"_content").show();
        //     }
        // });

    }
}

function switchTab(tabAreaClass, stylejson, clickobj) {
    var divStyle = getDivStyle_ByStyle(stylejson);
    var tab_head = jQuery("div." + tabAreaClass).find("div.tab_head");
    var tab_bottom = jQuery("div." + tabAreaClass).find("div.tab_bottom");

    //console.log(clickobj.attr("class")," divStyle:",divStyle," tab_head:",tab_head," tab_bottom:",tab_bottom);
    if (clickobj.attr("class") === "t_sel")
        return;
    //恢复当前选中的标签样式及内容
    var cur_sel = tab_head.find(".t_sel");
    //console.log("cur_sel:",cur_sel);
    cur_sel.add(cur_sel.children()).each(function () {
        jQuery(this).attr("class", jQuery(this).attr("class").replace("_sel", "_unsel"));
    });
    applyDivStyle(cur_sel, divStyle);
    tab_bottom.find("#" + cur_sel.attr("id") + "_content").css("display", "none");
    //设置将要选中标签样式及内容
    var will_sel = clickobj;
    will_sel.add(will_sel.children()).each(function () {
        jQuery(this).attr("class", jQuery(this).attr("class").replace("_unsel", "_sel"));
    });
    applyDivStyle(will_sel, divStyle);
    tab_bottom.find("#" + will_sel.attr("id") + "_content").css("display", "");
}

function getDivStyle_ByStyle(stylejson) {
    var t_area = "", t_sep = "";
    var t_sel_left = "", t_sel_middle = "", t_sel_right = "";
    var t_unsel_left = "", t_unsel_middle = "", t_unsel_right = "";
    if (stylejson.image_bg && stylejson.image_bg != "")
        t_area += "background-image:url('" + stylejson.image_bg + "') !important; ";
    if (stylejson.image_sep && stylejson.image_sep != "")
        t_sep += "background-image:url('" + stylejson.image_sep + "') !important; ";
    if (stylejson.image_sepwidth && stylejson.image_sepwidth != "")
        t_sep += "width:" + stylejson.image_sepwidth + "px !important; ";

    if (stylejson.sel_bgleft && stylejson.sel_bgleft != "")
        t_sel_left += "background-image:url('" + stylejson.sel_bgleft + "')!important; ";
    if (stylejson.sel_bgleftwidth && stylejson.sel_bgleftwidth != "")
        t_sel_left += "width:" + stylejson.sel_bgleftwidth + "px !important; ";
    if (stylejson.sel_bgmiddle && stylejson.sel_bgmiddle != "")
        t_sel_middle += "background-image:url('" + stylejson.sel_bgmiddle + "')!important; ";
    if (stylejson.sel_bgright && stylejson.sel_bgright != "")
        t_sel_right += "background-image:url('" + stylejson.sel_bgright + "')!important; ";
    if (stylejson.sel_bgrightwidth && stylejson.sel_bgrightwidth != "")
        t_sel_right += "width:" + stylejson.sel_bgrightwidth + "px !important; ";
    if (stylejson.sel_color && stylejson.sel_color != "")
        t_sel_middle += "color:" + stylejson.sel_color + "!important;";
    if (stylejson.sel_fontsize && stylejson.sel_fontsize != "")
        t_sel_middle += "font-size:" + stylejson.sel_fontsize + "px!important;";
    if (stylejson.sel_family && stylejson.sel_family != "")
        t_sel_middle += "font-family:" + stylejson.sel_family + "!important;";
    if (stylejson.sel_bold && stylejson.sel_bold == "1")
        t_sel_middle += "font-weight:bold!important;";
    if (stylejson.sel_italic && stylejson.sel_italic == "1")
        t_sel_middle += "font-style:italic!important;";

    if (stylejson.unsel_bgleft && stylejson.unsel_bgleft != "")
        t_unsel_left += "background-image:url('" + stylejson.unsel_bgleft + "')!important; ";
    if (stylejson.unsel_bgleftwidth && stylejson.unsel_bgleftwidth != "")
        t_unsel_left += "width:" + stylejson.unsel_bgleftwidth + "px !important; ";
    if (stylejson.unsel_bgmiddle && stylejson.unsel_bgmiddle != "")
        t_unsel_middle += "background-image:url('" + stylejson.unsel_bgmiddle + "')!important; ";
    if (stylejson.unsel_bgright && stylejson.unsel_bgright != "")
        t_unsel_right += "background-image:url('" + stylejson.unsel_bgright + "')!important; ";
    if (stylejson.unsel_bgrightwidth && stylejson.unsel_bgrightwidth != "")
        t_unsel_right += "width:" + stylejson.unsel_bgrightwidth + "px !important; ";
    if (stylejson.unsel_color && stylejson.unsel_color != "")
        t_unsel_middle += "color:" + stylejson.unsel_color + "!important;";
    if (stylejson.unsel_fontsize && stylejson.unsel_fontsize != "")
        t_unsel_middle += "font-size:" + stylejson.unsel_fontsize + "px!important;";
    if (stylejson.unsel_family && stylejson.unsel_family != "")
        t_unsel_middle += "font-family:" + stylejson.unsel_family + "!important;";
    if (stylejson.unsel_bold && stylejson.unsel_bold == "1")
        t_unsel_middle += "font-weight:bold!important;";
    if (stylejson.unsel_italic && stylejson.unsel_italic == "1")
        t_unsel_middle += "font-style:italic!important;";

    var divstyle = {};
    divstyle.t_area = t_area;
    divstyle.t_sep = t_sep;
    divstyle.t_sel_left = t_sel_left;
    divstyle.t_sel_middle = t_sel_middle;
    divstyle.t_sel_right = t_sel_right;
    divstyle.t_unsel_left = t_unsel_left;
    divstyle.t_unsel_middle = t_unsel_middle;
    divstyle.t_unsel_right = t_unsel_right;
    return divstyle;
}

function applyDivStyle(divobj, divstyle) {
    for (var key in divstyle) {
        divobj.find("div." + key).attr("style", divstyle[key]);
    }
}

export default FormTabLayout