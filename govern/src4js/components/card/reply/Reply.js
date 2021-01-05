import React from 'react';
import {
    WeaTab,
    WeaTable,
    WeaSearchGroup,
    WeaInput,
    WeaDateGroup,
    WeaHrmInput,
    WeaDepInput,
    WeaComInput,
    WeaDatePicker,
    WeaSelect
} from 'ecCom'

import ReplyItem from './ReplyItem'

import { Row, Col, Icon, Pagination, Menu, Form, Button, Spin, BackTop } from 'antd';

import FormLayout from '../FormLayout'

const FormItem = Form.Item;

class Reply extends React.Component {

    componentDidMount() {
        //if (this.props.replyType != "0") {
        //if (window.replyload != 1) {
        let replyModeInfo = this.props.replyModeInfo;
        //window.replyload = 1;
        UEUtil.initEditor('field' + replyModeInfo.replayContentFieldId);
        UEUtil.checkRequired('field' + replyModeInfo.replayContentFieldId);
        //}
        //}
    }

    /**
     * 加载更多
     */
    loadMore = () => {
        let dataLength = parseInt(this.props.dataLength);
        this.props.actions.showMore((dataLength + 5) + "");
    }


    iniField = (id, fieldid, fieldname, type) => {
        let obj = {};
        obj.colspan = "1";
        obj.etype = type
        obj.evalue = fieldname;
        obj.field = fieldid;
        obj.font = {
            valign: "middle"
        }
        obj.id = id;
        obj.rowspan = "1";
        if (type == "2") {
            obj.backgroundColor = "#e7f3fc";
        }
        let ebrArr = []
        ebrArr.push({
            color: "#90badd",
            kind: "top",
            style: "1"
        })
        ebrArr.push({
            color: "#90badd",
            kind: "left",
            style: "1"
        })
        ebrArr.push({
            color: "#90badd",
            kind: "right",
            style: "1"
        })
        ebrArr.push({
            color: "#90badd",
            kind: "bottom",
            style: "1"
        })
        obj.eborder = ebrArr;
        return obj;
    }

    /**
     * 附加功能 显示/隐藏
     */
    hideorshow = () => {
        if (jQuery('#otherFields').css('display') == "none") {
            jQuery('#otherFields').css('display', 'block');
        } else {
            jQuery('#otherFields').css('display', 'none');
        }
    }

    /**
     * 回复部分字段修改 重写FormField组件中所有字段onChange事件调用 回复评论区域不处理联动内容
     */
    changeField = (fieldObj, value, symbol, drowIndex) => {
        let fieldid = fieldObj.fieldid;
        let replyData = this.props.replyData;
        replyData.data[fieldid].value = value;
        this.props.actions.changeReply(replyData, "1", this.props.top, "0");
    }

    /**
     * 回复评论提交
     */
    doSubmit = () => {
        const { replyData, replyModeInfo } = this.props;
        const { modeId, formId, billid } = this.props;
        let content = UE.getEditor('field' + replyModeInfo.replayContentFieldId).getContent();
        let submitData = {};

        for (let item in replyData.data) {
            let obj = replyData.data[item];
            let value = obj.value;
            if (value) {
                submitData["field" + item] = value;
            }
        }
        submitData['field' + replyModeInfo.replayContentFieldId] = content;

        console.log(submitData);
        this.props.actions.saveReply({
            layoutid: replyModeInfo.layoutid, formId: replyModeInfo.formid, modeId: replyModeInfo.id, type: "1",
            reqModeId: modeId, reqBillid: billid, reqFormid: formId, from: "reply", src: "submit", iscreate: "1", isFormMode: "1",
            JSONStr: JSON.stringify(submitData)
        })
    }

    /**
     * 回复评论部分显示
     */
    changeReply = (event) => {
        var e = event || window.event;
        let replyData = this.props.replyData;
        let replyType = this.props.replyType;
        replyType = replyType == "1" ? "0" : "1";
        this.props.actions.changeReply(replyData, "1", e.screenY, "0");
    }

    /**
     * 高级搜索
     */
    onSearch = () => {
        const { modeId, billid, formId, replySearchData } = this.props
        this.props.actions.searchReply({ modeId, billid, formId, ...replySearchData });
    }

