import { Table, Tabs, Icon, Divider, Steps, Menu, Form, Button, Select, Dropdown, message } from 'antd';

const Step = Steps.Step;
const TabPane = Tabs.TabPane;
const FormItem = Form.Item;
const ButtonGroup = Button.Group;

import WeaSearchGroup from '../../plugin/wea-search-group';
import WeaTab from '../../plugin/wea-tab';
import WeaDateGroup from '../../plugin/wea-date-group';
import WeaInput from '../../plugin/wea-input';
import WeaBrowser from '../../plugin/wea-browser';
import WeaTools from '../../plugin/wea-tools';
import './style/index.css';

class List extends React.Component {

    constructor(props) {
        super(props);
        this.state = {
            searchData: { name: "", source: "", sourceObj: [], responsible: "", responsibleObj: [], leaders: "", leadersObj: [], startdateselect: "0", status: "0" },
            showSearchAd: false,
            activeKey: props.cid
        }
    }

    render() {

        const { taskList, total, current, pagesize, allCount } = this.props;
        const { showSearchAd, activeKey } = this.state;
        return (
            <div>
                <Tabs
                    activeKey={activeKey}
                    onChange={this.changeTab}
                >
                    <TabPane tab={`全部(${allCount})`} key="0"></TabPane>
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
                    buttons={[<Button type="primary" style={{ height: "29px" }} onClick={this.addProject}>新增</Button>]}
                />
                <Table className="table"
                    columns={this.getColumns()}
                    dataSource={taskList}
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

    addProject = () => {
        let flowid = this.props.flowid;
        if (parseInt(flowid) <= 0)
            message.error("立项流程未设置");
        else
            WeaTools.onUrl("newGoven", "督办立项", "/workflow/request/AddRequest.jsp?workflowid=" + flowid + "&isagent=0&beagenter=0&f_weaver_belongto_userid=")
    }
    reSet = () => {
        this.setState({ searchData: { name: "", source: "", sourceObj: [], responsible: "", responsibleObj: [], leaders: "", leadersObj: [], startdateselect: "0", status: "0" } })
    }

    changeTab = (key) => {
        const { pagesize } = this.props
        this.setState({ activeKey: key })
        const { searchData } = this.state;
        this.props.actions.getGovernorList({ current: 1, pagesize, category: key, ...searchData });
    }
    /**
     * 搜索
     */
    onSearch = () => {
        const { pagesize } = this.props
        const { searchData, activeKey } = this.state;
        this.setState({ showSearchAd: false })
        this.props.actions.getGovernorList({ current: 1, pagesize, category: activeKey, ...searchData });
    }

    /**
     * 跳页
     */
    nextDatas = (pagination, filters, sorter) => {
        let columnKey, order;
        columnKey = sorter.columnKey || "";
        order = sorter.order || "";
        console.log("sorter.columnKey  "+ sorter.columnKey);         
        let current = pagination.current;
        const { pagesize} = this.props;
        const { searchData, activeKey } = this.state;
        this.props.actions.getGovernorList({ current, pagesize,columnKey,order, category: activeKey, ...searchData }); 
    }

    /**
    * 切换高级搜索显示
    */
    showSearch = (bool) => {
        const { actions } = this.props;
        const { searchData } = this.state;
        this.setState({ showSearchAd: bool })
    }

    /**
     * 修改每页数量
     */
    changePageSize = (current, pageSize) => {
        const { searchData, activeKey } = this.state;
        this.props.actions.getGovernorList({ current, pagesize: pageSize, category: activeKey, ...searchData });
    }

    getTabList = () => {
        const { categoryList } = this.props;
        return categoryList.map(d => d.key && <TabPane tab={d.objname + "(" + d.count + ")"} key={d.key}></TabPane>)
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
    reminder = (key) => {
        const { actions } = this.props;
        console.log("催办流程key---------------------------", key);
        this.props.actions.reminderProject({ key });
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
                label={this.props.titles["governoName"]}
                labelCol={{ span: 6 }}
                wrapperCol={{ span: 12 }}>
                <WeaInput onChange={(v) => { this.changeSearchData("name", v) }} value={searchData.name} id="name" fieldName="name" name="name" viewAttr="3" />
            </FormItem>),
            colSpan: 1
        });

        /*items.push({
            com: (<FormItem
                label={this.props.titles["source"]}
                labelCol={{ span: 6 }}
                wrapperCol={{ span: 12 }}>
                <WeaBrowser
                    ismult={false}//单选多选
                    url="/systeminfo/BrowserMain.jsp?url=/interface/CommonBrowser.jsp?type=browser.dbly"
                    valueData={searchData.sourceObj}
                    onChange={(d1, d2) => { this.changeBrowser("source", d1, d2) }}
                />
            </FormItem>),
            colSpan: 1
        });*/

        items.push({
            com: (<FormItem
                label={this.props.titles["responsible"]}
                labelCol={{ span: 6 }}
                wrapperCol={{ span: 12 }}>
                <WeaBrowser
                    onChange={this.changeBrowser}
                    ismult={false}//单选多选
                    url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
                    valueData={searchData.responsibleObj}
                    onChange={(d1, d2) => { this.changeBrowser("responsible", d1, d2) }}
                />
            </FormItem>),
            colSpan: 1
        });

        /*items.push({
            com: (<FormItem
                label={this.props.titles["leaders"]}
                labelCol={{ span: 6 }}
                wrapperCol={{ span: 12 }}>
                <WeaBrowser
                    onChange={this.changeBrowser}
                    ismult={false}//单选多选
                    url="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
                    valueData={searchData.leadersObj}
                    onChange={(d1, d2) => { this.changeBrowser("leaders", d1, d2) }}
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
                label={this.props.titles["stataus"]}
                labelCol={{ span: 6 }}
                wrapperCol={{ span: 17 }}>
                <Select
                    defaultValue='0'
                    style={{ width: '32%', minWidth: 100 }}
                    disabled={false}
                    size={'default'}
                    value={searchData.status}
                    onChange={(v) => {
                        let { searchData } = this.state;
                        searchData.status = v;
                        this.setState({ searchData });
                    }}>
                    <Option key="0" value="0" >全部</Option>
                    <Option key="1" value="1" >未开始</Option>
                    <Option key="2" value="2" >进行中</Option>
                    <Option key="3" value="3" >超期</Option>
                    <Option key="4" value="4" >完成</Option>
                    <Option key="5" value="5" >废弃</Option>
                </Select>
            </FormItem>), //创建日期    createdateselect    ==6范围   createdatefrom---createdateto
            colSpan: 1
        });
        return [
            (<WeaSearchGroup col={2} needTigger={true} title="" showGroup={true} items={items} />),
        ]
    }

    openView = (text, id) => {
        WeaTools.onUrl("treeView" + id, text, "/govern/view/demoViewTree.jsp?id=" + id)
    }
    getColumns = () => {
        let s = this.props.cloumn
        console.log("this.props---------------------------",this.props)
        // console.log("this.record---------------------------",record)
        return [{
            title: this.props.titles["governoName"],
            dataIndex: 'governoName',
            key: 'governoName',
            width: 100,
            render: (text, record, index) => {
                   console.log("this.record---------------------------",record)
                let color ;
                let a_color ="";
                if(record.tflag =="1"){
                    color = "title title-yellow" ;
                    a_color = "title-a";
                }else if(record.tflag =="2"){
                    color = "title title-red" ;
                    a_color = "title-a";
                }else if(record.tflag =="3"){
                    color = "title title-green" ;
                    a_color = "title-a";
                }
                return (
                    <div className ={color}>
                        <a className ={a_color}  onClick={() => this.openProjectView(text, record.key)}>{text}</a>
                    </div>
                )
            }
        }, {
            title: this.props.titles["supervisionCode"],
            dataIndex: 'supervisionCode',
            key: 'supervisionCode',
            width: 100,
        }, {
            title: this.props.titles["category"],
            dataIndex: 'category',
            key: 'category',
            width: 100,
        }, 
        // {
        //     title: '任务来源',
        //     dataIndex: 'source',
        //     key: 'source',
        //     width: 100,
        // }, 
        {
            title: this.props.titles["goals"],
            dataIndex: 'goals',
            key: 'goals',
            width: 100,
        }, {
            title: this.props.titles["responsible"],
            dataIndex: 'responsible',
            key: 'responsible',
            width: 100,
        }, {
            title: this.props.titles["tel"],
            dataIndex: 'tel',
            key: 'tel',
            width: 100,
        },
        //  {
        //     title: '分管领导',
        //     dataIndex: 'leaders',
        //     key: 'leaders',
        //     width: 100,
        // }, 
        {
            title: this.props.titles["stataus"],
            dataIndex: 'stataus',
            key: 'stataus',
            width: 100,
            sorter: true,
            sortOrder:false,
            render: (text, record) => (
                <span>
                    <span style={{ color: text == 2 ? "#dc1414" : "#000000" }}>
                        {record.statusStr}
                    </span>
                </span>
            )
        }, {
            title: this.props.titles["startDate"],
            dataIndex: 'startDate',
            key: 'startDate',
            width: 100,
            sorter: true,
            sortOrder:false
        }, {
            title: this.props.titles["endDate"],
            dataIndex: 'endDate',
            key: 'endDate',
            width: 100,
            sorter: true,
            sortOrder:false
        },
        {
            title: '脑图',
            dataIndex: 'option',
            key: 'option',
            width: 50,
            render: (text, record) => (
             
                <span>
                    <Button size="small" type="primary" onClick={() => this.openView(record.governoName, record.key)}>脑图</Button>
                </span>
            )
        }
        ];
    }
   openProjectView = (text, id) => {
        window.top.onUrl("ProjectView" + id, text, this.props.projectLink + "&billid=" + id)
    }




}

export default List