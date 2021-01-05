import React from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { WeaTable, WeaTools, WeaTop, WeaTab, WeaSearchGroup } from 'ecCom';
import { WeaRightMenu, WeaPopoverHrm, WeaLeftRightLayout, WeaLeftTree } from 'ecCom';
import { Icon, Button, Form, Spin, Menu, Dropdown } from 'antd';
import { ModeTree, ModeTable, ModeTab, ModeLeftRightLayout } from 'mode';
const FormItem = Form.Item;
const MenuItem = Menu.Item;
import * as Actions from '../../actions/list';
import equal from 'deep-equal';
window.sb = {}
window.sb.scrollheigth = () => {
    let top = jQuery(".wea-tree-search-layout .wea-right").offset() ? (jQuery(".wea-tree-search-layout .wea-right").offset().top ? jQuery(".wea-tree-search-layout .wea-right").offset().top : 0) : 0;
    let scrollheigth = document.documentElement.clientHeight - top - 20;
    jQuery(".wea-tree-search-layout .wea-right").height(scrollheigth);
}
class Search extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            datakey: 'SDFHU_1245SDFSJDH',
            datas: [],
            columns: [],
            operates: [],
            sortParams: [],
            selectedRowKeys: [],
            loading: false,
            colSetVisible: false,
            colSetdatas: [],
            colSetKeys: [],
            count: 50,
            current: 1,
            pageSize: 10
        }
    }
    componentDidMount() {
        this.init();
    }
    componentWillReceiveProps(nextProps) {

    }
    init = () => {
        const { actions, customid } = this.props;
        actions.base({ customid });
        this.nextDatas();
    }
    nextDatas = (pagination, filters, sorter) => {
        const { actions, customid, } = this.props;
        const newState = {};
        if (pagination) newState.pagination = pagination;
        if (filters) newState.filters = filters;
        if (sorter) newState.sorter = sorter;
        this.setState({ 
            ...this.state,
            ...newState
        }, () => {
            const { pagination: { current: pageindex = 1, pageSize: pagesize = 10 } = {}, filters: filtersObj = {}, sorter: { columnKey: sortfield, field: sortfieldname, order } = {} } = this.state;
            const sorttype = order === 'ascend' ? 'asc' : 'desc';
            actions.datas({ customid, pagesize, pageindex, ...filtersObj, sortfield, sortfieldname, sorttype });
        });


    }
    querys = () => {
        return {

        }
    }
    needRefreshData = (next) => {

    }
    fetchData = (pagination, filter, sort) => {
        const { actions, customid } = this.props;
        actions.fetchListFields({});
        actions.fetchListDatas({});
    }
    handleRightMenuClick = (key) => {
        console.log(`click ${key}`);

    }
    onDropMenuClick = () => {

    }
    render() {
        console.log("this.props0", this.props)
        const { customname } = this.props;
        const { datakey, datas, fields, operates, sortParams, selectedRowKeys, loading, pagination,
            colSetVisible, colSetdatas, colSetKeys, count, current, pageSize } = this.props;
        const { searchAdvanceVisible = false, showSearchDrop = false } = this.props;
        const dropMenuDatas = [
            {
                key: 1,
                disabled: loading,
                icon: <i className='icon-search' />,
                content: '搜索'
            }
        ];
        const btns = [
            (<Button type="primary" disabled={true} onClick={() => this.dosubmit()}>提交（禁用）</Button>),
            (<Button type="glost" disabled={false} onClick={() => this.dosubmit()}>提交</Button>)
        ];
        return (
            <div>
                <WeaPopoverHrm />
                <WeaRightMenu
                    datas={[{
                        key: 1,
                        disable: false,
                        icon: <Icon type="eye-o" />,
                        content: "查看"
                    }
                    ]}
                    width={200}
                    onClick={this.handleRightMenuClick}
                >
                    <WeaTop
                        title={customname}
                        loading={loading}
                        icon={<i className='icon-portal-workflow' />}
                        iconBgcolor='#55D2D4'
                        buttons={btns}
                        buttonSpace={10}
                        showDropIcon={true}
                        dropMenuDatas={dropMenuDatas}
                        onDropMenuClick={this.onDropMenuClick}
                    >
                        <ModeLeftRightLayout
                            ref={(ref) => { this._layout = ref; }}
                            defaultShowLeft={true}
                            leftCom={this.getTree()}
                            leftWidth={25}>
                            <ModeTab
                                ref={(ref) => { this._tabs = ref; }}
                                hasDropMenu={false}
                                onlyShowRight={false}
                                selectedKey={1}
                                datas={[
                                    { id: 0, title: '全部', count: 100 },
                                    { id: 1, title: '流程', count: 50 }
                                ]}
                                keyParam="id"
                                countParam="count"
                                showcount={true}
                                searchType="base-advanced" // {icon/base/advanced/drop}
                                searchsBaseValue="123"

                                showSearchAd={searchAdvanceVisible}
                                setShowSearchAd={this.handleShowSearchAd}
                                searchAd={<Form horizontal>{this.getSearchs()}</Form>}
                                buttonsAd={[
                                    <Button type="primary" onClick={() => { }}>搜索</Button>,
                                    <Button type="ghost" onClick={() => { }}>重置</Button>,
                                    <Button type="ghost" onClick={() => { }}>取消</Button>
                                ]}


                                showSearchDrop={showSearchDrop}
                                setShowSearchDrop={() => { }}
                                dropIcon={<i className='icon-portal-workflow' />}
                                searchsDrop={<Form horizontal>{this.getSearchs()}</Form>}
                                buttonsDrop={[
                                    <Button type="primary" onClick={() => { }}>搜索</Button>,
                                    <Button type="ghost" onClick={() => { }}>重置</Button>,
                                    <Button type="ghost" onClick={() => { }}>取消</Button>
                                ]}

                                onSearch={() => { }}
                                onSearchChange={() => { }}
                                onChange={() => { }}
                            >
                            </ModeTab>
                            <ModeTable
                                columns={this.getColumns()}
                                datas={datas}
                                loading={loading}
                                ref={(ref) => { this._table = ref; }}
                                pagination={this.getPagination()}
                                heightSpace={-15}
                                onChange={this.nextDatas}
                                height={this._layout && this._tabs && this._layout.clientHeight - this._tabs.clientHeight}
                            />
                        </ModeLeftRightLayout>
                    </WeaTop>
                </WeaRightMenu>
            </div>
        )
    }
    handleShowSearchAd = (bool) => {
        const { actions } = this.props;
        actions.setSearchAdvanceVisible(bool)
    }
    getSearchs() {
        return [
            (<WeaSearchGroup needTigger={true} title="查询条件" showGroup={true} items={this.getFields()} />),
        ]
    }
    getFields(index = 0) {
        const fieldsData = [{ label: '测试', labelcol: 4, fieldcol: 8, key: 'd51f298d-5f51-4a4b-b25a-0a0e0e978c1d', domkey: ['requestname'] }]
        return fieldsData.map((field) => {
            return {
                com: (<FormItem
                    label={`${field.label}`}
                    labelCol={{ span: `${field.labelcol}` }}
                    wrapperCol={{ span: `${field.fieldcol}` }}>
                    {WeaTools.switchComponent(this.props, field.key, field.domkey, field, jQuery('.wea-advanced-searchsAd')[0])}
                </FormItem>),
                colSpan: 1
            }
        })
    }
    getTree = () => {
        const { leftTree, leftTreeCount, leftTreeCountType, actions, topTab, searchParams, selectedTreeKeys } = this.props;
        return (
            <WeaLeftTree
                datas={leftTree && leftTree.toJS()}
                counts={leftTreeCount && leftTreeCount.toJS()}
                countsType={leftTreeCountType && leftTreeCountType.toJS()}
                selectedKeys={selectedTreeKeys && selectedTreeKeys.toJS()}
                onFliterAll={() => {
                    actions.setShowSearchAd(false);
                    actions.setSelectedTreeKeys([]);
                    actions.saveOrderFields();
                    actions.initDatas({ method: "all" });
                    actions.doSearch({
                        method: 'all',
                        viewcondition: 0,
                        workflowid: "",
                        wftype: ""
                    });
                }}
                onSelect={(key, topTabCount, countsType) => {
                    actions.setShowSearchAd(false);
                    let viewc = '0';
                    actions.setSelectedTreeKeys([key]);
                    topTab.map(t => {
                        if (countsType && countsType.name && t.get('groupid') == countsType.name) viewc = t.get('viewcondition')
                    })

                    const workflowid = key.indexOf("wf_") === 0 ? key.substring(3) : '';
                    const workflowtype = key.indexOf("type_") === 0 ? key.substring(5) : '';
                    let workflowidShowName = '';
                    let workflowtypeShowName = '';
                    leftTree && leftTree.map(l => {
                        if (l.get('domid') == key) workflowtypeShowName = l.get('name');
                        l.get('childs') && l.get('childs').map(c => {
                            if (c.get('domid') == key) workflowidShowName = c.get('name');
                        })
                    })
                    const fieldsObj = {
                        workflowid: { name: 'workflowid', value: workflowid, valueSpan: workflowidShowName },
                        workflowtype: { name: 'workflowtype', value: workflowtype, valueSpan: workflowtypeShowName },
                    };

                    actions.saveOrderFields(fieldsObj);
                    actions.doSearch({
                        method: key.indexOf("type_") === 0 ? "reqeustbytype" : "reqeustbywfid",
                        wftype: workflowtype,
                        workflowid: workflowid,
                        viewcondition: viewc,
                    });
                }} />
        )
    }
    getRowSel() {
        const { selectedRowKeys } = this.props;
        return {
            selectedRowKeys: selectedRowKeys,
            onChange(sRowKeys, selectedRows) {
                this.setState({ selectedRowKeys: sRowKeys });
            },
            onSelect(record, selected, selectedRows) { },
            onSelectAll(selected, selectedRows, changeRows) { }
        };
    }
    getColumns = () => {
        const { fields, datas } = this.props;
        const columns = fields.map(column => {
            const colwidth = column.colwidth;
            return {
                title: column.fieldlabelname,
                dataIndex: column.aliasname,
                key: `field${column.fieldid}`,
                width: colwidth,
                sorter: typeof column.canorder == 'string' ? column.canorder === 'true' : column.canorder,
                filters: [{
                    text: '姓李的',
                    value: '李',
                }, {
                    text: '姓胡的',
                    value: '胡',
                }],
            }
        });
        if (datas.filter(d => d.rowButtons && d.rowButtons.length > 0).length > 0) {
            columns.push({
                title: '',
                dataIndex: 'rowButtons',
                key: 'rowButtons',
                width: 40,
                fixed: 'right',
                render: (buttons, record, index) => {
                    const newButtons = buttons.sort((a, b) => a.index - b.index).map((button, i) => {
                        const { billid, buttonname, href, hreftype, target, index } = button
                        return (
                            <MenuItem key={`mode-row-${i}-${index}`}>
                                <a href={href} target={target}>{buttonname}</a>
                            </MenuItem>
                        )
                    });
                    const menu = (
                        <Menu>
                            {newButtons}
                        </Menu>
                    )
                    return (
                        <div>
                            {newButtons.length > 0 &&
                                (<Dropdown overlay={menu}>
                                    <a className="ant-dropdown-link" href="javascript:void(0);">
                                        <Icon type="down" />
                                    </a>
                                </Dropdown>)}
                        </div>
                    )
                }
            })
        }
        //if (columns.length > 0) columns[0].fixed = 'left';
        columns.unshift({ key: 'selection-column', fixed: 'left' });
        return columns;
    }
    getPagination = () => {
        const { pagination } = this.props;
        return {
            showSizeChanger: true,
            pageSizeOptions: ['10', '20', '30', '40', '50', '100', '1000'],
            showQuickJumper: true,
            showTotal: (total, range) => {
                return `第${range[0]}-${range[1]}行，共${total}行`;
            },
            ...pagination
        }
    }
}

class MyErrorHandler extends React.Component {
    render() {
        const hasErrorMsg = this.props.error && this.props.error !== "";
        return (
            <WeaErrorPage msg={hasErrorMsg ? this.props.error : "对不起，该页面异常，请联系管理员！"} />
        );
    }
}

Search = WeaTools.tryCatch(React, MyErrorHandler, { error: "" })(Search);

Search = Form.create({
    onFieldsChange(props, fields) {

    },
    mapPropsToFields(props) {
        return props.orderFields || {};
    }
})(Search);

const mapStateToProps = (state, props) => {
    const { list = { baseset: {} } } = state;
    return {
        searchAdvanceVisible: list.searchAdvanceVisible,
        customid: props.location.query.customid,
        customname: list.baseset.customname,
        customdesc: list.baseset.customdesc,
        fields: list.fields,
        datas: list.datas,
        loading: list.loading,
        dataLoading: list.dataLoading,
        pagination: {
            current: list.current,
            total: list.total,
            pageSize: list.pageSize
        }
    }
}
mapDispatchToProps = (dispatch) => {
    return {
        actions: bindActionCreators(Actions, dispatch)
    }
}
export default connect(mapStateToProps, mapDispatchToProps)(Search);