
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="weaver.docs.senddoc.DocReceiveUnitConstant" %>


<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DocReceiveUnitComInfo" class="weaver.docs.senddoc.DocReceiveUnitComInfo" scope="page"/>
<jsp:useBean id="DocReceiveUnitManager" class="weaver.docs.senddoc.DocReceiveUnitManager" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="departmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />

<%
String rightStr = "SRDoc:Edit";
if(!HrmUserVarify.checkUserRight(rightStr, user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
int subcompanyid = Util.getIntValue(request.getParameter("subcompanyid"), 0);
String refresh = Util.null2String(request.getParameter("refresh"));
String navName = SystemEnv.getHtmlLabelName(19309,user.getLanguage());
String isWfDoc = Util.null2String(request.getParameter("isWfDoc"));
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript">
function onBtnSearchClick(){
	jQuery("#frmmain").submit();
}



var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}

function openDialog(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/docs/tabs/DocCommonTab.jsp?_fromURL=36&isWfDoc=<%=isWfDoc%>&isdialog=1&superiorUnitId=0&subcompanyid=<%=subcompanyid%>";
	if(!!id){
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("93,19309",user.getLanguage())%>";
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=37&isWfDoc=<%=isWfDoc%>&isdialog=1&subcompanyid=<%=subcompanyid%>&id="+id;
	}else{
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,19309",user.getLanguage())%>";
	}
	dialog.Width = 600;
	dialog.Height = 450;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function openDialog2(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/docs/tabs/DocCommonTab.jsp?_fromURL=36&isWfDoc=<%=isWfDoc%>&isdialog=1&_thisId="+id+"&subcompanyid=<%=subcompanyid%>";
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,19309",user.getLanguage())%>";
	dialog.Width = 600;
	dialog.Height = 450;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function openDialog3(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/docs/tabs/DocCommonTab.jsp?_fromURL=36&isWfDoc=<%=isWfDoc%>&isdialog=1&_superiorUnitId="+id+"&subcompanyid=<%=subcompanyid%>";
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,19309",user.getLanguage())%>";
	dialog.Width = 600;
	dialog.Height = 450;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function doCancel(id){
	if(!id){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("33930", user.getLanguage())%>");
		return;
	}
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(22153, user.getLanguage())%>",function(){
		jQuery.ajax({
			url:"DocReceiveUnitCanceledCheck.jsp?receiveUnitId="+id+"&userId=<%=user.getUID()%>",
			type:"post",
			dataType:"json",
			beforeSend:function(){
				e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(33592,user.getLanguage())%>",true);
			},
			complete:function(xhr,status){
				e8showAjaxTips("",false);
			},
			success:function(data){
				if(data.result=="1"){
					 window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22155, user.getLanguage())%>");
					 parent.parent.refreshTreeMain(data.subcompanyId,data.subcompanyId);
					 _table.reLoad();
				}else{
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(24302, user.getLanguage())%>");
				}
			}
			
		});
	});
}

function doOpen(id){
	if(!id){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("33930", user.getLanguage())%>");
		return;
	}
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(22154, user.getLanguage())%>",function(){
		jQuery.ajax({
			url:"DocReceiveUnitCanceledCheck.jsp?cancelFlag=1&receiveUnitId="+id+"&userId=<%=user.getUID()%>",
			type:"post",
			dataType:"json",
			beforeSend:function(){
				e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(33592,user.getLanguage())%>",true);
			},
			complete:function(xhr,status){
				e8showAjaxTips("",false);
			},
			success:function(data){
				if(data.result=="1"){
					 window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22156, user.getLanguage())%>");
					 parent.parent.refreshTreeMain(data.subcompanyId,data.subcompanyId);
					 _table.reLoad();
				}else{
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(24303, user.getLanguage())%>");
				}
			}
			
		});
	});
}

function doDelete(id){
	if(!id){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("33930", user.getLanguage())%>");
		return;
	}
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(33435, user.getLanguage())%>",function(){
		jQuery.ajax({
			url:"DocReceiveUnitCanceledCheck.jsp",
			type:"post",
			data:{
				method:"Delete",
				receiveUnitId:id,
				isWfDoc:"<%=isWfDoc%>",
				ajax:"1"
			},
			beforeSend:function(){
				e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(33592,user.getLanguage())%>",true);
			},
			complete:function(xhr,status){
				e8showAjaxTips("",false);
			},
			dataType:"json",
			success:function(data){
				if(data.result=="0"){
					 parent.parent.refreshTreeMain(data.superiorUnitId,data.superiorUnitId);
					 _table.reLoad();
				}else{
					if(data.result=="1"){
						top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(19365, user.getLanguage())%>");
					}else{
						top.Dialog.alert("<%=SystemEnv.getErrorMsgName(20, user.getLanguage())%>");
					}
				}
			}
			
		});
	});
}

jQuery(document).ready(function(){
	<% if(refresh.equals("1")){%>
		parent.parent.refreshTreeMain(<%=subcompanyid%>,<%=subcompanyid%>);
	<%}%>
});

</script>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
</head>
<%


String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(19309,user.getLanguage());
String needfav ="1";
String needhelp ="";
String qname = Util.null2String(request.getParameter("flowTitle"));
if(subcompanyid!=-1&&subcompanyid!=0){
	navName = SubCompanyComInfo.getSubCompanyname(""+subcompanyid);
}
%>
<script type="text/javascript">
	try{
		parent.setTabObjName("<%= navName %>");
	}catch(e){}
</script>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:openDialog("+DocReceiveUnitConstant.RECEIVE_UNIT_ROOT_ID+"),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form action="" name="frmmain" id="frmmain">
<input type="hidden" name="subcompanyid" value="<%=subcompanyid %>"/>
<input class=inputstyle type=hidden name=isWfDoc value="<%=isWfDoc %>">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="openDialog();" value="<%=SystemEnv.getHtmlLabelName(82, user.getLanguage())%>"></input>
			<input type="text" class="searchInput" name="flowTitle"  value="<%=qname %>"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
</form>

<%
    String isLight= "false";
	String id="";
	String receiveUnitName="";
	String superiorUnitId="";
	String receiverIds="";
	String canceled="";


	List allReceiveUnitList=new ArrayList();
	Map allReceiveUnitMap=null;
	DocReceiveUnitManager.setIsWfDoc(isWfDoc);
	DocReceiveUnitManager.setSubcompanyid(subcompanyid);
	DocReceiveUnitManager.getSubCompanyTreeListByRight(user.getUID(), rightStr);
    String tableString = DocReceiveUnitManager.getAllReceiveUnitListNew(allReceiveUnitList,DocReceiveUnitConstant.RECEIVE_UNIT_ROOT_ID,qname,user);

    %>
    <input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.DOC_DOCRECEIVEUNITLIST %>"/>

 <wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  />

</BODY></HTML>
