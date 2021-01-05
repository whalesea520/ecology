import { DatePicker, Card, Table, Icon, Divider, Steps, Menu, Row, Col, Tabs, Form, Select, Button, Dropdown, Modal, message } from 'antd';

const Step = Steps.Step;
const FormItem = Form.Item;
const TabPane = Tabs.TabPane;
const ButtonGroup = Button.Group;

import WeaSearchGroup from '../../plugin/wea-search-group';
import WeaTab from '../../plugin/wea-tab';
import WeaDateGroup from '../../plugin/wea-date-group';
import WeaInput from '../../plugin/wea-input';
import WeaBrowser from '../../plugin/wea-browser';
import WeaTools from '../../plugin/wea-tools';
import './style/index.css'

class List extends React.Component {

    constructor(props) {
        super(props);
        this.state = {
            searchData: { zh: "", title: "", nbr: "", nbrObj: [], fwbm: "", fwbmObj: [], startdateselect: "0", enddateselect: "0" },
            showSearchAd: false,
            visible: false,
            dbrData: { settype: "", index: "", key: "", dbr: "", dbrObj: [] },
            status: "",

        }
    }

    showModal = () => {
        this.setState({
            visible: true,
        });
    }

    handleOk = (e) => {
        const { dbrData } = this.state;
        console.log("dbrData.dbr " + dbrData.dbr);
        if (dbrData.dbr == "") {
            message.warning('请选择处理人');
            rerurn;
        }

        this.setState({
            visible: false,
        });

        this.props.actions.reportMyTask({ settype: dbrData.settype, index: dbrData.index, key: dbrData.key, dbr: dbrData.dbr });
        this.setState({ dbrData: { settype: "", index: "", key: "", dbr: "", dbrObj: [] } });
    }

    handleCancel = (e) => {
        this.setState({
            visible: false,
        });
        this.setState({ dbrData: { settype: "", index: "", key: "", dbr: "", dbrObj: [] } });
    }

    changeBrowserMult = (id, d1, d2) => {

        console.log("id, d1, d2 " + id, d1, d2);
        const { dbrData } = this.state;
        dbrData[id] = d1;
        dbrData[id + "Obj"] = d2;
        this.setState({ dbrData });
    }

    changeTab = (key) => {
        const { pagesize, dealtype } = this.props
        this.setState({ status: key })
        const { searchData } = this.state;
        // console.log("changeTab " + dealtype)
        this.props.actions.getMyTask({ current: 1, pagesize, dealtype, status: key, ...searchData });
    }

    getTabList = () => {
        const { taskStatusList } = this.props;
        return taskStatusList.map(d => d.key && <TabPane tab={d.objname + "(" + d.count + ")"} key={d.key}></TabPane>)
    }

    render() {

        const { taskDate, total, current, pagesize, allCount } = this.props;
        const { showSearchAd, status } = this.state;
        const { dbrData } = this.state;
        return (
            <div>
                <Tabs
                    status={status}
                    onChange={this.changeTab}
                >
                    {/* <TabPane tab={`全部(${allCount})`} key="-1"></TabPane> */}
                    {this.getTabList()}
                </Tabs>
                <WeaTab
                    hasDropMenu={true}
                    searchType={['advanced']}
                    searchsAd={<Form layout="horizontal"> {this.getSearchs()}</Form >}
                    buttonsAd={[
                        <Button type="primary" onClick={this.onSearch}>搜索</Button>,
                        <Button type="ghost" onClick={this.reSet} >重置</Button>,
                        <Button type="ghost" onClick={() => { this.showSearch(false) }} >取消</Button>
                    ]}
                    setShowSearchAd={bool => { this.showSearch(bool) }}
                    showSearchAd={showSearchAd}
                />
                <Table className="table"
                    columns={this.getColumns()}
                    dataSource={taskDate}
                    // bordered ={true}
                    pagination={{
                        current: current,
                        pageSizeOptions: ['10', '20', '30', '40', '50', '100'],
                        total: total,
                        defaultPageSize: pagesize,
                        showSizeChanger: true,
                        showQuickJumper: true,
                        showTotal: (total) => {
                            return ` 共 ${total} 行 `;
                        },
                        onShowSizeChange: (current, pageSize) => { this.changePageSize(current, pageSize) }
                    }}
                    onChange={this.nextDatas} />
                <div>
                    <Modal
                        title="请选择处理人"
                        visible={this.state.visible}
                        onOk={this.handleOk}
                        onCancel={this.handleCancel}
                        okText="确认"
                        cancelText="取消">
                        <p>
                            处理人 <WeaBrowser ismult={true}//多选 
                                url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp"
                                valueData={dbrData.dbrObj}
                                onChange={(d1, d2) => { this.changeBrowserMult("dbr", d1, d2) }} />
                        </p>
                    </Modal>
                </div>
            </div>
        )
    }

