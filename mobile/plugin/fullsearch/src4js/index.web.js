import React from 'react';
import ReactDOM from 'react-dom';

import { SearchBar,Flex,Button } from 'antd-mobile';
import { Popup, List, Menu ,Grid,Result ,Toast,ListView } from 'antd-mobile';

const Brief=List.Item.Brief;


let hotKeyList=[];
let initHotKey=false;
let backindex=1;
let iconMap=new Map();
let contentType='ALL';
let hideHead=false;
let title='';
let pagesize=10;
let pageindex=1;
let contentDivMarginHeight=0;
let resultDivHeight=300;
let searchKey='';
let back=false;//是否是返回
let userid="x";

//多语言标签
let searchStr="搜索";
let allStr="全部";
let promptStr="请输入关键字";
let loadStr="加载中...";
let hotStr1="系统热点";
let hotStr2="看看大家都在搜什么";
let hotStr3="系统暂无热点词";
let tipStr="提示";
let loadMoreStr="上拉加载更多...";




const SearchBarExample = React.createClass({
  getInitialState() {
    iconMap.set("ALL","all_grey_wev8.png");
    iconMap.set("WF","wf_wev8.png");
    iconMap.set("DOC","doc_wev8.png");
    iconMap.set("WKP","wkp_wev8.png");
    iconMap.set("RSC","rsc_wev8.png");
    iconMap.set("EMAIL","email_wev8.png");
    iconMap.set("COW","cow_wev8.png");
    iconMap.set("CRM","crm_wev8.png");
    iconMap.set("FAQ","faq_wev8.png");
    iconMap.set("PRJ","prj_wev8.png");
    iconMap.set("CPT","cpt_wev8.png");
    iconMap.set("OTHER","other_wev8.png");

    return {
      keyword: '',
      searchTypeList:[],
      contentTypeName:allStr,
      loadList:false,
      resultMap:{},
      showHot:false
    };
    
  },
  componentWillMount(){   
    hideHead="true"==document.getElementById("hideHead").value;
    title=document.getElementById("title").value;
    contentType=document.getElementById("contentType").value;
    back="true"==document.getElementById("back").value;
    backindex=document.getElementById("pageindex").value;
    
    //页面获取多语言
    searchStr=document.getElementById("searchStr").value; 
    allStr=document.getElementById("allStr").value; 
    promptStr=document.getElementById("promptStr").value;
    loadStr=document.getElementById("loadStr").value;
    hotStr1=document.getElementById("hotStr1").value;
    hotStr2=document.getElementById("hotStr2").value;
    hotStr3=document.getElementById("hotStr3").value;
    tipStr=document.getElementById("tipStr").value;
    loadMoreStr=document.getElementById("loadMoreStr").value;
    let keyword=document.getElementById("keyword").value;
    //获取之前的查询记录
    let storage=window.localStorage;
    userid=document.getElementById("userid").value;
    if(keyword==''){
      if(storage.getItem("fullsearch-validTime-"+userid)&&(new Date().getTime()-storage.getItem("fullsearch-validTime-"+userid))/1000<60){// 默认有效时间1min
          keyword=storage.getItem("fullsearch-keyword-"+userid);
          contentType=storage.getItem("fullsearch-contentType-"+userid);
          backindex=storage.getItem("fullsearch-backindex-"+userid);
          back=true;
      }
    }

    if(keyword==''){
      this.setState({ showHot:!hideHead});
    }else{
      this.setState({ showHot:!hideHead,keyword:keyword,loadList:true });
    }
  },
  componentDidMount() {
    contentDivMarginHeight=hideHead?0:document.getElementById("searchDiv").offsetHeight;
    resultDivHeight=window.innerHeight-contentDivMarginHeight;
    this.getSearchSchemaType(contentType);
    this.onSearch(this.state.keyword );   
  },
  onChange(value) {
    this.setState({ keyword:value });
  },
  onSearch(value) {
    searchKey=value;
    pageindex=1;
    if(value==''){
      this.setState({ keyword:value,loadList:false,resultMap:{}});
    }else{
      Toast.loading(loadStr,10);
      let that=this;
      GetList(value).then((data)=>{
        that.setState({ keyword:value,loadList:true,resultMap:data});
        Toast.hide();
      })
    }
  },
  clickHotKey(value){
      this.onSearch(value);
  },
  loadMoreList(){
      Toast.loading(loadStr,10);
      pageindex++;
      let that=this;
      GetList(searchKey).then((data)=>{
        that.setState({ keyword:searchKey,loadList:true,resultMap:data});
        Toast.hide();
      })
  },
  getSearchSchemaType(type){
      let that=this;
      fetch("/mobile/plugin/fullsearch/getFetch.jsp?type=schema", {
            method: 'POST',
            mode: 'same-origin',
            headers: {'Content-Type': 'application/json; charset=utf-8'},
            credentials: 'include'
        })
        .then(function(res) {
            let data=res.json();
            return data;
        }).then(function(data) {
          //console.log("data:",data);
          if(data.list){
            let typeName=allStr;
            data.list.map((key)=>{
                 let schema=key.split(":")
                let keyID=schema[0];
                typeName=keyID==type?schema[1]:typeName;
            })
            that.setState({ searchTypeList:data.list,contentTypeName:typeName });
          }
        })
        .catch(function(e) {
          console.log("error",e);
        });
  },
  showSearchType(){
    Popup.show(
        <div style={{"maxHeight":window.innerHeight-20,"overflowY":"auto"}}>
      <List>
            <List.Item key="ALL" thumb="/mobile/plugin/fullsearch/img/all_grey_wev8.png" onClick={()=>{
                 contentType='ALL';
                 this.setState({contentTypeName:allStr})
                 this.onSearch(this.state.keyword);
                 Popup.hide();
              }}>{allStr}</List.Item>
             {
              this.state.searchTypeList.map((key)=>{
              let schema=key.split(":")
              let keyID=schema[0];
              let keyName=schema[1];
              let icon='/mobile/plugin/fullsearch/img/other_wev8.png';
              icon=iconMap.has(keyID)?'/mobile/plugin/fullsearch/img/'+keyID.toLowerCase()+'_wev8.png':icon;
              return(
                <List.Item key={keyID} thumb={icon} onClick={()=>{
                  contentType=keyID;
                  this.setState({contentTypeName:keyName})
                  this.onSearch(this.state.keyword);
                  Popup.hide();
                  }}>{keyName}</List.Item>
                );
       
              })
            }
      </List></div>, { maskClosable: true });

  },
  render() {
    return (
        <div >
          {!hideHead &&
          <div className="searchDiv" id="searchDiv">

          <Flex style={{"backgroundColor":"#3496FC","width":"100%" }}>
              <table style={{width:"100%"}}><tr>
                <td style={{width:"60px"}}>
                    <div style={{"textAlign":"center","color":"white","width":"100%"}} onClick={this.showSearchType}>{this.state.contentTypeName}</div>
                </td>
                <td>
                  <div style={{"width":"100%"}}>
                    <SearchBar
                      value={this.state.keyword}
                      placeholder={promptStr}
                      onSubmit={this.onSearch}
                      onCancel={this.onSearch}
                      showCancelButton={false}
                      cancelText={searchStr}
                      onChange={this.onChange}
                    />
                  </div>
                </td>
              </tr></table>
          </Flex>
          </div>
          }
          <div id="resultDiv" className="resultDiv" style={{height:resultDivHeight}}>
          {this.state.loadList?<ListViewExample list={this.state.resultMap.list?this.state.resultMap.list:[]} resultMap={this.state.resultMap} loadMore={this.loadMoreList}/>:(this.state.showHot&&<HotKey clickCallback={this.clickHotKey}/>)}
          </div>
        </div>
    );
  },
});

