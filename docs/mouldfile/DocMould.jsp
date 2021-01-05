<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="DocMouldComInfo" class="weaver.docs.mouldfile.DocMouldComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<%
	String urlfrom = Util.null2String(request.getParameter("urlfrom"));
String imagefilename = "/images/hdMaintenance_wev8.gif";
DocMouldComInfo.removeDocMouldCache();
String titlename = "";
String log_id = "";
boolean canEdit=HrmUserVarify.checkUserRight("DocMouldEdit:Edit", user);
int detachable= ManageDetachComInfo.isUseDocManageDetach()?1:0;
int subcompanyid1= -1;
String hasRightSubFirst="";
String subcompanyId="0";
int operatelevel= 0;
String isWorkflowDoc = Util.null2String(request.getParameter("isWorkflowDoc"));
if(detachable==1){
        subcompanyid1=Util.getIntValue(request.getParameter("subcompanyid1"),-1);
        if(subcompanyid1==-1){
			String hasRightSub=String.valueOf(session.getAttribute("docdftsubcomid"));
	       
	      if(!hasRightSub.equals("")){
	       if(hasRightSub.indexOf(',')>-1){  
	      hasRightSubFirst=Util.null2String(hasRightSub.substring(0,hasRightSub.indexOf(',')));
        }else{
          hasRightSubFirst=hasRightSub;
        }
           }
        	subcompanyid1 = Util.getIntValue(String.valueOf(session.getAttribute("editMould_subcompanyid")),-1);
			subcompanyId=String.valueOf(session.getAttribute("editMould_subcompanyid"));
        }

    	operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"DocMouldAdd:add",subcompanyid1);
}else{
	if(HrmUserVarify.checkUserRight("DocMouldAdd:add", user) || HrmUserVarify.checkUserRight("DocMould:log", user))
		operatelevel=2;
}
if(urlfrom.equals("hr")){
  titlename = SystemEnv.getHtmlLabelName(614,user.getLanguage())+"："+SystemEnv.getHtmlLabelName(64,user.getLanguage());
  log_id ="110";
}else{
  titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+"："+SystemEnv.getHtmlLabelName(16449,user.getLanguage());
  log_id ="75";
}
/*if(subcompanyid1==-1 && detachable==1 && urlfrom.equals("hr"))
{
   String s="<TABLE class=viewform><colgroup><col width='10'><col width=''><TR class=Title><TH colspan='2'>"+SystemEnv.getHtmlLabelName(19010,user.getLanguage())+"</TH></TR><TR class=spacing><TD class=line1 colspan='2'></TD></TR><TR><TD></TD><TD><li>";
    if(user.getLanguage()==8){s+="Click on the left branch of the Division for the contract template set</li></TD></TR></TABLE>";}
    else{s+=""+SystemEnv.getHtmlLabelName(22176,user.getLanguage())+"</li></TD></TR></TABLE>";}
    out.println(s);
    return;
}*/
%>
<script type="text/javascript">
	function onBtnSearchClick(){
		jQuery("#frmmain").submit();
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
		var idArr = id.split(",");
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(33435,user.getLanguage())%>",function() {
			var ajaxNum=0;
		   for(var i=0;i<idArr.length;i++){
			   ajaxNum++;
				//以ajax方式提交
				jQuery.ajax({
					url:"UploadDoc.jsp",
					type:"post",
					data:{
						operation:"delete",
						id:idArr[i],
						urlfrom:"<%=urlfrom%>"
					},
					complete:function(xhr,status){
						ajaxNum--;
						if(ajaxNum==0)
							_table.reLoad();
					}
				});
			}
		});
	}
	
	var dialog = null;
	
	function closeDialog(){
		if(dialog)
			dialog.close();
	}
	
	function openDialog(id,doctype){
		dialog = new window.top.Dialog();
		dialog.currentWindow = window; 
		var url = "/docs/tabs/DocCommonTab.jsp?cmd=<%=urlfrom.equals("hr")?"resource":"doc"%>&_fromURL=24&isdialog=1&urlfrom=<%=urlfrom%>&subcompanyid1=<%=subcompanyid1%>&isWorkflowDoc=<%=isWorkflowDoc%>";
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,"+(urlfrom.equals("hr")?"15786":"16449"),user.getLanguage())%>";
		dialog.Width =jQuery(top.window).width()*0.95;
		dialog.Height = jQuery(top.window).height()*0.95;
		if(!!id){
			if(doctype=="0"){
				url = "/docs/tabs/DocCommonTab.jsp?cmd=<%=urlfrom.equals("hr")?"resource":"doc"%>&_fromURL=25&isdialog=2&urlfrom=<%=urlfrom%>&subcompanyid1=<%=subcompanyid1%>&id="+id;
			}else{
				url = "/docs/tabs/DocCommonTab.jsp?cmd=<%=urlfrom.equals("hr")?"resource":"doc"%>&_fromURL=26&isdialog=2&urlfrom=<%=urlfrom%>&subcompanyid1=<%=subcompanyid1%>&id="+id;
			}
			dialog.Title = "<%=SystemEnv.getHtmlLabelNames("93,"+(urlfrom.equals("hr")?"15786":"16449"),user.getLanguage())%>";
			dialog.Width =jQuery(top.window).width()*0.95;
			dialog.Height = jQuery(top.window).height()*0.95;
		}
		dialog.maxiumnable = true;
		dialog.Drag = true;
		dialog.URL = url;
		dialog.show();
	}
	
	//另存为模板
	function openDialogSaveAs(id,doctype){
		dialog = new window.top.Dialog();
		dialog.currentWindow = window; 
		dialog.normalDialog = false;
		if(doctype=="0"){
			url = "/docs/mouldfile/DocMouldEdit.jsp?_fromURL=25&isdialog=2&operation=add&urlfrom=<%=urlfrom%>&subcompanyid1=<%=subcompanyid1%>&id="+id;
		}else{
			url = "/docs/mouldfile/DocMouldEditExt.jsp?&_fromURL=26&isdialog=2&operation=add&urlfrom=<%=urlfrom%>&subcompanyid1=<%=subcompanyid1%>&id="+id;
		} 
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("33144,350",user.getLanguage())%>";
		dialog.Width =400;
		dialog.Height = 150;

		dialog.URL = url;
		dialog.maxiumnable = false;
		dialog.show();
	}
	
	function onLog(){
		var dialog = new window.top.Dialog();
		dialog.URL = "/docs/tabs/DocCommonTab.jsp?cmd=<%=urlfrom.equals("hr")?"resource":"doc"%>&_fromURL=3&sqlwhere=<%=xssUtil.put("operateitem ="+log_id)%>";
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(17480,user.getLanguage())%>";
		dialog.Width = jQuery(document).width();
		dialog.Height = 610;
		dialog.checkDataChange = false;
		dialog.maxiumnable = true;
		dialog.show();
		
	}
	/*查看模板*/
	
	function viewDialog(id){
		dialog = new window.top.Dialog();
		dialog.currentWindow = window; 
		dialog.checkDataChange = false;
		url = "/docs/tabs/DocCommonTab.jsp?cmd=<%=urlfrom.equals("hr")?"resource":"doc"%>&_fromURL=27&isdialog=2&urlfrom=<%=urlfrom%>&subcompanyid1=<%=subcompanyid1%>&id="+id;
		<%if(canEdit){%>
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(16450,user.getLanguage())%>";
		<%}else{%>
        dialog.Title = "<%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(16450,user.getLanguage())%>";
			<%}%>
		dialog.Width =jQuery(top.window).width()*0.95;
		dialog.Height = jQuery(top.window).height()*0.95;
		dialog.Drag = true;
		dialog.URL = url;
		dialog.maxiumnable = true;
		dialog.show();
	}
	
	/*标签排序*/
	function labelOrderDialog(id){
		dialog = new window.top.Dialog();
		dialog.currentWindow = window; 
		url = "/docs/tabs/DocCommonTab.jsp?cmd=<%=urlfrom.equals("hr")?"resource":"doc"%>&_fromURL=55&isdialog=1&isWorkflowDoc=<%=isWorkflowDoc%>&mouldId="+id;
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("26364,338",user.getLanguage())%>";
		dialog.Width = 800;
		dialog.Height = 460;
		dialog.Drag = true;
		dialog.URL = url;
		dialog.maxiumnable = true;
		dialog.show();
	}
	