    reSet = () => {
        this.setState({ searchData: { zh: "", title: "", nbr: "", nbrObj: [], fwbm: "", fwbmObj: [], startdateselect: "0", enddateselect: "0" } })
    }

    /**
     * 搜索
     */
    onSearch = () => {
        const { pagesize, dealtype } = this.props
        const { searchData, status } = this.state;
        this.setState({ showSearchAd: false })
        this.props.actions.getMyTask({ current: 1, pagesize, dealtype, status: status, ...searchData });
    }

    /**
    * 切换高级搜索显示
    */
    showSearch = (bool) => {
        const { searchData } = this.state;
        this.setState({ showSearchAd: bool })
    }

    /**
     * 跳页
     */
    nextDatas = (pagination, filters, sorter) => {
        let current = pagination.current
        const { pagesize, dealtype } = this.props
        const { searchData, status } = this.state;
        this.props.actions.getMyTask({ current, pagesize, dealtype, status, ...searchData });
    }

    /**
     * 修改每页数量
     */
    changePageSize = (current, pageSize) => {
        const { searchData, status } = this.state;
        const { dealtype } = this.props;
        // console.log("dealtype,status " + dealtype,status);
        this.props.actions.getMyTask({ current, pagesize: pageSize, dealtype, status, ...searchData });
    }

    changeBrowser = (id, d1, d2) => {
        const { searchData } = this.state;
        searchData[id] = d1;
        searchData[id + "Obj"] = d2;
        this.setState({ searchData })
    }

    /**
     * 字段value变动
     */
    changeSearchData = (key, value) => {
        const { searchData } = this.state;
        searchData[key] = value;
        this.setState({ searchData })
    }

    /**
     * 加载高级搜索查询条件
     */
    getSearchs = () => {
        const _this = this;
        const searchData = this.state.searchData;
        let items = new Array();
        items.push({
            com: (<FormItem
                label={this.props.titles["supervisionCode"]} 
                labelCol={{ span: 6 }}
                wrapperCol={{ span: 12 }}>
                <WeaInput onChange={(v) => { this.changeSearchData("zh", v) }} value={searchData.zh} id="zh" fieldName="zh" name="zh" viewAttr="3" />
            </FormItem>),
            colSpan: 1
        });

        items.push({
            com: (<FormItem
                label={this.props.titles["taskName"]} 
                labelCol={{ span: 6 }}
                wrapperCol={{ span: 12 }}>
                <WeaInput onChange={(v) => { this.changeSearchData("title", v) }} value={searchData.title} id="title" />
            </FormItem>),
            colSpan: 1
        });

        items.push({
            com: (<FormItem
                label={this.props.titles["presenter"]} 
                labelCol={{ span: 6 }}
                wrapperCol={{ span: 12 }}>
                <WeaBrowser
                    onChange={this.changeBrowser}
                    ismult={false}//单选多选
                    url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
                    valueData={searchData.nbrObj}
                    onChange={(d1, d2) => { this.changeBrowser("nbr", d1, d2) }}
                />
            </FormItem>),
            colSpan: 1
        });

        items.push({
            com: (<FormItem
                label={this.props.titles["unit"]} 
                labelCol={{ span: 6 }}
                wrapperCol={{ span: 12 }}>
                <WeaBrowser
                    onChange={this.changeBrowser}
                    ismult={false}//单选多选
                    url="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
                    valueData={searchData.fwbmObj}
                    onChange={(d1, d2) => { this.changeBrowser("fwbm", d1, d2) }}
                />
            </FormItem>),
            colSpan: 1
        });

        items.push({
            com: (<FormItem
                label={this.props.titles["startDate"]} 
                labelCol={{ span: 6 }}
                wrapperCol={{ span: 17 }}>
                <WeaDateGroup
                    value={searchData.startdateselect}
                    datas={[
                        { value: '0', selected: searchData.startdateselect == "0", name: '全部' },
                        { value: '1', selected: searchData.startdateselect == "1", name: '今天' },
                        { value: '2', selected: searchData.startdateselect == "2", name: '本周' },
                        { value: '3', selected: searchData.startdateselect == "3", name: '本月' },
                        { value: '4', selected: searchData.startdateselect == "4", name: '本季' },
                        { value: '5', selected: searchData.startdateselect == "5", name: '本年' },
                        { value: '6', selected: searchData.startdateselect == "6", name: '指定日期范围' }
                    ]} domkey={["startdateselect", "startdatefrom", "startdateto"]} onChange={(parmArray) => {
                        const { actions } = _this.props;
                        const { searchData } = _this.state;
                        searchData["startdateselect"] = parmArray[0];
                        searchData["startdatefrom"] = parmArray[1];
                        searchData["startdateto"] = parmArray[2];
                        this.setState({ searchData })
                    }} />
            </FormItem>), //创建日期    createdateselect    ==6范围   createdatefrom---createdateto
            colSpan: 1
        });

        items.push({
            com: (<FormItem
                label={this.props.titles["endDate"]} 
                labelCol={{ span: 6 }}
                wrapperCol={{ span: 17 }}>
                <WeaDateGroup
                    value={searchData.enddateselect}
                    datas={[
                        { value: '0', selected: true, name: '全部' },
                        { value: '1', selected: false, name: '今天' },
                        { value: '2', selected: false, name: '本周' },
                        { value: '3', selected: false, name: '本月' },
                        { value: '4', selected: false, name: '本季' },
                        { value: '5', selected: false, name: '本年' },
                        { value: '6', selected: false, name: '指定日期范围' }
                    ]} domkey={["enddateselect", "enddatefrom", "enddateto"]} onChange={(parmArray) => {
                        const { actions } = _this.props;
                        const { searchData } = _this.state;
                        searchData["enddateselect"] = parmArray[0];
                        searchData["enddatefrom"] = parmArray[1];
                        searchData["enddateto"] = parmArray[2];
                        this.setState({ searchData })
                    }} />
            </FormItem>), //创建日期    createdateselect    ==6范围   createdatefrom---createdateto
            colSpan: 1
        });
        return [
            (<WeaSearchGroup col={2} needTigger={true} title="" showGroup={true} items={items} />),
        ]
    }