//获取查询结果
const GetList = (value) =>{
    return new Promise((resolve,reject)=>{
      fetch('/mobile/plugin/fullsearch/searchList.jsp?hideHead='+hideHead+'&noauth=&title='+title+'&contentType='+contentType+'&pagesize='+(back?pagesize*backindex:pagesize)+'&pageindex='+(back?1:pageindex)+'&keyword='+encodeURIComponent(encodeURIComponent(value)), {
        method: 'POST',
        mode: 'same-origin',
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        credentials: 'include'
      })
      .then(function(res) {
          back=false;
          let data=res.json();
          return data;
      }).then(function(data) {
          resolve(data);
      })
      .catch(function(e) {
          console.log("error",e);
      });
    })
}
 
//热点
let HotKey  = React.createClass({
  getInitialState() {
    return {
      
    };
  },
  componentDidMount() {
      if(!initHotKey){
        this.getHotKey();
        initHotKey=true;
      }
      //this.getHotKey();
  },
  getHotKey(){
      //console.log("hotkey load");
      let that=this;
      fetch("/mobile/plugin/fullsearch/getFetch.jsp?type=hotkey", {
            method: 'POST',
            mode: 'same-origin',
            headers: {'Content-Type': 'application/json; charset=utf-8'},
            credentials: 'include'
        })
        .then(function(res) {
            let data=res.json();
            return data;
        }).then(function(data) {
          //console.log("data:",data);
          if(data.list){
            hotKeyList=data.list;
            that.setState({ hotKeyList:data.list });
          }
        })
        .catch(function(e) {
          console.log("error",e);
        });
  },
  checkHot(v){
     if(typeof(this.props.clickCallback)=="function") {
        this.props.clickCallback(v);
     }
  },
  render() {
      let that=this;
      return (<div id="hotDiv" style={{marginLeft:'16px',marginRight:'16px',marginTop:'16px'}}>
        <div style={{height:'60px',marginTop:'24px'}}>
          <div style={{height:'40px',borderBottom: '1px solid #f0f0f0',lineHeight: '40px'}}>
            <div style={{float:'left',color:'#4d4d4d',fontSize:'24px',fontWeight:'bold'}}>{hotStr1}</div>
            <div style={{float:'left',color:'#888888',marginLeft:'15px',fontSize:'16px'}}>{hotStr2}</div>
          </div>
        </div>
        {hotKeyList.length==0&&<div style={{textAlign:'center',fontSize:'16px',color:'#888888'}}>{hotStr3}</div>} 
        {hotKeyList.length>0&&<Grid
          data={hotKeyList}
          columnNum={4}
          hasLine={false}
          renderItem={(hotValue, index) => (
            <div className="hottd"><a onClick={()=>{
              this.checkHot(hotValue);
            }}>{hotValue}</a></div>
          )}
        />
        }
      </div>);
  },
});


