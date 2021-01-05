<%@page import="java.text.DecimalFormat"%>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="subcompany" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="PhotoComInfo" class="weaver.album.PhotoComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="KnowledgeTransMethod" class="weaver.general.KnowledgeTransMethod" scope="page"/>
<%

String isclose = Util.null2String(request.getParameter("isclose"));
String needrefreshtree = Util.null2String(request.getParameter("needrefreshtree"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/album/js/common_wev8.js"></script>
</head>
<%
String uploadcom=rs.getPropValue("album_uploadcom", "type");//照片上传插件类型:2,flash插件;1或者其他,activex插件

String paraid = Util.null2String(request.getParameter("paraid"));

//default first 
if("".equals(paraid)){
	
%>	
<script type="text/javascript">
try{
	var contents= $("#leftframe",parent.parent.document).contents();
	var firstmenu= contents.find("li.e8menu_li").first();
	firstmenu.find('div').first().find("span.e8menu_name").trigger('click');
}catch(e){}
</script>
<%
	
	return;
}


String strId = paraid;

int id = Util.getIntValue(strId, 0);
//if(id==0) id=user.getUserSubCompany1();

//String subcompanyName = subcompany.getSubCompanyname(String.valueOf(id));
int subCompanyId=id;
String parentId="";
String isFolder="";
String folderName="";
if(id<0){
	subCompanyId=Util.getIntValue(PhotoComInfo.getSubCompanyId(""+id), -1);
	parentId=PhotoComInfo.getParentId(""+id);
	isFolder=PhotoComInfo.getIsFolder(""+id);
	folderName=PhotoComInfo.getPhotoName(""+id);
	if(subCompanyId<-1){
		subCompanyId=user.getUserSubCompany1();
	}
}

String sName = Util.null2String(request.getParameter("sName"));
String sUserId = Util.null2String(request.getParameter("sUserId"));
String sDate1 = Util.null2String(request.getParameter("sDate1"));
String sDate2 = Util.null2String(request.getParameter("sDate2"));

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "" ;
String needfav ="1";
String needhelp ="";

%>
<script type="text/javascript">
if("<%=isclose%>"=="1"){
	var dialog = parent.getDialog(window); 
	var parentWin = parent.getParentWindow(window);
	parentWin.location="/docs/tools/DocPicUpload.jsp";
	parentWin.closeDialog();	
}





</script>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
boolean canEdit = false;
boolean canDel = false;

boolean canupload = false;


String albumSizeInfo=SystemEnv.getHtmlLabelNames("84036",user.getLanguage())+":&nbsp;&nbsp;";
double albumSize=0.0;
double albumUsedSize=0.0;
String rate="";
DecimalFormat df=new DecimalFormat("##0.00");
rs2 .executeSql("select * from  AlbumSubcompany where subcompanyid="+subCompanyId);

if(rs2.next()){
	albumSize=Util.getDoubleValue( rs2.getString ("albumsize"),0.0)/1000.0;
	albumUsedSize=Util.getDoubleValue(rs2.getString("albumSizeUsed"),0.0)/1000.0;
}

if(albumSize>0){
	rate=df.format((albumUsedSize/albumSize)*100.0);
}

albumSizeInfo+="<div style='width:200px;float:right;'>"+KnowledgeTransMethod.getPercent(rate)+"</div>" ;
if(Util.getDoubleValue(rate)<100.0){
	canupload = true;
}

if(!strId.equals("")){


   //是否分权系统，如不是，则不显示框架，直接转向到列表页面
   rs.executeSql("select detachable from SystemSet");
   int detachable=0;
   if(rs.next()){
       detachable=rs.getInt("detachable");
   }

   int operatelevel=0;

   if(detachable==1){  
       operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"Album:Maint",subCompanyId);
   }else{
       //if(HrmUserVarify.checkUserRight("FieldManage:All", user))
       if(HrmUserVarify.checkUserRight("Album:Maint", user)){
           operatelevel=2;
	}
   }
	
	if(operatelevel>=1){
		canEdit=true;
		if(canupload){
			RCMenu += "{"+SystemEnv.getHtmlLabelNames("84028",user.getLanguage())+",javascript:upload(),_self} " ;    
		    RCMenuHeight += RCMenuHeightStep;
		}
	    RCMenu += "{"+SystemEnv.getHtmlLabelNames("18475",user.getLanguage())+",javascript:onNewFolder("+id+"),_self} " ;    
	    RCMenuHeight += RCMenuHeightStep;
	    RCMenu += "{"+SystemEnv.getHtmlLabelNames("84029",user.getLanguage())+",javascript:onBatchMove(),_self} " ;    
	    RCMenuHeight += RCMenuHeightStep;
	}
	if(operatelevel==2){
		canDel=true;
	    RCMenu += "{"+SystemEnv.getHtmlLabelNames("32136",user.getLanguage())+",javascript:deletePhotoBatch();,_self} ";
	    RCMenuHeight += RCMenuHeightStep;
	    if("1".equals( PhotoComInfo.getIsFolder(""+id))){
	    	RCMenu += "{"+SystemEnv.getHtmlLabelNames("84032",user.getLanguage())+",javascript:onDelete("+id+",1);,_self} ";
		    RCMenuHeight += RCMenuHeightStep;
	    }
	    
	}
	
	if(!"".equals( parentId)){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onParent("+parentId+"),_self} ";
		RCMenuHeight += RCMenuHeightStep;
	}
	   
}

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form id="weaver" name="weaver" method="post" action="">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">

		<%
		if(canEdit){
			if(canupload){
			%>
			<input type="button" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelNames("84028",user.getLanguage())%>" onclick="javascript:upload()"/>
			<%} %>
			<input type="button" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelNames("18475",user.getLanguage())%>" onclick="javascript:onNewFolder(<%=id %>)"/>
			<input type="button" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelNames("84029",user.getLanguage())%>" onclick="javascript:onBatchMove()"/>
			<%
		}
		%>
		<%
		if(canDel){
			%>
			<input type="button" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelNames("32136",user.getLanguage())%>" onclick="javascript:deletePhotoBatch()"/>
			<%
		}
		%>
			<input type="text" class="searchInput" value="<%=sName%>" name="flowTitle"/>
			<span id="advancedSearch" class="advancedSearch" style="display:'';"><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<div class="advancedSearchDiv" id="advancedSearchDiv" >
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("15774",user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelNames("84033",user.getLanguage())%></wea:item>
		<wea:item><input type=text class="InputStyle" name="sName"  value='<%=sName %>'></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("26083",user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="sUserId" 
				browserValue='<%=sUserId %>' 
				browserSpanValue='<%=ResourceComInfo.getResourcename (""+sUserId) %>'
				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
				completeUrl="/data.jsp"  />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("27780",user.getLanguage())%></wea:item>
		<wea:item>
			<span class="wuiDateSpan" selectId="planbegindate_sel" selectValue="">
				  <input class=wuiDateSel type="hidden" name="sDate1" value="<%=sDate1 %>">
				  <input class=wuiDateSel  type="hidden" name="sDate2" value="<%=sDate2 %>">
			</span>
		</wea:item>
		
	</wea:group>
	
	<wea:group context="">
    	<wea:item type="toolbar">
    		<input class="zd_btn_submit" type="submit" name="submit1" value="<%=SystemEnv.getHtmlLabelNames("197",user.getLanguage())%>"/>
    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtion();"/>
    		<input class="zd_btn_cancle" type="button" name="cancel" id="cancel" value="<%=SystemEnv.getHtmlLabelNames("201",user.getLanguage())%>"  />
    	</wea:item>
    </wea:group>
    
</wea:layout>
</div>

<wea:layout>
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item attributes="{'colspan':'full'}">
			<div style="float:left;margin:10px;"><%=albumSizeInfo %></div>
		</wea:item>
	</wea:group>
</wea:layout>


<%
String sqlWhere = "WHERE parentId="+id+" ";
if(!sName.equals("")){
	//sqlWhere += " AND isFolder='0' AND photoName LIKE '%"+sName+"%' ";
	sqlWhere += "  AND photoName LIKE '%"+sName+"%' ";
}
if(!sUserId.equals("")){
	sqlWhere += " AND userId="+sUserId+" ";
}

if(!sDate1.equals("")&&!sDate2.equals("")){
	if("sqlserver".equals(rs.getDBType())){
		sqlWhere += " AND postdate >='"+sDate1+"' AND  postdate< DATEADD(day,1,'"+sDate2+"') ";
	}else if("mysql".equals(rs.getDBType())){
		sqlWhere += " AND postdate >='"+sDate1+"' AND  postdate< DATE_ADD('"+sDate2+"',INTERVAL (1) DAY ) ";
	}else{
		sqlWhere += " AND postdate >='"+sDate1+"' AND  postdate< to_char(trunc(to_date('"+sDate2+"','yyyy-mm-dd')+1),'yyyy-mm-dd')  ";
	}
	
}else if(!sDate1.equals("")){
	sqlWhere += " AND postdate >='"+sDate1+"' ";
}else if(!sDate2.equals("")){
	if("sqlserver".equals(rs.getDBType())){
		sqlWhere += " AND postdate < DATEADD(day,1,'"+sDate2+"') ";
	}else if("mysql".equals(rs.getDBType())){
		sqlWhere += " AND postdate< DATE_ADD('"+sDate2+"',INTERVAL (1) DAY ) ";
	}else{
		sqlWhere += " AND postdate< to_char(trunc(to_date('"+sDate2+"','yyyy-mm-dd')+1),'yyyy-mm-dd')  ";
	}
	
}
String browser="<browser imgurl=\"/weaver/weaver.album.ThumbnailServlet\" linkkey=\"\" linkvaluecolumn=\"\" path=\"thumbnailPath\" />";
String operateString= "<operates width=\"20%\">";
	       operateString+=" <popedom colum=\"id\" otherpara=\"column:isFolder\"  transmethod=\"weaver.album.util.AlbumTransUtil.getAlbumListOperates\" ></popedom> ";
	       if(canEdit){
	    	   operateString+="     <operate href=\"javascript:onEdit();\" otherpara=\"column:isFolder\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
		       operateString+="     <operate href=\"javascript:onMove();\"  text=\""+SystemEnv.getHtmlLabelName(78,user.getLanguage())+"\" index=\"1\"/>";
	       }
	       if(canDel){
	    	   operateString+="     <operate href=\"javascript:onDelete()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"2\"/>";
	       }
	       operateString+="</operates>";	
String tableString=""+
   "<table instanceid=\"docMouldTable\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.DOC_NEWSPICLIST,user.getUID(),PageIdConst.DOC)+"\" tabletype=\"thumbnail\">"+
   " <checkboxpopedom  id=\"checkbox\" showmethod=\"weaver.general.KnowledgeTransMethod.getImageCheckbox\"  popedompara=\"column:id\" />"+
   browser+
   "<sql backfields=\"*\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlform=\"AlbumPhotos\" sqlorderby=\"isFolder,orderNum,postDate\"  sqlprimarykey=\"id\" sqlsortway=\"desc\"  sqldistinct=\"true\" />"+
   operateString+
   "<head>"+							 
		 //"<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(85,user.getLanguage())+"\" transmethod=\"weaver.general.KnowledgeTransMethod.getPicName\"  column=\"photoName\" otherpara=\"column:id\" orderkey=\"photoName\"/>"+
   		"<col width=\"100%\" text=\"\" column=\"photoName\" orderkey=\"photoName\" transmethod=\"weaver.album.util.AlbumTransUtil.getAlbumHref\" otherpara=\"column:id+column:isFolder+column:photoCount+column:userId+"+user.getUID()+"+"+canEdit+"+list+"+canDel+"\" />"+
   "</head>"+
   "</table>"; 
%>



<wea:SplitPageTag isShowThumbnail="true"  isShowTopInfo="false" tableInfo="" tableString='<%=tableString%>' mode="run"  />
<input type="hidden" _showCol="false" name="pageId"  id="pageId" value="<%= PageIdConst.DOC_NEWSPICLIST %>"/>
<input type="hidden" name="movealbum" id="movealbum"/>
</form>
<div class="xTable_message" style="display:none" id="msgBox"></div>
<script>
var dialogMsg = "<%=SystemEnv.getHtmlLabelName(20537,user.getLanguage())%>?";
function onNewFolder(id){
	if(id){
		var url="/album/AlbumFolderAdd.jsp?id="+id+"&isdialog=1";
		var title="<%=SystemEnv.getHtmlLabelNames("18475",user.getLanguage())%>";
		openDialog(url,title,450,250);
	}
}

function onMove(id){
	if(id){
		onShowAlbumBrowser(id);
	}
}

function onBatchMove(){
	var typeids = "";
	$("input[name='chkInTableTag']").each(function(){
	if($(this).attr("checked"))			
		typeids = typeids +$(this).attr("checkboxId")+",";
	});
	if(typeids=="") {
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82891,user.getLanguage())%>");
		return ;
	}
	onShowAlbumBrowser(typeids);
}
function onShowAlbumBrowser(selectedIds){
	var selids="";
	if(selectedIds) selids=selectedIds;
	if(selids=="") return;
	
	var dlg11=new window.top.Dialog();//定义Dialog对象
	dlg11.currentWindow = window;
	dlg11.Model=false;
	dlg11.Width=700;//定义长度
	dlg11.Height=500;
	dlg11.URL="/systeminfo/BrowserMain.jsp?url=/album/AlbumBrowser.jsp?selids="+selids;
	dlg11.Title="<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%>";
	dlg11.callbackfun=moveAlbum;
	//dlg11.callbackfunParam=target;
　　dlg11.show();

	$("#movealbum").val(selids);
	
}
function moveAlbum(obj,data){

	if (data){
		if (data.id){
			var selids = $("#movealbum").val();
			//console.log("data.id:"+data.id);
			window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(128187,user.getLanguage())%>?",function(){
				jQuery.ajax({
					url : "/album/PhotoOperation.jsp",
					type : "post",
					async : true,
					data : {operation:"move",id:selids,toid:data.id},
					dataType : "json",
					contentType: "application/x-www-form-urlencoded; charset=utf-8", 
					success: function do4Success(msg){
						try{
							window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("84037",user.getLanguage())%>");
							//_table.reLoad();
							refreshLeftTree();
						}catch(e){}
					}
				});
				
			});
			
			
		}else{
			
		}
	}
}


