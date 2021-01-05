<%@ page language="java" pageEncoding="utf-8"%>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.conn.RecordSet"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<%@ page import="weaver.rdeploy.doc.PrivateSeccategoryManager,
				weaver.rdeploy.doc.MultiAclManagerNew,
				weaver.rdeploy.doc.SeccategoryShowModel" %>

<!DOCTYPE HTML>
<html>
	<%
		String isBrowser = Util.null2String(request.getParameter("isBrowser"));
	%>
	<head>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		
		<style>
			span.folder,span.file{
				cursor:pointer;
			}
			span.folder.hover,span.file.hover{
				color:#3597F1;
			}
			.content {
				font-size:12px!important;
			}
			td[align='right'],th[align='right']{
			 text-align:right !important;
			}
			td[align='center'],th[align='center']{
             text-align:center !important;
            }
		</style>
		<%if("".equals(isBrowser)){%>
		<script>
			location.href = location.href + "&isBrowser=" + (window.Electron ? "0" : "1");
		</script>
		<%
			return;
		}%>
	</head>
	<%
			String cid = Util.null2String(request.getParameter("categoryid"));
	
			String orderby = Util.null2String(request.getParameter("orderby"));	
			String loadFolderType = Util.null2String(request.getParameter("loadFolderType"));	
			orderby = orderby.isEmpty() ? "name" : orderby;
			loadFolderType = loadFolderType.isEmpty() ? "privateAll" : loadFolderType;
			
			int categoryid = Util.getIntValue(cid,0);	
			
			String iconCol = "50px";
            String userCol = "150px";
            String sizeCol = "150px";
            String timeCol = "300px";
            String operateCol = "10px";
			
			String where = "";
			RecordSet rs = new RecordSet();
			boolean isoracle = (rs.getDBType()).equals("oracle") ;
			String fileType = "0";
			
			String txt = Util.null2String(request.getParameter("txt"));
			txt = txt.replaceAll("'","''");
			
			String backfields = "id,name,shareid,filesize,updatetime,type";
			String fromSql = "";
			//String parentid = categoryid + "";
		    String tableString = "";
			String operateString = "";
			String subDocscribe = Util.null2String(request.getParameter("subDocscribe"));
			boolean createDoc = false;
			if("publicAll".equals(loadFolderType)){//公共目录
			   if("1".equals(subDocscribe)){
			       tableString = "<table tabletype=\"checkbox\" datasource=\"weaver.rdeploy.doc.MultiAclManagerNew.getDocSubscribeTableList\" sourceparams=\"id:" + categoryid + "+type:" + fileType + "\" pagesize=\"10\" pageBySelf=\"true\"> "+
				   "<sql backfields=\"*\" sqlform=\"tmpTable\" sqlorderby=\"type\" sqlsortway=\"desc\" sqlprimarykey=\"id\" />";
			   }else{
			       
			       String createrid = Util.null2String(request.getParameter("createrid"));
			       String departmentid = Util.null2String(request.getParameter("departmentid"));
			       String seccategory = Util.null2String(request.getParameter("seccategory"));
			       String createdatefrom = Util.null2String(request.getParameter("createdatefrom"));
			       String createdateto = Util.null2String(request.getParameter("createdateto"));
			       String bySearch = Util.null2String(request.getParameter("bySearch"));
			       String para = "";
			       if("1".equals(bySearch)){
			           para += "+bySearch:" + bySearch;
			           para += "+createrid:" + createrid;
			           para += "+departmentid:" + departmentid;
			           para += "+seccategory:" + seccategory;
			           para += "+createdatefrom:" + createdatefrom;
			           para += "+createdateto:" + createdateto;
			       }
			       
			        tableString = "<table tabletype=\"checkbox\" datasource=\"weaver.rdeploy.doc.MultiAclManagerNew.getPublicData\" sourceparams=\"id:" + categoryid + "+type:" + fileType + "+txt:" + txt + para + "\" pagesize=\"10\" pageBySelf=\"true\"> "+
					   "<sql backfields=\"*\" sqlform=\"tmpTable\" sqlorderby=\"type\" sqlsortway=\"desc\" sqlprimarykey=\"id\" />";
				    
				    rs.executeSql("select parentid from DocSecCategory where id=" + categoryid);
				    if(rs.next()){
				        MultiAclManagerNew manager = new MultiAclManagerNew();
				        Map<String,SeccategoryShowModel> canCreaterDoc = manager.packageCategorys(user,rs.getString("parentid"),0,0);
				        if(canCreaterDoc.get(categoryid + "") != null){
				            createDoc = true;
				        }
				    }
				    operateString += "<operates width=\"" + operateCol + "\">"; 
				    operateString += "     <operate otherpara=\"column:type\" href=\"javascript:doEditDoc()\"   text=\"" + SystemEnv.getHtmlLabelName(26473,user.getLanguage()) + "\" index=\"0\"/>";
				    operateString += "     <operate otherpara=\"column:type\" href=\"javascript:doDelDoc()\"   text=\"" + SystemEnv.getHtmlLabelName(91,user.getLanguage()) + "\" index=\"1\"/>";
				    operateString += "     <operate otherpara=\"column:type\" href=\"javascript:doShareDoc()\"   text=\"" + SystemEnv.getHtmlLabelName(119,user.getLanguage()) + "\" index=\"2\"/>";
				    operateString += "     <operate otherpara=\"column:type\" href=\"javascript:doShowLog()\"   text=\"" + SystemEnv.getHtmlLabelName(83,user.getLanguage()) + "\" index=\"3\"/>";
				    operateString += "	   <popedom column=\"type\" otherpara=\"" + fileType + "+column:canEdit+column:canDelete+column:canShare+1\" transmethod=\"weaver.docs.rdeploy.util.SplitPageForRdeploy.docPremission\"></popedom> ";
				    operateString += "</operates>";
			   }
			}else{ // 私人目录、我的分享、同事的分享
				if("privateAll".equals(loadFolderType)){
				    tableString = "<table tabletype=\"checkbox\" datasource=\"weaver.rdeploy.doc.PrivateSeccategoryManager.getPrivateData\" sourceparams=\"id:" + categoryid + "+orderby:" + orderby + "+txt:" + txt + "\" pagesize=\"10\" pageBySelf=\"true\"> "+
					   "<sql backfields=\"*\" sqlform=\"tmpTable\" sqlorderby=\"type\" sqlsortway=\"desc\" sqlprimarykey=\"id\" />";
				}else{
				    tableString = "<table tabletype=\"checkbox\" datasource=\"weaver.rdeploy.doc.PrivateSeccategoryManager.getShareData\" sourceparams=\"id:" + categoryid + "+loadFolderType:" + loadFolderType + "+orderby:" + orderby + "+txt:" + txt + "\" pagesize=\"10\" pageBySelf=\"true\"> "+
					   "<sql backfields=\"*\" sqlform=\"tmpTable\" sqlorderby=\"type\" sqlsortway=\"desc\" sqlprimarykey=\"id\" />";
				}   
			    operateString += "<operates width=\"" + operateCol + "\">";
			    if("myShare".equals(loadFolderType)){
			    	operateString += "     <operate otherpara=\"column:type\" href=\"javascript:doDownload()\"  text=\"" + SystemEnv.getHtmlLabelName(258,user.getLanguage()) + "\" index=\"0\"/>";
			    	if(categoryid == 0){
				    	operateString += "     <operate otherpara=\"column:type\" href=\"javascript:doShareObj()\"  text=\"查看分享对象\" index=\"0\"/>";
				    	operateString += "     <operate otherpara=\"column:type\" href=\"javascript:doCancelShare()\"   text=\"" + SystemEnv.getHtmlLabelName(129158,user.getLanguage()) + "\" index=\"1\"/>";
			    	}
			    }else if("shareMy".equals(loadFolderType)){
			    	operateString += "     <operate otherpara=\"column:type\" href=\"javascript:doDownload()\"  text=\"" + SystemEnv.getHtmlLabelName(258,user.getLanguage()) + "\" index=\"0\"/>";
			        operateString += "     <operate otherpara=\"column:type+column:shareid\" href=\"javascript:doSave2Disk()\"   text=\"" + SystemEnv.getHtmlLabelName(129159,user.getLanguage()) + "\" index=\"2\"/>";
			    }else{
			    	operateString += "     <operate otherpara=\"column:type\" href=\"javascript:doDownload()\"  text=\"" + SystemEnv.getHtmlLabelName(258,user.getLanguage()) + "\" index=\"0\"/>";
				    if(!"1".equals(isBrowser)){
				    	operateString += "     <operate otherpara=\"column:type\" href=\"javascript:doShare()\"   text=\"" + SystemEnv.getHtmlLabelName(129144,user.getLanguage()) + "\" index=\"1\"/>";
				    }
				    operateString += "     <operate otherpara=\"column:type\" href=\"javascript:doPublic()\"   text=\"" + SystemEnv.getHtmlLabelName(129148,user.getLanguage()) + "\" index=\"2\"/>";
				    operateString += "     <operate otherpara=\"column:type\" href=\"javascript:doCopy()\"   text=\"" + SystemEnv.getHtmlLabelName(77,user.getLanguage()) + "\" index=\"3\"/>";
				    operateString += "     <operate otherpara=\"column:type\" href=\"javascript:doMove()\"   text=\"" + SystemEnv.getHtmlLabelName(129168,user.getLanguage()) + "\" index=\"4\"/>";
				    operateString += "     <operate otherpara=\"column:type\" href=\"javascript:doDel()\"   text=\"" + SystemEnv.getHtmlLabelName(91,user.getLanguage()) + "\" index=\"5\"/>";
				}
			    operateString += "</operates>";
			}
			
			String timeLabel = "";
			if("myShare".equals(loadFolderType) || "shareMy".equals(loadFolderType)){
			    timeLabel = "分享时间";
			}else{
			    timeLabel = SystemEnv.getHtmlLabelName(26805,user.getLanguage()); 
			}
			
			String sharetime = Util.null2String(request.getParameter("sharetime"));
			String username = Util.null2String(request.getParameter("username"));
			String shareid = Util.null2String(request.getParameter("shareid"));
			
		    tableString += operateString;
		    tableString += "<head>";
			tableString += "<col width=\"" + iconCol + "\" labelid=\"22969\"  text=\"\" column=\"" + ("publicAll".equals(loadFolderType) ? "extName" : "name") + "\" otherpara=\"column:type+" + fileType + "\" transmethod=\"weaver.docs.rdeploy.util.SplitPageForRdeploy.getFileType\"/>";
		    tableString += "<col labelid=\"17517\"  text=\"" + SystemEnv.getHtmlLabelName(17517,user.getLanguage()) + "\" column=\"name\" otherpara=\"column:type+" + fileType + "+column:id+column:isNew+column:canDownload\" transmethod=\"weaver.docs.rdeploy.util.SplitPageForRdeploy.getFileName\"/>";
			
		    if("publicAll".equals(loadFolderType) && "1".equals(subDocscribe)){
		    	tableString += "<col align=\"right\" width=\"" + sizeCol + "\" labelid=\"2036\"  text=\"" + SystemEnv.getHtmlLabelName(2036,user.getLanguage()) + "\" column=\"filesize\" otherpara=\"column:type+" + fileType + "\" transmethod=\"weaver.docs.rdeploy.util.SplitPageForRdeploy.formatFileSize\"/>/>";
		    }else{
		    	tableString += "<col align=\"right\" width=\"" + sizeCol + "\" labelid=\"2036\"  text=\"" + SystemEnv.getHtmlLabelName(2036,user.getLanguage()) + "\" column=\"filesize\" />";
		    }
		    if("shareMy".equals(loadFolderType)){
                if(categoryid == 0 || !txt.isEmpty()){
    	            tableString += "<col width=\"" + userCol + "\" labelid=\"26805\"  text=\"分享人\" column=\"username\" />";
				    tableString += "<col width=\"" + timeCol + "\" align=\"center\" labelid=\"26805\"  text=\"" + timeLabel  + "\" column=\"sharetime\"/>";
				    tableString += "<col width=\"0\" labelid=\"26805\"  text=\"\" column=\"shareid\" otherpara=\"column:shareid\" transmethod=\"weaver.docs.rdeploy.util.SplitPageForRdeploy.getCommonValueDisplay\"/>";
                }else{
    	            tableString += "<col width=\"" + userCol + "\" labelid=\"26805\"  text=\"分享人\" otherpara=\"" + username + "\" column=\"shareid\" transmethod=\"weaver.docs.rdeploy.util.SplitPageForRdeploy.getCommonValue\"/>";
				    tableString += "<col width=\"" + timeCol + "\" align=\"center\" labelid=\"26805\"  text=\"" + timeLabel  + "\" otherpara=\"" + sharetime + "\" column=\"shareid\" transmethod=\"weaver.docs.rdeploy.util.SplitPageForRdeploy.getCommonValue\"/>";
				    tableString += "<col width=\"0\" labelid=\"26805\"  text=\"\" otherpara=\"" + shareid + "\" column=\"shareid\" transmethod=\"weaver.docs.rdeploy.util.SplitPageForRdeploy.getCommonValueDisplay\"/>";
                }
                
            }else if("myShare".equals(loadFolderType)){
                if(categoryid == 0 || !txt.isEmpty()){
			    	tableString += "<col width=\"" + timeCol + "\" align=\"center\" labelid=\"26805\"  text=\"" + timeLabel  + "\" column=\"sharetime\"/>";
                }else{
			    	tableString += "<col width=\"" + timeCol + "\" align=\"center\" labelid=\"26805\"  text=\"" + timeLabel  + "\" otherpara=\"" + sharetime + "\" column=\"id\" transmethod=\"weaver.docs.rdeploy.util.SplitPageForRdeploy.getCommonValue\"/>";
                }
            }else{
			    tableString += "<col width=\"" + timeCol + "\" align=\"center\" labelid=\"26805\"  text=\"" + timeLabel  + "\" column=\"updatetime\"/>";
            }
		    tableString += "</head></table>";
		%>
	<body>
		<div id="content" class="content" style="padding:5px">
			<wea:SplitPageTag tableString='<%=tableString%>'
				isShowTopInfo="false" mode="run" />
		</div>
		<div id="dataloading" style="text-align:center;position: absolute;left: 45%;top: 20%;display:none;">
						<img src="/rdeploy/assets/img/doc/loading.gif">
					</div>
					
	<script>
		
		window.__isBrowser = "<%=isBrowser%>" == 1;
		//初始化”公共目录“的公共按钮
		if("publicAll" == "<%=loadFolderType%>"){
			if("<%=categoryid%>" != "" && "<%=categoryid%>" !=0){
				parent.jQuery("#askNoPermission,#markAllDoc").removeClass("disabled");
			}else{
				parent.jQuery("#askNoPermission,#markAllDoc").addClass("disabled");
			}
			
			if(<%=createDoc%>){
				parent.jQuery("#createDoc").removeClass("disabled");
			}else{
				parent.jQuery("#createDoc").addClass("disabled");
			}
			if(parent.publicIdMap["<%=categoryid%>"] && parent.publicIdMap["<%=categoryid%>"].canCreaterDoc == undefined){
				parent.publicIdMap["<%=categoryid%>"].canCreaterDoc	= <%=createDoc%>;
			}
			parent.jQuery("#privateId").val("<%=categoryid%>");
		}
		
		if(parent.jQuery("#loadFolderType").val() == "publicAll"){
			parent.fullDivNav({txt : "<%=txt%>"});
			parent.fullDivNav({txt : "<%=txt%>"},"<%=subDocscribe%>" == "1");
		}else{
			parent.fullPrivateDivNav(parent.jQuery("#loadFolderType").val(),{txt : "<%=txt%>"});
		}
		
		//订阅无权查看的文档
	
		this.PageModel = "tableList"; //表格列表模式
		this.submitFlag = true;	
		jQuery(function(){
			parent.hideLoading();
			parent.disabledOpt(false); 
			jQuery("span.folder,span.file").live({
				mouseover : function(){
					jQuery(this).addClass("hover");
				},
				mouseout : function(){
					jQuery(this).removeClass("hover");
				},
				click : function(){
					var _id = jQuery(this).attr("dataid");
					if(jQuery(this).hasClass("file")){
						doOpen(_id);
					}else{
						if(window.submitFlag){
							window.submitFlag = false;
							doOpen(_id);
		                }
					}
				}
			});
			
			
			jQuery(":checkbox,.jNiceCheckbox").live({
				click : function(){
					if(jQuery(".ListStyle tbody").find(":checkbox:checked").length == 0){
						parent.disabledOpt(false);
					}else{
						parent.disabledOpt(true);
					}
					parent.hideRightClickMenu();
				}
			});
			
			jQuery(document).unbind("contextmenu").bind("contextmenu", function (e) { //禁用鼠标右键系统菜单
		        return false;
		    });
			jQuery(window).mousedown(function(e){ //绑定鼠标点击事件
				e = e || event;
				//隐藏高级菜单
				parent.$(".hiddensearch").animate({
					height: 0
					}, 200,null,function() {
						parent.jQuery(".hiddensearch").hide();
				}); 
				parent.hideUploadView();
				if(e.button == "0"){
					parent.hideRightClickMenu();
				}else if(e.button == "2"){
					e.preventDefault();
		            var _left = e.clientX;
		            var _top = e.clientY;
					parent.showRightMenuByPosition(_left,_top);
				}
			});
			
		});
		
		//获取选中文件夹、文件id
		function getselectIds(){
			var folderid = "";
			var fileid = "";
			
			jQuery(".ListStyle tbody").find(":checkbox:checked").each(function(){
				var $obj = jQuery(this).closest("tr").find("span.file,span.folder");
				var _id = jQuery(this).attr("checkboxid");
				if($obj.hasClass("file")){
					fileid += "," + _id;
				}else if($obj.hasClass("folder")){
					folderid += "," + _id;
				}
			});
			folderid = folderid == "" ? "" : folderid.substring(1);
			fileid = fileid == "" ? "" : fileid.substring(1);
			return {folderid : folderid,fileid : fileid};
		}
		
		//获取选中文件夹、文件
		function getselectItems(){
			var folderid = "";
			var fileid = "";
			var resultMap = {};
			var folderArray = new Array();
			var fileArray = new Array();
			jQuery(".ListStyle tbody").find(":checkbox:checked").each(function(){
				var $obj = jQuery(this).closest("tr").find("span.file,span.folder");
				var _id = jQuery(this).attr("checkboxid");
				var _title = $obj.html();
				var selectItem = {};
				selectItem['id'] = _id ;
				selectItem['name'] = _title;
				if($obj.hasClass("file")){
					fileArray.push(selectItem);
				}else if($obj.hasClass("folder")){
					folderArray.push(selectItem);
				}
			});
			resultMap['folderArray'] = folderArray;
			resultMap['fileArray'] = fileArray;
			return resultMap;
		}
		
		//公共目录重新获取数据
		function fullItemData(categoryid,itemData,params){
			fullPrivateItemData(categoryid,itemData,params);
		} 
		
		//重新获取数据
		function fullPrivateItemData(categoryid,itemData,params){
			if(params){
				parent.IS_SEARCH = true;
			}else{
				parent.IS_SEARCH = false;
			}
			parent.showLoading();
			parent.jQuery("#privateId").val(categoryid);
			var loadFolderType = parent.jQuery("#loadFolderType").val();
			
			var _href = "";
			
			var para = "";
			if(loadFolderType == "shareMy"){
				if(categoryid > 0 && (!params || !params.txt || params.txt == "")){
					para = "&sharetime=" + parent.shareMyIdMap[categoryid].sharetime + "&username=" + parent.shareMyIdMap[categoryid].username + "&shareid=" + parent.shareMyIdMap[categoryid].shareid; 
				}
			}else if(loadFolderType == "myShare"){
				if(categoryid > 0 && (!params || !params.txt || params.txt == "")){
					para = "&sharetime=" + parent.myShareIdMap[categoryid].sharetime;
				}
			}else if(loadFolderType == "publicAll"){
				if(params){
					if(params.createrid){
						para += "&createrid=" + params.createrid;
					}
					if(params.departmentid){
						para += "&departmentid=" + params.departmentid;
					}
					if(params.seccategory){
						para += "&seccategory=" + params.seccategory;
					}
					if(params.createdatefrom){
						para += "&createdatefrom=" + params.createdatefrom;
					}
					if(params.createdateto){
						para += "&createdateto=" + params.createdateto;
					}
					if(para != "" || params.txt){
						para += "&bySearch=1";
					}
				}
			}
			
			if(categoryid == 0){
				_href = "/rdeploy/chatproject/doc/seccategoryTableList.jsp?categoryid=" 
					+ "&orderby=" + (parent.ORDER_BY ? parent.ORDER_BY : "") 
					+ "&loadFolderType=" + parent.jQuery("#loadFolderType").val() + para;
			}else{
				
				_href = "/rdeploy/chatproject/doc/seccategoryTableList.jsp?categoryid=" + categoryid 
					+ "&orderby=" + (parent.ORDER_BY ? parent.ORDER_BY : "")
					+ "&loadFolderType=" + parent.jQuery("#loadFolderType").val() + para;
			}
			if(params && params.txt && params.txt != ""){
				_href += "&txt=" + params.txt;
			}
			
			if(loadFolderType == "publicAll" && para.length > 0){
				getAllParents(categoryid,function(){
					location.href = _href;
				});
			}else{
				location.href = _href;
			}	
		}
		
		function getAllParents(categoryid,fn){
			if(parent.publicIdMap[categoryid]){
				fn();
				return;
			}
		
			jQuery.ajax({
				url : "/rdeploy/chatproject/doc/eventForAjax.jsp",
				type : "post",
				data : {categoryid : categoryid,type : "publicParents"},
				dataType : "json",
				success : function(data){
					if(data && data.flag == "1"){
						for(var i = 0;i < data.dataList.length;i++){
							parent.publicIdMap[data.dataList[i].sid] = data.dataList[i];
						}
					}
				},complete : function(){
					fn();
				}
			});
			
		}
		
		//复制事件，将复制的文件夹、文件id存放到存储对象中
		function saveIdByCopy(){
			return getselectItems();
		}
		
		//发布到系统
		function doPublic(id,type){
			parent.onPublic(operateData(id,type));
		}
		
		//移动到
		function doMove(id,type){
			parent.onMove(operateData(id,type));
		}
		
		//复制
		function doCopy(id,type){
			var map = operateData(id,type);
			var folderArray = [];
			var fileArray = [];
			if(map.folderid != ""){
				folderArray.push({
					id : id,
					name : jQuery("span.folder[dataid='" + id + "']").html()
				});
			}else if(map.fileid){
				fileArray.push({
					id : id,
					name : jQuery("span.file[dataid='" + id + "']").html()
				});
			}
			
			parent.CopyObject = {
				folderArray : folderArray,
				fileArray : fileArray,
				currentId : parent.getCurrentCateId()
			}
			parent.copySuccess();
		}
		
		//分享
		function doShare(id,type){
			var map = operateData(id,type);
			var folderArray = [];
			var fileArray = [];
			if(map.folderid != ""){
				folderArray.push({
					id : id,
					name : jQuery("span.folder[dataid='" + id + "']").html()
				});
			}else if(map.fileid){
				fileArray.push({
					id : id,
					name : jQuery("span.file[dataid='" + id + "']").html()
				});
			}
			parent.onShare({
				folderArray : folderArray,
				fileArray : fileArray
			});
		}
		
		//查看分享对象
		function doShareObj(id,type){
			if(type == "<%=fileType%>"){ //文件
				dataMap = {
					folderid : "",
					fileid : id,
					shareid : ""
				}
			}else{ //文件夹
				dataMap = {
					folderid : id,
					fileid : "",
					shareid : ""
				}
			}
			parent.onShowShareObj(dataMap);
		}
		
		//取消分享
		function doCancelShare(id,type){
			if(type == "<%=fileType%>"){ //文件
				dataMap = {
					folderid : "",
					fileid : id,
					shareid : ""
				}
			}else{ //文件夹
				dataMap = {
					folderid : id,
					fileid : "",
					shareid : ""
				}
			}
			parent.onCancelShare(dataMap);	
		
		}
		
		//保存到网盘
		function doSave2Disk(id,type){
			var filetype = type.substring(0,type.indexOf("+"));
			var shareid = type.substring(type.indexOf("+") + 1);
			if(filetype == "<%=fileType%>"){ //文件
				dataMap = {
					folderid : "",
					fileid : id,
					shareid : shareid
				}
			}else{ //文件夹
				dataMap = {
					folderid : id,
					fileid : "",
					shareid : shareid
				}
			}
			parent.onSave2Disk(dataMap);	
		}
		
		//删除
		function doDel(id,type){
			parent.onDelete(operateData(id,type));
		}
		
		//下载
		function doDownload(id,type){
			if(type == "<%=fileType%>"){ //文件
				dataMap = {
					folderid : "",
					fileid : id
				}
			}else{ //文件夹
				dataMap = {
					folderid : id,
					fileid : ""
				}
			}
			parent.onDownload(dataMap);
		}
		
		//重命名
		function doRename(){
			 var $obj = jQuery(".ListStyle tbody").find(":checkbox:checked").closest("tr").find("span.file,span.folder");
			 if($obj.siblings(".renameInput").length > 0) return;
			 var _name = $obj.html();
			 var _extname = "";
			 if(_name.indexOf(".") > -1){
			 	_extname = _name.substring(_name.lastIndexOf("."));
				_name = _name.substring(0,_name.lastIndexOf("."));
			 }
			 var $input = jQuery("<input type='text' style='2px solid rgb(238, 238, 238);padding:1px 2px' class='renameInput' extname='" + _extname + "' value='" + _name + "' style='width:80%'/>");
			 
			 $input.blur(function(){
			 	var _uid = parent.userInfos.guid;
			 	var _name = this.value + jQuery(this).attr("extname");
			 	
			 	var that = this;
			 	if(_name == ""){
		    		top.Dialog.alert("名称不能为空!",function(){
		    			jQuery(that).focus();
		    		});
		    		return;
		    	}else if(/[\\/:*?"<>|]/.test(_name)){
		    		top.Dialog.alert("名称不能包含下列字符：<br/>\\/:*?\"<>|",function(){
		    			jQuery(that).focus();
		    		});
		    		return;
		    	}
			 	
			 	var _id = jQuery(this).siblings("span.file,span.folder").attr("dataid");
				var data;
				var url = "";
				if($obj.hasClass("file")){
					url = "/rdeploy/chatproject/doc/renameImageFile.jsp"
					data = {
						fileName : _name,
						imagefileid : _id,
						uid : _uid,
						categoryid : parent.getCurrentCateId()
					}
				}else if($obj.hasClass("folder")){
					url = "/rdeploy/chatproject/doc/addSeccategory.jsp"
					data = {
						foldertype : "privateAll",
						categoryname : _name,
						categoryid : _id
					}
				}else{
					return;
				}
			 var that = this;
			 	jQuery.ajax({
					url : url,
					type : "post",
					data : data,
					dataType : "json",
					success : function(data){
						if(true){
							jQuery(that).siblings("span.file,span.folder").show().html(_name).parent().attr("title",_name);
							jQuery(that).remove();
						}else{
							var $input = jQuery(that);
							focusLast($input);
						}
					}
				})
			 });
			 $obj.hide().after($input);
			 focusLast($input);
		}
		
		//选中对象，并将光标移动到上个状态
		function focusLast($input){
			$input.focus();
			var pos = $input.val().length;
			if($input[0].setSelectionRange){
				$input[0].setSelectionRange(pos,pos);
			}else if ($input[0].createTextRange) {
				var range = $input[0].createTextRange(); 
				range.collapse(true); 
				range.moveEnd('character', pos); 
				range.moveStart('character', pos); 
				range.select(); 
			}
		}
		
		function operateData(id,type){
			var isFile = 0;
			if(type == "<%=fileType%>"){
				isFile = 1;
			}
			return {
					folderid : isFile == 1 ? "" : id,
					fileid : isFile == 1 ? id : ""
				};
		}
		
		function cancelSelect(){
			jQuery(":checkbox:checked").each(function(){
				this.checked = false;
			});	
		}
		
		//重新加载table 
		function reload(){
			_table.reLoad();
		};
		
		function addView(){
			reload();
		}
		
		function fullPrivateDocitem(){
		    reload();
		}
		
		function fillParentMap(data){
			var loadFolderType = parent.jQuery("#loadFolderType").val();
			if(loadFolderType == "privateAll"){
				parent.privateIdMap[data.sid] = data;
			}else if(loadFolderType == "myShare"){
				if(data){
					var sharetime = jQuery(".folder[dataid='" + data.sid + "']").closest("td").next().next().html();
					data.sharetime = sharetime;
					parent.myShareIdMap[data.sid] = data;
				}
			}else if(loadFolderType == "shareMy"){
				if(data){
					var sharetime = jQuery(".folder[dataid='" + data.sid + "']").closest("td").next().next().next().html();
					var username = jQuery(".folder[dataid='" + data.sid + "']").closest("td").next().next().html();
					var shareid = jQuery(".folder[dataid='" + data.sid + "']").closest("td").next().next().next().next().text();
					data.sharetime = sharetime;
					data.username = username;
					data.shareid = shareid;
				}
				parent.shareMyIdMap[data.sid] = data;
			}else if(loadFolderType == "publicAll"){
				parent.publicIdMap[data.sid] = data;
			}
		}
		
		function doOpen(id){
			//jQuery("span.folder,span.file")
			//id = id ? id : jQuery("
			var $obj;
			if(id){
				$obj = jQuery("span[dataid='" + id + "']");
			}else{
				$obj = jQuery(".ListStyle tbody").find(":checkbox:checked").closest("tr").find("span.file,span.folder");
				id = $obj.attr("dataid");
			}
			
			if($obj.length != 1){
				return;
			}
			var sname = $obj.html();
			if($obj.hasClass("file")){
				if(parent.jQuery("#loadFolderType").val() == "publicAll"){
					parent.openUrl("/docs/docs/DocDsp.jsp?id=" + id); 
				}else{
					var shareid = "";
					if(parent.jQuery("#loadFolderType").val() == "shareMy"){
						shareid = $obj.closest("td").next().next().next().next().text();
					}
					if(parent.window.__isBrowser){
						parent.openFullWindowForXtable("/rdeploy/chatproject/doc/imageFileView.jsp?fileid=" + id + "&shareid=" + shareid); 
					}else{
						parent.openUrl("/rdeploy/chatproject/doc/imageFileView.jsp?fileid=" + id + "&shareid=" + shareid); 
					}
				}
				$obj.siblings("img").remove();
			}else{
               parent.jQuery("#privateId").val(id);
               fillParentMap({
               	sid : id,
               	pid : "<%=categoryid == 0 || !txt.isEmpty() ? "root0" : categoryid%>",
               	sname : sname
               });
               fullPrivateItemData(id);
			}
		}
		
		//取消未读标记
		function removeNoReadMark(type){
			if(type == "select"){
				jQuery(".ListStyle tbody").find(":checkbox:checked").each(function(){
					jQuery(this).closest("tr").find("span.file,span.folder").siblings("img").remove();
				});
			}else if(type == "all"){
				jQuery(".ListStyle tbody").find("span.file,span.folder").siblings("img").remove();
			}
		}
		
		//订阅无权限查看的文档
		function onSubscritbe(){
			var _href = location.href;
			if(_href.indexOf("&subDocscribe=") > -1){
				location.href = _href;
			}else{
				location.href = _href + "&subDocscribe=1";
			}
		}
		
		//编辑文档
		function doEditDoc(docid){
			parent.openUrl("/docs/docs/DocEdit.jsp?id=" + docid); 
			//openFullWindowForXtable("/docs/docs/DocEdit.jsp?id=" + docid); 
		}
		
		//删除文档
		function doDelDoc(docid){
			window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(30952,user.getLanguage())%>?",function(){
	        	var url = "/docs/docs/DocOperate.jsp?operation=delete&docid="+docid;
	        	jQuery.ajax({
	        		url : url , 
					data : {},
					url : url ,
					type: 'POST',
					beforeSend:function(){
						e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(33592,user.getLanguage())%>",true);
					},
					complete:function(){
						e8showAjaxTips("",false);
					},
					success: function ( data) {
		       			_table.reLoad();
					},
					error: function ( xhr) { 
						//Ext.MessageBox.alert('Failed', 'Successfully posted form: '+result);
						top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20462,user.getLanguage())%>"); 
					} 
				});
	        });
		}
		
		//共享文档
		function doShareDoc(docid){
			dialog = new window.top.Dialog();
			dialog.currentWindow = window;
			dialog.Title = "<%=SystemEnv.getHtmlLabelName(1985,user.getLanguage())%>";
			dialog.Width = 800;
			dialog.Height = 510;
			dialog.checkDataChange = false;
			dialog.URL = "/docs/tabs/DocCommonTab.jsp?_fromURL=46&isdialog=1&id=" + docid;
			dialog.maxiumnable = true;
			dialog.show();
		}
		
		//文档日志
		function doShowLog(docid){
			dialog = new window.top.Dialog();
			dialog.currentWindow = window;
			dialog.Title = "<%=SystemEnv.getHtmlLabelName(21990,user.getLanguage())%>";
			dialog.Width = 800;
			dialog.Height = 500;
			dialog.checkDataChange = false;
			dialog.URL = "/docs/DocDetailLogTab.jsp?_fromURL=0&isdialog=1&id=" + docid;
			dialog.maxiumnable = true;
			dialog.show();
		}
		
		//是否都有下载权限
		function isAllDownload(docids){
			var ids = docids.split(",");
			for(var i = 0;i < ids.length;i++){
				if(jQuery(".file[dataid='" + ids[i] + "']").siblings("input.download").val() != "1"){
					return false;
				}
			}
			return true;
		}
	</script>			
	</body>
</html>
