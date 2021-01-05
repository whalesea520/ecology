import React from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { DatePicker, Input, Card, Table, Icon, Divider, Steps, Menu, Row, Col, Tabs, Form, Button, Select, message ,Tooltip } from 'antd';
import * as Actions from '../../actions/govern';
import WeaDBTop from '../../plugin/wea-DB-top';
import equal from 'deep-equal';

import WeaInput from '../../plugin/wea-input';
import WeaBrowser from '../../plugin/wea-browser';
import WeaTools from '../../plugin/wea-tools';

const Option = Select.Option;
const FormItem = Form.Item;

class Setting extends React.Component {

    constructor(props) {
        super(props);
        this.state = {
            data: { setName: "", tableName: "",topic:"", enable: "", flowid: "", flowidObj: [{ id: "", name: "" }] },
            flowFields: [],
            modeFields: [],
            formId: -900,
            options: [],
            detailOptions: [],
            flowidFields: [],
            formidFields: [],
            detailFlowFields: [],
            detailModeFields: [],
        }
    }

    componentDidMount() {
        const { settype } = this.props.location.query;
        this.init(settype);
        this.doUpdate(this.props);
    }

    init = (settype) => {
        WeaTools.callApi(`/govern/interfaces/governAction.jsp?action=initSet`, 'POST', { settype }).then(({ flowFields, modeFields, basicInfo, detailFlowFields, detailModeFields }) => {
            const { data } = this.state;
            const { detaillist } = this.state;
            // console.log("basicInfo " + basicInfo.setName)
            data.setName = basicInfo.setName;
            data.tableName = basicInfo.tableName;
            data.flowid = basicInfo.flowid;
            data.topic = basicInfo.topic;
            var param = [{ id: basicInfo.flowid, name: basicInfo.workflowname }]
            data.flowidObj = param;   
            data.enable = basicInfo.enable;
            this.setState({ data });

            let options = [<Option value=""></Option>];
            modeFields.map((d) => {
                if (d.id) {
                    options.push(<Option value={d.id} >{d.labelname}</Option>);
                }
            });

            let detailOptions = [<Option value="" name="" ></Option>];
            detailModeFields.map((d) => {
                if (d.id)  {
                    detailOptions.push(<Option value={d.id} name={d.detailtable} >{d.labelname}</Option>);
                }
            });

            this.setState({ flowFields, modeFields, options: options, detailOptions: detailOptions, detailFlowFields, detailModeFields })
        });
    }

    componentWillReceiveProps(nextProps) {
        if (!equal(nextProps.location, this.props.location)) {
            console.log("componentWillReceiveProps  " + nextProps.location.query.settype)
            this.init(nextProps.location.query.settype);
            this.doUpdate(nextProps);
        }
    }

    doUpdate = (props) => {
        const { location } = props;
        let card = location.query;
        // console.log("doUpdate  " + card.settype);
        let param = {
            settype: card.settype,
        }
        this.props.actions.updateParm(param);
    }

    handleClick = (e) => {
        console.log('click ', e);
        this.setState({
            current: e.key,
        });
    }

    changeFlowId = (d1, d2) => {
        console.log(d1, d2);
        const { data, formId } = this.state;
        data["flowid"] = d1;
        data["flowidObj"] = d2;
        data.flowid = d1;
        this.setState({ data })
        WeaTools.callApi(`/govern/interfaces/governAction.jsp?action=getFields`, 'POST', { flowid: data.flowid, formId }).then(({ flowFields, modeFields, detailFlowFields, detailModeFields }) => {
            let options = [<Option value=""></Option>];
            modeFields.map((d) => {
                if (d.id) {
                    options.push(<Option value={d.id}>{d.labelname}</Option>);
                }
            });
            let detailOptions = [<Option value=""></Option>];
            detailModeFields.map((d) => {
                if (d.id) {
                    detailOptions.push(<Option value={d.id}>{d.labelname}</Option>);
                }
            });
            this.setState({ flowFields, modeFields, options: options, detailOptions: detailOptions, detailFlowFields, detailModeFields })
        });
    }

    settingSave = () => {
        const { settype } = this.props.location.query;
        const { flowidFields } = this.state;
        const { formidFields } = this.state;
        const { data } = this.state;
        let setName = data.setName;
        let enable = data.enable;
        let flowid = data.flowid;
        let topic = data.topic;
        WeaTools.callApi(`/govern/interfaces/governAction.jsp?action=saveSetting`, 'POST', { settype, setName,topic, enable, flowid, flowidFields, formidFields }).then(({api_status,api_errormsg }) => {
            if (api_status == true) {
                console.log("api_status " + api_status);
                message.success("保存成功！")
            } else {
                message.error("保存失败！"+ api_errormsg);
            }
           
        });
    }

    onEnableChange = (value) => {
        let data = this.state.data;
        data.enable = value;
        this.setState({ data: data });
    }

    changeSettingName = (value) => {
        let data = this.state.data;
        console.log("changeSettingName " + value);
        data.setName = value;
        this.setState({ data: data });
    }

