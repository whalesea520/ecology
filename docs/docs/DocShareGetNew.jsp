<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SpopForDoc" class="weaver.splitepage.operate.SpopForDoc" scope="page"/>
<%@ page import="weaver.docs.category.security.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<HTML><HEAD>
<%
	int id = Util.getIntValue(request.getParameter("id"),0);
	String secId= "";
	rs.executeSql("select seccategory from docdetail where id="+id);
	if(rs.next()){
	secId=rs.getString("seccategory");
	}
   
	String isDialog = Util.null2String(request.getParameter("isdialog"));
 %>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>

<script type="text/javascript">

var parentdialog = null;
try{
	parentdialog = parent.parent.getDialog(parent); 
}catch(e){}

		function onDelete(id){
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
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function(){
			jQuery.ajax({
				url:"DocShareUtilNew.jsp?method=delMulti&isdialog=1&docid=<%=id%>&shareIds="+id,
				method:"post",
				dataType:"text",
				complete:function(xhr,ts){
					_table.reLoad();
				},
				error:function(xhr,msg,e){
					
				}
			});
		});
	}

	var dialog = null;
	function closeDialog(){
		if(dialog)
			dialog.close();
	}
	var isclose = 0;
	function openDialog(){
		dialog = new window.top.Dialog();
		dialog.currentWindow = window; 
		dialog.URL = "/docs/docs/DocShareAddBrowser.jsp?isdialog=1&_para2=2_<%=id%>";
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(18645,user.getLanguage())%>";
		dialog.Width = 400;
		dialog.Height = 255;
		dialog.Drag = true;
		dialog.CancelEvent = function(){
			if(isclose == 0){
				dialog.close();
			}
		}
		dialog.show();
	}
