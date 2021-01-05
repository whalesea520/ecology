
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.docs.category.CategoryUtil" %>
<%@ page import="weaver.docs.category.security.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="ReportShareInfo" class="weaver.formmode.report.ReportShareInfo" scope="page" />

<%
if(!HrmUserVarify.checkUserRight("ModeSetting:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

int reportid = Util.getIntValue(request.getParameter("id"),0);
int righttype = Util.getIntValue(request.getParameter("righttype"),0);

ReportShareInfo.setUser(user);
ReportShareInfo.setReportid(reportid);

Map allRightMap = ReportShareInfo.getAllRightList();			//所有权限
List addRightList = ReportShareInfo.getAddRightList();

%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>
<BODY>
<%
String imagefilename = "/images/hdCRMAccount_wev8.gif";
//报表共享权限:添加
String titlename = SystemEnv.getHtmlLabelName(30540,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(611,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_top} " ;//保存
RCMenuHeight += RCMenuHeightStep ;//返回
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:location.href='/formmode/setup/reportinfoBase.jsp?id="+reportid+"',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
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
		<tr>
		<td valign="top">
<FORM id=weaver name=weaver action=reportinfoShareAction.jsp method=post onsubmit='return check_by_permissiontype()'>
  <input type="hidden" name="method" value="addNew">
  <input type="hidden" name="reportid" value="<%=reportid%>">
  <input type="hidden" name="righttype" value="<%=righttype%>">
  <input type=hidden name=mainids >
  <TABLE class=ViewForm>
    <COLGROUP>
		<COL width="20%">
  		<COL width="80%">
    </COLGROUP>
    <TBODY>
     <TR><!-- 共享类型 -->
       <TD><%=SystemEnv.getHtmlLabelName(18495,user.getLanguage())%></TD>   
       <TD class="field">
         <SELECT class=InputStyle  name=sharetype onChange="onChangeSharetype()" >  
           <option value="1" selected><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></option> <!-- 人员 -->
           <option value="2"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option><!-- 分部 -->
           <option value="3"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option><!-- 部门 -->
           <option value="4"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option><!-- 角色 -->
           <option value="5"><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></option><!-- 所有人 -->
         </SELECT>
         <span id=showspan >
	         <INPUT type=hidden name="relatedid"  id="relatedid" value="">
	         <BUTTON type="button" class=Browser id="btnRelated" onClick="onShowRelated(relatedid,showrelatedname)" name="btnRelated"></BUTTON>
	         <span id="showrelatedname" name="showrelatedname"><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>
         </span>
       </TD>
     </TR>
     <TR style="height: 1px"> <TD class=Line colSpan=2></TD></TR>
     <!-- 角色级别 -->
     <TR id=rolelevel_tr name=id=rolelevel_tr style="display:none">
       <td><%=SystemEnv.getHtmlLabelName(3005,user.getLanguage())%></td>
       <td class="field">
           <SELECT  name=rolelevel>
	           <option value="0" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%><!-- 部门 -->
	           <option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%><!-- 分门 -->
	           <option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%><!-- 总部 -->
	       </SELECT>
       </td>
     </TR>
     <TR id=rolelevel_line name=rolelevel_line style="display:none;height: 1px">
       <TD class=Line colSpan=2  ></TD>
     </TR>
     <!-- 安全级别 -->
     <TR  id=showlevel_tr name=showlevel_tr style="display:none;height: 1px">
       <TD><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></TD>
       <TD class="field">
       	 <INPUT type=text name=showlevel class=InputStyle size=6 value="10" onchange='checkinput("showlevel","showlevelimage")' onKeyPress="ItemCount_KeyPress()">
         <span id=showlevelimage></span>
       </TD>
     </TR>
     <TR id=showlevel_line name=showlevel_line style="display:none;height: 1px">
        <TD class=Line colSpan=2 ></TD>
     </TR>
     
     <TR style="display: none;">
       <TD  colspan=2>
         <TABLE  width="100%">
           <TR>
     		<TD width="*"></TD>
        	<TD width="300px">
        	<!-- 添加共享 --><button class="btnNew" type="button" onClick="addValue()" title="<%=SystemEnv.getHtmlLabelName(18645,user.getLanguage())%>" accesskey="a"><u>A</u>&nbsp;<%=SystemEnv.getHtmlLabelName(18645,user.getLanguage())%></button>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        	<!-- 删除共享 --><button class="btnDelete" type="button" onClick="removeValue()" title="<%=SystemEnv.getHtmlLabelName(18646,user.getLanguage())%>" onClick="removeValue()" accesskey="d"><u>D</u>&nbsp;<%=SystemEnv.getHtmlLabelName(18646,user.getLanguage())%></button></TD>
           </TR>
         </TABLE>
       </TD>
     </TR>
     <TR style="height: 1px"><TD class=Line colSpan=2></TD></TR>
     <tr style="display: none;">
       <td colspan=2>
         <table class="listStyle" id="oTable" name="oTable">
             <colgroup>
             <col width="5%">
             <col width="25%">
             <col width="30%">
             <col width="20%">
             <col width="20%">
             </colgroup>
             <tr class="header">
                 <th><input type="checkbox" name="chkAll" onClick="chkAllClickNew(this)"></th>
                 <th><%=SystemEnv.getHtmlLabelName(18495,user.getLanguage())%></th><!-- 共享类型 -->
                 <th><%=SystemEnv.getHtmlLabelName(119,user.getLanguage())%></th><!-- 共享 -->
                 <th><%=SystemEnv.getHtmlLabelName(3005,user.getLanguage())%></th><!-- 共享级别 -->
                 <th><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></th><!-- 安全级别 -->
             </tr>
             <tr class=Line style="height: 1px" ><td colspan=6 style="padding: 0px"></td></tr>
         </table>
       </td>
  	  </tr>
    </TBODY>
  </TABLE>
  
  
  <TABLE id="listTab" class=ViewForm style="margin-top: 30px;">
					<TBODY>
						<TR>
							<TD vAlign=top>
						        <TABLE class=ViewForm >
									<COLGROUP>
										<col width="8%">
										<col width="35%">
										<col width="*">
									</COLGROUP>
									<TBODY>
							          	
										<TR class=Title>
							            	<th colspan=2 noWrap style="padding-left: 6px;">
							            		<input type="checkbox" name="chkPermissionAll0" onclick="chkAllClick(this,0)">
							            		<%=SystemEnv.getHtmlLabelName(26137,user.getLanguage())%></th><!-- 共享权限 -->
							    			<td align=right>&nbsp;
							    				<!--  
							    		  		<a href="reportinfoShareAdd.jsp?righttype=0&reportid=<%=reportid%>"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a>
							    		  		<a href="#" onclick="javaScript:doDelShare(0);"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>    
							    		  		--><!-- 删除 -->
							    		  		<button class="btnDelete" type="button" onClick="javaScript:doDelShare(0);" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"  accesskey="d"><u>D</u>&nbsp;<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></button>
							            	</td>
							          	</TR>
							          	<TR style="height: 1px!important;"><TD class=Line1 colSpan=3></TD></TR>
							          	<%
								            Map datamap = null;
								            for(int i=0 ;i < addRightList.size();i++){
								          	  datamap = (Map)addRightList.get(i);
								          	  String rightid = (String)datamap.get("rightId");
								          	  String sharetypetext = (String)datamap.get("sharetypetext");
								          	  String detailText = (String)datamap.get("detailText");
							          	%>
							          	<tr>
							            	<td><input type="checkbox" name="rightid0" id="rightid0" value="<%=rightid %>"></td>
							            	<td class="field"><%=sharetypetext %></td>
							            	<td class="field"><%=detailText%></td>
							          	</tr>
							          	<TR style="height: 1px"> <TD class=Line colSpan=3></TD></TR>
							          	<%
							          		}
							          	%>
						          	</TBODY>
								</TABLE>
						     </TD>
						</TR>
					</TBODY>
				</TABLE>
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

<script language=javascript>
function onChangeSharetype(){
	var thisvalue=$GetEle("sharetype").value;	
    var strAlert= ""
	if(thisvalue==1 || thisvalue==2 || thisvalue==3 || thisvalue==4){//需要浏览框
		$GetEle("showspan").style.display='';	//浏览框
		$GetEle("relatedid").value="";
		$GetEle("showrelatedname").innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	}else{
		$GetEle("showspan").style.display='none';	//不需要浏览框
	}
	if(thisvalue != 4){
		$GetEle("rolelevel_tr").style.display='none';	//角色级别
		$GetEle("rolelevel_line").style.display='none';	
	}else{
		$GetEle("rolelevel_tr").style.display='';	//需要角色级别
		$GetEle("rolelevel_line").style.display='';	
	}
	if(thisvalue == 1){//人员不需要安全级别
		$GetEle("showlevel_tr").style.display='none';	//安全级别
		$GetEle("showlevel_line").style.display='none';
	}else{
		$GetEle("showlevel_tr").style.display='';	//安全级别
		$GetEle("showlevel_line").style.display='';
	}
}


function onShowRelated(inputname,spanname){
	var sharetype = $G("sharetype").value;
	var datas = "";
	if(sharetype == '1'){
		datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+inputname.value);
	}else if(sharetype == '2'){
		datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="+inputname.value+"&selectedDepartmentIds="+inputname.value);
	}else if(sharetype == '3'){
		datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="+inputname.value);
	}else if(sharetype == '4'){
		datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp");
	}
	if (datas != undefined && datas != null) {
		var ids = "";
		var names = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
		if(datas.id != ''){
			if(sharetype != '4'){
				ids = datas.id.substring(1);
				names = datas.name.substring(1);
			}else{
				ids = datas.id;
				names = datas.name;
			}
			inputname.value = ids;
			spanname.innerHTML = names;
		}else{
			inputname.value = ids;
			spanname.innerHTML = names;
		}
	}
}

function checkFieldValue(ids){
	var idsArr = ids.split(",");
	for(var i=0;i<idsArr.length;i++){
		var obj = document.getElementById(idsArr[i]);
		if(obj&&obj.value==""){
			Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>",function(){displayAllmenu();});//必要信息不完整！
			return false;
		}
	}
	return true;
}

function addValue(){
	thisvalue=$GetEle("sharetype").value;
	var shareTypeValue = thisvalue;
	var shareTypeText = $GetEle("sharetype").options.item($GetEle("sharetype").selectedIndex).text;
	//人力资源(1),分部(2),部门(3),角色后的那个选项值不能为空(4)
	var relatedids="0";
	var relatedShareNames="";
	if (thisvalue==1||thisvalue==2||thisvalue==3||thisvalue==4) {
	    if(!checkFieldValue('relatedid')) {
	        return false;
	    }
	    if (thisvalue == 4){
	        if (!checkFieldValue('rolelevel'))
	            return false;
	    }
	    if(thisvalue != 1){
	    	if (!checkFieldValue('showlevel'))
	            return false;
	    }
	    relatedids = $GetEle("relatedid").value;
	    relatedShareNames= $GetEle("showrelatedname").innerHTML;
	}
	
	var showlevelValue="0";
	var showlevelText="";
	if (thisvalue!=1) {
	    showlevelValue = $GetEle("showlevel").value;
	    showlevelText = showlevelValue;
	}
	var rolelevelValue=0;
	var rolelevelText="";
	if (thisvalue==4){  //角色  0:部门   1:分部  2:总部
	   	rolelevelValue = $GetEle("rolelevel").value;
	    	rolelevelText = $GetEle("rolelevel").options.item($GetEle("rolelevel").selectedIndex).text;
	}
	
	var righttypeValue =  $GetEle("righttype").value;
	
	//共享类型 + 共享者ID +共享角色级别 +共享级别+共享权限+下载权限(TD12005)
	var totalValue=shareTypeValue+"_"+relatedids+"_"+rolelevelValue+"_"+showlevelValue+"_"+righttypeValue;
	var oRow = oTable.insertRow(-1);
	var oRowIndex = oRow.rowIndex;
	
	if (oRowIndex%2==0) oRow.className="dataLight";
	else oRow.className="dataDark";
	
	for (var i =1; i <=5; i++) {   //生成一行中的每一列
		oCell = oRow.insertCell(-1);
		var oDiv = document.createElement("div");
		if (i==1) oDiv.innerHTML="<input class='inputStyle' type='checkbox' name='chkShareDetail' value='"+totalValue+"'><input type='hidden' name='txtShareDetail' value='"+totalValue+"'>";
		else if (i==2) oDiv.innerHTML=shareTypeText;
		else  if (i==3) oDiv.innerHTML=relatedShareNames;
		else  if (i==4) oDiv.innerHTML=rolelevelText;
		else  if (i==5) {if (showlevelText=="0") showlevelText=""; oDiv.innerHTML=showlevelText;}
		oCell.appendChild(oDiv);
	}
	return true;
}

function removeValue(){
    var chks = document.getElementsByName("chkShareDetail");
    for (var i=chks.length-1;i>=0;i--){
        var chk = chks[i];
        if (chk.checked)
            oTable.deleteRow(chk.parentElement.parentElement.parentElement.rowIndex)
    }
}

function chkAllClickNew(obj){
    var chks = document.getElementsByName("chkShareDetail");
    for (var i=0;i<chks.length;i++){
        var chk = chks[i];
        chk.checked=obj.checked;
    }
}

function doSave(obj){
	if(addValue()){
	    obj.disabled=true;
	    weaver.submit();
	}
}

function chkAllClick(obj,types){
    var chks = document.getElementsByName("rightid"+types);
    for (var i=0;i<chks.length;i++){
        var chk = chks[i];
        chk.checked=obj.checked;
    }
    if(obj.checked){
	    $("#listTab .jNiceCheckbox").addClass("jNiceChecked");
    }else{
	    $("#listTab .jNiceCheckbox").removeClass("jNiceChecked");
    }
    
}

function doDelShare(type){
	var mainids = "";
    var chks = document.getElementsByName("rightid"+type);    
    for (var i=0;i<chks.length;i++){
        var chk = chks[i];
        if(chk.checked)
        	mainids = mainids + "," + chk.value;
    }
    if(mainids == '') {
    	Dialog.alert("<%=SystemEnv.getHtmlLabelName(22346,user.getLanguage())%>");//请选择要删除的信息
    	return;
    }else {
    	Dialog.confirm('<%=SystemEnv.getHtmlLabelName(82264,user.getLanguage())%>',function(){//警告：确认要删除吗？
	    	weaver.method.value="delete";
	    	weaver.mainids.value=mainids;
	    	weaver.submit();
    	});
	}
}

</script>

</BODY>
</HTML>
