<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<HTML><HEAD>
<STYLE>.SectionHeader {
	FONT-WEIGHT: bold; COLOR: white; BACKGROUND-COLOR: teal
}
</STYLE>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%      RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:btok(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.close(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btclear(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td></td>
<td valign="top">
<form name="weaver">
<TABLE class=Shadow>
<COLGROUP> <COL width="30%"> <COL width="30%"> <COL width="40%"><TBODY> 
<tr>
<td valign="top" >
<table><tr><td>
<select id="checks" name="checks" onchange="getText()">
<option value=""></option>
<option value="a"><%=SystemEnv.getHtmlLabelName(18128,user.getLanguage())%></option>
<option value="b"><%=SystemEnv.getHtmlLabelName(18129,user.getLanguage())%></option>
<option value="c"><%=SystemEnv.getHtmlLabelName(18130,user.getLanguage())%></option>
</select>
</td>
<td class=Field>
</td>
<td class=Field></td>
</tr>
</table>
</td>
<td valign="top" >
<table bgcolor="#C0C0C0" class=viewform width="100%" id="formulaTable">
<COLGROUP> <COL width="33%"> <COL width="33%"> <COL width="33%"><TBODY>
	<tr >
		<td ><font color="#FF0000"><a href="#">&gt;</a></font></td>
		<td ><font color="#FF0000"><a href="#">&lt;</a></font></td>
		<td><font color="#FF0000"><a href="#">&lt;=</a></font></td>
	</tr>
	<tr>
		<td align="center"><font color="#FF0000"><a href="#">&gt;=</a></font></td>
		<td align="center"><font color="#FF0000"><a href="#">&</a></font></td>
		<td align="center"><font color="#FF0000"><a href="#">||</a></font></td>
	</tr>
	
	<tr>
		<td align="center"><font color="#FF0000"><a href="#">9</a></font></td>
		<td align="center"><font color="#FF0000"><a href="#">8</a></font></td>
		<td align="center"><font color="#FF0000"><a href="#">7</a></font></td>
	</tr>
	<tr>
		<td align="center"><font color="#FF0000"><a href="#">6</a></font></td>
		<td align="center"><font color="#FF0000"><a href="#">5</a></font></td>
		<td align="center"><font color="#FF0000"><a href="#">4</a></font></td>
	</tr>
	<tr>
		<td align="center"><font color="#FF0000"><a href="#">3</a></font></td>
		<td align="center" ><font color="#FF0000"><a href="#">2</a></font></td>
		<td align="center"><font color="#FF0000"><a href="#">1</a></font></td>
	</tr>
	<tr>
		<td align="center"><font color="#FF0000"><a href="#">0</font></a></td>
		<td align="center"><font color="#FF0000"><a href="#">¡û</a></font></td>
		<td align="center">¡¡</td>
	</tr>
	</table>

</td>
<td valign="top">
<table class="viweform"><tr><td>
<textarea class=inputstyle rows="8" cols="30" name=formula style="color: #FF0000;font-size: 10pt"></textarea>
<input type="hidden" name="formulaid" id="formulaid">
</td>
</tr>
</table>
</td>
</tr>
</TBODY>
</TABLE>
</form>
</td>
<td></td>
</tr>
</table>

<script>
$("#formulaTable").click(function(event){
	var e =  $.event.fix(event).target ;
	var v=$("textarea[name=formula]").val();
	var reg=/[\<\>\>=\<=\&]/;
	if(e.nodeName == "A"){
		var newEntry = $(e).parent().parent().text();
		if (newEntry=="¡û")
		{
			jQuery("textarea[name=formula]").val("");
			jQuery("#formulaid").val("");
			return;
		}
		if ((reg.test(newEntry)&&reg.test(v.substring(v.length-1,v.length)))||v=="")
		{
			alert("<%=SystemEnv.getHtmlLabelName(18098,user.getLanguage())%>");
			return;
		}
		jQuery("textarea[name=formula]").val(jQuery("textarea[name=formula]").val()+newEntry);
		jQuery("#formulaid").val(jQuery("#formulaid").val()+newEntry);
	}
});
function getText()
{
       var reg=/[\<\>\>=\<=\&]/;
       var v=jQuery("textarea[name=formula]").val();
       if (jQuery("#checks").val()=="")
      {
      		alert("<%=SystemEnv.getHtmlLabelName(18131,user.getLanguage())%>");
      		return;
      }
      if (!reg.test(v.substring(v.length-1,v.length))&&(v!=""))
		{
			alert("<%=SystemEnv.getHtmlLabelName(18098,user.getLanguage())%>");
			return;
		}
     jQuery("[textarea[name=formula]").val(jQuery("[textarea[name=formula]").val() + jQuery(document.weaver.checks.options[document.weaver.checks.selectedIndex]).text());
      var temp;
      temp="$"+jQuery("#checks").val()+"$";
      jQuery("#formulaid").val(jQuery("#formulaid").val()+temp);
  }
function  btok(){

	a=jQuery("#formulaid").val();
	b=jQuery("textarea[name=formula]").val();
	window.parent.parent.returnValue = {id:a,name:b};
	window.parent.parent.close();
}
function  btclear(){
	window.parent.parent.returnValue ={id:"",name:""};
	window.parent.parent.close();
}
</script>

</BODY>
</HTML>