</script>
</head>
<%
String needfav ="1";
String needhelp ="";
String mouldName = Util.null2String(request.getParameter("flowTitle"));
%>
<BODY>


<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>

<form action="DocMould.jsp" name="frmmain" id="frmmain">
<input type="hidden" name="urlfrom" value="<%=urlfrom%>">
<input type="hidden" name="isWorkflowDoc" id="isWorkflowDoc" value="<%=isWorkflowDoc %>"/>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%
			if(HrmUserVarify.checkUserRight("DocMouldAdd:add", user)){
			%>
			<%
				if(operatelevel > 0){
			%>
				<input type="button" class="e8_btn_top" value="<%= SystemEnv.getHtmlLabelName(82,user.getLanguage())%>" onclick="javascript:openDialog();"/>
			<%
				}
			%>
			<%
			}if(HrmUserVarify.checkUserRight("DocMouldEdit:Delete", user)){
				if(operatelevel > 0){
			%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("91",user.getLanguage())%>" class="e8_btn_top" onclick="onDelete();"/>
			<%} }%>
			<input type="text" class="searchInput" name="flowTitle" value="<%=mouldName %>"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
</form>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>


<%
if(HrmUserVarify.checkUserRight("DocMouldAdd:add", user)){
%>
<%
	if(operatelevel > 0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:openDialog(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	}
%>
<%
}

if(HrmUserVarify.checkUserRight("DocMouldEdit:Delete", user)){
	if(operatelevel > 0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	}
}

if(HrmUserVarify.checkUserRight("DocMould:log", user)){
%>
<%
if(operatelevel > 0){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:onLog(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>

<%}
%>
 
<%
	
	String backfields = "a.*,(select COUNT(*) from HrmContractType where contracttempletid in ( select id from HrmContractTemplet where templetdocid = a.id)) as result";
	String sqlform = "DocMouldFile a";
    String sqlWhere ="";
    
    if(urlfrom.equals("hr")){
    	if(detachable==1){
    		String subcompanyidStr = "";
    		if(subcompanyid1>0){
    			subcompanyidStr = "where subcompanyid = "+subcompanyid1;
    		}
    		sqlWhere=" ID  IN (Select TEMPLETDOCID From HrmContractTemplet "+subcompanyidStr+")";
    	}else{
			sqlWhere=" ID  IN (Select TEMPLETDOCID From HrmContractTemplet) ";
		}
    }else{
		sqlWhere=" ID NOT IN (Select TEMPLETDOCID From HrmContractTemplet)";
    }
    
    if(!mouldName.equals("mouldName")){
    	sqlWhere += " and mouldName like '%"+mouldName+"%'";
    }
    if(Util.getIntValue(String.valueOf(session.getAttribute("docdetachable")),0)==1){
		sqlWhere += " and subcompanyid in("+subcompanyId+")";
	}
	if(isWorkflowDoc.equals("1")){
		sqlWhere += " and mouldType in (2,4)";
	}		
    String  operateString= "<operates width=\"20%\">";
	 	       operateString+=" <popedom transmethod=\"weaver.hrm.common.SplitPageTagOperate.getBasicOperate2\"  otherpara=\""+HrmUserVarify.checkUserRight("DocMouldAdd:add", user)+":"+HrmUserVarify.checkUserRight("DocMouldEdit:Edit", user)+":+column:mouldType+==2:+column:result+==0and"+HrmUserVarify.checkUserRight("DocMouldEdit:Delete", user)+":isIE="+isIE+":+column:mouldType+=0"+"\"></popedom> ";
	 	       operateString+="     <operate  otherpara=\"column:mouldType\" href=\"javascript:openDialog()\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
			 
	 	       operateString+="     <operate otherpara=\"column:mouldType\" href=\"javascript:openDialogSaveAs()\" text=\""+SystemEnv.getHtmlLabelName(350,user.getLanguage())+"\" index=\"1\"/>";
			  
	 	       operateString+="     <operate otherpara=\"column:mouldType\" href=\"javascript:labelOrderDialog()\" text=\""+SystemEnv.getHtmlLabelNames("26364,338",user.getLanguage())+"\" index=\"2\"/>";
	 	       operateString+="     <operate href=\"javascript:onDelete()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\"  index=\"3\"/>";
	 	       operateString+="</operates>";
    String tableString=""+
		   "<table pageId=\""+PageIdConst.DOC_EIDTMOULDLIST+"\" instanceid=\"docMouldTable\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.DOC_EIDTMOULDLIST,user.getUID(),PageIdConst.DOC)+"\" tabletype=\"checkbox\">"+
		   " <checkboxpopedom showmethod=\"weaver.hrm.common.SplitPageTagOperate.getBasicCheckbox\"  id=\"checkbox\"  popedompara=\"column:result+==0\" />"+
		   "<sql backfields=\""+backfields+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlform=\""+sqlform+"\" sqlorderby=\"mouldType\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqldistinct=\"true\" />"+
		   operateString+
		   "<head>"+							 
				 "<col width=\"10%\" text=\"ID\" column=\"id\" orderkey=\"id\"  />"+
				 "<col width=\"50%\" transmethod=\"weaver.general.KnowledgeTransMethod.getMouldFileName\" otherpara=\"column:id\" text=\""+SystemEnv.getHtmlLabelName(18151,user.getLanguage())+"\" column=\"mouldName\" orderkey=\"mouldName\"/>"+
				 "<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(20622,user.getLanguage())+"\" column=\"mouldType\" transmethod=\"weaver.general.KnowledgeTransMethod.getModuleType\" otherpara=\""+urlfrom+":"+user.getLanguage()+"\" orderkey=\"mouldType\" />"+
				 "<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(19521 ,user.getLanguage())+"\" column=\"lastModTime\" transmethod=\"weaver.general.KnowledgeTransMethod.getMouldModDate\" orderkey=\"lastModTime\" />"+						
		   "</head>"+
		   "</table>"; 
	%>
	<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.DOC_EIDTMOULDLIST %>"/>
    <wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  />
	

 <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
 </BODY></HTML>
