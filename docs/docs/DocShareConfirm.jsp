
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="DocShare" class="weaver.docs.DocShare" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="SpopForDoc" class="weaver.splitepage.operate.SpopForDoc" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="SendToAllForNew" class="weaver.system.SendToAllForNew" scope="page"/>
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
 
<%
	String actionid = Util.null2String(request.getParameter("actionid"));
	String datasourceid = Util.null2String(request.getParameter("datasourceid"));

    int docid = Util.getIntValue(request.getParameter("docid"),0); 
    
    if("netdisk".equals(actionid)){
        docid = Util.getIntValue(datasourceid.contains(",") ? datasourceid.split(",")[0] : datasourceid,0);
    }

	//文档名称链接放在页面顶部  开始  fanggsh 20060424
    String  docsubject = DocComInfo.getDocname(""+docid);
	//文档名称链接放在页面顶部  结束

//3:共享
//user info
int userid=user.getUID();
String logintype = user.getLogintype();
String userSeclevel = user.getSeclevel();
String userType = ""+user.getType();
String userdepartment = ""+user.getUserDepartment();
String usersubcomany = ""+user.getUserSubCompany1();
String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");
String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");
boolean canEdit = false;
boolean canShare = false ;
String userInfo=logintype+"_"+userid+"_"+userSeclevel+"_"+userType+"_"+userdepartment+"_"+usersubcomany;
ArrayList PdocList = SpopForDoc.getDocOpratePopedom(""+docid,userInfo);
if (((String)PdocList.get(1)).equals("true")) canEdit = true ;
if (((String)PdocList.get(3)).equals("true")) canShare = true ;
if(canEdit){
    canShare = true;
}
RecordSet.executeSql("select d2.allownModiMshareL,d1.seccategory,d2.allownModiMshareW,d2.shareable from docdetail d1,DocSecCategory d2 where d1.seccategory=d2.id and d1.id=" + docid);
int isAllowModiMShare = 0;
int isAllowModiNMShare = 0;
int secId= 0;
if (RecordSet.next()) {
	isAllowModiMShare = Util.getIntValue(Util.null2String(RecordSet.getString("allownModiMshareL")),0);
	isAllowModiNMShare = Util.getIntValue(Util.null2String(RecordSet.getString("shareable")),0);
	secId =  Util.getIntValue(Util.null2String(RecordSet.getString("seccategory")),0);
}
if(isAllowModiMShare==0&&isAllowModiNMShare==0){
	canShare = false;
}
boolean nodownload=SecCategoryComInfo1.getNoDownload(secId+"").equals("1")?true:false;
String sendtoall ="";
if(SendToAllForNew.checkeSendingRight(secId+"")){
    sendtoall="1";
}
String isdialog = Util.null2String(request.getParameter("isdialog"));
%>
<HTML>
<HEAD>
    <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
    <SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
    <script type="text/javascript">
		try{
			parent.setTabObjName("<%=SystemEnv.getHtmlLabelName(15059,user.getLanguage())%>");
		}catch(e){
			
		}
		
		var parentdialog = null;
		try{
			parentdialog = parent.parent.getDialog(parent);
		}catch(e){}
		
		function onClose(){
			if(parentdialog){
				parentdialog.close();
			}else{
				window.parent.close();
			}
		}
		
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
				url:"DocShareUtilNew.jsp?method=delMulti&isdialog=1&docid=<%=docid%>&shareIds="+id + "&actionid=<%=actionid%>&datasourceid=<%=datasourceid%>",
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
		dialog.URL = "/docs/docs/DocShareAddBrowser.jsp?isdialog=1&_para2=2_<%=docid%>&actionid=<%=actionid%>&datasourceid=<%=datasourceid%>";
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(18645,user.getLanguage())%>";
		dialog.Width = 400;
		dialog.Height = 255;
		dialog.CancelEvent = function(){
			if(isclose == 0){
				dialog.close();
			}
		}
		dialog.Drag = true;
		dialog.show();
	}
	
	jQuery(document).ready(function(){
		jQuery("#loading").hide();
	});
