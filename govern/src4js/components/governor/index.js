import React from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { DatePicker, Card, Table, Icon, Divider, Steps, Menu, Row, Tabs } from 'antd';

import './style/index.css'
import * as Actions from '../../actions/govern';

const Step = Steps.Step;
const SubMenu = Menu.SubMenu;
const MenuItemGroup = Menu.ItemGroup;
const TabPane = Tabs.TabPane;

import WeaDBTop from '../../plugin/wea-DB-top';
import DBList from './list'

class Governor extends React.Component {

    componentDidMount() {
        this.init();
    }

    init = () => {
        const { actions, cid } = this.props;
        actions.getCateGory();
        actions.getTableTitle({type: "project"});     
        actions.getGovernorList({ current: 1, pagesize: 5, category: cid });
    }

    render() {
        return (
            <div>
                <WeaDBTop>
                    <DBList
                        {...this.props}
                    />
                </WeaDBTop>
            </div>
        )
    }
}

const mapStateToProps = (state, props) => {
    const { govern = {} } = state;
    console.log("govern", govern);
    return {
        cid: props.location.query.cid ? props.location.query.cid : "0",
        pagesize: govern.pagesize ? govern.pagesize : 5,
        categoryList: govern.categoryList || [],
        allCount: govern.allCount ? govern.allCount : 0,
        taskList: govern.taskList || [],
        total: govern.total,
        current: govern.current ? govern.current : 1,
        flowid: govern.flowid ? govern.flowid : 0,
        titles:govern.titles ? govern.titles : {},
        projectLink: govern.projectLink || "",
        taskLink: govern.taskLink || "",
    }
}
const mapDispatchToProps = (dispatch) => {
    return {
        actions: bindActionCreators(Actions, dispatch)
    }
}
export default connect(mapStateToProps, mapDispatchToProps)(Governor);