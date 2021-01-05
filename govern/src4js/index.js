import Route from 'react-router/lib/Route';

import reducer from './reducers';
import actions from './actions';
import Top from './components/top';
import ActionSet from './components/actionSet';
import GovernorList from './components/governor';
import Distribute from './components/distribution';
import Task from './components/task';
import Setting from './components/setting';
import Portal from './components/portal';
import BaseSetting from './components/baseSetting';
import SplitSet from './components/baseSetting/splitSetting.js';
import WeaTools from './plugin/wea-tools';

require("./interface");
require('es5-shim');
require('es5-shim/es5-sham');
require('console-polyfill');
require('core-js/fn/object/assign');
require('es6-promise');
require('fetch-ie8');

if (!window.console) {
    window.console = { log: function () { } };
}
document.onclick = function () {
    try{
        WeaTools.onCloseMenu();
    }catch(e){
    }
}

const router = (
    <Route path="formmode" breadcrumbName="建模">
        <Route path="top" breadcrumbName="督办门户" component={Top} />
        <Route path="actionSet" breadcrumbName="卡片页面" component={ActionSet} />
        <Route path="governor" breadcrumbName="督办项目列表" component={GovernorList} />
        <Route path="distribution" breadcrumbName="任务下发" component={Distribute} />
        <Route path="task" breadcrumbName="任务列表" component={Task} />
        <Route path="Setting" breadcrumbName="卡片页面" component={Setting} />
        <Route path="portal" breadcrumbName="卡片页面" component={Portal} />
        <Route path="baseSet" breadcrumbName="卡片页面" component={BaseSetting} />
        <Route path="splitSet" breadcrumbName="卡片页面" component={SplitSet} />
    </Route>
);


export default {
    reducer,
    router,
    actions
}