</script>
</HEAD>
    <BODY>
    <%
    String imagefilename = "/images/hdReport_wev8.gif";

	//文档名称链接放在页面顶部  开始  fanggsh 20060424
    //String titlename = SystemEnv.getHtmlLabelName(18644,user.getLanguage());
    //String titlename = SystemEnv.getHtmlLabelName(18644,user.getLanguage())+": <a href='DocDsp.jsp?id="+docid+"'>"+ docsubject + "</a>";
    String titlename = SystemEnv.getHtmlLabelName(18644,user.getLanguage())+": "+ docsubject ;
	//文档名称链接放在页面顶部  结束

    String needfav ="1";
    String needhelp ="";
    %> 
    <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %> 
    <%
        RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:doSubmit(this),_top} " ;
        RCMenuHeight += RCMenuHeightStep ;       
    %>
    <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
    <div class="zDialog_div_content">
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
				<input type="button" class="e8_btn_top" value="<%= SystemEnv.getHtmlLabelName(826,user.getLanguage())%>" onclick="javascript:doSubmit(this);"/>
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>    
	<%
	//设置好搜索条件				
	
	String tableString=""+
		   "<table datasource=\"weaver.docs.docs.DocDataSource.getDocShare\" sourceparams=\"id:"+docid+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.DOC_DOCSHARECONFIRM,user.getUID(),PageIdConst.DOC)+"\" tabletype=\"checkbox\">"+
		   "<sql backfields=\"*\"  sqlform=\"temp\" sqlorderby=\"shareId\"  sqlprimarykey=\"shareId\" sqlsortway=\"desc\"  />"+
		   " <checkboxpopedom  showmethod=\"weaver.general.KnowledgeTransMethod.getShareCheckbox\" id=\"checkbox\"  popedompara=\"column:chk\" />"+
		   "<head>";
		        tableString += "<col width=\"10%\" labelid=\"18495\"  text=\""+SystemEnv.getHtmlLabelName(18495,user.getLanguage())+"\" column=\"type\"/>";
		   		tableString+=	 "<col width=\"20%\" labelid=\"21956\"  text=\""+SystemEnv.getHtmlLabelName(21956,user.getLanguage())+"\" column=\"shareName\" />";	
				tableString +=	 "<col width=\"20%\" labelid=\"106\"  text=\""+SystemEnv.getHtmlLabelName(106,user.getLanguage())+"\" column=\"shareRealName\" />";
				tableString += "<col width=\"20%\" labelid=\"683\"  text=\""+SystemEnv.getHtmlLabelName(683,user.getLanguage())+"\" column=\"shareRealLevel\"/>";					
				
				tableString += "<col width=\"20%\" labelid=\"385\"  text=\""+SystemEnv.getHtmlLabelName(385,user.getLanguage())+"\" column=\"shareRealType\"/>";
				if(!nodownload){
				tableString +=	 "<col width=\"10%\" labelid=\"32070\"  text=\""+SystemEnv.getHtmlLabelName(32070,user.getLanguage())+"\" column=\"downloadlevelName\" />";
				}
			tableString +=	
		   "</head>"+
		   "</table>";      
  %>	
<wea:layout>
				<wea:group context='<%= SystemEnv.getHtmlLabelName(1279,user.getLanguage())%>'>
					<%if(canShare){ %>
						<wea:item type="groupHead">
							<input type="button" class="addbtn" title="<%= SystemEnv.getHtmlLabelName(18645,user.getLanguage())%>" onclick="javascript:openDialog();"/>
							<input type="button" class="delbtn" title="<%= SystemEnv.getHtmlLabelName(18646,user.getLanguage())%>" onclick="javascript:onDelete();"/>
						</wea:item>
					<%} %>
					<wea:item attributes="{'isTableList':'true'}">
						<wea:SplitPageTag  tableString='<%=tableString%>' isShowTopInfo="false"  mode="run"/>
						<input type="hidden" _showCol="false" name="pageId" id="pageId" value="<%= PageIdConst.DOC_DOCSHARECONFIRM %>"/>
					</wea:item>
				</wea:group>
			</wea:layout>
			 
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
				<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onClose();">
				</wea:item>
			</wea:group>
		</wea:layout>
</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
    </BODY>
</HTML>
<%@ include file="/docs/docs/DocCommExt.jsp"%>
<%
BaseBean baseBean_self = new BaseBean();
int userightmenu_self = 1;
String marginStr="";
try{
	userightmenu_self = Util.getIntValue(baseBean_self.getPropValue("systemmenu", "userightmenu"), 1);
}catch(Exception e){}
if(userightmenu_self==1){
	marginStr = "0 8 5 5";
}else{
	marginStr = "30 8 5 5";
}
%>
<SCRIPT LANGUAGE="JavaScript">

function doSubmit(obj){
    obj.disabled = true ; 
    window.location="/docs/docs/DocShareOperation.jsp?sendToAll=<%=sendtoall%>&isdialog=<%=isdialog%>&method=finish&docid=<%=docid%>&actionid=<%=actionid%>&datasourceid=<%=datasourceid%>&blnOsp=true&f_weaver_belongto_userid=<%=f_weaver_belongto_userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>";
}
function doModify(obj){ 
    obj.disabled = true ; 
    window.location="/docs/docs/DocShare.jsp?docid=<%=docid%>&blnOsp=true&f_weaver_belongto_userid=<%=f_weaver_belongto_userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>";
}

</SCRIPT>

<script type="text/javascript" src="/js/doc/DocShareSnip_wev8.js"></script>


