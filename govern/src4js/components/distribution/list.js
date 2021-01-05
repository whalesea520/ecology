import { Table, Tabs, Icon, Divider, Steps, Menu, Input, Form, Button, Row, Col, DatePicker, Modal, message } from 'antd';

const Step = Steps.Step;
const ButtonGroup = Button.Group;
const TabPane = Tabs.TabPane;
const FormItem = Form.Item;

import WeaSearchGroup from '../../plugin/wea-search-group';
import WeaTab from '../../plugin/wea-tab';
import WeaDateGroup from '../../plugin/wea-date-group';
import WeaInput from '../../plugin/wea-input';
import WeaBrowser from '../../plugin/wea-browser';
import WeaTools from '../../plugin/wea-tools';

class List extends React.Component {

    constructor(props) {
        super(props);
        this.state = {
            searchData: { zh: "", title: "", nbr: "", nbrObj: [], fwbm: "", fwbmObj: [], startdateselect: "0", enddateselect: "0" },
            showSearchAd: false,
            status: 0,
        }
    }

    changeTab = (key) => {
        const { pagesize } = this.props
        this.setState({ status: key })
        const { searchData } = this.state;
        this.props.actions.getAssignTasks({ current: 1, pagesize, status: key, ...searchData });
    }

    getTabList = () => {
        const { assigngroup = [] } = this.props;
        return assigngroup.map(d => d.key && <TabPane tab={d.objname + "(" + d.count + ")"} key={d.key}></TabPane>)
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

    render() {
        const { taskDate, total, current, pagesize } = this.props;
        const showSearchAd = this.state.showSearchAd;
        const { status } = this.state;
        return (
            <div>
                <Tabs
                    status={status}
                    onChange={this.changeTab}
                >
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
                <Table
                    columns={this.getColumns()}
                    expandedRowRender={this.getExpande}
                    dataSource={taskDate}
                    className="table"
                    rowClassName={this.getRowClass}
                    pagination={{
                        current: current,
                        pageSizeOptions: ['5', '10', '20', '30', '40', '50', '100'],
                        total: total,
                        defaultPageSize: pagesize,
                        showSizeChanger: true,
                        showQuickJumper: true,
                        showTotal: (total) => {
                            return ` 共 ${total} 行 `;
                        },
                        onShowSizeChange: (current, pageSize) => { this.changePageSize(current, pageSize) }
                    }}
                    onChange={this.nextDatas}
                />
            </div>
        )
    }

    getRowClass = (record, index) => {
        const taskDetail = record.taskDetail || [];
        if (taskDetail.length == 0)
            return "hideSub"
        else
            return "showSub"
    }

    reSet = () => {
        this.setState({ searchData: { zh: "", title: "", nbr: "", nbrObj: [], fwbm: "", fwbmObj: [], startdateselect: "0", enddateselect: "0" } })
    }
    /**
     * 搜索
     */
    onSearch = () => {
        const { pagesize } = this.props
        const { searchData, status } = this.state;
        this.setState({ showSearchAd: false })
        this.props.actions.getAssignTasks({ current: 1, pagesize, status: status, ...searchData });
    }
    /**
     * 跳页
     */
    nextDatas = (pagination, filters, sorter) => {
        let current = pagination.current
        const { pagesize, } = this.props
        const { searchData, status } = this.state;
        this.props.actions.getAssignTasks({ current, pagesize, status: status, ...searchData });
    }
    /**
     * 修改每页数量
     */
    changePageSize = (current, pageSize) => {
        const { searchData, status } = this.state;
        this.props.actions.getAssignTasks({ current, pagesize: pageSize, status: status, ...searchData });
    }

    /**
     * 切换高级搜索显示
     */
    showSearch = (bool) => {
        const { actions } = this.props;
        const { searchData } = this.state;
        this.setState({ showSearchAd: bool })
    }

    openProjectView = (text, id) => {
        WeaTools.onUrl("ProjectView" + id, text, this.props.projectLink + "&billid=" + id)
    }

    openTaskView = (text, id) => {
        WeaTools.onUrl("TasktView" + id, text, this.props.taskLink + "&billid=" + id)
    }
    /**
     * 加载列表列
     */
    getColumns = () => {
        const columns = [{
            title:  this.props.titles["governoName"],
            dataIndex: 'title',
            key: 'title',
            width: 100,
            render: (text, record, index) => {
                return (
                    <a onClick={() => { this.openProjectView(text, record.project) }}>{text}</a>
                )
            }
        },{
            title: this.props.titles["supervisionCode"],
            dataIndex: 'zh',
            key: 'zh',
            width: 100,
        },  {
            title:  this.props.titles["remark"],
            dataIndex: 'task',
            key: 'task',
            width: 100,
            render: (text, record, index) => {
                return (
                    <div className="detail" dangerouslySetInnerHTML={{ __html: text }}></div>
                )
            }
        }, 
         {
            title: this.props.titles["stataus"],
            dataIndex: 'statausStr',
            key: 'statausStr',
            width: 40,
        }, 
         {
            title: this.props.titles["responsib"],
            dataIndex: 'responsib',
            key: 'responsib',
            width: 60,
        }, 
        {
            title:  this.props.titles["startDate"],
            dataIndex: 'stime',
            key: 'stime',
            width: 40,
        }, {
            title:  this.props.titles["endDate"],
            dataIndex: 'endtime',
            key: 'endtime',
            width: 40,
        }, 
        // {
        //     title:  this.props.titles["unit"],
        //     dataIndex: 'unit',
        //     key: 'unit',
        //     width: 60,
        // }, 
        //{
        //     title:  this.props.titles["presenter"],
        //     dataIndex: 'transactor',
        //     key: 'transactor',
        //     width: 60,
        //     render: (text, record, index) => {
        //         return (
        //             <a onClick={() => this.openhrm(record.userId)}>{text}</a>
        //         )
        //     }
        // },
         {
            title: '办理方式',
            dataIndex: 'options',
            key: 'options',
            width: 100,
            render: (text, record) => (
                <span>
                    <ButtonGroup>
                        {/*{this.props.buttons["6"] == "1" && <Button size="small" type="primary" disabled={record.status == "4"||record.status == "5" } target="_blank" rel="noopener noreferrer" onClick={() => { this.reminderProject("6", "5", record.key) }} >{this.props.btnames["6"]}</Button>}*/}
                        {(record.showAssign && record.status != "4" && record.status != "5") && <Button size="small" type="primary" onClick={this.finishRootTask.bind(this, record)}>完结</Button>}
                        <Button size="small" type="primary" disabled={!record.showBtn||record.status == "4"||record.status == "5"|| record.xfflag } onClick={this.distributionAll.bind(this, record)}>批量下发</Button>
                        {(record.showAssign && record.status != "4" && record.status != "5") && <Button size="small" type="primary" onClick={this.cancelRootTask.bind(this, record)}>取消</Button>}
                        {/*<Button size="small" type="primary" disabled= {record.isfilePreview} onClick={this.filePreview.bind(this, record)}>文件预览</Button>*/}
                    </ButtonGroup>
                </span>
            ),
        }];
        return columns;
    }

    distributionAll = (record) => {
        Modal.confirm({
            title: '请确认',
            content: <div><span>是否要批量下发督办项目所有子任务</span></div>,
            onOk: () => {
                WeaTools.callApi(`/govern/interfaces/governAction.jsp?action=distributionAll`, 'POST', { id: record.key }).then(({ flowFields, modeFields }) => {
                    message.info('所属任务及子任务已经下发');
                    const { pagesize } = this.props
                    const { searchData, status } = this.state;
                    this.setState({ showSearchAd: false })
                    this.props.actions.getAssignTasks({ current: 1, pagesize, status: status, ...searchData });
                });
            },
            onCancel() {
            },
        });
    }

    distribution = (record) => {
        Modal.confirm({
            title: '请确认',
            content: <div><span>是否要下发该任务</span></div>,
            onOk: () => {
                WeaTools.callApi(`/govern/interfaces/governAction.jsp?action=distribution`, 'POST', { id: record.key }).then(({ flowFields, modeFields }) => {
                    message.info('所属任务已经下发');
                    const { pagesize } = this.props
                    const { searchData, status } = this.state;
                    this.setState({ showSearchAd: false })
                    this.props.actions.getAssignTasks({ current: 1, pagesize, status: status, ...searchData });
                });
            },
            onCancel() {
            },
        });
    }

    finishRootTask = (record) => {
        Modal.confirm({
            title: '请确认',
            content: <div><span>执行当前操作会完结当前任务及其所有子任务，确认关闭？</span></div>,
            onOk: () => {
                WeaTools.callApi(`/govern/interfaces/governAction.jsp?action=finishTask`, 'POST', { id: record.key }).then(({ msg }) => {
                    message.info(msg);
                    const { pagesize } = this.props
                    const { searchData, status } = this.state;
                    this.setState({ showSearchAd: false })
                    this.props.actions.getAssignTasks({ current: 1, pagesize, status: status, ...searchData });
                });
            },
            onCancel() {
            },
        });
    }
    cancelRootTask = (record) => {
        Modal.confirm({
            title: '请确认',
            content: <div><span>执行当前操作会废弃当前任务及其所有子任务，确认关闭？</span></div>,
            onOk: () => {
                WeaTools.callApi(`/govern/interfaces/governAction.jsp?action=cancelTask`, 'POST', { id: record.key }).then(({ msg }) => {
                    message.info(msg);
                    const { pagesize } = this.props
                    const { searchData, status } = this.state;
                    this.setState({ showSearchAd: false })
                    this.props.actions.getAssignTasks({ current: 1, pagesize, status: status, ...searchData });
                });
            },
            onCancel() {
            },
        });
    }

    finishTask = (record) => {
        Modal.confirm({
            title: '请确认',
            content: <div><span>该任务已完成，确认关闭？</span></div>,
            onOk: () => {
                WeaTools.callApi(`/govern/interfaces/governAction.jsp?action=finishTask`, 'POST', { id: record.key }).then(({ msg }) => {
                    message.info(msg);
                    const { pagesize } = this.props
                    const { searchData, status } = this.state;
                    this.setState({ showSearchAd: false })
                    this.props.actions.getAssignTasks({ current: 1, pagesize, status: status, ...searchData });
                });
            },
            onCancel() {
            },
        });
    }
    filePreview = (record) => {
        // WeaTools.onUrl("distribution","文档预览","/docs/docs/DocDsp.jsp?id=" + record.docId)
       window.open("/docs/docs/DocDsp.jsp?id=" + record.docId)
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

        /*items.push({
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
        });*/

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
    * 催办项目流程
    */
    reminderProject = (settype, index, key) => {
        const { actions } = this.props;
        console.log("催办流程key---------------------------", settype, index, key);
        this.props.actions.reminderProject({ settype, index, key });
    }

    openView = (record) => {
        console.log("record", record);
        let text = record.title;
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
        // if (hasSplit) {
        //     url = record.splitUrl0 + splitId;
        // }
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
    /**
     * 解析扩展内容
     */
    getExpande = (record) => {
        const taskDetail = record.taskDetail || [];
        if (taskDetail.length == 0)
            return
        const columns = [
            // {
            //     title: '阶段', dataIndex: 'state', key: 'state', width: 50, render: (text, record, index) => {
            //         return (
            //             <a onClick={() => { this.openTaskView(text, record.key) }}>{(record.status == "4" ? "（已取消）" : "") + text}</a>
            //         )
            //     }
            // },
            {
                title: this.props.titles["taskName"], dataIndex: 'title', key: 'title', width: 75, render: (text, record, index) => {
                    return (
                        <a onClick={() => { this.openTaskView(text, record.key) }}>{text}</a>
                    )
                }
            },
            { title: this.props.titles["remark"], dataIndex: 'content', key: 'content', width: 75 ,
            render: (text, record, index) => {
                    return (
                        <div className = "detail" dangerouslySetInnerHTML={{ __html: text }}></div>
                    )
                }
            },
            { title: this.props.titles["startDate"], dataIndex: 'sdate', key: 'sdate', width: 40 },
            { title: this.props.titles["endDate"], dataIndex: 'edate', key: 'edate', width: 40 },
            { title: this.props.titles["Processing"], dataIndex: 'statusStr', key: 'statsuStr', width: 40 },
            { title: this.props.titles["sponsor"], dataIndex: 'sponsor', key: 'sponsor', width: 60,
                render: (text, record, index) => {
                    return (
                        <a onClick={() => this.openhrm(record.zb)}>{text}</a>
                            )
                 }
             },
            { title: this.props.titles["coordinator"], dataIndex: 'coordinator', key: 'coordinator', width: 60 ,
                render: (text, record, index) => {
                        let items = [];
                        var this_ = this;
                        let datas =  record.xb.split(","); 
                        var i=0;           
                        datas.map(function (name) {
                            console.log("name   " + name);
                            items.push(<a onClick={() => {this_.openhrm(name)}}>{record.coordinator.split(",")[i]}</a>);
                            items.push(" ");
                            i++;
                        })   
                        console.log("items         "+items );
                        return (
                            items
                        )
                 }    
            },
            {
                title: '办理方式',
                dataIndex: 'options',
                key: 'options',
                width: 100,
                render: (text, record) => (
                    <span>
                        <ButtonGroup>
                            {/*催办按钮的可点击条件:任务不是超期.废弃状态或者完成状态,任务的责任人是本人*/}
                            {this.props.buttons["6"] == "1" && <Button size="small" type="primary" disabled={!record.showAssign ||record.status != "2"  } target="_blank" rel="noopener noreferrer" onClick={() => { this.reminderProject("6", "5", record.key) }} >{this.props.btnames["6"]}</Button>}
                            {record.showBtn && <Button size="small" type="primary" disabled={record.status == "1" || record.status == "4" || record.status == "5"} onClick={() => { this.openView(record) }}>分解&nbsp;&nbsp;</Button>}
                            {(record.taskDetail || []).length > 0 && record.showBtn &&
                                <Button size="small" type="primary" disabled={ !record.showAssign || record.xfflag} onClick={this.distributionAll.bind(this, record)}>批量下发</Button>}
                            {(record.taskDetail || []).length == 0 &&
                            <Button size="small" type="primary" disabled={record.status != "1" || !record.showAssign} onClick={this.distribution.bind(this, record)}>{record.status == "1" ? "下发" : "已发"}</Button>}
                            {/*<Button size="small" type="primary" onClick={this.distribution.bind(this, record)}>{record.status == "1" ? "下发" : "已发"}</Button>}*/}
                            {/*完成按钮的显示条件:任务不是废弃状态或者完成状态,任务的责任人是本人*/}
                            {(record.showAssign && record.status != "4" && record.status != "5") && <Button size="small" type="primary" onClick={this.finishTask.bind(this, record)}>完结</Button>}
                            <Button size="small" type="primary" disabled= {record.isfilePreview} onClick={this.filePreview.bind(this, record)}>文件预览</Button>
                        </ButtonGroup>
                    </span>
                ),
            }
        ];

        return (
            <Table
                className="distable"
                columns={columns}
                dataSource={taskDetail}
                pagination={false}
                rowClassName={this.getRowClass}
                expandedRowRender={this.getExpande}
            />
        );
    }

}
export default List