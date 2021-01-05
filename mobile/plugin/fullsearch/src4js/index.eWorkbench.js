import React from 'react';
import ReactDOM from 'react-dom';
import { Router, Route, hashHistory } from 'react-router'
import { Flex,Popup, List, Button ,Grid,Toast,Icon,Modal } from 'antd-mobile';
import { RefreshControl,ListView,Tabs, Card,TextareaItem } from 'antd-mobile';

const TabPane = Tabs.TabPane;
const alert = Modal.alert;

const isIPhone = new RegExp('\\biPhone\\b|\\biPod\\b', 'i').test(window.navigator.userAgent);
let maskProps;
let isdebug=false;

if (isIPhone) {
  // Note: the popup content will not scroll.
  maskProps = {
    onTouchStart: e => e.preventDefault(),
  };
}

let clientHight=document.documentElement.clientHeight;

//初始加载
class TabExample extends React.Component{
  constructor(props) {
    super(props);
    this.state = {
      tab: "1",
      todoNum: 0,
    };
  }
  componentWillMount() {
     if(this.props.location.query.tab&&this.props.location.query.tab!=undefined){
         this.setState({tab:this.props.location.query.tab});
     }
  }
  callback(key) {
    //console.log('onChange', key);
  }
  handleTabClick(key) {
      this.setState({tab:key});
    //console.log('onTabClick', key);
  }
  getTodoNum(value){
     if(value){
       this.setState({todoNum:value});
     }
  }
  render() {
    return (
        <div>
          <Tabs defaultActiveKey={this.state.tab} animated={false} onChange={this.callback.bind(this)} onTabClick={this.handleTabClick.bind(this)}>
            <TabPane tab={`待处理(${this.state.todoNum})`} key="1">
                <ToDoList getTodoNum={this.getTodoNum.bind(this)}/>
            </TabPane>
            <TabPane tab="已完成" key="2">
                <FinishList/>
            </TabPane>
          </Tabs>
      </div>
    );
  }
};

//已处理
class ToDoList extends React.Component {
  constructor(props) {
    super(props);
    const dataSource = new ListView.DataSource({
      rowHasChanged: (row1, row2) => row1 !== row2,
    });
    this.state = {
      dataSource: dataSource.cloneWithRows([]),
      refreshing: false,
    };
  }
  componentDidMount() {
     this.GetToDoList().then((data)=>{
        let that=this;
        that.props.getTodoNum(data.count);
        that.setState({
            dataSource: this.state.dataSource.cloneWithRows(data.list),
            refreshing: false,
          });
      })
  }
  GetToDoList = () =>{
    return new Promise((resolve,reject)=>{
      if(isdebug){
          fetch('./data-todoList.json')
              .then(function(res) {
              let data=res.json();
              return data;
          }).then(function(data) {
            resolve(data);
          }).catch(function(e) {
              console.log("error",e);
          });
      }else{
        fetch('/mobile/plugin/fullsearch/EAssistant/eWorkbenchAjax.jsp?type=getTodoList&random='+new Date().getTime(), {
          method: 'POST',
          mode: 'same-origin',
          headers: {'Content-Type': 'application/json; charset=utf-8'},
          credentials: 'include'
        })
        .then(function(res) {
            let data=res.json();
            return data;
        }).then(function(data) {
          resolve(data);
        }).catch(function(e) {
            console.log("error",e);
        });
      }
    })
  };
  onRefresh = () => {
    this.setState({ refreshing: true });
    this.GetToDoList().then((data)=>{
      let that=this;
      that.props.getTodoNum(data.count);
      that.setState({
          dataSource: this.state.dataSource.cloneWithRows(data.list),
          refreshing: false,
        });
    })
  };
  onScroll = () => {

  };
  render() {
    const separator = (sectionID, rowID) => (
      <div key={`${sectionID}-${rowID}`}
        style={{
          height: 18,
        }}
      />
    );
    const row = (rowData, sectionID, rowID) => {
      const obj = rowData;
      return (
        <div key={`${rowID}`} 
          style={{
            margin: '20px 40px',
          }}
          onClick={()=>{
            if(obj.canDo=="true"){
              hashHistory.push({
                pathname: '/Info',
                query: { id: obj.id,status:0,tab:"1" },
              })
            }
          }}
        >
            <Card>
              <Card.Header title={obj.ask} />
              <div style={{margin:"10px 0"}}></div>
              <div className="am-card-footer">
                  <div className="am-card-footer-content">{obj.createrName+' '+obj.createdate+' '+obj.createtime}</div>
                  {obj.commitTag=='1'&&<div className="flagDiv comefrom-e">小e</div>}
                  {obj.commitTag=='2'&&<div className="flagDiv comefrom-ws">微搜</div>}
              </div>
              <div style={{margin:"20px 0", borderBottom:"2px solid #f3f3f3"}}></div>
              <Card.Footer className={obj.canDo=="true"?"operateDiv":"unDoDiv"}  content={obj.checkOutName}/>
            </Card>
        </div>
      );
    };
    return (
      <ListView
        dataSource={this.state.dataSource}
        renderRow={row}
        renderSeparator={separator}
        initialListSize={10}
        pageSize={10}
        scrollRenderAheadDistance={200}
        scrollEventThrottle={20}
        onScroll={this.onScroll}
        style={{
          height: clientHight-85,
        }}
        className="toDoListDiv tapSlideDiv"
        scrollerOptions={{ scrollbars: false }}
        refreshControl={<RefreshControl
          refreshing={this.state.refreshing}
          onRefresh={this.onRefresh}
        />}
      />
    );
  }
}

