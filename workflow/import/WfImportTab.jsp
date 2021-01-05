<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ include file="/systeminfo/init.jsp"%>
<%@ taglib uri="/browser" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<HTML>
	<HEAD>
		<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
		<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min.js'></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue.js'></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete.js'></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/browser.js'></script>
		<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete.css" />
		<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser.css" />			
		<SCRIPT language="javascript" src="../../js/weaver.js"></script>
		<style>
		#loading{
		    position:absolute;
		    left:45%;
		    background:#ffffff;
		    top:40%;
		    padding:8px;
		    z-index:20001;
		    height:auto;
		    border:1px solid #ccc;
		}
		</style>
	</head>
	<%
		if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user))
		{
			response.sendRedirect("/notice/noright.jsp");
	    	
			return;
		}
		String imagefilename = "/images/hdSystem.gif";
		String titlename = SystemEnv.getHtmlLabelName(24771,user.getLanguage());//"���̵���";24771
		String needfav = "1";
		String needhelp = "";
		
		String workflowid = Util.null2String(request.getParameter("workflowid"));
		String importtype = Util.null2String(request.getParameter("importtype"));
		String type = Util.null2String(request.getParameter("type"));
		String checkresult = Util.null2String(request.getParameter("checkresult"));

	%>
	<BODY>
		<%@ include file="/systeminfo/TopTitle.jsp"%>
		<%@ include file="/systeminfo/RightClickMenuConent.jsp"%>
		<%		
			RCMenu += "{"+SystemEnv.getHtmlLabelName(25649,user.getLanguage())+",javascript:importwf(),_top}" ;
			RCMenuHeight += RCMenuHeightStep ;
		%>
		<%@ include file="/systeminfo/RightClickMenu.jsp"%>
		
		<div id="loading">
			<span><img src="/images/loading2.gif" align="absmiddle"></span>
			<!-- ���ݵ����У����Ե�... -->
			<span  id="loading-msg"><%=SystemEnv.getHtmlLabelName(28210,user.getLanguage())%></span>
		</div>

		<div id="content">
<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="WfImportOperation.jsp" enctype="multipart/form-data">
<%
	if(checkresult.equals("1")){//�������Ͳ����
		out.println("<span><font color=red>"+SystemEnv.getHtmlLabelName(28211,user.getLanguage())+"<font></span>");
		out.println("<br/>");
	}else if(checkresult.equals("2")){//
		out.println("<span><font color=red>"+SystemEnv.getHtmlLabelName(28212,user.getLanguage())+"<font></span>");
		out.println("<br/>"); 
	}