</script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(70,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(68,user.getLanguage());
String needfav ="1";
String needhelp ="";
String hasBtn = "false";
String hasDelBtn = "false";
int userid=user.getUID();
String logintype = user.getLogintype();
String userSeclevel = user.getSeclevel();
String userType = ""+user.getType();
String userdepartment = ""+user.getUserDepartment();
String usersubcomany = ""+user.getUserSubCompany1();
String userInfo=logintype+"_"+userid+"_"+userSeclevel+"_"+userType+"_"+userdepartment+"_"+usersubcomany;
ArrayList PdocList = SpopForDoc.getDocOpratePopedom(""+id,userInfo);
boolean nodownload=SecCategoryComInfo1.getNoDownload(secId).equals("1")?true:false;
if (((String)PdocList.get(3)).equals("true")){ 
	rs.executeSql("select d2.allownModiMshareL,d2.allownModiMshareW,d2.shareable from docdetail d1,DocSecCategory d2 where d1.seccategory=d2.id and d1.id=" + id);
	int isAllowModiMShare = 0;
	int isAllowModiNMShare = 0;
	if (rs.next()) {
		isAllowModiMShare = Util.getIntValue(Util.null2String(rs.getString("allownModiMshareL")),0);
		isAllowModiNMShare = Util.getIntValue(Util.null2String(rs.getString("shareable")),0);
	}
	if(isAllowModiNMShare==1){
		hasBtn="true";
		hasDelBtn="true";
	}else if(isAllowModiMShare==1){
		hasDelBtn="true";
	}
	
}
String docvestin = Util.null2String(request.getParameter("docvestin"));
%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(hasBtn.equalsIgnoreCase("true")){ %>
				<input type="button" class="e8_btn_top" value="<%= SystemEnv.getHtmlLabelName(18645,user.getLanguage())%>" onclick="javascript:openDialog();"/>
			<%}if(hasDelBtn.equals("true")){ %>
				<input type="button" class="e8_btn_top" value="<%= SystemEnv.getHtmlLabelName(18646,user.getLanguage())%>" onclick="javascript:onDelete();"/>
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<% 
	if(hasBtn.equalsIgnoreCase("true") && isDialog.equals("1")){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(18645,user.getLanguage())+",javascript:openDialog(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
		RCMenu += "{"+SystemEnv.getHtmlLabelName(18646,user.getLanguage())+",javascript:onDelete(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

			<%
				//设置好搜索条件				
				String docid = Util.null2String(request.getParameter("id"));
				
				
				String tableString=""+
					   "<table datasource=\"weaver.docs.docs.DocDataSource.getDocShare\" sourceparams=\"id:"+docid+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.DOC_DOCSHARE,user.getUID(),PageIdConst.DOC)+"\" tabletype=\"checkbox\">"+
					   "<sql backfields=\"*\"  sqlform=\"temp\" sqlorderby=\"shareId\"  sqlprimarykey=\"shareId\" sqlsortway=\"desc\"  />"+
					   " <checkboxpopedom  showmethod=\"weaver.general.KnowledgeTransMethod.getShareCheckbox\" id=\"checkbox\"  popedompara=\"column:chk\" />"+
					   "<head>";
					        tableString += "<col width=\"10%\" labelid=\"18495\"  text=\""+SystemEnv.getHtmlLabelName(18495,user.getLanguage())+"\" column=\"type\"/>";
					   		tableString+=	 "<col width=\"20%\" labelid=\"21956\"  text=\""+SystemEnv.getHtmlLabelName(21956,user.getLanguage())+"\" column=\"shareName\" />";	
							tableString +=	 "<col width=\"25%\" labelid=\"106\"  text=\""+SystemEnv.getHtmlLabelName(106,user.getLanguage())+"\" column=\"shareRealName\" />";
							tableString += "<col width=\"20%\" labelid=\"683\"  text=\""+SystemEnv.getHtmlLabelName(683,user.getLanguage())+"\" column=\"shareRealLevel\"/>";
							
							tableString += "<col width=\"15%\" labelid=\"385\"  text=\""+SystemEnv.getHtmlLabelName(385,user.getLanguage())+"\" column=\"shareRealType\"/>";
						if(!nodownload){
							tableString +=	 "<col width=\"15%\" labelid=\"32070\"  text=\""+SystemEnv.getHtmlLabelName(32070,user.getLanguage())+"\" column=\"downloadlevelName\" />";
						 }
						tableString +=
					   "</head>"+
					   "</table>";      
			  %>
			  <input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.DOC_DOCSHARE %>"/>
			<wea:layout>
				<%String attrs = "{'groupDisplay':'"+(!isDialog.equals("1")?"":"none" )+"'}"; %>
				<wea:group context='<%= SystemEnv.getHtmlLabelName(1279,user.getLanguage())%>' attributes="<%=attrs %>">
					<%if((!isDialog.equals("1")&&hasBtn.equalsIgnoreCase("true")) || docvestin.equals("1")){ %>
						<wea:item type="groupHead">
							<input type="button" class="addbtn" title="<%= SystemEnv.getHtmlLabelName(18645,user.getLanguage())%>" onclick="javascript:openDialog();"/>
							<input type="button" class="delbtn" title="<%= SystemEnv.getHtmlLabelName(18646,user.getLanguage())%>" onclick="javascript:onDelete();"/>
						</wea:item>
					<%} %>
					<%if((!isDialog.equals("1")&&hasDelBtn.equalsIgnoreCase("true")) || docvestin.equals("1")){ %>
						<wea:item type="groupHead">
							<input type="button" class="delbtn" title="<%= SystemEnv.getHtmlLabelName(18646,user.getLanguage())%>" onclick="javascript:onDelete();"/>
						</wea:item>
					<%} %>
					<wea:item attributes="{'isTableList':'true'}">
						<wea:SplitPageTag  tableString='<%=tableString%>' isShowTopInfo="false"  mode="run"/>
					</wea:item>
				</wea:group>
			</wea:layout>
			 
  <%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
				<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parentdialog.closeByHand();">
				</wea:item>
			</wea:group>
		</wea:layout>
</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
<%} %>
 </BODY></HTML>
