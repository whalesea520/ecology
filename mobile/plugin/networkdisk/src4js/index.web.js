import { SearchBar,List,ListView,RefreshControl } from 'antd-mobile';
import { Modal, Button, WhiteSpace, WingBlank,Toast} from 'antd-mobile';
import { Popup, Icon } from 'antd-mobile';
import { Router, Route, hashHistory,Link } from 'react-router';
import ReactCSSTransitionGroup from 'react-addons-css-transition-group';
import 'whatwg-fetch';
import React from 'react';
import ReactDOM from 'react-dom';

import SystemDoc from './system-doc.web.js';

import './disk.css';

const alert = Modal.alert;


//let folderList = folders;
//let fileList = files;
let folderList = [];
let fileList = [];
pageNum = 1;
let initialListSize = folderList.length + fileList.length;

let maxWindowHeight = 0;
let resultDivHeight  = 300;

let IconPath = "/mobile/plugin/networkdisk/img/";
let IconList = {
	createIcon : '/mobile/plugin/networkdisk/img/create.png', //新建目录图标
	shareIconSim : '/mobile/plugin/networkdisk/img/doshare.png',//单个分享图标
	cancelShareIconSim : '/mobile/plugin/networkdisk/img/cancel_share.png',//取消分享
	shareIconMul : '/mobile/plugin/networkdisk/img/share.png', //批量分享图标
	publicIconSim : '/mobile/plugin/networkdisk/img/public.png',//单个分享图标
	publicIconMul : '/mobile/plugin/networkdisk/img/public_mul.png',//批量发布图标
	deleteIconSim : '/mobile/plugin/networkdisk/img/delete_sim.png',//单个删除
	deleteIconMul : '/mobile/plugin/networkdisk/img/delete.png',//批量删除
	moreIconSim : '/mobile/plugin/networkdisk/img/more_sim.png',//单个操作更多
	moreIcon : '/mobile/plugin/networkdisk/img/more.png',//更多
	addNoIcon : '/mobile/plugin/networkdisk/img/add_no.png', //(底部)添加图标
	addIcon : '/mobile/plugin/networkdisk/img/add.png', //(底部)添加图标
	diskIcon : '/mobile/plugin/networkdisk/img/disk.png', //(底部)云盘图标
	diskIconChecked : '/mobile/plugin/networkdisk/img/disk_checked.png', //(底部)云盘选中图标
	shareIcon : '/mobile/plugin/networkdisk/img/share.png', //(底部)分享图标
	shareIconChecked : '/mobile/plugin/networkdisk/img/share_checked.png', //(底部)分享选中图标
	folderIcon : '/mobile/plugin/networkdisk/img/2.png', //文件夹图标
	folderEmpty : '/mobile/plugin/networkdisk/img/empty.png',
	publicEmpty : '/mobile/plugin/networkdisk/img/public_empty.png',
	shareMyEmpty :'/mobile/plugin/networkdisk/img/shareMy_empty.png',
	myShareEmpty :'/mobile/plugin/networkdisk/img/myShare_empty.png',
	diskEmpty : '/mobile/plugin/networkdisk/img/disk_empty.png',
	checkedNo : '/mobile/plugin/networkdisk/img/check_icon_no.png', //多选（未选中）
	checkedYes : '/mobile/plugin/networkdisk/img/check_icon_yes.png', //多选（选中)
	shrinkage: '/mobile/plugin/networkdisk/img/down.png',//收缩
	stretch : '/mobile/plugin/networkdisk/img/up.png'//展开
}

let blueStyle = {
	color : "#017afd"
}

let selectMap = {
	fileIndex : "",
	folderIndex : ""
}

let state = {
	showIndex : -1,
	showType : '',
	operateType : 'view',
	operateView : 'right',
	currentView : VIEW_TYPE == '' ? 'disk' : VIEW_TYPE,
	createDialog : false,
	renameDialog : false,
	isLoading : 0,
	listFreash : 0,
	firstInPage : 1,
	backFreash : 0, //返回刷新 0-不操作，1-刷新，2-还原state,3-搜索
	diskState : {},
	resizeHeight : 1, //是否重新计算高度
	successInfo : 0, //是否弹出成功提示
	successMsg : "",//成功提示信息
	sharetime : SHARETIME,//分享时间
	sharefrom : SHAREFROM,//分享来源
	chooseNum : 0 //选中的文件、文件夹数量（CHOOSE_FILE = 1时，即选择文件时）
}


