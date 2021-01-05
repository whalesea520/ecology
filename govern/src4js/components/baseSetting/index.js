import React from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { DatePicker, Input, Card, Table, Icon, Divider, Steps, Menu, Row, Col, Tabs, Form, Button, Select, message } from 'antd';
import * as Actions from '../../actions/govern';
import WeaDBTop from '../../plugin/wea-DB-top';

import WeaInput from '../../plugin/wea-input';
import WeaBrowser from '../../plugin/wea-browser';
import WeaTools from '../../plugin/wea-tools';

const Option = Select.Option;
const FormItem = Form.Item;

class Set extends React.Component {

    componentDidMount() {
        this.init();
    }
    init = () => {
        WeaTools.callApi(`/govern/interfaces/governAction.jsp?action=initBaseSet`, 'POST', {}).then(({ projectflowid, projectflowname, projectLink, taskLink, portalLink, operatermodeid, taskmodeid, menulistlink, menutreelink, projectmodeid,enable,messageSend}) => {
            let data = {
                projectflowid, projectflowidObj: [{ id: projectflowid, name: projectflowname }], projectLink, taskLink, portalLink, operatermodeid, taskmodeid, menulistlink, menutreelink, projectmodeid,enable,messageSend
            }
            this.setState({ data });
        });
    }
    constructor(props) {
        super(props);
        this.state = {
            data: { projectflowid: "", projectflowidObj: [{ id: "", name: "" }], projectLink: "", taskLink: "", portalLink: "", operatermodeid: "", taskmodeid: "", menulistlink: "", menutreelink: "", projectmodeid: "",enable: "" ,messageSend:""},
        }
    }

    changeSearchData = (id, value) => {
        let data = this.state.data;
        data[id] = value;
        this.setState({ data });
    }

    changeFlowId = (d1, d2) => {
        console.log(d1, d2);
        const { data, formId } = this.state;
        data.projectflowid = d1;
        data.projectflowidObj = d2;
        this.setState({ data })
    }

    settingSave = () => {
        const { data } = this.state;
        WeaTools.callApi(`/govern/interfaces/governAction.jsp?action=saveBaseSetting`, 'POST', { ...data }).then(({ }) => {
            message.success("保存成功！")
        });
    }

    onEnableChange = (value) => {
        let data = this.state.data;
        data.enable = value;
        this.setState({data});
    }

    onMessageSendChange = (value) => {
        let data = this.state.data;
        data.messageSend = value;
        this.setState({data});
    }

