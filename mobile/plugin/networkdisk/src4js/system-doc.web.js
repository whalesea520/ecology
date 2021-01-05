import { SearchBar,List,ListView,RefreshControl } from 'antd-mobile';
import { Modal, Button, WhiteSpace, WingBlank,Toast} from 'antd-mobile';
import { Popup, Icon } from 'antd-mobile';
import { Router, Route, hashHistory,Link,browserHistory } from 'react-router';
import ReactCSSTransitionGroup from 'react-addons-css-transition-group';
import 'whatwg-fetch';
import React from 'react';
import ReactDOM from 'react-dom';




let maxWindowHeight = 0;
let resultDivHeight  = 300;
let IconPath = "/mobile/plugin/networkdisk/img/";
let IconList = {
	folderEmpty : IconPath + 'empty.png',
	addNoIcon : IconPath + 'add_no.png', //(底部)添加图标
	addIcon : IconPath + 'add.png', //(底部)添加图标
	docIcon : IconPath + 'disk.png', //(底部)文档图标
	docIconChecked : IconPath + 'disk_checked.png', //(底部)文档选中图标
	categoryIcon : IconPath + 'category.png', //(底部)目录图标
	categoryIconChecked : IconPath + 'category_checked.png', //(底部)目录选中图标
	folderIcon : '2.png',//列表中文件夹类型图标
	checkedNo : '/mobile/plugin/networkdisk/img/check_icon_no.png', //多选（未选中）
	checkedYes : '/mobile/plugin/networkdisk/img/check_icon_yes.png', //多选（选中)
}
let blueStyle = {
	color : "#017afd"
}

let state = {
	isLoading : 0,
	successInfo : 0,
	successMsg : '',
	onlyRearsh : 0, //只刷新当前数据
}

let __version = "v1.0";

let localStorageData = {};
if(localStorage.systemDoc){
	localStorageData.systemDoc = JSON.parse(localStorage.systemDoc);
	if(localStorage.dataVersion != __version){
		localStorage.removeItem("systemDoc");
		localStorage.dataVersion = __version;
		localStorageData = {};
	}else if(localStorageData.systemDoc.sessionData.userid != window._USER_ID){
		localStorage.removeItem("systemDoc");
		localStorageData = {};
	}
}

let sessionData = IS_OPEN_SESSION == 1 && localStorageData.systemDoc ? localStorageData.systemDoc.sessionData : {
	userid : window._USER_ID,
	allDocs : {}, //所有文档
	myDocs : {}, //我的文档
	collectDocs : {}, //我的收藏
	categorys : {},//目录缓存
	docs : {},//目录下文件缓存
	searchList : [],	//搜索历史
}

function iosSearchKey(){
	var $form = document.getElementsByClassName("am-search");
	if($form.length > 0){
		for(let i = 0;i < $form.length;i++){
			if($form[i].tagName == "FORM"){
				$form[i].action = "";
			}
		}
	}
}


