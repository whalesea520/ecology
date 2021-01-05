
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="rs" class= "weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rci" class= "weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="dci" class= "weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="sci" class= "weaver.hrm.company.SubCompanyComInfo" scope="page" />

<%
String type = Util.null2String(request.getParameter("type"));
String resourceId = Util.null2String(request.getParameter("resourceId"));	
String resourceType = Util.null2String(request.getParameter("resourceType"));	
String menuId = Util.null2String(request.getParameter("menuId"));
String titlename="";
%>

<html>
<HEAD> 
    <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
    <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</HEAD>
<body>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:doSave(this),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
   
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%
   
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
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
                    <tr>
                        <td valign="top">  
                            <form name="frmAdd" method="post" action="SystemMenuMaintoperation.jsp">
                              <INPUT TYPE="hidden" NAME="menuId" value="<%=menuId%>">
                              <INPUT TYPE="hidden" NAME="type" value="<%=type%>">           
                              <INPUT type="hidden" Name="operate" value="addLimit">
                			  <INPUT type="hidden" Name="resourceId" value="<%=resourceId%>">
                			  <INPUT type="hidden" Name="resourceType" value="<%=resourceType%>">
							  

                              <TABLE class=ViewForm>
                                <COLGROUP>
                                <COL width="30%">
                                <COL width="70%">
                                <TBODY>                                    
                                    <TR class=Spacing style="height:1px;">
                                    <TD class=Line1 colSpan=2></TD></TR>
                                    <TR>
                                        <TD>
                                           <%=SystemEnv.getHtmlLabelName(18495,user.getLanguage())%>
                                        </TD>
                                            
                                        <TD class="field">
                                            
                                            <SELECT class=InputStyle  name=sharetype id="sharetype" onchange="onChangeSharetype(this,relatedshareid,showrelatedsharename)" >   
                                                <option value="1" selected><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></option>
                                                <option value="3"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
                                            </SELECT>
                                            &nbsp;&nbsp;
                                            
											<button type=button  class=Browser id="btnRelatedHrm" style="display:''" onClick="onShowResource('relatedshareid','showrelatedsharename')" name="btnRelatedHrm"></BUTTON> 
											<button type=button  class=Browser id="btnRelatedDepartment" style="display:none"  onClick="onShowDepartment('relatedshareid', 'showrelatedsharename')" name="btnRelatedAll"></BUTTON> 
                                            
											<INPUT type=hidden name="relatedshareid"  id="relatedshareid" value="">
											<INPUT type=hidden name="removeshareids"  id="removeshareids" value="">
                                            <span id="showrelatedsharename" name="showrelatedsharename">
												<IMG src='/images/BacoError_wev8.gif' align=absMiddle>
											</span>                                            
                                        </TD>		
                                    </TR>
                                    <TR class=Spacing style="height:1px;">
                                        <TD class=Line1 colSpan=2></TD>
                                    </TR>                                  

                                    <tr>
                                        <TD  colspan=2>
                                           <TABLE  width="100%">
                                            <TR>
                                                <TD width="35%"></TD>
                                                <TD width="30%"><img src="/images/arrow_d_wev8.gif" style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" onclick="addValue()" border="0">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/images/arrow_u_wev8.gif" style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(20230,user.getLanguage())%>" border="0" onclick="removeValue()"></TD>
                                                <TD width="35%"></TD>
                                            </TR>
                                           </TABLE>
                                        </TD>
                                    <tr>
                                   <TR class=Spacing style="height:1px;">
                                        <TD class=Line1 colSpan=2></TD>
                                   </TR>
                                   <tr>
                                        <td colspan=2>
                                            <table class="listStyle" id="oTable" name="oTable">
                                                <colgroup>
                                                <col width="8%">
                                                <col width="42%">
                                                <col width="50%">
                                                <tr class="header">
                                                    <td><input type="checkbox" name="chkAll" onclick="chkAllClick(this)"></td>
                                                    <td><%=SystemEnv.getHtmlLabelName(18495,user.getLanguage())%></td>
                                                    <td><%=SystemEnv.getHtmlLabelName(119,user.getLanguage())%></td>
                                                </tr>
                                                <tr class=Spacing style="height:1px;"><td class=Line1 colspan=6 style="padding:0;"></td></tr>
                                                <%
                                                rs.executeSql("select id,resourceId,resourceType from mainmenuconfig where infoid = "+menuId);
                                                int oRowIndex = 0;
                                                String className = "";
                                                while(rs.next()){
                                                	oRowIndex++;
                                                	int id = rs.getInt("id");
                                                	int sourceId = rs.getInt("resourceId");
                                                	int sourceType = rs.getInt("resourceType");
                                                	String share = "";
                                                	String sharetype = "";
													if(sourceType==1){
														share = rci.getLastname(sourceId+"");
														sharetype = SystemEnv.getHtmlLabelName(33451,user.getLanguage());
													}else if(sourceType==2){
														share = sci.getSubCompanyname(sourceId+"");
														sharetype = SystemEnv.getHtmlLabelName(33553,user.getLanguage());
														if(!resourceId.equals(sourceId+"")) continue;
                                                	}else if(sourceType==3){
                                                		share = dci.getDepartmentname(sourceId+"");
                                                		sharetype = SystemEnv.getHtmlLabelName(82499,user.getLanguage());
                                                	}
													if (oRowIndex%2==0) className="dataDark";
													else className="dataLight";
                                                %>
                                                	<tr class='<%=className %>'>
                                                	<td>
                                                	<div><input type="checkbox" name="chkShareDetail" <%=(sourceType==1&&sourceId==1)?"disabled":"value='"+id+"'" %>></div>
                                                	</td>
                                                    <td><%=sharetype%></td>
                                                    <td><%=share%></td>
                                                    </tr>
                                              <%  } %>
                                            </table>
                                        </td>
                                   </tr>
                                </TBODY>
                            </TABLE>
                        </td>
                    </tr>
                </TABLE>
                </form>
            </td>
            <td></td>
        </tr>
        <tr>
            <td height="10" colspan="3"></td>
        </tr>
        </table>

