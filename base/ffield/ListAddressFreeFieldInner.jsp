
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<%@ page import="weaver.general.Util,
                 weaver.docs.docs.CustomFieldManager" %>
<%!
private boolean hasUsed(weaver.conn.RecordSet rs, String fieldname){
	boolean hasUsed = false;
	rs.execute("select count(*) from CRM_CustomerAddress  where "+fieldname+"<>'' and "+fieldname+" is not null ");
	if(rs.next()){
		if(rs.getInt(1)>0)hasUsed = true;	
	}
	return hasUsed;
}

%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
<script type="text/javascript">

function jsChkAll(obj){
	$("input[name='fieldChk']").each(function(){
		if(obj.checked)
		{
			jQuery(this).siblings("span.jNiceCheckbox").addClass("jNiceChecked");
		}
		else
		{
			jQuery(this).siblings("span.jNiceCheckbox").removeClass("jNiceChecked");
		}
		this.checked=obj.checked;
	}); 
}

function addrow(){
	var oRow;
	var oCell;
	var flchk = $("<input name=fieldChk  class=InputStyle type=checkbox value=''>");
	var fisuse = $("<input type=checkbox class=InputStyle name=chkisuse><input type=hidden name=isuse >");
	var fismand = $("<input type=checkbox name=chkismand ><input type=hidden name=ismand >");
	
	oRow = jQuery("#inputface")[0].insertRow(-1);
	oCell = oRow.insertCell(-1);
  oCell.style.borderBottom="silver 1pt solid";
	$(oCell).append(flchk);

	oCell = oRow.insertCell(-1);
  oCell.style.borderBottom="silver 1pt solid";
	oCell.innerHTML = jQuery("#flable").html();
	
	oCell = oRow.insertCell(-1);
  oCell.style.borderBottom="silver 1pt solid";
	oCell.innerHTML = jQuery("#fhtmltype").html();
	
	oCell = oRow.insertCell(-1);
  oCell.style.borderBottom="silver 1pt solid";
	oCell.innerHTML = jQuery("#ftype1").html() ;
	
	oCell = oRow.insertCell(-1);
  oCell.style.borderBottom="silver 1pt solid";
	oCell.innerHTML = jQuery("#ftype5").html() ;
	
	oCell = oRow.insertCell(-1);
  oCell.style.borderBottom="silver 1pt solid";
  $(oCell).append(fisuse);
	
	oCell = oRow.insertCell(-1);
  oCell.style.borderBottom="silver 1pt solid";
  $(oCell).append(fismand)
	
  oCell = oRow.insertCell(-1);
  oCell.style.borderBottom="silver 1pt solid";
	oCell.innerHTML = jQuery("#action").html() ;
	$(oRow).jNice(); 
}

function htmltypeChange(obj){
	var celltype = jQuery(obj).parents("tr")[0].cells[3];
	var celllenth = jQuery(obj).parents("tr")[0].cells[4];
	if(obj.selectedIndex == 0){
		celltype.innerHTML=jQuery("#ftype1").html() ;
		celllenth.innerHTML=jQuery("#ftype5").html() ;
	}else if(obj.selectedIndex == 2){
		celltype.innerHTML=jQuery("#ftype2").html() ;
		celllenth.innerHTML=jQuery("#ftype4").html() ;
	}else if(obj.selectedIndex == 4){
		celltype.innerHTML=jQuery("#fselectaction").html() ;
		celllenth.innerHTML=jQuery("#fselectitems").html() ;
	}else if(obj.selectedIndex == 5){
		celltype.innerHTML=jQuery("#ftype6").html() ;
		celllenth.innerHTML=jQuery("#ftype4").html() ;
	}
	else{
		celltype.innerHTML=jQuery("#ftype3").html() ;
		celllenth.innerHTML=jQuery("#ftype4").html() ;
	}
}

function typeChange(obj){
	if(obj.selectedIndex == 0){
		jQuery(obj).parents("tr")[0].cells[4].innerHTML=jQuery("#ftype5").html();
	}else{
		jQuery(obj).parents("tr")[0].cells[4].innerHTML=jQuery("#ftype4").html();
	}
}

function doDel(){
	var chkobj = $("input:checked[name='fieldChk']");
	if(chkobj.length<=0)
	{
		alert("<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>");
  	return false;
	}
	$("input:checked[name='fieldChk']").each(function(){$(this).parent().parent().parent().remove();});
  	weaver.submit();
}

