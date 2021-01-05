
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="weaver.general.Util" %>

<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page" />
<%
    if(!HrmUserVarify.checkUserRight("WorkPlanTypeSet:Set", user))
    {
        response.sendRedirect("/notice/noright.jsp");
        return;
    }

	boolean mutilLang=Util.isEnableMultiLang();
%>

<HTML>
<HEAD>
	<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	<SCRIPT language="javascript" src="/js/weaver_wev8.js"></SCRIPT>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
	<style>
		.colorPicker{vertical-align:middle;margin-left:4px;cursor:pointer}
		.colorPane td{padding:0 !important;height:18px;};
	</style>
</HEAD>

<BODY>
<!--============================= 标题栏：设置:日程类型 =============================-->
<%
    String imagefilename = "/images/hdMaintenance_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(19653, user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(16094, user.getLanguage());
    String needhelp ="";
    String needfav = "";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>


<!--============================= 右键菜单开始 =============================-->
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
    RCMenu += "{" + SystemEnv.getHtmlLabelName(86,user.getLanguage()) + ",javascript:doSave(this),_self}";
    RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
	   <td>
	    </td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" class="e8_btn_top middle" onclick="doSave(this)"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
	<span id="hoverBtnSpan" class="hoverBtnSpan">
			<span ><%=SystemEnv.getHtmlLabelName(19773,user.getLanguage())%></span>
	</span>
</div>
<FORM name="weaver" action="WorkPlanTypeSetOperation.jsp" method="post">
	<wea:layout type="2col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(33467,user.getLanguage())%>' >
			<wea:item attributes="{'colspan':'full','isTableList':'true'}">
				<TABLE class="ListStyle">
                    <COLGROUP>
                        <COL width="7%" align="center">
                        <COL width="53%" align="left">
                        <COL width="25%" align="center">
                        <COL width="15%" align="center">
                    <TR class="header">
                        <TD align="center"><INPUT type="checkbox" name="chkAll" onClick="chkAllClick(this)"></TD>
                        <TD align="center"><%=SystemEnv.getHtmlLabelName(33468,user.getLanguage())%></TD>
                        <TD align="center"><%=SystemEnv.getHtmlLabelName(495,user.getLanguage())%></TD>
                        <TD align="center"><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%></TD>
                    </TR>
                                            		
                </TABLE>
				<TABLE class="ListStyle LayoutTable" id="oTable1" name="oTable1">
                         <COLGROUP>
                         <COL width="7%" align="center">
                         <COL width="53%" align="left">
                         <COL width="25%" align="center">
                         <COL width="15%" align="center">
                </TABLE>
			</wea:item>
		</wea:group>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(16094,user.getLanguage())%>'  attributes="{'itemAreaDisplay':\"block\"}">
			<wea:item attributes="{'colspan':'full','isTableList':'true'}">
				<TABLE width=100%>
            				<TR>
            					<TD align=right>
            						<BUTTON class="addbtn" type=button accessKey=A onClick="addRow()" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></BUTTON>
            						<BUTTON class="delbtn" type=button accessKey=E onClick="removeRow()" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></BUTTON>
            					</TD>
            				</TR>
          				</TABLE>
          	</wea:item>
			<wea:item attributes="{'colspan':'full','isTableList':'true'}">
				<TABLE class="ListStyle">
                    <COLGROUP>
                        <COL width="7%" align="center">
                        <COL width="53%" align="left">
                        <COL width="25%" align="center">
                        <COL width="15%" align="center">
                    <TR class="header">
                        <TD align="center"><INPUT type="checkbox" name="chkAll" onClick="chkAllClick(this)"></TD>
                        <TD align="center"><%=SystemEnv.getHtmlLabelName(19774,user.getLanguage())%></TD>
                        <TD align="center"><%=SystemEnv.getHtmlLabelName(495,user.getLanguage())%></TD>
                        <TD align="center"><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%></TD>
                    </TR>
                                            		
                </TABLE>
				
				<TABLE class="ListStyle LayoutTable" id="oTable" name="oTable">
                    <COLGROUP>
                       <COL width="7%" align="center">
                       <COL width="53%" align="left">
                       <COL width="25%" align="center">
                       <COL width="15%" align="center">
                </TABLE>
			</wea:item>
		</wea:group>
	</wea:layout>
