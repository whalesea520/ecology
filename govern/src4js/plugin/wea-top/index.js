import React from 'react';
import { Row, Col, Menu, Progress, Tabs, message } from 'antd';

import './style/index.css'

const Item = Menu.Item;
const MenuItemGroup = Menu.ItemGroup;
const TabPane = Tabs.TabPane;

class WeaNewTopReq extends React.Component {
  constructor(props) {
    super(props);
    this.isMounted = false;
    this.overMouseTarget = "-100";
    this.state = {
      showDrop: false,
      percent: 85,
      end: true,
      height: 0,
    };
  }
  componentDidMount() {
    let _this = this;
    //window.overMouseTarget = "-100";
    this.isMounted = true;
    this.scrollheigth();
    jQuery(window).resize(() => {
      this.isMounted && this.scrollheigth();
    });

    /**双击关闭事件逻辑 */
    jQuery("#DB-tab .ant-tabs-nav-container").dblclick(() => {
      if (parseInt(_this.overMouseTarget) > 0 || _this.overMouseTarget) {
        _this.props.onEdit(_this.overMouseTarget, "remove");
      }
    });

    jQuery('#DB-tab .ant-tabs-nav-container').mouseover(function (event) {
      let index = jQuery(event.target).attr("data-index");
      if (index) {
        _this.overMouseTarget = index;
      } else {
        _this.overMouseTarget = "-100"
      }
    });

    jQuery("#DB-tab .ant-tabs-nav-container").unbind("mousedown").bind("contextmenu", function (e) {
      e.preventDefault();
      if (_this.overMouseTarget && _this.overMouseTarget != "-100") {
        var menu = jQuery("#menu");
        menu.css("width", '165px');
        menu.css("border", 'solid 2px #666');
        menu.css("left", e.clientX + 'px');
        menu.css("top", e.clientY + 'px');
      } else {
        jQuery("#menu").css("width", "0px");
        jQuery("#menu").css("border", 'solid 0px #666');
      }
    });

    document.onclick = function () {
      jQuery("#menu").css("width", "0px");
      jQuery("#menu").css("border", 'solid 0px #666');
    };

  }
  componentWillReceiveProps(nextProps) {
  }
  componentWillUnmount() {
    this.isMounted = false;
  }
  scrollheigth() {
    const { heightSpace } = this.props;
    const heightOther = heightSpace || 0;
    const top = jQuery('.wea-new-top-req-content').offset()
      ? (jQuery('.wea-new-top-req-content').offset().top
        ? jQuery('.wea-new-top-req-content').offset().top : 0) : 0;
    const scrollheigth = document.documentElement.clientHeight - top - heightOther;
    this.setState({ height: scrollheigth });
  }

  handleMenuClick = (e) => {
    if (typeof (this.props.onMenuClick) === 'function') {
      this.props.onMenuClick(e);
    }
  }

  handleTabChange = (activeKey) => {
    if (typeof (this.props.onTabChange) === 'function') {
      this.props.onTabChange(activeKey);
    }
  }

  handleTabEdit = (targetKey, action) => {
    if (typeof (this.props.onEdit) === 'function') {
      this.props.onEdit(targetKey, action);
    }
  }

  render() {
    const { showDrop, percent, height, end } = this.state;
    const { children, MenuList = [], panes = [], activeKey } = this.props;
    return (
      <div className='wea-new-top-req-wapper'>
        <ul id="menu">
          <li>
            <a
              style={{ backgroundImage: "url(/wui/theme/ecology8/skins/default/contextmenu/CM_icon7_wev8.png)" }}
              onClick={() => { this.props.onEdit(this.overMouseTarget, "refresh"); }}
            >
              刷新</a>
          </li>
          <li>
            <a
              id="closeLi"
              style={{ backgroundImage: "url(/wui/theme/ecology8/skins/default/contextmenu/CM_icon13_wev8.png)" }}
              onClick={() => { this.props.onEdit(this.overMouseTarget, "remove"); }}
            >
              关闭
            </a>
          </li>
          <li>
            <a
              id="openLi"
              style={{ backgroundImage: "url(/wui/theme/ecology8/skins/default/contextmenu/CM_icon14_wev8.png)" }}
              onClick={() => { if (this.overMouseTarget != '-1000') { this.props.onEdit(this.overMouseTarget, "opennew"); } else { message.warning('不允许在新标签页打开门户页面'); } }}
            >
              在新的标签页打开
          </a>
          </li>
        </ul>
        <Row className='wea-new-top-req'>
          {MenuList && <Row className="DB-menu">

            <div className="logo" />
            <Menu
              onClick={this.handleMenuClick}
              theme="dark"
              mode="horizontal"
              style={{ lineHeight: '64px' }}
            >
              {MenuList}
            </Menu>
          </Row>}

          <Row className="DB-tab" id="DB-tab">
            <Tabs
              hideAdd
              onChange={this.handleTabChange}
              activeKey={activeKey}
              type="editable-card"
              onEdit={this.handleTabEdit}
            >
              {panes.map(pane => <TabPane data-index={pane.key} tab={<div data-index={pane.key}>{pane.title}</div>} key={pane.key} closable={pane.closable}>{pane.content}</TabPane>)}
            </Tabs>
          </Row>
        </Row>
        {
          children && <div className={panes.length == 0 ? ' wea-new-top-req-content-none-content' : 'wea-new-top-req-content'} style={{ height }}>
            {children}
          </div>
        }
      </div>
    );
  }

}

export default WeaNewTopReq;
