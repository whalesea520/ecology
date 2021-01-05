
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.workflow.workflow.UserWFOperateLevel" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="SubComanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
		response.sendRedirect("/notice/noright.jsp");
    		return;
}

int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int isbill=Util.getIntValue(Util.null2String(request.getParameter("isbill")),-1);
String billid = Util.null2String(request.getParameter("billid"));
int operatelevel = UserWFOperateLevel.checkWfFormOperateLevel(detachable,user,"FormManage:All",Util.getIntValue(billid,0),isbill);

String detailno = Util.null2String(request.getParameter("detailno"));
String operation = Util.null2String(request.getParameter("operation"));
if(operation.equals("submit")){
	String subcompanyid=Util.null2String(request.getParameter("subcompanyid"));
	RecordSet.executeSql("update workflow_bill set subcompanyid="+subcompanyid+" where id="+billid);
}

RecordSet.executeSql("select subcompanyid from workflow_bill where id="+billid);
RecordSet.next();
int subcompanyid=Util.getIntValue(RecordSet.getString("subcompanyid"),0);

String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(18581,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
%>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(operatelevel > 0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/workflow/workflow/BillManagementDetail"+detailno+".jsp?isbill="+isbill+"&billId="+billid+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="BillRightManagent.jsp">
<input type="hidden" name=operation  value="">
<input type="hidden" name=billid  value="<%=billid%>">
<input type="hidden" name=detailno  value="<%=detailno%>">
<input type="hidden" name=isbill  value="<%=isbill%>">
<wea:layout type="2col">
						<wea:group context="<%=SystemEnv.getHtmlLabelName(26505,user.getLanguage())+SystemEnv.getHtmlLabelName(68,user.getLanguage()) %>">
						<wea:item><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></wea:item>
						<wea:item>
						<%if(operatelevel > 0){%>
				            <brow:browser name="subcompanyid" viewType="0" hasBrowser="true" hasAdd="false" 
				                  browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=WorkflowManage:All&isedit=1&selectedids=" isMustInput="2" isSingle="true" hasInput="true"
				                  completeUrl="/data.jsp?type=164&show_virtual_org=-1"  width="300px" browserValue='<%=String.valueOf(subcompanyid)%>' browserSpanValue='<%=SubComanyComInfo.getSubCompanyname(String.valueOf(subcompanyid))%>'/>
						<%}else{ %>
				            <brow:browser name="subcompanyid" viewType="0" hasBrowser="true" hasAdd="false" 
				                  browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=WorkflowManage:All&isedit=1&selectedids=" isMustInput="0" isSingle="true" hasInput="true"
				                  completeUrl="/data.jsp?type=164&show_virtual_org=-1"  width="300px" browserValue='<%=String.valueOf(subcompanyid)%>' browserSpanValue='<%=SubComanyComInfo.getSubCompanyname(String.valueOf(subcompanyid))%>'/>
						<%}%>
						</wea:item>
						</wea:group>
					</wea:layout>
  </FORM>
</BODY>

<!--<script language=vbs>
    sub onShowSubcompany()
        id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="&frmMain.subcompanyid.value)
        issame = false 
        if (Not IsEmpty(id)) then
        if id(0)<> 0 then
        if id(0) = frmMain.subcompanyid.value then
            issame = true 
        end if
        supsubcomspan.innerHtml = id(1)
        frmMain.subcompanyid.value=id(0)
        else
        supsubcomspan.innerHtml = ""
        frmMain.subcompanyid.value=""
        end if
        end if
    end sub
</script>  -->

<script language="javascript">
	function onSubmit(){
		if(check_form(frmMain,'subcompanyid')){
			document.all("operation").value="submit";
			frmMain.submit();
		}
	}
	
	function onShowSubcompany(){
        datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids=<%=subcompanyid%>");
        issame = false ;
        if(datas){
	        if(datas.id!="0"&&datas.id!=""){
	        if(datas.id ==  $GetEle("subcompanyid").value){
	            issame = true ;
	        }
	        $GetEle("supsubcomspan").innerHTML = datas.name;
	        $GetEle("subcompanyid").value=datas.id;
	        }else{
	          //supsubcomspan.innerHtml = "";
	          //frmMain.subcompanyid.value="";
	          $GetEle("supsubcomspan").innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
		      $GetEle("subcompanyid").value="";
	        }
        }
    }
	
</script>

</HTML>