</FORM>

</BODY>
</HTML>
<style tyle="text/css">
	.colorBox{
		color:red;
		position:absolute;
		top:0;
	}
</style>
<SCRIPT LANGUAGE="JavaScript">
function checkItems(receive,checkItem)
  {
      var　temp　=　-1;　　
　　　　for　(var　i=0;　i<receive.length;　i++){
　　　　　　　　if　(receive[i].value==checkItem.value){
　　　　　　　　　　　　temp　=　i;
　　　　　　　　　　　　break;
　　　　　　　　}
　　　　}
　　　　return　temp;
   }

   function ifRepeat(receive)
  {
      var flag = false;
　　　　var　arrResult　=　new　Array();
      arrResult.push(receive[0]);　
　　　　for　(var　i=1;　i<receive.length;　i++){
　　　　　　　　if　(checkItems(arrResult,receive[i])　==　-1){　
　　　　　　　　　　　 arrResult.push(receive[i]);
　　　　　　　　}else{
                 flag = true;
                 break;
             }
　　　　}
　　　　return　flag;
   }
</SCRIPT>
<SCRIPT LANGUAGE="JavaScript">

	function addRow()
    {        
        var oRow = oTable.insertRow(-1);
        var oRowIndex = oRow.rowIndex;

		oRow.className = "DataDark";
		
		/*============ 选择 ============*/
        var oCell = oRow.insertCell(-1);
        var oDiv = document.createElement("div");
        oDiv.innerHTML="<INPUT type='checkbox' name='workPlanTypeID'><INPUT type='hidden' name='workPlanTypeIDs' value='-1'>";                        
        oCell.appendChild(oDiv);
        
        /*============ 名称 ============*/
        oCell = oRow.insertCell(-1);
        oDiv = document.createElement("div");
        oDiv.innerHTML="<INPUT class='Inputstyle' maxlength='80' type='text' name='workPlanTypeName' size='55' value='' onBlur='setworkPlanTypeName(this)'><SPAN><IMG src='/images/BacoError_wev8.gif' align=absmiddle></SPAN>";                        
        oCell.appendChild(oDiv);
        
        /*============ 颜色 ============*/
        oCell = oRow.insertCell(-1);
        oDiv = document.createElement("div");
        oDiv.innerHTML="<TABLE class='colorPane'><colgroup><col width='0'><col width='16'><col width='60'></colgroup><TR><TD rowspan='2'><INPUT type='hidden' class='InputStyle' maxlength='7' size='10' id='color' name='color' value='1' onBlur='setMenubarBgColor(this)'/></TD><TD><IMG src='/images/ColorPicker_wev8.gif' class='colorPicker' onClick='getColorFromColorPicker(this);'></TD><TD id='menubarBgColor' style='height:4px;background-color:"+getColor(1,0)+"!important;'></TD></TR></TABLE>";                 
        //alert(oDiv.innerHTML);
        oCell.appendChild(oDiv);
        
        /*============ 启用 ============*/
        oCell = oRow.insertCell(-1);
        oDiv = document.createElement("div");
        oDiv.innerHTML="<INPUT type='checkbox' onClick='setAvailable(this)'><INPUT type='hidden' name='available' value='0'>";                        
        oCell.appendChild(oDiv);
		
		jQuery("body").jNice();
    }
        
    function removeRow()
    {
    	len = document.forms[0].elements.length;
    	var dltCnt = 0;
    	for(i=len-1; i >= 0;i--) {
			if (document.forms[0].elements[i].name=='workPlanTypeID'){
				if(document.forms[0].elements[i].checked==true) {
					dltCnt++;	
				}
			}
		}
		var dialog;
		if(window.top.Dialog){
			dialog = window.top.Dialog;
		} else {
			dialog = Dialog;
		}
		if(dltCnt > 0){
			dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
				//var chks = document.getElementsByName("workPlanTypeID");
		       
		        //for (var i = chks.length - 1; i >= 0; i--)
		        //{
		        //    var chk = chks[i];
		        //    //alert(chk.parentElement.parentElement.parentElement.rowIndex);
		        //    if (chk.checked)
		        //    {
		        //        oTable.deleteRow(chk.parentElement.parentElement.parentElement.rowIndex)
		        //    }
		        //}
				
				len = document.forms[0].elements.length;
				var i=0;
				var rowsum1 = 0;
				for(i=len-1; i >= 0;i--) {
					if (document.forms[0].elements[i].name=='workPlanTypeID')
						rowsum1 += 1;
				}
				for(i=len-1; i >= 0;i--) {
					if (document.forms[0].elements[i].name=='workPlanTypeID'){
						if(document.forms[0].elements[i].checked==true) {
							oTable.deleteRow(rowsum1-1);	
						}
						rowsum1 -=1;
					}
				
				}
			}, function () {}, 320, 90,true);
		} else {
			dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
		}
    }
    
    function setAvailable(o)
    {
        
    	if(o.checked)
    	{
    		o.parentElement.parentElement.lastChild.value = "1";
    	}
    	else
    	{
    		o.parentElement.parentElement.lastChild.value = "0";
    	}
    }
    
    function chkAllClick(obj)
    {
        var chks = document.getElementsByName("workPlanTypeID");
        
        for (var i = 0; i < chks.length; i++)
        {
            var chk = chks[i];
            
            if(false == chk.disabled)
            {
            	chk.checked = obj.checked;
            }
        }
    }
    
    function doSave(obj)
    {    	
    	if(checkFormInput(weaver, "workPlanTypeName","color","workplanname", "wcolor"))
    	{
			var name = document.getElementsByName('workPlanTypeName');
		    if(ifRepeat(name)){
		       parent.paretnAlert('<%=SystemEnv.getHtmlLabelName(21943,user.getLanguage())%>!');
		       return;
		    }
    		obj.disabled = true;
        	document.weaver.submit();
        }
    }
    

	function checkFormInput(checkForm, checkItems, checkSpecialItems)
	{
		var thisForm = checkForm;
		var checkItems = checkItems + ",";
		var checkSpecialItems = checkSpecialItems + ",";
		
		for(var i = 1; i <= thisForm.length; i++)
		{
			var tmpName = thisForm.elements[i-1].name;
			var tmpValue = thisForm.elements[i-1].value;
			
			while(0 == tmpValue.indexOf(" "))
			{
				tmpValue = tmpValue.substring(1, tmpValue.length);
			}
		
			if("" != tmpName && ((-1 != checkItems.indexOf(tmpName+",") && "" == tmpValue) || (-1 != checkSpecialItems.indexOf(tmpName+",") && "#" == tmpValue)))
			{
				parent.paretnAlert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
			 	return false;
			}
		}
		return true;
	}

	function checkRepetitiveColor(inputColor, nowColor)
	//检测所选颜色是否可以使用  true：可以使用输入颜色  false：不可以使用输入颜色
	{
		var count = 0;
		var total = 1;
		var inputColor = inputColor.toUpperCase();
		var nowColor = nowColor.toUpperCase();

		for(var i = 1; i <= weaver.length; i++)
		{
			var tmpName = weaver.elements[i-1].name;
			var tmpValue = weaver.elements[i-1].value.toUpperCase();

			if("color" == tmpName && "#" != tmpValue && inputColor == tmpValue)
			{
				if(inputColor == nowColor && count < total)
				{
					count++;
				}
				else
				{
					parent.paretnAlert("<%=SystemEnv.getHtmlLabelName(19778,user.getLanguage())%>");
				 	return false;
				}
			}
		}
		return true;
	}

	function setworkPlanTypeName(o)
	{
		if("" != o.value)
		{
			o.parentElement.lastChild.innerHTML = "";  //去除必须输入符号
		}
		else
		{
			o.parentElement.lastChild.innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absmiddle>";  //增加必须输入符号
		}
	}
	
	function setMenubarBgColor(o)
    {
    	var reg = /^#(([a-f]|[A-F]|\d){6})$/;
		//);
		if(!reg.test(o.value))
		{
			Dialog.alert("<%=SystemEnv.getHtmlLabelName(19777,user.getLanguage())%>");			
			jQuery(o).parent().parent().parent().children(":last-child").children(":first-child")[0].style.backgroundColor = "";  //颜色显示
			jQuery(o).parent().parent().parent().children(":first-child").children(":first-child").children(":first-child").text("#");  //数据输入
			jQuery(o).parent().parent().parent().children(":first-child").children(":first-child").children(":last-child")[0].innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absmiddle>";  //增加必须输入符号
		}
		else if(!checkRepetitiveColor(o.value, o.value))
		{
			jQuery(o).parent().parent().parent().children(":last-child").children(":first-child")[0].style.backgroundColor = "";  //颜色显示
			jQuery(o).parent().parent().parent().children(":first-child").children(":first-child").children(":first-child").text("#");  //数据输入
			jQuery(o).parent().parent().parent().children(":first-child").children(":first-child").children(":last-child")[0].innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absmiddle>";  //增加必须输入符号		
		}
		else
		{
			jQuery(o).parent().parent().parent().children(":last-child").children(":first-child")[0].style.backgroundColor = o.value;  //颜色显示
    		jQuery(o).parent().parent().parent().children(":first-child").children(":first-child").children(":last-child")[0].innerHTML = "";  //去除必须输入符号    	
		}		
	}
		 
    function getColorFromColorPicker(o)
    {
    	
		var colorPane=$(o).parents(".colorPane")[0];
		var cells=colorPane.rows[0].cells;
		
		var dialog;
		if(window.top.Dialog){
			dialog = new window.top.Dialog();
		} else {
			dialog = new Dialog();
		}
		dialog.URL="/workplan/config/global/WorkplanThemeBrowser.jsp?themeId="+$(cells[0]).find("input").val();
		dialog.Height=320;
		dialog.Width=480;
		dialog.currentWindow = window;
	    dialog.Modal = true;
	    dialog.Title = "<%=SystemEnv.getHtmlLabelName(16217,user.getLanguage())%>";
		dialog.OKEvent=function(){
			value=dialog.innerFrame.contentWindow.document.getElementsByName('themeid')[0].value;
			if(value != ""){
				$(cells[0]).find("input").val(value);
				$(cells[2]).css("cssText","background-color:"+getColor(value,0)+"!important");
			}
			dialog.close();
		}
		dialog.show();
		
	}
	
	function initOverPlan()
	{
		<%
			String sql = "select * from overworkplan";
			recordSet.executeSql(sql);
			while (recordSet.next()) 
			{
				String workPlanID = recordSet.getString("id");
				String workplanname = recordSet.getString("workplanname");
				String workplancolor = recordSet.getString("workplancolor");
				String wavailable = recordSet.getString("wavailable");
				
		%>
		var oRow = oTable1.insertRow(-1);
        var oRowIndex = oRow.rowIndex;

		oRow.className = "DataDark";
		/*============ 选择 ============*/
        var oCell = oRow.insertCell(-1);
        var oDiv = document.createElement("div");
        oDiv.innerHTML="<INPUT type='checkbox' disabled='true' name='workPlanID'><INPUT type='hidden' name='workPlanIDs' value='<%=workPlanID%>'>";                        
        oCell.appendChild(oDiv);
        
        /*============ 名称 ============*/
        oCell = oRow.insertCell(-1);
        oDiv = document.createElement("div");
        oDiv.innerHTML="<INPUT class='Inputstyle' type='text' name='workplanname' size='55' value='<%=workplanname%>' readonly onBlur='setworkPlanTypeName(this)'><SPAN></SPAN>";                        
        oCell.appendChild(oDiv);
        
        /*============ 颜色 ============*/
        oCell = oRow.insertCell(-1);
        oDiv = document.createElement("div");
        oDiv.innerHTML="<TABLE class='colorPane'><colgroup><col width='0'><col width='16'><col width='60'></colgroup><TR><TD rowspan='2'><INPUT type='hidden' class='InputStyle' maxlength='7' size='10' id='wcolor' name='wcolor' value='<%=workplancolor%>' onBlur='setMenubarBgColor(this)'/><SPAN></SPAN></TD><TD><IMG src='/images/ColorPicker_wev8.gif' class='colorPicker' onClick='getColorFromColorPicker(this);'></TD><TD id='menubarBgColor' style='height:4px;background-color:"+getColor(<%=workplancolor%>,0)+" !important;'></TD></TR></TABLE>";                 
        oCell.appendChild(oDiv);
        
        /*============ 启用 ============*/
        oCell = oRow.insertCell(-1);
        oDiv = document.createElement("div");
        oDiv.innerHTML="<INPUT type='checkbox' onClick='setAvailable(this)' <%if("1".equals(wavailable)){%>checked='true'<%}%>><INPUT type='hidden' name='wavailable' value='<%=wavailable%>'>";                        
        oCell.appendChild(oDiv);
		<%
			}
		%>
	}
	function init()
	{
<%
		StringBuffer stringBuffer = new StringBuffer();
		stringBuffer.append("SELECT DISTINCT workPlanType.*, workPlan.type_n");
		stringBuffer.append(" FROM WorkPlanType workPlanType");
		stringBuffer.append(" LEFT JOIN WorkPlan workPlan");
		stringBuffer.append(" ON workPlanType.workPlanTypeId = workPlan.type_n");
		stringBuffer.append(" ORDER BY workPlanType.displayOrder ASC");
		recordSet.executeSql(stringBuffer.toString());
		
		while (recordSet.next()) 
		{
            int attribute = recordSet.getInt("workPlanTypeAttribute");
            String available = recordSet.getString("available");
            String typeUsed = recordSet.getString("type_n");
            boolean used = (null == typeUsed || "".equals(typeUsed)) ? false : true;
%>
			var oRow = oTable.insertRow(-1);
	        var oRowIndex = oRow.rowIndex;

			oRow.className = "DataDark";
			/*============ 选择 ============*/
	        var oCell = oRow.insertCell(-1);
	        var oDiv = document.createElement("div");
	        oDiv.innerHTML="<INPUT type='checkbox' name='workPlanTypeID' <%= checkRightCheckBox(used, attribute) %> ><INPUT type='hidden' name='workPlanTypeIDs' value='<%= recordSet.getInt("workPlanTypeID") %>'>";                        
	        oCell.appendChild(oDiv);
	        
	        /*============ 名称 ============*/
	        oCell = oRow.insertCell(-1);
	        oDiv = document.createElement("div");
	        oDiv.innerHTML="<INPUT class='Inputstyle' maxlength='80' type='text' name='workPlanTypeName' size='55' value='<%= Util.toHtml(Util.null2String(recordSet.getString("workPlanTypeName")).replace("\\","\\\\"),false) %>' onBlur='setworkPlanTypeName(this)' <%= checkRightInput(attribute,mutilLang) %> ><SPAN></SPAN>";                        
	        oCell.appendChild(oDiv);
	        
	        /*============ 颜色 ============*/
	        oCell = oRow.insertCell(-1);
	        oDiv = document.createElement("div");
	        oDiv.innerHTML="<TABLE class='colorPane'><colgroup><col width='0'><col width='16'><col width='60'></colgroup><TR><TD rowspan='2'><INPUT type='hidden' class='InputStyle' maxlength='7' size='10' id='color' name='color' value='<%= recordSet.getString("workPlanTypeColor") %>' onBlur='setMenubarBgColor(this)' <%= checkRightColorInput(attribute) %>/><SPAN></SPAN></TD><TD><IMG src='/images/ColorPicker_wev8.gif' class='colorPicker' <%= checkRightColorpallette(attribute) %> ></TD><TD id='menubarBgColor' style='height:4px;background-color:"+getColor(<%= recordSet.getString("workPlanTypeColor") %>,0)+" !important;'></TD></TR></TABLE>";                 
	        oCell.appendChild(oDiv);
	        
	        /*============ 启用 ============*/
	        oCell = oRow.insertCell(-1);
	        oDiv = document.createElement("div");
	        oDiv.innerHTML="<INPUT type='checkbox' <%= checkRightValidCheckBox(attribute) %> onClick='setAvailable(this)' <% if("1".equals(available)) { %> checked='true'<% } %>><INPUT type='hidden' name='available' value='<% if("1".equals(available)) { %>1<% } else { %>0<% } %>'>";                        
	        oCell.appendChild(oDiv);
<%
		}
		
		String note = (String)request.getAttribute("note");
		if(null != note && !"".equals(note))
		{
%>
			Dialog.alert("<%= note %>");
<%
		}
%>
	}
	initOverPlan();
	init();

	function getColor(i,j){
		
		var  d = "666666888888aaaaaabbbbbbdddddda32929cc3333d96666e69999f0c2c2b1365fdd4477e67399eea2bbf5c7d67a367a994499b373b3cca2cce1c7e15229a36633cc8c66d9b399e6d1c2f029527a336699668cb399b3ccc2d1e12952a33366cc668cd999b3e6c2d1f01b887a22aa9959bfb391d5ccbde6e128754e32926265ad8999c9b1c2dfd00d78131096184cb05288cb8cb8e0ba52880066aa008cbf40b3d580d1e6b388880eaaaa11bfbf4dd5d588e6e6b8ab8b00d6ae00e0c240ebd780f3e7b3be6d00ee8800f2a640f7c480fadcb3b1440edd5511e6804deeaa88f5ccb8865a5aa87070be9494d4b8b8e5d4d47057708c6d8ca992a9c6b6c6ddd3dd4e5d6c6274878997a5b1bac3d0d6db5a69867083a894a2beb8c1d4d4dae54a716c5c8d8785aaa5aec6c3cedddb6e6e41898951a7a77dc4c4a8dcdccb8d6f47b08b59c4a883d8c5ace7dcce";
		
		return "#" + d.substring(i * 30 + j * 6, i * 30 + (j + 1) * 6);
	
	}
	function preDo(){
	//tabSelectChg();
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	$("#hoverBtnSpan").hoverBtn();
	}

	function onBtnSearchClick(){
	}