// {"result":"","pagesize":"10","count":"259","list":[],
// "ishavenext":"1","ishavepre":"0","hasHrm":"true","pagecount":"26",
// "err":"0","pageindex":"1","key":"123"}

//查询结果集
let ListExample = React.createClass({
   getInitialState() {
    return {
      resultList:[]
    };
  },
  render() {
    //console.log(this.props);
    let resultMap=this.props.resultMap;
    let err=resultMap.err;
    return (<div>
    
      {err<0 && <Result
            imgUrl="/mobile/plugin/fullsearch/img/waring_wev8.png"
            title={tipStr}
            message={resultMap.msg.replace("<b style='color:red;'>","").replace("</b>","")}
          />
      }
      {err==0 &&  resultMap.count==0?<Result
            imgUrl="/mobile/plugin/fullsearch/img/noresult_wev8.png"
            title={tipStr}
            message={resultMap.result}
          />:
        <List>
              {
                 resultMap.list.map((data)=>{
                  //console.log(data);
                  return (
                      <List.Item
                        arrow="horizontal"
                        onClick={() => {
                          goPage(data.id,data.schema,data.url);
                        }}
                        multipleLine
                      > <div dangerouslySetInnerHTML={{__html:data.title}}></div><Brief ><div dangerouslySetInnerHTML={{__html:data.content}}></div></Brief><Brief>{data.description}</Brief>
                      </List.Item>
                    );
                })
              }
        </List>
      }

    </div>);
  },
});



