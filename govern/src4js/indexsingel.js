/*require('es5-shim');
require('es5-shim/es5-sham');
require('console-polyfill');

import 'babel-polyfill'
import 'fetch-polyfill'
import 'fetch-ie8'
require('es6-promise').polyfill();
import 'es6-promise'*/
import React from 'react'
import ReactDOM from 'react-dom'
import { combineReducers, applyMiddleware, actionCreator } from 'redux';
import { Provider, connect } from 'react-redux'

//import Provider from 'react-redux/lib/components/Provider'
//import connect from 'react-redux/lib/components/connect'

import thunkMiddleware from 'redux-thunk/lib/index'
//const ReactRouter = require('react-router');
//let { Router, Route, Link, useRouterHistory, IndexRedirect  } = ReactRouter;
import Router from 'react-router/lib/Router'
import Route from 'react-router/lib/Route'
import Link from 'react-router/lib/Link'
import useRouterHistory from 'react-router/lib/useRouterHistory'
import IndexRedirect from 'react-router/lib/IndexRedirect'

import { createHistory, useBasename, createHashHistory } from 'history'
//browserHistory
import { Breadcrumb, Menu, Icon } from 'antd';

import 'antd/dist/antd.css';  // or 'antd/dist/antd.less'

import configureStore from './store/configureStore'

import Formmode from './index';

const store = configureStore(
    Formmode.reducer,
    applyMiddleware(//无需返回对象，只需返回一个带dispatch的函数
        thunkMiddleware
    )
);

store.subscribe(() => {
    //console.log("redux,state监听：",store.getState());
});
const browserHistory = useRouterHistory(createHashHistory)({
    queryKey: '_key',
    basename: '/'
});

//browserHistory.basename="/cloudstore/system";
function requireCredentials(nextState, replace, next) {
    // console.log("nextstate",nextState);
    const query = nextState.location.query;
    // console.log("querytitle",query.title);
    nextState.routes[2].breadcrumbName = query.id + "  " + query.name;
    next();//跳转函数
}

class Root extends React.Component {
    render() {
        return (
            <Provider store={store}>
                <Router history={browserHistory}>
                    <Route path="/">
                        {Formmode.router}
                    </Route>
                </Router>
            </Provider>
        );
    }
};
//          <Route name="appApply" breadcrumbName=":kao" path=":id/show" component={AppDetail} onEnter={requireCredentials}/>

window.Mode = {};
window.Mode.store = store;

/*let bindActionCreator = (actionCreator, dispatch) => {
    return (...args) => dispatch(actionCreator(...args));
}

window.formmodeDoAction = (obj, param1, param2, param3, callback) => {
    try {
        const action = bindActionCreator(obj, store.dispatch);
        action(param1, param2, param3, callback);
    } catch (e) {
        console.log(e);
    }
}*/
ReactDOM.render(<Root />, document.getElementById('container'));
