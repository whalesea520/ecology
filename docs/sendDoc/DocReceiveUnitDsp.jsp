

<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="weaver.docs.senddoc.DocReceiveUnitConstant" %>

<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DocReceiveUnitComInfo" class="weaver.docs.senddoc.DocReceiveUnitComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>


<%
String rightStr = "SRDoc:Edit";
String receiveUnitId=Util.null2String(request.getParameter("id"));

//公文交换功能
Prop prop = Prop.getInstance();
//boolean docchangeEnabled = Util.null2String(prop.getPropValue("DocChange", "Enabled")).equals("Y");
String strDocChgEnabled = Util.null2String(prop.getPropValue("DocChange", "Enabled"));
boolean docchangeEnabled = false;
if("Y".equalsIgnoreCase(strDocChgEnabled) || "1".equals(strDocChgEnabled)) {
    docchangeEnabled = true;
}
String receiveUnitName=DocReceiveUnitComInfo.getReceiveUnitName(receiveUnitId);
int superiorUnitId = Util.getIntValue(DocReceiveUnitComInfo.getSuperiorUnitId(receiveUnitId),0);
String receiverIds = DocReceiveUnitComInfo.getReceiverIds(receiveUnitId);
int level=Util.getIntValue(DocReceiveUnitComInfo.getLevel(receiveUnitId),0);
int showOrder = Util.getIntValue(DocReceiveUnitComInfo.getShowOrder(receiveUnitId),0);
int subcompanyid = Util.getIntValue(DocReceiveUnitComInfo.getSubcompanyid(receiveUnitId),0);
String subcompanyname = SubCompanyComInfo.getSubCompanyname(""+subcompanyid);
String changeDir = DocReceiveUnitComInfo.getChangeDir(receiveUnitId);
String companyType = DocReceiveUnitComInfo.getCompanyType(receiveUnitId);
String canceled = DocReceiveUnitComInfo.getCanceled(receiveUnitId);
String isMain = DocReceiveUnitComInfo.getIsMain(receiveUnitId);
String canStartChildRequest = Util.null2String(DocReceiveUnitComInfo.getCanStartChildRequest(receiveUnitId));

%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%




