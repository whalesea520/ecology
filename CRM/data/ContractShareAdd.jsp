
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetShare" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="ContractComInfo" class="weaver.crm.Maint.ContractComInfo" scope="page"/>
<jsp:useBean id="ContacterShareBase" class="weaver.crm.ContacterShareBase" scope="page"/>

<%
String customername = Util.null2String(request.getParameter("customername"));
String CustomerID = Util.null2String(request.getParameter("CustomerID"));
String contractId = Util.null2String(request.getParameter("contractId"));
String isfromtab  = Util.null2String(request.getParameter("isfromtab"),"false");

/*权限判断－－Begin*/

String useridcheck=""+user.getUID();
boolean canedit=false;
boolean canview=false;
boolean canedit_share=false;


int sharelevel = ContacterShareBase.getRightLevelForContacter(user.getUID()+"" , contractId);

if(sharelevel > 0 ){
	 canview=true;
	 if(sharelevel == 2){
		canedit=true;	
		canedit_share = true;
	 }else if (sharelevel == 3 || sharelevel == 4){
		canedit=true;
		canedit_share=true;
	 }
}

if (!canedit) response.sendRedirect("/notice/noright.jsp") ;
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(614,user.getLanguage())+SystemEnv.getHtmlLabelName(2112,user.getLanguage())+" - "+"<a href=/CRM/data/ContractView.jsp?id="+contractId+"&CustomerID="+CustomerID+">"+ContractComInfo.getContractname(contractId)+"</a>";
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%if(isfromtab.equals("false")){ %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="customer"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(19025,user.getLanguage()) %>"/>
</jsp:include>
<%} %>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="doSave()" type="button"  value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<div class="zDialog_div_content" style="height:494px;">
<FORM id=weaver name=weaver action="/CRM/data/ContractShareOperation.jsp" method=post >
<input type="hidden" name="method" value="add">
<input type="hidden" name="CustomerID" value="<%=CustomerID%>">
<input type="hidden" name="contractId" value="<%=contractId%>">
<input type="hidden" name="isfromtab" value="<%=isfromtab %>"/>

<input type="hidden" name="deleteIds" id="deleteIds">
<input type="hidden" name="rownum" id="rownum" value="0">  
<input type="hidden" name="relatedshareid" id="relatedshareid">
<input type="hidden" name="showrelatedsharename" id="showrelatedsharename">