let pageIndex=1;
class FinishList extends React.Component {
  constructor(props) {
    super(props);
    const dataSource = new ListView.DataSource({
      rowHasChanged: (row1, row2) => row1 !== row2,
    });
    
    this.state = {
      dataSource: dataSource.cloneWithRows([]),
      isLoading: true,
      refreshing: false,
      hasMore:false,
    };
  }
  GetFinishList = (s) =>{
    return new Promise((resolve,reject)=>{
      if(isdebug){
          fetch(`./data-finishList${s}.json`)
          .then(function(res) {
              let data=res.json();
              return data;
          }).then(function(data) {
            resolve(data);
          })
          .catch(function(e) {
              console.log("error",e);
          });
      }else{
          fetch('/mobile/plugin/fullsearch/EAssistant/eWorkbenchAjax.jsp?type=getFinishList&pageno='+s+'&timeSag=1&random='+new Date().getTime(), {
            method: 'POST',
            mode: 'same-origin',
            headers: {'Content-Type': 'application/json; charset=utf-8'},
            credentials: 'include'
          })
          .then(function(res) {
              let data=res.json();
              return data;
          }).then(function(data) {
            resolve(data);
          })
          .catch(function(e) {
              console.log("error",e);
          });


      }
    })
  };
  componentDidMount() {
    // you can scroll to the specified position
    // this.refs.lv.refs.listview.scrollTo(0, 200);
    this.GetFinishList(1).then((data)=>{
      let that=this;
      pageIndex=data.pageno;
      that.setState({
          dataSource: this.state.dataSource.cloneWithRows(data.list),
          resultMap:data,
          isLoading: false,
          hasMore:data.hasnext,
          datalist:data.list,
        });
    })
  }

  onEndReached = (event) => {
    // load new data
    // hasMore: from backend data, indicates whether it is the last page, here is false

    if (this.state.isLoading || !this.state.hasMore) {
      return;
    }

    if(event){
      this.setState({ isLoading: true });

      this.GetFinishList(++pageIndex).then((data)=>{
        let rData=[...this.state.datalist,...data.list]
        let that=this;
        that.setState({
            dataSource: this.state.dataSource.cloneWithRows(rData),
            resultMap:data,
            isLoading: false,
            hasMore:data.hasnext,
            datalist:rData,
          });
      })
    }
  }

