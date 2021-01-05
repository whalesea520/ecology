
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
int fieldid=Util.getIntValue(request.getParameter("index"));
String titlename = SystemEnv.getHtmlLabelName(32714,user.getLanguage());
RecordSet.executeSql("select max(selectvalue) maxselectvalue from crm_selectitem where fieldid='"+fieldid+"'");
int maxselectvalue = 0;
if(RecordSet.next()){
	maxselectvalue = Util.getIntValue(RecordSet.getString("maxselectvalue"),0);
}
	
RecordSet.executeSql("select fieldid,selectvalue,selectname from crm_selectitem where fieldid='"+fieldid+"' order by fieldorder");
int rownum = RecordSet.getCounts();
%>
<%!
public String checkSelect(int fieldid,String value){
	String rstr = "";
	RecordSet rs = new RecordSet();
	String sql = "select fieldname,usetable from CRM_CustomerDefinField where id='"+fieldid+"'";
	rs.executeSql(sql);
	if(rs.next()){
		String fieldname = rs.getString("fieldname");
		String usetable = rs.getString("usetable");
		sql = "select id from "+usetable+" where "+fieldname+" = '"+value+"'";
		rs.executeSql(sql);
		if(rs.next()){
			rstr = "display:none";
		}
	}
	return rstr;
}
%>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=stylesheet>
<link href="/js/ecology8/jNice/jNice/jNice_wev8.css" type=text/css rel=stylesheet>
<link href="/js/ecology8/selectbox/css/jquery.selectbox_wev8.css" type=text/css rel=stylesheet>
<script language=javascript src="/js/ecology8/selectbox/js/jquery.selectbox-0.2_wev8.js"></script>
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=stylesheet>
<script language=javascript src="/js/checkbox/jquery.tzRadio_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/skins/default/wui_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<script language=javascript src="/js/checkbox/jquery.tzRadio_wev8.js"></script>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
</HEAD>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:jsOK();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="customer"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(32714,user.getLanguage()) %>"/>
</jsp:include>

<div class="zDialog_div_content" style="height: 198px;">
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td class="rightSearchSpan" style="text-align:right;">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>" class="e8_btn_top" onclick="jsOK(this);">
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
	<form name="weaver" action="CRM_FreeFieldOperation.jsp" method="post">
		<input type="hidden" name="method" value="changeSelectItemInfo">
		<input type="hidden" name="rownum" value="<%=rownum%>">
		<input type="hidden" name="fieldid" value="<%=fieldid%>">
		<input type="hidden" name="maxselectvalue" value="<%=maxselectvalue%>">
		<wea:layout>
			<wea:group context='<%=SystemEnv.getHtmlLabelName(32716,user.getLanguage())%>'>
				<wea:item type="groupHead">
					<input type="button" class="addbtn" style="cursor:pointer" title="<%=SystemEnv.getHtmlLabelName(15128, user.getLanguage())%>" onclick="addRow();">
					<input type="button" class="delbtn" style="cursor:pointer" title="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>" onclick="javascript:if(isdel()){deleteRow()};">
				</wea:item>
				<wea:item attributes="{'colspan':'full'}">
					<TABLE class=ListStyle cellspacing=1  cols=2 id="oTable">
				 		<colgroup>
							<col width="10%">
							<col width="90%">
						</colgroup>
						<tr class=header>
				        	<td class=Field><input type="checkbox" name="node_total" onclick="setCheckState(this)"/></td>
				    	   	<td class=Field><%=SystemEnv.getHtmlLabelName(32715,user.getLanguage())%></td>
				    	</tr>
				    	
				    	<%
				    		int i=0;
							while (RecordSet.next()){
							String value = RecordSet.getString("selectvalue");
							String name = RecordSet.getString("selectname");
							String display = checkSelect(fieldid,value);
							%>
				    		<tr>
								<td>
									<input type='checkbox' name='check_node' value='<%=value%>' style="<%=display%>">
									<input type='hidden' name='canDeleteP_<%=i%>' value='1' >
									<input type='hidden' name='itemNameId_<%=i%>' value='<%=value%>' >
								</td>
								<td >
									<input type=text class='InputStyle' item="<%=value%>" name="itemName_<%=i%>" size=20 value="<%=name%>" onchange='checkinput("itemName_<%=i%>","itemName_<%=i%>span")'><span id="itemName_<%=i%>span"></span>	
								</td>
							</tr>
				    	<%i++;}%>
				 	</TABLE>
				</wea:item>
			</wea:group>
		</wea:layout>
	</form>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parentWin.closeDialog();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<script>
var parentWin = parent.getParentWindow(window);
var rowindex = <%=rownum%>;
var vl = <%=maxselectvalue%>;
function addRow(){
	vl = vl+1;
	ncol = jQuery(oTable).attr("cols");
	oRow = oTable.insertRow(-1);
	oRow.setAttribute("class","DataLight");
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1); 
		oCell.style.height=24;
		oCell.style.background= "#efefef";
		switch(j) {
            case 0:
                oCell.style.width=10;
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_node' value='0' ><input type='hidden' name='canDeleteP_"+rowindex+"' value='0' ><input type='hidden' name='itemNameId_"+rowindex+"' value='"+vl+"' >"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<input type=text class=\"InputStyle\" item="+rowindex+" name=\"itemName_"+rowindex+"\" size=20 value=\"\" onchange=\"checkinput('itemName_"+rowindex+"','itemName_"+rowindex+"span')\"><span id=\"itemName_"+rowindex+"span\"><img src=\"/images/BacoError_wev8.gif\" align=\"absMiddle\"></span>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
		}
	}
	rowindex = rowindex*1 +1;
	weaver.rownum.value=rowindex;
	jQuery('body').jNice(); 
}

function deleteRow(){
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0;
    for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node')
			rowsum1 += 1;
	} 
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node'){
			if(document.forms[0].elements[i].checked==true) {
				oTable.deleteRow(rowsum1);	
			}
			rowsum1 -=1;
		}	
	}	
}
function jsOK(obj){
	var parastr = "name";
	for(i=0; i<document.all("rownum").value ; i++) {
		parastr += ",itemName_"+i ;
	}
	
	if(check_form(document.weaver,parastr)){
		obj.disabled = true;
		document.weaver.submit();
	}
}
function setCheckState(obj){
	jQuery("input[name='check_node']").each(function(){
		changeCheckboxStatus(this,obj.checked);
	});
	
}
</script>
</BODY>
</HTML>