    /**
     * 加载高级搜索查询条件
     */
    getSearchs = () => {
        const { getFieldProps } = this.props.form;
        const replySearchData = this.props.replySearchData;
        let items = new Array();

        items.push({
            com: (<FormItem
                label="内容"
                labelCol={{ span: 6 }}
                wrapperCol={{ span: 18 }}>
                <WeaInput {...getFieldProps("content", { "initialValue": replySearchData.content }) } />
            </FormItem>),
            colSpan: 1
        });

        items.push({
            com: (<FormItem
                label="发表人"
                labelCol={{ span: 6 }}
                wrapperCol={{ span: 18 }}>
                <WeaHrmInput {...getFieldProps("operatorid", { "initialValue": replySearchData.operatorid }) } />
            </FormItem>),
            colSpan: 1
        });

        items.push({
            com: (<FormItem
                label="操作日期"
                labelCol={{ span: 6 }}
                wrapperCol={{ span: 18 }}>
                <WeaDateGroup {...getFieldProps("createdateselect", {
                    initialValue: replySearchData.createdateselect
                }) } datas={[
                    { value: '0', selected: true, name: '全部' },
                    { value: '1', selected: false, name: '今天' },
                    { value: '2', selected: false, name: '本周' },
                    { value: '3', selected: false, name: '本月' },
                    { value: '4', selected: false, name: '本季' },
                    { value: '5', selected: false, name: '本年' },
                    { value: '6', selected: false, name: '指定日期范围' }
                ]} form={this.props.form} domkey={["createdateselect", "createdatefrom", "createdateto"]} />
            </FormItem>), //创建日期    createdateselect    ==6范围   createdatefrom---createdateto
            colSpan: 1
        });

        items.push({
            com: (<FormItem
                label="楼号"
                labelCol={{ span: 6 }}
                wrapperCol={{ span: 6 }}>
                <WeaInput {...getFieldProps("floornum", { "initialValue": replySearchData.floornum }) } />
            </FormItem>),
            colSpan: 1
        });

        return [
            (<WeaSearchGroup col={2} needTigger={true} title="查询条件" showGroup={true} items={items} />),
        ]
    }

