import React from 'react';

import FormLayout from '../FormLayout'

import { Button, Icon } from 'antd';

import { WeaInput } from 'ecCom'
class ReplyItem extends React.Component {
    componentDidMount() {
        let replayContentFieldId = this.props.replayContentFieldId;
        let data = this.props.data;
        UEUtil.initEditor(replayContentFieldId + "_" + data.id);
    }


    onEdit0 = (event) => {
        var e = event || window.event;
        let replayContentFieldId = this.props.replayContentFieldId;
        let data = this.props.data;
        if (jQuery("#remark_div_" + data.id).css('display') == "none") {
            jQuery("#remark_div_" + data.id).css('display', 'block');

            let obj = UE.getEditor(replayContentFieldId + "_" + data.id).setContent(data.replycontent);

        }
    }

    onQuote = () => {
        this.onReload("quote");
    }

    onEdit = () => {
        this.onReload("edit");
    }

    onReload = (type) => {
        let data = this.props.data;
        let replyListData = this.props.replyListData;
        let replayContentFieldId = this.props.replayContentFieldId;
        let replyData = replyListData[data.id] ? replyListData[data.id] : {};
        let dealType = replyData.dealType;
        if (type == "edit" && dealType != "edit") {//编辑的时候 之前的操作类型不是编辑 初始化文本内容
            UE.getEditor(replayContentFieldId + "_" + data.id).setContent(data.replycontent);
        }
        if (type == "quote" && dealType != "quote") {
            UE.getEditor(replayContentFieldId + "_" + data.id).setContent("");
        }
        replyData.dealType = type;
        replyListData[data.id] = replyData;
        this.props.actions.changeEditId(replyListData, data.id);
    }

    onCancel = () => {
        this.props.actions.changeEditId("0");
        //let data = this.props.data;
        //jQuery("#remark_div_" + data.id).css('display', 'none');
    }
    hideorshow = () => {
        let data = this.props.data;
        if (jQuery('#otherFields_' + data.id).css('display') == "none") {
            jQuery('#otherFields_' + data.id).css('display', 'block');
        } else {
            jQuery('#otherFields_' + data.id).css('display', 'none');
        }
    }

    doSubmit = () => {
        const { replyModeInfo, replayContentFieldId, replyIndex, replyListData } = this.props;

        let detaType = replyListData[replyIndex].dealType;
        let submitData = replyListData[replyIndex][detaType];
        let content = UE.getEditor(replayContentFieldId + "_" + replyIndex).getContent();
        submitData[replayContentFieldId] = content;

        this.props.actions.saveReply({
            layoutid: replyModeInfo.layoutid, formId: replyModeInfo.formid, modeId: replyModeInfo.id, type: detaType == "edit" ? "2" : "1", billid: replyIndex,
            reqModeId: modeId, reqBillid: billid, reqFormid: formId, from: "reply", src: detaType, iscreate: detaType == "edit" ? "1" : "0", isFormMode: "1",
            JSONStr: JSON.stringify(submitData)
        })
    }

    changeField = (fieldObj, value, symbol, drowIndex) => {
        let replyListData = this.props.replyListData;
        let replyIndex = this.props.replyIndex;

        let fieldid = fieldObj.fieldid;
        let fieldname = fieldObj.fieldname;

        let replyData = replyListData[replyIndex];
        let dealType = replyData.dealType;
        let realData = replyData[dealType] ? replyData[dealType] : {};
        realData["field" + fieldid] = value;
        replyData[dealType] = realData;
        replyListData[replyIndex] = replyData;
        console.log(replyListData);
        this.props.actions.changeReplyList(replyListData);
    }

