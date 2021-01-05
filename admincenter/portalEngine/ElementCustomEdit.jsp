
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="wbec" class="weaver.admincenter.homepage.WeaverBaseElementCominfo" scope="page" />
<jsp:useBean id="ecc" class="weaver.admincenter.homepage.ElementCustomCominfo" scope="page" />
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
   
    <title>元素开发</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles_wev8.css">
	-->
		<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
  </head>
  <LINK href="ElementTab_wev8.css" type="text/css" rel=STYLESHEET>
  <LINK href="/css/ecology8/upload_e8_Btn_wev8.css" type="text/css" rel=STYLESHEET>
  <SCRIPT language="javascript" src="/js/ecology8/portalEngine/upload_e8_Btn_wev8.js"></script>
  <body>
  	<%
		String titlename = "";
  	    String msg = Util.null2String(request.getParameter("msg"));
  	  	String ebaseid = Util.null2String(request.getParameter("ebaseid"));
  	  	List display = ecc.getDisplayList(ebaseid);
  	 	List setting = ecc.getSettingList(ebaseid);
	%>

	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<div class="zDialog_div_content">	
<form id="elementModel" name="elementModel" method="post" action="/weaver/weaver.admincenter.homepage.ElementCustomServlet">
	<div id="modelDiv" style="width:100%;">
		<input type="hidden" id="operate" name="operate" value="edit"/>
		<input type="hidden" id="e_id" name="e_id" value="<%=ebaseid %>"/>
		<input type="hidden" id="e_type" name="e_type" value="3"/>
		<input type="hidden" id="e_isuse" name="e_isuse" value="0"/>
		<table class="ViewForm" style="align:top">
			<tr>
				<td class="FieldTitle">元素名称(中文)</td>
				<td class="Field">
				<input type="text" id="e_title" name="e_title" value="<%=wbec.getTitle(ebaseid) %>" onchange='checkinput("e_title","e_titlespan");this.value=trim(this.value)'/>
				<SPAN id=e_titlespan>
                </SPAN><div id="customMessage" style="display:inline;color:red;"></div></td>
			</tr>
			<TR class=Spacing style="height:1px">
            	<TD class=Line1 colSpan=2></TD>
          	</TR>
			<tr>
				<td class="FieldTitle">元素名称(English)</td>
				<td class="Field"><input type="text" id="e_titleEN" name="e_titleEN" value="<%=wbec.getTitleEN(ebaseid) %>"/></td>
			</tr>
			<TR class=Spacing style="height:1px">
            	<TD class=Line1 colSpan=2></TD>
          	</TR>
          	<tr>
				<td class="FieldTitle">元素名称(繁體)</td>
				<td class="Field"><input type="text" id="e_titleTHK" name="e_titleTHK" value="<%=wbec.getTitleTHK(ebaseid) %>"/></td>
			</tr>
			<TR class=Spacing style="height:1px">
            	<TD class=Line1 colSpan=2></TD>
          	</TR>
			<tr>
				<td class="FieldTitle">元素描述</td>
				<td class="Field"><input type="text" id="e_desc" name="e_desc" value="<%=wbec.getEdesc(ebaseid) %>"/></td>
			</tr>
			<TR class=Spacing style="height:1px">
            	<TD class=Line1 colSpan=2></TD>
          	</TR>
          	<tr>
				<td class="FieldTitle">元素类别</td>
				<td class="Field">
					<select id="e_loginview" name="e_loginview" style="width:136px;margin-left:2px;">
						<%String loginview = wbec.getLoginview(ebaseid); %>
						<option value="0" <%="0".equals(loginview)?"selected":"" %>>登录后元素</option>
						<option value="1" <%="1".equals(loginview)?"selected":"" %>>登录前元素</option>
						<option value="2" <%="2".equals(loginview)?"selected":"" %>> 元 素 </option>
					</select></td>
			</tr>
			<TR class=Spacing style="height:1px">
            	<TD class=Line1 colSpan=2></TD>
          	</TR>
			<tr>
				<td class="FieldTitle">链接方式</td>
				<td class="Field">
					<select id="e_linkMode" name="e_linkMode" style="width:136px;margin-left:2px;">
						<%String linkmode = wbec.getLinkmode(ebaseid); %>
						<option value="-1" <%="-1".equals(linkmode)?"selected":"" %>>无</option>
						<option value="1" <%="1".equals(linkmode)?"selected":"" %>>默认窗口</option>
						<option value="2" <%="2".equals(linkmode)?"selected":"" %>>弹出窗口</option>
					</select>
				</td>
			</tr>
			<TR class=Spacing style="height:1px">
            	<TD class=Line1 colSpan=2></TD>
          	</TR>
		</table>
		<br/>
		<TABLE width="100%" id="oShowTable" class=ListStyle cellspacing=0 >
          <COLGROUP>
   		    <COL width=3%>
		    <COL width=15%>
			<COL width=15%>
			<COL width=15%>
			<COL width=15%>
			<COL width=15%>
	      <TBODY>
		  <input type=hidden name="showrownum" value="<%=display.size() %>">
          <TR class=header>
            <td colspan="2"><b>显示字段：</b></td>
	   	 	<Td align=right colspan=4>
	      		<BUTTON class="addbtn" type="button" accessKey=A onClick="addShowRow();"></BUTTON>
	    		<BUTTON class="delbtn" type="button" accessKey=D onClick="deleteShowRow();"></BUTTON>
           </Td>
          </TR>
          <TR class=Spacing style="height:1px;display:none">
            <TD class=Line1 colSpan=6></TD>
          </TR>
		  <tr class=Header>
            <td >&nbsp;</td>
		    <td >显示名称</td>
			<td >显示类型</td>
			<td >字段名称</td>
			<td >是否控制字数</td>
			<td >显示顺序</td>			
		  </tr>
		  <%
		  for(int i=0;i<display.size();i++){
			  Map showMap = (Map)display.get(i);
			  out.print("<tr ><td style=\"background-color:rgb(245,250,252);\"><input class=inputstyle type='checkbox' name='check_shownode' value='"+i+"'/><input class=inputstyle type='hidden' name='showfieldid' value='"+i+"'/></td>");
			  out.print("<td style=\"background-color:rgb(245,250,252);\"><input class=inputstyle type=text  name='showtitle_"+i+"' value=\""+showMap.get("showtitle")+"\" onchange=\"checkinput('showtitle_"+i+"','showtitle_"+i+"span');this.value=trim(this.value)\"/>"
						+"<span id=\"showtitle_"+i+"span\"></span></td>");
			  out.print("<td style=\"background-color:rgb(245,250,252);\">CHECKBOX<input class=inputstyle type=hidden value='checkbox' name='showtype_"+i+"'/></td>");
			  out.print("<td style=\"background-color:rgb(245,250,252);\"><input class=inputstyle type=text  name='showname_"+i+"' value=\""+showMap.get("showname")+"\" onchange=\"checkinput('showname_"+i+"','showname_"+i+"span');this.value=trim(this.value)\"/>"
						+"<span id=\"showname_"+i+"span\"></span></td>");
			  out.print("<td style=\"background-color:rgb(245,250,252);\"><select name='showdatatype_"+i+"'>"
						+"<option value='1'>是</option>"
						+"<option value='0'>否</option>"
						+"</select></td>");
			  out.print("<td style=\"background-color:rgb(245,250,252);\"><input class=inputstyle type=text  name='showdatalength_"+i+"' value='"+(i+1)+"'/></td></tr>");
		  }
		  %>
      </tbody>
       </table>
       <br/>
       <TABLE width="100%" id="oSettingTable" class=ListStyle cellspacing=0 >
          <COLGROUP>
   		    <COL width=3%>
		    <COL width=15%>
			<COL width=15%>
			<COL width=15%>
			<COL width=15%>
			<COL width=15%>
	      <TBODY>
		  <input type=hidden name="settingrownum" value="<%=setting.size() %>">
          <TR class=header>
            <td colspan="2"><b>设置字段：</b></td>
	    	<Td align=right colspan=4>
	    		<BUTTON class="addbtn" type="button" accessKey=A onClick="addSettingRow();"></BUTTON>
	    		<BUTTON class="delbtn" type="button" accessKey=D onClick="deleteSettingRow();"></BUTTON>
           </Td>
          </TR>
          <TR class=Spacing style="height:1px;display:none">
            <TD class=Line1 colSpan=6></TD>
          </TR>
		  <tr class=Header>
            <td >&nbsp;</td>
		    <td >显示名称</td>
			<td >内容来源</td>
			<td >字段名称</td>
			<td >数据类型</td>
			<td >显示方式</td>			
		  </tr>
		  <%
		  
		  for(int i=0;i<setting.size();i++){
			  Map settingMap = (Map)setting.get(i);
			  out.print("<tr ><td style=\"background-color:rgb(245,250,252);\"><input class=inputstyle type='checkbox' name='check_settingnode' value='"+i+"'/></td>");
			  out.print("<td style=\"background-color:rgb(245,250,252);\"><input class=inputstyle type=text  name='settingtitle_"+i+"' value=\""+settingMap.get("settingtitle")+"\" onchange=\"checkinput('settingtitle_"+i+"','settingtitle_"+i+"span');this.value=trim(this.value)\"/>"
						+"<span id=\"settingitle_"+i+"span\"></span></td>");
			  String setType = (String)settingMap.get("settingtype");
			  out.print("<td style=\"background-color:rgb(245,250,252);\"><select name='settingtype_"+i+"'>"
				+"<option value='DataSource' "+("DataSource".equals(setType)?"selected":"")+">外部数据源</option>"
				+"<option value='DataPage' "+("DataPage".equals(setType)?"selected":"")+">数据页面</option>"
				+"</select></td>");
			  out.print("<td style=\"background-color:rgb(245,250,252);\"><input class=inputstyle type=text  name='settingname_"+i+"' value=\""+settingMap.get("settingname")+"\" onchange=\"checkinput('settingname_"+i+"','settingname_"+i+"span');this.value=trim(this.value)\"/>"
						+"<span id=\"settingname_"+i+"span\"></span></td>");
			  String setDataType = (String)settingMap.get("settingdatatype");
			  out.print("<td style=\"background-color:rgb(245,250,252);\"><select name='settingdatatype_"+i+"'>"
				+"<option value='SQL' "+("SQL".equals(setDataType)?"selected":"")+">数据库+SQL语句</option>"
				+"<option value='XML' "+("XML".equals(setDataType)?"selected":"")+">XML</option>"
				//+"<option value='RSS' "+("RSS".equals(setDataType)?"selected":"")+">RSS</option>"
				+"<option value='JSON' "+("JSON".equals(setDataType)?"selected":"")+">JSON</option>"
				//+"<option value='WebService' "+("WebService".equals(setDataType)?"selected":"")+">webservice</option>"
				+"</select></td>");
			  String setDataTypeLen = (String)settingMap.get("settingdatalength");
			  out.print("<td style=\"background-color:rgb(245,250,252);\"><select name='settingdatalength_"+i+"'>"
						+"<option value='showList' "+("showList".equals(setDataTypeLen)?"selected":"")+">列表式</option>"
						//+"<option value='showTop' "+("showTop".equals(setDataTypeLen)?"selected":"")+">上图式</option>"
						//+"<option value='showLeft' "+("showLeft".equals(setDataTypeLen)?"selected":"")+">左图式</option>"
						+"</select></td></tr>");
		  }
		  %>
      </tbody>
       </table>
       <p>&nbsp;</p>
	</div>
