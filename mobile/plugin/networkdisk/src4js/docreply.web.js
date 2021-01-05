import { Modal, Button, WhiteSpace, WingBlank,Toast} from 'antd-mobile';
import { Popup, Icon,List,ListView,RefreshControl} from 'antd-mobile';
import 'whatwg-fetch';
import React from 'react';
import ReactDOM from 'react-dom';
import './disk.css';
import './content.css';
import './reply.css';

const alert = Modal.alert;

let state = {
	isLoading : 0,
	successInfo : 0,
	successMsg : '',
}

let maxWindowHeight = 0;

const ReplyList = React.createClass({
	getInitialState : function(){
		return ({
			docid : docid,
			ownerid : ownerid,
			replyList : [], //回复列表
			canReply : canReply, //是否可回复,1-可回复，0-不可回复
			isFirst : 1,
			lastId : lastId,  //最后一个评论id
			pageSize : pageSize, //一次取评论数
			childrenSize : childrenSize, //一次取子回复数量
			islast : 0 //是否取完
		})
	},
	componentDidMount : function(){
		this.loadMore(true);
	},
	getData : function(mainId,lastId,noLoading){
		if(state.isLoading == 1){
			return;
		}
		mainId = mainId ? mainId : 0;
		lastId= lastId ? lastId : 0;
		state.isLoading = 1;
		if(!noLoading){
			Toast.info(<LodingState/>,10);
		}
		return new Promise((resolve,reject)=>{
			 fetch('/mobile/plugin/networkdisk/systemDoc.jsp?sessionkey=' + sessionkey + '&method=getReply' + 
	      		'&docid=' + this.state.docid + '&lastId=' + lastId + '&pageSize=' + this.state.pageSize + "&mainId=" + mainId + "&childrenSize=" + this.state.childrenSize
	      	, {
	        method: 'POST',
	        mode: 'same-origin',
	        headers: {'Content-Type': 'application/json; charset=utf-8'},
	        credentials: 'include'
		}).then(function(res) {
	          let data=res.json();
	          state.isLoading = 0;
	          if(!noLoading){
	          	Toast.hide();
	          }else{
	          	try{
		      		parent.hideSystemDocLoading();
		      	}catch(e){}
	          }
	          return data;
	      }).then(function(data) {
	          resolve(data);
	      })
	      .catch(function(e) {
	          console.log("error",e);
	      });
	  });
	},
	loadMore : function(noLoading){
		if(state.isLoading == 1){
			return;
		}
		let that = this;
		this.getData(0,this.state.lastId,noLoading).then((data)=>{
			let replyList = eval("(" + data.replyList + ")");
			let pList = that.state.replyList;
			replyList.map((reply)=>{
				if(reply.documentid == reply.replymainid){
					pList.push(reply);
					reply.children = [];
					replyList.map((cReply)=>{
						if(cReply.replymainid != cReply.documentid && cReply.replymainid == reply.documentid){
							reply.children.push(cReply);
						}
					});
				}
				//that.state.replyList.push(reply);
			});
			let lastId = 0;
			if(pList.length == 0 || !pList[pList.length - 1].isHave){
				this.state.islast = 1;
			}
			if(pList.length > 0){
				lastId = pList[pList.length - 1].documentid;
			}
			that.setState({
				replyList : pList,
				lastId : lastId, 
				isFirst : 0
			});
		});
	},
	loadMoreChildren : function(d,e){
		let that = this;
		this.getData(d.mainId,d.lastId).then((data)=>{
			let replyList = eval("(" + data.replyList + ")");
			let pReply = {};
			that.state.replyList.map((reply)=>{
				if(reply.documentid == d.mainId){
					pReply = reply;
					return;
				}
			});
			pReply.children = pReply.children ? pReply.children : [];
			replyList.map((reply)=>{
				pReply.children.push(reply);
			});
			that.setState({});
		})
	},
	onRefresh : function(){
		this.state.lastId = 0;
		loadMore();
	},
	openReply : function(d,e){
		let _class = e.target.className;
		if(this.state.canReply == "0")return;
		if(_class && (_class.indexOf("praisePointer") > -1 || _class.indexOf("loadMoreChildren") > -1)){
			return;
		}
		Popup.show(
			<div className="replyPop">
				<div className="replyPopHead">
					<div className="replyPopClose" onClick={this.closeReply}><Icon type="cross-circle-o" /></div>
					<div className="replyPopTitle">写回复</div>
					<div className="replyPopCommit" onClick={this.commitReply.bind(this,{id:d.id,mainId:d.mainId,userid : d.userid})}><Icon type="check-circle-o" /></div>
				</div>
				<div className="replyContent">
					<div className="replyContentBorder">
						<textarea id="replyContent" placeholder="写回复"></textarea>
					</div>
				</div>
			</div>
		,{animationType : 'slide-up'})
	},
	closeReply : function(){
		Popup.hide();
	},
	commitReply : function(d,e){ //提交回复
		if(state.isLoading == 1){
			return;
		}
		let _value = replyContent.value;
		if(_value == ""){
			alert("回复内容不能为空!");
			return;
		}
		let that = this;
		state.isLoading = 1;
		Toast.info(<LodingState/>,10);
		new Promise((resolve,reject)=>{
			 fetch('/mobile/plugin/networkdisk/systemDoc.jsp?sessionkey=' + sessionkey + '&method=replyDoc' + 
	      		'&documentid=' + this.state.docid + '&docsubject=' + _value +
	      		'&replyid=' + (d.id ? d.id : -1) + '&replytype=' + (d.id ? 1 : 0) +
	      		'&rownerid=' + (d.id ? d.userid : this.state.ownerid) + '&replymainid=' + (d.mainId ? d.mainId : "")
	      	, {
	        method: 'POST',
	        mode: 'same-origin',
	        headers: {'Content-Type': 'application/json; charset=utf-8'},
	        credentials: 'include'
		}).then(function(res) {
	          let data=res.json();
	          state.isLoading = 0;
	          Toast.hide();
	          return data;
	      }).then(function(data) {
	          resolve(data);
	      })
	      .catch(function(e) {
	          console.log("error",e);
	      })
	  }).then((data)=>{
      	if(data && data.result && data.result.result == "success"){
      		Popup.hide();
      		state.successMsg = '回复成功!';
      		state.successInfo = 1;
      		let result = data.result;
      		result.children = [];
      		if(d.id){ //回复其他回复
      			that.state.replyList.map((pReply)=>{
      				if(pReply.documentid == result.replymainid){
      					pReply.children = pReply.children ? pReply.children : [];
      					pReply.children.push(result);
      				}
      			})
      		}else{ //回复主文档
      			that.state.replyList.unshift(result);
      		}
      		that.setState({});
      	}else if(data && data.result && data.result.result){
      		alert(data.result.error);
      	}else{
      		alert("回复失败!");
      	}
      });
	},
	commitPraise : function(d,e){ //提交点赞(取消点赞)
		if(state.isLoading == 1){
			return;
		}
		let that = this;
		state.isLoading = 1;
		Toast.info(<LodingState/>,10);
		new Promise((resolve,reject)=>{
			 fetch('/mobile/plugin/networkdisk/systemDoc.jsp?sessionkey=' + sessionkey + '&method=praiseDoc' + 
	      		'&replyid=' + d.id + '&docid=' + this.state.docid + '&isPraise=' + d.isPraise
	      	, {
	        method: 'POST',
	        mode: 'same-origin',
	        headers: {'Content-Type': 'application/json; charset=utf-8'},
	        credentials: 'include'
		}).then(function(res) {
	          let data=res.json();
	          state.isLoading = 0;
	          Toast.hide();
	          return data;
	      }).then(function(data) {
	          resolve(data);
	      })
	      .catch(function(e) {
	          console.log("error",e);
	      })
	  }).then((data)=>{
      	if(data && data.result && data.result.result == "success"){
      		state.successMsg = (d.isPraise == 1 ? '取消点赞' : '点赞') + '成功!';
      		state.successInfo = 1;
      		if(d.mainId == d.id){
      			that.state.replyList.map((reply)=>{
      				if(d.id == reply.documentid){
      					let praiseInfo = reply.praiseInfo ? reply.praiseInfo : {users:[]};
      					if(d.isPraise == 1){
      						praiseInfo.isPraise = 0;
      						reply.praiseInfo.users.map((user,i)=>{
      							if(user.userid == data.userid){
      								reply.praiseInfo.users.splice(i,1);
      								return;
      							}
      						})
      					}else{
      						praiseInfo.isPraise = 1;
      						praiseInfo.users.push({userid:data.userid})
      					}
      					reply.praiseInfo = praiseInfo;
      					return;
      				}
      			})
      		}else{
      			that.state.replyList.map((reply)=>{
      				if(d.mainId == reply.documentid){
      					reply.children.map((cReply,j)=>{
      						if(d.id != cReply.documentid)return;
      						let praiseInfo = cReply.praiseInfo ? cReply.praiseInfo : {users:[]};
	      					if(d.isPraise == 1){
	      						praiseInfo.isPraise = 0;
	      						cReply.praiseInfo.users.map((user,i)=>{
	      							if(user.userid == data.userid){
	      								cReply.praiseInfo.users.splice(i,1);
	      								return;
	      							}
	      						})
	      					}else{
	      						praiseInfo.isPraise = 1;
	      						praiseInfo.users.push({userid:data.userid})
	      					}
	      					cReply.praiseInfo = praiseInfo;
	      					return;
      					})
      					return;
      				}
      			})
      		}
      		that.setState({});
      	}else if(data && data.result && data.result.result){
      		alert(data.result.error);
      	}else{
      		alert((d.isPraise == 1 ? '取消点赞' : '点赞') + "失败!");
      	}
      });
	},
	render : function(){
		return (
			<div id="content">
				<div>
					<FileListView 
						replyList={this.state.replyList}
						islast={this.state.islast}
						canReply={this.state.canReply}
						isLoading={state.isLoading}
						isFirst={this.state.lastId == 0 ? 1 : 0}
						loadMore={this.loadMore}
						onRefresh={this.onRefresh}
						openReply={this.openReply}
						commitPraise={this.commitPraise}
						loadMoreChildren={this.loadMoreChildren}
					/>
				</div>
				{
					this.state.canReply == "1" &&
					<div className="operate">
						<div className="reply">
							<div className="replyInput" onClick={this.openReply.bind(this,{id:0})}><Icon type="edit"/> 写回复</div>
						</div>
					</div>
				}
				{
					state.successInfo == 1 &&
					<SuccessState msg={state.successMsg}/>
				}
			</div>
		)
	}
})