function copyRow()
{
	var flchk = $("<input name=fieldChk class=InputStyle type=checkbox value=''>");
	var fisuse = $("<input type=checkbox class=InputStyle name=chkisuse>");
	var fismand = $("<input type=checkbox class=InputStyle name=chkismand >");
	if($("input:checked[name='fieldChk']").length<=0)
	{
		alert("<%=SystemEnv.getHtmlLabelName(31433,user.getLanguage())%>");
  		return false;
	}
	var chkObj = $("input:checked[name='fieldChk']").parent().parent().parent().clone();
	$(chkObj).find("input[name=fieldid]").val("");
	var fieldChkTD = $(chkObj).find("input[name='fieldChk']").parent().parent();
	$(fieldChkTD).empty().append(flchk);
	var chkisuseTD = $(chkObj).find("input[name='chkisuse']").parent().parent();
	$(chkisuseTD).each(function(){
		var fisuse = $("<input type=checkbox class=InputStyle name=chkisuse>");
		var ischecked = $(this).find(".jNiceCheckbox").hasClass("jNiceChecked");
		$(this).children("span").remove();
		if(ischecked)
			$(fisuse).attr("checked",true);
		$(this).append(fisuse);
	});
	var chkismandTD = $(chkObj).find("input[name='chkismand']").parent().parent();
	$(chkismandTD).each(function(){
		var fismand = $("<input type=checkbox class=InputStyle name=chkismand >");
		var ischecked = $(this).find(".jNiceCheckbox").hasClass("jNiceChecked");
		$(this).children("span").remove();
		if(ischecked)
			$(fismand).attr("checked",true);
		$(this).append(fismand);
		$(fismand).click(function(){
			alert($(this).attr("checked"));
		});
	});
	jQuery("#inputface").append($(chkObj));
	
	jQuery("#inputface").jNice();
}

function submitData()
{
	var chkisuses = document.getElementsByName("chkisuse");
	var chkismands = document.getElementsByName("chkismand");
	var chkffuses = document.getElementsByName("chkffuse");
	var isuses = document.getElementsByName("isuse");
	var ismands = document.getElementsByName("ismand");
	var ffuses = document.getElementsByName("ffuse");

	for(var i=0;i< chkisuses.length;i++)
	{
		if(chkisuses[i].checked)
			isuses[i].value=1;
		else
			isuses[i].value=0;
		
		if(chkismands[i].checked)
			ismands[i].value=1;
		else
			ismands[i].value=0;
	}
	
	for(var i=0;i< chkffuses.length;i++)
	{
		if(chkffuses[i].checked)
			ffuses[i].value=1;
		else
			ffuses[i].value=0;
	}
	
	if(checkform()){
		weaver.submit();
  	}
}

	function checkform()
	{
		
		var fieldlables = document.getElementsByName("fieldlable");
		var array = new Array();
		var idx = 0;
		for(var i=0;fieldlables!=null&&i<fieldlables.length;i++){
			if(fieldlables[i].value!="")array[idx++]=fieldlables[i].value;
		}
		
		var array=array.sort();
		for(var i=0;i<array.length;i++){
		 	if (array[i]==array[i+1]){
		  		alert("显示名重复,请重新输入");
		  		return false;
		 	}
		}
		return true;
	}
</script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(570,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(136,user.getLanguage());
String needfav ="1";
String needhelp ="";

boolean canedit = false;
canedit = HrmUserVarify.checkUserRight("CustomerAccountFreeFeildEdit:Edit", user);
String disableLable = "disabled";
if(canedit)disableLable="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0" >
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(611, user.getLanguage()) %>" class="e8_btn_top"  onclick="javascript:addrow();"/>&nbsp;&nbsp;
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(23777, user.getLanguage()) %>" class="e8_btn_top" onclick="javascript:doDel();"/>&nbsp;&nbsp;
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(77, user.getLanguage()) %>" class="e8_btn_top"  onclick="javascript:copyRow();"/>&nbsp;&nbsp;
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage()) %>" class="e8_btn_top" onclick="javascript:submitData();"/>&nbsp;&nbsp;
			
			<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table> 
<div style="DISPLAY: none" id="flchk">
<input name="fieldChk" tzCheckbox="true" class=InputStyle type="checkbox" value="">
</div>
<div style="DISPLAY: none" id="flable">
<input  class=InputStyle name="fieldlable" maxLength=30><input  type="hidden" name="fieldid" value="-1">
</div>
<div style="DISPLAY: none" id="fhtmltype">
	<select size="1" name="fieldhtmltype" onChange = "htmltypeChange(this)">
		<option value="1" selected><%=SystemEnv.getHtmlLabelName(688,user.getLanguage())%></option>
		<option value="2" ><%=SystemEnv.getHtmlLabelName(689,user.getLanguage())%></option>
		<option value="3" ><%=SystemEnv.getHtmlLabelName(695,user.getLanguage())%></option>
		<option value="4" ><%=SystemEnv.getHtmlLabelName(691,user.getLanguage())%></option>
		<option value="5" ><%=SystemEnv.getHtmlLabelName(690,user.getLanguage())%></option>
		<option value="6" ><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())%></option>
  </select>
</div>

<div style="DISPLAY: none" id="ftype1">
	<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>
	<select size=1 name=type onChange = "typeChange(this)">
		<option value="1" selected><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%></option>
		<option value="2"><%=SystemEnv.getHtmlLabelName(696,user.getLanguage())%></option>
		<option value="3"><%=SystemEnv.getHtmlLabelName(697,user.getLanguage())%></option>
	</select>
</div>

<div style="DISPLAY: none" id="ftype2">
	<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>
	<select size=1 name=type>
    <%while(BrowserComInfo.next()){
	   	 if(("226".equals(BrowserComInfo.getBrowserid()))||"227".equals(BrowserComInfo.getBrowserid())||"224".equals(BrowserComInfo.getBrowserid())||"225".equals(BrowserComInfo.getBrowserid())){
	        	 //屏蔽集成浏览按钮-zzl
			continue;
			}
    %>
		<option value="<%=BrowserComInfo.getBrowserid()%>" ><%=SystemEnv.getHtmlLabelName(Util.getIntValue(BrowserComInfo.getBrowserlabelid(),0),7)%></option>
    <%}%>
	</select>