</form>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<table width="100%">
    <tr><td style="text-align:center;" colspan="3">
     <input type="button" value="保存"  class="zd_btn_submit" onclick="top.Dialog.confirm('保存之后,所有页面该元素的设置项都将无效,需重新设置,是否继续?',onSave);">
     <input type="button" value="取消"  class="zd_btn_cancle" onclick="onCancle();">
    </td></tr>
</table>

</div>
<div id="rightMenuDiv">
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
		RCMenu += "{保存,javascript:doSave();,_self}";
		RCMenuHeight += RCMenuHeightStep; 
	%>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</div>	
</body>
</html>
<SCRIPT type="text/javascript" src="/js/addRowBg_wev8.js"></script>
<!-- for zDiaolg -->
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css"type="text/css"/>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript">
var msg = "<%=msg%>";
var checkField = "e_title";
var checkshowField = "";
var checksettingField = "";
	jQuery(document).ready(function(){
		jQuery("#topTitle").topMenuTitle();
		jQuery(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
		jQuery("#tabDiv").remove();		
		
		resizeDialog(document);
		
		if(msg!=""&&msg=="1") jQuery("#customMessage").html("元素配置文件不存在或编码不对");
		else jQuery("#customMessage").html("");
	});
	
	function onNext(){
		parent.location.href="/admincenter/portalEngine/ElementTabs.jsp?curUrl=register";
	}
	
	function onHelp(){
		var help_dialog = new Dialog();
		help_dialog.currentWindow = window;   //传入当前window
	 	help_dialog.Width = 500;
	 	help_dialog.Height = 300;
	 	help_dialog.Modal = false;
	 	help_dialog.Title = "开发指南"; 
	 	help_dialog.URL = "/admincenter/portalEngine/ElementCustomHelp.jsp";
	 	help_dialog.show();
	}
	
	function onCancle(){
		var parentWin = parent.getDialog(window);
		parentWin.close();
	}
		
	function onSave(){
		var num = jQuery("input[name=check_shownode]").length;
		checkshowField = "";
		checksettingField = "";
		for(var i=0;i<num;i++){
			var index = jQuery("input[name=check_shownode]")[i].value;
			checkshowField += ",showtitle_"+index+",showname_"+index;
		}
		num = jQuery("input[name=check_settingnode]").length;
		for(var i=0;i<num;i++){
			var index = jQuery("input[name=check_settingnode]")[i].value;
			checksettingField += ",settingtitle_"+index+",settingname_"+index;
		}
		//alert(checkField+checkshowField+checksettingField);
		if(check_form(document.elementModel,checkField+checkshowField+checksettingField)){
			elementModel.submit();
		}
	}
	var showrowindex = <%=display.size()%>;
	function addShowRow()
	{
		ncol = jQuery(oShowTable).find("tr:nth-child(4)").find("td").length;
		oRow = oShowTable.insertRow(-1);
		rowColor = getRowBg();
		for(j=0; j<ncol; j++) {
			oCell = oRow.insertCell(-1);
			oCell.style.height=24;
			oCell.style.background= rowColor;
			switch(j) {
	            case 0:
					var oDiv = document.createElement("div");
					var sHtml = "<input class=inputstyle type='checkbox' name='check_shownode' value='"+showrowindex+"'/>";
					oDiv.innerHTML = sHtml;
					oCell.appendChild(oDiv);
					break;
				case 1:
					var oDiv = document.createElement("div");
					var sHtml =  "<input class=inputstyle type=text  name='showtitle_"+showrowindex+"' onchange=\"checkinput('showtitle_"+showrowindex+"','showtitle_"+showrowindex+"span');this.value=trim(this.value)\"/>"
						+"<span id=\"showtitle_"+showrowindex+"span\"><IMG src=\"/images/BacoError_wev8.gif\" align=\"absMiddle\"></span>";
					oDiv.innerHTML = sHtml;
					oCell.appendChild(oDiv);
					break;
				case 2:
					var oDiv = document.createElement("div");
					var sHtml = "CHECKBOX<input class=inputstyle type=hidden value='checkbox'  name='showtype_"+showrowindex+"'/>";
					oDiv.innerHTML = sHtml;
					oCell.appendChild(oDiv);
					break;
				case 3:
					var oDiv = document.createElement("div");
					var sHtml = "<input class=inputstyle type=text  name='showname_"+showrowindex+"' onchange=\"checkinput('showname_"+showrowindex+"','showname_"+showrowindex+"span');this.value=trim(this.value)\"/>"
						+"<span id=\"showname_"+showrowindex+"span\"><IMG src=\"/images/BacoError_wev8.gif\" align=\"absMiddle\"></span>";
					oDiv.innerHTML = sHtml;
					oCell.appendChild(oDiv);
					break;
	            case 4:
					var oDiv = document.createElement("div");
					var sHtml = "<select name='showdatatype_"+showrowindex+"'>"
						+"<option value='1'>是</option>"
						+"<option value='0'>否</option>"
						+"</select>";
					oDiv.innerHTML = sHtml;
					oCell.appendChild(oDiv);
					break;
			    case 5:
					var oDiv = document.createElement("div");
					var sHtml = "<input class=inputstyle type=text  name='showdatalength_"+showrowindex+"' value='"+(showrowindex+1)+"'/>";
					oDiv.innerHTML = sHtml;
					oCell.appendChild(oDiv);
					break;
			}
		}
		showrowindex = showrowindex*1 +1;
		jQuery("input[name=showrownum]").val(showrowindex);
	}
	
	function deleteShowRow()
	{
		if(!isdel())return;
	   	len = document.forms[0].elements.length;
		var i=0;
		var rowsum1 = 1;
	    for(i=len-1; i >= 0;i--) {
			if (document.forms[0].elements[i].name=='check_shownode')
				rowsum1 += 1;
		}
		var delrow = 0;
		for(i=len-1; i >= 0;i--) {
			if (document.forms[0].elements[i].name=='check_shownode'){
				if(document.forms[0].elements[i].checked==true) {
					oShowTable.deleteRow(rowsum1+1);
					delrow+=1;
				}
				rowsum1 -=1;
			}
		}
		if(delrow)
			jQuery("input[name=showrownum]").val(jQuery("input[name=showrownum]").val()-delrow);
	}
	
	var settingrowindex = <%=setting.size()%>;
	function addSettingRow()
	{
		if(jQuery("input[name=check_settingnode]").length>0) return;
		ncol = jQuery(oSettingTable).find("tr:nth-child(4)").find("td").length;
		oRow = oSettingTable.insertRow(-1);
		rowColor = getRowBg();
		for(j=0; j<ncol; j++) {
			oCell = oRow.insertCell(-1);
			oCell.style.height=24;
			oCell.style.background= rowColor;
			switch(j) {
	            case 0:
					var oDiv = document.createElement("div");
					var sHtml = "<input class=inputstyle type='checkbox' name='check_settingnode' value='0'/>";
					oDiv.innerHTML = sHtml;
					oCell.appendChild(oDiv);
					break;
				case 1:
					var oDiv = document.createElement("div");
					var sHtml =  "<input class=inputstyle type=text  name='settingtitle_"+settingrowindex+"' onchange=\"checkinput('settingtitle_"+settingrowindex+"','settingtitle_"+settingrowindex+"span');this.value=trim(this.value)\"/>"
						+"<span id=\"settingtitle_"+settingrowindex+"span\"><IMG src=\"/images/BacoError_wev8.gif\" align=\"absMiddle\"></span>";
					oDiv.innerHTML = sHtml;
					oCell.appendChild(oDiv);
					break;
				case 2:
					var oDiv = document.createElement("div");
					var sHtml = "<select name='settingtype_"+settingrowindex+"'>"
						+"<option value='DataSource'>外部数据源</option>"
						+"<option value='DataPage'>数据页面</option>"
						+"</select>";
					oDiv.innerHTML = sHtml;
					oCell.appendChild(oDiv);
					break;
				case 3:
					var oDiv = document.createElement("div");
					var sHtml = "<input class=inputstyle type=text  name='settingname_"+settingrowindex+"' onchange=\"checkinput('settingname_"+settingrowindex+"','settingname_"+settingrowindex+"span');this.value=trim(this.value)\"/>"
						+"<span id=\"settingname_"+settingrowindex+"span\"><IMG src=\"/images/BacoError_wev8.gif\" align=\"absMiddle\"></span>";
					oDiv.innerHTML = sHtml;
					oCell.appendChild(oDiv);
					break;
	            case 4:
					var oDiv = document.createElement("div");
					var sHtml = "<select name='settingdatatype_"+settingrowindex+"'>"
						+"<option value='SQL'>数据库+SQL语句</option>"
						+"<option value='XML'>XML</option>"
						//+"<option value='RSS'>RSS</option>"
						+"<option value='JSON'>JSON</option>"
						//+"<option value='WebService'>webservice</option>"
						+"</select>";
					oDiv.innerHTML = sHtml;
					oCell.appendChild(oDiv);
					break;
			    case 5:
					var oDiv = document.createElement("div");
					var sHtml = "<select name='settingdatalength_"+settingrowindex+"'>"
						+"<option value='showList'>列表式</option>"
						//+"<option value='showTop'>上图式</option>"
						//+"<option value='showLeft'>左图式</option>"
						+"</select>";
					oDiv.innerHTML = sHtml;
					oCell.appendChild(oDiv);
					break;
			}
		}
		settingrowindex = settingrowindex*1 +1;
		jQuery("input[name=settingrownum]").val(settingrowindex);
	}
	
	function deleteSettingRow()
	{
		if(!isdel())return;
	   	len = document.forms[0].elements.length;
		var i=0;
		var rowsum1 = 1;
	    for(i=len-1; i >= 0;i--) {
			if (document.forms[0].elements[i].name=='check_settingnode')
				rowsum1 += 1;
		}
		var delrow = 0;
		for(i=len-1; i >= 0;i--) {
			if (document.forms[0].elements[i].name=='check_settingnode'){
				if(document.forms[0].elements[i].checked==true) {
					oSettingTable.deleteRow(rowsum1+1);
					delrow+=1;
				}
				rowsum1 -=1;
			}
		}
		if(delrow)
			jQuery("input[name=settingrownum]").val(jQuery("input[name=settingrownum]").val()-delrow);
	}
</script>