    openProjectView = (text, id) => {
        WeaTools.onUrl("ProjectView" + id, text, this.props.projectLink + "&billid=" + id)
    }

    openTaskView = (text, id) => {
        WeaTools.onUrl("TaskView" + id, text, this.props.taskLink + "billid=" + id)
    }

    reportMyTask = (settype, index, key) => {
        // console.log("settype  " + settype);
        this.props.actions.reportMyTask({ settype, index, key });
    }

    governMyTask = (settype, index, key) => {
        const { dbrData } = this.state;
        // console.log("settype  " + settype);
        dbrData.key = key;
        dbrData.index = index;
        dbrData.settype = settype;

        this.setState({ dbrData })
        this.showModal();
    }

    /**
     * 任务变更
     */
    governorPostpone = (settype, index, key) => {
        const { actions } = this.props;
        console.log("任务延期key-----------------", key, "index ----------------", index);
        this.props.actions.governorPostpone({ index, key, settype });
    }

    openhrm(tempuserid) {
        this.openFullWindowForXtable("/hrm/HrmTab.jsp?_fromURL=HrmResource&id=" + tempuserid);
    }

    openFullWindowForXtable(url) {
        var redirectUrl = url;
        var width = screen.width;
        var height = screen.height;
        //if (height == 768 ) height -= 75 ;
        //if (height == 600 ) height -= 60 ;
        var szFeatures = "top=100,";
        szFeatures += "left=400,";
        szFeatures += "width=" + width / 2 + ",";
        szFeatures += "height=" + height / 2 + ",";
        szFeatures += "directories=no,";
        szFeatures += "status=yes,";
        szFeatures += "menubar=no,";
        szFeatures += "scrollbars=yes,";
        szFeatures += "resizable=yes"; //channelmode
        window.open(redirectUrl, "", szFeatures);
    }