</div>

<div style="DISPLAY: none" id="ftype3">
	<input name=type type=hidden value="0">&nbsp;
</div>

<div style="DISPLAY: none" id="ftype4">
	<input name=flength type=hidden  value="100">&nbsp;
</div>

<div style="DISPLAY: none" id="ftype5">
	<input  class=InputStyle name=flength type=text value="100" maxlength=4 style="width:50">
</div>

<div style="DISPLAY: none" id="ftype6">
	<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>
	<select size=1 name=type onChange = "typeChange(this)">
		<option value="1" selected><%=SystemEnv.getHtmlLabelName(20798,user.getLanguage())%></option>
		<option value="2"><%=SystemEnv.getHtmlLabelName(20001,user.getLanguage())%></option>
	</select>
</div>

<div style="DISPLAY: none" id="fisuse">
  	<input type=checkbox name=chkisuse>
    <input type=hidden name=isuse >
</div>

<div style="DISPLAY: none" id="fismand">
		<input type=checkbox name=chkismand >
    <input type=hidden name=ismand >
</div>

<div style="DISPLAY: none" id="fselectaction">
	<input name=type type=hidden  value="0">
	<BUTTON Class=Btn type=button accessKey=A onclick="addrow2(this)"><%=SystemEnv.getHtmlLabelName(18597,user.getLanguage())%></BUTTON><br>
  <BUTTON Class=Btn type=button accessKey=I onclick="importSel(this)"><%=SystemEnv.getHtmlLabelName(18596,user.getLanguage())%></BUTTON>
</div>
<div style="DISPLAY: none" id="fselectitems">
	<TABLE cellSpacing=0 cellPadding=1 width="100%" border=0 >
	<COLGROUP>
		<col width="40%">
		<col width="60%">
	</COLGROUP>
	</TABLE>
  <input name=selectitemid type=hidden value="--">
	<input name=selectitemvalue type=hidden >
  <input name=flength type=hidden  value="100">
</div>

<div style="DISPLAY: none" id="fselectitem">
	<input name=selectitemid type=hidden value="-1" >
	<input  class=InputStyle name=selectitemvalue type=text style="width:100">
</div>

<div style="DISPLAY: none" id="itemaction">
    <img src="/images/icon_ascend_wev8.gif" height="14" onclick="upitem(this)">
    <img src="/images/icon_descend_wev8.gif" height="14" onclick="downitem(this)">
	<img src="/images/delete_wev8.gif" height="14" onclick="delitem(this)">
</div>

<div style="DISPLAY: none" id="action">
  <input class=InputStyle  name="filedOrder"  type="text" value="" style="width: 40px">
</div>

<FORM id=weaver name="weaver" action="CustomerFreeFieldOperation.jsp" method=post >
<input type="hidden" name="whickField" value="c3"/>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">

