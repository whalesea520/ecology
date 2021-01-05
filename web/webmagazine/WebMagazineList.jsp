
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
<script type="text/javascript">
	function onBtnSearchClick(){
		jQuery("#frmmain").submit();
	}
	
	var dialog = null;
	function closeDialog(){
		if(dialog)
			dialog.close();
	}
	
	function onLog(){
		_onViewLog(273,"<%=xssUtil.put("where operateitem=273")%>");
	}

	function openDialogMagazine(id){
		dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		var url = "/docs/tabs/DocCommonTab.jsp?_fromURL=42&to=2&isdialog=1&typeID="+id;
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,31518",user.getLanguage())%>";
		dialog.Width = 600;
		dialog.Height = 249;
		dialog.Drag = true;
		dialog.URL = url;
		dialog.show();
}

function openDialogMagazineEdit(id){
		dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		var url = "/docs/tabs/DocCommonTab.jsp?_fromURL=44&to=2&isdialog=1&id="+id;
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("93,31518",user.getLanguage())%>";
		dialog.Width = 600;
		dialog.Height = 249;
		dialog.Drag = true;
		dialog.URL = url;
		dialog.show();
}
	
	function submitData()
	{
		if (check_form(Magazine,'name'))
			Magazine.submit();
	}
</script>
<%
if(!HrmUserVarify.checkUserRight("WebMagazine:Main", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
String optype=Util.null2String(request.getParameter("optype"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(31516,user.getLanguage());
String needfav ="1";
String needhelp ="";
String typeID = ""+Util.getIntValue(request.getParameter("typeID"),0);
String typeName = "";
String typeRemark = "";
int subcompanyid = 0;
int operatelevel=0;
RecordSet.executeSql("select * from WebMagazineType where id = " + typeID);
if (RecordSet.next()) 
{
	typeName = Util.null2String(RecordSet.getString("name"));
	typeRemark = Util.null2String(RecordSet.getString("remark"));
	subcompanyid = Util.getIntValue(RecordSet.getString("subcompanyid"),0);
}
int detachable = Util.getIntValue(String.valueOf(session.getAttribute("docdetachable")),0);
if(detachable==1){
	operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"WebMagazine:Main",subcompanyid);
}else{
    if(HrmUserVarify.checkUserRight("WebMagazine:Main", user))
        operatelevel=2;
}
String name = Util.null2String(request.getParameter("flowTitle"));
%>
<script type="text/javascript">
	try{
		parent.setTabObjName("<%= typeName %>");
	}catch(e){}
</script>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
/*RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",/web/webmagazine/WebMagazineTypeEdit.jsp?typeID="+typeID+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;*/
if(!optype.equals("1")){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}else{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(456,user.getLanguage())+SystemEnv.getHtmlLabelName(31518,user.getLanguage())+",javascript:openDialogMagazine("+typeID+"),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDel(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
/*RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/web/webmagazine/WebMagazineTypeList.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;*/
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:onLog(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form action="WebMagazineList.jsp" name="frmmain" id="frmmain">
<input type="hidden" name="typeID" id="typeID" value="<%= typeID %>"/>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td width="30%">{
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(!optype.equals("1")){ %>
				<input type="button" class="e8_btn_top" value="<%= SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" onclick="javascript:submitData();"/>
			<%}else{ %>
				<input type="button" class="e8_btn_top" value="<%= SystemEnv.getHtmlLabelName(456,user.getLanguage())+SystemEnv.getHtmlLabelName(31518,user.getLanguage())%>" onclick="javascript:openDialogMagazine(<%=typeID %>)"/>
				<input type="button" class="e8_btn_top" value="<%= SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onclick="javascript:doDel();"/>
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
</form>

	
			<form id="Magazine" name="Magazine" action="WebMagazineOperation.jsp" method="post">	
			<input type="hidden" name="method" value="TypeUpdate">
			<input type="hidden" name="typeID" id="typeID" value="<%= typeID %>"/>

			<wea:layout>
				<%if(!optype.equals("1")){ %>
					<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
						<wea:item><%=SystemEnv.getHtmlLabelName(31517,user.getLanguage())%></wea:item>
						<wea:item>
							<wea:required id="nameSpan" required="true" value='<%=typeName%>'>
								<INPUT temptitle="<%=SystemEnv.getHtmlLabelName(31517,user.getLanguage())%>" class="InputStyle" type="text" id="name" name="name" value="<%=typeName%>" onChange="checkinput('name','nameSpan')">
							</wea:required>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></wea:item>
						<wea:item><textarea class="InputStyle" id="remark" name="remark" cols="50"><%=typeRemark%></textarea></wea:item>
						<%if(detachable==1){ %>
							<wea:item><%= SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></wea:item>
							<wea:item>
								<span>
									<brow:browser viewType="0" name="subcompanyid" browserValue='<%= ""+subcompanyid %>' 
											browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp"
											hasInput='<%=operatelevel>0?"true":"false" %>' isSingle="true" hasBrowser = "true" isMustInput='<%=operatelevel>0?"2":"0" %>'
											completeUrl="/data.jsp?type=164" width="80%" temptitle='<%= SystemEnv.getHtmlLabelName(17868,user.getLanguage())%>'
											language='<%=""+user.getLanguage() %>'
											browserSpanValue='<%=subcompanyid!=0?Util.toScreen(SubCompanyComInfo.getSubCompanyname(subcompanyid+""),user.getLanguage()):""%>'>
									</brow:browser>
								</span>
							</wea:item>
						<%}%>
						
					</wea:group>
				<%}else{ %>
					<wea:group context='<%=SystemEnv.getHtmlLabelName(32869,user.getLanguage())%>' attributes="{'groupDisplay':'none'}">
						<wea:item attributes="{'isTableList':'true'}">
							<%			
								int perpage =20;
								//设置好搜索条件
								String backFields ="id  , releaseYear , name , createDate ";
								String fromSql = " WebMagazine ";                              
								String orderBy="id";
								String sqlWhere = "typeID = " + typeID;
								if(!name.equals("")){
									sqlWhere += " and name like '%"+name+"%'";
								}
								String tableString=""+
									   "<table pageId=\""+PageIdConst.DOC_WEBMAGAZINELIST+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.DOC_WEBMAGAZINELIST,user.getUID(),PageIdConst.DOC)+"\" tabletype=\"checkbox\">"+
									   "<sql  sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlorderby=\""+orderBy+"\"  sqlprimarykey=\"id\" sqlsortway=\"Desc\"  sqldistinct=\"true\" />"+
									   "<head>"+                                           
											 "<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(31517,user.getLanguage())+"\" transmethod=\"weaver.general.KnowledgeTransMethod.getMagazineNameMultiLang\" otherpara=\"column:releaseYear+"+SystemEnv.getHtmlLabelName(445,user.getLanguage())+"\" target=\"_parent\" column=\"name\" orderkey=\"name\" linkvaluecolumn=\"id\"  href =\"DocWebTab.jsp?_fromURL=3\" linkkey=\"id\"/>"+
											 "<col width=\"50%\"  text=\""+SystemEnv.getHtmlLabelName(433,user.getLanguage())+"\" column=\"remark\" orderkey=\"remark\"/>"+                                           
									   "</head>"+
									   "<operates width=\"20%\">"+
									   "	<operate href=\"javascript:openDialogMagazineEdit();\"  text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" />"+
									   "	<operate href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" />"+
									   "</operates>"+
									   "</table>";                                             
							  %>
							  <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="false" isShowBottomInfo="true"/>
							  <input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.DOC_WEBMAGAZINELIST %>"/>
						</wea:item>
					</wea:group>
				<%} %>
			</wea:layout>
		</form>
		
</BODY>
</HTML>
<SCRIPT type="text/JavaScript">
  function doDel(id){
  	if(!id){
			id = _xtable_CheckedCheckboxId();
		}
		if(!id){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
			return;
		}
		if(id.match(/,$/)){
			id = id.substring(0,id.length-1);
		}
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(33435,user.getLanguage())%>",function() {
			window.location='/web/webmagazine/WebMagazineOperation.jsp?method=MagazineDel&typeID=<%=typeID%>&id='+id;
		});
  }
</SCRIPT>