%>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
		    <input type="button" value="<%=SystemEnv.getHtmlLabelName(25649,user.getLanguage())%>" class="e8_btn_top" onclick="importwf();"/>
			<span title="�˵�" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<wea:layout type="twoCol">
    <wea:group context="<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>">
    	<wea:item><%=SystemEnv.getHtmlLabelName(24863,user.getLanguage())%></wea:item>
    	<wea:item>
			<select id="importtype" name="importtype" onchange="importTypeChange(this)" style="width: 150px;">
				<option value="0" <%if(importtype.equals("0")) out.println("selected");%>>
					<%=SystemEnv.getHtmlLabelName(1421,user.getLanguage())%>
				</option>
				<option value="1" <%if(importtype.equals("1")) out.println("selected");%>>
					<%=SystemEnv.getHtmlLabelName(17744,user.getLanguage())%>
				</option>
			</select>    	
    	</wea:item>
    	<wea:item><%=SystemEnv.getHtmlLabelName(25646,user.getLanguage())%></wea:item>
    	<wea:item>
			<select id=type name=type style="width: 150px;">
				<option value="0" <%if(type.equals("0")) out.println("selected");%>>
					<%=SystemEnv.getHtmlLabelName(25647,user.getLanguage())%>
				</option>
				<option value="1" <%if(type.equals("1")) out.println("selected");%>>
					<%=SystemEnv.getHtmlLabelName(25648,user.getLanguage())%>
				</option>
			</select>    	
    	</wea:item>
    	<wea:item><%=SystemEnv.getHtmlLabelName(33807,user.getLanguage())%></wea:item>
    	<wea:item attributes="{\"id\":\"workflow_td\"}">
  			<brow:browser name="workflowid" viewType="0" hasBrowser="true" hasAdd="false" 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp" isMustInput="2" isSingle="true" hasInput="true"
 					completeUrl="/data.jsp?type=workflowBrowser" width="300px" browserValue="<%=workflowid%>" browserSpanValue="<%=WorkflowComInfo.getWorkflowname(workflowid) %>"/>    	
    	</wea:item>
    	<wea:item>XML<%=SystemEnv.getHtmlLabelName(18493,user.getLanguage())%></wea:item>
    	<wea:item>
			<input class=InputStyle  type=file size=40 name="filename" id="filename" onChange="checkinput('filename','filenamespan')">
			<span id="filenamespan"><img src="/images/BacoError.gif" align=absmiddle></span>     	
    	</wea:item>
    </wea:group>
    <wea:group attributes="{\"itemAreaDisplay\":\"block\"}" context="<%=SystemEnv.getHtmlLabelName(33803,user.getLanguage()) %>">
    	<wea:item><%=SystemEnv.getHtmlLabelName(25650,user.getLanguage()) %></wea:item>
    </wea:group>
    <wea:group attributes="{\"itemAreaDisplay\":\"block\"}" context="<%=SystemEnv.getHtmlLabelName(33804,user.getLanguage()) %>">
    	<wea:item>
			1��<!-- ϵͳһ����--><%=SystemEnv.getHtmlLabelName(25646,user.getLanguage())%>/<!--ϵͳһ��--><%=SystemEnv.getHtmlLabelName(25647,user.getLanguage())%>��
			<!-- ����xml�ļ�������ϵͳ��xml�ļ������ϵͳ��ȫһ��(��Ա����֯�ṹ����ɫ��һ��)-->
			<%=SystemEnv.getHtmlLabelName(25651,user.getLanguage())%>
			<BR>
			2��<!-- ϵͳһ����--><%=SystemEnv.getHtmlLabelName(25646,user.getLanguage())%>/<!--ϵͳ��һ��--><%=SystemEnv.getHtmlLabelName(25648,user.getLanguage())%>��
			<!--����xml�ļ�������ϵͳ������xml�ļ������ϵͳ���ܲ�һ��(��Ա����֯�ṹ����ɫ�Ȳ�һ��)����һ�µ�����£����̲����ߣ���������,�Լ�������ģ����ع���(����߼����ã��������õ�)�����ᵼ�룬��Ҫ��������-->
			<%=SystemEnv.getHtmlLabelName(25652,user.getLanguage())%>
			<BR>
			3��<!-- ��������--><%=SystemEnv.getHtmlLabelName(24863,user.getLanguage())%>/<!--����--><%=SystemEnv.getHtmlLabelName(1421,user.getLanguage())%>��
			<%=SystemEnv.getHtmlLabelName(28213,user.getLanguage())%>
			<BR>
			4��<!-- ��������--><%=SystemEnv.getHtmlLabelName(24863,user.getLanguage())%>/<!--����--><%=SystemEnv.getHtmlLabelName(17744,user.getLanguage())%>��
			<%=SystemEnv.getHtmlLabelName(28214,user.getLanguage())%>
			<BR>
    	</wea:item>
    </wea:group>
</wea:layout>
</FORM>
</div>
</BODY>
	
	<script type="text/javascript">
	function importTypeChange(obj){
		if(obj.value=="1"){//����
		    $("#type").val("0");
			$("#type").selectbox("disable");
			$("#workflow_td").parent().show().next().show();		
		}else{//��������Ҫ���������͵��������
			$("#type").selectbox("enable")
		    $("#workflow_td").parent().hide().next().hide();
		    $("#workflowid").val("");
			$("#workflowidspan").html("");
		}
	}

	jQuery(document).ready(function(){
		importTypeChange($GetEle("importtype"));
		jQuery("#loading").hide();
	})

	function importwf(){
		var parastr="filename";				
		var filename = document.frmMain.filename.value;
		//�����������Ϊ
		if($GetEle("importtype").value=="1"){
			if(!check_form(document.frmMain,"workflowid")){
				return;
			}
			jQuery("#type").val("0");
			document.frmMain.action = "/workflow/import/WfUpdateOperation.jsp";
		}else{
			document.frmMain.action = "/workflow/import/WfImportOperation.jsp";
		}

		if(check_form(document.frmMain,parastr)){
			var pos = filename.length-4;
			if(filename.lastIndexOf(".xml")==pos){
				jQuery("#type").attr("disabled",false);
				jQuery("#loading").show();
				jQuery("#content").hide();
				document.frmMain.submit();
			}else{
				alert("<%=SystemEnv.getHtmlLabelName(25644,user.getLanguage())%>");//ѡ���ļ���ʽ����ȷ,��ѡ��xml�ļ�25644
				return;
			}
		}
	}
	</script>
</HTML>