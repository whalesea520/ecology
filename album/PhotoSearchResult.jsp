
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="subcompany" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%--
<jsp:useBean id="SearchComInfo" class="weaver.album.SearchComInfo" scope="session" />
<jsp:useBean id="chk" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
--%>
<jsp:useBean id="PhotoComInfo" class="weaver.album.PhotoComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
//int[] ids = chk.getSubComByUserEditRightId(user.getUID(), "Album:Maint");
//String _ids = "";
//for(int i=0;i<ids.length;i++){
//	_ids += ids[i] + ",";
//}
//if(_ids.endsWith(",")) _ids=_ids.substring(0, _ids.length()-1);

String strId = Util.null2String(request.getParameter("id"));
int id = Util.getIntValue(strId, 0);
//if(id==0) id=user.getUserSubCompany1();

int subCompanyId=id;
if(id<0){
	subCompanyId=Util.getIntValue(PhotoComInfo.getSubCompanyId(""+id), -1);
	if(subCompanyId<-1){
		subCompanyId=user.getUserSubCompany1();
	}
}

String sName = Util.null2String(request.getParameter("sName"));
String sUserId = Util.null2String(request.getParameter("sUserId"));
String sDate1 = Util.null2String(request.getParameter("sDate1"));
String sDate2 = Util.null2String(request.getParameter("sDate2"));

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(20164,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<html> 
<head>
<title></title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<head>
<script type="text/javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript" src="/js/prototype_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />
<style type="text/css">.href{color:blue;text-decoration:underline;cursor:hand}</style>
</head>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.back(),_self} " ;    
//RCMenuHeight += RCMenuHeightStep;

String canEdit = "false";
String canDel = "false";

//if(HrmUserVarify.checkUserRight("Album:Maint",user)){
//	canEdit = "true";
//}

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
		canEdit="true";
	}

	

    RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:search(),_self} ";
    RCMenuHeight += RCMenuHeightStep;
	if(operatelevel==2){
		canDel="true";
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:deletePhotoBatch();,_self} ";
	    RCMenuHeight += RCMenuHeightStep;
	}
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.back(),_self} ";
    RCMenuHeight += RCMenuHeightStep;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table style="width:100%;height:92%;border-collapse:collapse">
<tr>
	<td height="10"></td>
</tr>
<tr>
	<td valign="top">
		<TABLE class=Shadow>
		<colgroup>
			<col width="10"/>
			<col width=""/>
			<col width="10"/>
		</colgroup>
		<tr>
		<td></td>
		<td valign="top">

<!--==========================================================================================-->
<table class="viewform">
<form name="searchForm" method="post" action="">
<colgroup>
	<col width="6%"/>
	<col width="20%"/>
	<col width="1%"/>
	<col width="6%"/>
	<col width="15%"/>
	<col width="1%"/>
	<col width="6%"/>
	<col width="35%"/>
</colgroup>
<tbody>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
	<td class=field>
		<input type="text" name="sName" style="width:100%" class="Inputstyle" value="<%=sName%>"/>
	</td>
	<td></td>
	<td><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></td>
	<td class=field>
	   	<button type="button" class="Browser" onClick="onShowHRMResource()"></BUTTON>
		<span id="sUserIdSpan"><%=ResourceComInfo.getResourcename(sUserId)%></span>
		<input type="hidden" _url="" name="sUserId" value="<%=sUserId%>"/>
	</td>
	<td></td>
	<td><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td>
	<td class=field>
		 <input name="sDate1" type="hidden" class=wuiDate  ></input> 
	    -&nbsp;
	     <input name="sDate2" type="hidden" class=wuiDate  ></input> 
	</td>
</tr>
<tr style="height:1px;"><td class="line" colspan="8"></td></tr>
</form>
</table>

<!--==========================================================================================-->
<form id="weaver" method="post" action="">
<%
//String sqlWhere = "WHERE isFolder='0' ";
//if(!_ids.equals("")){
//	sqlWhere += "AND subcompanyId IN ("+_ids+") ";
//}
//sqlWhere += SearchComInfo.formatSQLSearch(user.getLanguage());