<TABLE cellSpacing=0 cellPadding=1 width="100%" border=0 id="inputface" class=ListStyle>
  	<TR class=Header>
	  	<th width="2%"><input name="chkAll" type="checkbox" onclick="jsChkAll(this)"></th>
	  	<th width="20%"><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%></th>
	  	<th width="45%" colspan="3"><%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%></th>
	  	<th width="10%"><%=SystemEnv.getHtmlLabelName(31676,user.getLanguage())%></th>
	  	<th width="10%"><%=SystemEnv.getHtmlLabelName(18019,user.getLanguage())%></th>
	  	<th width="10%"><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></th>
	</tr> 
  	<%
  	//老字段信息
		RecordSet.executeSql("select * from Base_FreeField where tablename = 'c3'");
		RecordSet.first();
		if(RecordSet.getString(3).equals("1") || hasUsed(rs,"datefield1")){
	%>
<tr>
	<td style="border-bottom:silver 1pt solid"><input name="ffname" type="hidden" value="dff01">&nbsp;</td>
	<td style="border-bottom:silver 1pt solid"><input  class=InputStyle name="fflabel" value="<%=Util.toScreen(RecordSet.getString(2),user.getLanguage())%>" <%=disableLable%>></td>
	<td style="border-bottom:silver 1pt solid" colspan="3"><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>1</td>
	<td style="border-bottom:silver 1pt solid">
		<input type=checkbox name=chkffuse  <%=disableLable%> <%=RecordSet.getString(3).equals("1")?"checked":""%> >
    <input type=hidden name=ffuse  value="<%=RecordSet.getString(3).equals("1")?"1":"0" %>" ></td>
	<td style="border-bottom:silver 1pt solid">&nbsp;</td>
	<td style="border-bottom:silver 1pt solid">&nbsp;</td>
</tr>
<%}if(RecordSet.getString(5).equals("1") || hasUsed(rs,"datefield2")){ %>
<tr>
	<td style="border-bottom:silver 1pt solid"><input name="ffname" type="hidden" value="dff02">&nbsp;</td>
	<td style="border-bottom:silver 1pt solid"><input  class=InputStyle name="fflabel" value="<%=Util.toScreen(RecordSet.getString(4),user.getLanguage())%>" <%=disableLable%>></td>
  <td style="border-bottom:silver 1pt solid" colspan="3"><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>2</td>
  <td style="border-bottom:silver 1pt solid">
  	<input type=checkbox name=chkffuse  <%=disableLable%> <%=RecordSet.getString(5).equals("1")?"checked":""%> >
    <input type=hidden name=ffuse  value="<%=RecordSet.getString(5).equals("1")?"1":"0" %>" ></td>
	<td style="border-bottom:silver 1pt solid">&nbsp;</td>
	<td style="border-bottom:silver 1pt solid">&nbsp;</td>
</tr>
<%}if(RecordSet.getString(7).equals("1") || hasUsed(rs,"datefield3")){ %>
<tr>
	<td style="border-bottom:silver 1pt solid"><input name="ffname" type="hidden" value="dff03">&nbsp;</td>
	<td style="border-bottom:silver 1pt solid"><input  class=InputStyle name="fflabel" value="<%=Util.toScreen(RecordSet.getString(6),user.getLanguage())%>" <%=disableLable%>></td>
  <td style="border-bottom:silver 1pt solid" colspan="3"><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>3</td>
  <td style="border-bottom:silver 1pt solid">
    <input type=checkbox name=chkffuse  <%=disableLable%> <%=RecordSet.getString(7).equals("1")?"checked":""%> >
    <input type=hidden name=ffuse  value="<%=RecordSet.getString(7).equals("1")?"1":"0" %>" ></td>
	<td style="border-bottom:silver 1pt solid">&nbsp;</td>
	<td style="border-bottom:silver 1pt solid">&nbsp;</td>
</tr>
<%}if(RecordSet.getString(9).equals("1") || hasUsed(rs,"datefield4")){ %>
<tr>
	<td style="border-bottom:silver 1pt solid"><input name="ffname" type="hidden" value="dff04">&nbsp;</td>
	<td style="border-bottom:silver 1pt solid"><input  class=InputStyle name="fflabel" value="<%=Util.toScreen(RecordSet.getString(8),user.getLanguage())%>" <%=disableLable%>></td>
  <td style="border-bottom:silver 1pt solid" colspan="3"><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>4</td>
  <td style="border-bottom:silver 1pt solid">
  	<input type=checkbox name=chkffuse  <%=disableLable%> <%=RecordSet.getString(9).equals("1")?"checked":""%> >
    <input type=hidden name=ffuse  value="<%=RecordSet.getString(9).equals("1")?"1":"0" %>" ></td>
  <td style="border-bottom:silver 1pt solid">&nbsp;</td>
  <td style="border-bottom:silver 1pt solid">&nbsp;</td>
</tr>
<%}if(RecordSet.getString(11).equals("1") || hasUsed(rs,"datefield5")){ %>
<tr>
	<td style="border-bottom:silver 1pt solid"><input name="ffname" type="hidden" value="dff05">&nbsp;</td>
	<td style="border-bottom:silver 1pt solid"><input  class=InputStyle name="fflabel" value="<%=Util.toScreen(RecordSet.getString(10),user.getLanguage())%>" <%=disableLable%>></td>
  <td style="border-bottom:silver 1pt solid" colspan="3"><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>5</td>
  <td style="border-bottom:silver 1pt solid">
    <input type=checkbox name=chkffuse  <%=disableLable%> <%=RecordSet.getString(11).equals("1")?"checked":""%> >
    <input type=hidden name=ffuse  value="<%=RecordSet.getString(11).equals("1")?"1":"0" %>" ></td>
  <td style="border-bottom:silver 1pt solid">&nbsp;</td>
  <td style="border-bottom:silver 1pt solid">&nbsp;</td>
</tr>
<%}if(RecordSet.getString(13).equals("1") || hasUsed(rs,"numberfield1")){ %>
<tr>
	<td style="border-bottom:silver 1pt solid"><input name="ffname" type="hidden" value="nff01">&nbsp;</td>
	<td style="border-bottom:silver 1pt solid"><input  class=InputStyle name="fflabel" value="<%=Util.toScreen(RecordSet.getString(12),user.getLanguage())%>" <%=disableLable%>></td>
	<td style="border-bottom:silver 1pt solid" colspan="3"><%=SystemEnv.getHtmlLabelName(607,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>1</td>
	<td style="border-bottom:silver 1pt solid">
	 	<input type=checkbox name=chkffuse  <%=disableLable%> <%=RecordSet.getString(13).equals("1")?"checked":""%> >
    <input type=hidden name=ffuse  value="<%=RecordSet.getString(13).equals("1")?"1":"0" %>" ></td>
	<td style="border-bottom:silver 1pt solid">&nbsp;</td>
	<td style="border-bottom:silver 1pt solid">&nbsp;</td>
</tr>
<%}if(RecordSet.getString(15).equals("1") || hasUsed(rs,"numberfield2")){ %>
<tr>
	<td style="border-bottom:silver 1pt solid"><input name="ffname" type="hidden" value="nff02">&nbsp;</td>
	<td style="border-bottom:silver 1pt solid"><input  class=InputStyle name="fflabel" value="<%=Util.toScreen(RecordSet.getString(14),user.getLanguage())%>" <%=disableLable%>></td>
	<td style="border-bottom:silver 1pt solid" colspan="3"><%=SystemEnv.getHtmlLabelName(607,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>2</td>
	<td style="border-bottom:silver 1pt solid">
	  <input type=checkbox name=chkffuse  <%=disableLable%> <%=RecordSet.getString(15).equals("1")?"checked":""%> >
    <input type=hidden name=ffuse  value="<%=RecordSet.getString(15).equals("1")?"1":"0" %>" ></td>
	<td style="border-bottom:silver 1pt solid">&nbsp;</td>
	<td style="border-bottom:silver 1pt solid">&nbsp;</td>
</tr>
<%}if(RecordSet.getString(17).equals("1") || hasUsed(rs,"numberfield3")){ %>
<tr>
	<td style="border-bottom:silver 1pt solid"><input name="ffname" type="hidden" value="nff03">&nbsp;</td>
	<td style="border-bottom:silver 1pt solid"><input  class=InputStyle name="fflabel" value="<%=Util.toScreen(RecordSet.getString(16),user.getLanguage())%>" <%=disableLable%>></td>
	<td style="border-bottom:silver 1pt solid" colspan="3"><%=SystemEnv.getHtmlLabelName(607,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>3</td>
	<td style="border-bottom:silver 1pt solid">
	  <input type=checkbox name=chkffuse  <%=disableLable%> <%=RecordSet.getString(17).equals("1")?"checked":""%> >
    <input type=hidden name=ffuse  value="<%=RecordSet.getString(17).equals("1")?"1":"0" %>" ></td>
	<td style="border-bottom:silver 1pt solid">&nbsp;</td>
	<td style="border-bottom:silver 1pt solid">&nbsp;</td>
</tr>
<%}if(RecordSet.getString(19).equals("1") || hasUsed(rs,"numberfield4")){ %>
<tr>
	<td style="border-bottom:silver 1pt solid"><input name="ffname" type="hidden" value="nff04">&nbsp;</td>
	<td style="border-bottom:silver 1pt solid"><input  class=InputStyle name="fflabel" value="<%=Util.toScreen(RecordSet.getString(18),user.getLanguage())%>" <%=disableLable%>></td>
	<td style="border-bottom:silver 1pt solid" colspan="3"><%=SystemEnv.getHtmlLabelName(607,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>4</td>
	<td style="border-bottom:silver 1pt solid">
  	<input type=checkbox name=chkffuse  <%=disableLable%> <%=RecordSet.getString(19).equals("1")?"checked":""%> >
    <input type=hidden name=ffuse  value="<%=RecordSet.getString(19).equals("1")?"1":"0" %>" ></td>
	<td style="border-bottom:silver 1pt solid">&nbsp;</td>
	<td style="border-bottom:silver 1pt solid">&nbsp;</td>
</tr>
<%}if(RecordSet.getString(21).equals("1") || hasUsed(rs,"numberfield5")){ %>
<tr>
	<td style="border-bottom:silver 1pt solid"><input name="ffname" type="hidden" value="nff05">&nbsp;</td>
	<td style="border-bottom:silver 1pt solid"><input  class=InputStyle name="fflabel" value="<%=Util.toScreen(RecordSet.getString(20),user.getLanguage())%>" <%=disableLable%>></td>
	<td style="border-bottom:silver 1pt solid" colspan="3"><%=SystemEnv.getHtmlLabelName(607,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>5</td>
	<td style="border-bottom:silver 1pt solid">
  	<input type=checkbox name=chkffuse  <%=disableLable%> <%=RecordSet.getString(21).equals("1")?"checked":""%> >
    <input type=hidden name=ffuse  value="<%=RecordSet.getString(21).equals("1")?"1":"0" %>" ></td>
	<td style="border-bottom:silver 1pt solid">&nbsp;</td>
	<td style="border-bottom:silver 1pt solid">&nbsp;</td>
</tr>
<%}if(RecordSet.getString(23).equals("1") || hasUsed(rs,"textfield1")){ %>
<tr>
	<td style="border-bottom:silver 1pt solid"><input name="ffname" type="hidden" value="tff01">&nbsp;</td>
	<td style="border-bottom:silver 1pt solid"><input  class=InputStyle name="fflabel" value="<%=Util.toScreen(RecordSet.getString(22),user.getLanguage())%>" <%=disableLable%>></td>
	<td style="border-bottom:silver 1pt solid" colspan="3"><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>1</td>
	<td style="border-bottom:silver 1pt solid">
  	<input type=checkbox name=chkffuse  <%=disableLable%> <%=RecordSet.getString(23).equals("1")?"checked":""%> >
    <input type=hidden name=ffuse  value="<%=RecordSet.getString(23).equals("1")?"1":"0" %>" ></td>
	<td style="border-bottom:silver 1pt solid">&nbsp;</td>
	<td style="border-bottom:silver 1pt solid">&nbsp;</td>
</tr>
<%}if(RecordSet.getString(25).equals("1") || hasUsed(rs,"textfield2")){ %>
<tr>
	<td style="border-bottom:silver 1pt solid"><input name="ffname" type="hidden" value="tff02">&nbsp;</td>
	<td style="border-bottom:silver 1pt solid"><input  class=InputStyle name="fflabel" value="<%=Util.toScreen(RecordSet.getString(24),user.getLanguage())%>" <%=disableLable%>></td>
	<td style="border-bottom:silver 1pt solid" colspan="3"><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>2</td>
	<td style="border-bottom:silver 1pt solid">
  	<input type=checkbox name=chkffuse  <%=disableLable%> <%=RecordSet.getString(25).equals("1")?"checked":""%> >
    <input type=hidden name=ffuse  value="<%=RecordSet.getString(25).equals("1")?"1":"0" %>" ></td>
	<td style="border-bottom:silver 1pt solid">&nbsp;</td>
	<td style="border-bottom:silver 1pt solid">&nbsp;</td>
</tr>
<%}if(RecordSet.getString(27).equals("1") || hasUsed(rs,"textfield3")){ %>
<tr>
	<td style="border-bottom:silver 1pt solid"><input name="ffname" type="hidden" value="tff03">&nbsp;</td>
	<td style="border-bottom:silver 1pt solid"><input  class=InputStyle name="fflabel" value="<%=Util.toScreen(RecordSet.getString(26),user.getLanguage())%>" <%=disableLable%>></td>
	<td style="border-bottom:silver 1pt solid" colspan="3"><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>3</td>
	<td style="border-bottom:silver 1pt solid">
  	<input type=checkbox name=chkffuse  <%=disableLable%> <%=RecordSet.getString(27).equals("1")?"checked":""%> >
    <input type=hidden name=ffuse  value="<%=RecordSet.getString(27).equals("1")?"1":"0" %>" ></td>
	<td style="border-bottom:silver 1pt solid">&nbsp;</td>
	<td style="border-bottom:silver 1pt solid">&nbsp;</td>
</tr>
<%}if(RecordSet.getString(29).equals("1") || hasUsed(rs,"textfield4")){ %>
<tr>
	<td style="border-bottom:silver 1pt solid"><input name="ffname" type="hidden" value="tff04">&nbsp;</td>
  <td style="border-bottom:silver 1pt solid"><input  class=InputStyle name="fflabel" value="<%=Util.toScreen(RecordSet.getString(28),user.getLanguage())%>" <%=disableLable%>></td>
  <td style="border-bottom:silver 1pt solid" colspan="3"><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>4</td>
  <td style="border-bottom:silver 1pt solid">
  	<input type=checkbox name=chkffuse  <%=disableLable%> <%=RecordSet.getString(29).equals("1")?"checked":""%> >
    <input type=hidden name=ffuse  value="<%=RecordSet.getString(29).equals("1")?"1":"0" %>" ></td>
	<td style="border-bottom:silver 1pt solid">&nbsp;</td>
	<td style="border-bottom:silver 1pt solid">&nbsp;</td>
</tr>
<%}if(RecordSet.getString(31).equals("1") || hasUsed(rs,"textfield5")){ %>
<tr>
	<td style="border-bottom:silver 1pt solid"><input name="ffname" type="hidden" value="tff05">&nbsp;</td>
	<td style="border-bottom:silver 1pt solid"><input  class=InputStyle name="fflabel" value="<%=Util.toScreen(RecordSet.getString(30),user.getLanguage())%>" <%=disableLable%>></td>
	<td style="border-bottom:silver 1pt solid" colspan="3"><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>5</td>
	<td style="border-bottom:silver 1pt solid">
  	<input type=checkbox name=chkffuse  <%=disableLable%> <%=RecordSet.getString(31).equals("1")?"checked":""%> >
    <input type=hidden name=ffuse  value="<%=RecordSet.getString(31).equals("1")?"1":"0" %>" ></td>
	<td style="border-bottom:silver 1pt solid">&nbsp;</td>
	<td style="border-bottom:silver 1pt solid">&nbsp;</td>
</tr>
<%}if(RecordSet.getString(33).equals("1") || hasUsed(rs,"tinyintfield1")){ %>
<tr>
	<td style="border-bottom:silver 1pt solid"><input name="ffname" type="hidden" value="bff01">&nbsp;</td>
	<td style="border-bottom:silver 1pt solid"><input  class=InputStyle name="fflabel" value="<%=Util.toScreen(RecordSet.getString(32),user.getLanguage())%>" <%=disableLable%>></td>
	<td style="border-bottom:silver 1pt solid" colspan="3"><%=SystemEnv.getHtmlLabelName(609,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>1</td>
	<td style="border-bottom:silver 1pt solid">
  	<input type=checkbox name=chkffuse  <%=disableLable%> <%=RecordSet.getString(33).equals("1")?"checked":""%> >
    <input type=hidden name=ffuse  value="<%=RecordSet.getString(33).equals("1")?"1":"0" %>" ></td>
	<td style="border-bottom:silver 1pt solid">&nbsp;</td>
	<td style="border-bottom:silver 1pt solid">&nbsp;</td>
</tr>
<%}if(RecordSet.getString(35).equals("1") || hasUsed(rs,"tinyintfield2")){ %>
<tr>
	<td style="border-bottom:silver 1pt solid"><input name="ffname" type="hidden" value="bff02">&nbsp;</td>
	<td style="border-bottom:silver 1pt solid"><input  class=InputStyle name="fflabel" value="<%=Util.toScreen(RecordSet.getString(34),user.getLanguage())%>" <%=disableLable%>></td>
	<td style="border-bottom:silver 1pt solid" colspan="3"><%=SystemEnv.getHtmlLabelName(609,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>2</td>
	<td style="border-bottom:silver 1pt solid">
  	<input type=checkbox name=chkffuse  <%=disableLable%> <%=RecordSet.getString(35).equals("1")?"checked":""%> >
    <input type=hidden name=ffuse  value="<%=RecordSet.getString(35).equals("1")?"1":"0" %>" ></td>
	<td style="border-bottom:silver 1pt solid">&nbsp;</td>
	<td style="border-bottom:silver 1pt solid">&nbsp;</td>
</tr>
<%}if(RecordSet.getString(37).equals("1") || hasUsed(rs,"tinyintfield3")){ %>
<tr>
	<td style="border-bottom:silver 1pt solid"><input name="ffname" type="hidden" value="bff03">&nbsp;</td>
	<td style="border-bottom:silver 1pt solid"><input  class=InputStyle name="fflabel" value="<%=Util.toScreen(RecordSet.getString(36),user.getLanguage())%>" <%=disableLable%>></td>
  <td style="border-bottom:silver 1pt solid" colspan="3"><%=SystemEnv.getHtmlLabelName(609,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>3</td>
  <td style="border-bottom:silver 1pt solid">
  	<input type=checkbox name=chkffuse  <%=disableLable%> <%=RecordSet.getString(37).equals("1")?"checked":""%> >
    <input type=hidden name=ffuse  value="<%=RecordSet.getString(37).equals("1")?"1":"0" %>" ></td>
  <td style="border-bottom:silver 1pt solid">&nbsp;</td>
  <td style="border-bottom:silver 1pt solid">&nbsp;</td>
</tr>
<%}if(RecordSet.getString(39).equals("1") || hasUsed(rs,"tinyintfield4")){ %>
<tr>
	<td style="border-bottom:silver 1pt solid"><input name="ffname" type="hidden" value="bff04">&nbsp;</td>
	<td style="border-bottom:silver 1pt solid"><input  class=InputStyle name="fflabel" value="<%=Util.toScreen(RecordSet.getString(38),user.getLanguage())%>" <%=disableLable%>></td>
  <td style="border-bottom:silver 1pt solid" colspan="3"><%=SystemEnv.getHtmlLabelName(609,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>4</td>
  <td style="border-bottom:silver 1pt solid">
  	<input type=checkbox name=chkffuse  <%=disableLable%> <%=RecordSet.getString(39).equals("1")?"checked":""%> >
    <input type=hidden name=ffuse  value="<%=RecordSet.getString(39).equals("1")?"1":"0" %>" ></td>
  <td style="border-bottom:silver 1pt solid">&nbsp;</td>
  <td style="border-bottom:silver 1pt solid">&nbsp;</td>
</tr>
<%}if(RecordSet.getString(41).equals("1") || hasUsed(rs,"tinyintfield5")){ %>
<tr>
	<td style="border-bottom:silver 1pt solid"><input name="ffname" type="hidden" value="bff05">&nbsp;</td>
	<td style="border-bottom:silver 1pt solid"><input  class=InputStyle name="fflabel" value="<%=Util.toScreen(RecordSet.getString(40),user.getLanguage())%>" <%=disableLable%>></td>
  <td style="border-bottom:silver 1pt solid" colspan="3"><%=SystemEnv.getHtmlLabelName(609,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>5</td>
  <td style="border-bottom:silver 1pt solid">
  	<input type=checkbox name=chkffuse  <%=disableLable%> <%=RecordSet.getString(41).equals("1")?"checked":""%> >
    <input type=hidden name=ffuse  value="<%=RecordSet.getString(41).equals("1")?"1":"0" %>" ></td>
  <td style="border-bottom:silver 1pt solid">&nbsp;</td>
  <td style="border-bottom:silver 1pt solid">&nbsp;</td>
</tr>
<%} %>
<%

CustomFieldManager cfm = new CustomFieldManager("CrmAddressFieldByInfoType",86);
cfm.getCustomFields();

    int idx = 0;
    boolean canDel = false;
    boolean canEdit = true;
    while(cfm.next()){
    	boolean isUsed = CustomFieldManager.fieldIsUsed("CrmAddressFieldByInfoType", 86, cfm.getId());
    %>
    <tr>
  	<td style="border-bottom:silver 1pt solid">
  		<input name="fieldChk" type="checkbox" value="<%=idx++%>">
  	</td>
    <td style="border-bottom:silver 1pt solid">
    	<input  class=InputStyle name="fieldlable" value="<%=cfm.getLable()%>" <%=disableLable%>>
    	<input  type="hidden" name="fieldid" value="<%=cfm.getId()%>" >
    </td>
    <td style="border-bottom:silver 1pt solid">
    <%if(cfm.getHtmlType().equals("1")){%>
        <%=SystemEnv.getHtmlLabelName(688,user.getLanguage())%>
    <%} else if(cfm.getHtmlType().equals("2")){%>
        <%=SystemEnv.getHtmlLabelName(689,user.getLanguage())%>
    <%} else if(cfm.getHtmlType().equals("3")){%>
        <%=SystemEnv.getHtmlLabelName(695,user.getLanguage())%>
    <%} else if(cfm.getHtmlType().equals("4")){%>
        <%=SystemEnv.getHtmlLabelName(691,user.getLanguage())%>
    <%} else if(cfm.getHtmlType().equals("5")){%>
        <%=SystemEnv.getHtmlLabelName(690,user.getLanguage())%>
    <%} else if(cfm.getHtmlType().equals("6")){ %>
    		<%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())%>
    <%} %>
    <input name="fieldhtmltype" type="hidden" value="<%=cfm.getHtmlType()%>" >
    </td>
    <td style="border-bottom:silver 1pt solid">
	    <%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>
	    <%if(cfm.getHtmlType().equals("1")){%>
	    <%if(cfm.getType() == 1){%>
	        <%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%>
	    <%} else if(cfm.getType() == 2){%>
	        <%=SystemEnv.getHtmlLabelName(696,user.getLanguage())%>
	    <%} else if(cfm.getType() == 3){%>
	        <%=SystemEnv.getHtmlLabelName(697,user.getLanguage())%>
	    <%} %>
	    <input name=type type="hidden" value="<%=cfm.getType()%>">
    </td>
    <td style="border-bottom:silver 1pt solid">
        <%if(cfm.getType()==1){%>
       			<%=SystemEnv.getHtmlLabelName(698,user.getLanguage())%> 
            <%=cfm.getStrLength()%>
            <input  name=flength type=hidden  value="<%=cfm.getStrLength()%>">
        <%}else{%>
            <input name=flength type=hidden  value="100">
        <%}%>
    </td>
    <%}else if(cfm.getHtmlType().equals("3")){%>
        <%=SystemEnv.getHtmlLabelName(Util.getIntValue(BrowserComInfo.getBrowserlabelid(String.valueOf(cfm.getType())),0),7)%>
        <input name=type type="hidden" value="<%=cfm.getType()%>">
    </td>
    <td style="border-bottom:silver 1pt solid">
        <input name=flength type=hidden  value="100">&nbsp;
    </td>
    <%}else if(cfm.getHtmlType().equals("6")){%>
			<%=cfm.getType()==1?SystemEnv.getHtmlLabelName(20798,user.getLanguage()):SystemEnv.getHtmlLabelName(20001,user.getLanguage()) %>
    <input name=type type="hidden" value="<%=cfm.getType()%>">
		</td>
		<td style="border-bottom:silver 1pt solid">
		    <input name=flength type=hidden  value="100">&nbsp;
		</td>
		<%}else if(cfm.getHtmlType().equals("5")){%>
        <input name=type type=hidden  value="0">
		<%
		    if(canEdit){
		%>
         <BUTTON Class=Btn type=button accessKey=A onclick="addrow2(this)"><%=SystemEnv.getHtmlLabelName(18597,user.getLanguage())%></BUTTON><br>
         <BUTTON Class=Btn type=button accessKey=I onclick="importSel(this)"><%=SystemEnv.getHtmlLabelName(18596,user.getLanguage())%></BUTTON>
		<%
		    }
		%>
        </td>
        <td style="border-bottom:silver 1pt solid">
            <TABLE cellSpacing=0 cellPadding=1 width="100%" border=0 >
            <COLGROUP>
                <col width="40%">
                <col width="60%">
            </COLGROUP>
     <%
        cfm.getSelectItem(cfm.getId()); 
        while(cfm.nextSelect()){
     %>
        <tr>
            <td>
            	<input name=selectitemid type=hidden value="<%=cfm.getSelectValue()%>" >
	            <input  class=InputStyle name=selectitemvalue type=text value="<%=cfm.getSelectName()%>" style="width:100"  <%=disableLable%>>
            </td>
            <td>
               	<img src="/images/icon_ascend_wev8.gif" height="14" onclick="upitem(this)">
                <img src="/images/icon_descend_wev8.gif" height="14" onclick="downitem(this)">
                <img src="/images/delete_wev8.gif" height="14" onclick="delitem(this)">
            </td>
        </tr>

     <%}%>

        </TABLE>
            <input name=selectitemid type=hidden value="--">
            <input name=selectitemvalue type=hidden >
            <input name=flength type=hidden  value="100">
        </td>
    <%}else{%>
            <input name=type type=hidden  value="0">
        </td>
        <td style="border-bottom:silver 1pt solid">
            <input name=flength type=hidden  value="100">&nbsp;
        </td>
    <%}%>
        <td style="border-bottom:silver 1pt solid">
            <input type=checkbox name=chkisuse  <%=disableLable%> <%=cfm.isUse()?"checked":""%> >
            <input type=hidden name=isuse  value="<%=cfm.isUse()?"1":"0" %>" >
        </td>
        <td style="border-bottom:silver 1pt solid">
        		<input type=checkbox name=chkismand  <%=disableLable%> <%=cfm.isMand()?"checked":""%> >
            <input type=hidden name=ismand  value="<%=cfm.isMand()?"1":"0" %>" >
        </td>
        
        <td style="border-bottom:silver 1pt solid">
  				<input class="InputStyle" name="filedOrder" type="text" value="<%=cfm.getOrder()%>" style="width: 40px" >
        </td>
    </tr>
    <%}%>
</TABLE>
</table>
</FORM>
</BODY>
</HTML>