    render() {
        const { actions, replyList, modeId, formId, billid, replyFieldList, getFieldProps, replyModeInfo, replyData, replyType, showType, replySearchData, top, replyIndex, dataLength, replyListData } = this.props
        let replayContentFieldId = "field" + replyModeInfo.replayContentFieldId;

        let functionAttr = this.props.functionAttr;
        functionAttr.changeField = this.changeField;
        functionAttr.changeListField = this.changeListField;

        let staticWidth = parseInt(document.body.clientWidth, 0);
        let labelWidth = staticWidth * 0.52;
        let fieldWidth = staticWidth * 0.26;
        let btnright = staticWidth * 0.22;

        let colhead = { col_1: labelWidth + "", col_0: fieldWidth + "" };
        let rowhead = { row_0: "30" };
        let ecMap = {};
        let i = 0;
        for (let item in replyFieldList) {
            let fieldObj = replyFieldList[item];
            let isedit = fieldObj ? fieldObj.isedit : "";
            let htmltype = fieldObj ? fieldObj.htmltype : "2";
            if (isedit == "1" && htmltype != "2") {
                let fieldid = fieldObj ? fieldObj.fieldid : "";
                let fieldlabel = fieldObj ? fieldObj.fieldlabel : "";
                rowhead["row_" + i] = "30";
                ecMap[i + ",0"] = this.iniField(i + ",0", fieldid, fieldlabel, "2");
                ecMap[i + ",1"] = this.iniField(i + ",1", fieldid, fieldlabel, "3");
                i++;
            }
        }

        let replys = [];
        let rsize = 0;
        let showMore = true;
        if (replyList.length > parseInt(dataLength)) {
            rsize = parseInt(dataLength);
        } else {
            rsize = replyList.length;
            showMore = false;
        }
        for (let i = 0; i < rsize; i++) {
            let obj = replyList[i];
            replys.push(
                <ReplyItem data={obj}
                    actions={this.props.actions}
                    modeId={modeId}
                    formId={formId}
                    billid={billid}
                    getFieldProps={getFieldProps}
                    replyModeInfo={replyModeInfo}
                    colhead={colhead}
                    rowhead={rowhead}
                    ecMap={ecMap}
                    replyFieldList={replyFieldList}
                    functionAttr={functionAttr}
                    replayContentFieldId={replayContentFieldId}
                    replyIndex={replyIndex}
                    replyListData={replyListData}
                />
            )
        }
        return (
            <div className='wea-formmode-reply'>
                <div>
                    <div id="remarkShadowDiv" name="remarkShadowDiv" style={{ display: replyType == "0" ? "" : "none" }}>
                        <div id="remarkShadowDivInnerDiv" onClick={this.changeReply} title="请填写评论内容">
                            <span style={{ margin: "0 5px" }}>
                                <img style={{ verticalAlign: "middle" }} src="/images/sign/sign_wev8.png" />
                            </span>
                            <span style={{ lineHeight: "30px" }}>请填写评论内容</span>
                        </div>
                    </div>
                    <div id="remark_div" style={{
                        border: "1px solid #d6d6d6", background: "#F7F7F7",
                        // position: "fixed", zIndex: "99999", height: 'auto', left: 60, top: 300,//浮动效果暂时不用
                        marginRight: '0px', display: replyType == "0" ? "none" : ""
                    }} >

                        <div className='remarkDiv' style={{ marginLeft: 30, marginRight: 30, marginTop: 30, marginBottom: 30, display: replyType == "0" ? "none" : "" }}>
                            <div className='formModeReplyContent'  >
                                <textarea className="Inputstyle" id={replayContentFieldId} name={replayContentFieldId} rows="4" style={{ width: "90%", wordBreak: "break-all", wordWrap: "break-word" }} >

                                </textarea>
                            </div>
                            <br />
                            <div className="btnDiv">
                                <Button style={{ marginLeft: 10 }}
                                    type="primary"
                                    onClick={this.doSubmit}>
                                    提交
                                </Button>
                                <Button style={{ marginRight: btnright + "" }}
                                    className="formModeExternalBtn"
                                    type="dashed"
                                    onClick={this.hideorshow}>
                                    附加功能
                                </Button>
                            </div>
                            <div style={{ marginTop: 10, display: "block" }} id="otherFields">
                                <FormLayout
                                    getFieldProps={getFieldProps}
                                    symbol="replyTable"
                                    className="excelReplyTable"
                                    modeInfo={replyModeInfo}
                                    type={"1"}
                                    colheads={colhead}
                                    rowheads={rowhead}
                                    rowattrs={{}}
                                    colattrs={{}}
                                    ecMap={ecMap}
                                    mainFields={replyFieldList}
                                    detailTable={{}}
                                    mainData={{}}
                                    detailData={{}}
                                    functionAttr={functionAttr}
                                    modeField={{}}

                                />
                            </div>
                        </div>
                    </div>
                    <WeaTab
                        selectedKey={"1"}
                        datas={[
                            { title: '评论相关', key: "1" }
                        ]}
                        keyParam='key'
                        showSearchDrop={showType}
                        hasDropMenu={true}
                        dropIcon={<i className='icon-search-search' style={{ color: '#77da88' }} onClick={() => actions.changeShowSearchDrop()} />}
                        searchType="drop"
                        searchsDrop={<Form horizontal>{this.getSearchs()}</Form>}
                        buttonsDrop={[
                            <Button type="primary" onClick={this.onSearch}>搜索</Button>,
                            <Button type="ghost" >重置</Button>,
                            <Button type="ghost" onClick={() => { actions.changeShowSearchDrop() }} >取消</Button>
                        ]}
                    />
                    <div id="replyList" className='wea-formmode-reply-list'>
                        {replys}
                        {replys && replys.length == 0 &&
                            <div className='ant-table-placeholder' style={{ borderBottom: 0 }}>暂时没有数据</div>
                        }
                        {replys && showMore &&
                            <div classnName="moreFoot" style={{ display: "block" }}>
                                <a hidefocus="" onClick={this.loadMore}>
                                    <em className="ico_load"></em>更多<em className="more_down"></em>
                                </a>
                            </div>
                        }
                    </div>
                </div>
            </div>

        )
    }
}

Reply = Form.create({
    onFieldsChange(props, fields) {
        const { replySearchData, actions } = props;
        for (var item in fields) {
            replySearchData[item] = fields[item].value;
        }
        actions.replyCondition(replySearchData, true)
    },
    mapPropsToFields(props) {
        return props.orderFields || {};
    }
})(Reply);

export default Reply