  onRefresh = () => {
      this.setState({ refreshing: true });
      this.GetFinishList(1).then((data)=>{
        pageIndex=data.pageno;
        let that=this;
        that.setState({
            dataSource: this.state.dataSource.cloneWithRows(data.list),
            resultMap:data,
            refreshing: false,
            hasMore:data.hasnext,
            datalist:data.list,
          });
      })
  };

  render() {
   const separator = (sectionID, rowID) => (
      <div key={`${sectionID}-${rowID}`}
        style={{
          height: 18,
        }}
      />
    );
    const row = (rowData, sectionID, rowID) => {
      const obj = rowData;
      return (
        <div key={`${rowID}`}
          style={{
            margin: '20px 40px',
          }}
          onClick={()=>{
            hashHistory.push({
               pathname: '/Info',
               query: { id: obj.id,status:1,tab:"2" },
            })
          }}
        >
            <Card>
              <Card.Header title={obj.ask} />
              <div style={{margin:"10px 0"}}></div>
              <div className="am-card-footer">
                  <div className="am-card-footer-content">{obj.createrName+' '+obj.createdate+' '+obj.createtime}</div>
                  {obj.commitTag=='1'&&<div className="flagDiv comefrom-e">小e</div>}
                  {obj.commitTag=='2'&&<div className="flagDiv comefrom-ws">微搜</div>}
                  {obj.targetFlag!=''&&<div className="flagDiv">{obj.targetFlag}</div>}
              </div>
              <Card.Footer content={"结束于 "+obj.processdate+' '+obj.processtime}/>
              <div style={{margin:"20px 0px", borderBottom:"2px solid #f3f3f3"}}></div>
              <Card.Footer className='detailDiv' content={"查看详情"}  extra={<Icon type={'right'} />} />
            </Card>
        </div>
      );
    };
    return (
      <ListView
        dataSource={this.state.dataSource}
        renderFooter={() => <div style={{ padding: 30, textAlign: 'center' }}>
          {this.state.isLoading ? '加载中...' : '加载完毕'}
        </div>}
        renderRow={row}
        renderSeparator={separator}
        className="finishListDiv tapSlideDiv"
        pageSize={10}
        scrollRenderAheadDistance={500}
        scrollEventThrottle={20}
        style={{
          height: clientHight-85,
        }}
        onEndReached={this.onEndReached}
        onEndReachedThreshold={10}
        scrollerOptions={{ scrollbars: false }}
        refreshControl={<RefreshControl
          refreshing={this.state.refreshing}
          onRefresh={this.onRefresh}
        />}
      />
    );
  }
}