</body>
</html>


<SCRIPT LANGUAGE="JavaScript">
<!--
  function onChangeSharetype(seleObj,txtObj,spanObj){
	var thisvalue=seleObj.value;	
    var strAlert= "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	
	if(thisvalue==1){  //人员
 		document.getElementById("btnRelatedHrm").style.display='';
		document.getElementById("btnRelatedDepartment").style.display='none';
		txtObj.value="";		
		spanObj.innerHTML=strAlert;	
	} else if (thisvalue==3)	{ //部门
		document.getElementById("btnRelatedHrm").style.display='none';
		document.getElementById("btnRelatedDepartment").style.display='';
		txtObj.value="";
		spanObj.innerHTML=strAlert;	
	}
	
}
function removeValue(){
    var chks = document.getElementsByName("chkShareDetail");
    for (var i=chks.length-1;i>=0;i--){
        var chk = chks[i];
        if (chk.checked){
            oTable.deleteRow(chk.parentElement.parentElement.parentElement.rowIndex);
        	if(chk.value!=''&&chk.value!='on') document.getElementById("removeshareids").value = chk.value+",";
        }
    }
}

function addValue(){
   var thisvalue=document.getElementById("sharetype").value;

   var shareTypeValue = thisvalue;
   var shareType=$("#sharetype")[0];
   var shareTypeText = $(shareType.options[shareType.selectedIndex]).text();

    //人力资源(1),部门(3)
    var relatedShareIds="0";
    var relatedShareNames="";
    if (thisvalue==1 || thisvalue==3) {
        if(!check_form(document.frmAdd,'relatedshareid')) {
            return ;
        }
        relatedShareIds = $G("relatedshareid").value;
        relatedShareNames= $G("showrelatedsharename").innerHTML;
        //alert(relatedShareIds);
    }

   //共享类型 + 共享者ID
   var totalValue=shareTypeValue+"_"+relatedShareIds

   var oRow = oTable.insertRow(-1);
   var oRowIndex = oRow.rowIndex;

   if (oRowIndex%2==0) oRow.className="dataLight";
   else oRow.className="dataDark";

   for (var i =1; i <=3; i++) {   //生成一行中的每一列
      oCell = oRow.insertCell(-1);
      var oDiv = document.createElement("div");
      if (i==1) oDiv.innerHTML="<input class='inputStyle' type='checkbox' name='chkShareDetail'><input type='hidden' name='txtShareDetail' value='"+totalValue+"'>";
      else if (i==2) oDiv.innerHTML=shareTypeText;
	  else if (i==3) oDiv.innerHTML=relatedShareNames;
      oCell.appendChild(oDiv);
   }
}

function chkAllClick(obj){
	 var chkboxElems= document.getElementsByName("chkShareDetail");
	    for (j=0;j<chkboxElems.length;j++)
	    {
	        if (obj.checked) 
	        {
	        	if(chkboxElems[j].style.display!='none'&&!chkboxElems[j].disabled){
	            	chkboxElems[j].checked = true ;		
	            }	
	        } 
	        else 
	        {       
	            chkboxElems[j].checked = false ;
	        }
	    }
}

//-->
</SCRIPT>

<script type="text/javascript">
//<!--
function disModalDialogRtnM(url, inputname, spanname, need, curl, isjs) {
	var id = window.showModalDialog(url);
	
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			var ids = wuiUtil.getJsonValueByIndex(id, 0).substr(1);
			var names = wuiUtil.getJsonValueByIndex(id, 1).substr(1);
			$G(inputname).value = ids;
			var sHtml = "";
			var ridArray = ids.split(",");
			var rNameArray = names.split(",");
			
			for ( var i = 0; i < ridArray.length; i++) {
				var curid = ridArray[i];
				var curname = rNameArray[i];
				
				if (curl != undefined && curl != null && curl != "") {
					sHtml += ("&nbsp;<A href='" + curl+ curid) 
							+ (isjs ? ")' onclick='pointerXY(event);" : "")
							+ ("'>" + curname + "</a>&nbsp;");
				} else {
					sHtml += curname + (i < ridArray.length - 1) ? "," : ""; 
				}
			}
			
			$G(spanname).innerHTML = sHtml;
		} else {
			$G(inputname).value = "";
			$G(spanname).innerHTML = need ? "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>" : "";
		}
	}
}

function onShowDepartment(inputname,spanname) {
	var url = "/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids=" + $G(inputname).value;
	var curl = "/hrm/company/HrmDepartmentDsp.jsp?id=";
	disModalDialogRtnM(url, inputname, spanname, true, curl);
}

function onShowResource(inputname,spanname) {
	var url = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp";
	var curl = "javaScript:openhrm(";
	disModalDialogRtnM(url, inputname, spanname, true, curl, true);
}

function doSave(obj) {
	obj.disabled=true;
	$G("frmAdd").submit();    
}
//-->
</script>