function onEdit(id,isfolder){
	if(id){
		var url="/album/AlbumFolderEdit.jsp?id="+id+"&isdialog=1";
		var title="<%=SystemEnv.getHtmlLabelNames("84038",user.getLanguage())%>";
		if(isfolder&&isfolder=="1"){
			title="<%=SystemEnv.getHtmlLabelNames("84039",user.getLanguage())%>";
			url="/album/AlbumFolderEdit.jsp?id="+id+"&isdialog=1&isfolder=1";
		}
		openDialog(url,title,450,250);
	}
}
function onView(id,src){
	if(id){
		//var url="/album/slider/index.html";
		var url="/album/PhotoView.jsp?id="+id+"&isdialog=1&src="+src;
		var title="<%=SystemEnv.getHtmlLabelNames("84040",user.getLanguage())%>";
		openDialog(url,title,1200,750,false,false);
	}
}

function onParent(id){
	if(id){
		window.location.href="/album/AlbumListTab.jsp?paraid="+id;
	}
}


function upload(){
	var uploadcom='<%=uploadcom %>';
	showMsgBox($G("msgBox"), "<img src='/images/loading2_wev8.gif'> <%=SystemEnv.getHtmlLabelNames("84049",user.getLanguage())%>");
	if(uploadcom&&uploadcom=="2"){
		location.href = "flash/flash.jsp?id=<%=id%>";
	}else{
		location.href = "ImageUploaderD.jsp?id=<%=id%>";	
	}
}
function search(){
	var f = $G("searchForm");
	f.submit();
}
function editTitle(id, isFolder){
	if(isFolder){
		location.href = "AlbumFolderEdit.jsp?id="+id;
		return false;
	}
	var photoName="",photoExtName="";
	var o = event.srcElement;
	while(o.tagName!="TD"){o = o.parentNode;}
	var str = o.innerHTML.match(/<A.*?>(.*)<\/A>/i)[1];
	var dotPos = str.lastIndexOf(".");
	var bracketPos = str.lastIndexOf("(");
	//if(dotPos==-1){
		//photoName = str.substring(0, bracketPos);
	//}else{
		photoName = str.substring(0, dotPos);
		photoExtName = str.substring(dotPos, str.length);
	//}
	var title = prompt("<%=SystemEnv.getHtmlLabelName(20008,user.getLanguage())%>:", photoName);
	if(title){
		title = title.replace(/\.|\(|\)/ig,"");
		callAjax("PhotoOperation.jsp", "operation=edit&id="+id+"&title="+escape(title+photoExtName));
	}
}