String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(19309,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight(rightStr, user) && ("0".equals(canceled) || "".equals(canceled))){
    
	RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",/docs/sendDoc/DocReceiveUnitEdit.jsp?id="+receiveUnitId+",_self} " ;
    RCMenuHeight += RCMenuHeightStep ;


    RCMenu += "{"+SystemEnv.getHtmlLabelName(19312,user.getLanguage())+",/docs/sendDoc/DocReceiveUnitAdd.jsp?superiorUnitId="+superiorUnitId+"&subcompanyid="+subcompanyid+",_self} " ;
    RCMenuHeight += RCMenuHeightStep ;

    if(level<DocReceiveUnitConstant.RECEIVE_UNIT_MAX_LEVEL){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(19313,user.getLanguage())+",/docs/sendDoc/DocReceiveUnitAdd.jsp?superiorUnitId="+receiveUnitId+"&subcompanyid="+subcompanyid+",_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}

	RCMenu += "{"+SystemEnv.getHtmlLabelName(22151,user.getLanguage())+",javascript:doCanceled(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;

}else if(HrmUserVarify.checkUserRight("SendDoc:Manage", user)&& "1".equals(canceled)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(22152,user.getLanguage())+",javascript:doISCanceled(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}




%>	

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<FORM id=weaver name=frmMain action="" method=post>



    <TR vAlign=top> 
      <TD> 
        <TABLE class=ViewForm width="100%">
		  <TBODY> 
          <COLGROUP> <COL width="30%"> <COL width="70%">
          <TR class=Title> 
              <TH><%=SystemEnv.getHtmlLabelName(16261,user.getLanguage())%></TH>
          </TR>
          <TR class=Spacing style="height: 1px!important;"> 
            <TD class=Line1 colSpan=2></TD>
          </TR>
          <%if(docchangeEnabled){%>
   		  <TR>
            <TD><%=SystemEnv.getHtmlLabelName(22880,user.getLanguage())%></TD>
            <TD class=FIELD>
			<%if(companyType.equals("0")){%><%=SystemEnv.getHtmlLabelName(1994,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1329,user.getLanguage())%><%}%>
			<%if(companyType.equals("1")){%><%=SystemEnv.getHtmlLabelName(1995,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1329,user.getLanguage())%><%}%>
			</select>
			</TD>
          </TR>
          <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
		  <%}%>
          <TR> 
            <TD class=lable><%=SystemEnv.getHtmlLabelName(19309,user.getLanguage())%></TD>
            <TD class=Field> 
              <%=receiveUnitName%>
              </TD>
          </TR>
          <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD class=lable><%=SystemEnv.getHtmlLabelName(19310,user.getLanguage())%></TD>
            <TD class=Field><nobr> 
              <%=DocReceiveUnitComInfo.getReceiveUnitName(superiorUnitId+"")%></TD>
          </TR> 
          <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR> 
		<%if(companyType.equals("0") || docchangeEnabled==false){%>
          <TR> 
            <TD class=lable><%=SystemEnv.getHtmlLabelName(19311,user.getLanguage())%></TD>
            <TD class=Field> 
              <%=ResourceComInfo.getMulResourcename1(receiverIds)%>
            </TD>
          </TR>          
          <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR> 
		  <%}%>
		  <%if(companyType.equals("1") && docchangeEnabled){%>
		  <TR id="CpnTR1">
            <TD><%=SystemEnv.getHtmlLabelName(22879,user.getLanguage())%></TD>
            <TD class=FIELD><%=changeDir%></TD>
          </TR>
          <TR id="CpnTR2" style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
		  <TR id="CpnTR3">
            <TD><%=SystemEnv.getHtmlLabelName(23090,user.getLanguage())%></TD>
            <TD class=FIELD><%if(isMain.equals("0")){%><%=SystemEnv.getHtmlLabelName(23092,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(23091,user.getLanguage())%><%}%></TD>
          </TR>
          <TR id="CpnTR3" style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
		  <%}%>
          <TR> 
            <TD class=lable><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></TD>
            <TD class=Field>
              <%=subcompanyname%>
            </TD>
          </TR>
    <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
	
          <TR> 
            <TD class=lable><%=SystemEnv.getHtmlLabelName(22904,user.getLanguage())%></TD>
            <TD class=Field>
			    <select class=inputstyle  name = canStartChildRequest disabled>
			        <option value=1 <%if(canStartChildRequest.equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
			        <option value=0 <%if(canStartChildRequest.equals("0")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
			    </select>                         
            </TD>
          </TR>
    <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>

          <TR> 
            <TD class=lable><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></TD>
            <TD class=Field> 
              <%=showOrder%>
            </TD>
          </TR>
          <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR> 
          </TBODY> 
        </TABLE>
      </TD>
    </TR>
          
</FORM>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="10" colspan="3"></td>
</tr>
</table>


</BODY></HTML>
<script language=javascript>
function ajaxinit(){
    var ajax=false;
    try {
        ajax = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
        try {
            ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (E) {
            ajax = false;
        }
    }
    if (!ajax && typeof XMLHttpRequest!='undefined') {
    ajax = new XMLHttpRequest();
    }
    return ajax;
}

function doCanceled(){
    if(confirm("<%=SystemEnv.getHtmlLabelName(22153, user.getLanguage())%>")){
	  var ajax=ajaxinit();
      ajax.open("POST", "DocReceiveUnitCanceledCheck.jsp", true);
      ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
      ajax.send("receiveUnitId=<%=receiveUnitId%>&userId=<%=user.getUID()%>");
      ajax.onreadystatechange = function() {
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
	            if(ajax.responseText == 1){
	              alert("<%=SystemEnv.getHtmlLabelName(22155, user.getLanguage())%>");
	              parent.leftframe.location.reload();
	              window.location.href = "DocReceiveUnitDsp.jsp?id=<%=receiveUnitId%>";
	            }else{
	              alert("<%=SystemEnv.getHtmlLabelName(24302, user.getLanguage())%>");
	            }
            }catch(e){
                return false;
            }
        }
     }
  }
}

 function doISCanceled(){
   if(confirm("<%=SystemEnv.getHtmlLabelName(22154, user.getLanguage())%>")){
	  var ajax=ajaxinit();
      ajax.open("POST", "DocReceiveUnitCanceledCheck.jsp", true);
      ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
      ajax.send("receiveUnitId=<%=receiveUnitId%>&cancelFlag=1&userId=<%=user.getUID()%>");
      ajax.onreadystatechange = function() {
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
	            if(ajax.responseText == 1){
	              alert("<%=SystemEnv.getHtmlLabelName(22156, user.getLanguage())%>");
	              parent.leftframe.location.reload();
	              window.location.href = "DocReceiveUnitDsp.jsp?id=<%=receiveUnitId%>";
	            }else{
	              alert("<%=SystemEnv.getHtmlLabelName(24303, user.getLanguage())%>");
				}
            }catch(e){
                return false;
            }
        }
     }
   }
 }
 </script>