    render() {
        const { actions, data, modeId, formId, billid } = this.props;
        const { getFieldProps, replyModeInfo, colhead, rowhead, ecMap, replyFieldList, functionAttr, replayContentFieldId, replyIndex, replyListData } = this.props;
        functionAttr.changeField = this.changeField;
        let mainData = {};

        let replyData = replyListData[data.id] ? replyListData[data.id] : {};
        let dealType = replyData.dealType;
        if (dealType == "edit") {
            let realDate = replyData[dealType] ? replyData[dealType] : {};
            for (let item in replyFieldList) {
                let fieldObj = replyFieldList[item];
                let fieldname = fieldObj.fieldname;
                let value = realDate["field" + item] ? realDate["field" + item] : data[fieldname];
                if (value) {
                    mainData[item] = { fieldid: item, fieldname: fieldname, value: value }
                }
            }
            if (data.id == replyIndex) {
                console.log("mainData", mainData);
            }
        }else{
            if (data.id == replyIndex) {
                console.log("mainData", replyModeInfo.initData.data);
            }
        }


        const dpurl = "http://192.168.31.92:8070/hrm/company/HrmDepartmentDsp.jsp?id=" + data.replyor;
        const img_path = data.img_path;
        return (
            <div className='wea-formmode-reply-list-content'>
                <div className='content-left'>
                    <img src={img_path} className='content-text-left-user-img' />
                    <div style={{ 'width': '132px' }}>
                        <p>
                            <a href={`javaScript:openhrm(${data.replyor})`} onClick={event => window.pointerXY(event)}>{data.replyorname ? data.replyorname : "系统管理员"}</a>
                        </p>
                        <span>
                            <a href={dpurl} target="_blank" style={{ color: '#9b9b9b', 'white-space': 'pre-wrap' }}>
                                {data.replyorname ? data.replyorname : "系统管理员"}
                            </a>
                        </span>
                    </div>
                </div>
                <div className='content-right'>

                    <div className='content-right-remark-html' dangerouslySetInnerHTML={{ __html: (data.replycontent ? data.replycontent : '') }} />
                    {data.rdocument &&
                        <div className='content-right-other-html'>
                            相关文档：	{data.rdocumentName}
                        </div>
                    }
                    {data.rworkflow &&
                        <div className='content-right-other-html'>
                            相关流程：	{data.rworkflowName}
                        </div>
                    }
                    {data.rcustomer &&
                        <div className='content-right-other-html'>
                            相关客户：	{data.rcustomerName}
                        </div>
                    }
                    {data.rproject &&
                        <div className='content-right-other-html'>
                            相关项目：	{data.rprojectName}
                        </div>
                    }
                    <p style={{ lineHeight: '22px', marginTop: 10, color: '#9a9a9a' }}>
                        <span style={{ marginRight: 8 }}>{`${data.replydate}`}</span>
                        <span>{`${data.replytime}`}</span>
                        <span className="btnspan">
                            #{data.floornum}  &nbsp; &nbsp;
                            <Icon type="edit" />
                            <a onClick={this.onEdit}>编辑</a>&nbsp; &nbsp;
                            <Icon type="delete" />
                            <a >删除</a>&nbsp; &nbsp;
                            <Icon type="copy" />
                            <a onClick={this.onQuote}>引用</a> &nbsp; &nbsp;
                            <Icon type="calculator" />
                            <a >评论</a>
                        </span>
                    </p>
                    <div id={"remark_" + data.id} style={{ border: "1px solid #d6d6d6", background: "#F7F7F7" }}>
                        <div id={"remark_div_" + data.id} style={{ height: '100%', marginRight: '0px', marginBottom: 10, marginTop: 10, display: data.id == replyIndex ? "" : "none" }} >

                            <div style={{ marginLeft: 30 }}>
                                <div className='formModeReplyContent'  >
                                    <textarea className="Inputstyle" id={replayContentFieldId + "_" + data.id} name={replayContentFieldId + "_" + data.id} rows="4" style={{ width: "92%", wordBreak: "break-all", wordWrap: "break-word" }} >

                                    </textarea>
                                </div>
                                <br />
                                <div className="btnDiv">
                                    <Button style={{ marginLeft: 10 }}
                                        type="primary"
                                        onClick={this.doSubmit}>
                                        提交
                                    </Button>
                                    <Button style={{ marginLeft: 10 }}
                                        onClick={this.onCancel}>
                                        取消
                                    </Button>
                                    <Button style={{ marginRight: 100 + "" }}
                                        className="formModeExternalBtn"
                                        type="dashed"
                                        onClick={this.hideorshow}>
                                        附加功能
                                    </Button>
                                </div>
                                <div style={{ marginTop: 10, display: "block" }} id={"otherFields_" + data.id}>
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
                                        mainData={mainData}
                                        detailData={{}}
                                        functionAttr={functionAttr}
                                        modeField={{}}
                                    />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div >
        )
    }
}
export default ReplyItem