<wea:layout>
	<wea:group context='<%= SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' >
		<wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
		<wea:item>
			<SELECT  class=InputStyle name=sharetype onchange="onChangeSharetype()" style="width: 120px;">
			  <option value="1"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>
			  <option value="2" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
			  <option value="5"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
			  <option value="3"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%>
			  <option value="4"><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%>
			</SELECT>
		</wea:item>
		
		<wea:item attributes="{'samePair':'showsharetype'}"><%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'showsharetype'}">
			<div id="resourceDiv">
				<brow:browser viewType="0" name="id_1" 
			         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp"
			         isSingle="false" hasBrowser="true"  hasInput="true" isMustInput='2'
			         completeUrl="/data.jsp" width="90%" ></brow:browser> 
			</div>
			
			<div id="departmentDiv">
				<brow:browser viewType="0" name="id_2" 
			         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp"
			         isSingle="false" hasBrowser="true"  hasInput="true" isMustInput='2'
			         completeUrl="/data.jsp?type=57" width="90%;" ></brow:browser> 
			</div>
			
			<div id="subcompanyDiv">
				<brow:browser viewType="0" name="id_5" 
			         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp"
			         isSingle="false" hasBrowser="true"  hasInput="true" isMustInput='2'
			         completeUrl="/data.jsp?type=164" width="90%" ></brow:browser> 
			</div>
			
			<div id="roleDiv">
				<brow:browser viewType="0" name="id_3" 
			         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/roles/MutiRolesBrowser.jsp"
			         isSingle="false" hasBrowser="true"  hasInput="true" isMustInput='2'
			         completeUrl="/data.jsp?type=65" width="90%" ></brow:browser> 
			</div>
		</wea:item>
		
		
		<wea:item attributes="{'samePair':'showrolelevel'}"><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'showrolelevel'}">
			<SELECT class=InputStyle  name=rolelevel id="showrolelevel" style="width: 120px;">
			  <option value="0" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
			  <option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
			  <option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
			</SELECT>
		</wea:item>
		
		<wea:item attributes="{'samePair':'showseclevelPair'}"><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'showseclevelPair'}">
			<wea:required id="seclevelimage" required="true">
				<INPUT class=InputStyle maxLength=3 size=5 name=seclevel id="showseclevel" onKeyPress="ItemCount_KeyPress()" 
					onBlur='checknumber("seclevel");checkinput("seclevel","seclevelimage")' value="10" style="width: 68px;">
			</wea:required>
			-
			<wea:required id="seclevelMaximage" required="true">
				<INPUT class=InputStyle maxLength=3 size=5 name=seclevelMax onKeyPress="ItemCount_KeyPress()" 
					onBlur='checknumber("seclevelMax");checkinput("seclevelMax","seclevelMaximage")' value="100" style="width: 68px;">
			</wea:required>
		 </wea:item>
		 
		 <wea:item><%=SystemEnv.getHtmlLabelName(119,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></wea:item>
		 <wea:item>
		 	<SELECT class=InputStyle  name=sharelevel style="width:120px;">
			  <option value="1"><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
			  <option value="2"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
			</SELECT>
		 </wea:item>
	</wea:group>
	
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1279,user.getLanguage())%>'>
		<wea:item type="groupHead">
			<input type="button" class="addbtn" style="cursor:pointer" title="<%=SystemEnv.getHtmlLabelName(15128, user.getLanguage())%>" onclick="addRow();">
			<input type="button" class="delbtn" style="cursor:pointer" title="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>" onclick="deleteRow()">
		</wea:item>
		<wea:item attributes="{'isTableList':'true'}">
			<TABLE class="ListStyle" cellpadding=1  cols=7 id="oTable" name="oTable">
				<colgroup>
					<col width="5%">
					<col width="20%">
					<col width="75%">
				</colgroup>
				<tr class=header>
					<td class=Field><input type="checkbox" name="node_total" onclick="setCheckState(this)"/></td>
					<td class=Field><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
					<td class=Field><%=SystemEnv.getHtmlLabelName(1279,user.getLanguage())%></td>
				</tr>
			<%
			RecordSetShare.execute(" select * from Contract_ShareInfo where relateditemid = "+contractId+"  order by sharetype asc , id desc");//and (isdefault is null or (isdefault=1 and sharelevel <> 2 and sharetype=1))
			if(RecordSetShare.getCounts()!=0){
				while(RecordSetShare.next()){%>
					<tr>
						<td>
							<%if(canedit_share){%>
							<input type='checkbox' name='check_node' value='<%=RecordSetShare.getString("id")%>'>
							<%}%>
						</td>
						
						<%if(RecordSetShare.getInt("sharetype")==1){%>
					          <td><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></td>
							  <td>
								<%=Util.toScreen(ResourceComInfo.getResourcename(RecordSetShare.getString("userid")),user.getLanguage())%>&nbsp;/&nbsp;<% if(RecordSetShare.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%><% if(RecordSetShare.getInt("sharelevel")>=2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
							  </td>
							  
						<%}else if(RecordSetShare.getInt("sharetype")==2)	{%>
					          <td><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
							  <td>
								<%=Util.toScreen(DepartmentComInfo.getDepartmentname(RecordSetShare.getString("departmentid")),user.getLanguage())%>&nbsp;/&nbsp;<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSetShare.getString("seclevel"),user.getLanguage())+" - "+Util.toScreen(RecordSetShare.getString("seclevelMax"),user.getLanguage())%>&nbsp;/&nbsp;<% if(RecordSetShare.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
								<% if(RecordSetShare.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
							  </td>
						<%}else if(RecordSetShare.getInt("sharetype")==3)	{%>
					          <td><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></td>
							  <td>
								<%=Util.toScreen(RolesComInfo.getRolesname(RecordSetShare.getString("roleid")),user.getLanguage())%>&nbsp;/&nbsp;<% if(RecordSetShare.getInt("rolelevel")==0)%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
								<% if(RecordSetShare.getInt("rolelevel")==1)%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
								<% if(RecordSetShare.getInt("rolelevel")==2)%><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>&nbsp;/&nbsp;<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSetShare.getString("seclevel"),user.getLanguage())+" - "+Util.toScreen(RecordSetShare.getString("seclevelMax"),user.getLanguage())%>&nbsp;/&nbsp;<% if(RecordSetShare.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
								<% if(RecordSetShare.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
							  </td>
						<%}else if(RecordSetShare.getInt("sharetype")==4)	{%>
					          <td><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%></td>
							  <td>
								<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSetShare.getString("seclevel"),user.getLanguage())+" - "+Util.toScreen(RecordSetShare.getString("seclevelMax"),user.getLanguage())%>&nbsp;/&nbsp;<% if(RecordSetShare.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
								<% if(RecordSetShare.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
							  </td>
						<%}else if(RecordSetShare.getInt("sharetype")==5)	{%>
					          <td><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></td>
							  <td>
								<%=Util.toScreen(SubCompanyComInfo.getSubCompanyname(RecordSetShare.getString("subcompanyid")),user.getLanguage())%>&nbsp;/&nbsp;<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSetShare.getString("seclevel"),user.getLanguage())+" - "+Util.toScreen(RecordSetShare.getString("seclevelMax"),user.getLanguage())%>&nbsp;/&nbsp;<% if(RecordSetShare.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
								<% if(RecordSetShare.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
							  </td>
						<%}%>
						</tr>
					<%}
				}%>
			</TABLE>	
		</wea:item>
	</wea:group>
</wea:layout>	
</FORM>
</div>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="closeWin()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 

<script language="JavaScript" src="/js/addRowBg_wev8.js"></script>
<script language=javascript>
var deleteIds = "";
function setCheckState(obj){
	var checkboxs = jQuery("input[name='check_node']").each(function(){
		changeCheckboxStatus(this,obj.checked);
 	});
}

function closeWin(){
	if("<%=isfromtab%>" == "true"){
		parent.closeDialog();
	}else{
		parent.getDialog(window).close();
	}
}

var dialog = parent.parent.getDialog(window); 

  jQuery(function(){
  	
  	hideEle("showrolelevel","true");
  	checkinput("seclevel","seclevelimage");
  	checkinput("seclevelMax","seclevelMaximage");
  	
  	jQuery("#resourceDiv").hide();
	jQuery("#subcompanyDiv").hide();
	jQuery("#roleDiv").hide();
  });
  	
  function onChangeSharetype(){
  	thisvalue=document.weaver.sharetype.value;
  	
	showEle('showseclevel',"true");
	showEle('showsharetype',"true");
	hideEle("showrolelevel","true");
	
	jQuery("#resourceDiv").hide();
	jQuery("#departmentDiv").hide();
	jQuery("#subcompanyDiv").hide();
	jQuery("#roleDiv").hide();
	
	
	if(thisvalue==1){
		hideEle('showseclevel','true');
		jQuery("#resourceDiv").show();
	}
	
	if(thisvalue==2){
 		jQuery("#departmentDiv").show();
	}

	if(thisvalue==3){
 		jQuery("#roleDiv").show();
		showEle("showrolelevel","true");
	}
	if(thisvalue==4){
		hideEle("showsharetype","true");
	}
	if(thisvalue==5){
 		jQuery("#subcompanyDiv").show();
	}
}

function checkValid(){
	thisvalue=document.weaver.sharetype.value;
	if(thisvalue==4){
		jQuery("#relatedshareid").val("");
		jQuery("#showrelatedsharename").val("");
	}else{
		jQuery("#relatedshareid").val(jQuery("#id_"+thisvalue).val());
		var sels = jQuery("#id_"+thisvalue+"span").find("a");
		
		var showrelatedsharename = "";
		for(var i= 0 ; i < sels.length; i++){
			showrelatedsharename += jQuery(sels[i]).html()+",";
		}
		showrelatedsharename = showrelatedsharename.substring(0,showrelatedsharename.length-1);
		jQuery("#showrelatedsharename").val(showrelatedsharename);
	}
	
	var checkinfo = "relatedshareid,seclevel,seclevelMax";
	if(thisvalue==1){//人力资源
		checkinfo = "relatedshareid";
	}
	if(thisvalue==4){//所有人
		checkinfo = "";
	}
	return check_form(weaver,checkinfo);
}


function addRow(){
    if(!checkValid()){
        return;
    }
    thisvalue=document.weaver.sharetype.value;
    if(thisvalue == 4){
    	addRowChild("","");
    }else{
    	var ids = jQuery("#relatedshareid").val().split(",");
    	var names = jQuery("#showrelatedsharename").val().split(",");
    	for(var i=0; i < ids.length; i++){
    		addRowChild(ids[i] , names[i]);
    	}
    }
}

var curindex=0;
function addRowChild(id ,name){
	rowColor = getRowBg();
    var oRow = oTable.insertRow(-1);
    var oCell = oRow.insertCell(-1);
    oCell.style.background= rowColor;
    var oDiv = document.createElement("div");
    var sHtml = "<input type='checkbox' name='check_node' value='0'>";
    oDiv.innerHTML = sHtml;
    oCell.appendChild(oDiv);
	jQuery("body").jNice();
	 
    oCell = oRow.insertCell(-1);
    oCell.style.background= rowColor;
    oDiv = document.createElement("div");
	sHtml = document.all("sharetype").options[document.all("sharetype").selectedIndex].text;
	sHtml += "<input type='hidden' name='sharetype_"+curindex+"' value='"+document.all("sharetype").value+"'>";
    oDiv.innerHTML = sHtml;
    oCell.appendChild(oDiv);
	
    oCell = oRow.insertCell(-1);
    oCell.style.background= rowColor;
    oDiv = document.createElement("div");
    sHtml = name;
    sHtml += "<input type='hidden' name='relatedshareid_"+curindex+"' value='"+id+"'>";
    if(document.all("sharetype").value == "3"){
        sHtml += "&nbsp;/&nbsp;"+document.all("rolelevel").options[document.all("rolelevel").selectedIndex].text;
    }
    sHtml += "<input type='hidden' name='rolelevel_"+curindex+"' value='"+document.all("rolelevel").value+"'>";

    if(document.all("sharetype").value!="1"){
        sHtml += "&nbsp;/&nbsp;<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:"+document.all("seclevel").value+" - "+document.all("seclevelMax").value;
    }
    sHtml += "<input type='hidden' name='seclevel_"+curindex+"' value='"+document.all("seclevel").value+"'>";
	sHtml += "<input type='hidden' name='seclevelMax_"+curindex+"' value='"+document.all("seclevelMax").value+"'>";
   	sHtml += "&nbsp;/&nbsp;"+document.all("sharelevel").options[document.all("sharelevel").selectedIndex].text;
    sHtml += "<input type='hidden' name='sharelevel_"+curindex+"' value='"+document.all("sharelevel").value+"'>";
	curindex++;
    oDiv.innerHTML = sHtml;
    oCell.appendChild(oDiv);
    

}

function deleteInfo(id, contractId , CustomerID){
	jQuery.post("/CRM/data/ContractShareOperation.jsp?method=delete",
		{"id":id,"contractId":contractId,"CustomerID":CustomerID},function(){
		location.reload();
	});
}

function doSave(){
	jQuery("#rownum").val(curindex);
	if(deleteIds != ""){
		jQuery("#deleteIds").val(deleteIds);
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(84351,user.getLanguage())%>",function(){
			jQuery.post("/CRM/data/ContractShareOperation.jsp?method=add",jQuery("form").serialize(),function(){
		   		location.reload();
		   	});
		});
	}else{
		jQuery.post("/CRM/data/ContractShareOperation.jsp?method=add",jQuery("form").serialize(),function(){
	   		location.reload();
	   	});
	}
}


function deleteRow(){
	if(jQuery("input[name='check_node']:checked").length == 0){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>!");
		return;
	}
	
	var selecteds = jQuery("input[name='check_node']:checked");
	for(var i=0 ; i< selecteds.length; i++){
		if(jQuery(selecteds[i]).val()!="0"){
			deleteIds += deleteIds ==""?jQuery(selecteds[i]).val():","+jQuery(selecteds[i]).val();
			jQuery(selecteds[i]).closest("tr").remove();
		}else{
			jQuery(selecteds[i]).closest("tr").remove();
		}
	}
	
}

</script>

</BODY>
</HTML>
