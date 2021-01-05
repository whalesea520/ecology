import React from 'react';

import { Input, Form, Checkbox, Select, Icon, Upload, Button, DatePicker } from 'antd';

import { WeaSelect, WeaInput, WeaBrowser, WeaCheckbox, WeaTextarea, WeaUpload, WeaDatePicker, WeaTimePicker } from 'ecCom'

import trim from 'lodash/trim'

import * as Util from '../../util/modeUtil'

class FormField extends React.Component {

    changeshowattr = (value) => {
        const { cellObj, symbol, functionAttr, drowIndex } = this.props
        functionAttr.changeshowattr(value, cellObj.field, symbol, drowIndex);
    }
    doChangeEvent = (idsT, idsB) => {
        const valueInfo = { value: idsT.concat(idsB).join(',') };
        const { cellObj, symbol, functionAttr, drowIndex } = this.props;
        functionAttr.fileUpload(symbol, drowIndex, cellObj.field, "1", valueInfo.value);
        //getUploadFileInfo
        //actions.changeFieldValue(baseInfo, valueInfo);
    }
    changeField = (value) => {
        const { fieldObj, formValue, functionAttr, symbol, drowIndex } = this.props
        functionAttr.changeField(fieldObj, value, symbol, drowIndex);
    }
    changeBrowserField = (ids, names, datas) => {
        const { fieldObj, formValue, functionAttr, symbol, drowIndex } = this.props
        functionAttr.changeField(fieldObj, ids, symbol, drowIndex);
    }
    changeDate = (value) => {
        console.log(value);
    }
    render() {
        const { getFieldProps } = this.props
        const { cellObj, fieldObj, formValue, type, drowIndex, symbol, modeInfo } = this.props;
        const { functionAttr } = this.props;
        const htmltype = fieldObj ? fieldObj.htmltype : "";
        const detailtype = fieldObj ? fieldObj.type : "";
        const fieldid = cellObj.field;
        const isdetail = fieldObj && (fieldObj.isdetail == "1");
        const fieldlabel = fieldObj ? fieldObj.fieldlabel : "";

        let fieldidStr = isdetail ? `field${fieldid}_${drowIndex}` : `field${fieldid}`;

        const fieldValueObj = formValue[fieldid];
        let theValue = fieldValueObj ? fieldValueObj.value : "";

        let showid = symbol + "." + fieldid;
        let ishide = (isdetail ? (fieldValueObj.attrHide ? fieldValueObj.attrHide : fieldObj.ishide) : (fieldObj.attrHide ? fieldObj.attrHide : fieldObj.ishide)) == "1";
        let isedit = (isdetail ? (fieldValueObj.attrEdit ? fieldValueObj.attrEdit : fieldObj.isedit) : (fieldObj.attrEdit ? fieldObj.attrEdit : fieldObj.isedit)) == "1";
        let isview = (isdetail ? (fieldValueObj.attrView ? fieldValueObj.attrView : fieldObj.isview) : (fieldObj.attrView ? fieldObj.attrView : fieldObj.isview) == "1");
        let ismandatory = (isdetail ? (fieldValueObj.attrMandatory ? fieldValueObj.attrMandatory : fieldObj.ismandatory) : (fieldObj.attrMandatory ? fieldObj.attrMandatory : fieldObj.ismandatory)) == "1";

        let spanShowName;
        let viewAttr = ismandatory ? 3 : (isedit ? 2 : 1);
        let fieldElement = <div>{theValue}</div>;
        if (htmltype == "1") {

            const financial = cellObj.financial;
            if (financial && financial.indexOf("2-") > -1) { }
            if (detailtype == "1" || detailtype == "2" || detailtype == "3" || detailtype == "5") {
                if (ishide) {
                    fieldElement = <div>
                        <WeaInput type="hidden" name={fieldidStr} id={fieldidStr} value={theValue} />
                    </div>;
                } else {
                    //if ((type == "1" || type == "2") && (isedit || ismandatory)) {
                    fieldElement = <div>
                        <WeaInput
                            className="modeInput"
                            //{...getFieldProps(fieldidStr, { "initialValue": theValue }) }
                            id={fieldidStr}
                            fieldName={fieldidStr}
                            name={fieldidStr}
                            viewAttr={viewAttr}
                            onChange={this.changeField}
                            value={theValue}
                            style={{ width: detailtype == "1" ? "89%" : "55%", height: "24px" }}
                        />
                    </div>;
                    //<Input {...getFieldProps(fieldidStr,{"initialValue":theValue})} type="text" id={fieldidStr} />/*
                    /*} else {
                        fieldValueObj && fieldValueObj.showname && (theValue = fieldValueObj.showname);
                        fieldValueObj && fieldValueObj.formatvalue && (theValue = fieldValueObj.formatvalue);
                        if (detailtype == "1")
                            fieldElement = <span id={fieldidStr + "span"} dangerouslySetInnerHTML={{ __html: theValue }}></span>
                        else
                            fieldElement = <span id={fieldidStr + "span"}>{theValue}</span>
                    }*/
                }
            } else if (detailtype == "4") {
                const specialobj = fieldValueObj && fieldValueObj.specialobj;
                const thousandsVal = specialobj && specialobj.thousandsVal;
                const upperVal = specialobj && specialobj.upperVal;
                if ((type == "1" || type == "2") && (isedit || ismandatory)) {
                    fieldElement =
                        <table cols="2" id={fieldidStr + "__tab"} width="100%">
                            <tr>
                                <td>
                                    <WeaInput
                                        datatype="float" style={{ imeMode: "disabled", width: "95%" }}
                                        type="text"
                                        class="Inputstyle"
                                        id={"field_lable" + fieldid}
                                        name={"field_lable" + fieldid} />
                                    <span id={"field_lable" + fieldid + "span"}>{theValue}</span>
                                    <span id={"field" + fieldid + "span"}
                                        isedit="+isedit+"
                                        style={{ wordBreak: "break-all", wordWrap: "break-word" }}>
                                    </span>
                                    <WeaInput fieldtype="4" datatype="float" datalength="2" viewtype="0" temptitle="a4" type="hidden" class="Inputstyle" id={"field" + fieldid} name={"field" + fieldid} value={theValue} />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <WeaInput type="text" class="Inputstyle" style={{ width: "95%" }} id={"field_chinglish" + fieldid} name={"field_chinglish" + fieldid} readOnly={"true"} />
                                </td>
                            </tr>
                        </table>
                }


            }
        } else if (htmltype == "2") { //多行文本
            if (!ishide) {
                let textheight = fieldObj ? fieldObj.textheight : "4";
                fieldElement = <div>
                    <Input
                        className="modetextarea"
                        {...getFieldProps(fieldidStr, { "initialValue": theValue }) }
                        type="textarea"
                        name={fieldidStr}
                        rows={textheight == 0 ? 4 : textheight}
                        id={fieldidStr}
                        style={{ height: "auto", width: type == "2" ? "90%" : "80%" }}
                    />

                    <span id={fieldidStr + "span"}>{spanShowName}</span>
                </div>

                fieldElement = <div>
                    <WeaTextarea
                        fieldName={fieldidStr}
                        //{...getFieldProps(fieldidStr, { "initialValue": theValue }) }
                        id={fieldidStr}
                        name={fieldidStr}
                        value={theValue}
                        viewAttr={viewAttr}
                        onChange={this.changeField}
                        textheight={textheight == 0 ? 4 : textheight}
                    />
                </div>
            } else {
                fieldElement = <div>
                    <span id={fieldidStr + "span"} dangerouslySetInnerHTML={{ __html: theValue }} />
                </div>
            }
        } else if (htmltype == "3") {      //浏览框
            let specialobj = fieldValueObj ? fieldValueObj.specialobj : { replaceDatas: new Array() };
            let showname = specialobj ? specialobj.showname : "";
            if (fieldValueObj && fieldValueObj.formatvalue)
                showname = fieldValueObj.formatvalue;
            //<span id={fieldidStr+"spanfieldidStr"} dangerouslySetInnerHTML={{__html: showname}} />
            //        <Input type="hidden" id={fieldidStr+"13213123"} value={theValue} />
            //if ((type == "1" || type == "2") && (isedit || ismandatory)) {
            let browserAttr = fieldObj ? fieldObj.browserAttr : null;
            let issingle = browserAttr ? browserAttr.issingle : true;
            let replaceDatas = specialobj ? specialobj.replaceDatas : {};
            if (detailtype == "2") {//日期
                fieldElement = <WeaDatePicker
                    {...getFieldProps(fieldidStr, { "initialValue": theValue }) }
                    fieldName={fieldidStr}
                    onChange={this.changeField}
                    value={theValue}
                    viewAttr={viewAttr}
                />;
            } else if (detailtype == "19") {//时间
                fieldElement = <WeaTimePicker
                    {...getFieldProps(fieldidStr, { "initialValue": theValue }) }
                    fieldName={fieldidStr}
                    onChange={this.changeField}
                    value={theValue}
                    viewAttr={viewAttr}
                />;
            } else {
                fieldElement =
                    <WeaBrowser
                        type={detailtype}
                        isSingle={issingle}
                        fieldName={fieldidStr}
                        viewAttr={viewAttr}
                        title={fieldlabel}
                        onChange={this.changeBrowserField}
                        replaceDatas={replaceDatas}
                    //inputStyle={style = { width: '100px', height: '30px', fontSize: '14px' }}
                    />
            }
            /*} else {
                fieldElement = <div>
                    <span id={fieldidStr + "span"} dangerouslySetInnerHTML={{ __html: showname }} />
                    <WeaInput 
                        type="hidden" 
                        name={fieldidStr} 
                        id={fieldidStr} 
                        //{...getFieldProps(fieldidStr, { "initialValue": theValue }) } 
                        />
                </div>

            }*/

        } else if (htmltype == "4") {      //check框
            if (ishide) {
                fieldElement = <div>
                    <WeaInput
                        type="hidden"
                        name={fieldidStr}
                        id={fieldidStr}
                    //{...getFieldProps(fieldidStr, { "initialValue": theValue }) } 
                    />
                </div>
            } else {
                if ((type == "1" || type == "2") && (isedit || ismandatory)) {
                    fieldElement = <div>
                        <Checkbox
                            //{...getFieldProps(fieldidStr, { "initialValue": theValue }) } 
                            id={fieldidStr} />
                        <span id={fieldidStr + "span"}>{spanShowName}</span>
                    </div>
                } else {
                    fieldElement = <Checkbox checked={theValue == "1"} disabled />
                }
            }
        } else if (htmltype == "5") {      //选择框
            let selectAttr = fieldObj ? fieldObj.selectAttr : {};
            let selectList = selectAttr ? selectAttr.selectList : [];
            let showname = fieldValueObj && fieldValueObj.showname;     //显示名称 暂时没用
            let hasParent = fieldObj ? fieldObj.hasParent : false;      //是否存在父项
            let pValue = fieldValueObj ? fieldValueObj.pValue : "";     //父项的值
            //if ((type == "1" || type == "2") && (isedit || ismandatory)) {
            let selectArr = new Array();
            let options = new Array();
            options.push({ key: "", selected: theValue == "", showname: "" })
            for (var i = 0; i < selectList.length; i++) {
                let selectObj = selectList[i];
                if (hasParent ? Util.contains((fieldObj.valueObj ? fieldObj.valueObj : {})[pValue], selectObj.selectvalue + "") : true) {//没有父项直接加载  存在父项则父项的子项中包含此选项才加载
                    selectArr.push(<Select.Option key={selectObj.selectvalue} value={selectObj.selectvalue} >{selectObj.selectname}</Select.Option>)
                    options.push({ key: selectObj.selectvalue + "", selected: selectObj.selectvalue + "" == theValue, showname: selectObj.selectname })
                }
            }
            let s1 =
                <div>
                    <Select showSearch
                        {...getFieldProps(fieldidStr, { "initialValue": showname }) }
                        id={fieldidStr}
                        name={fieldidStr}
                        style={{ width: "80%" }}
                        placeholder="请选择"
                        optionFilterProp="children"
                        notFoundContent="无法找到"
                    >
                        {selectArr}
                    </Select>

                    <span id={fieldidStr + "span"}>{spanShowName}</span>
                </div>
            //console.log("options",options);
            fieldElement =
                <div>
                    <WeaSelect
                        fieldName={fieldidStr}
                        viewAttr={viewAttr}
                        options={options}
                        value={theValue}
                        style={{ width: "50%" }}
                        onChange={this.changeField}
                    >
                    </WeaSelect>
                </div>
            //} else {
            //    fieldElement = <span id={fieldidStr + "span"}>{showname}</span>
            //}
        } else if (htmltype == "6") {
            //if ((type == "1" || type == "2") && (isedit || ismandatory)) {
            let docCategory = modeInfo.maincategory + "," + modeInfo.subcategory + "," + modeInfo.seccategory;
            let category = trim(docCategory)
            let uploadUrl = "/api/formmode/card/docUpload?category=" + category
            let specialobj = fieldValueObj ? fieldValueObj.specialobj : null;
            let datas = specialobj ? specialobj.filedatas : new Array();
            let showBatchLoad = specialobj ? specialobj.showBatchLoad : true;
            fieldElement = <WeaUpload
                //{...getFieldProps(fieldidStr, { "initialValue": theValue }) }
                value={theValue}
                uploadId={fieldidStr}
                uploadUrl={uploadUrl}
                autoUpload={true}
                category={category}
                viewAttr={viewAttr}
                showClearAll={true}
                datas={datas}
                showBatchLoad={true}
                btnSize={isdetail ? "small" : ""}
                onChange={this.doChangeEvent}
                //listType="img"
                limitType=""
            />
            // }
        }
        return fieldElement
    }
}
export default FormField