import React from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';

import './style/index.css'

import DBList from './list'
import * as Actions from '../../actions/govern';
import WeaDBTop from '../../plugin/wea-DB-top';
import * as Util from '../../util/DbUtil'

class Distrib extends React.Component {

    componentDidMount() {
        this.init();
    }

    init = () => {
        const { actions } = this.props;
        actions.getAssignTaskStatus({});
        actions.getAssignTasks({ current: 1, pagesize: 5 });
        actions.getTableTitle({type: "distrib"});     
        actions.buttonShow();     
    }

    handleClick = (e) => {
        console.log('click ', e);
        this.setState({
            current: e.key,
        });
    }

    render() {
        return (
            <div>
                <WeaDBTop>
                    <DBList
                        actions={this.props.actions}
                        taskDate={this.props.taskDate}
                        total={this.props.total}
                        current={this.props.current}
                        pagesize={this.props.pagesize}
                        projectLink={this.props.projectLink}
                        taskLink={this.props.taskLink}
                        assigngroup={this.props.assigngroup}
                        buttons={this.props.buttons}
                        btnames={this.props.btnames}
                        titles={this.props.titles}
                    />
                </WeaDBTop>
            </div>

            
        )
    }
}

const mapStateToProps = (state, props) => {
    const { govern = {} } = state;
    console.log("govern", govern);
    console.log("assigngroup ", govern.assigngroup);
    return {
        taskDate: govern.taskDate,
        total: govern.total,
        current: govern.current ? govern.current : 1,
        pagesize: govern.pagesize ? govern.pagesize : 5,
        projectLink: govern.projectLink || "",
        taskLink: govern.taskLink || "",
        assigngroup: govern.assigngroup || [],
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
export default connect(mapStateToProps, mapDispatchToProps)(Distrib);