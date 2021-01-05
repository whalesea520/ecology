<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<% if(!HrmUserVarify.checkUserRight("ShowColumn:Operate",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<%!
private boolean hasChild(int id)throws Exception{
	boolean hasChild = false;
	weaver.conn.RecordSet rs = new RecordSet();
	rs.executeSql(" select count(*) from HrmListValidate where parentid = "+id);
	if(rs.next()){
		if(rs.getInt(1)>0)hasChild=true;
	}
	
	return hasChild;
}
private String getChildCheckbox(int parentid)throws Exception
{
	weaver.conn.RecordSet rs = new RecordSet();
	String htmlResult = "<table>";
	int index = 0;
	rs.executeSql("select id,name,validate_n from HrmListValidate where parentid ="+parentid+" order by tab_index asc");
  while(rs.next()){
  	index++;
  	int id=rs.getInt("id");
    if(id==10)continue;
		String	name=rs.getString("name");
		int	validate=rs.getInt("validate_n");
		htmlResult +="<tr><td style='border-bottom:0px;padding: 0px 0px 0px 0px'><span style=\"width:150px;height:20px;display:inline-block;margin-top:10px;\"><input class=inputstyle type=\"checkbox\" name=\"isValidate\" onclick=\"jsChkChild1(this)\" value=\""+id+"\"";
		if(validate==1)htmlResult+="checked";
		htmlResult+=">"+name+"</span>";
    htmlResult+="</td>";
    if(hasChild(id)){
    	htmlResult+="<td style='border-bottom:0px;padding: 0px 0px 0px 0px'>"+getChildCheckbox1(id)+"</td>";
    }
    htmlResult+="</tr>";
  }
  htmlResult += "</table>";
	return htmlResult;
}

private String getChildCheckbox1(int parentid)throws Exception
{
	weaver.conn.RecordSet rs = new RecordSet();
	String htmlResult = "";
	int index = 0;
	rs.executeSql("select id,name,validate_n from HrmListValidate where parentid ="+parentid+" order by tab_index asc");
  while(rs.next()){
  	index++;
  	int id=rs.getInt("id");
    if(id==10)continue;
		String	name=rs.getString("name");
		int	validate=rs.getInt("validate_n");
		htmlResult +="<span style=\"width:150px;height:20px;display:inline-block;margin-top:10px;\"><input class=inputstyle type=\"checkbox\" name=\"isValidate\" onclick=\"jsChk(this)\" value=\""+id+"\"";
		if(validate==1)htmlResult+="checked";
		htmlResult+=">"+name+"</span>";
    htmlResult+="<br>";
  }
	return htmlResult;
}

%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script type="text/javascript">
function onBtnSearchClick(){
	//jQuery("#searchfrm").submit();
}
</script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(6002,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="submitData();" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"></input>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id=weaver name=frmMain action="HrmValidateOperation.jsp" method=post>
<input class=inputstyle type=hidden name=method value="save">
<table class=ListStyle  border=0 valign="top" cellspacing=1 style="position:fixed;z-index:99!important;">
<colgroup>
	<col width="25%">
	<col width="25%">
	<col width="50%">
</colgroup>
<tr class=HeaderForXtalbe>
		<th><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></th>
		<th><input name="chkAll" type="checkbox" onclick="jsChkAll(this)"><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%></th>
		<th><%=SystemEnv.getHtmlLabelName(32749,user.getLanguage())%></th>
</tr>
</TABLE>
<TABLE id='tabContiner' CLASS="ListStyle" valign="top" cellspacing=1 border="0" style="z-index:1!important;">
<colgroup>
	<col width="25%">
	<col width="25%">
	<col width="50%">
</colgroup>
<tbody>
<tr class="DataLight"><td colspan="3">&nbsp;</td></tr>
		<%
    rs.executeSql(" select id,name,validate_n from HrmListValidate " +
									" where tab_type =1 and parentid is null " +
									" and id not in (10,25,4,5,6,7,8,9,1,2) " + 
									" order by tab_index asc ");
    while(rs.next()){
    	int id=rs.getInt("id");
			String	name=rs.getString("name");
			int	validate=rs.getInt("validate_n");
%>
<tr class="DataLight">
  	<td><%=name%></td>
    <td>
    	<%if(id<4){ %>
    	<input class=inputstyle type="checkbox" checked="checked" disabled="disabled">
    	<input class=inputstyle type="hidden" name="isValidate" value="<%=id%>">
    	<%}else{ %>
      <input class=inputstyle type="checkbox" name="isValidate" value="<%=id%>" onclick="jsChkChild(this)" <%=validate==1?"checked":""%>>
      <%} %>
    </td>
    <td>
	    <%
	    	out.println(getChildCheckbox(id));
	    %>
	  </td>
    </tr>
  <%}%> 
  </tbody>
  </TABLE> 
 </form>
<script language=javascript>  
function submitData() {
 frmMain.submit();
}

function jsChkAll(obj) {
	jQuery("#tabContiner").find("input[name=isValidate]").each(function(){
		changeCheckboxStatus(this,obj.checked);
	});
}

function jsChkChild(obj){
	jQuery(obj).parent().parent().next().find("input[name='isValidate']").each(function(){
		changeCheckboxStatus(this,obj.checked);
	});
}


function jsChkChild1(obj){
	jQuery(obj).parent().parent().parent().next().find("input[name='isValidate']").each(function(){
		changeCheckboxStatus(this,obj.checked);
	});
}

jQuery(document).ready(function(){

/*
	jQuery("#tableShow").find("[name='childDiv']").each(function(){
		var allcheckObj = jQuery(this).parent().parent().find("input[name='checkall']");
		var allChecked = true;
		jQuery(this).find("input[name='isValidate']").each(function(){
			if(!this.checked){
				allChecked = false;
				return false;
			}
		});
		if(allChecked)
			allcheckObj.siblings("span.jNiceCheckbox").addClass("jNiceChecked");
		else
			allcheckObj.siblings("span.jNiceCheckbox").removeClass("jNiceChecked");
			
		allcheckObj.attr("checked",allChecked);
	});*/
});
</script>
</BODY>
</HTML>
