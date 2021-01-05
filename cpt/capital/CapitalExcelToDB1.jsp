<%@page import="java.util.Map.Entry"%>
<%@page import="org.json.JSONObject"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryManager" class="weaver.docs.category.SecCategoryManager" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryDocTypeComInfo" class="weaver.docs.category.SecCategoryDocTypeComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="MouldManager" class="weaver.docs.mouldfile.MouldManager" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="CptFieldComInfo" class="weaver.cpt.util.CptFieldComInfo" scope="page" />
<jsp:useBean id="CapitalExcelToDB" class="weaver.cpt.ExcelToDB.CapitalExcelToDB" scope="page" />
<jsp:useBean id="CodeUtil" class="weaver.proj.util.CodeUtil" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script LANGUAGE="JavaScript" SRC="/js/checkinput_wev8.js"></script>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
if(!HrmUserVarify.checkUserRight("Capital:Maintenance",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(19314,user.getLanguage());
String needfav ="1";
String needhelp ="";
String isFromTab=Util.null2String( request.getParameter("isFromTab"));
if(!"1".equals(isFromTab)){
	response.sendRedirect("/cpt/capital/CapitalExcelToDB1Tab.jsp") ;
	return ;
}

String isGeneratedTemplateFile=Util.null2String( request.getParameter("isGeneratedTemplateFile"));
if(!"1".equals(isGeneratedTemplateFile)){
	response.sendRedirect("/cpt/capital/CapitalExcelToDBOperation.jsp?generateTemplateFile=1&isdata=2") ;
	return;
}

HashMap<String,JSONObject> fieldInfo=CapitalExcelToDB.getFieldInfo();
String nameQuery = Util.null2String(request.getParameter("nameQuery"));
%>
<BODY style="overflow-x:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:onSave(this),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(19320,user.getLanguage())+",CapitalExcelToDB.jsp,_top} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM id=frmMain name=frmMain action="CapitalExcelToDBOperation.jsp?isdata=2" method=post enctype="multipart/form-data">

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName( 615 ,user.getLanguage()) %>" class="e8_btn_top"  onclick="onSave(this)"/>
			<span id="advancedSearch" class="advancedSearch" style="display:none;"><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>		
<div class="advancedSearchDiv" id="advancedSearchDiv" ></div>


<!-- listinfo -->
<wea:layout attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(19314,user.getLanguage()) %>' attributes="{'groupDisplay':''}" >
<%
if("1".equals(CodeUtil.getCptData2CodeUse())){
	%>
		<wea:item><%=SystemEnv.getHtmlLabelName(22396,user.getLanguage())%></wea:item>
		<wea:item>
			<input class=InputStyle  type=checkbox checked name="autocode" id="autocode" value="1" >
		</wea:item>
	<%
}

%>	
		<wea:item><%=SystemEnv.getHtmlLabelName(1509,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="cptdata1ids" 
				browserValue="" 
				browserSpanValue=""
				browserUrl="/systeminfo/BrowserMain.jsp?url=/cpt/brow/MultiCapitalBrowser.jsp?from=cptimp&resourceids=#id#"
				hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1' width="280px"
				completeUrl="/data.jsp?type=179&from=cptimp" _callback="" />
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" value="<%=SystemEnv.getHtmlLabelNames("83555",user.getLanguage())%>" class="middle e8_btn_top" onclick="regenTemplate();">
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(19971,user.getLanguage())%></wea:item>
		<wea:item>
			<a style="color: #1d98f8;cursor: pointer;" href="CapitalExcelToDB1new.xls?V=<%=System.currentTimeMillis()%>"><%=SystemEnv.getHtmlLabelNames("28446",user.getLanguage())%></a>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(16699,user.getLanguage())%></wea:item>
		<wea:item>
			<input class=InputStyle  type=file size=40 name="filename" id="filename">
		</wea:item>

<%
String msg=Util.null2String(request.getParameter("msg"));
String msgtype=Util.null2String(request.getParameter("msgType"));
int msgsize;
if (Util.null2String(request.getParameter("msgsize"))==""){
   msgsize=0;
}else{
msgsize=Integer.valueOf(Util.null2String(request.getParameter("msgsize"))).intValue();
}
if("success".equals(msg)||msgsize>0){
	%>
		<wea:item attributes="{'id':'msg','colspan':'full'}">
<font size="2" color="#FF0000">
<%


String msg1=Util.null2String((String)session.getAttribute("cptmsg1"));
String msg2=Util.null2String((String)session.getAttribute("cptmsg2"));
String msg3=Util.null2String((String)session.getAttribute("cptmsg3"));
int    dotindex=0;
int    cellindex=0;
int    detailindex = 0;

if("e1".equalsIgnoreCase(msgtype)){
	msg=SystemEnv.getHtmlLabelNames("24652",user.getLanguage());
}else if("e4".equalsIgnoreCase(msgtype)){
	msg=SystemEnv.getHtmlLabelNames("64,26161,563",user.getLanguage());
}else if (msg.equals("success")){
msg=SystemEnv.getHtmlLabelName(19317,user.getLanguage());
}else{
int preRownum=0;
for (int i=0;i<msgsize;i++){
	dotindex=msg1.indexOf(",");
    cellindex=msg2.indexOf(",");
    detailindex=msg3.indexOf("-");
    int rownum=Util.getIntValue( msg1.substring(0, dotindex),1);
    if(i==0){
        out.print(" "+ SystemEnv.getHtmlLabelName(19327, user.getLanguage())+" : ");
        preRownum=rownum;
    }
    if(preRownum!=rownum){
        out.print("<br>");
        out.print(" "+ SystemEnv.getHtmlLabelName(19327, user.getLanguage())+" : ");
        out.println();
        preRownum=rownum;
    }else if(i!=0){
        out.print("&nbsp;&nbsp;");
    }
	out.print("" + rownum + "&nbsp;" + SystemEnv.getHtmlLabelName(18620, user.getLanguage()) + "&nbsp;" + msg2.substring(0, cellindex) + "&nbsp;" + SystemEnv.getHtmlLabelName(18621, user.getLanguage()) + "&nbsp;" + msg3.substring(0, detailindex)+ "");
	
	msg1=msg1.substring(dotindex+1,msg1.length());
    msg2=msg2.substring(cellindex+1,msg2.length());
    msg3=msg3.substring(detailindex+1,msg3.length());
    

}

}

out.println(msg);

if(session.getAttribute("cptexceltodb_totalCount")!=null&&session.getAttribute("cptexceltodb_successCount")!=null){
    double totalcount=Util.getDoubleValue((String) session.getAttribute("cptexceltodb_totalCount"),0);
    double successcount=Util.getDoubleValue((String) session.getAttribute("cptexceltodb_successCount"),0);
    if(successcount>totalcount){
        successcount=totalcount;
    }
    double failurecount=totalcount-successcount;

    if(totalcount>0){
    	String s="<br>"+SystemEnv.getHtmlLabelName(128217, user.getLanguage())+(int)totalcount+SystemEnv.getHtmlLabelName(128218, user.getLanguage())
        +","+SystemEnv.getHtmlLabelName(128219, user.getLanguage())+(int)successcount+SystemEnv.getHtmlLabelName(128218, user.getLanguage())+
        ","+SystemEnv.getHtmlLabelName(128220, user.getLanguage())+(int)failurecount+SystemEnv.getHtmlLabelName(128218, user.getLanguage())+".";
    	
        out.println(s);
    }
}
%></font>			
		</wea:item>	
	<%
}
%>
		
	</wea:group>
	
	<wea:group context='<%=SystemEnv.getHtmlLabelName(19010,user.getLanguage())%>'>
		<wea:item attributes="{'colspan':'full'}">
			<div>
				<br />
				<%=SystemEnv.getHtmlLabelName(128225,user.getLanguage())%>
				<br /><br />
				<%=SystemEnv.getHtmlLabelName(128226,user.getLanguage())%><a style="color: #1d98f8;cursor: pointer;" href="CapitalExcelToDB1new.xls?V=<%=System.currentTimeMillis()%>"><%=SystemEnv.getHtmlLabelNames("28446",user.getLanguage())%></a><%=SystemEnv.getHtmlLabelName(128227,user.getLanguage()) %>
				<br /><br />
				<%=SystemEnv.getHtmlLabelName(128228,user.getLanguage())%>
				<br /><br />
				<%=SystemEnv.getHtmlLabelName(128229,user.getLanguage())%>
				<br /><br />
			</div>
		</wea:item>
	</wea:group>
	
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("24962",user.getLanguage())%>'>
		<wea:item attributes="{'colspan':'full'}">
			<div>
				<br>
				<strong><%=SystemEnv.getHtmlLabelName(18617,user.getLanguage())%></strong>
				<br><br>
				<span style="color:#FF0000;">
					<%=SystemEnv.getHtmlLabelName(18019,user.getLanguage())%>:&nbsp;
					
					<%=SystemEnv.getHtmlLabelName(19322,user.getLanguage())%>&nbsp;
					<%=SystemEnv.getHtmlLabelName(15302,user.getLanguage())%>&nbsp;
                    <%=SystemEnv.getHtmlLabelName(19799,user.getLanguage())%>&nbsp;
					<%=SystemEnv.getHtmlLabelName(15393,user.getLanguage())%>&nbsp;
                    <%--入库单价--%>
                    <%
                    if(fieldInfo.get("startprice").getBoolean("ismand")){
                    %>
                    <%=SystemEnv.getHtmlLabelName(17342,user.getLanguage())%>&nbsp;
                    <%
                    }
                    %>
                    <%--资产状态--%>
                    <%
                    if(fieldInfo.get("stateid").getBoolean("ismand")){
                    %>
                    <%=SystemEnv.getHtmlLabelName(830,user.getLanguage())%>&nbsp;
                    <%
                    }
                    %>
                    <%--入库日期--%>
                    <%
                    if(fieldInfo.get("stockindate").getBoolean("ismand")){
                    %>
                    <%=SystemEnv.getHtmlLabelName(753,user.getLanguage())%>&nbsp;
                    <%
                    }
                    %>
                    <%--购置日期--%>
                    <%
                    if(fieldInfo.get("selectdate").getBoolean("ismand")){
                    %>
                    <%=SystemEnv.getHtmlLabelName(16914,user.getLanguage())%>&nbsp;
                    <%
                    }
                    %>
                    <%--存放地点--%>
                    <%
                    if(fieldInfo.get("location").getBoolean("ismand")){
                    %>
                    <%=SystemEnv.getHtmlLabelName(1387,user.getLanguage())%>&nbsp;
                    <%
                    }
                    %>
                    <%--供应商--%>
                    <%
                    if(fieldInfo.get("customerid").getBoolean("ismand")){
                    %>
                    <%=SystemEnv.getHtmlLabelName(138,user.getLanguage())%>&nbsp;
                    <%
                    }
                    %>
                    <%--条形码--%>
                    <%
                    if(fieldInfo.get("barcode").getBoolean("ismand")){
                    %>
                    <%=SystemEnv.getHtmlLabelName(1362,user.getLanguage())%>&nbsp;
                    <%
                    }
                    %>
                    <%--财务编号--%>
                    <%
                    if(fieldInfo.get("fnamark").getBoolean("ismand")){
                    %>
                    <%=SystemEnv.getHtmlLabelName(15293,user.getLanguage())%>&nbsp;
                    <%
                    }
                    %>
                    <%--生效日--%>
                    <%
                    if(fieldInfo.get("startdate").getBoolean("ismand")){
                    %>
                    <%=SystemEnv.getHtmlLabelName(717,user.getLanguage())%>&nbsp;
                    <%
                    }
                    %>
                    <%--生效至--%>
                    <%
                    if(fieldInfo.get("enddate").getBoolean("ismand")){
                    %>
                    <%=SystemEnv.getHtmlLabelName(718,user.getLanguage())%>&nbsp;
                    <%
                    }
                    %>
                    <%--出厂日期--%>
                    <%
                    if(fieldInfo.get("manudate").getBoolean("ismand")){
                    %>
                    <%=SystemEnv.getHtmlLabelName(1365,user.getLanguage())%>&nbsp;
                    <%
                    }
                    %>
                    <%--替代--%>
                    <%
                    if(fieldInfo.get("replacecapitalid").getBoolean("ismand")){
                    %>
                    <%=SystemEnv.getHtmlLabelName(1371,user.getLanguage())%>&nbsp;
                    <%
                    }
                    %>
                    <%--版本--%>
                    <%
                    if(fieldInfo.get("version").getBoolean("ismand")){
                    %>
                    <%=SystemEnv.getHtmlLabelName(567,user.getLanguage())%>&nbsp;
                    <%
                    }
                    %>
                    <%--账内或账外--%>
                    <%
                    if(fieldInfo.get("isinner").getBoolean("ismand")){
                    %>
                    <%=SystemEnv.getHtmlLabelName(15297,user.getLanguage())%>&nbsp;
                    <%
                    }
                    %>
                    <%--发票号码--%>
                    <%
                    if(fieldInfo.get("invoice").getBoolean("ismand")){
                    %>
                    <%=SystemEnv.getHtmlLabelName(900,user.getLanguage())%>&nbsp;
                    <%
                    }
                    %>
                    <%--领用日期--%>
                    <%
                    if(fieldInfo.get("deprestartdate").getBoolean("ismand")){
                    %>
                    <%=SystemEnv.getHtmlLabelName(1412,user.getLanguage())%>&nbsp;
                    <%
                    }
                    %>
                    <%--备注--%>
                    <%
                    if(fieldInfo.get("remark").getBoolean("ismand")){
                    %>
                    <%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%>&nbsp;
                    <%
                    }
                    %>

				</span>	
					
					
<%
TreeMap<String, JSONObject> mandfieldMap= CptFieldComInfo.getMandFieldMap();
if(mandfieldMap!=null && mandfieldMap.size()>0){
%>	
				<span style="color:#FF0000;">	
					<%=SystemEnv.getHtmlLabelName(17037,user.getLanguage())%>(&nbsp;
					
<%
	Iterator it=mandfieldMap.entrySet().iterator();
	while(it.hasNext()){
		Entry<String,JSONObject> entry=(Entry<String,JSONObject>)it.next();
		String k= entry.getKey();
		JSONObject v= entry.getValue();
%>			
					<%=SystemEnv.getHtmlLabelName(v.getInt("fieldlabel"),user.getLanguage()) %>&nbsp;
<%
	}
	%>
				)</span>
	<%
}

%>
					
				
				<br><br>
				<span>
					<%=SystemEnv.getHtmlLabelName(375,user.getLanguage())%>:&nbsp;
					<%=SystemEnv.getHtmlLabelName(21029,user.getLanguage())%>&nbsp;
					<%=SystemEnv.getHtmlLabelName(21030,user.getLanguage())%>&nbsp;
					<%=SystemEnv.getHtmlLabelName(21031,user.getLanguage())%>&nbsp;
                    <%=SystemEnv.getHtmlLabelName(903,user.getLanguage())%>&nbsp;
                    <%--入库单价--%>
                    <%
                        if(!fieldInfo.get("startprice").getBoolean("ismand")){
                    %>
                    <%=SystemEnv.getHtmlLabelName(17342,user.getLanguage())%>&nbsp;
                    <%
                        }
                    %>
                    <%--资产状态--%>
                    <%
                        if(!fieldInfo.get("stateid").getBoolean("ismand")){
                    %>
                    <%=SystemEnv.getHtmlLabelName(830,user.getLanguage())%>&nbsp;
                    <%
                        }
                    %>
                    <%--入库日期--%>
                    <%
                        if(!fieldInfo.get("stockindate").getBoolean("ismand")){
                    %>
                    <%=SystemEnv.getHtmlLabelName(753,user.getLanguage())%>&nbsp;
                    <%
                        }
                    %>
                    <%--购置日期--%>
                    <%
                        if(!fieldInfo.get("selectdate").getBoolean("ismand")){
                    %>
                    <%=SystemEnv.getHtmlLabelName(16914,user.getLanguage())%>&nbsp;
                    <%
                        }
                    %>
                    <%--存放地点--%>
                    <%
                        if(!fieldInfo.get("location").getBoolean("ismand")){
                    %>
                    <%=SystemEnv.getHtmlLabelName(1387,user.getLanguage())%>&nbsp;
                    <%
                        }
                    %>
                    <%--供应商--%>
                    <%
                        if(!fieldInfo.get("customerid").getBoolean("ismand")){
                    %>
                    <%=SystemEnv.getHtmlLabelName(138,user.getLanguage())%>&nbsp;
                    <%
                        }
                    %>
                    <%--条形码--%>
                    <%
                        if(!fieldInfo.get("barcode").getBoolean("ismand")){
                    %>
                    <%=SystemEnv.getHtmlLabelName(1362,user.getLanguage())%>&nbsp;
                    <%
                        }
                    %>
                    <%--财务编号--%>
                    <%
                        if(!fieldInfo.get("fnamark").getBoolean("ismand")){
                    %>
                    <%=SystemEnv.getHtmlLabelName(15293,user.getLanguage())%>&nbsp;
                    <%
                        }
                    %>
                    <%--生效日--%>
                    <%
                        if(!fieldInfo.get("startdate").getBoolean("ismand")){
                    %>
                    <%=SystemEnv.getHtmlLabelName(717,user.getLanguage())%>&nbsp;
                    <%
                        }
                    %>
                    <%--生效至--%>
                    <%
                        if(!fieldInfo.get("enddate").getBoolean("ismand")){
                    %>
                    <%=SystemEnv.getHtmlLabelName(718,user.getLanguage())%>&nbsp;
                    <%
                        }
                    %>
                    <%--出厂日期--%>
                    <%
                        if(!fieldInfo.get("manudate").getBoolean("ismand")){
                    %>
                    <%=SystemEnv.getHtmlLabelName(1365,user.getLanguage())%>&nbsp;
                    <%
                        }
                    %>
                    <%--替代--%>
                    <%
                        if(!fieldInfo.get("replacecapitalid").getBoolean("ismand")){
                    %>
                    <%=SystemEnv.getHtmlLabelName(1371,user.getLanguage())%>&nbsp;
                    <%
                        }
                    %>
                    <%--版本--%>
                    <%
                        if(!fieldInfo.get("version").getBoolean("ismand")){
                    %>
                    <%=SystemEnv.getHtmlLabelName(567,user.getLanguage())%>&nbsp;
                    <%
                        }
                    %>
                    <%--账内或账外--%>
                    <%
                        if(!fieldInfo.get("isinner").getBoolean("ismand")){
                    %>
                    <%=SystemEnv.getHtmlLabelName(15297,user.getLanguage())%>&nbsp;
                    <%
                        }
                    %>
                    <%--发票号码--%>
                    <%
                        if(!fieldInfo.get("invoice").getBoolean("ismand")){
                    %>
                    <%=SystemEnv.getHtmlLabelName(900,user.getLanguage())%>&nbsp;
                    <%
                        }
                    %>
                    <%--领用日期--%>
                    <%
                        if(!fieldInfo.get("deprestartdate").getBoolean("ismand")){
                    %>
                    <%=SystemEnv.getHtmlLabelName(1412,user.getLanguage())%>&nbsp;
                    <%
                        }
                    %>
                    <%--备注--%>
                    <%
                        if(!fieldInfo.get("remark").getBoolean("ismand")){
                    %>
                    <%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%>&nbsp;
                    <%
                        }
                    %>
					
				</span>

<%
TreeMap<String, JSONObject> openfieldMap= CptFieldComInfo.getOpenFieldMap();
if(openfieldMap!=null && openfieldMap.size()>0&&mandfieldMap!=null&&openfieldMap.size()>mandfieldMap.size()){
%>	
				<span >	
					<%=SystemEnv.getHtmlLabelName(17037,user.getLanguage())%>(&nbsp;
					
<%
	Iterator it=openfieldMap.entrySet().iterator();
	while(it.hasNext()){
		Entry<String,JSONObject> entry=(Entry<String,JSONObject>)it.next();
		String k= entry.getKey();
		JSONObject v= entry.getValue();
		if(v.getInt("ismand")!=1){
			
%>			
					<%=SystemEnv.getHtmlLabelName(v.getInt("fieldlabel"),user.getLanguage()) %>&nbsp;
<%
		}
	}
	%>
				)</span>
				<br><br>
	<%
}

%>
				
				
			</div>
		</wea:item>
	</wea:group>
	
</wea:layout>


<div id='_xTable' style='background:#FFFFFF;padding:3px;width:100%' ></div>
</FORM>
<script language="javascript">
function onSave(obj){
	if (frmMain.filename.value=="" || frmMain.filename.value.toLowerCase().indexOf(".xls")<0){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18618,user.getLanguage())%>");
	}else{
        var showTableDiv  = document.getElementById('_xTable');
		var message_table_Div = document.createElement("div");
		message_table_Div.id="message_table_Div";
		message_table_Div.className="xTable_message";
		showTableDiv.appendChild(message_table_Div);
		var message_table_Div  = document.getElementById("message_table_Div");
		message_table_Div.style.display="inline";
		message_table_Div.innerHTML="<%=SystemEnv.getHtmlLabelName(19316,user.getLanguage())%>....";
		var pTop= document.body.offsetHeight/2-60;
		var pLeft= document.body.offsetWidth/2-100;
		message_table_Div.style.position="absolute";
		message_table_Div.style.posTop=pTop;
		message_table_Div.style.posLeft=pLeft;

		frmMain.submit();
		obj.disabled = true;
    }
}

$(function(){
	//高亮搜索
	$("#topTitle").topMenuTitle({});
});
<%
String regenTemplateMsg=SystemEnv.getHtmlLabelName(128230,user.getLanguage());
String regenTemplateMsg2=SystemEnv.getHtmlLabelName(128231,user.getLanguage());
String regenTemplateMsg3=SystemEnv.getHtmlLabelName(128232,user.getLanguage());
%>
function regenTemplate(event,data,name){
	var cptid=$('#cptdata1ids').val();
	if(cptid!=''){
		var diag_tooltip = new window.top.Dialog();
		var message="<%=regenTemplateMsg %>";
		diag_tooltip.ShowCloseButton=false;
		diag_tooltip.ShowMessageRow=false;
		//diag_tooltip.hideDraghandle = true;
		diag_tooltip.normalDialog = false
		diag_tooltip.Width = 300;
		diag_tooltip.Height = 50;
		diag_tooltip.InnerHtml="<div style=\"font-size:12px;\" >"+message+"<br><img style='margin-top:-20px;' src='/images/ecology8/loadingSearch_wev8.gif' /></div>";
		diag_tooltip.show();
		
		jQuery.ajax({
			url : "CapitalExcelToDBOperation.jsp?method=regenTemplate&isdata=2",
			type : "post",
			async : true,
			data : "cptids="+cptid,
			dataType : "json",
			success: function do4Success(msg){
				if(msg&&msg.result=="success"){
					diag_tooltip.close();
					window.top.Dialog.alert("<%=regenTemplateMsg2 %>");
				}else{
					diag_tooltip.close();
					window.top.Dialog.alert("<%=regenTemplateMsg3 %>");
				}
				
			}
		});
	}
	
}

</script>
</body>
</HTML>
