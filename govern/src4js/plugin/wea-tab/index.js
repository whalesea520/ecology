import React from 'react';
import { Tabs, Row, Col, Button, Menu } from 'antd';
// import Tabs from '../../_antd1.11.2/tabs'
// import Row from '../../_antd1.11.2/row'
// import Col from '../../_antd1.11.2/col'
// import Input from '../../_antd1.11.2/input'
// import Button from '../../_antd1.11.2/button'
// import Menu from '../../_antd1.11.2/menu'
import WeaInputSearch from '../wea-input-search';
import './style/index.css'
const TabPane = Tabs.TabPane;

class WeaTab extends React.Component {
  constructor(props) {
    super(props);
    this.state={
      maskDarkB: 0,
      maskDarkH: 0,
    }
    this.calc = false;
  }
  componentDidUpdate() {
    const {showSearchAd} = this.props;
    if (showSearchAd && !this.calc) {
      let h = this.getMaskDarkH();
      let b = this.getMaskDarkB();
      this.setState({maskDarkH: h, maskDarkB: b});
    }
  }
  onSearch(v) {
    if (typeof this.props.onSearch === 'function') {
      this.props.onSearch(v);
    }
  }
  onSearchChange(v) {
    if (typeof this.props.onSearchChange === 'function') {
      this.props.onSearchChange(v);
    }
  }
  onChange(key) {
    if (typeof (this.props.onChange) === 'function') {
      this.props.onChange(key);
    }
  }
  onMenuChange(o) {
    if (typeof (this.props.onChange) === 'function') {
      this.props.onChange(o.key);
    }
  }
  setShowSearchAd(bool) {
    if (typeof this.props.setShowSearchAd === 'function') {
      this.props.setShowSearchAd(bool);
    }
  }
  setShowSearchDrop(bool) {
    if (typeof this.props.setShowSearchDrop === 'function') {
      this.props.setShowSearchDrop(bool);
    }
  }
  getKey(obj) {
    const { keyParams } = this.props;
    if (!keyParams) {
      return '0';
    }
    if (!obj) return '';
    let theKey = '';
    keyParams.forEach(name => {
      theKey += obj[name] + '_';
    });
    if (theKey && theKey !== '') {
      theKey = theKey.substring(0, theKey.length - 1);
    }
    return theKey;
  }
  render() {
    const { datas, counts, keyParam, buttons, selectedKey,
      countParam, showSearchAd, buttonsAd, searchsAd,
      searchType, searchsBaseValue, hasDropMenu, dropIcon,
      buttonsDrop, showSearchDrop, searchsDrop, onlyShowRight, type = 'line', onEdit } = this.props;
    const {maskDarkH, maskDarkB} = this.state;
    // let keyParam = keyParams[0];
    // console.log("searchs:",searchs);
    // console.log("counts:",counts);
    // console.log("keyParam:",keyParam);
    // console.log("buttons:",buttons);
    // let obj = {}
    // datas.map(d=>{
    //   if(keyParam == selectedKey) obj = objectAssign({},d)
    // });
    // console.log("datas:",datas);
    // console.log("selectedKey:",selectedKey);
    const tabType = type.indexOf('editable') > -1 ? 'editable-card' : type;
    const tabClassName = type === 'editable-inline' ? 'wea-tab-edit' : '';
    const isIE8 = window.navigator.appVersion.indexOf('MSIE 8.0') >= 0;
    // const isIE9 = window.navigator.appVersion.indexOf('MSIE 9.0') >= 0;
    const searchBase = `${searchType}`.indexOf('base') >= 0;
    const searchAdvanced = `${searchType}`.indexOf('advanced') >= 0;
    const searchDrop = `${searchType}`.indexOf('drop') >= 0;

    let nowSelectedKey = selectedKey || selectedKey === 0 ? selectedKey.toString() : '';
    if (hasDropMenu && datas) {
      datas.forEach(data => {
        const dataKey = (data[keyParam] || data[keyParam] === 0) ? data[keyParam].toString() : '';
        const dropMenu = data.dropMenu;
        if (dropMenu) {
          if (dataKey === nowSelectedKey) {
            nowSelectedKey = [dataKey, `item_${dataKey}`];
          }
          dropMenu.forEach(d => {
            if (d.requestid === nowSelectedKey) {
              nowSelectedKey = [dataKey, d.requestid];
            }
          });
        }
      });
    }
    let leftDom = '';
    if (!onlyShowRight) {
      if (hasDropMenu) {
        leftDom = (
          <Menu mode='horizontal'
            selectedKeys = {nowSelectedKey}
            onClick={this.onMenuChange.bind(this)}
          >
            {
              datas && datas.map(data => {
                const dataKey = (data[keyParam] || data[keyParam] === 0)
                  ? data[keyParam].toString() : '';
                const countKey = data[countParam];
                const showCount = counts && data.showcount;
                const tab = showCount ? (<span>
                  {data.title + (showCount ? ' (' : '')}
                  {showCount ?
                    <span style={data.color ? { color: data.color } : {}}>
                    {counts[countKey] || '0'}</span> : ''}
                  {showCount ? ')' : ''}
                </span>) : data.title;
                const dropMenu = data.dropMenu;
                if (dropMenu) {
                  return (
                  <Menu.SubMenu title={tab} key={dataKey}
                    onTitleClick={this.onMenuChange.bind(this)}
                  >
                    <Menu.Item style={{ display: 'none' }} key={`item_${dataKey}`}></Menu.Item>
                    {
                      dropMenu.map(d => {
                        return <Menu.Item key={d.requestid}>{d.requestname}</Menu.Item>;
                      })
                    }
                  </Menu.SubMenu>);
                } else {
                  return <Menu.Item key={dataKey}>{tab}</Menu.Item>;
                }
              })
            }
          </Menu>
        );
      } else {
        leftDom = (
          <Tabs
            { ...this.props }
            className={tabClassName}
            type={tabType}
            defaultActiveKey={nowSelectedKey} activeKey={nowSelectedKey}
            onChange={this.onChange.bind(this)}
            onEdit={(targetKey, action) => {
              typeof onEdit === 'function' && onEdit(targetKey, action);
            }}
          >
            {
              datas && datas.map(data => {
                const dataKey = (data[keyParam] || data[keyParam] === 0)
                  ? data[keyParam].toString() : '';
                const countKey = data[countParam];
                const showCount = counts && data.showcount;
                const tab = showCount ? (<span>
                  {data.title + (showCount ? ' (' : '')}
                  {showCount ? <span style={data.color ? { color: data.color } : {}}>
                    {counts[countKey] || '0'}</span> : ''}
                  {showCount ? ')' : ''}
                </span>) : data.title;
                return (
                  <TabPane tab={tab} className={tabClassName
                    ? `${tabClassName}-pane${data.editable ? '' : '-nodel'}` : ''}
                    title={data.titleText || data.title} key={dataKey}
                  >{data.com || ''}</TabPane>
                );
              })
            }
          </Tabs>
        );
      }
    }

    return (
      <div className='wea-tab'>
        <Row>
          <Col xs={isIE8 ? 15 : 9} sm={9} md={11} lg={15}>
            {leftDom}
          </Col>
          <Col xs={isIE8 ? 9 : 15} sm={15} md={12} lg={9} style={{ textAlign: 'right' }}>
            <div className='wea-search-tab'>
              {
                buttons && buttons.map((data, index) => {
                  return (
                    <span key={index} style={{ marginLeft: 15 }}>{data}</span>
                  );
                })
              }
              {searchBase &&
                <WeaInputSearch value={searchsBaseValue}
                  onSearch={this.onSearch.bind(this)}
                  onSearchChange={this.onSearchChange.bind(this)}
                />
              }
              {searchAdvanced &&
                <Button type='ghost' className='wea-advanced-search'
                  onClick={this.setShowSearchAd.bind(this, true)}
                >高级搜索</Button>
              }
              {searchDrop && <span style={{ marginLeft: 15 }}>{dropIcon}</span>}
            </div>
          </Col>
        </Row>
        <div className='wea-search-container' ref="containerWrapper"
          style={{ display: showSearchAd ? 'block' : 'none' }}
        >
          <Button type='ghost' className='wea-advanced-search'
            onClick={this.setShowSearchAd.bind(this, false)}
          >高级搜索</Button>
          <div className='wea-advanced-searchsAd' >
            {searchsAd}
          </div>
          <div className='wea-search-buttons'>
            <div style={{ textAlign: 'center' }}>
            {
              buttonsAd && buttonsAd.map((data, index) => {
                return (
                  <span key={index} style={{ marginLeft: 15 }}>{data}</span>
                );
              })
            }
            </div>
          </div>
        </div>
        <div className='mask-dark' style={{ display: showSearchAd ? 'block' : 'none', height: maskDarkH, bottom: maskDarkB}}></div>
        <div className='mask-wrapper' style={{ display: showSearchAd ? 'block' : 'none' }}
          onClick={() => this.props.hideSearchAd && this.props.hideSearchAd()} />
        <div className='wea-search-container'
          style={{ display: showSearchDrop ? 'block' : 'none' }}
        >
          <span className='wea-Drop-search' onClick={this.setShowSearchDrop.bind(this, false)}>
            {dropIcon}
          </span>
          <div className='wea-advanced-searchsAd' >
            {searchsDrop}
          </div>
          <div className='wea-search-buttons'>
            <div style={{ textAlign: 'center' }}>
              {
                buttonsDrop && buttonsDrop.map((data, index) => {
                  return (
                    <span key={index} style={{ marginLeft: 15 }}>{data}</span>
                  );
                })
              }
            </div>
          </div>
        </div>
      </div>
    );
  }
  getMaskDarkH() {
    let v = 0;
    if (this.refs.containerWrapper) {
      const dom = $(this.refs.containerWrapper);
      v = window.innerHeight - dom.height() - dom.offset().top - 10;
    }
    return v;
  }
  getMaskDarkB() {
    let v = 0;
    if (this.refs.containerWrapper) {
      const dom = $(this.refs.containerWrapper);
      this.calc = true;
      v = - dom.height() - this.getMaskDarkH();
    }
    return v;
  }
}

export default WeaTab;
