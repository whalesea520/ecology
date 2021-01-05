<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="FormManager" class="weaver.workflow.form.FormManager" scope="session"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="FormFieldMainManager" class="weaver.workflow.form.FormFieldMainManager" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<%FormFieldMainManager.resetParameter();%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>
</head>

<%	int userid=user.getUID();
	String username=Util.toScreen(ResourceComInfo.getResourcename(userid+""),user.getLanguage());
	

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(6062,user.getLanguage()) + " : " + "<a href='/hrm/resource/HrmResource.jsp?id="+userid+"'>"+username+"</a>";
String needfav ="1";
String needhelp ="";
String sql = "";
%>
<script language="JavaScript">
 
<!--Begin
// Add the selected items in the parent by calling method of parent
function addSelectedItemsToParent() {
self.opener.addToParentList(window.document.forms[0].destList);
window.close();
}
// Fill the selcted item list with the items already present in parent.
function fillInitialDestList() {
	var destList = window.document.forms[0].destList; 
	var srcList = self.opener.window.document.forms[0].parentList;
	for (var count = destList.options.length - 1; count >= 0; count--) {
		destList.options[count] = null;
	}
	if(srcList != null){
		for(var i = 0; i < srcList.options.length; i++) { 
			if (srcList.options[i] != null)
				destList.options[i] = new Option(srcList.options[i].text,srcList.options[i].value);
   		}
   	}
}
// Add the selected items from the source to destination list
function addSrcToDestList() {
	destList = window.document.forms[0].destList;
	srcList = window.document.forms[0].srcList; 
	var len = destList.length;
	for(var i = 0; i < srcList.length; i++) {
		if ((srcList.options[i] != null) && (srcList.options[i].selected)) {
			//Check if this value already exist in the destList or not
			//if not then add it otherwise do not add it.
			var found = false;
			for(var count = 0; count < len; count++) {
				if (destList.options[count] != null) {
					if (srcList.options[i].text == destList.options[count].text) {
						found = true;
						break;
			  		}
  				 }
			}
			if (found != true) {
				destList.options[len] = new Option(srcList.options[i].text,srcList.options[i].value); 
				len++;
	        	}
     		}
  	 }
}
// Deletes from the destination list.
function deleteFromDestList() {
var destList  = window.document.forms[0].destList;
var len = destList.options.length;
for(var i = (len-1); i >= 0; i--) {
if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
destList.options[i] = null;
      }
   }
}
// Up selections from the destination list.
function upFromDestList() {
var destList  = window.document.forms[0].destList;
var len = destList.options.length;
for(var i = 0; i <= (len-1); i++) {
if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
	if(i>0 && destList.options[i-1] != null){
		fromtext = destList.options[i-1].text;
		fromvalue = destList.options[i-1].value;
		totext = destList.options[i].text;
		tovalue = destList.options[i].value;
		destList.options[i-1] = new Option(totext,tovalue);
		destList.options[i-1].selected = true;
		destList.options[i] = new Option(fromtext,fromvalue);		
	}
      }
   }
}
// Down selections from the destination list.
function downFromDestList() {
var destList  = window.document.forms[0].destList;
var len = destList.options.length;
for(var i = (len-1); i >= 0; i--) {
if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
	if(i<(len-1) && destList.options[i+1] != null){
		fromtext = destList.options[i+1].text;
		fromvalue = destList.options[i+1].value;
		totext = destList.options[i].text;
		tovalue = destList.options[i].value;
		destList.options[i+1] = new Option(totext,tovalue);
		destList.options[i+1].selected = true;
		destList.options[i] = new Option(fromtext,fromvalue);		
	}
      }
   }
}
function selectall(){
	tmpstr="";
	destinationList = window.document.forms[0].destList;
	for(var count = 0; count <= destinationList.options.length - 1; count++) {
		tmpstr+=destinationList.options[count].value;
		tmpstr+=",";
	}
	window.document.forms[0].formfields.value=tmpstr;
//	alert(tmpstr);
	window.document.forms[0].submit();
}
// End -->
</SCRIPT>

<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:selectall(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form name="form1" method=post action="DesignHomePage_operation.jsp">
<input type="hidden" value="formfield" name="src">
<input type="hidden" value="" name="formfields">
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
			<table class=ListStyle cellspacing="1">
			  <COLGROUP>
			   <COL width="45%">
			   <COL width="10%">
			   <COL width="45%">
			  <tr class=header>
				<td align=center class=field><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%></td>
				<td align=center class=field><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></td>
				<td align=center class=field><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%></td>
				<td>&nbsp;</td>
			  </tr>
			  <tr>
				<td align=center>
				<select size=15 name="destList" multiple style="width:100%" class="InputStyle">
			<%
				sql = "select * from HomePageDesign t1,PersonalHomePageDesign t2 where t2.homepageid = t1.id and t2.hrmid = " + userid + " and t2.ischecked = 0 order by t2.orderid";
				RecordSet.executeSql(sql);
				while(RecordSet.next()){%>
			<%if( !( ((software.equals("HRM") || software.equals("KM")) && (RecordSet.getInt("name")==6059 || RecordSet.getInt("name")==1211 || RecordSet.getInt("name")==6060 || RecordSet.getInt("name")==6061))  ) ){%>
				<option value="<%=RecordSet.getInt("id")%>"><%=SystemEnv.getHtmlLabelName(RecordSet.getInt("name"),user.getLanguage())%></option>
				<%}%>
			<%}%>
				</select>
				</td>
				<td align=center>
					<img src="/images/arrow_u_wev8.gif" title="<%=SystemEnv.getHtmlLabelName(15084,user.getLanguage())%>" onclick="javascript:upFromDestList();">
				<br><br>
					<img src="/images/arrow_l_wev8.gif" title="<%=SystemEnv.getHtmlLabelName(456,user.getLanguage())%>" onClick="javascript:addSrcToDestList()">
				<br><br>
				<img src="/images/arrow_r_wev8.gif"  title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onclick="javascript:deleteFromDestList();">
				<br><br>
				<img src="/images/arrow_d_wev8.gif"   title="<%=SystemEnv.getHtmlLabelName(15085,user.getLanguage())%>" onclick="javascript:downFromDestList();">
				</td>
				<td align=center>
				<select size="15" name="srcList" multiple style="width:100%" class="InputStyle">
				<%
				sql = "select * from HomePageDesign t1,PersonalHomePageDesign t2 where t2.homepageid = t1.id and t2.hrmid = " + userid + " order by t1.id";
				RecordSet.executeSql(sql);
				while(RecordSet.next()){%>
			<%if( !( ((software.equals("HRM") || software.equals("KM")) && (RecordSet.getInt("name")==6059 || RecordSet.getInt("name")==1211 || RecordSet.getInt("name")==6060 || RecordSet.getInt("name")==6061))  ) ){%>
				<option value="<%=RecordSet.getInt("id")%>"><%=SystemEnv.getHtmlLabelName(RecordSet.getInt("name"),user.getLanguage())%></option>
				<%}%>
			<%}%>
				</select>
				</td>
				<td>&nbsp;</td> 
			  </tr>
			</table>
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

</form>
</center>
</body>
</html>