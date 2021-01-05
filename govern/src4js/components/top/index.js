import React from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { Icon, Menu, Popconfirm, Spin, Modal } from 'antd';
import WeaTools from '../../plugin/wea-tools';
import WeaTop from '../../plugin/wea-top';

import './style/index.css'

const SubMenu = Menu.SubMenu;
const MenuItemGroup = Menu.ItemGroup;
const confirm = Modal.confirm;

//import RwList from './rwlist'
//import DbList from './dblist'
//import Portal from './portal'

import * as Actions from '../../actions/govern';

class Top extends React.Component {

    constructor(props) {
        super(props);
        this.state = {
            panes: [{ title: '督办门户', content: '', key: '-1000', closable: false }],
            activeKey: '-1000',
        }
    }

    componentDidMount() {
        try {
            let _this = this;
            jQuery.ajax({
                url: "/govern/interfaces/governAction.jsp?action=checkUser",
                dataType: 'json',
                type: 'POST',
                async: false,
                success: function (res) {
                    _this.init();
                },
                error: function (e) {
                    window.location = '/login/Logout.jsp';
                }
            });
        } catch (e) {
            console.log(e);
            window.location = '/login/Logout.jsp';
        }
        window.onUrl = this.onUrl;
        window.closeGovernMenu = this.closeGovernMenu;
        window.handleTabEdit = this.handleTabEdit;
    }

    /*componentDidUpdate(){
        console.log("componentDidUpdate")
    }

    componentWillReceiveProps(nextProps){
        console.log("componentWillReceiveProps")
    }

    shouldComponentUpdate(nextProps, nextState) {
        console.log("shouldComponentUpdate")
    }*/

    init = () => {
        const { actions } = this.props;
        actions.menuBase();
    }

    onUrl = (key, title, src) => {
        let panes = this.state.panes;
        let pane = { title, src, content: '', key };
        if (!WeaTools.contains(panes, pane)) {
            panes.push(pane);
        }
        this.setState({ panes: panes, activeKey: key });
    }

    closeGovernMenu = () => {
        jQuery("#menu").css("width", "0px");
        jQuery("#menu").css("border", 'solid 0px #666');
    }
    handleMenuClick = (e) => {
        const { Menus } = this.props;
        let MenuIndex = e.key;
        if (MenuIndex == "-1000") {
            let panes = this.state.panes;
            let pane = { title: '督办门户', content: '', key: '-1000', closable: false };
            if (!WeaTools.contains(panes, pane)) {
                panes.unshift(pane);
            }
            this.setState({  panes: panes,activeKey: MenuIndex });
        } else if (MenuIndex == "loginout") {
            confirm({
                title: '确定要退出系统吗?',
                content: '',
                onOk() {
                    window.location = '/login/Logout.jsp';
                },
                onCancel() { },
            });
        } else {
            let menuObj;
            if (MenuIndex.indexOf("-") > 0) {
                menuObj = Menus[parseInt(MenuIndex.split("-")[0])].submenu[parseInt(MenuIndex.split("-")[1])];
            } else {
                menuObj = Menus[parseInt(MenuIndex)]
            }
            let panes = this.state.panes;

            let pane = { title: menuObj.title, src: menuObj.src, content: '', key: menuObj.key };
            if (!WeaTools.contains(panes, pane)) {
                panes.push(pane);
            }
            this.setState({ panes: panes, activeKey: menuObj.key });
        }

    }

    handleTabChange = (activeKey) => {
        this.setState({ activeKey });
    }

    handleTabEdit = (targetKey, action) => {
        if (action == "remove") {
            let activeKey = this.state.activeKey;
            let lastIndex;
            this.state.panes.forEach((pane, i) => {
                if (pane.key === targetKey) {
                    lastIndex = i - 1;
                }
            });
            if (lastIndex < 0)
                lastIndex = 0;
            const panes = this.state.panes.filter(pane => pane.key !== targetKey);
            if (lastIndex >= 0 && activeKey === targetKey) {
                activeKey = panes[lastIndex] ? panes[lastIndex].key : "-1000";
            }
            this.setState({ panes, activeKey });
        } else if (action == "refresh") {
            if (document.getElementById('iframe' + targetKey)) {
                document.getElementById('iframe' + targetKey).contentWindow.location.reload(true);
                this.setState({ activeKey: targetKey });
            }
        } else if (action == "opennew") {
            let src = "";
            this.state.panes.forEach((pane, i) => {
                if (pane.key === targetKey) {
                    src = pane.src;
                }
            });
            window.open(src);
            this.setState({ activeKey: targetKey });
        }
    }

