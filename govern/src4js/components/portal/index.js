import React from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';

import { Row, Col, Card, Tooltip } from 'antd';

import * as Actions from '../../actions/govern';

import WeaDBTop from '../../plugin/wea-DB-top';

import './style/index.css'

import PortalPage from './portal'

class Portal extends React.Component {

    componentDidMount() {
        this.init();
    }

    init = () => {
        const { actions } = this.props;
        actions.initPortal();
    }


    render() {
        return (
            <div>
                <PortalPage {...this.props} />
            </div >
        )
    }
}

const mapStateToProps = (state, props) => {
    const { govern = {} } = state;
    return {
        categorys: govern.categorys || [],
        countMap: govern.countMap || {},
        portalLink: govern.portalLink,
    }
}
const mapDispatchToProps = (dispatch) => {
    return {
        actions: bindActionCreators(Actions, dispatch)
    }
}
export default connect(mapStateToProps, mapDispatchToProps)(Portal);