let sessionData = {
	diskSeatchList : [],
	shareSearchList : [],
	diskData : {},
	shareMyData : {},
	myShareData : {}
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

let Disk = React.createClass({
	getInitialState : function(){
		window.DiskObj = this;

		prevStep = ()=>{
			this.prev();
		}
		getPid = ()=>{
			return state.currentView == "disk" && this.state.operateType == "view" ? this.state.folderid : 1;
		}

		return {
			keyword : '',  //搜索关键字(用于显示)
			searchTxt : '', //搜索关键字(用于查询)
			folderList : folderList, //文件夹数据集
			fileList : fileList, //文件数据集
			searchStr : FontList.searchStr, //搜索按钮
			promptStr : FontList.promptStr, //输入框内提示文字
			showIndex : state.showIndex,  //展开项下标
			showType : state.showType,     //展开的类型（文件、文件夹） file , folder
			operateType : state.operateType,   //主视图、选项视图 view ,operate
			operateView : state.operateView,  //显示左侧操作（选项）、还是右侧操作（展开、收缩） left，right
			currentView : state.currentView, //当前视图（云盘、我的分享，同事的分享）disk,myShare,shareMy(operateType为view时)
			createDialog : state.createDialog, //是否显示新建目录dialog
			renameDialog : state.renameDialog, //是否显示重命名dialog
			path : [FontList.diskFont],//导航路径
			searchStatus : 0,
			searchHistory : 1,
			historyList : [],
			pids : PIDS,
			folderid : FOLDER_ID == "" ? 0 : FOLDER_ID,
			islast : 0,
			isFirst : 1,
			back2Disk : this.props.location.query.back2Disk ? this.props.location.query.back2Disk : 0//返回到云盘根目录(由系统目录点回来时)
		}
	},
	componentDidMount : function(){
		if(this.isMounted()){
			Toast.hide();
			pageNum = 1;
			if(state.backFreash == 1){
				state.backFreash = 0;
				state.diskState.fileList = [];
				state.diskState.folderList = [];
				this.setState(state.diskState);
				DETAULT_PATH = state.diskState.path;
				PIDS = state.diskState.pids;
				this.removeSession(state.diskState.folderid,state.currentView);

				if(state.mesList && state.mesList.length > 0){
					sendCancel2Msg(state.mesList);
					state.mesList = [];
				}

				this.openFolder(state.diskState.folderid,true);
			}else if(state.backFreash == 2){
				state.backFreash = 0;
				//state.diskState.fileList = [];
				//state.diskState.folderList = [];
				state.listFreash = 1;
				this.setState(state.diskState);
			}else if(state.backFreash == 3){
				state.backFreash = 0;
				state.diskState.fileList = [];
				state.diskState.folderList = [];
				this.setState(state.diskState);
				this.state = state.diskState;
				this.onSearch();
			}else{
				if(state.firstInPage == 1){
					state.firstInPage = 0;
					let folderid = 0;
					let defaultPostion = false;
					if(VIEW_TYPE != ''){
						folderid = FOLDER_ID;
						defaultPostion = true;
						if(SHARE_FLAG == 2){
							state.successInfo = 1;
							state.successMsg = "文件夹已不存在!";
							SHARE_FLAG = 0;
						}else if(SHARE_FLAG == 3){
							state.successInfo = 1;
							state.successMsg = "分享已取消!";
							SHARE_FLAG = 0;
						}
					}
					let that = this;
					this.getCookie().then(function(data){
						sessionData.diskSeatchList = data;
						that.openFolder(folderid,defaultPostion);
					})
		 		}else if(this.state.back2Disk == 1){
		 			this.diskView();
		 		}
		 	}
	 	}
	}, 
	componentDidUpdate : function(){
		let title = this.state.path[this.state.path.length - 1];
		if(title == "/"){
			if(this.state.currentView == "disk"){
				title = FontList.diskFont;
			}else if(this.state.currentView == "shareMy"){
				title = FontList.shareFont;
			}else if(this.state.currentView == "myShare"){
				title = FontList.shareFont;
			}
		}


		
		if(this.state.renameDialog){
			let dataMap = this.getSelectId();
			let folderids = dataMap.folderid;
			let fileids = dataMap.fileid;
			let renameTxt = "";
			let extname = "";
			if(folderids != ""){
				for(let i = 0 ;i < folderList.length;i++){
					if(folderList[i].id == folderids){
						renameTxt = folderList[i].name;
						break;
					}
				}
			}else if(fileids != ""){
				for(let i = 0 ;i < fileList.length;i++){
					if(fileList[i].id == fileids){
						renameTxt = fileList[i].name;
						break;
					}
				}
				extname = renameTxt.indexOf(".") > -1 ? renameTxt.substring(renameTxt.lastIndexOf(".")) : "";
				renameTxt = renameTxt.indexOf(".") > -1 ? renameTxt.substring(0,renameTxt.lastIndexOf(".")) : renameTxt;
			}
			document.getElementById("renameTxt").value = renameTxt;
			document.getElementById("extname").value = extname;
		}

		showTitle(title);



		let $obj = document.getElementById("breadcrumbs-one");
		if($obj){
			let _childWidth = 0;
			let $childNodes = $obj.childNodes;
			
			for(let i = 0;i < $childNodes.length;i++){
				_childWidth += $childNodes[i].clientWidth;
			}

			let mwidth = 80;
			try{
				mwidth = window.getComputedStyle(document.getElementById("breadcrumbs-one").childNodes[0].childNodes[0]).width;
				mwidth = mwidth.replace("px","")
			}catch(e){
				mwidth = 80;
			}
			$obj.style.width = _childWidth + parseInt(mwidth) + "px";
		}

		if(this.state.searchStatus == 1 && this.state.searchHistory != 2){
			if(document.getElementsByClassName("am-search-value").length > 0){
				document.getElementsByClassName("am-search-value")[0].focus();
			}
		}

		iosSearchKey();

	},
	onSearch : function(){ //搜索

		if(document.getElementsByClassName("am-search-value").length > 0){
			document.getElementsByClassName("am-search-value")[0].blur();
		}
		let that = this;
		this.state.searchStatus = 1;
		this.state.searchTxt = this.state.keyword;
		this.getDataList(this.state.folderid,true,state.currentView).then((data)=>{
			folderList = data.folders;
			fileList = data.files;
			let islast = 0;
			if(state.currentView != "disk" || fileList.length < pageSize){ //不是云盘下的搜索，或者是云盘下的搜索，搜索到的数据小于每页显示数量
				islast = 1;
			}
			state.listFreash = 1;
			

			that.getCookie().then(function(data){
				if(that.state.currentView == "disk"){
					sessionData.diskSeatchList = data;
				}else{
					sessionData.shareSearchList = data;
				}
				
				that.setState({
					folderList : folderList,
					fileList : fileList,
					searchTxt : that.state.keyword,
					searchHistory : 2,
					showIndex : -1,
					showType : '',
					isFirst : 1,
					islast : islast
				})
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
		let type = state.currentView == "disk" ? 0 : 1;
		state.isLoading = 1;
		Toast.info(<LodingState/>,10);
		let that = this;
		new Promise((resolve,reject)=>{
	      fetch('/mobile/plugin/networkdisk/historySearch.jsp?sessionkey=' + sessionkey + '&method=clearHistory&type=' + type, {
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
	    	if(that.state.currentView == "disk"){
					sessionData.diskSeatchList = [];
				}else{
					sessionData.shareSearchList = [];
				}
	    	that.setState({
	    		historyList : []
	    	});
	    });	
	},
	onChange : function(value){ //搜索，输入文字填充到输入框
		this.setState({keyword : value});
	},
	onCreateFolder : function(){ //弹出新建目录
		state.createDialog = true;
		state.listFreash = 1;
		state.resizeHeight = 0;
		this.setState({createDialog : state.createDialog});
	},
	onSaveFolder : function(){//保存新建的目录
		that = this;

		let _filename = folderName.value.trim();
		if(_filename == ""){
			alert(FontList.folderNameEmpty);
			return;
		}

		if(/[\\/:*?"<>|]/.test(_filename)){
			alert(<div>
					<div>{FontList.nameNotContains}</div>
					<div>{"\\/:*?\"<>|"}</div>
				</div>);
			return;
		}
		if(this.isEmoji(_filename)){
			alert(FontList.nameNotEmoj);
			return;
		}

		state.isLoading = 1;
		Toast.info(<LodingState/>,10);
		new Promise((resolve,reject)=>{
	      fetch('/mobile/plugin/networkdisk/getDataList.jsp?sessionkey=' + sessionkey + '&method=createFolder&folderid=' + this.state.folderid + '&name=' + _filename, {
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
	    	if(data.flag == 1){
	    		let folder = data.folder;
		        let newFolderList = [folder];
				folderList.map((data)=>{
					newFolderList.push(data);
				});
				folderList = newFolderList;

				
				let _f = [];
				for(let key in folder){
					_f[key] = folder[key];
				}
				let _nf = [_f];
				let _sessionData = that.getSessionData(that.state.folderid,state.currentView);
				if(_sessionData != null){
					_sessionData.data.folders.map((data)=>{
						_nf.push(data);
					})
					_sessionData.data.folders = _nf;
				}else{
					_sessionData = {};
					_sessionData.data = {
						folders : folderList,
						files : []	
					}
					sessionData.diskData[that.state.folderid] = _sessionData;

				}


				state.createDialog = false;
				folderName.value = "";
				state.listFreash = 1;
				state.resizeHeight = 0;
				that.setState({folderList : folderList,createDialog : state.createDialog});
	    	}else if(data.flag == -1){
	    		alert(FontList.folderNameExist);
	    	}
	    });
		
	},

	onCloseDialog : function(type){
		if(type == "create"){
			state.createDialog = false;
		}else if(type == "rename"){
			state.renameDialog = false;
		}
		state.listFreash = 1;
		state.resizeHeight = 0;
		this.setState({createDialog : state.createDialog,renameDialog : state.renameDialog});
	},
	operateShow : function(e){ //展开单个文件、目录的操作项（分享、发布）
		if(state.longTouch == 1){
			return;
		}
		let $obj = e.target;
		let _id = $obj.getAttribute("data-dataid");
		let _type = $obj.getAttribute("data-datatype");
		let _shareid = $obj.getAttribute("data-shareid");
		
		if(_shareid){
			state.showIndex = _shareid == this.state.showIndex && _type == this.state.showType ? -1 : _shareid;
		}else{
			state.showIndex = _id == this.state.showIndex && _type == this.state.showType ? -1 : _id;
		}
		state.showType = _type;

	
		for(let i = 0;i < folderList.length;i++){
			if((!_shareid || _shareid == folderList[i].shareid) && folderList[i].id == _id){
				if(state.showIndex == -1){
					folderList[i].operateShow = false;
				}else{
					folderList[i].operateShow = true;
				}
			}else{
				folderList[i].operateShow = false;
			}
			
		}
		for(let i = 0;i < fileList.length;i++){
			if((!_shareid || _shareid == fileList[i].shareid) && fileList[i].id == _id){
				if(state.showIndex == -1){
					fileList[i].operateShow = false;
				}else{
					fileList[i].operateShow = true;
				}
			}else{
				fileList[i].operateShow = false;
			}
		}
		state.listFreash = 1;
		this.setState({showIndex : state.showIndex,showType : state.showType,isFirst : 0,fileList : fileList,folderList : folderList});
	},
	onSelect : function(e){ //选择文档、目录
		if(state.longTouch == 1){
			return;
		}
		let $obj = e.target;
		while($obj.tagName != "LI"){
			$obj = $obj.parentNode;
		}
		let _id = $obj.getAttribute("data-dataid");
		let _type = $obj.getAttribute("data-datatype");
		state.listFreash = 1;


		if(_type == "folder"){
			for(let i = 0;i < folderList.length;i++){
				if(folderList[i].id == _id){
					folderList[i].checked = folderList[i].checked ? false : true;
					state.chooseNum = folderList[i].checked ? (state.chooseNum + 1) : (state.chooseNum - 1);
				}
			}

			this.setState({folderList : folderList});
		}else if(_type == "file"){
			for(let i = 0;i < fileList.length;i++){
				if(fileList[i].id == _id){
					fileList[i].checked = fileList[i].checked ? false : true;
					state.chooseNum = fileList[i].checked ? (state.chooseNum + 1) : (state.chooseNum - 1);
				}
			}
			this.setState({fileList : fileList});
		}
		
	},
	toSelect : function(){ //跳转到选择状态
		let operateView = this.state.operateView == "right" ? "left" : "right";
		let operateType = "view";
		if(operateView == "left"){
			operateType = "operate"
			folderList.map((data,i)=>{
				data.checked = false;
				data.operateShow = false;
			});
			fileList.map((data,i)=>{
				data.checked = false;
				data.operateShow = false;
			});
		}
		state.showIndex = -1;
		state.showType = "";
		state.operateType = operateType;
		state.operateView = operateView;
		state.listFreash = 1;
		this.setState({
			operateView : state.operateView,
			operateType : state.operateType,
			showIndex : state.showIndex,
			showType : state.showType,
			folderList : folderList,
			fileList : fileList
		})
	},
	checkAll : function(){ //全选
		fileList.map((data)=>{
			data.checked = true;
		});
		folderList.map((data)=>{
			data.checked = true;
		});
		state.listFreash = 1;
		this.setState({fileList : fileList,folderList : folderList});
	},
	prev : function(){//返回
		let that = this;


		if(this.state.operateType == "operate"){
			this.toSelect();
			return;
		}

		if(this.state.folderid == 0){
			//window.history.back();
			this.diskView();
			return "";
		}

		this.openFolder(this.state.pids[this.state.pids.length > 1 ? (this.state.pids.length - 2) : 0])
	},
	onShareSimple : function(e){ //单个分享
		let type = e.target.getAttribute("data-datatype");
		let id = e.target.getAttribute("data-dataid");
		toShare({
			fileid : type == "file" ? id : "",
			folderid : type == "folder" ? id : ""
		});
	},
	onShareMul : function(){ //多个分享
		let dataMap = this.getSelectId();
		if(dataMap.fileid == "" && dataMap.folderid == ""){
			alert(FontList.shareNoSelect);
			return;
		}
		toShare(dataMap);
	},
	doShare : function(params,fn){ //分享
		state.isLoading = 1;
		Toast.info(<LodingState/>,10);
		new Promise((resolve,reject)=>{
	      fetch('/mobile/plugin/networkdisk/getDataList.jsp?sessionkey=' + sessionkey + '&method=share&folderid=' + this.state.folderid + '&' + params, {
	        method: 'POST',
	        mode: 'same-origin',
	        headers: {'Content-Type': 'application/json; charset=utf-8'},
	        credentials: 'include'
	      })
	      .then(function(res) {
	          let data=res.json();
	          Toast.hide();
	          state.isLoading = 0;
	          return data;
	      }).then(function(data) {
	          resolve(data);
	      })
	      .catch(function(e) {
	          console.log("error",e);
	      });
	    }).then(function(data){
	    	if(typeof(fn) == "function"){
	    		fn(data);
	    	}
	    	if(data && data.flag == 1){
	    		DETAULT_PATH = that.state.path;
	    		PIDS = that.state.pids;
	    		that.openFolder(that.state.folderid,true);
	    	}else{
	    		alert(FontList.shareError);
	    	}
	    });
	},
	onPublicMul : function(){//未选中文件或者文件夹发布
		alert(FontList.publicNoData);
	},
	onMoreSimple : function(){
		this.onMore();
	},
	onDeleteSimple : function(e){
		let type = e.target.getAttribute("data-datatype");
		let id = e.target.getAttribute("data-dataid");
		this.doDelete({
			fileid : type == "file" ? id : "",
			folderid : type == "folder" ? id : ""
		})
	},
	onDeleteMul : function(){ //删除多个
		let selectMap =  this.getSelectId();
		if(selectMap.fileid == "" && selectMap.folderid == ""){
			alert(FontList.deleteNoData);
			return;	
		}
		this.doDelete(selectMap);
	},
	doDelete : function(selectMap){
		
		let that = this;
		alert(FontList.confirmDel,"",[
			{text : FontList.cancel,onPress : () => console.log("cancel")},
			{text : FontList.ensure,onPress : () => {
				state.isLoading = 1;
			    Toast.info(<LodingState/>,10);
				new Promise((resolve,reject)=>{
				      fetch('/mobile/plugin/networkdisk/getDataList.jsp?sessionkey=' + sessionkey + '&method=delete&folderids=' + selectMap.folderid + '&fileids=' + selectMap.fileid, {
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
				    	if(data && data.flag == 1){
				    		that.removeView(selectMap);
				    	}else if(data && data.flag == -1){
				    		alert(FontList.deleteNotEmpty);
				    	}
				    });
			}}
		]);
	},
	getnamebyid : function(id,type){
		if(type == "pdoc"){
			for(var i = 0;i < fileList.length;i++){
				if(id == fileList[i].id){
					return fileList[i].name;
				}
			}
		}else if(type == "folder"){
			for(var i = 0;i < folderList.length;i++){
				if(id == folderList[i].id){
					return folderList[i].name;
				}
			}
		}
		return "";
	},
	removeView : function(selectMap){
		let newFolderList = [];
		let newFileList = []
		for(let i = 0;i < folderList.length;i++){
			if(selectMap.folderid != "" && selectMap.folderid.indexOf(",") == -1){
				if(folderList[i].id != selectMap.folderid){
					newFolderList.push(folderList[i]);
				}
			}else if(!folderList[i].checked){
				newFolderList.push(folderList[i]);
			}
		}
		for(let i = 0;i < fileList.length;i++){
			if(selectMap.fileid != "" && selectMap.fileid.indexOf(",") == -1){
				if(fileList[i].id != selectMap.fileid){
					newFileList.push(fileList[i]);
				}
			}else if(!fileList[i].checked){
				newFileList.push(fileList[i]);
			}
		}


		let _sessionData = this.getSessionData(this.state.folderid,state.currentView);
		if(_sessionData != null){
			let _fids = selectMap.folderid.split(",");
			for(let j = 0;j < _fids.length;j++){
				if(_fids[j] == "") continue;
				for(let i = 0 ;i < _sessionData.data.folders.length;i++){
					if(_sessionData.data.folders[i].id == _fids[j]){
						_sessionData.data.folders.splice(i,1);
						break;
					}
				}
			}

			let _fiids = selectMap.fileid.split(",");
			for(let j = 0;j < _fiids.length;j++){
				if(_fiids[j] == "")continue;
				for(let i = 0;i < _sessionData.data.files.length;i++){
					if(_sessionData.data.files[i].id == _fiids[j]){
						_sessionData.data.files.splice(i,1);
						break;
					}
				}
			}
		}


		folderList = newFolderList;
		fileList = newFileList;
		state.listFreash = 1;
		this.setState({folderList : folderList,fileList : fileList});
	},
	onMore : function(){ //更多
		let dataMap = this.getSelectId();
		let showRename = false;
		if((dataMap.fileid == "" && dataMap.folderid != "" && dataMap.folderid.indexOf(",") == -1) || (dataMap.fileid != "" && dataMap.folderid == "" && dataMap.fileid.indexOf(",") == -1)){
			showRename = true;
		}
		Popup.show(
			<div className="moreProp">
				{
					showRename && 
					<div className="rename" onClick={this.onRename}>{FontList.rename}</div>
				}
				<div className="moveTo" onClick={this.onMove}>{FontList.move}</div>
				<div style={blueStyle} className="cancel" onClick={Popup.hide}>{FontList.cancel}</div>
			</div>
		,{animationType : 'slide-up'})
	},
	onMove : function(){ //移动到
		let selectMap = this.getSelectId();

		if(selectMap.fileid == "" && selectMap.folderid == ""){
			alert(FontList.moveNoData);
			return;	
		}

		Popup.hide();
		hashHistory.pushState(null,"/PrivateCategory",{
			fileids : selectMap.fileid,
			folderids : selectMap.folderid,
			currentCate : this.state.folderid,
			operateType : "move"
		});


		//alert("该功能暂未开放!");
	},
	isEmoji : function(name){
		return /\uD83C[\uDF00-\uDFFF]|\uD83D[\uDC00-\uDE4F]/.test(name);
	},
	onRename : function(){//重命名
		Popup.hide();
		state.renameDialog = true;
		state.listFreash = 1;
		state.resizeHeight = 0;
		this.setState({renameDialog : state.renameDialog});
	},
	onSaveRename : function(){
		if(renameTxt.value.trim() == ""){
			alert(FontList.nameIsNull);
			return;
		}

		if(/[\\/:*?"<>|]/.test(renameTxt.value.trim())){
			alert(<div>
					<div>{FontList.nameNotContains}</div>
					<div>{"\\/:*?\"<>|"}</div>
				</div>);
			return;
		}
		if(this.isEmoji(renameTxt.value)){
			alert(FontList.nameNotEmoj);
			return;
		}

		let newname = renameTxt.value + extname.value;
		let that = this;
		let url = "";
		let dataMap = this.getSelectId();
		if(dataMap.folderid != ""){
			url = '/mobile/plugin/networkdisk/getDataList.jsp?sessionkey=' + sessionkey + '&method=rename&renameType=folder&categoryname=' + newname + "&categoryid=" + dataMap.folderid;
		}else if(dataMap.fileid != ""){
			url = '/mobile/plugin/networkdisk/getDataList.jsp?sessionkey=' + sessionkey + '&method=rename&renameType=file&fileName=' + newname + "&imagefileid=" + dataMap.fileid + "&categoryid=" + this.state.folderid;
		}else{
			return;
		}
		state.isLoading = 1;
		Toast.info(<LodingState/>,10);
		new Promise((resolve,reject)=>{
	      fetch(url, {
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
	    	if(data.result == "success"){

	    		let _sessionData = that.getSessionData(that.state.folderid,state.currentView);

		       if(dataMap.folderid != ""){
			       	folderList.map((data)=>{
						if(data.id == dataMap.folderid){
							data.name = newname;
							return;
						}
					});

			       	_sessionData.data.folders.map((data)=>{
			       		if(data.id == dataMap.folderid){
							data.name = newname;
							return;
						}
			       	})

		       }else if(dataMap.fileid != ""){
		       		fileList.map((data)=>{
		       			if(data.id == dataMap.fileid){
		       				data.name = newname;
		       				return;
		       			}
		       		})

		       		_sessionData.data.files.map((data)=>{
			       		if(data.id == dataMap.fileid){
							data.name = newname;
							return;
						}
			       	})
		       }
				
				state.renameDialog = false;
				state.listFreash = 1;
				state.resizeHeight = 0;
				that.setState({folderList : folderList,fileList : fileList,renameDialog : state.renameDialog});
	    	}else if(data.result == "exist"){
	    		alert(FontList.nameExist);
	    	}else {
	    		alert(FontList.renameFaile);
	    	}
	    });
	},
	diskView : function(){ //我的云盘
		state.currentView = "disk";
		this.openFolder(0);
	},
	shareView : function(){//分享
		//state.currentView = state.currentView == "myShare" ? "shareMy" : "myShare";
		let that = this;
		this.state.searchTxt='';

		let sdata = this.getSessionData(0,state.currentView);
		if(sdata == null){
			this.getDataList(0,true,state.currentView).then((data)=>{
				folderList = data.folders;
				fileList = data.files;
				that.setState({
					folderList : folderList,
					fileList : fileList,
					showIndex : -1,
					showType : '',
					isFirst : 1,
					folderid : 0,
					islast : 1,
					searchTxt : '',
					currentView : state.currentView,
					keyword : '',
					pids : [0],
					path : [state.currentView == "myShare" ? FontList.shareTabMyShare : FontList.shareTabShareMy]
				})
			});
		}else{
			folderList = sdata.data.folders;
			fileList = sdata.data.files;
			that.setState({
				folderList : folderList,
				fileList : fileList,
				showIndex : -1,
				showType : '',
				isFirst : 1,
				folderid : 0,
				islast : 1,
				searchTxt : '',
				currentView : state.currentView,
				keyword : '',
				pids : [0],
				path : [state.currentView == "myShare" ? FontList.shareTabMyShare : FontList.shareTabShareMy]
			});
		}
	},
	shareMyView : function(){
		state.currentView = "shareMy";
		this.shareView();
	},
	myShareView : function(){
		state.longTouch = 0;
		state.currentView = "myShare";
		this.shareView();
	},
	cancelShareSimple : function(e){ //取消分享
		let type = e.target.getAttribute("data-datatype");
		let dataid = e.target.getAttribute("data-dataid");
		let that = this;
		let folderids = "";
		let fileids = "";
		if(type == "folder"){
			folderids = dataid;
		}else{
			fileids = dataid;
		}
		alert(FontList.confirmCancelShare,"",[
			{text : FontList.cancel,onPress : () => console.log("cancel")},
			{text : FontList.ensure,onPress : () => {
					state.isLoading = 1;
					Toast.info(<LodingState/>,10);
					new Promise((resolve,reject)=>{
				      fetch('/mobile/plugin/networkdisk/getDataList.jsp?sessionkey=' + sessionkey + '&method=cancelShare&folderids=' + folderids + '&fileids=' + fileids, {
				        method: 'POST',
				        mode: 'same-origin',
				        headers: {'Content-Type': 'application/json; charset=utf-8'},
				        credentials: 'include'
				      })
				      .then(function(res) {
				          let data=res.json();
				          state.isLoading = 0;
				          Toast.hide()
				          return data;
				      }).then(function(data) {
				          resolve(data);
				      })
				      .catch(function(e) {
				          console.log("error",e);
				      });
				    }).then((data)=>{
				    	if(data && data.flag == 1){
				    		let _sessionData = this.getSessionData(this.state.folderid,state.currentView);
				    		if(type == "folder"){
								for(let i = 0 ;i < folderList.length;i++){
									if(folderList[i].id == dataid){
										folderList.splice(i,1);
										break;
									}
								}


								if(_sessionData != null){
									for(let i = 0 ;i < _sessionData.data.folders.length;i++){
										if(_sessionData.data.folders[i].id == dataid){
											_sessionData.data.folders.splice(i,1);
											break;
										}
									}
								}
							}else if(type == "file"){
								for(let i = 0 ;i < fileList.length;i++){
									if(fileList[i].id == dataid){
										fileList.splice(i,1);
										break;
									}
								}

								if(_sessionData != null){
									for(let i = 0;i < _sessionData.data.files.length;i++){
										if(_sessionData.data.files[i].id == dataid){
											_sessionData.data.files.splice(i,1);
											break;
										}
									}
								}
							}

							sendCancel2Msg(data.mesList);

							state.listFreash = 1;
							that.setState({
								folderList : folderList,
								fileList : fileList
							})
				    	}
				    });
				}
			}
		]);
	},
	getSelectId : function(){

		if(this.state.operateType == "view"){
			for(let i = 0;i < folderList.length;i++){
				if(folderList[i].operateShow){
					return {
						folderid : folderList[i].id,
						fileid : ""
					}
					
				}
			}
			for(let i =0;i < fileList.length;i++){
				if(fileList[i].operateShow){
					return {
						folderid : "",
						fileid : fileList[i].id
					}
				}
			}
		}
			

		let folderid = "";
		this.state.folderList.map((folder)=>{
			if(folder.checked)
				folderid += "," + folder.id;
		}); 
		folderid = folderid.indexOf(",") > -1 ? folderid.substring(1) : folderid;
		let fileid = "";
		this.state.fileList.map((file)=>{
			if(file.checked)
				fileid += "," + file.id;
		});
		fileid = fileid.indexOf(",") > -1 ? fileid.substring(1) : fileid;
		return (
			{
				folderid : folderid,
				fileid : fileid
			}
		)

	},
	openFolder : function(e,defaultPostion){
		if(state.longTouch == 1){
			return;
		}
		let dataid = 0;
		let path = this.state.path;
		let pids = this.state.pids;
		if(typeof(e) == "object"){
			dataid = e.target.getAttribute("data-dataid");
			let _from = e.target.getAttribute("data-from");
			if(_from == "nav"){
				let _pids = [];
				let _path = [];
				for(let i = 0 ;i < pids.length;i++){
					_pids.push(pids[i]);
					_path.push(path[i]);
					if(pids[i] == dataid){
						break;
					}
				}
				path = _path;
				pids = _pids;
			}else{
				if(this.state.searchStatus == 1){
					path = [path[0]];
					pids = [pids[0],dataid];
					for(let i = 0;i < folderList.length;i++){
						if(folderList[i].id == dataid){
							path.push(folderList[i].name);
						}
					}

				}else{
					for(let i = 0;i < folderList.length;i++){
						if(folderList[i].id == dataid){
							path.push(folderList[i].name);
						}
					}
					pids.push(dataid);
				}
				state.sharetime = e.target.getAttribute("data-time");
				state.sharefrom = e.target.getAttribute("data-user");
				
			}

			if(pids.length == 1){  //根目录
				state.sharetime = "";
				state.sharefrom = "";
			}
		}else if(defaultPostion){
			path = DETAULT_PATH;
			pids = PIDS;
			dataid = e;
			DETAULT_PATH = "";
			PIDS = "";
		}else{
			dataid = e;
			if(dataid == 0){
				path = [];
				if(state.currentView == "disk"){
					path.push(FontList.diskFont);
				}else if(state.currentView == "myShare"){
					path.push(FontList.shareTabShareMy);
				}else if(state.currentView == "shareMy"){
					path.push(FontList.shareTabMyShare);
				}
				pids = [0];
			}else{
				//path = path.substring(0,path.length - 1);
				//path = path.substring(0,path.lastIndexOf("/") + 1);
				path.pop();
				pids.pop();
			}
			
		}
		let that = this;
		this.state.searchTxt = '';
		this.state.searchStatus = 0;

		let sdata = this.getSessionData(dataid,state.currentView);
		state.chooseNum = 0; 
		if(sdata == null){
			this.getDataList(dataid,true,state.currentView).then((data)=>{
				folderList = data.folders;
				fileList = data.files;
				that.setState({
					folderList : folderList,
					fileList : fileList,
					showIndex : -1,
					showType : '',
					isFirst : 1,
					folderid : dataid,
					currentView : state.currentView,
					islast : 1,
					searchTxt : '',
					keyword : '',
					path : path,
					pids : pids
				})
			})
		}else{
			folderList = sdata.data.folders;
			fileList = sdata.data.files;
			if(CHOOSE_FILE == 1){
				folderList.map((data)=>{
					data.checked = false;
				})
				fileList.map((data)=>{
					data.checked = false;
				})
			}
			that.setState({
				folderList : folderList,
				fileList : fileList,
				showIndex : -1,
				showType : '',
				isFirst : 1,
				folderid : dataid,
				currentView : state.currentView,
				islast : 1,
				searchTxt : '',
				keyword : '',
				path : path,
				pids : pids
			})
		}
	},
	openFile : function(e){
		if(state.longTouch == 1 || CHOOSE_FILE == 1){
			return;
		}
		let id = e.target.getAttribute("data-dataid");
		let size = e.target.getAttribute("data-size"); 
		let name = e.target.innerHTML;
		let _flag = false;
		if(window._isUsePDFViewer == 1){
			let _ext = name.indexOf(".") > -1 ? name.substring(name.lastIndexOf(".") + 1) : "";
			
			let sizeNum = -1;
			if(/\d+(.\d+)B/.test(size)){
				 sizeNum = size.replace("B");
			}else if(/\d+(.\d+)KB/.test(size)){
				sizeNum = size.replace("KB")*1024;
			}else if(/\d+(.\d+)MB/.test(size)){
				sizeNum = size.replace("KB")*1024*1024;
			}

			let maxSize = window.__maxSize*1024*1024;
			let xmlSize = window.__xmlSize*1024*1024;
			if(_ext == "xls" || _ext == "xlsx" || _ext == "doc" || _ext == "docx" || _ext == "pdf" || _ext == "ppt" || _ext == "pptx" || _ext == "txt" || _ext == "wps"){
				if(((_ext == "xls" || _ext == "xlsx") && sizeNum <= xmlSize) || _ext == "pdf" || sizeNum <= maxSize){
					_flag = true;
					name += ".pdf";
				}
			}else{
				_flag = false;
			}
		}
		let params = "fileid=" + id + "&filename=" + name + "&from=networkdisk&sessionkey=" + sessionkey;
		toOpenFile(params,_flag,"disk");
	},
	getDataList : function(id,isFirst,view,hideLoading){
		state.isLoading = 1;
		if(isFirst){
			pageNum = 1;
		}
		if(!hideLoading){
			Toast.info(<LodingState/>,10);
		}
		let that = this;
		return new Promise((resolve,reject)=>{
	      fetch('/mobile/plugin/networkdisk/getDataList.jsp?sessionkey=' + sessionkey + '&method=getDataList&view=' + view + '&folderid=' + id + (isFirst ? '&isFirst=1' : '') + 
	      	'&keyword=' + this.state.searchTxt + '&pageSize=' + pageSize + "&pageNum=" + pageNum + "&bySearch=" + this.state.searchStatus + 
	      	"&sharetime=" + state.sharetime + "&sharefrom=" + state.sharefrom
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
	          if(!hideLoading){
	             Toast.hide();
	      	  }
	          return data;
	      }).then(function(data) {
	          resolve(data);
	      })
	      .catch(function(e) {
	          console.log("error",e);
	      });
	    }).then(function(data){
	    	if(that.state.searchStatus == 0){
	    		that.add2Session(id,data,view);
	    	}
	    	return {
	    		files : eval("(" + data.files + ")"),
	    		folders : eval("(" + data.folders + ")")
	    	};
	    });
	},
	getSessionData : function(id,view){
		let _sessionData = null;
		if(view == "disk"){
			if(sessionData.diskData[id]){
				_sessionData = sessionData.diskData[id];
			}

		}else if(view == "myShare"){
			if(sessionData.myShareData[id]){
				_sessionData = sessionData.myShareData[id];
			}
		}else if(view == "shareMy"){
			if(sessionData.shareMyData[id]){
				
				_sessionData = sessionData.shareMyData[id];
			}
		}

		if(_sessionData != null && _sessionData.data.files.length == 0 && _sessionData.data.folders.length == 0){
			return null;
		}

		return _sessionData;
	},
	add2Session : function(id,data,view){
		
		if(IS_OPEN_SESSION != 1)
			return;

		data = {
			files : eval("(" + data.files + ")"),
	    	folders : eval("(" + data.folders + ")")
		}

		let _sessionData = null;
    	if(view == "disk"){
    		_sessionData = sessionData.diskData;
		}else if(view == "myShare"){
			_sessionData = sessionData.myShareData;
		}else if(view == "shareMy"){
			_sessionData = sessionData.shareMyData;
		}

		if(_sessionData != null){
			if(_sessionData[id]){
				for(let i = 0 ; i < data.folders.length;i++){
					_sessionData[id].data.folders.push(data.folders[i]);
				}
				for(let i = 0; i < data.files.length;i++){
					_sessionData[id].data.files.push(data.files[i]);
				}
			}else{
				_sessionData[id] = {};
				_sessionData[id].data = data;
			}
		}
	},
	removeSession : function(id,view){
		let _sessionData = null;
		view = view ? view : state.currentView;
    	if(view == "disk"){
    		_sessionData = sessionData.diskData;
		}else if(view == "myShare"){
			_sessionData = sessionData.myShareData;
		}else if(view == "shareMy"){
			_sessionData = sessionData.shareMyData;
		}
		if(_sessionData != null){
			delete(_sessionData[id ? id : this.state.folderid]);
		}
	},
	loadMore : function(){
		let that = this;
		if(state.isLoading == 1)
			return;
		this.getDataList(this.state.folderid,false,state.currentView).then((data)=>{
			let files = data.files;
			let islast = 0;
			if(files.length < pageSize){
				islast = 1;
			}
			for(let i = 0;i < files.length;i++){
				fileList.push(files[i]);
			}
			
			that.setState({
				fileList : files,
				folderList : [],
				islast : islast,
				isFirst : 0
			})
		})
	},
	showDiskLoading : function(){
		Toast.info(<LodingState/>,10);
	},
	hideDiskLoading : function(){
		Toast.hide();
	},
	onRefresh : function(){
		let that = this;
		if(state.isLoading == 1)
			return;
		this.removeSession();
		this.getDataList(this.state.folderid,true,state.currentView,true).then((data)=>{
			folderList = data.folders;
			fileList = data.files;
			let islast = 0;
			if(that.state.searchStatus == 0 || state.currentView != "disk" || fileList.length < pageSize){ //不是搜索，或者不是私人目录的搜索，或者私人目录下取到的数据长度小于每页显示数量
				islast = 1;
			}
			
			that.setState({
				fileList : fileList,
				folderList : folderList,
				islast : islast,
				isFirst : 1
			})
		})	
	},
	touchStart : function(){
		//timeOutEvent = setInterval("touchCancel()",500);  
		let that = this;
		state.longTouch = 0;
		timeOutEvent = setTimeout(function(){
			state.longTouch = 1;
			that.touchCancel();
		},500);
	},
	touchEnd : function(e){
		//clearInterval(timeOutEvent); 
		clearTimeout(timeOutEvent); 
		if(state.longTouch == 1){
			state.longTouch = 0;
			e.preventDefault();
			e.stopPropagation();
		}

	},
	touchCancel : function(){
		//clearTimeout(timeOutEvent);
		clearTimeout(timeOutEvent);
		this.toSelect();
	},
	touchMove : function(e){
		clearTimeout(timeOutEvent);
		if(state.longTouch == 1){
			e.preventDefault();
		}
	},
	emptyTouch : function(){

	},
	focus : function(){
		state.resizeHeight = 0;
		if(this.state.searchHistory == 1){
			this.setState({
				searchHistory : 0,
				searchStatus : 1,
				historyList : sessionData.diskSeatchList
			});
		}
	},
	toShareSearch : function(){
		let that = this;
		state.chooseNum = 0; 
		if(sessionData.shareSearchList.length == 0){
			this.getCookie().then(function(data){
				sessionData.shareSearchList = data;
				that.setState({
					searchHistory : 0,
					searchStatus : 1,
					historyList : data
				})
			})
		}else{
			that.setState({
				searchHistory : 0,
				searchStatus : 1,
				historyList : sessionData.shareSearchList
			})
		}
		
	},
	doChooseFile : function(){
		chooseFileFn(this.getSelectId());
	},
	getCookie : function(cookiename){
		if(state.isLoading == 1)
			return;
		let type = state.currentView == "disk" ? 0 : 1;
		state.isLoading = 1;
		Toast.info(<LodingState/>,10);
		let that = this;
		return new Promise((resolve,reject)=>{
	      fetch('/mobile/plugin/networkdisk/historySearch.jsp?sessionkey=' + sessionkey + '&method=getHistorySearch&type=' + type, {
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
	showLoad : function(){
		Toast.info(<LodingState/>,10);
	},
	hideLoad : function(){
		Toast.hide();
	},
	iframeShow : function(d,e){
		if(d.hideLoad){
			Toast.hide();
		}
		e.target.style.display = "block";
	},
	onCancel : function(){
		state.chooseNum = 0; 
		this.state.searchHistory = 1;
		this.state.searchStatus = 0;
		PIDS = this.state.pids;
		DETAULT_PATH = this.state.path;
		this.openFolder(this.state.folderid,true);
	},
	render : function(){	
		if(this.state.searchStatus == 1){
			maxWindowHeight = maxWindowHeight >  window.innerHeight	? maxWindowHeight : window.innerHeight;
			resultDivHeight = maxWindowHeight - (CHOOSE_FILE == 1 && this.state.searchHistory == 2 ? 90 : 39)*window.viewportScale;
		}else{
			maxWindowHeight = maxWindowHeight >  window.innerHeight ? maxWindowHeight : window.innerHeight;
			resultDivHeight = maxWindowHeight - (this.state.currentView == "disk" ? 117 : 121)*window.viewportScale;
		}
		let that = this;
		let dataMap = this.getSelectId();
		let folderids = dataMap.folderid;
		let fileids = dataMap.fileid;
		let dataEmtpy = true;
		if(folderList.length > 0){
			dataEmtpy = false;
		}else if(fileList.length > 0){
			dataEmtpy = false;
		}
		return (
			<div>
			
				{
					this.state.currentView == "disk" ?
						<DiskHeader
							keyword={this.state.keyword}
							promptStr={this.state.promptStr}
							searchStatus={this.state.searchStatus}
							onSearch={this.onSearch}
							onCancel={this.onCancel}
							onChange={this.onChange}
							focus={this.focus}
							onCreateFolder={this.onCreateFolder}
						/>
					:	
						<ShareHeader 
							keyword={this.state.keyword}
							promptStr={this.state.promptStr}
							searchStatus={this.state.searchStatus}
							currentView={this.state.currentView}
							onSearch={this.onSearch}
							onCancel={this.onCancel}
							onChange={this.onChange}
							toShareSearch={this.toShareSearch}
							myShareView={this.myShareView}
							shareMyView={this.shareMyView}
						/>
				}
				{
					this.state.searchStatus == 0 ?
					<NavPath path={this.state.path} clientEvent={this.openFolder} ids={this.state.pids}/>
					:
					<div className="searchLine"></div>
				}
				<div id="content" className="diskBody" 
						onTouchStart={state.currentView == "disk" && !dataEmtpy && CHOOSE_FILE == 0? this.touchStart : this.emptyTouch} 
						onTouchEnd={state.currentView == "disk" && !dataEmtpy && CHOOSE_FILE == 0 ? this.touchEnd : this.emptyTouch} 
						onTouchMove={state.currentView == "disk" && !dataEmtpy && CHOOSE_FILE == 0 ? this.touchMove : this.emptyTouch}>
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

								<LoadingView 
									showType={that.state.showType} 
									fileList={that.state.fileList}
									folderList={that.state.folderList}
									showIndex={that.state.showIndex} 
									operateView={that.state.operateView}
									currentView={that.state.currentView}
									searchStatus={that.state.searchStatus}
									islast={that.state.islast}
									isFirst={that.state.isFirst}
									folderid={that.state.folderid}
									operateShow={that.operateShow}
									onSelect={that.onSelect}
									onPublicSimple={that.onPublicSimple}
									onShareSimple={that.onShareSimple}
									onDeleteSimple={that.onDeleteSimple}
									onMoreSimple={that.onMoreSimple}
									cancelShareSimple={that.cancelShareSimple}
									openFolder={that.openFolder}
									openFile={that.openFile}
									loadMore={that.loadMore}
									toSelect={that.toSelect}
									onRefresh={that.onRefresh}
									onCreateFolder={that.onCreateFolder}
									diskView={that.diskView}
								/>
							}
						</List>	
					</ul>
					
					
				</div>
				{
					(this.state.searchStatus == 0 || (CHOOSE_FILE == 1 && this.state.searchHistory == 2)) && 
					<div className={"diskFoot firstInPage" + (CHOOSE_FILE ? " chooseFileFoot" : "")}>
						{this.state.operateType == "operate" ?
						<DiskFootOperate 
							folderids={folderids}
							fileids={fileids}
							onShareMul={this.onShareMul}
							onPublicMul={this.onPublicMul}
							onDeleteMul={this.onDeleteMul}
							onMore={this.onMore}
						/>
						:
						CHOOSE_FILE == 0 ?
						<DiskFootTab 
							currentView={this.state.currentView}
							folderid={this.state.folderid}
							diskView={this.diskView}
							myShareView={this.myShareView}	
						/>
						:
						<ChooseFile
							doChooseFile={this.doChooseFile}
						/>
						}
					</div>
				}
				<Modal className="creatDialog"
					title={FontList.createFolder}
					closable = {false}
					transparent
					visible={this.state.createDialog}
					footer={[ 
						{text : FontList.cancel,onPress : () => {console.log('cancel');this.onCloseDialog('create')}},
						{text : FontList.ensure, onPress: () => { console.log('ok'); this.onSaveFolder(); } }
						]}
				  >
					<div className="modal-dialog-content">
					  <div className="dialog-content">
						<input type="text" id="folderName" placeholder={FontList.inputFolderName}/>
					  </div>
					</div>
				</Modal>

				<Modal className="creatDialog"
					title={FontList.rename}
					closable = {false}
					transparent
					visible={this.state.renameDialog}
					footer={[ 
						{text : FontList.cancel,onPress : () => {console.log('cancel');this.onCloseDialog('rename')}},
						{text : FontList.ensure, onPress: () => { console.log('ok'); this.onSaveRename(); } }
						]}
				  >
					<div className="modal-dialog-content">
					  <div className="dialog-content">
						<input type="text" id="renameTxt" placeholder={FontList.inputNewName}/>
						<input type="hidden" id="extname"/>
					  </div>
					</div>
				</Modal>
				{
					state.successInfo == 1 &&
					<SuccessState msg={state.successMsg}/>
				}
				<div id="attrDetail">
					<iframe frameborder="0" scrolling="no" width="100%" height="100%" onLoad={this.iframeShow.bind(this,{hideLoad : true})}></iframe>
				</div>
			</div>
		)
	}
})

const DiskHeader = React.createClass({
	toSystemDoc : function(){
		//Toast.info(<LodingState/>,10);
		//setTimeout(function(){
			hashHistory.pushState(null,"/SystemDoc",{});
		//},100)
		
	},
	render : function(){
		return (

			<div className="diskHeader">
				{
					CHOOSE_FILE == 1 ?  //外部选择云盘目录、文件
					<div style={{width:'100%'}}>
						<div className="diskSearch">
							<SearchBar 
								 value={this.props.keyword}
								 placeholder={this.props.promptStr}
								 showCancelButton={this.props.searchStatus ? false : true}
								 onSubmit={this.props.onSearch}
								 onCancel={this.props.onCancel}
								 onChange={this.props.onChange}
								 onFocus={this.props.focus}
							 />
						</div>
					</div>
					:       //云盘
					<div style={{width:'100%'}}>
						{
							this.props.searchStatus == 0 ?   //非搜索状态
							<div  className="DiskHeaderTab">
								<div className="diskAddFolder"><img src={IconList.createIcon} onClick={this.props.onCreateFolder} /></div>
								<div className="diskSystemTab">
									<div>
										<div className="myDiskTab select">
											<div>我的云盘</div>
										</div>
										<div className="systemTab" onClick={this.toSystemDoc}>
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
				}
						
			</div>
		)
	}
})

const ShareHeader = React.createClass({
	toSystemDoc : function(){
		//Toast.info(<LodingState/>,10);
		//setTimeout(function(){
			hashHistory.pushState(null,"/SystemDoc",{});
		//},100)
		
	},
	render : function(){
		return (
			<div className="diskHeader">
			{
				this.props.searchStatus == 0 ? //非搜索状态
				<div style={{width:'100%'}}>
					<div className="DiskHeaderTab">
						{
							this.props.currentView == "myShare" ?
							<div onClick={this.props.shareMyView} className="shareMyTab">
								<img src="/mobile/plugin/networkdisk/img/shareMy.png"/>
							</div>
							:
							<div onClick={this.props.myShareView} className="myShareTab">
								<img src="/mobile/plugin/networkdisk/img/myShare.png"/>
							</div>
						}
						<div className="diskSystemTab">
							<div>
								<div className="myDiskTab select">
									<div>我的云盘</div>
								</div>
								<div className="systemTab" onClick={this.toSystemDoc}>
									<div>系统目录</div>
								</div>
							</div>
						</div>
					</div>
					<div className="searchIcon" onClick={this.props.toShareSearch}>
						
					</div>
				</div>
				: //搜索状态	
				<div className="diskSearch">
					<SearchBar 
					  value={this.props.keyword}
					  placeholder={this.props.promptStr}
					  onSubmit={this.props.onSearch}
					  onCancel={this.props.onCancel}
					  showCancelButton={this.props.searchStatus == 0 ? false : true}
					  onChange={this.props.onChange}
					  />
				</div>
			}
		</div>
		)
	}
})

const SystemHeader = React.createClass({
	render : function(){
		return (
			<div></div>
		)
	}
})


const LoadingView = React.createClass({
	getInitialState : function(){
		const dataSource = new ListView.DataSource({
			rowHasChanged : (row1,row2) => row1 !== row2
		});
		this.initData=[];
		for(let i = 0; i < this.props.folderList.length;i++){
			this.props.folderList[i].datatype = "folder";
			this.initData.push(this.props.folderList[i]);
		}
		for(let i = 0;i < this.props.fileList.length;i++){
			this.props.fileList[i].datatype = "file";
			this.initData.push(this.props.fileList[i]);
		}
		initialListSize = this.initData.length;
		return {
			dataSource : dataSource.cloneWithRows(this.initData),
			islast : this.props.islast,
			refreshing : false,
			back2Top : false,
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

	componentWillReceiveProps : function(nextProps){
		if(state.listFreash == 1){
			state.listFreash = 0;
			this.initData = [];
		}else{
			if(nextProps.isFirst == 1){
				this.initData = [];
				renderRow = pageSize;
				this.state.back2Top = true;
			}
		}
		for(let i = 0; i < nextProps.folderList.length;i++){
			let ndata = {};
			ndata.datatype = "folder";
			let folder = nextProps.folderList[i];
			for(key in folder){
				ndata[key] = folder[key];
			}
			this.initData.push(ndata);
		}
		for(let i = 0;i < nextProps.fileList.length;i++){
			let ndata = {};
			ndata.datatype = "file";
			let file = nextProps.fileList[i];
			for(key in file){
				ndata[key] = file[key];
			}
			this.initData.push(ndata);
		}
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
	showBtn : function(e){
		showBtn(e);
	},
	render : function(){	
		let that = this;
		let i = 0;
		const row = (rowData,sectionID,rowID) => {
			return (
					<FileListView key={rowID}
						data={rowData}
						operateView={that.props.operateView}
						operateShow={that.props.operateShow}
						currentView={that.props.currentView}
						showType={that.props.showType}
						showIndex={that.props.showIndex}
						folderid={that.props.folderid}
						onSelect={that.props.onSelect}
						onPublicSimple={that.props.onPublicSimple}
						onShareSimple={that.props.onShareSimple}
						onDeleteSimple={that.props.onDeleteSimple}
						onMoreSimple={that.props.onMoreSimple}
						cancelShareSimple={that.props.cancelShareSimple}
						openFolder={that.props.openFolder}
						openFile={that.props.openFile}
						toSelect={this.props.toSelect}
					/>
			)
		};
		return (
					this.state.back2Top ? 
					<div></div>

					:

					this.initData.length > 0 || state.firstInPage == 1 ? 
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
					 	
					 	{
					 		this.props.currentView == "disk" && this.props.folderid == 0 && this.props.searchStatus == 0  &&
						 	<div>
								<img className="diskEmpty" src={IconList.diskEmpty}/>
								<div>
									{FontList.diskEmptyFont}
								</div>
								
								<div className="EmptyBtn">
									<a className="selectBtn uploadFile" onClick={this.showBtn}>{FontList.uploadFile}</a>
									<a className="selectBtn createFolder" onClick={this.props.onCreateFolder}>{FontList.createFolder}</a>
								</div>
							</div>
						}
						{	
							this.props.currentView == "myShare" && this.props.folderid == 0 && this.props.searchStatus == 0  &&
							<div>
								<img className="myShareEmpty" src={IconList.myShareEmpty}/>
								<div>
									{FontList.myShareEmptyFont}
								</div>
								<div className="EmptyBtn">
									<a className="selectBtn shareBtn" onClick={this.props.diskView}>{FontList.shareRightNow}</a>
								</div>
							</div>
						}
						{	
							this.props.currentView == "shareMy" && this.props.folderid == 0 && this.props.searchStatus == 0  &&
							<div>
								<img className="shareMyEmpty"  src={IconList.shareMyEmpty}/>
								<div>
									{FontList.shareMyEmptyFont}
								</div>
							</div>
						}
						{
							(this.props.folderid != 0 || this.props.searchStatus == 1) &&
							<div>
								<img className="folderEmpty"  src={IconList.folderEmpty}/>
								<div className="emptyInfo">
									{this.props.searchStatus == 0 ? FontList.dataEmptyFont : FontList.searchNoFile}
								</div>
								{	this.props.currentView == "disk" && this.props.searchStatus == 0 &&
									<div className="EmptyBtn">
										<a className="selectBtn uploadFile" style={{margin:0}} onClick={this.showBtn}>{FontList.uploadFile}</a>
									</div>
								}
							</div>	
						}
					</li>
			)
	}	
})


let FileListView = React.createClass({
	
	render : function(){
		return (
			<List.Item>
				<li className={this.props.data.datatype} data-dataid={this.props.data.id} data-datatype={this.props.data.datatype} 
					onClick={this.props.operateView == "left" && CHOOSE_FILE == 0 ? this.props.onSelect : ""}>
					<div className={"diskUnit " +  (CHOOSE_FILE == 0 ? this.props.operateView : "left")}>
						
						{	
							(this.props.operateView == "left" || CHOOSE_FILE == 1) &&
							<div className="diskCheck" data-dataid={this.props.data.id} data-datatype={this.props.data.datatype} onClick={CHOOSE_FILE == 1 ? this.props.onSelect : ""}>
								<img src={this.props.data.checked ? IconList.checkedYes : IconList.checkedNo}/>
							</div>
						}
						
						<div className="diskIcon">
							{
								this.props.operateView == "right" &&
								<img src={IconPath + this.props.data.icon} data-dataid={this.props.data.id} data-time={this.props.data.datetime} data-user={this.props.data.username} data-size={this.props.data.size}
									onClick={this.props.data.datatype == "folder" ? this.props.openFolder : this.props.openFile}/>
							}
							{
								this.props.operateView == "left" &&	
								<img src={IconPath  + this.props.data.icon}/>
							}
						</div>
						<div className={"diskContent" + (this.props.data.datetime == "" ? " line_1" : "")}>
							{
								this.props.operateView == "right" &&
								<div className="diskName" data-dataid={this.props.data.id} data-time={this.props.data.datetime} data-user={this.props.data.username} data-size={this.props.data.size}
									onClick={this.props.data.datatype == "folder" ? this.props.openFolder : this.props.openFile}>
									{this.props.data.name}
								</div>
							}
							{
								this.props.operateView == "left" &&
								<div className="diskName">{this.props.data.name}</div>
							}
							<div className="diskTime">{this.props.data.datetime}</div>
							<div className="diskSize">{this.props.data.size}</div>
							<div className="clearBoth"></div>
							{ 
								this.props.data.username &&	
								<div>
									<div className="sharefrom">来自：{this.props.data.username}</div>
								</div>
							}
							
						</div>
						{
							this.props.operateView == "right" && CHOOSE_FILE == 0 && (state.currentView == "disk" || state.currentView == "shareMy" || this.props.folderid == 0) &&	
							<div className="diskOpeate"
								data-dataid={this.props.data.id} data-datatype={this.props.data.datatype} data-shareid={this.props.data.shareid} onClick={this.props.operateShow}>
								<img data-dataid={this.props.data.id} data-datatype={this.props.data.datatype} data-shareid={this.props.data.shareid} src={this.props.data.operateShow ? IconList.stretch : IconList.shrinkage}/>	
							</div>
						}
					</div>
					
					{
						this.props.currentView == "disk" && this.props.data.operateShow &&
						<DiskOperate 
							datatype={this.props.data.datatype}
							index={this.props.data.id}
							onShareSimple={this.props.onShareSimple}
							onDeleteSimple={this.props.onDeleteSimple}
							onMoreSimple={this.props.onMoreSimple}
							onPublicSimple={this.props.onPublicSimple}
						/>
					}
					
					{
						this.props.currentView == "myShare" && this.props.data.operateShow &&
						<MyShareOperate
							cancelShareSimple={this.props.cancelShareSimple}
							datatype={this.props.data.datatype}
							dataid={this.props.data.id}
						/>
					}
					{
						this.props.currentView == "shareMy" && this.props.data.operateShow &&
						<ShareMyOperate
							datatype={this.props.data.datatype}
							index={this.props.data.id}
						/>
					}
					
				</li>
			</List.Item>	
		)
	}						
})

let DiskOperate = React.createClass({
	render : function(){
		let href = location.href;
		return (
			<div className="operateContent">
				<div>
					<div className="bindEvent" data-datatype={this.props.datatype} data-dataid={this.props.index} onClick={this.props.onShareSimple}>
						<img data-datatype={this.props.datatype} data-dataid={this.props.index} src={IconList.shareIconSim}/><br/>
						<font data-datatype={this.props.datatype} data-dataid={this.props.index}>{FontList.shareFontSim}</font>
					</div>
				</div>
				<div>
					<Link to={{pathname:'/PublicDoc',query:{fileids : this.props.datatype == "file" ? this.props.index : "",folderids : this.props.datatype == "folder" ? this.props.index : ""}}}>
							<img src={IconList.publicIconSim}/><br/>
							<font>{FontList.publicFontSim}</font>
					</Link>
				</div>
				<div>
					<div className="bindEvent" data-datatype={this.props.datatype} data-dataid={this.props.index} onClick={this.props.onDeleteSimple}>
						<img data-datatype={this.props.datatype} data-dataid={this.props.index} src={IconList.deleteIconSim}/><br/>
						<font data-datatype={this.props.datatype} data-dataid={this.props.index}>{FontList.deleteFontSim}</font>
					</div>
				</div>
				<div>
					<div className="bindEvent" data-datatype={this.props.datatype} data-dataid={this.props.index} onClick={this.props.onMoreSimple}>
						<img data-datatype={this.props.datatype} data-dataid={this.props.index} src={IconList.moreIconSim}/><br/>
						<font data-datatype={this.props.datatype} data-dataid={this.props.index}>{FontList.moreFont}</font>
					</div>	
				</div>
			</div>
		)
	}
})
let MyShareOperate = React.createClass({
	render : function(){
		return (
			<div className="operateContent myShare">
				<div>
					<img data-datatype={this.props.datatype} data-dataid={this.props.dataid} src={IconList.cancelShareIconSim} onClick={this.props.cancelShareSimple}/><br/>
					<font data-datatype={this.props.datatype} data-dataid={this.props.dataid}  onClick={this.props.cancelShareSimple}>{FontList.cancelShareFontSim}</font>
				</div>
				<div>
					<Link to={{pathname:'/ShareObject',query:{fileid : this.props.datatype == "file" ? this.props.dataid : "",folderid : this.props.datatype == "folder" ? this.props.dataid : ""}}}>
						<img data-datatype={this.props.datatype} src="/mobile/plugin/networkdisk/img/share_object.png"/> <br/>
						<font data-datatype={this.props.datatype} >查看分享对象</font>
					</Link>
				</div>
			</div>
		)
	}
})
let ShareMyOperate = React.createClass({
	render : function(){
		return (
			<div className="operateContent shareMy">
				<div>
					<Link to={{pathname:'/PrivateCategory',query:{shareids:this.props.shareid,fileids : this.props.datatype == "file" ? this.props.index : "",folderids : this.props.datatype == "folder" ? this.props.index : ""}}}>
						<img src={IconList.shareIconSim} /><br/>
						<font>{FontList.save2DiskFontSim}</font>
					</Link>
				</div>
			</div>
		)
	}
})


let DiskFootTab = React.createClass({
	showBtn : function(e){
		showBtn(e);
	},
	render : function(){
		let files1 = [];
		let that = this;
		return (
			<div className="diskTab">
				<div className="myDisk">
					<div className="footImg">
						<img src={this.props.currentView == "disk" ? IconList.diskIconChecked : IconList.diskIcon} onClick={this.props.diskView}/>
					</div>
					<div className="footFont">
						<font style={this.props.currentView == "disk" ? blueStyle : {}} onClick={this.props.diskView}>{FontList.diskFont}</font>
					</div>
				</div>
				<div className="add">
					{
						this.props.currentView == "disk" ?
						<img onClick={this.showBtn} src={IconList.addIcon}/>
						:
						<img src={IconList.addNoIcon}/>
					}
				</div>
				<div>
					<div className="footImg">
						<img src={this.props.currentView == "myShare" || this.props.currentView == "shareMy" ? IconList.shareIconChecked : IconList.shareIcon} onClick={this.props.myShareView}/>
					</div>
					<div className="footFont">
						<font style={this.props.currentView == "myShare" || this.props.currentView =="shareMy" ? blueStyle : {}} onClick={this.props.myShareView}>{FontList.shareFont}</font>
					</div>
				</div>
			</div>
		)
	}
	
})

let ChooseFile = React.createClass({
	render : function(){
		return (
			<div style={{textAlign:"right"}}>
				<a className="chooseFileBtn" onClick={this.props.doChooseFile}>确定(<span id="chooseNum">{state.chooseNum}</span>)</a>
			</div>
		)
	}
})

const DiskFootOperate = React.createClass({
	render : function(){
		return (
			<div className="diskFootOperate">
				<div>
					<img src={IconList.shareIconMul} onClick={this.props.onShareMul}/><br/>
					<font onClick={this.props.onShareMul}>{FontList.shareFontMul}</font>
				</div>
				<div>
					{
						this.props.fileids == "" && this.props.folderids == "" ?
						<div>
							<img src={IconList.publicIconMul} onClick={this.props.onPublicMul}/><br/>
							<font onClick={this.props.onPublicMul}>{FontList.publicFontMul}</font>
						</div>
						:
						<Link to={{pathname:'/PublicDoc',query:{fileids : this.props.fileids,folderids : this.props.folderids}}}>
							<img src={IconList.publicIconMul} /><br/>
							<font>{FontList.publicFontMul}</font>
						</Link>
					}
				</div>
				<div>
					<img src={IconList.deleteIconMul} onClick={this.props.onDeleteMul}/><br/>
					<font onClick={this.props.onDeleteMul}>{FontList.deleteFontMul}</font>
				</div>
				<div>
					<img src={IconList.moreIcon} onClick={this.props.onMore}/><br/>
					<font onClick={this.props.onMore}>{FontList.moreFont}</font>
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
									<a data-from="nav" onClick={that.props.clientEvent} data-dataid={this.props.ids[i]}>{data}</a>
								</li>
							)
						})
					}
				</ul>
			</div>
		)
	}
});

const ShareObject = React.createClass({
	getInitialState : function(){
		return ({
			keyword : '',  //搜索关键字
			searchTxt : '',
			searchStr : FontList.searchStr, //搜索按钮
			promptStr : '请输入名称/群名称', //输入框内提示文字
			fileid : this.props.location.query.fileid ? this.props.location.query.fileid : "",
			folderid : this.props.location.query.folderid ? this.props.location.query.folderid : "",
			objects : [],
			checkAll : 0
		})
	},
	componentDidMount : function(){
		if(this.isMounted()){
			let that = this;
			this.getObjects().then((data)=>{
				that.setState({
					objects : data.dataList
				})
			});
		}
	},
	componentDidUpdate : function(){
		iosSearchKey();
	},
	getObjects : function(){
		state.isLoading = 1;
	 	Toast.info(<LodingState/>,10);
		return new Promise((resolve,reject)=>{
		    fetch('/mobile/plugin/networkdisk/getDataList.jsp?sessionkey=' + sessionkey + '&method=getShareObj&fileid=' + this.state.fileid + '&folderid=' + this.state.folderid + 
		    	'&objname=' + this.state.searchTxt, { 
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
	    });
	},
	deleteShareObj : function(){
	 	let shareids = this.getSelectId();
	 	if(shareids == ""){
	 		alert("请选择要删除的对象!");
	 		return;
	 	}
	 	let that = this;
	 	alert(FontList.confirmDel,"",[
			{text : FontList.cancel,onPress : () => console.log("cancel")},
			{text : FontList.ensure,onPress : () => that.doDelete(shareids)}
			]);
	},
	doDelete : function(shareids){
		state.isLoading = 1;
	 	Toast.info(<LodingState/>,10);
	 	let that = this;
	 	new Promise((resolve,reject)=>{
		    fetch('/mobile/plugin/networkdisk/getDataList.jsp?sessionkey=' + sessionkey + '&method=deleteShareObj&shareids=' + shareids, { 
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
	      })
		}).then((data)=>{
	      	if(data && data.flag == "1"){
	      		state.successInfo = 1;
	      		state.successMsg = "删除成功!";
	      		let ndata= [];
	      		that.state.objects.map((data)=>{
	      			if(!data.checked){
	      				ndata.push(data);
	      			}
	      		});

	      		if(ndata.length == 0){
	      			that.cancel(true,data.mesList);
	      		}else{
	      			sendCancel2Msg(data.mesList);
	      			that.setState({
	      				objects : ndata
	      			})
	      		}
	      	}

	    })
	},
	doCheck : function(d){
		let obj = this.state.objects[d.i];
		obj.checked = obj.checked ? false : true;
		this.setState({objects : this.state.objects});
	},
	checkAll : function(){
		let checkAll = 0;
		if(this.state.checkAll == 1){
			this.state.objects.map((data)=>{
				data.checked = false;
			})
		}else{
			this.state.objects.map((data)=>{
				data.checked = true;
			})
			checkAll = 1;
		}
		this.setState({
			checkAll : checkAll
		});
	},
	getSelectId : function(){
		let ids = "";
		this.state.objects.map((data)=>{
			if(data.checked){
				ids += "," + data.id;
			}
		});
		ids = ids == "" ? "" : ids.substring(1);
		return ids;
	},
	cancel : function(isEmpty,mesList){
		state.diskState = DiskObj.state;
		if(isEmpty){
			state.backFreash = 1;
			sessionData.myShare = {};
			state.mesList = mesList;
		}else{
			state.backFreash = 2;
		}
		
		this.props.history.goBack();
	},
	onChange : function(value){
		this.setState({keyword : value});
	},
	onSearch : function(){
		this.state.searchTxt = this.state.keyword;
		let that = this;
		this.getObjects().then((data)=>{
			that.setState({
				objects : data.dataList,
				searchStr : that.state.keyword
			})
		})
	},
	clear : function(){
		this.state.keyword = '';
		this.onSearch();
	},
	render : function(){
		let that = this;
		return (
			<div id="content">
				<div className="diskHeader">
					<div className="diskSearch">
						<SearchBar 
						  value={this.state.keyword}
						  placeholder={this.state.promptStr}
						  onSubmit={this.onSearch}
						  onCancel={this.cancel}
						  showCancelButton={true}
						  onChange={this.onChange}
						  onFocus={this.focus}
						  onClear={this.clear}
						/>
					</div>
				</div>
				<ul>
					<List>
						{
							this.state.objects.map((data,i)=>{
								return (
									<List.Item>
										<li data-dataid={data.id} onClick={that.doCheck.bind(this,{i})}>
											<div className="diskUnit left">
												<div className="diskCheck shareObjectChoose">
													<img src={data.checked ? IconList.checkedYes : IconList.checkedNo}/>
												</div>
												<div className="diskIcon cycleImg">
													<img src={data.icon}/>
												</div>
												<div className="diskContent">
													
													<div className="diskName">{data.sharername}</div>
													<div className="diskTime">{data.type == "user" ? (data.department + "/" + data.company) : (data.number + "人")}</div>
													<div className="clearBoth"></div>
													<div className="diskTime">分享时间：{data.sharetime}</div>
													<div className="clearBoth"></div>
												</div>
											</div>
										</li>
									</List.Item>	
								)
							})
						}
					</List>
				</ul>
				<div className="diskFoot firstInPage">
					<div className="diskTab shareObject">
						<div className="checkAll">
							<font onClick={this.checkAll}>全选</font>
						</div>
						<div className="delete">
							<font onClick={this.deleteShareObj}>删除</font>
						</div>
					</div>
				</div>

				{
					state.successInfo == 1 &&
					<SuccessState msg={state.successMsg}/>
				}
			</div>
		)
	}
})


const PublicDoc = React.createClass({
	getInitialState : function(){
		prevStep = ()=>{
			this.prev();
		}
		getPid = ()=>{
			return 1;
		}
		return ({
			keyword : '',  //搜索关键字
			searchTxt : '',
			pid : this.props.location.query.category ? this.props.location.query.category : 0, //上级目录id
			category : {},
			searchStr : FontList.searchStr, //搜索按钮
			promptStr : FontList.promptStr, //输入框内提示文字
			path : [FontList.systemFolder], //已选目录
			pids : [0],
			isFirst : '1',
			allData : {},
			fileids : this.props.location.query.fileids,
			folderids : this.props.location.query.folderids,
			canSelect : false
		})
	},
	componentDidMount : function(){
	 	if(this.isMounted()){
	 		let that = this;
	 		this.getCategorys(this.state.pid).then((data)=>{
	 		//	let allData = that.add2All(eval("(" + data.category + ")"));
			//	that.setState({category : eval("(" + data.category + ")"),allData : allData,isFirst : 0});
				let category = {};
				that.packFolder(data,category,0);

				that.setState({category : category,isFirst : 0,allData : category})
				//console.info(category);
			}); 
	 	}
	},
	packFolder : function(data,category,pid){
		for(let i = 0;i < data.length;i++){
			let cate = {};
			for(let key in data[i]){
				cate.sid = data[i][key].categoryid;
				cate.sname = data[i][key].name;
				cate.pid = pid;
				cate.canCreateDoc = data[i][key]['hasRight'] == "Y" ? true : false;
				category[cate.sid] = cate;
				this.packFolder(data[i][key]['submenus'],category,cate.sid);
			}
		}

	},
	componentDidUpdate : function(){
		let title = this.state.path[this.state.path.length - 1];
		if(title == "/"){
			title = "发布到系统";
		}
		showTitle(title);

		let $obj = document.getElementById("breadcrumbs-one");
		if($obj){
			let _childWidth = 0;
			let $childNodes = $obj.childNodes;
			for(let i = 0;i < $childNodes.length;i++){
				_childWidth += $childNodes[i].clientWidth;
			}
			
			let mwidth = 80;
			try{
				mwidth = window.getComputedStyle(document.getElementById("breadcrumbs-one").childNodes[0].childNodes[0]).width;
				mwidth = mwidth.replace("px","")
			}catch(e){
				mwidth = 80;
			}
			$obj.style.width = _childWidth + parseInt(mwidth) + "px";
		}
		iosSearchKey();
	},
	getCategorys : function(category){
	 	state.isLoading = 1;
	 	Toast.info(<LodingState/>,10);
		return new Promise((resolve,reject)=>{
	//      fetch('/mobile/plugin/networkdisk/getDataList.jsp?sessionkey=' + sessionkey + '&method=getCategorys&category=' + category, { 
			fetch('/mobile/plugin/networkdisk/getCategory.jsp?sessionkey=' + sessionkey + '&operationcode=0&timestap=' + new Date().getTime() 
					+ '&hasTab=1&_fromURL=4' + '&categoryname=' + this.state.searchTxt,{
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
	    });
	},
	cancel : function(){
		state.backFreash = 2;
		state.diskState = DiskObj.state;
		this.props.history.goBack();
	},
	prev : function(){
		if(this.state.pid == 0){
			this.cancel();
		}else{
			this.openFolder(this.state.allData[this.state.pid].pid);
		}
	},
	onSearch : function(){
		if(document.getElementsByClassName("am-search-value").length > 0){
			document.getElementsByClassName("am-search-value")[0].blur();
		}
		if(this.state.keyword.trim() == ""){
			this.state.category = this.state.allData;
			this.openFolder(0);
		}else{
			this.state.searchTxt = this.state.keyword;
			let that = this;
			this.getCategorys().then(function(data){
				let category = {};
				that.packFolder(data,category,0);
				that.state.category = category;
				that.openFolder(0);
			});
		}
	},
	onChange : function(value){
		this.setState({keyword : value})
	},
	focus : function(){

	},
	clear : function(){
		this.state.category = this.state.allData;
		this.openFolder(0);
	},
	openFolder : function(e){
		let id = 0;
		if(typeof(e) == "object"){
			let _from = e.target.getAttribute("data-from");
			if(_from == "nav"){
				id = e.target.getAttribute("data-dataid");
			}else{
				let $obj = e.target;
				while($obj.tagName != "LI"){
					$obj = $obj.parentNode;
				}
				id = $obj.getAttribute("data-dataid");
			}
		}else{
			id = e;	
		}

		let allData = this.state.allData[id];
		let path = [FontList.systemFolder];
		let ids = [0];
		if(allData){
			path.push(allData.sname);
			ids.push(allData.sid);
			while(allData.pid != 0){
				allData = this.state.allData[allData.pid];
				path.push(allData.sname);
				ids.push(allData.sid);
			}
		}
		let npath = [FontList.systemFolder];
		let nids = [0];
		for(let i = path.length - 1;i > 0;i--){
			npath.push(path[i]);
			nids.push(ids[i]);
		}

		this.setState({pid : id,path : npath,pids : nids,canSelect : id == 0 ? false : this.state.allData[id].canCreateDoc});
	},
	getKeys : function(){
		let keys = [];
		let map = this.state.category;
		for(let key in map){
			if(map[key].pid == this.state.pid){
				keys.push(key);
			}
		}
		return keys;
	},
	onPublic : function(e){
		if(e.target.className.indexOf("canSelect") == -1)
			return;
		let files = this.state.fileids.split(",");
		let folders = this.state.folderids.split(",");
		alert(
			<div>
				<div>{FontList.isSure}</div>
				{
					files.map((id)=>{
						return (
							fileList.map((file) => {
								if(file.id == id){
									return (
										<div key={id}>《{file.name}》</div>
									)
								}
							})
						)
					})
				}
			
				{
					folders.map((id)=>{
						return (
							folderList.map((folder) => {
								return (
									folder.id == id &&
										<div key={id}>《{folder.name}》</div>
								)	
							})
						)
					})
				}
				<div>{FontList.publicSystem}
					{
						this.state.path.map((data,i)=>{
							return (
									i > 0 ?
									<span>
										<span>{data}</span>
										<span>/</span>
									</span>
									:
									<span>/</span>	
								)
						})
					}
				</div>
			</div>,"",[
			{text : FontList.cancel,onPress : () => console.log("cancel")},
			{text : FontList.ensure,onPress : () => 
				{
					this.doPublic();
				}
			}
		]); 
	},
	doPublic : function(){
		let that = this;
		state.isLoading = 1;
		Toast.info(<LodingState/>,10);
		new Promise((resolve,reject)=>{
	      fetch('/mobile/plugin/networkdisk/getDataList.jsp?sessionkey=' + sessionkey + '&method=public&fileids=' + this.state.fileids + '&folderids=' + this.state.folderids + '&category=' + this.state.pid, {
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
	    	if(data && data.flag == "1"){
				state.successInfo = 1;
				state.successMsg = FontList.publicSuccess;
				that.cancel();
	    	}
	    });
	},

	render : function(){
		
		let keys = this.getKeys();
		let i = 0;
		let height = window.innerHeight - (this.state.canSelect ? 89*window.viewportScale : 69*window.viewportScale);
		return (
			<div id="content">
				<div className="diskHeader">
					<div className="diskSearch">
						<SearchBar 
						  value={this.state.keyword}
						  placeholder={this.state.promptStr}
						  onSubmit={this.onSearch}
						  onCancel={this.cancel}
						  showCancelButton={true}
						  onChange={this.onChange}
						  onFocus={this.focus}
						  onClear={this.clear}/>
					</div>
				</div>
				<NavPath clientEvent={this.openFolder} path={this.state.path} ids={this.state.pids}/>
				<div className="publicContent" style={{height : height,overflow : 'auto'}}>
					<ul style={{height:keys.length > 0 || this.state.isFirst == 1 ? 'auto' : '100%'}}>
						{
							keys.length > 0 || this.state.isFirst == 1?	
								<CategoryListView 
									keys={keys} 
									pid={this.state.pid}
									fileids={this.state.fileids}
									folderids={this.state.folderids}
									category={this.state.category}
									openFolder={this.openFolder}
									/>
							:
							(
								<li className="folderEmpty">
									<img src={IconList.publicEmpty}/>
									<div className="EmptyBtn">
										<a className="selectBtn canSelect" onClick={this.onPublic}>
											{FontList.publicEmptyFont}
										</a>
									</div>
								</li>
							)
						}	
					</ul>
				</div>
			
				{
					this.state.canSelect && keys.length > 0 &&
					<div className="publicFoot canSelect" onClick={this.onPublic}>
						{FontList.publicComfirmFont}
					</div>
				}
				
			</div>
		)
	}
})

//<Link to={{pathname:'/PublicDoc',query:{fileids:that.props.fileids,folderids:that.props.folderids,category:key}}}>
//</Link>
const CategoryListView = React.createClass({
	render : function(){
		let that = this;
		return (
			<List>
				{
					this.props.keys.map((key)=>{
						return (
							<div key={key}>
								{
									<List.Item>
										
											<li data-dataid={key} onClick={that.props.openFolder}>
												<div className="categoryFolder">
													<img src={IconList.folderIcon}/>
												</div>
												<div className="categoryName">
													{that.props.category[key].sname}
												</div>
											</li>
										
									</List.Item>
								}
							</div>
						)
					})
				}
			</List>
		)
	}
})


const PrivateCategory = React.createClass({
	getInitialState : function(){
		prevStep = ()=>{
			this.prev();
		}
		getPid = ()=>{
			return DEFAULT_VIEW == "PrivateCategory" ? this.state.pid : 1;
		}
		let params = {};
		if(DEFAULT_VIEW == "PrivateCategory"){
			params = DEFAULT_PARAMS;
		}else{
			params = this.props.location.query;
		}
		return ({
			keyword : '',  //搜索关键字
			searchTxt : '',
			pid : params.category ? params.category : 0, //上级目录id
			category : [],
			allData : {},
			currentCate : params.currentCate ? params.currentCate : "", //文件、文件夹当前目录（移动到过滤不能移动）
			searchStr : FontList.searchStr, //搜索按钮
			promptStr : FontList.promptStr, //输入框内提示文字
			path : [FontList.diskFont], //已选目录
			pids : [0],
			isFirst : '1',
			fileids : params.fileids,
			folderids : params.folderids,
			operateType : params.operateType ? params.operateType : 'save',
			shareids : params.shareids,
			saveFn : 0,//保存成功回调
			warmState : 0, //是否弹出轻提示
			warmMsg : '' //弹出轻提示文字
		});
	},
	componentDidUpdate : function(){
		let title = this.state.path[this.state.path.length - 1];
		if(title == "/"){
			if(this.state.operateType == "save"){
				title = FontList.save2DiskFontSim;
			}else if(this.state.operateType == "move"){
				title = FontList.moveComfirmFont;
			}else if(this.state.operateType == "upload"){
				title = FontList.upload2Disk;
			}
		}
		showTitle(title);

		let $obj = document.getElementById("breadcrumbs-one");
		if($obj){
			let _childWidth = 0;
			let $childNodes = $obj.childNodes;
			
			for(let i = 0;i < $childNodes.length;i++){
				_childWidth += $childNodes[i].clientWidth;
			}


			let mwidth = 80;
			try{
				mwidth = window.getComputedStyle(document.getElementById("breadcrumbs-one").childNodes[0].childNodes[0]).width;
				mwidth = mwidth.replace("px","")
			}catch(e){
				mwidth = 80;
			}
			$obj.style.width = _childWidth + parseInt(mwidth) + "px";
		}
		iosSearchKey();


		if(this.state.saveFn == 1){
			saveFromMsgFn();
		}else if(this.state.warmMsg == 1){
			this.setState({
				warmState : 0,
				warmMsg : ''
			})
		}
	},
	cancel : function(){
		if("PrivateCategory" == DEFAULT_VIEW){
			if(DEFAULT_PARAMS.operateType == "upload"){
				location.href = location.href.replace("&viewType=PrivateCategory","")
								.replace("viewType=PrivateCategory","")
								.replace("&imagefileid=" + this.state.fileids,"")
								.replace("imagefileid=" + this.state.fileids,"") + "&defaultFolderid=" + this.state.pid;
			}					
		}else{
			DiskObj.removeSession(this.state.pid,"disk");
			state.backFreash = 1;
			state.diskState = DiskObj.state;
			state.diskState.searchStatus = 0;
			this.props.history.goBack();
		}
	},
	prev : function(){
		if(this.state.pid == 0 || !this.state.allData[this.state.pid]){
			this.cancel();
		}else{
			this.openFolder(this.state.allData[this.state.pid].pid);
		}
	},
	getCategorys : function(category){
		state.isLoading = 1;
		Toast.info(<LodingState/>,10);
		return new Promise((resolve,reject)=>{
	      fetch('/mobile/plugin/networkdisk/getDataList.jsp?sessionkey=' + sessionkey + '&method=getPrivateCategorys&categoryname=' + this.state.searchTxt, {
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
	    });
	},
	componentDidMount : function(){
		if(this.isMounted()){
			let that = this;
	 		this.getCategorys(this.state.pid).then((data)=>{
				that.setState({
					category : data.data,
					allData : data.data,
					isFirst : 0
				});
			}); 
	 	}
	},
	onSearch : function(){
		if(document.getElementsByClassName("am-search-value").length > 0){
			document.getElementsByClassName("am-search-value")[0].blur();
		}
		if(this.state.keyword.trim() == ""){
			this.state.category = this.state.allData;
			this.openFolder(0);
		}else{
			let category = {};
			for(let key in this.state.allData){
				if(this.state.allData[key].name.indexOf(this.state.keyword) > -1 && !category[key]){
					category[key] = this.state.allData[key];
					let k = key;
					while(this.state.allData[category[k].pid] && !category[category[k].pid]){
						k = this.state.allData[category[k].pid].id;
						category[k] = this.state.allData[k];
					}
				}
			}
			this.state.category = category;
			this.openFolder(0);
			//this.state.searchTxt = this.state.keyword;
			//let that = this;
			//this.getCategorys().then(function(data){
			//	that.state.category = data.data;
			//	that.openFolder(0);
			//});
		}
	},
	onChange : function(value){
		this.setState({keyword : value});
	},
	focus : function(){

	},
	clear : function(){
		this.setState({
			category : this.state.allData
		});
	},
	openFolder : function(e){
		if(this.state.saveFn == 1){
			return
		}

		let id = 0;
		if(typeof(e) == "object"){
			let _from = e.target.getAttribute("data-from");
			if(_from == "nav"){
				id = e.target.getAttribute("data-dataid");
			}else{
				let $obj = e.target;
				while($obj.tagName != "LI"){
					$obj = $obj.parentNode;
				}
				id = $obj.getAttribute("data-dataid");
			}
		}else{
			id = e;	
		}
		
		let allData = this.state.allData[id];
		let path = [FontList.diskFont];
		let pids = [0];
		if(allData){
			path.push(allData.name);
			pids.push(allData.id)
			while(this.state.allData[allData.pid]){
				allData = this.state.allData[allData.pid];
				path.push(allData.name);
				pids.push(allData.id)
			}
		}
		let npath = [FontList.diskFont];
		let nids = [0];
		for(let i = path.length - 1;i > 0;i--){
			npath.push(path[i]);
			nids.push(pids[i]);
		}

		this.setState({
			pid : id,
			pids : nids,
			path : npath,
			warmState : 0,
			warmMsg : ''
		});
	},
	onSave : function(){
		if(this.state.saveFn == 1){
			return
		}

		state.isLoading = 1;
		Toast.info(<LodingState/>,10);
		let that = this;
		let method = "";
		let _msg = "";
		if(this.state.operateType == "move"){
			method = "move";
			_msg = FontList.moveSuccess;
		}else if(this.state.operateType == "upload"){
			method = "uploadAsExist";
			_msg = FontList.uploadSuccess;
		}else{
			method = "save2Disk";
			_msg = FontList.saveSuccess;
		}
		new Promise((resolve,reject)=>{
	      fetch('/mobile/plugin/networkdisk/getDataList.jsp?sessionkey=' + sessionkey + '&method=' + method + '&folderid=' + this.state.pid + 
	      		'&fileids=' + this.state.fileids + '&folderids=' + this.state.folderids + '&shareids=' + this.state.shareids + "&from=" + this.state.operateType, {
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
	    	if(data && data.flag == 1){
	    		if("PrivateCategory" == DEFAULT_VIEW && that.state.operateType == "saveFromMsg"){
	    			that.setState({
		    			warmState : 1,
		    			saveFn : 1,
		    			warmMsg : data.msg ? data.msg : '保存成功!'
		    		});	
	    		}else{
	    			state.successInfo = 1;
					state.successMsg = _msg;	
					that.cancel();
	    		}
	    	}else if(data && data.flag == -1){//共享已删除
	    		that.setState({
	    			warmState : 1,
	    			warmMsg : data.msg ? data.msg : '共享已删除!'
	    		});	
	    	}else if(data && data.flag == -2){//文件已删除
	    		that.setState({
	    			warmState : 1,
	    			warmMsg : data.msg ? data.msg : '文件已删除!'
	    		});
	    	}else{//保存失败
	    		that.setState({
	    			warmState : 1,
	    			warmMsg : data.msg ? data.msg : '保存失败!'
	    		});
	    	}
	    });
	},
	getCurrentCate : function(){
		let category = [];
		for(let key in this.state.category){
			if(this.state.folderids != "" && ("," + this.state.folderids + ",").indexOf("," + key + ",") > -1)
				continue;
			if(this.state.pid == this.state.category[key].pid){
				category.push(this.state.category[key]);
			}
		}
		return category;
	},
	render : function(){
		let that = this;
		let comfirmFont = FontList.saveComfirmFont;
		if(this.state.operateType == "move"){
			comfirmFont = FontList.moveComfirmFont;
		}else if(this.state.operateType == "upload"){
			comfirmFont = FontList.uploadComfirmFont;
		}
		let category = this.getCurrentCate();
		let mulHeight = 0;
		if(category.length > 0 && (this.state.operateType != "move" || this.state.currentCate != this.state.pid)){
			mulHeight = 114*window.viewportScale;
		}
		let height = window.innerHeight - mulHeight;
		return (
			<div id="content">
				<div className="diskHeader">
					<div className="diskSearch">
						<SearchBar 
						  value={this.state.keyword}
						  placeholder={this.state.promptStr}
						  onSubmit={this.onSearch}
						  onCancel={this.cancel}
						  showCancelButton={true}
						  onChange={this.onChange}
						  onClear={this.clear}
						  onFocus={this.focus}/>
					</div>
				</div>
				<NavPath clientEvent={this.openFolder} path={this.state.path} ids={this.state.pids}/>
				<div className="publicContent" style={{height : height,overflow : 'auto'}}>
					<ul style={{height:this.state.category.length > 0 || this.state.isFirst == 1 ? 'auto' : '100%'}}>
						{
							category.length > 0 || this.state.isFirst == 1?	
								<List>
								{
									category.map((data)=>{
										return (
												<List.Item key={data.id}>
										
													<li data-dataid={data.id} onClick={that.openFolder}>
														<div className="categoryFolder">
															<img src={IconList.folderIcon}/>
														</div>
														<div className="categoryName">
															{data.name}
														</div>
													</li>
												
											</List.Item>

											)
									})
								}
								</List>
							:
							(
								<li className="folderEmpty" >				
									{
										(this.state.operateType == "save" || this.state.operateType == "saveFromMsg") &&
										<div>
											<img src={IconList.publicEmpty}/>
											<div className="EmptyBtn">
												<a className="selectBtn" onClick={this.onSave}>
													{FontList.save2DiskEmptyFont}
												</a>
											</div>

										</div>
									}
									
									{
										this.state.operateType == "move" && this.state.currentCate != this.state.pid &&
										<div>
											<img src={IconList.publicEmpty}/>
											<div className="EmptyBtn">
												<a className="selectBtn" onClick={this.onSave}>
													{FontList.moveEmptyFont}
												</a>
											</div>
										</div>
									}

									{
										this.state.operateType == "move" && this.state.currentCate == this.state.pid &&
										<div>
											当前要移动的文件、目录已在该目录!
										</div>
									}

									{
										this.state.operateType == "upload" &&
										<div>
											<img src={IconList.publicEmpty}/>
											<div className="EmptyBtn">
												<a className="selectBtn" onClick={this.onSave}>
													{FontList.uploadEmptyFont}
												</a>
											</div>
										</div>
									}	
								</li>
							)
						}	
					</ul>
				</div>
				{
					category.length > 0 && (this.state.operateType != "move" || this.state.currentCate != this.state.pid) &&
					<div className="publicFoot canSelect" onClick={this.onSave}>
						{comfirmFont}
					</div>
				}
				{
					this.state.warmState == 1 &&
					<SuccessState msg={this.state.warmMsg}/>
				}
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




const SuccessState = React.createClass({
	componentDidMount : function(){
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


//ReactDOM.render(<Disk />,document.getElementById('root'));
if(DEFAULT_VIEW == "PrivateCategory"){
	ReactDOM.render(<PrivateCategory/>,document.getElementById("root"));
}else if(DEFAULT_VIEW == "ChooseSystemDoc"){
	ReactDOM.render(<SystemDoc/>,document.getElementById("root"));
}else{
	ReactDOM.render((
	  <Router history={hashHistory}>
	    <Route path="/" component={Disk}/>
	    <Route path="/PublicDoc" component={PublicDoc} />
	    <Route path="/PrivateCategory" component={PrivateCategory} />
	    <Route path="/ShareObject" component={ShareObject} />
	    <Route path="/SystemDoc" component={SystemDoc} />
	  </Router>
	), document.getElementById('root'));
}