    openView = (record) => {
        console.log("record", record);
        let text = record.taskName;
        let id = record.key;
        let hasSplit = record.hasSplit;
        let splitId = record.splitId;

        /*let url = "/formmode/view/AddFormMode.jsp?customTreeDataId=null&mainid=0&modeId=666&formId=-903&type=1&field16981=" + id + "&field19062=" + record.goals + "&field19063=" + record.project +
            "&field19064=" + record.nwr + "&field19065=" + record.nwdw + "&field19061=" + record.dbzh;
        if (hasSplit) {
            url = "/formmode/view/AddFormMode.jsp?customTreeDataId=null&mainid=0&modeId=666&formId=-903&type=0&billid=" + splitId;
        }*/

        /*let url = "/formmode/view/AddFormMode.jsp?customTreeDataId=null&mainid=0&modeId=8&formId=-19&type=1&field6377=" + id + "&field6379=" + record.goals + "&field6380=" + record.project +
            "&field6381=" + record.nwr + "&field6382=" + record.nwdw + "&field6378=" + record.dbzh;
        if (hasSplit) {
            url = "/formmode/view/AddFormMode.jsp?customTreeDataId=null&mainid=0&modeId=8&formId=-19&type=0&billid=" + splitId;
        }*/

        let url = record.splitUrl;
        if (hasSplit) {
            url = record.splitUrl0 + splitId;
        }
        //中山小榄镇政府
        /*let url = "/formmode/view/AddFormMode.jsp?customTreeDataId=null&mainid=0&modeId=11&formId=-43&type=1&field7096=" + id + "&field7098=" + record.goals + "&field7099=" + record.project +
            "&field7100=" + record.nwr + "&field7101=" + record.nwdw + "&field7097=" + record.dbzh;
        if (hasSplit) {
            url = "/formmode/view/AddFormMode.jsp?customTreeDataId=null&mainid=0&modeId=11&formId=-43&type=0&billid=" + splitId;
        }*/


        //太平人寿测开发环境
        /*let url = "/formmode/view/AddFormMode.jsp?customTreeDataId=null&mainid=0&modeId=8&formId=-31&type=1&field7855=" + id + "&field7857=" + record.goals + "&field7858=" + record.project +
            "&field7859=" + record.nwr + "&field7860=" + record.nwdw + "&field7856=" + record.dbzh;
        if (hasSplit) {
            url = "/formmode/view/AddFormMode.jsp?customTreeDataId=null&mainid=0&modeId=8&formId=-31&type=0&billid=" + splitId;
        }*/

        //太平人寿测试环境
        /*let url = "/formmode/view/AddFormMode.jsp?customTreeDataId=null&mainid=0&modeId=8&formId=-29&type=1&field7614=" + id + "&field7616=" + record.goals + "&field7617=" + record.project +
            "&field7618=" + record.nwr + "&field7619=" + record.nwdw + "&field7615=" + record.dbzh;
        if (hasSplit) {
            url = "/formmode/view/AddFormMode.jsp?customTreeDataId=null&mainid=0&modeId=8&formId=-29&type=0&billid=" + splitId;
        }*/

        //console.log(url);
        //window.open(url);
        WeaTools.onUrl("tasksplit" + id, text + "任务分解", url);
    }


    // /**
    // * 催办项目流程
    // */
    // reminderProject = (setid, index, key) => {
    //     const { actions } = this.props;
    //     console.log("催办流程key---------------------------",setid, index, key);
    //     this.props.actions.reminderProject({ setid, index, key });
    // }