    render() {
        const { panes, activeKey } = this.state;
        let MenuList = this.getMenu();       
        return (
            <div className="topDiv">
                {this.props.spinning && <Spin tip="正在初始化数据...请稍候..." spinning={!!this.props.spinning || false}>
                <WeaTop
                    MenuList={MenuList}
                    onMenuClick={this.handleMenuClick}
                    panes={panes}
                    onTabChange={this.handleTabChange}
                    activeKey={activeKey}
                    onEdit={this.handleTabEdit}
                >
                    {this.getIframe()}
                </WeaTop>
                </Spin>}
                {!this.props.spinning && <WeaTop
                    MenuList={MenuList}
                    onMenuClick={this.handleMenuClick}
                    panes={panes}
                    onTabChange={this.handleTabChange}
                    activeKey={activeKey}
                    onEdit={this.handleTabEdit}
                >
                    {this.getIframe()}
                </WeaTop>
                }
            </div>
        )
    }

    getIframe = () => {
        const { panes, activeKey } = this.state;

        let iframes = [];
        /*panes.map((pane) => {
            iframes.push(<iframe src="" style={{ display: pane.key == activeKey ? "" : "none", border: "0px", width: "100%", height: "1500px" }} >
                {pane.key == "1000" && <RwList />}
                {pane.key == "1" && <DbList />}
            </iframe>)
        });*/
        for (let i = 0; i < panes.length; i++) {
            let pane = panes[i];
            if (pane.key == "-1000") {
                /*iframes.push(<div style={{ display: pane.key == activeKey ? "" : "none", border: "0px", width: "100%", height: "100%" }} >
                    <Portal categorys={this.props.categorys} countMap={this.props.countMap} />
                </div>)*/
                iframes.push(<iframe id="iframe-1000" src="/govern/spa/index1.html#/formmode/portal" frameborder="0" style={{ display: pane.key == activeKey ? "" : "none", border: 0, width: "100%", height: "100%" }} >
                </iframe>)
                /*iframes.push(<iframe id="iframe-1000" src="/index.html#/formmode/portal" frameborder="0" style={{ display: pane.key == activeKey ? "" : "none", border: 0, width: "100%", height: "100%" }} >
                </iframe>)*/
            } else {
                iframes.push(<iframe id={"iframe" + pane.key} src={pane.src} frameborder="0" style={{ display: pane.key == activeKey ? "" : "none", border: 0, width: "100%", height: "100%" }} >
                </iframe>)
            }
        }

        return iframes;
    }

    getMenu = () => {
        let Menus = this.props.Menus;
        let menulist = [];
        menulist.push(<SubMenu title={<span className="DB-menu-title"><div style={{width:"90px",height:"64px"}}></div><h2 style={{ color: "#108ee9" }}></h2></span>}>
        </SubMenu>);

        menulist.push(<Menu.Item key="-1000" ><span className="nav_ico"><center><Icon type="home" style={{ fontSize: 30}} /></center></span><h3 className="nav_ico nav_txt">督办门户</h3></Menu.Item>);
        for (let i = 0; i < Menus.length; i++) {
            menulist.push(<Menu.Item key={-(i + 1)} className="menu_line"></Menu.Item>)
            let menuObj = Menus[i];
            let subm = menuObj.submenu || [];
            let sublist = [];
            for (let j = 0; j < subm.length; j++) {
                let subObj = subm[j];
                sublist.push(<Menu.Item key={i + "-" + j}>{subObj.title}</Menu.Item>)
            }
            if (sublist.length > 0) {
                menulist.push(<SubMenu key={i} title={<span className="nav_ico_1"><center><Icon type={menuObj.icon} style={{ fontSize: 30 }} /></center><h3 className="nav_ico nav_txt">{menuObj.title}</h3></span>}>{sublist}</SubMenu>)
            } else { 
                menulist.push(<Menu.Item key={i} ><span><Icon type={menuObj.icon}/></span> {menuObj.title}</Menu.Item>)
            }
        }
        let loginUser = this.props.loginUser;
        //console.log("loginUser  " + loginUser);       
        menulist.push(<Menu.Item style={{ position: "absolute", right: "150px", "font-size": "15px", color: "#FFF" }}><Icon type="user" />&nbsp;{loginUser}</Menu.Item>);
        menulist.push(<Menu.Item key="loginout" title="退出登录" style={{ position: "absolute", right: "60px", "font-size": "15px", color: "#FFF" }}><Icon type="logout" />&nbsp;退出</Menu.Item>);
        return menulist;
    }
}

const mapStateToProps = (state, props) => {
    const { govern = {} } = state;
    //console.log("govern", govern);
    return {
        Menus: govern.Menus || [],
        loginUser: govern.loginUser,
        spinning: govern.spinning
    }
}
const mapDispatchToProps = (dispatch) => {
    return {
        actions: bindActionCreators(Actions, dispatch)
    }
}
export default connect(mapStateToProps, mapDispatchToProps)(Top);