const FileListView = React.createClass({
	getInitialState : function(){
		const dataSource = new ListView.DataSource({
			rowHasChanged : (row1,row2) => row1 !== row2,
		});
		this.initData = this.props.replyList;
		initialListSize = this.initData.length;
		return {
			dataSource : dataSource.cloneWithRows(this.initData),
			islast : this.props.islast,
			refreshing : false,
			isLoading : state.isLoading,
			isFirst : true,
		}
	},
	onEndReached : function(e){
		if(e !== undefined){
			 if(this.state.islast == 0){
			 	if(this.state.isLoading == 0){//表示正在加载
			 		//this.props.loadMore();
			 		let renderRow = this.state.renderRow + pageSize;
			 		if(renderRow < this.initData.length || this.state.islast == 1){
			 			this.setState({renderRow : renderRow});
			 		}else{
			 			this.props.loadMore();
			 		}
			 	}
			 }  
		}
	},
	componentDidUpdate : function(){
		if(this.state.isFirst){
			this.setState({isFirst : false});
		}
	},

	componentWillReceiveProps : function(nextProps){
	
		let listStr = JSON.stringify(nextProps.replyList)
		this.initData = eval("(" + listStr + ")");
		initialListSize = this.initData.length;
		this.setState({
			isLoading:state.isLoading,
			islast : nextProps.islast,
			refreshing : false,
			dataSource:this.state.dataSource.cloneWithRows(this.initData)
		});

	},
	onRefresh : function(){
		if(!this.state.refreshing){
			this.setState({
				refreshing : true
			});
			this.props.onRefresh();
		}
	},
	errorImg : function(d,e){
		try{
			let $obj = jQuery(d.url);
			if($obj[0].tagName == "IMG"){
				e.target.setAttribute("src",$obj.attr("src"));
			}else if($obj[0].tagName == "DIV"){
				jQuery(e.target).parent().html(d.url);
			}
		}catch(e){
			//console.info("error")
		}
	},
	render : function(){
		let that = this;
		let contentWidth = window.innerWidth;
		const row = (rowData,sectionID,rowID) => {
			return (
				<List.Item key={rowID}>
					<li style={{width:contentWidth}}>
						<div onClick={this.props.openReply.bind(this,{id:rowData.documentid,mainId:rowData.documentid,userid : rowData.ownerid})}>
							<div className="diskUnit right replyUnit">
								<div className="diskIcon" dangerouslySetInnerHTML={{__html : rowData.ownerurl}}>
								</div>
								<div className="diskContent">
									<div className="diskName" >
										{rowData.ownername}
									</div>
									<div className="diskTime">{rowData.doccreatedate + " " + rowData.doccreatetime}</div>
									<div className="clearBoth"></div>
								</div>
								<div className={"praisePointer diskOpeate praise" + (rowData.praiseInfo && rowData.praiseInfo.isPraise ? " praised" :"")} 
									onClick={this.props.commitPraise.bind(this,{id:rowData.documentid,
											isPraise:rowData.praiseInfo && rowData.praiseInfo.isPraise == 1 ? 1 : 0,
									mainId:rowData.documentid})}>
									<span className={"praisePointer replyPraise" + (rowData.praiseInfo && rowData.praiseInfo.isPraise == 1 ? " praised" : "")}>
										{rowData.praiseInfo ? rowData.praiseInfo.users.length : 0}
									</span>	
									<Icon type="like" className="praisePointer"/>
								</div>
							</div>
							<div className="replyContent">
								<div style={{"white-space": "normal"}}>{rowData.docsubject}</div>
							</div>
						</div>
						{
							rowData.children.length > 0 &&
							<div className="replyChildren">
								{
									rowData.children.map((children,i)=>{
										return (
											<div className="childrenInfo" onClick={that.props.openReply.bind(this,{id:children.documentid,mainId:children.replymainid,userid : children.ownerid})}>
												<div className="replyInfo">
													<div className="userInfo">
														<span className="replyUser">{children.ownername}</span>
														<span>回复</span>
														<span className="replyUser">{children.rownername}</span>
														<span className="replyTime">{children.doccreatedate + " " + children.doccreatetime}</span>
													</div>
													<div className={"praisePointer childOpeate praise" + (children.praiseInfo && children.praiseInfo.isPraise ? " praised" :"")} onClick={that.props.commitPraise.bind(this,{id:children.documentid,
														isPraise:children.praiseInfo && children.praiseInfo.isPraise == 1 ? 1 : 0,
														mainId:children.replymainid})}>
														<span className={"praisePointer replyPraise" + (children.praiseInfo && children.praiseInfo.isPraise == 1 ? " praised" : "")}>
															{children.praiseInfo ? children.praiseInfo.users.length : 0}
														</span>	
														<Icon type="like" className="praisePointer"/>
														
													</div>
												</div>
												<div className="replyContent">{children.docsubject}</div>
												{
													rowData.children.length - i == 1 && (children.isHave == true || children.isHave == "true") &&
													<div className="loadMoreChildren" onClick={that.props.loadMoreChildren.bind(this,{lastId : children.documentid,mainId : rowData.documentid})}>
														点击加载更多
													</div>
												}
											</div>
										)
									})
								}
							</div>
						}
					</li>
				</List.Item>
			)
		}
		maxWindowHeight = window.innerHeight < maxWindowHeight ? maxWindowHeight : window.innerHeight;
		let resultDivHeight = maxWindowHeight -  (this.props.canReply == "1" ? 50*window.viewportScale : 0);
		return (
					this.state.isFirst ?
					<div></div>
					:
					this.initData.length > 0 ?
					 <ListView
					 	dataSource={this.state.dataSource}
					 	renderRow={row}
					 	 pageSize={pageSize}
					 	 initialListSize={initialListSize}
					 	 scrollRenderAheadDistance={500}
				          scrollEventThrottle={20}
				          onEndReached={this.onEndReached}
				          onEndReachedThreshold={1}
				          scrollRenderAheadDistance={200}
				          scrollEventThrottle={20}
				          refreshControl={
				          	<RefreshControl
					          refreshing={this.state.refreshing}
					          onRefresh={this.onRefresh}
					        />
				          }
				          renderFooter={()=>
				          	<div style={{padding:10,textAlign:'center'}}>
				          		{this.state.islast || this.initData.length == 0 ? '' : FontList.loadMore}
				          	</div>
				          }
				          style={{
				            height: resultDivHeight,
				            overflow: 'auto',
				          }}	
					 />

					:

					 <li className="folderEmpty" style={{height:resultDivHeight}}>
					  	<div>
							<Icon type="message"/>
							<div className="emptyInfo">
								暂无回复
							</div>
							
						</div>	
					 </li> 
		)
	}
})

const LodingState = React.createClass({
	render : function(){
		return (
			<div>	
				<div className="mue-load-bounce">
					<div className="mue-load-bounce-child mue-load-bounce1"></div>
					<div className="mue-load-bounce-child mue-load-bounce2"></div>
					<div className="mue-load-bounce-child mue-load-bounce"></div>
				</div>
				<div style={{textAlign : 'center',color:'#ffffff'}}>
					{FontList.loadingFont}
				</div>
			</div>	
		)
	}
})


const SuccessState = React.createClass({
	componentDidMount : function(){
		this.setHideTimeOut();
	},
	componentDidUpdate : function(){
		if(state.successInfo == 1){
			document.getElementById("successInfo").style.display = "block";
			this.setHideTimeOut();
		}
	},
	setHideTimeOut : function(){
		setTimeout(function(){
			document.getElementById("successInfo").style.display = "none";
			state.successInfo = 0;
		},1000);
	},
	render : function(){
		return (
			<div className="successInfo" id="successInfo">
				<div className="successMsg">{this.props.msg}</div>
			</div>
		)
	}
})

ReactDOM.render(<ReplyList />,document.getElementById('root'));