    getColumns = () => {
        return [{
            title: this.props.titles["project"],
            dataIndex: 'name',
            key: 'name',
            width: 80,
            render: (text, record, index) => {
                return (
                    <a onClick={() => this.openProjectView(text, record.project)}>{text}</a>
                )
            }
        }, {
            title: this.props.titles["taskName"],
            dataIndex: 'taskName',
            key: 'taskName',
            width: 80,
            render: (text, record, index) => {
                return (
                    <a onClick={() => this.openTaskView(text, record.key)}>{text}</a>
                )
            }
        }, {
            title: this.props.titles["taskType"],
            dataIndex: 'type',
            key: 'type',
            width: 80,
        }, {
            title: this.props.titles["Processing"],
            dataIndex: 'statu',
            key: 'statu',
            width: 80,
        }, 
        // {
        //     title: '阶段',
        //     dataIndex: 'state',
        //     key: 'state',
        //     width: 220,
        //     render: (text, record, index) => {
        //         let returnObj;
        //         if (record.subCount > 0) {
        //             let stepList = [];
        //             for (let i = 0; i < record.subCount; i++) {
        //                 stepList.push(<Step title="" />);
        //             }
        //             returnObj = <Steps size="small" current={record.currentStep}>
        //                 {stepList}
        //             </Steps>
        //         }
        //         return (
        //             <span>{returnObj}</span>
        //         )
        //     }
        // }, 
        {
            title: this.props.titles["endDate"],
            dataIndex: 'endtime',
            key: 'endtime',
            width: 80,
        }, {
            title: this.props.titles["unit"],
            dataIndex: 'unit',
            key: 'unit',
            width: 80,
        }, {
            title: this.props.titles["presenter"],
            dataIndex: 'creater',
            key: 'creater',
            width: 80,
            render: (text, record, index) => {
                return (
                    <a onClick={() => this.openhrm(record.userId)}>{text}</a>
                )
            }
        }, {
            title: '办理方式',
            dataIndex: 'options',
            key: 'options',
            width: 100,
            render: (text, record) => (
                <span>
                    <ButtonGroup>
                        {(this.props.dealtype == 0 && this.props.buttons["11"] == "1" ) && record.showBtn && (record.status != "0" && record.status != "3" && record.status != "4") && 
                         <Button size="small" type="primary"  onClick={() => { this.openView(record) }} >{this.props.btnames["11"]}</Button>}
                        {this.props.buttons["1"] == "1" && <Button size="small" type="primary" disabled={record.status == "3" || record.status == "4"} onClick={() => { this.reportMyTask("1", "0", record.key) }} >{this.props.btnames["1"]}</Button>}
                        {this.props.buttons["2"] == "1" && <Button size="small" type="primary" disabled={record.status == "3" || record.status == "4"} onClick={() => { this.governMyTask("2", "1", record.key) }} >{this.props.btnames["2"]}</Button>}
                        {/* {this.props.buttons["3"] == "1" && <Button size="small" type="primary" onClick={() => { this.governMyTask("3", "2", record.key) }} >{this.props.btnames["3"]}</Button>} */}
                        {this.props.buttons["more"]   && <Dropdown disabled={record.status == "3" || record.status == "4"}
                            overlay={<Menu>
                                <Menu.Item style={this.props.buttons["3"] == "1" ? { display: 'block' } : { display: 'none' }} >
                                    <a target="_blank" rel="noopener noreferrer" onClick={() => { this.governMyTask("3", "2", record.key) }} >{this.props.btnames["3"]}</a>
                            </Menu.Item>
                                <Menu.Item style={this.props.buttons["4"] == "1" ? { display: 'block' } : { display: 'none' }} >
                                    <a target="_blank" rel="noopener noreferrer" onClick={() => { this.governMyTask("4", "3", record.key) }} >{this.props.btnames["4"]}</a>
                            </Menu.Item>
                                <Menu.Item style={this.props.buttons["5"] == "1" ? { display: 'block' } : { display: 'none' }} >
                                    <a target="_blank" rel="noopener noreferrer" onClick={() => { this.governMyTask("5", "4", record.key) }} >{this.props.btnames["5"]}</a>
                            </Menu.Item>
                                {/* <Menu.Item style={this.props.buttons["6"]=="1"?{display:'block'}:{display:'none'}} >
                                <a target="_blank" rel="noopener noreferrer" onClick={() => { this.reminderProject("6", "5", record.key) }} >催办</a> &nbsp;
                            </Menu.Item>                            */}
                                <Menu.Item style={(this.props.dealtype == 0 && this.props.buttons["7"] == "1") ? { display: 'block' } : { display: 'none' }}>
                                    <a target="_blank" rel="noopener noreferrer" onClick={() => { this.governorPostpone("7", "0", record.key) }} >{this.props.btnames["7"]}</a>
                            </Menu.Item>
                                <Menu.Item style={(this.props.dealtype == 0 && this.props.buttons["8"] == "1") ? { display: 'block' } : { display: 'none' }}>
                                    <a target="_blank" rel="noopener noreferrer" onClick={() => { this.governorPostpone("8", "1", record.key) }} >{this.props.btnames["8"]}</a>
                            </Menu.Item>
                                <Menu.Item style={(this.props.dealtype == 0 && this.props.buttons["9"] == "1") ? { display: 'block' } : { display: 'none' }}>
                                    <a target="_blank" rel="noopener noreferrer" onClick={() => { this.governorPostpone("9", "2", record.key) }} >{this.props.btnames["9"]}</a>
                            </Menu.Item>
                                {/* <Menu.Item style={(this.props.dealtype == 0 && this.props.buttons["11"] == "1") ? { display: 'block' } : { display: 'none' }}>
                                    {record.showBtn && (record.status != "0" && record.status != "3" && record.status != "4") && <a target="_blank" onClick={() => { this.openView(record) }}>{this.props.btnames["11"]}</a>}
                                </Menu.Item> */}
                            </Menu>
                            }
                        >
                            <Button size="small" type="primary" className="ant-dropdown-link">
                                更多 <Icon type="down" />
                            </Button>
                        </Dropdown>}
                    </ButtonGroup>
                </span>
            ),
        }];
    }
}

export default List