String sqlWhere = "WHERE parentId="+id+" ";
if(!sName.equals("")){
	sqlWhere += " AND isFolder='0' AND photoName LIKE '%"+sName+"%' ";
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

String tableString=""+
	"<table pagesize=\"20\" tabletype=\"thumbnail\">"+
	"<browser imgurl=\"/weaver/weaver.album.ThumbnailServlet\" linkkey=\"\" linkvaluecolumn=\"\" path=\"thumbnailPath\" />"+
	"<sql backfields=\"*\" sqlform=\"AlbumPhotos\" sqlprimarykey=\"id\" sqlsortway=\"desc\" sqlorderby=\"isFolder,postDate\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" />"+
	"<head>"+
//		"<col width=\"100%\" text=\"\" column=\"photoName\" orderkey=\"photoName\" transmethod=\"weaver.splitepage.transform.SptmForAlbum.getHref\" otherpara=\"column:id+column:isFolder+column:photoCount+column:userId+"+user.getUID()+"+"+canEdit+"+search\" />"+
		"<col width=\"100%\" text=\"\" column=\"photoName\" orderkey=\"photoName\" transmethod=\"weaver.splitepage.transform.SptmForAlbum.getHref\" otherpara=\"column:id+column:isFolder+column:photoCount+column:userId+"+user.getUID()+"+"+canEdit+"+list+"+canDel+"\" />"+
	"</head>"+
	"</table>";
%>
<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="false" isShowThumbnail="1" imageNumberPerRow="5"/>
</form>
<!--==========================================================================================-->
<iframe id="iframeAlbumSubcompany" style="width:100%;height:180px" frameborder="0" src="AlbumSubcompany.jsp?id=<%=id%>"></iframe>
<!--==========================================================================================-->
		</td>
		<td></td>
		</tr>
		</TABLE>
	</td>
</tr>
<tr>
	<td height="10"></td>
</tr>
</table>

<div class="xTable_message" style="display:" id="msgBox"></div>
</body>
</html>
<script type="text/javascript">
var dialogMsg = "<%=SystemEnv.getHtmlLabelName(20537,user.getLanguage())%>?";
function editTitle(id){
	var photoName="",photoExtName="";
	var o = event.srcElement;
	while(o.tagName!="TD"){o = o.parentNode;}
	var str = o.innerHTML.match(/<A.*?>(.*)<\/A>/i)[1];
	var dotPos = str.lastIndexOf(".");
	var bracketPos = str.lastIndexOf("(");
	if(dotPos==-1){
		photoName = str.substring(0, bracketPos);
	}else{
		photoName = str.substring(0, dotPos);
		photoExtName = str.substring(dotPos, str.length);
	}
	var title = prompt("<%=SystemEnv.getHtmlLabelName(20008,user.getLanguage())%>:", photoName);
	if(title){
		title = title.replace(/\.|\(|\)/ig,"");
		callAjax("PhotoOperation.jsp", "operation=edit&id="+id+"&title="+escape(title+photoExtName));
	}
}
function deletePhotoBatch(){
	if(confirm(dialogMsg)){
		callAjax("PhotoOperation.jsp", "operation=batchdelete&ids="+_xtable_CheckedCheckboxValue()+"");
		reloadAlbumSubcompany();
	}
}
function deletePhoto(id){
	if(confirm(dialogMsg)){
		callAjax("PhotoOperation.jsp", "operation=delete&id="+id);
		reloadAlbumSubcompany();
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
function search(){
	var f = $G("searchForm");
	f.submit();
}
function onShowHRMResource(){
	var opts={
			_dwidth:'550px',
			_dheight:'550px',
			_url:'about:blank',
			_scroll:"no",
			_dialogArguments:"",

			value:""
			};
			var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
			var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;
			opts.top=iTop;
			opts.left=iLeft;


	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp",
			"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
    if (datas){
	if (datas.id!=""){
		document.getElementById("sUserIdSpan").innerHTML = "<A href='/hrm/resource/HrmResource.jsp?id="+datas.id+"'>"+datas.name+"</A>"
		searchForm.sUserId.value = wuiUtil.getJsonValueByIndex(datas,0);
	}else{ 
		document.getElementById("sUserIdSpan").innerHTML = "";
		searchForm.sUserId.value = "";
	}
    }
}
</script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>