const SystemDoc = React.createClass({
	getInitialState : function(){
		window.SystemObj = this;
		return ({
			keyword : '',  //搜索关键字
			searchTxt : '',
			searchStr : FontList.searchStr, //搜索按钮
			promptStr : '请输入文档名称', //输入框内提示文字
			categoryid : 0, //目录id
			showTab : 'all', //显示tab(all-全部文档，my-我的文档，collect-我的收藏)
			currentView : 'doc', //当前视图，doc-文档，category-目录
			pids : [0],
			path : ['目录'],
			searchStatus : 0,
			searchHistory : 1,
			historyList : [],
			docList : [],  //文档集合
			docMap : {},  //文档对象
			categoryList : [], //目录集合
			categoryMap : {},   //目录对象
			totalSize : 0 ,//选中文件数量
			chooseFileMap : {} //选中文件对象

		})
	},
	componentDidMount : function(){
		Toast.hide();
		let that = this;
		pageNum = 1;
		this.getCookies().then((data)=>{
			sessionData.searchList = data;

			if(IS_OPEN_SESSION == 1 && localStorageData.systemDoc){
				//that.state = localStorageData.systemDoc.state;
				//that.state.searchStatus = 0;
				//that.state.searchHistory = 1;
				//that.state.historyList = [];
				//that.setState({});
				this.onRefresh(true);	

			}else{
				that.getDocList(true).then((rdata)=>{
					rdata.docs.map((doc)=>{
						if(!that.state.docMap[doc.docid]){
							that.state.docMap[doc.docid] = doc;
							that.state.docList.push(doc);
						}
					});
					
					that.setState({});
				})
			}
		})
	},
	componentDidUpdate : function(){
	 	if(this.state.searchStatus == 1 && this.state.searchHistory != 2){
			if(document.getElementsByClassName("am-search-value").length > 0){
				document.getElementsByClassName("am-search-value")[0].focus();
			}
		}

		iosSearchKey();
	},
	onChangeDocTab : function(d,e){ //切换文档导航
		this.state.showTab = d.tab;
		pageNum = 1;
		this.onRefresh(true);
	},
	focus : function(){
		if(this.state.searchHistory == 1){
			this.setState({
				searchHistory : 0,
				searchStatus : 1,
				historyList : sessionData.searchList
			});
		}
	},
	deleteDoc : function(docid){
		docDetail.className = "";
		
		if(this.state.currentView == "doc"){
			if(this.state.showTab == "all"){
				sessionData.allDocs.docs.map((doc)=>{
					if(doc.docid == docid){
						doc.isDelete = true;
						return;
					}
				})
			}else if(this.state.showTab == "my"){
				sessionData.myDocs.docs.map((doc)=>{
					if(doc.docid == docid){
						doc.isDelete = true;
						return;
					}
				})
			}else if(this.state.showTab == "collect"){
				sessionData.collectDocs.docs.map((doc)=>{
					if(doc.docid == docid){
						doc.isDelete = true;
						return;
					}
				})
			}
		}else if(this.state.currentView == "category"){
			sessionData.categorys[this.state.categoryid].docs.map((doc)=>{
				if(doc.docid == docid){
					doc.isDelete = true;
				}
			})
		}
		let _localStorageSystemDoc = localStorage.systemDoc ? JSON.parse(localStorage.systemDoc) : {};
		_localStorageSystemDoc.sessionData = sessionData;
		localStorage.systemDoc = JSON.stringify(_localStorageSystemDoc);

		state.successInfo = 1;
		state.successMsg = "删除成功!";
		state.onlyRearsh = 1;
		this.setState({});
	},
	onSearch : function(){
		this.state.searchTxt = this.state.keyword;
		this.state.searchHistory = 2;
		if(this.state.keyword != ""){
			if(state.isLoading == 1) return;
			state.isLoading  = 1;
			Toast.info(<LodingState/>,10);
			let that = this;
			new Promise((resolve,reject)=>{
		      fetch('/mobile/plugin/networkdisk/historySearch.jsp?sessionkey=' + sessionkey + '&method=add&type=5&searchtext=' + this.state.keyword
		      	, {
		        method: 'POST',
		        mode: 'same-origin',
		        headers: {'Content-Type': 'application/json; charset=utf-8'},
		        credentials: 'include'
		      })
		      .then(function(res) {
		          let data=res.json();
		          state.isLoading = 0;
		          Toast.hide();
		          return data;
		      }).then(function(data) {
		          resolve(data);
		      })
		      .catch(function(e) {
		          console.log("error",e);
		      });
		    }).then(function(data){
		    	that.getCookies().then((historyList)=>{
		    		sessionData.searchList = historyList;
		    		that.onRefresh();
		    	})
		    });
		}else{
			this.onRefresh();
		}
	},
	onCancel : function(){
		pageNum = 1;
		this.state.keyword = "";
		this.state.searchTxt = "";
		this.state.searchHistory = 1;
		this.state.searchStatus = 0;
		this.onRefresh(true);
	},
	onChange : function(value){
		this.state.keyword = value;
		this.setState({});
	},
	getCategoryList : function(flag,fn){//查询目录,flag-是否执行查询操作
		if(state.isLoading == 1)return;
		if(!flag || this.state.currentView == "doc" || this.state.searchStatus != 0){ //文档或者搜索状态，不获取目录
			if(typeof(fn) == "function")
				fn();
			return;
		}
		let that = this;
		state.isLoading = 1;
		Toast.info(<LodingState/>,10);
		return new Promise((resolve,reject)=>{
	      fetch('/mobile/plugin/networkdisk/systemDoc.jsp?sessionkey=' + sessionkey + '&method=getCategoryList' + 
	      		'&bySearch=' + this.state.searchStatus + '&keyword=' + this.state.searchTxt + '&categoryid=' + this.state.categoryid 
	      	, {
	        method: 'POST',
	        mode: 'same-origin',
	        headers: {'Content-Type': 'application/json; charset=utf-8'},
	        credentials: 'include'
	      })
	      .then(function(res) {
	          let data=res.json();
	          state.isLoading = 0;
	          Toast.hide();
	          return data;
	      }).then(function(data) {
	          resolve(data);
	      })
	      .catch(function(e) {
	          console.log("error",e);
	      });
	    }).then(function(data){
	    	let rdata = {
	    		categorys : eval("(" + data.categorys + ")")
	    	};
	    	that.add2Session(rdata);
	    	if(typeof(fn) == "function"){
	    		fn(rdata);
	    	}else{
	    		return rdata;
	    	}
	    	
	    });
	},
	getDocList : function(isFirst){//查询文档
		if(state.isLoading == 1)
			return;
		state.isLoading = 1;
		if(isFirst){
			pageNum = 1;
		}
		Toast.info(<LodingState/>,10);
		let that = this;
		return new Promise((resolve,reject)=>{
	      fetch('/mobile/plugin/networkdisk/systemDoc.jsp?sessionkey=' + sessionkey + '&method=' + (this.state.currentView == 'doc' ? 'getDocList' : 'getCategoryDocList') + 
	      		'&bySearch=' + this.state.searchStatus + '&keyword=' + this.state.searchTxt + '&categoryid=' + this.state.categoryid +
	      		'&docTab=' + this.state.showTab + '&pageSize=' + pageSize + '&pageNum=' + pageNum 
	      	, {
	        method: 'POST',
	        mode: 'same-origin',
	        headers: {'Content-Type': 'application/json; charset=utf-8'},
	        credentials: 'include'
	      })
	      .then(function(res) {
	      	  pageNum++;
	          let data=res.json();
	          state.isLoading = 0;
	          Toast.hide();
	          return data;
	      }).then(function(data) {
	          resolve(data);
	      })
	      .catch(function(e) {
	          console.log("error",e);
	      });
	    }).then(function(data){
	    	let rdata = {
	    		docs : eval("(" + data.docs + ")")
	    	};
	    	that.add2Session(rdata);
	    	if(rdata.docs.length < pageSize){
	    		state.islast = 1;
	    	}else{
	    		state.islast = 0;
	    	}
	    	return rdata;
	    });
	},
	add2Session : function(data){
		if(IS_OPEN_SESSION !=1 || this.state.searchStatus != 0){
	    	return;
	    }
	    if(this.state.currentView == "doc"){
	    	if(this.state.showTab == "all"){
	    		if(data && data.docs){
	    			sessionData.allDocs.docs = sessionData.allDocs.docs ? sessionData.allDocs.docs : [];
	    			data.docs.map((d)=>{
	    				sessionData.allDocs.docs.push(d);
	    			});
	    		}
	    	}else if(this.state.showTab == "my"){
	    		if(data && data.docs){
	    			sessionData.myDocs.docs = sessionData.myDocs.docs ? sessionData.myDocs.docs : [];
	    			data.docs.map((d)=>{
	    				sessionData.myDocs.docs.push(d);
	    			});
	    		}
	    	}else if(this.state.showTab == "collect"){
	    		if(data && data.docs){
	    			sessionData.collectDocs.docs = sessionData.collectDocs.docs ? sessionData.collectDocs.docs : [];
	    			data.docs.map((d)=>{
	    				sessionData.collectDocs.docs.push(d);
	    			});
	    		}
	    	}
	    }else if(this.state.currentView == "category"){
	    	if(!sessionData.categorys[this.state.categoryid]){
    			sessionData.categorys[this.state.categoryid] = {
    				categorys:[],
    				docs:[]
    			};
    		}
	    	if(data && data.categorys){
	    		sessionData.categorys[this.state.categoryid].categorys = data.categorys;
	    	}else if(data && data.docs){
	    		sessionData.categorys[this.state.categoryid].docs = sessionData.categorys[this.state.categoryid].docs ? sessionData.categorys[this.state.categoryid].docs : [];
	    		if(data.docs.length > 0){
		    		data.docs.map((d)=>{
		    			sessionData.categorys[this.state.categoryid].docs.push(d);
		    		})
	    		}
	    	}
	    }
	    let _localStorageSystemDoc = localStorage.systemDoc ? JSON.parse(localStorage.systemDoc) : {};
		_localStorageSystemDoc.sessionData = sessionData;
		localStorage.systemDoc = JSON.stringify(_localStorageSystemDoc);
	},
	getSession : function(){
		let rMap = null;
		let docs = [];
		let _start = (pageNum - 1)*pageSize;
		let _end = pageNum*pageSize;
		if(this.state.currentView == "doc"){
			let _docs = [];
			if(this.state.showTab == "all"){
				_docs = sessionData.allDocs.docs;
			}else if(this.state.showTab == "my"){
				_docs = sessionData.myDocs.docs;
			}else if(this.state.showTab == "collect"){
				_docs = sessionData.collectDocs.docs;
			}
			if(_docs && _docs.length > 0){
				_docs.map((doc,i)=>{
					if(i >= _start && i < _end){
						docs.push(doc);
					}
				});
				rMap = {docs : docs};
				if(docs.length > 0){
					pageNum++;
				}
				state.islast = docs.length == pageSize ? 0 : 1;
			}
		}else if(this.state.currentView == "category"){
			if(sessionData.categorys && sessionData.categorys[this.state.categoryid]){
				
				let _docs = sessionData.categorys[this.state.categoryid].docs;
				if(_docs && _docs.length > 0){
					_docs.map((doc,i)=>{
						if(i >= _start && i < _end){
							docs.push(doc);
						}
					});
					if(docs.length > 0){
						pageNum++;
					}
					state.islast = docs.length == pageSize ? 0 : 1;
				}
				rMap = {
					docs : docs,
					categorys : sessionData.categorys[this.state.categoryid].categorys
				}
			}
		}
		return rMap;
	},
	removeSession : function(){
		if(this.state.currentView == "doc"){
			if(this.state.showTab == "all"){
				sessionData.allDocs = {};
			}else if(this.state.showTab == "my"){
				sessionData.myDocs = {};
			}else if(this.state.showTab == "collect"){
				sessionData.collectDocs = {};
			}
		}else if(this.state.currentView == "category"){
			if(sessionData.categorys){
				sessionData.categorys[this.state.categoryid] = {};
			}
		}
		let _localStorageSystemDoc = localStorage.systemDoc ? JSON.parse(localStorage.systemDoc) : {};
		_localStorageSystemDoc.sessionData = sessionData;
		localStorage.systemDoc = JSON.stringify(_localStorageSystemDoc);
	},
	categoryView : function(){ //目录视图
		if(state.isLoading == 1)
			return;
		this.state.currentView = 'category',
		this.state.categoryid = 0,
		this.state.pids = [0],
		this.state.path = ['目录'],
		pageNum = 1;
		state.islast = 1;
		this.onRefresh(true);
	},
	docView : function(){//文档视图
		if(state.isLoading == 1)
			return;
		this.state.showTab = "all";
		this.state.currentView = "doc";
		pageNum = 1;
		this.onRefresh(true);
	},
	getCookies : function(){
		if(state.isLoading == 1)
			return;
		state.isLoading = 1;
		Toast.info(<LodingState/>,10);
		return new Promise((resolve,reject)=>{
	      fetch('/mobile/plugin/networkdisk/historySearch.jsp?sessionkey=' + sessionkey + '&method=getHistorySearch&type=5', {
	        method: 'POST',
	        mode: 'same-origin',
	        headers: {'Content-Type': 'application/json; charset=utf-8'},
	        credentials: 'include'
	      }).then(function(res) {
	      	  state.isLoading = 0;
	      	  Toast.hide();
	          let data= res.json();
	         return data;
	      }).then(function(data) {
	      	 resolve(data);
	      }).catch(function(e) {
	      	console.log("error",e);
	      });
	    });
	},
	onSearchByHistory : function(d,i,e){
		this.state.keyword = d.data;
		this.onSearch();
	},
	clearHistory : function(){
		if(state.isLoading == 1)
			return;
		state.isLoading = 1;
		Toast.info(<LodingState/>,10);
		let that = this;
		new Promise((resolve,reject)=>{
	      fetch('/mobile/plugin/networkdisk/historySearch.jsp?sessionkey=' + sessionkey + '&method=clearHistory&type=5', {
	        method: 'POST',
	        mode: 'same-origin',
	        headers: {'Content-Type': 'application/json; charset=utf-8'},
	        credentials: 'include'
	      })
	      .then(function(res) {
	      	  state.isLoading = 0;
	      	  Toast.hide();
	          let data= res.json();
	         return data;
	      }).then(function(data) {
	      	 resolve(data);
	      })
	      .catch(function(e) {
	      	console.log("error",e);
	      });
	    }).then(function(data){
	    	sessionData.searchList = [];
	    	that.setState({
	    		historyList : []
	    	});
	    });	
	},
	loadMore : function(){
	
		if(state.isLoading == 1) return;
		let that = this;
		let sessionMap = this.getSession();
		this.state.docMap = {};
		this.state.docList = [];
		this.state.categoryList = [];
		if(sessionMap != null && sessionMap.docs.length > 0){
			sessionMap.docs.map((doc)=>{
				that.state.docMap[doc.docid] = doc;
				that.state.docList.push(doc);
			})
			that.setState({});
			return;
		}
		this.getDocList(false).then((rdata)=>{
			rdata.docs.map((doc)=>{
				if(!that.state.docMap[doc.docid]){
					that.state.docMap[doc.docid] = doc;
					that.state.docList.push(doc);
				}
			});	
			that.setState({});
		});
	},
	onRefresh : function(sessionFirst){
		if(state.isLoading == 1) return;
		this.state.docMap = {};
		this.state.docList = [];
		this.state.categoryList = [];
		let that = this;
		let categorySearch = true;
		if(sessionFirst){ //是否先判断session中是否存在，存在则先从session取
			let sessionMap = this.getSession();
			if(sessionMap != null){
				if(sessionMap.categorys && sessionMap.categorys.length > 0){ 
					let dmap = {};
					sessionMap.categorys.map((category)=>{
						if(!dmap[category.sid]){
							dmap[category.sid] = category;
							this.state.categoryMap[category.sid] = category;
							this.state.categoryList.push(category);
						}
					});
					categorySearch = false;
				}

				if(sessionMap.docs && sessionMap.docs.length > 0){
					let dmap = {};
					sessionMap.docs.map((doc)=>{
						if(!dmap[doc.docid]){
							dmap[doc.docid] = doc;
							this.state.docMap[doc.docid] = doc;
							this.state.docList.push(doc);
						}
					})
					this.setState({});
					return;
				}

				if(!categorySearch){  //只有在目录和文档全为空，才去重新获取文档
					pageNum = 1;
					this.setState({});
					return;
				}
			}
		}else{
			this.state.categoryMap = {};
			if(IS_OPEN_SESSION == 1 && this.state.searchStatus == 0){ //开启缓存，并且是非搜索状态
				this.state.chooseFileMap = {};
				this.removeSession();
			}
		}

		this.getCategoryList(categorySearch,function(cdata){
			that.getDocList(true).then((rdata)=>{
				let dmap = {};
				rdata.docs.map((doc)=>{
					if(!dmap[doc.docid]){
						dmap[doc.docid] = doc;
						that.state.docMap[doc.docid] = doc;
						that.state.docList.push(doc);
					}
				});
				if(cdata && cdata.categorys && cdata.categorys.length > 0){
					let dmap = {};
					cdata.categorys.map((category)=>{
						if(!dmap[category.sid]){
							dmap[category.sid] = category;
							that.state.categoryMap[category.sid] = category;
							that.state.categoryList.push(category);
						}
					})
				}	
				that.setState({});
			});
		})

		
	},
	showLoad : function(){
		Toast.info(<LodingState/>,10);
	},
	hideLoad : function(){
		Toast.hide();
	},
	openFile : function(d,e){
		Toast.info(<LodingState/>,10);
		docDetail.className = "show";
		

		if(this.state.currentView == "doc"){
			if(this.state.showTab == "all"){
				sessionData.allDocs.docs.map((doc)=>{
					if(doc.docid == d.docid){
						doc.isnew = "0";
						return;
					}
				})
			}else if(this.state.showTab == "my"){
				sessionData.myDocs.docs.map((doc)=>{
					if(doc.docid == d.docid){
						doc.isnew = "0";
						return;
					}
				})
			}else if(this.state.showTab == "collect"){
				sessionData.collectDocs.docs.map((doc)=>{
					if(doc.docid == d.docid){
						doc.isnew = "0";
						return;
					}
				})
			}
		}else if(this.state.currentView == "category"){
			let that = this;
			sessionData.categorys[this.state.categoryid].docs.map((doc)=>{
				if(doc.docid == d.docid){
					if(doc.isnew == "1"){
						
						let pids = that.state.pids;
						try{
							if(pids && pids.length > 1){
								let _cateid = pids[pids.length - 2];
								if(sessionData.categorys[_cateid] && sessionData.categorys[_cateid].categorys){
									sessionData.categorys[_cateid].categorys.map((c)=>{
										if(c.sid == that.state.categoryid && c.noReadNum && c.noReadNum > 0){
											c.noReadNum = c.noReadNum - 1;
										}
									})
								}
							}
						}catch(e){}

						if(sessionData.categorys[that.state.categoryid].noReadNum && sessionData.categorys[that.state.categoryid].noReadNum > 0){
							sessionData.categorys[that.state.categoryid].noReadNum = sessionData.categorys[that.state.categoryid].noReadNum - 1;
							console.info(sessionData.categorys[that.state.categoryid].noReadNum)
						}
					}
					doc.isnew = "0";
				}
			})
		}
		let _localStorageSystemDoc = localStorage.systemDoc ? JSON.parse(localStorage.systemDoc) : {};
		_localStorageSystemDoc.sessionData = sessionData;
		localStorage.systemDoc = JSON.stringify(_localStorageSystemDoc);

		if(document.getElementById("noread_" + d.docid)){
			document.getElementById("noread_" + d.docid).style.display = "none";
		}


		setTimeout(function(){
			docDetail.childNodes[0].src = "/mobile/plugin/networkdisk/docDetail.jsp?docid=" + d.docid + "&sessionkey=" + sessionkey + "&module=" + moduleid + "&scope=" + scope;
		},500);
	},
	iframeShow : function(d,e){
		if(d.hideLoad){
			Toast.hide();
		}
		e.target.style.display = "block";
	},
	openFolder : function(d,e){
		if(!d){
			return;
		}else if(d.type == "nav"){ //点击头部导航
			let nids = [];
			let npath = [];
			for(let i = 0;i < this.state.pids.length;i++){
				nids.push(this.state.pids[i]);
				npath.push(this.state.path[i]);
				if(d.id == this.state.pids[i]){
					break;
				}
			}
			this.state.pids = nids;
			this.state.path = npath;
		}else if(d.type == "icon"){ //点击列表图标
			this.state.pids.push(d.id);
			this.state.path.push(d.name)
		}else{
			return;
		}
		pageNum = 1;
		this.state.categoryid = d.id;
		if(d.id == 0){
			state.islast = 1;
		}
		this.onRefresh(true);
	},
	onSelectDoc : function(d,e){ //选中文档
		if(this.state.chooseFileMap[d.docid]){
			delete(this.state.chooseFileMap[d.docid]);
		}else{
			this.state.chooseFileMap[d.docid] = d;
		}
		this.state.totalSize = this.state.totalSize - (this.state.chooseFileMap[d.docid] ? -1 : 1);
		this.setState({});
	},
	comfirmChoose : function(){ //确认选择文档操作
		chooseDocFn(this.state.chooseFileMap);
	},
	render : function (){
		if(this.state.searchStatus == 1){
			maxWindowHeight = maxWindowHeight >  window.innerHeight ? maxWindowHeight : window.innerHeight;
			resultDivHeight = maxWindowHeight - 39*window.viewportScale;
		}else{
			maxWindowHeight = maxWindowHeight >  window.innerHeight ? maxWindowHeight : window.innerHeight;
			resultDivHeight = maxWindowHeight - (this.state.currentView == "category" ? 118 : 121)*window.viewportScale;
		}
		let that = this;
		return (
			<div>
				<SystemHeader
					keyword={this.props.keyword}
					placeholder={this.props.promptStr}
					searchStatus={this.state.searchStatus}
					onSearch={this.onSearch}
					onCancel={this.onCancel}
					onChange={this.onChange}
					focus={this.focus}
				/>
				{
					this.state.searchStatus == 0 && this.state.currentView == "doc" &&
					<SystemDocTab
						showTab={this.state.showTab}
						onChangeDocTab={this.onChangeDocTab}
					/>
				}
				{
					this.state.currentView == "category" && this.state.searchStatus == 0 ?
					<NavPath path={this.state.path} clientEvent={this.openFolder} ids={this.state.pids}/>
					:
					<div className="searchLine"></div>
				}
				<div id="content">
					<ul>
						<List>
							{
								this.state.searchHistory == 0 && this.state.searchStatus == 1 ?

								<li style={{height : resultDivHeight}}>
									<div className="historyTitle">
										{this.state.historyList.length > 0 ? FontList.searchHistory : FontList.searchHistoryNo}
									</div>
									<div className="historyList">
										{
											this.state.historyList.map((data,i)=>{
												return (
													<div onClick={that.onSearchByHistory.bind(this,{data},{i})}>{data}</div>
												)
											})
										}
										{
											this.state.historyList.length > 0 &&
											<div className="clearHistory" onClick={this.clearHistory}>{FontList.clearHistory}</div>
										}
									</div>
								</li>

								:

								<FileListView 
									docs={this.state.docList}
									categorys={this.state.categoryList}
									searchStatus={this.state.searchStatus}
									currentView={this.state.currentView}
									chooseFileMap={this.state.chooseFileMap}
									islast={state.islast}
									isLoading={state.isLoading}
									isFirst={pageNum <= 2 ? 1 : 0}
									loadMore={this.loadMore}
									onRefresh={this.onRefresh}
									openFile={this.openFile}
									openFolder={this.openFolder}
									onSelectDoc={this.onSelectDoc}
								/>
							}
						</List>
					</ul>	
				</div>
				{
					window.DEFAULT_VIEW == "ChooseSystemDoc" ?
					<DiskFootTabChoose 
						totalSize={this.state.totalSize}
						comfirmChoose={this.comfirmChoose}
					/>
					:
					this.state.searchStatus == 0 ?
					<div className="diskFoot firstInPage">
						<DiskFootTab 
							currentView={this.state.currentView}
							categoryid={this.state.categoryid}
							categoryMap={this.state.categoryMap}
							docView={this.docView}
							categoryView={this.categoryView}
						/>
					</div>
					:
					<div></div>
				}

				{
					state.successInfo == 1 &&
					<SuccessState msg={state.successMsg}/>

				}

				<div id="docDetail">
					<iframe frameborder="0" scrolling="no" width="100%" height="100%" onLoad={this.iframeShow.bind(this,{hideLoad : false})}></iframe>
				</div>
				<div id="docReply">
					<iframe frameborder="0" scrolling="no" width="100%" height="100%" onLoad={this.iframeShow.bind(this,{hideLoad : false})}></iframe>
				</div>
				<div id="attrDetail">
					<iframe frameborder="0" scrolling="no" width="100%" height="100%" onLoad={this.iframeShow.bind(this,{hideLoad : true})}></iframe>
				</div>
			</div>
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

const NavPath = React.createClass({
	render : function(){
		let that = this;
		return(	
			<div className="publicNav">
				<ul id="breadcrumbs-one">
					{
						this.props.path.map((data,i)=>{
							return (
								<li key={i}>
									<a data-from="nav" onClick={that.props.clientEvent.bind(this,{id:that.props.ids[i],type:'nav'})}>{data}</a>
								</li>
							)
						})
					}
				</ul>
			</div>
		)
	}
});

const SystemHeader = React.createClass({
	toDiskDoc : function(){
		//Toast.info(<LodingState/>,10);
		//setTimeout(function(){
			hashHistory.pushState(null,"/",{back2Disk : 1});
		//},100);
	},
	render : function(){
		return (

			<div className="diskHeader systemHeader">
				
				<div style={{width:'100%'}}>
					{	
						this.props.searchStatus == 0 ?   //非搜索状态
						window.DEFAULT_VIEW == "ChooseSystemDoc" ?
						<div className="systemSearch">
							<div className="searchIn" onClick={this.props.focus}>
								<div className="searchIcon"></div>请输入文档名称
							</div>
						</div>
						:
						<div className="DiskHeaderTab">
							<div className="diskAddFolder">
								<div className="empty"></div>
							</div>
							<div className="diskSystemTab">
								<div>
									<div className="myDiskTab" onClick={this.toDiskDoc}>
										<div>我的云盘</div>
									</div>
									<div className="systemTab select">
										<div>系统目录</div>
									</div>	
								</div>
							</div>
							<div className="searchIcon" onClick={this.props.focus}></div>
						</div>
						:    //搜索状态
						<div>
							<div className="diskSearch">
								<SearchBar 
									 value={this.props.keyword}
									 placeholder={this.props.promptStr}
									 showCancelButton={true}
									 onSubmit={this.props.onSearch}
									 onCancel={this.props.onCancel}
									 onChange={this.props.onChange}
								  />
							</div>
						</div>
					}
				</div>
				
					
			</div>
		)
	}
})

const DiskFootTab = React.createClass({
	showBtn : function(e){
		showBtn2System(e);
	},
	render : function(){
		let files1 = [];
		let that = this;
		return (
			<div className="diskTab">
				<div className="myDisk">
					<div className="footImg">
						<img src={this.props.currentView == "doc" ? IconList.docIconChecked : IconList.docIcon} onClick={this.props.docView}/>
					</div>
					<div className="footFont">
						<font style={this.props.currentView == "doc" ? blueStyle : {}} onClick={this.props.docView}>文档</font>
					</div>
				</div>
				<div className="add">
					{
						this.props.currentView == "category" && this.props.categoryMap[this.props.categoryid] && this.props.categoryMap[this.props.categoryid].canCreateDoc == 'true' ?
						<img onClick={this.showBtn} src={IconList.addIcon}/>
						:
						<img src={IconList.addNoIcon}/>
					}
				</div>
				<div>
					<div className="footImg">
						<img src={this.props.currentView == "category" ? IconList.categoryIconChecked : IconList.categoryIcon} onClick={this.props.categoryView}/>
					</div>
					<div className="footFont">
						<font style={this.props.currentView == "category" ? blueStyle : {}} onClick={this.props.categoryView}>目录</font>
					</div>
				</div>
			</div>
		)
	}
	
})

const DiskFootTabChoose = React.createClass({
	render : function(){
		return (
			<div className="diskFoot firstInPage chooseFileFoot">
				<div style={{textAlign:"right"}}>
					<a className="chooseFileBtn" onClick={this.props.comfirmChoose}>确定(<span id="chooseNum">{this.props.totalSize}</span>)</a>
				</div>
			</div>
		)
	}
})

const SystemDocTab = React.createClass({
	render : function(){
		return (
			<div className="systemDocTab">
				<ul>
					<li onClick={this.props.onChangeDocTab.bind(this,{tab:'all'})} className={"docTab" + (this.props.showTab == "all" ? " select" : "")}>
						<div><div className="blueLine"></div>全部文档</div>
						
					</li>
					<li><div className="yLine"></div></li>
					<li onClick={this.props.onChangeDocTab.bind(this,{tab:'my'})} className={"docTab" + (this.props.showTab == "my" ? " select" : "")}>
						<div><div className="blueLine"></div>我的文档</div>
						
					</li>
					<li><div className="yLine"></div></li>
					<li onClick={this.props.onChangeDocTab.bind(this,{tab:'collect'})} className={"docTab" + (this.props.showTab == "collect" ? " select" : "")}>
						<div><div className="blueLine"></div>我的收藏</div>
						
					</li>
				</ul>
			</div>
		)
	}
})


const FileListView = React.createClass({
	getInitialState : function(){
		const dataSource = new ListView.DataSource({
			rowHasChanged : (row1,row2) => row1 !== row2
		});
		this.initData=[];
		this.dataList=[];
		for(let i = 0;i < this.props.categorys.length;i++){
			this.props.categorys[i].datatype = "category";
			this.dataList.push(this.props.categorys[i]);
		}
		for(let i = 0; i < this.props.docs.length;i++){
			this.props.docs[i].datatype = "doc";
			this.dataList.push(this.props.docs[i]);
		}
		initialListSize = this.dataList.length;
		this.initData = JSON.parse(JSON.stringify(this.dataList));
		let _chooseMap = this.props.chooseFileMap;
		this.initData.map((data)=>{
			if(_chooseMap[data.docid]){
				data.checked = true;
			}else{
				data.checked = false;
			}
		})
		return {
			dataSource : dataSource.cloneWithRows(this.initData),
			islast : this.props.islast,
			refreshing : false,
			back2Top : true,
			isLoading : state.isLoading
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
		if(this.state.back2Top){
			this.setState({back2Top : false});
		}
	},
	componentDidMount : function(){
		if(this.isMounted()){
			if(this.state.back2Top && this.initData.length > 0){
				this.setState({back2Top : false});
			}
		}
	},
	componentWillReceiveProps : function(nextProps){
		if(nextProps.isFirst == 1 && state.onlyRearsh == 0){
			this.dataList = [];
			renderRow = pageSize;
			this.state.back2Top = true;
		}
		
		if(state.onlyRearsh == 0){
			for(let i = 0; i < nextProps.categorys.length;i++){
				nextProps.categorys[i].datatype = "category";
				this.dataList.push(nextProps.categorys[i]);
			}
			for(let i = 0;i < nextProps.docs.length;i++){
				nextProps.docs[i].datatype = "doc";
				this.dataList.push(nextProps.docs[i]);
			}
		}

			
		this.initData = JSON.parse(JSON.stringify(this.dataList));

		let _chooseMap = this.props.chooseFileMap;
		this.initData.map((data)=>{
			if(_chooseMap[data.docid]){
				data.checked = true;
			}else{
				data.checked = false;
			}
		})

		state.onlyRearsh = 0;
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
		//	this.state.refreshing = true;
			this.props.onRefresh();
		}
	},
	render : function(){
		let that = this;
		const row = (rowData,sectionID,rowID) => {
			return (
				<List.Item className={rowData.datatype == "doc" && rowData.isDelete ? "isDelete" : ""} key={rowData.datatype == "doc" ? rowData.docid : rowData.sid}>
					<li onClick={
							window.DEFAULT_VIEW == "ChooseSystemDoc" ? this.props.onSelectDoc.bind(this,{
								docid:rowData.docid,
								title:rowData.docTitle,
								author:rowData.username,
								createrid:rowData.userid,
								createTime:rowData.createTime,
								status:1,
								attchmentType:rowData.doctype
							}) :
							rowData.datatype == "doc" ? that.props.openFile.bind(this,{docid:rowData.docid}) : 
								that.props.openFolder.bind(this,{id:rowData.sid,type:'icon',name:rowData.sname})}>
						<div className={"diskUnit" + (window.DEFAULT_VIEW == "ChooseSystemDoc" ? " left" : " right systemUnit")}>
							{
								window.DEFAULT_VIEW == "ChooseSystemDoc" &&
								<div className="diskCheck">
									<img src={rowData.checked ? IconList.checkedYes : IconList.checkedNo}/>
								</div>
							}
							<div className="diskIcon">
								<img src={IconPath + (rowData.datatype == "doc" ? rowData.icon : IconList.folderIcon)} />
							</div>
							{
								rowData.datatype == "doc" ?  //文档
								<div className="diskContent">
									<div className="diskName" >
										{rowData.docTitle}
									</div>
									<div className="username">{rowData.username}</div>
									<div className="diskTime">{rowData.updateTime}</div>
									<div className="clearBoth"></div>
								</div>	
								:  //目录
								<div className="diskContent line_1">
									<div className="diskName" >
										{rowData.sname}
									</div>
								</div>	
							}

							{
								rowData.datatype == "doc" ?  //文档
								<div className={rowData.isnew == "1" ? "fileNoRead" : ""} id={"noread_" + rowData.docid}>
									{
										rowData.isnew == "1" &&
										<img src="/mobile/plugin/networkdisk/img/fileNoRead.png"/>
									}
								</div>
								:     //目录
								<div className={rowData.noReadNum && rowData.noReadNum > 0 ? "folderNoRead" : ""}>
									{
										rowData.noReadNum && rowData.noReadNum > 0 &&
										<img src="/mobile/plugin/networkdisk/img/folderNoRead.png"/>
									}
									{
										rowData.noReadNum ? 
										rowData.noReadNum > 99 ?
										"未读99+"
										:
										rowData.noReadNum > 0 ?
										("未读" + rowData.noReadNum)
										:
										""
										:
										""
									}
								</div>
							}
						</div>
					</li>
				</List.Item>
			)
		}

		return (
			this.state.back2Top ? 
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
							<img className="folderEmpty"  src={IconList.folderEmpty}/>
							<div className="emptyInfo">
								{this.props.searchStatus == 1 ? FontList.searchNoFile : this.props.currentView == "category" ? FontList.dataEmptyFont : "没有相关文档!"}
							</div>
							
						</div>	
					 </li>
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

export default SystemDoc;