function deletePhotoBatch(){
	var typeids = "";
	$("input[name='chkInTableTag']").each(function(){
	if($(this).attr("checked"))			
		typeids = typeids +$(this).attr("checkboxId")+",";
	});
	if(typeids=="") {
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82891,user.getLanguage())%>");
		return ;
	}
	//console.log("typeids:"+typeids);
	window.top.Dialog.confirm(dialogMsg,function(){
		jQuery.post(
			"/album/PhotoOperation.jsp",
			{"operation":"batchdelete","ids":typeids},
			function(data){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83472",user.getLanguage())%>",function(){
					//_table.reLoad();
					refreshLeftTree();
				});
			}
		);
		
	});
}

function onDelete(id,isfolder){
	if(id){
		var alertMsg=dialogMsg;
		if(isfolder&&isfolder=='1'){
			alertMsg="<%=SystemEnv.getHtmlLabelNames("84051",user.getLanguage())%> <%=folderName %> <%=SystemEnv.getHtmlLabelNames("84052",user.getLanguage())%>";
		}
		window.top.Dialog.confirm(alertMsg,function(){
			jQuery.post(
				"/album/PhotoOperation.jsp",
				{"operation":"delete","id":id},
				function(data){
					try{
						window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83472",user.getLanguage())%>",function(){
							if(isfolder&&isfolder=='1'){
								//_table.reLoad();
								refreshLeftTree();
								window.location.href="/album/AlbumListTab.jsp?paraid=<%=parentId %>";
							}else{
								//_table.reLoad();
								refreshLeftTree();
							}
							
						});
					}catch(e){}
				}
			);
			
		});
	}
}