    changeSettingTopic = (value) => {
        let data = this.state.data;
        console.log("changeSettingTopic " + value);
        data.topic = value;
        this.setState({ data: data });
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
                                    <Form.Item label="触发名称">
                                        <WeaInput onChange={(v) => { this.changeSettingName(v) }} value={data.setName} id="setName" fieldName="setName" name="setName" viewAttr="3" />
                                    </Form.Item>
                                </Col>
                            </Row>
                            <Row gutter={16}>
                                <Col xl={{ span: 6, offset: 2 }} lg={{ span: 8 }} md={{ span: 12 }} sm={24}>
                                    <Form.Item label="对应表单">
                                        <WeaInput onChange={(v) => { this.changeSearchData("zh", v) }} value={data.tableName} disabled="disabled" id="tableName" fieldName="tableName" name="tableName" viewAttr="3" />
                                    </Form.Item>
                                </Col>
                            </Row>
                            <Row gutter={16}>
                                <Col xl={{ span: 6, offset: 2 }} lg={{ span: 8 }} md={{ span: 12 }} sm={24}>
                                    <Form.Item label="对应流程">
                                        <WeaBrowser
                                            ismult={false}//单选多选
                                            url="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp"
                                            valueData={data.flowidObj}
                                            onChange={(d1, d2) => { this.changeFlowId(d1, d2) }}
                                        />
                                    </Form.Item>
                                </Col>
                            </Row>
                            <Row gutter={16}>
                                <Col xl={{ span: 6, offset: 2 }} lg={{ span: 8 }} md={{ span: 12 }} sm={24}>
                                    <Form.Item label="流程标题">                                                                
                                    <WeaInput  onChange={(v) => { this.changeSettingTopic(v) }} value={data.topic} id="topic" fieldName="topic" name="topic" addonAfter={ <span title="提示：可输入动态参数为 &#10;1.输入“$UserId$”表示当前操作者 &#10;2.输入“$DepartmentId$”表示当前操作者部门 &#10;3.输入“$date$”表示当前日期 &#10;4.输入“$id$”表示数据ID &#10;5.输入“$字段名称$”带出模块字段"  id="remind">                                       
                                        <img src="/images/remind_wev8.png" align="absMiddle"/>
                                    </span>   }  />                                                                                
                                    </Form.Item>
                                </Col>
                            </Row>
                            <Row gutter={16}>
                                <Col xl={{ span: 6, offset: 2 }} lg={{ span: 8 }} md={{ span: 12 }} sm={24}>
                                    <Form.Item label="是否启用">
                                        <Select value={data.enable} style={{ width: 120 }} onChange={this.onEnableChange.bind(this)}>
                                            <Option value={"0"}></Option>
                                            <Option value={"1"}>是</Option>
                                            <Option value={"2"}>否</Option>
                                        </Select>
                                    </Form.Item>
                                </Col>
                            </Row>
                        </Form>
                    </Card>

                    <Card title="字段设置" bordered={false}>
                        <div>
                            <Table
                                columns={this.getColumns()}
                                dataSource={this.state.flowFields}
                                pagination={false}
                            />
                        </div>
                    </Card>
                    {/* {this.getDetails()} */}
                    <Card title="明细1" bordered={false}>
                        <div>
                            <Table
                                columns={this.getDetailColumns()}
                                dataSource={this.state.detailFlowFields}
                                pagination={false}
                            />
                        </div>
                    </Card>
                </WeaDBTop>
            </div>
        )
    }
    getDetails = () => {
      
    }
    getColumns = () => {
        return [{
            title: '被触发流程字段',
            dataIndex: 'flowFIeld',
            key: 'flowFIeld',
            width: '20%',
            render: (text, record) => {
                return (
                    <span>{record.labelname}</span>
                );
            },
        },
        {
            title: '模块字段',
            dataIndex: 'formField',
            key: 'formField',
            width: '20%',
            render: (text, record) => {
                return (
                    <Select value={record.indexFiled} onChange={this.onFieldChange.bind(this, record)} style={{ width: 120 }}>
                        {this.state.options}
                    </Select>
                );
            },
        }
        ]
    }


    getDetailColumns = () => {
        return [{
            title: '被触发流程明细字段',
            dataIndex: 'detailflowFIeld',
            key: 'detailflowFIeld',
            width: '20%',
            render: (text, record) => {
                return (
                    <span>{record.labelname}</span>
                );
            },
        },
        {
            title: '模块明细字段',
            dataIndex: 'detailformField',
            key: 'detailformField',
            width: '20%',
            render: (text, record) => {
                return (
                    <Select value={record.indexFiled} onChange={this.onFieldChange.bind(this, record)} style={{ width: 120 }}>
                        {this.state.detailOptions}
                    </Select>
                );
            },
        }
        ]
    }

    onFieldChange = (record, value) => {
        console.log("onFieldChange " + value);
        console.log("detailtable " + record.modedetailtable);
        record.indexFiled = value;
        jQuery("field" + record.id).attr("value", value);
        const { flowidFields } = this.state;
        const { formidFields } = this.state;
        let modeValue = value + "|" + (record.modedetailtable ||"");
        console.log("modeValue " + modeValue);
        flowidFields.push(record.id);
        formidFields.push(modeValue);
        this.setState({ flowidFields });
        this.setState({ formidFields });
    }
}

const mapStateToProps = (state, props) => {
    const { govern = {} } = state;
    return {
        settype: govern.settype || "0",
    }
}
const mapDispatchToProps = (dispatch) => {
    return {
        actions: bindActionCreators(Actions, dispatch)
    }
}
export default connect(mapStateToProps, mapDispatchToProps)(Setting);