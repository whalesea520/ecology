import React from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { Card, Icon, Layout, Menu } from 'antd';
const { SubMenu } = Menu;
const { Content, Sider } = Layout;

import WeaDBTop from '../../plugin/wea-DB-top';
import DBList from './list'

class Test extends React.Component {

    menuOnClick = (item, key) => {
        console.log("menuKey item  " + item.key);
        if(item.key == "10"){
            jQuery("#menuIframe").attr("src" ,"/govern/spa/setting.html#/formmode/baseSet");
        }else if(item.key == "11"){
            jQuery("#menuIframe").attr("src" ,"/govern/spa/setting.html#/formmode/splitSet");
        }else{
            jQuery("#menuIframe").attr("src" ,"/govern/spa/setting.html#/formmode/setting?settype="+item.key);
            //jQuery("#menuIframe").attr("src" ,"/index.html#/formmode/setting?settype="+item.key);
        }
    }

    render() {
        let height = document.body.offsetHeight - 48;
        return (
            <WeaDBTop>
                <Layout>
                    <Layout>
                        <Sider width={200} style={{ background: '#fff' }}>
                            <Menu
                                mode="inline"
                                defaultSelectedKeys={['1']}
                                defaultOpenKeys={['sub1']}
                                style={{ height: '100%', borderRight: 0 }}
                                onClick={(item, key) => { this.menuOnClick(item, key)}}
                            >
                                <Menu.Item key="1">汇报设置</Menu.Item>
                                <Menu.Item key="2">督办设置</Menu.Item>
                                <Menu.Item key="3">会办设置</Menu.Item>
                                <Menu.Item key="4">退办设置</Menu.Item>
                                <Menu.Item key="5">升办设置</Menu.Item>
                                <Menu.Item key="6">催办设置</Menu.Item>
                                <Menu.Item key="7">延期设置</Menu.Item>
                                <Menu.Item key="8">取消设置</Menu.Item>
                                <Menu.Item key="9">变更设置</Menu.Item>
                                <Menu.Item key="11">任务分解设置</Menu.Item>
                                <Menu.Item key="10">督办基本设置</Menu.Item>
                            </Menu>
                        </Sider>    
                        <Layout style={{ padding: '24px 24px 24px', }}>
                            <Content style={{ background: '#fff', height: height, padding: 24, margin: 0, minHeight: 280 }}>
                                <iframe id="menuIframe"  src="/govern/spa/setting.html#/formmode/setting?settype=1"  style={{ border: "0px", width: "100%", height: "100%" }} />
                            </Content>
                        </Layout>
                    </Layout>
                </Layout>

            </WeaDBTop>
        )
    }
}

const mapStateToProps = (state, props) => {
    const { card } = state;
    return {
        billid: props.location.query.billid,
        formId: props.location.query.formId,
        modeId: props.location.query.modeId,
    }
}
mapDispatchToProps = (dispatch) => {
    return {
        actions: bindActionCreators({}, dispatch)
    }
}
export default connect(mapStateToProps, mapDispatchToProps)(Test);