</SCRIPT>

<%!
	/*
	 *	7：标题无  颜色无  启用删除无 
	 *  6：标题无  颜色可  启用删除无 
	 *  0：标题可  颜色可  启用删除可 
	 *
	 */
	public String checkRightCheckBox(boolean used, int rightLevel)
	{
		if(used)
		{
			return " disabled='true' ";
		}
		else if(7 == rightLevel)
		{
			return " disabled='true' ";
		}
		else if(6 == rightLevel)
		{
			return " disabled='true' ";
		}
		else if(0 == rightLevel)
		{
			return "";
		}

		return "";
	}

	/*
	 *	7：标题无  颜色无  启用删除无 
	 *  6：标题无  颜色可  启用删除无 
	 *  0：标题可  颜色可  启用删除可 
	 *
	 */
	public String checkRightValidCheckBox(int rightLevel)
	{
		if(7 == rightLevel)
		{
			return " disabled='true' ";
		}
		else if(6 == rightLevel)
		{
			return " disabled='true' ";
		}
		else if(0 == rightLevel)
		{
			return "";
		}

		return "";
	}
	
	/*
	 *	7：标题无  颜色无  启用删除无 
	 *  6：标题无  颜色可  启用删除无 
	 *  0：标题可  颜色可  启用删除可 
	 *
	 */
	public String checkRightInput(int rightLevel,boolean mutilLang)
	{	
		if(!mutilLang){
			if(7 == rightLevel)
			{
				return " readonly ";
			}
			else if(6 == rightLevel)
			{
				return " readonly ";
			}
			else if(0 == rightLevel)
			{
				return "";
			}
		}
		return "";	
	}
	
	/*
	 *	7：标题无  颜色无  启用删除无 
	 *  6：标题无  颜色可  启用删除无 
	 *  0：标题可  颜色可  启用删除可 
	 *
	 */
	public String checkRightColorInput(int rightLevel)
	{	
		
		if(7 == rightLevel)
		{
			return " readonly ";
		}
		else if(6 == rightLevel)
		{
			return "";
		}
		else if(0 == rightLevel)
		{
			return "";
		}
		
		return "";	
	}
	
	/*
	 *	7：标题无  颜色无  启用删除无 
	 *  6：标题无  颜色可  启用删除无 
	 *  0：标题可  颜色可  启用删除可 
	 *
	 */
	public String checkRightColorpallette(int rightLevel)
	{
		if(7 == rightLevel)
		{
			return "";
		}
		else if(6 == rightLevel)
		{
			return " onClick='getColorFromColorPicker(this);' ";
		}
		else if(0 == rightLevel)
		{
			return " onClick='getColorFromColorPicker(this);' ";
		}

		return "";	
	}
%>
