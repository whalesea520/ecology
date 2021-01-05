import React from 'react';
import { Row, Col, Menu, Progress, Tabs } from 'antd';

import './style/index.css'

const Item = Menu.Item;
const SubMenu = Menu.SubMenu;
const MenuItemGroup = Menu.ItemGroup;
const TabPane = Tabs.TabPane;

class WeaNewTopReq extends React.Component {
  constructor(props) {
    super(props);
    this.isMounted = false;
    this.state = {
      showDrop: false,
      percent: 85,
      end: true,
      height: 0,
    };
  }
  componentDidMount() {
    this.isMounted = true;
    this.scrollheigth();
    jQuery(window).resize(() => {
      this.isMounted && this.scrollheigth();
    });
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
      <div className='wea-top-req-wapper'>
        {
          children && <div className='wea-top-req-content' style={{ height }}>
            {children}
          </div>
        }
      </div>
    );
  }

}

export default WeaNewTopReq;