const ListViewExample = React.createClass({
  getInitialState() {

    const dataSource = new ListView.DataSource({
      rowHasChanged: (row1, row2) => row1 !== row2,
    });
    this.rData = this.props.list;
    return {
      dataSource: dataSource.cloneWithRows(this.rData),
      isLoading: false,
      resultMap:this.props.resultMap,
    };

  },
  componentWillReceiveProps(nextProps) {
    if (nextProps.resultMap !== this.props.resultMap) {
        if(nextProps.resultMap.pageindex > 1){
            this.rData=this.rData.concat(nextProps.list);
            this.setState({isLoading:false,dataSource:this.state.dataSource.cloneWithRows(this.rData),resultMap:nextProps.resultMap});
        }

        if(nextProps.resultMap.pageindex==1){
            this.rData=nextProps.list;
            this.setState({isLoading:false,dataSource:this.state.dataSource.cloneWithRows(this.rData),resultMap:nextProps.resultMap});
        }
    }
  },
  onEndReached(event) {
    if(event !== undefined){
      if(this.state.resultMap.ishavenext==1){    
        // load new data
        //console.log('reach end', event);
        if(!this.state.isLoading){//表示正在加载
            this.setState({ isLoading: true });
            if(typeof(this.props.loadMore)=="function") {
              this.props.loadMore();
            }
        }
      }
    }
  },
  render() {
  
    let resultMap=this.props.resultMap;
    let list=resultMap.list;
    let err=resultMap.err;
    const row = (rowData, sectionID, rowID) => {
      let icon='/messager/images/icon_m_wev8.jpg';
      let job="";
      let subcomp="";
      let dept="";
      let imgDiv="";
      try{
        //console.log(rowData.other);
        //console.log(otherJson);
        if(rowData.schema=="RSC"){
          let otherJson=eval("("+rowData.other+")");  
          icon=otherJson.URL==""?otherJson.SEX=="1"?'/messager/images/icon_w_wev8.jpg':icon:otherJson.URL;        
          subcomp=otherJson.SUBCOMP;
          job=otherJson.JOBTITLENAME;
          dept=otherJson.DEPT;

	        if(icon.indexOf("icon_w_wev8.jpg")>-1||icon.indexOf("icon_m_wev8.jpg")>-1||icon.indexOf("dummyContact.png")>-1){
              if(rowData.simpleTitle){
		            imgDiv=getRSCname(rowData.simpleTitle);
              }
	        }

        }
      }catch(e){
        console.log(e);
      }

      return (
        <List.Item
          arrow="horizontal"
          onClick={() => {
              let storage=window.localStorage;
              storage.setItem("fullsearch-validTime-"+userid,new Date().getTime());
              storage.setItem("fullsearch-keyword-"+userid,searchKey);
              storage.setItem("fullsearch-contentType-"+userid,contentType);
              storage.setItem("fullsearch-backindex-"+userid,backindex>pageindex?backindex:pageindex);
              
             
              goPage(rowData.id,rowData.schema,rowData.url);
          }}
          multipleLine
        > 

        {rowData.schema=="RSC" && <div>
                  <span className="ul-li-div-img">
                    {imgDiv==""&&<img src={icon}/>}
                    {imgDiv!=""&& <div className="imgDiv">{imgDiv}</div> }
                  </span>
                  <div className="ul-li-div">
                     <div className="ul-li-div-first"> <span className="ui-li-span ui-li-span-heading">{rowData.simpleTitle?rowData.simpleTitle:rowData.title}</span> <span className="ui-li-span">{job}</span></div>
                     <div className="ul-li-div-second"> <span className="ui-li-span">{subcomp}</span><span className="ui-li-span">{dept}</span></div>
                  </div>
        </div>}


        {rowData.schema !=="RSC" && <div><div dangerouslySetInnerHTML={{__html:rowData.title}}></div><Brief ><div dangerouslySetInnerHTML={{__html:rowData.content}}></div></Brief><Brief>{rowData.description}</Brief></div>}

        </List.Item>
      );
    };
    return (<div>
      {err<0 && 
        <Result imgUrl="/mobile/plugin/fullsearch/img/err_wev8.png" title={tipStr} message={<div dangerouslySetInnerHTML={{__html:resultMap.msg}}></div>}/>
      }
      {err==0 &&  (resultMap.count==0?
          <Result imgUrl="/mobile/plugin/fullsearch/img/noresult_wev8.png" title={tipStr} message={resultMap.result}/>:
          <ListView
          dataSource={this.state.dataSource}
          renderFooter={() => <div style={{ padding: 10, textAlign: 'center' }}> 
              {this.state.isLoading ? loadStr : this.state.resultMap.ishavenext==1 ? loadMoreStr:
                <div dangerouslySetInnerHTML={{__html:this.state.resultMap.result}}></div>
              }
            </div>}
          renderRow={row}
          pageSize={5}
          scrollRenderAheadDistance={500}
          scrollEventThrottle={20}
          onEndReached={this.onEndReached}
          onEndReachedThreshold={1}
          style={{
            height: resultDivHeight,
            overflow: 'auto',
          }}

        />)
      }
    </div>);
  },
});

function getRSCname(name){
   var reg = /[\u4E00-\u9FA5]/;
   if(reg.test(name)){
   		if(name.length>2){
  			name = name.substring(name.length-2,name.length);
  		}
   }else{
  		if(name.length>4){
  			name = name.substring(0,4);
  		}
   }
   return name;
}

try{
  ReactDOM.render(<SearchBarExample  />, document.getElementById('root'));
}catch(e){
  alert(e);
}