    render() {
        let data = this.state.data;
        return (
            <div>
                <WeaDBTop>
                    <Card title="基本信息" bordered={false} extra={<Button type="primary" onClick={() => { this.settingSave() }} >保存</Button>}>
                        <Form layout="vertical" hideRequiredMark>
                            <Row gutter={16}>
                                <Col xl={{ span: 6, offset: 2 }} lg={{ span: 8 }} md={{ span: 12 }} sm={24}>
                                    <Form.Item label="督办项目链接路径">
                                        <WeaInput onChange={(v) => { this.changeSearchData("projectLink", v) }} value={data.projectLink} id="projectLink" fieldName="projectLink" name="projectLink" viewAttr="3" />
                                    </Form.Item>
                                </Col>
                            </Row>
                            <Row gutter={16}>
                                <Col xl={{ span: 6, offset: 2 }} lg={{ span: 8 }} md={{ span: 12 }} sm={24}>
                                    <Form.Item label="督办任务链接路径">
                                        <WeaInput onChange={(v) => { this.changeSearchData("taskLink", v) }} value={data.taskLink} id="taskLink" fieldName="taskLink" name="taskLink" viewAttr="3" />
                                    </Form.Item>
                                </Col>
                            </Row>
                            <Row gutter={16}>
                                <Col xl={{ span: 6, offset: 2 }} lg={{ span: 8 }} md={{ span: 12 }} sm={24}>
                                    <Form.Item label="立项流程">
                                        <WeaBrowser
                                            ismult={false}//单选多选
                                            url="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp"
                                            valueData={data.projectflowidObj}
                                            onChange={(d1, d2) => { this.changeFlowId(d1, d2) }}
                                        />
                                    </Form.Item>
                                </Col>
                            </Row>
                            <Row gutter={16}>
                                <Col xl={{ span: 6, offset: 2 }} lg={{ span: 8 }} md={{ span: 12 }} sm={24}>
                                    <Form.Item label="任务模块ID">
                                        <WeaInput onChange={(v) => { this.changeSearchData("taskmodeid", v) }} value={data.taskmodeid} id="taskmodeid" fieldName="taskmodeid" name="taskmodeid" viewAttr="3" />
                                    </Form.Item>
                                </Col>
                            </Row>
                            <Row gutter={16}>
                                <Col xl={{ span: 6, offset: 2 }} lg={{ span: 8 }} md={{ span: 12 }} sm={24}>
                                    <Form.Item label="操作者模块ID">
                                        <WeaInput onChange={(v) => { this.changeSearchData("operatermodeid", v) }} value={data.operatermodeid} id="operatermodeid" fieldName="operatermodeid" name="operatermodeid" viewAttr="3" />
                                    </Form.Item>
                                </Col>
                            </Row>
                            <Row gutter={16}>
                                <Col xl={{ span: 6, offset: 2 }} lg={{ span: 8 }} md={{ span: 12 }} sm={24}>
                                    <Form.Item label="项目模块ID">
                                        <WeaInput onChange={(v) => { this.changeSearchData("projectmodeid", v) }} value={data.projectmodeid} id="projectmodeid" fieldName="projectmodeid" name="projectmodeid" viewAttr="3" />
                                    </Form.Item>
                                </Col>
                            </Row>
                            <Row gutter={16}>
                                <Col xl={{ span: 6, offset: 2 }} lg={{ span: 8 }} md={{ span: 12 }} sm={24}>
                                    <Form.Item label="门户页面路径">
                                        <WeaInput onChange={(v) => { this.changeSearchData("portalLink", v) }} value={data.portalLink} id="portalLink" fieldName="portalLink" name="portalLink" viewAttr="3" />
                                    </Form.Item>
                                </Col>
                            </Row>
                            {/*<Row gutter={16}>
                                <Col xl={{ span: 6, offset: 2 }} lg={{ span: 8 }} md={{ span: 12 }} sm={24}>
                                    <Form.Item label="菜单列表路径">
                                        <WeaInput onChange={(v) => { this.changeSearchData("menulistlink", v) }} value={data.menulistlink} id="menulistlink" fieldName="menulistlink" name="menulistlink" viewAttr="3" />
                                    </Form.Item>
                                </Col>
                            </Row>
                            <Row gutter={16}>
                                <Col xl={{ span: 6, offset: 2 }} lg={{ span: 8 }} md={{ span: 12 }} sm={24}>
                                    <Form.Item label="菜单树路径">
                                        <WeaInput onChange={(v) => { this.changeSearchData("menutreelink", v) }} value={data.menutreelink} id="menutreelink" fieldName="menutreelink" name="menutreelink" viewAttr="3" />
                                    </Form.Item>
                                </Col>
                            </Row>*/}
                            <Row gutter={16}>
                                <Col xl={{ span: 6, offset: 2 }} lg={{ span: 8 }} md={{ span: 12 }} sm={24}>
                                    <Form.Item label="是否自动下发">
                                        <Select value={data.enable} style={{ width: 120 }} onChange={this.onEnableChange.bind(this)}>
                                            <Option value={"0"}></Option>
                                            <Option value={"1"}>是</Option>
                                            <Option value={"2"}>否</Option>
                                        </Select>
                                    </Form.Item>
                                </Col>
                            </Row>
                            <Row gutter={16}>
                                <Col xl={{ span: 6, offset: 2 }} lg={{ span: 8 }} md={{ span: 12 }} sm={24}>
                                    <Form.Item label="是否推送消息">
                                        <Select value={data.messageSend} style={{ width: 120 }} onChange={this.onMessageSendChange.bind(this)}>
                                            <Option value={"0"}></Option>
                                            <Option value={"1"}>是</Option>
                                            <Option value={"2"}>否</Option>
                                        </Select>
                                    </Form.Item>
                                </Col>
                            </Row>
                        </Form>
                    </Card>
                </WeaDBTop>
            </div>
        )
    }
}
const mapStateToProps = (state, props) => {
    const { card } = state;
    return {
        billid: props.location.query.billid,
        formId: props.location.query.formId,
        modeId: props.location.query.modeId,
    }
}
mapDispatchToProps = (dispatch) => {
    return {
        actions: bindActionCreators({}, dispatch)
    }
}
export default connect(mapStateToProps, mapDispatchToProps)(Set);