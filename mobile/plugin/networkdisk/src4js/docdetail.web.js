import { Modal, Button, WhiteSpace, WingBlank,Toast} from 'antd-mobile';
import { Popup, Icon , List, ListView, RefreshControl} from 'antd-mobile';
import 'whatwg-fetch';
import React from 'react';
import ReactDOM from 'react-dom';

import './disk.css';
import './content.css';

const alert = Modal.alert;

let state = {
	isLoading : 0,
	successInfo : 0,
	successMsg : ''
}
let maxWindowHeight = 0;

let IconPath = "/mobile/plugin/networkdisk/img/";

const DocDetail = React.createClass({
	getInitialState : function(){
		return (
			{
				docid : docid,
				isFirst : 1,
				docFlag : '', //1-正常，-1-删除，0-没有权限
				docInfo : {}
			}
		)
	},
	componentDidMount : function(){
		let that = this;
		this.getData(true).then((data)=>{
			that.setState({
				isFirst : 0,
				docFlag : data.flag,
				docInfo : data.docInfo
			})
		});
	},
	componentDidUpdate : function(){
		try{
			componentDidUpdate();
		}catch(e){}
	},
	getData : function(noLoading){
		if(state.isLoading == 1){
			return;
		}
		state.isLoading = 1;
		if(!noLoading){
			Toast.info(<LodingState/>,10);
		}
		return new Promise((resolve,reject)=>{
			 fetch('/mobile/plugin/networkdisk/systemDoc.jsp?sessionkey=' + sessionkey + '&method=getDocDetail' + 
	      		'&docid=' + this.state.docid 
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
	openReply : function(){
		Popup.show(
			<div className="replyPop">
				<div className="replyPopHead">
					<div className="replyPopClose" onClick={this.closeReply}><Icon type="cross-circle-o" /></div>
					<div className="replyPopTitle">写回复</div>
					<div className="replyPopCommit" onClick={this.commitReply}><Icon type="check-circle-o" /></div>
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
	commitReply : function(){ //提交回复
		
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
	      		'&replyid=-1&replytype=0' +
	      		'&rownerid=' + this.state.docInfo.ownerid + '&replymainid='
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
      		that.state.docInfo.replyCount = that.state.docInfo.replyCount ? (parseInt(that.state.docInfo.replyCount) + 1) : 0;
      		that.setState({});
      	}else if(data && data.result && data.result.result){
      		alert(data.result.error);
      	}else{
      		alert("回复失败!");
      	}
      });
	},
	commitPraise : function(){ //提交点赞(取消点赞)
		if(state.isLoading == 1){
			return;
		}
		let that = this;
		state.isLoading = 1;
		Toast.info(<LodingState/>,10);
		new Promise((resolve,reject)=>{
			 fetch('/mobile/plugin/networkdisk/systemDoc.jsp?sessionkey=' + sessionkey + '&method=praiseDoc' + 
	      		'&docid=' + this.state.docid + '&isPraise=' + this.state.docInfo.isPraise
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
      		state.successMsg = (that.state.docInfo.isPraise == 1 ? '取消点赞' : '点赞') + '成功!';
      		state.successInfo = 1;
      		that.state.docInfo.praiseCount = that.state.docInfo.isPraise == 1 ? (that.state.docInfo.praiseCount - 1) : (parseInt(that.state.docInfo.praiseCount) + 1);
      		that.state.docInfo.isPraise = that.state.docInfo.isPraise == 1 ? 0 : 1;
      		that.setState({});
      	}else if(data && data.result && data.result.result){
      		alert(data.result.error);
      	}else{
      		alert((that.state.docInfo.isPraise == 1 ? '取消点赞' : '点赞') + "失败!");
      	}
      });
	},
	commitCollute : function(){//提交收藏（取消收藏）
		if(state.isLoading == 1){
			return;
		}
		let that = this;
		state.isLoading = 1;
		Toast.info(<LodingState/>,10);
		new Promise((resolve,reject)=>{
			 fetch('/mobile/plugin/networkdisk/systemDoc.jsp?sessionkey=' + sessionkey + '&method=coluteDoc' + 
	      		'&docid=' + this.state.docid + '&isCollute=' + this.state.docInfo.isCollute
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
      		state.successMsg = (that.state.docInfo.isCollute == 1 ? '取消收藏' : '收藏') + '成功!';
      		state.successInfo = 1;
      		that.state.docInfo.isCollute = that.state.docInfo.isCollute == 1 ? 0 : 1;
      		that.setState({});
      	}else if(data && data.result && data.result.result){
      		alert(data.result.error);
      	}else{
      		alert((that.state.docInfo.isCollute == 1 ? '取消收藏' : '收藏') + "失败!");
      	}
      });
	},
	onMore : function(){//更多
		Popup.show(
			<div className="moreProp">
				{
					this.state.docInfo.canShare &&	
					<div className="shareDoc" onClick={this.share}>分享</div>
				}
				{
					this.state.docInfo.canDelete &&
					<div className="deleteDoc" onClick={this.deleteDoc}>删除</div>
				}
				<div className="cancel" onClick={Popup.hide} style={{color : "#017afd"}}>取消</div>
			</div>
		,{animationType : 'slide-up'})
	},
	share : function(){//分享
		let dataMap = {
			docid : this.state.docid,
			docTitle : this.state.docInfo.docTitle
		}
		toShareDoc(dataMap);
		Popup.hide();
	},
	shareToOther : function(){//分享到其他应用

	},
	deleteDoc : function(){//删除文档
		let that = this;
		alert("确定要删除该文档吗?","",[
			{text : '取消',onPress : () => console.log("cancel")},
			{text : '确定',onPress : () => that.doDelete()}
			]);
	},
	doDelete : function(){
		let that = this;
		state.isLoading = 1;
		Toast.info(<LodingState/>,10);
		new Promise((resolve,reject)=>{
			 fetch('/mobile/plugin/networkdisk/systemDoc.jsp?sessionkey=' + sessionkey + '&method=deleteDoc' + 
	      		'&docid=' + this.state.docid
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
	  		deleteDoc(this.state.docid);
	  	}else if(data && data.result && data.result.result){
	  		alert(data.result.error);
	  	}else{
	  		alert("删除失败!");
	  	}
	  });
	},
	toReplyList : function(){ //打开回复列表
		if(window._hasParentWindow){
			try{
				parent.showSystemDocLoading();
			}catch(e){}
			parent.docReply.className = "show";
			let that = this;
			setTimeout(function(){
				parent.docReply.childNodes[0].src = "/mobile/plugin/networkdisk/docReplyList.jsp?docid=" + that.state.docid + "&sessionkey=" + sessionkey + "&module=" + moduleid + "&scope=" + scope;
			},500);
		}else{
			Toast.info(<LodingState/>,10);
			docReply.className = "show";
			let that = this;
			setTimeout(function(){
				docReply.childNodes[0].src = "/mobile/plugin/networkdisk/docReplyList.jsp?docid=" + that.state.docid + "&sessionkey=" + sessionkey + "&module=" + moduleid + "&scope=" + scope;
			},500);
		}
	},
	openAttrFile : function(d,e){ //打开可在线查看附件
		var params = "fileid=" + d.fileid + "&docid=" + d.docid + "&filename=" + d.filename + (d.readOnLine == 1 ? ".pdf" : "") + "&sessionkey=" + sessionkey + "&from=networkdisk&type=document";
		if(window._hasParentWindow){
			if(d.readOnLine == 1){
				parent.toOpenFile(params,true,"systemDoc");
			}else{
				parent.toOpenFile(params,false,"systemDoc");
			}
		}else{
			if(d.readOnLine == 1){
				toOpenFile(params,true);
			}else{
				toOpenFile(params,false);
			}
		}
	},
	iframeShow : function(d,e){
		if(d.hideLoad){
			Toast.hide();
		}
		e.target.style.display = "block";
	},
	render : function(){
		let docInfo = this.state.docInfo;
		maxWindowHeight = window.innerHeight < maxWindowHeight ? maxWindowHeight : window.innerHeight;
		let contentHeight = maxWindowHeight - 50*window.viewportScale;
		let contentWidth = window.innerWidth;
		return (
			<div>
				<div id="content" style={{height:contentHeight,width:contentWidth}}>
				{
					this.state.isFirst == 1 ?
					<div></div>
					:
					this.state.docFlag == -1 ?
					<div>
						文档已删除
					</div>
					:
					this.state.docFlag == 0 ?
					<div>
						没有权限
					</div>
					:
					<div>
						<DocContent 
							docInfo={docInfo}
							contentHeight={contentHeight}
							contentWidth={contentWidth}
							openAttrFile={this.openAttrFile}
						/>
					</div>	
				}

				</div>
				{
					this.state.docFlag == 1 &&

					window._androidX5 ?
					<div className="operate">
						<table  style={{width:'100%'}}>
							<tbody>
								<tr>
									<td className="replyTd">
										<div className="reply">
											{
												docInfo.canReply &&
												<div className="replyInput" onClick={this.openReply}><Icon type="edit"/> 写回复</div>
											}
										</div>
									</td>
									
									{
										docInfo.canReply &&	
										<td className="replyList" onClick={this.toReplyList}>
											<Icon type="message"/>
											({docInfo.replyCount})
										</td>
									}
									{
										docInfo.canReply &&	
										<td className={"praise" + (docInfo.isPraise == "1" ? " praised" : "")} onClick={this.commitPraise}>
											<Icon type="like"/>
											({docInfo.praiseCount})
										</td>
									}
									<td className={"collute" + (docInfo.isCollute == "1" ? " colluted" : "")} onClick={this.commitCollute}>
										<Icon type="star-o"/>
									</td>
									{
										(docInfo.canDelete || docInfo.canShare) &&
										<td className="more" onClick={this.onMore}>
											<Icon type="ellipsis"/>
										</td>
									}
								</tr>
							</tbody>
						</table>	
					</div>	
					:
					<div className="operate">
							
						<div className="reply">
							{
								docInfo.canReply &&
								<div className="replyInput" onClick={this.openReply}><Icon type="edit"/> 写回复</div>
							}
						</div>
						
						{
							docInfo.canReply &&	
							<div className="replyList" onClick={this.toReplyList}>
								<Icon type="message"/>
								({docInfo.replyCount})
							</div>
						}
						{
							docInfo.canReply &&	
							<div className={"praise" + (docInfo.isPraise == "1" ? " praised" : "")} onClick={this.commitPraise}>
								<Icon type="like"/>
								({docInfo.praiseCount})
							</div>
						}
						<div className={"collute" + (docInfo.isCollute == "1" ? " colluted" : "")} onClick={this.commitCollute}>
							<Icon type="star-o"/>
						</div>
						{
							(docInfo.canDelete || docInfo.canShare) &&
							<div className="more" onClick={this.onMore}>
								<Icon type="ellipsis"/>
							</div>
						}
					</div>
				}


				{
					state.successInfo == 1 &&
					<SuccessState msg={state.successMsg}/>
				}


				{
					!window._hasParentWindow &&
					<div>
						<div id="docReply">
							<iframe frameborder="0" scrolling="no" width="100%" height="100%" onLoad={this.iframeShow.bind(this,{hideLoad : true})}></iframe>
						</div>
						<div id="attrDetail">
							<iframe frameborder="0" scrolling="no" width="100%" height="100%" onLoad={this.iframeShow.bind(this,{hideLoad : true})}></iframe>
						</div>
					</div>
				}
			</div>	
		)
	}
})


const DocContent = React.createClass({
	getInitialState : function(){
		const dataSource = new ListView.DataSource({
			rowHasChanged : (row1,row2) => row1 !== row2,
		});
		this.initData = [];
		if(this.props.docInfo){
			this.initData.push(this.props.docInfo);
		}
		return {
			dataSource : dataSource.cloneWithRows(this.initData),
			contentWidth : this.props.contentWidth,
			contentHeight : this.props.contentHeight
		}
	},
	onEndReached : function(e){
		
	},
	componentDidUpdate : function(){
		
	},

	componentWillReceiveProps : function(nextProps){
		this.setState({
			contentHeight : this.props.contentHeight,
			dataSource:this.state.dataSource.cloneWithRows(this.initData)
		});

	},
	onRefresh : function(){
		
	},
	openAttrFile : function(d,e){
		this.props.openAttrFile(d,e);
	},
	render : function(){

		let that = this;
		const row = (docInfo,sectionID,rowID) => {
			return (
				<div style={{width:this.state.contentWidth}}>
					<div className="docTitle">
						{docInfo.docTitle}
					</div>
					<div className="docMain" style={{width:'100%'}}>
						<div className="docOwner">
							<div className="ownerImg" dangerouslySetInnerHTML={{__html : docInfo.icon}} >
							</div>
							<div className="ownerInfo">
								<div className="ownerName">
									{docInfo.owner}
								</div>
								<div className="docInfo">
									<font className="updateUser">最后修改：{docInfo.updateUser}</font>
									<font className="updateTime">{docInfo.updateTime}</font>
									<font className="readNum">阅读{docInfo.readCount}</font>
								</div>
							</div>
						</div>
						<div className="docContent" id="docContent" dangerouslySetInnerHTML={{__html : docInfo.doccontent}} />
						<div className="docAttr">
							{
								docInfo.docAttrs.map((docAttr)=>{
									return(
										<div className="attrUnit">
											<div onClick={this.openAttrFile.bind(this,{fileid : docAttr.imagefileid,filename : docAttr.filename,docid : docAttr.docid,readOnLine : docAttr.readOnLine})}>
												<div className="attrImg">
													<img src={IconPath + docAttr.ficon}/>
												</div>
												<div className="attrName">
													{docAttr.filename}
												</div>
												<div className="attrSize">
													<font>{docAttr.fileSizeStr}</font>
												</div>
												<div className="attrIcon">
													<font></font>
												</div>
											</div>
										</div>
									)	
								})
							}
						</div>
					</div>
				</div>
			)
		}
		
		return (
			<ListView
			 	dataSource={this.state.dataSource}
			 	renderRow={row}
			 	 pageSize={1}
			 	 initialListSize={1}
			 	 scrollRenderAheadDistance={500}
		          scrollEventThrottle={20}
		          onEndReached={this.onEndReached}
		          onEndReachedThreshold={1}
		          scrollRenderAheadDistance={200}
		          scrollEventThrottle={20}
		          renderFooter={()=>{}}
		          style={{
		            height: this.state.contentHeight,
		            overflow: 'auto',
		          }}	
			 />
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
});


ReactDOM.render(<DocDetail />,document.getElementById('root'));
