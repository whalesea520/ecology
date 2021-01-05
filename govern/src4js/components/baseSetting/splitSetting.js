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

class SplitSet extends React.Component {

    componentDidMount() {
        this.init();
    }
    init = () => {
        WeaTools.callApi(`/govern/interfaces/governAction.jsp?action=initSplitSet`, 'POST', {}).then(({ setName, tableName, splitModeid, ModeFieldlist1, ModeFieldlist2, fields, TriggerSourceList, splitFieldlist, triggerFields }) => {
            console.log("splitFieldlist", splitFieldlist);
            let options = [<Option value=""></Option>];
            ModeFieldlist1.map((d) => {
                if (d.id) {
                    options.push(<Option value={d.id}>{d.labelname}</Option>);
                }
            });
            let options1 = [<Option value=""></Option>];
            splitFieldlist.map((d) => {
                if (d.id) {
                    options1.push(<Option value={d.id}>{d.labelname}</Option>);
                }
            });

            this.setState({ options, options1, setName, tableName, splitModeid, ModeFieldlist1, ModeFieldlist2, fields, TriggerSourceList, triggerFields, splitFieldlist });
        });
    }
    constructor(props) {
        super(props);
        this.state = {
            options: [],
            options1: [],
            setName: "",
            tableName: "",
            splitModeid: "",
            ModeFieldlist1: [],
            ModeFieldlist2: [],
            fields: {},
            TriggerSourceList: [],
            triggerFields: {},
            splitFieldlist: []
        }
    }

    settingSave = () => {
        let { fields, setName, splitModeid, triggerFields } = this.state;
        WeaTools.callApi(`/govern/interfaces/governAction.jsp?action=saveSplitSetting`, 'POST', { fields: JSON.stringify(fields), triggerFields: JSON.stringify(triggerFields), setName, splitModeid }).then(({ }) => {
            message.success("保存成功！");
            window.location.reload();
        });
    }

    render() {
        return (
            <div>
                <WeaDBTop>
                    <Card title="基本信息" bordered={false} extra={<Button type="primary" onClick={() => { this.settingSave() }} >保存</Button>}>
                        <Form layout="vertical" hideRequiredMark>
                            <Row gutter={16}>
                                <Col xl={{ span: 6, offset: 2 }} lg={{ span: 8 }} md={{ span: 12 }} sm={24}>
                                    <Form.Item label="触发名称">
                                        <WeaInput onChange={(v) => { this.changeSettingName(v) }} value={this.state.setName} id="setName" fieldName="setName" name="setName" viewAttr="3" />
                                    </Form.Item>
                                </Col>
                            </Row>
                            <Row gutter={16}>
                                <Col xl={{ span: 6, offset: 2 }} lg={{ span: 8 }} md={{ span: 12 }} sm={24}>
                                    <Form.Item label="对应表单">
                                        <WeaInput onChange={(v) => { this.changeSearchData("zh", v) }} value={this.state.tableName} disabled="disabled" id="tableName" fieldName="tableName" name="tableName" viewAttr="3" />
                                    </Form.Item>
                                </Col>
                            </Row>
                            <Row gutter={16}>
                                <Col xl={{ span: 6, offset: 2 }} lg={{ span: 8 }} md={{ span: 12 }} sm={24}>
                                    <Form.Item label="分解模块id">
                                        <WeaInput onChange={(v) => { this.setState({ splitModeid: v }) }} value={this.state.splitModeid} id="splitModeId" fieldName="splitModeId" name="splitModeId" viewAttr="3" />
                                    </Form.Item>
                                </Col>
                            </Row>

                            <Card title="显示字段设置" bordered={false}>
                                <div>
                                    <Table
                                        columns={this.getColumns()}
                                        dataSource={this.state.ModeFieldlist2}
                                        pagination={false}
                                    />
                                </div>
                            </Card>

                            <Card title="触发字段设置" bordered={false}>
                                <div>
                                    <Table
                                        columns={this.getSplitColumns()}
                                        dataSource={this.state.TriggerSourceList}
                                        pagination={false}
                                    />
                                </div>
                            </Card>
                        </Form>
                    </Card>
                </WeaDBTop>
            </div>
        )
    }

    getSplitColumns = () => {
        return [{
            title: '任务字段',
            dataIndex: 'flowfieldid',
            key: 'flowfieldid',
            width: '20%',
            render: (text, record) => {
                return (
                    <span>{record.labelname}</span>
                );
            },
        },
        {
            title: '分解明细字段',
            dataIndex: 'formfieldid',
            key: 'formfieldid',
            width: '20%',
            render: (text, record) => {
                return (
                    <Select value={this.state.triggerFields[record.id]} onChange={this.onSplitFieldChange.bind(this, record)} style={{ width: 120 }}>
                        {this.state.options1}
                    </Select>
                );
            },
        }
        ]
    }

    getColumns = () => {
        return [{
            title: '分解模块字段',
            dataIndex: 'flowfieldid',
            key: 'flowfieldid',
            width: '20%',
            render: (text, record) => {
                return (
                    <span>{record.labelname}</span>
                );
            },
        },
        {
            title: '任务模块字段',
            dataIndex: 'formfieldid',
            key: 'formfieldid',
            width: '20%',
            render: (text, record) => {
                return (
                    <Select value={this.state.fields[record.id]} onChange={this.onFieldChange.bind(this, record)} style={{ width: 120 }}>
                        {this.state.options}
                    </Select>
                );
            },
        }
        ]
    }

    onFieldChange = (record, value) => {
        let fields = this.state.fields;
        fields[record.id] = value;
        this.setState({ fields });
    }
    onSplitFieldChange = (record, value) => {
        let triggerFields = this.state.triggerFields;
        triggerFields[record.id] = value;
        this.setState({ triggerFields });
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
export default connect(mapStateToProps, mapDispatchToProps)(SplitSet);