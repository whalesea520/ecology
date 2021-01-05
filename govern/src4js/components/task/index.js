import React from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';

import DBList from './list'
import * as Actions from '../../actions/govern';
import WeaDBTop from '../../plugin/wea-DB-top';

class Task extends React.Component {

    componentDidMount() {
        this.init();
    }

    init = () => {
        const { actions } = this.props;
        const { dealtype } = this.props;
        // console.log("init  dealtype  " + dealtype)
        actions.getTaskStatusGroup({dealtype: dealtype});       
        actions.getMyTask({ current: 1, pagesize: 10, dealtype: dealtype });
        actions.buttonShow({dealtype:dealtype});     
        actions.getTableTitle({type: "task"});     
    }

    handleClick = (e) => {
        console.log('click ', e);
        this.setState({
            current: e.key,
        });
    }

    render() {
        let { searchData, actions } = this.props;
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
        taskDate: govern.taskDate,
        total: govern.total,
        current: govern.current ? govern.current : 1,
        pagesize: govern.pagesize ? govern.pagesize : 10,
        dealtype: props.location.query.dealtype ? props.location.query.dealtype : 0,
        projectLink: govern.projectLink || "",
        taskLink: govern.taskLink || "",
        taskStatusList: govern.taskStatusList || [],
        allCount: govern.allCount ? govern.allCount : 0,
        buttons: govern.buttons ? govern.buttons : {},
        btnames:govern.btnames ? govern.btnames : {},
        titles:govern.titles ? govern.titles : {},
    }
}
const mapDispatchToProps = (dispatch) => {
    return {
        actions: bindActionCreators(Actions, dispatch)
    }
}
export default connect(mapStateToProps, mapDispatchToProps)(Task);