function callAjax(url, param){
	new Ajax.Request(url,{
		onSuccess : function(resp){
			_table.reLoad();
			var _operation = resp.responseText.stripScripts().stripTags().escapeHTML();
			if(_operation=="reloadTree" && parent.frames[0]){
				parent.frames[0].location.reload();
			}
		},
		onFailure : function(){alert("");},
		parameters : param
	});
}
function reloadAlbumSubcompany(){
	$G("iframeAlbumSubcompany").contentWindow.document.location.reload();
}

function searchTitle(){	
	var value=$("input[name='flowTitle']",parent.document).val();
    $("input[name='sName']").val(value);
    weaver.submit();
}
$(function(){
	$("#topTitle").topMenuTitle({searchFn:searchTitle});
});

$(function(){
	var cptgroupname='';
	var isfolder='<%=isFolder %>';
	if(isfolder=="1"){
		cptgroupname='<%=folderName %>';
	}else{
		cptgroupname='<%=SubCompanyComInfo .getSubCompanyname(paraid) %>';
		if(cptgroupname==''){
			cptgroupname='<%=SystemEnv.getHtmlLabelName(20163,user.getLanguage()) %>';
		}
	}
	try{
		parent.setTabObjName(cptgroupname);
		var needrefreshtree='<%=needrefreshtree %>';
		if(needrefreshtree=="1"){
			refreshLeftTree();
		}
		
	}catch(e){}
});

function refreshLeftTree(){
	try{
		var tree= $("#leftframe",parent.parent.document);
		var src=tree.attr("src");
		tree.attr("src",src);
	}catch(e){}
}


</script>
</BODY>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