let InfoTopHeight=0;  
class DetailInfo extends React.Component {
    constructor(props) {  
        super(props);  
        //暴露方法给jsp调用
        window.backList=this.backList;
        this.state = {  
            tab:"1",
            id:"",  
            ask:"",
            answer:"",
            status:"",
            createdate:"",
            createtime:"",
            processdate:"",
            processtime:"",
            createrName:'',
            processName:"",
            targetFlag:"",
            commitTag:"",
            canSubmit:false,
            maxHeight:"300",
            resetHeight:false,
            init:false,
        };
    } 
    GetData = (id,status) =>{
      return new Promise((resolve,reject)=>{
        if(isdebug){
            fetch(`./data-detail${status}.json`)
            .then(function(res) {
                let data=res.json();
                return data;
            }).then(function(data) {
              resolve(data);
            })
            .catch(function(e) {
                console.log("error",e);
            });
        }else{
            fetch('/mobile/plugin/fullsearch/EAssistant/eWorkbenchAjax.jsp?type=getInfo&faqId='+id+'&status='+status+'&random='+new Date().getTime(), {
              method: 'POST',
              mode: 'same-origin',
              headers: {'Content-Type': 'application/json; charset=utf-8'},
              credentials: 'include',
            })
            .then(function(res) {
                let data=res.json();
                return data;
            }).then(function(data) {
              resolve(data);
            })
            .catch(function(e) {
                console.log("error",e);
            });
        }
      })
    }; 
    componentDidUpdate(){
       if(!this.state.resetHeight){
            if(InfoTopHeight!=0&&InfoTopHeight!=document.getElementById("InfoTop").offsetHeight){
                InfoTopHeight=document.getElementById("InfoTop").offsetHeight;
                this.setState({
                  resetHeight:true,
                });
            }
       }
    }
    componentDidMount() {
        InfoTopHeight=document.getElementById("InfoTop").offsetHeight;
        this.setState({
          tab:this.props.location.query.tab,
          id:this.props.location.query.id,
        });
        this.GetData(this.props.location.query.id,this.props.location.query.status).then((result)=>{
          if(!result.checkResut){
              Toast.info(result.msg,'1',()=>{
                  this.backList();
              });
          }else{
            let that=this;
            let data=result.obj;
            that.setState({ 
                init:true,
                ask:data.ask,
                createrName:data.createrName,
                createdate:data.createdate,
                createtime:data.createtime,
                processdate:data.processdate,
                processtime:data.processtime,
                processName:data.processName,
                answer:data.answer,
                status:data.status,
                targetFlag:data.targetFlag,
                commitTag:data.commitTag,
            });
          }
        })
    }
    onShowPopupClick = () => {
      Popup.show(<div  onClick={this.onClose.bind(this)}>
        <List  className="popup-list" >
              <List.Item className="typeDiv" onClick={()=>{this.confirmChangeFlag()}}>删除</List.Item>
              <List.Item className="typeDiv" onClick={()=>{this.changeFlag("4")}}>忽略</List.Item>
              {this.state.status==1&&<List.Item className="typeDiv" onClick={()=>{this.changeFlag("2")}}>待完善语义</List.Item>}
              {this.state.status==1&&<List.Item className="typeDiv" onClick={()=>{this.changeFlag("1")}}>记录问题库</List.Item>}
              <div style={{height:"15px"}}></div><List.Item className="typeDiv" onClick={()=>{Popup.hide()}}>取消</List.Item>
        </List>
      </div>, { animationType: 'slide-up',  maskClosable: true });
    };
    confirmChangeFlag=()=>{
          alert('提示', '确定删除么?', [
            { text: '取消'},
            { text: '确定', onPress: () => this.changeFlag("-1"), style: { fontWeight: 'bold' } },
          ]);
    }
    changeFlag=(flag)=>{         
          Popup.hide();
          Toast.loading('处理中...',10);
          this.ChangeTargetFlag(flag).then((data)=>{
              Toast.hide();
              this.backList();
          });
    }
    ChangeTargetFlag = (flag) =>{
      return new Promise((resolve,reject)=>{
        if(isdebug){
            fetch(`./data-detail0.json`)
            .then(function(res) {
                let data=res.json();
                return data;
            }).then(function(data) {
              resolve(data);
            })
            .catch(function(e) {
                console.log("error",e);
            });
        }else{
            fetch('/mobile/plugin/fullsearch/EAssistant/eWorkbenchAjax.jsp?type=changeTargetFlag&targetFlag='+flag+'&faqId='+this.state.id+'&random='+new Date().getTime(), {
              method: 'POST',
              mode: 'same-origin',
              headers: {'Content-Type': 'application/json; charset=utf-8'},
              credentials: 'include'
            })
            .then(function(res) {
                let data=res.json();
                return data;
            }).then(function(data) {
              resolve(data);
            })
            .catch(function(e) {
                console.log("error",e);
            });
        }
      })
    }; 
    onClose = () => {
      Popup.hide();
    };
    onChange(value){
        this.setState({ answer:value });
    }
    giveup=()=>{
        let that=this;
        if(isdebug){
            fetch(`./data-detail0.json`)
            .then(function(res) {
                that.backList();
            }).catch(function(e) {
                console.log("error",e);
            });       
        }else{
            Toast.loading('处理中...',10);
            fetch('/mobile/plugin/fullsearch/EAssistant/eWorkbenchAjax.jsp?type=unDoCheckOut&faqId='+this.state.id+'&random='+new Date().getTime(), {
              method: 'POST',
              mode: 'same-origin',
              headers: {'Content-Type': 'application/json; charset=utf-8'},
              credentials: 'include'
            })
            .then(function(res) {
                Toast.hide();
                that.backList();
            })
            .catch(function(e) {
                console.log("error",e);
            });
        }
    }
    backList=()=>{
        hashHistory.push({
            pathname: '/',
            query:{tab:this.state.tab}
        })
    }
    sendMsg=()=>{
        Toast.loading('处理中...',10);
        this.AjaxSendMsg().then((data)=>{
            Toast.hide();
            Toast.success('提交成功!!!', 1);
            this.backList();
        });
    }
    changeAsk=()=>{
        Toast.loading('处理中...',10);
        this.AjaxChangeAsk().then((data)=>{
            Toast.hide();
            Toast.success('提交成功!!!', 1);
            this.backList();
        });
    }
    AjaxSendMsg=()=>{
        let param={};
        param.answer=this.state.answer;
        param.faqId=this.state.id;
        return new Promise((resolve,reject)=>{
          if(isdebug){
              fetch(`./data-detail0.json`)
              .then(function(res) {
                  let data=res.json();
                  return data;
              }).then(function(data) {
                  resolve(data);
              })
              .catch(function(e) {
                  Toast.fail('提交失败!!!', 1);
                  console.log("error",e);
              });
          }else{
              fetch('/mobile/plugin/fullsearch/EAssistant/eWorkbenchAjax.jsp?type=sendEMsg', {
                method: 'POST',
                mode: 'same-origin',
                headers: {'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8','X-Requested-With':'XMLHttpRequest'},
                credentials: 'include',
                body:getFd(param)
              })
              .then(function(res) {
                  let data=res.json();
                  return data;
              }).then(function(data) {
                  resolve(data);
              })
              .catch(function(e) {
                  Toast.fail('提交失败!!!', 1);
                  console.log("error",e);
              });
          }
          
        })
    }
    AjaxChangeAsk=()=>{
        let param={};
        param.answer=this.state.answer;
        param.faqId=this.state.id;
        return new Promise((resolve,reject)=>{
          if(isdebug){
              fetch(`./data-detail0.json`)
              .then(function(res) {
                  let data=res.json();
                  return data;
              }).then(function(data) {
                  resolve(data);
              })
              .catch(function(e) {
                  Toast.fail('提交失败!!!', 1);
                  console.log("error",e);
              });
          }else{
              fetch('/mobile/plugin/fullsearch/EAssistant/eWorkbenchAjax.jsp?type=changeAsk', {
                method: 'POST',
                mode: 'same-origin',
                headers: {'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8','X-Requested-With':'XMLHttpRequest'},
                credentials: 'include',
                body:getFd(param)
              })
              .then(function(res) {
                  let data=res.json();
                  return data;
              }).then(function(data) {
                  resolve(data);
              })
              .catch(function(e) {
                  Toast.fail('提交失败!!!', 1);
                  console.log("error",e);
              });
          }
          
        })
    }
    render() {
        return (
            <div
            style={{
              height: clientHight,
              background:"#fff"
            }}>
                <div id="InfoTop">
                  <Card>
                    <Card.Header title={this.state.ask} />
                    <div style={{margin:"10px 0"}}></div>
                    <div className="am-card-footer">
                        <div className="am-card-footer-content">{this.state.createrName+' '+this.state.createdate+' '+this.state.createtime}</div>
                        {this.state.commitTag=='1'&&<div className="flagDiv comefrom-e">小e</div>}
                        {this.state.commitTag=='2'&&<div className="flagDiv comefrom-ws">微搜</div>}
                        {this.state.targetFlag!=''&&<div className="flagDiv">{this.state.targetFlag}</div>}
                    </div>
                    <div style={{margin:"20px 0", borderBottom:"2px solid #f3f3f3"}}></div> 
                    {this.state.init&&
                    <div onClick={()=>{this.onShowPopupClick()}}>
                      <Card.Footer className='detailDiv' content={"标记为"} extra={<Icon type={'right'} />} />
                    </div> 
                    }
                  </Card>
                </div>
                <div style={{height:"20px", background:"#f3f3f3"}}></div>
                
                {this.state.status==1&&
                  <div style={{height:"40px",marginTop:"15px"}}>
                      <div style={{float:"left",marginLeft:"15px"}}>
                        <img src="/fullsearch/img/answer.png" style={{width:"40px"}}/>
                      </div>
                      <div className="am-card-footer" style={{lineHeight:"40px"}}>
                        {this.state.processName+' '+this.state.processdate+' '+this.state.processtime}
                      </div>
                  </div>
                }
                {this.state.status==1&&<div className="tapSlideDiv" style={{maxHeight:clientHight-InfoTopHeight-20-40-40-30,marginLeft:"10px",marginTop:"30px",marginRight:"10px",paddingBottom:"20px",overflow:"auto"}} dangerouslySetInnerHTML={{__html:this.state.answer}}></div>}
                {this.state.init&&this.state.status==0&&
                <div onClick={()=>{ReactDOM.findDOMNode(this.refs.answerTextArea).children[0].children[0].focus()}} style={{height:clientHight-InfoTopHeight-20-40-110,marginTop:"20px",marginRight:"10px", overflow:"auto"}}>
                    <TextareaItem ref='answerTextArea'
                       autoHeight
                       labelNumber={5}
                       placeholder="写回复"
                       onChange={this.onChange.bind(this)}
                    />
                </div>
                }
                {this.state.status=="0"&&
                  <div style={{position: "absolute", left: "0", bottom: "0",right: "0"}}>
                      <Flex style={{ margin: '10px' }}>
                          <Flex.Item><Button onClick={this.giveup.bind(this)} style={{fontSize:"0.28rem"}}>放弃修改</Button></Flex.Item>
                          {this.state.answer!=''&&<Flex.Item><Button style={{fontSize:"0.28rem"}} onClick={this.changeAsk.bind(this)}>转化问法</Button></Flex.Item>}
                          {this.state.answer==''&&<Flex.Item><Button disabled style={{fontSize:"0.28rem"}}>转化问法</Button></Flex.Item>}
                          {this.state.answer!=''&&<Flex.Item><Button type="primary" style={{fontSize:"0.28rem"}} onClick={this.sendMsg.bind(this)}>提交</Button></Flex.Item>}
                          {this.state.answer==''&&<Flex.Item><Button type="primary" disabled style={{fontSize:"0.28rem"}}>提交</Button></Flex.Item>}
                      </Flex>
                  </div>
                }
            </div>
        )
    }
}

const getFd = (values) => {
    let fd = "";
    for(let p in values) {
	 	if(p == 'jsonstr' && typeof values[p] === 'object'){
	 		fd += p+"="+JSON.stringify(values[p]).replace(/\\/g,'')+"&";
        }else{
        	fd += p+"="+encodeURIComponent(values[p])+"&";
        }
    }
    fd += "__random__="+new Date().getTime();
    return fd;
}

class Root extends React.Component {
    render() {
        return ( 
           <Router history={hashHistory}>
              <Route path="/" component={TabExample}> </Route>
              <Route path="/Info" component={DetailInfo}></Route>
          </Router>
        );
    }
};

try{
  ReactDOM.render(<Root/>, document.getElementById('container'));
}catch(e){
  console.log(e);
  alert(e);
}

