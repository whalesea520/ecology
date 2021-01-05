
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.ArrayList" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="WFFreeFlowManager" class="weaver.workflow.request.WFFreeFlowManager" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<HTML>
<HEAD>
    <LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
    <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</HEAD>
<body>
<%
	String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");//需要增加的代码
	String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");//需要增加的代码
	user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
	int userid=user.getUID();                   //当前用户id
	int usertype = 0;
    int requestid = Util.getIntValue(request.getParameter("requestid"));
    int nodeid = Util.getIntValue((String) session.getAttribute(user.getUID() + "_" + requestid + "nodeid"));
	String iscnodefree = Util.null2String(request.getParameter("iscnodefree"));//是否来自自由节点流程
	if("".equals(iscnodefree)){
		iscnodefree = "0";
	}
    String src = Util.null2String(request.getParameter("src"));
    String checkfield="";
    boolean saveflag=true;
    if (src.equals("save")) {
        //WFFreeFlowManager.setDebug(true);
        saveflag=WFFreeFlowManager.SaveFreeFlow(request,requestid,nodeid,user.getLanguage());
    }
    RecordSet=WFFreeFlowManager.getFreeWFStep(requestid,nodeid);
%>

<%
    String imagefilename = "/images/hdMaintenance_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(21787, user.getLanguage());
    String needfav = "";
    String needhelp = "";
%>

		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
    RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage()) + ",javascript:onSave(this),_self} ";
    RCMenuHeight += RCMenuHeightStep;

    RCMenu += "{" + SystemEnv.getHtmlLabelName(309, user.getLanguage()) + ",javascript:onClose(),_self} ";
    RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div class="zDialog_div_content">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=titlename %>"/>
</jsp:include>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align: right;">
			<input type="button" class="e8_btn_top_first" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>" onClick="onSave(this);" />
			<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<form name="FreeWorkflowSetform" method="post" action="FreeWorkflowSet.jsp">
<input type=hidden name="requestid" value="<%=requestid%>">
<input type="hidden" value="save" name="src">
<TABLE class=ListStyle cellspacing=1 id="freewfoTable" width="100%">
<COLGROUP>
<COL width="8%">
<COL width="10%">
<COL width="35%">
<COL width="27%">
<COL width="20%">
<TBODY>
<TR>
<%if(iscnodefree.equals("0")){%>
    <TD colSpan=3><b><%=SystemEnv.getHtmlLabelName(21787, user.getLanguage())%>
    <%}else{%>
    <TD colSpan=2><b><%=SystemEnv.getHtmlLabelName(21787, user.getLanguage())%>
    <%}%>
    </b></TD>
    <TD colSpan=2 align="right">
    <%if(iscnodefree.equals("0")){%>
        <a style="color:#262626;cursor:hand; TEXT-DECORATION:none" onclick='addStep()'>
    <%}else{ %>
        <a style="color:#262626;cursor:hand; TEXT-DECORATION:none" onclick='addStep1()'>
    <%}%>
            <img src="/js/swfupload/add_wev8.gif" align="absmiddle" border="0">&nbsp;<%=SystemEnv.getHtmlLabelName(21788, user.getLanguage())%>
        </a>
        &nbsp;
        <a style="color:#262626;cursor:hand;TEXT-DECORATION:none" onclick="delStep()">
            <img src="/js/swfupload/delete_wev8.gif" align="absmiddle" border="0">&nbsp;<%=SystemEnv.getHtmlLabelName(21789, user.getLanguage())%>
        </a>
    </TD>
</TR>
<TR class="Spacing" style="height:1px;">
	<%if(iscnodefree.equals("0")){%>
    <TD class="Line1" colSpan=5 style="padding:0;margin:0;"></TD>
    <%}else{%>
    <TD class="Line1" colSpan=4 style="padding:0;margin:0;"></TD>
    <%}%>
</TR>
<TR class=header>
    <TH><%=SystemEnv.getHtmlLabelName(1426, user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(15486, user.getLanguage())%>
    </TH>
    <TH><%=SystemEnv.getHtmlLabelName(15694, user.getLanguage())%>
    </TH>
    <%if(iscnodefree.equals("0")){%>
    <TH><%=SystemEnv.getHtmlLabelName(21790, user.getLanguage())%>
    </TH>
    <%}%>
    <TH><%=SystemEnv.getHtmlLabelName(17482, user.getLanguage())%>
</TR>
<%
    int i=0;
    while (RecordSet.next()) {
        checkfield+=",nodename_"+i+",operators_"+i;
        String operators=Util.null2String(RecordSet.getString("operators"));
        String operatornames="";
        ArrayList operatorlist=Util.TokenizerString(operators,",");
        for(int j=0;j<operatorlist.size();j++){
            if(operatornames.equals("")){
                operatornames=ResourceComInfo.getLastname((String)operatorlist.get(j));
            }else{
                operatornames+=","+ResourceComInfo.getLastname((String)operatorlist.get(j));
            }
        }
        int floworder=Util.getIntValue(RecordSet.getString("floworder"),0);
        String nodename=Util.null2String(RecordSet.getString("nodename"));
        int Signtype=Util.getIntValue(RecordSet.getString("Signtype"),0);
%>
<TR <%if(i%2==0){%>CLASS="DataDark" <%}else{%>class="DataLight" <%}%>>
    <TD><input type='checkbox' class=inputstyle name='check_node' value='<%=i%>'></TD>
    <TD><input type='text' class=inputstyle name='floworder_<%=i%>' value='<%=floworder%>' size="5" maxlength="3"></TD>
    <TD><input type='text' class=inputstyle name='nodename_<%=i%>' value='<%=nodename%>'  onBlur="checkstr('nodename_<%=i%>',60);checkinput('nodename_<%=i%>','nodenamespan_<%=i%>')"><SPAN id="nodenamespan_<%=i%>"><%if(nodename.equals("")){%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}%></SPAN></TD>
    <%if(iscnodefree.equals("0")){%>
    <TD><select class=inputstyle name='Signtype_<%=i%>'>
        <option value="0" <%if(Signtype==0){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15556, user.getLanguage())%></option>
        <option value="1" <%if(Signtype==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15557, user.getLanguage())%></option>
        <option value="2" <%if(Signtype==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15558, user.getLanguage())%></option>
    </select>
    </TD>
     <%}else{%>
     	<input type='hidden' class=inputstyle name='Signtype_<%=i%>' value='1'>
     <%}%>
    <TD>
        <button type=button  class=Browser onclick="ShowMultiResource('operatorsspan_<%=i%>','operators_<%=i%>')"></button><SPAN id="operatorsspan_<%=i%>"><%if (operators.equals("")) {%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%} else {%><%=operatornames%><%}%></SPAN>
        <input type='hidden' class=inputstyle name='operators_<%=i%>' value="<%=operators%>">
    </TD>
</TR>
<%
        i++;
    }
    if(RecordSet.getCounts()<1){
        checkfield+=",nodename_"+i+",operators_"+i;
%>
<TR <%if(i%2==0){%>CLASS="DataDark" <%}else{%>class="DataLight" <%}%>>
    <TD><input type='checkbox' class=inputstyle name='check_node' value='<%=i%>'></TD>
    <TD><input type='text' class=inputstyle name='floworder_<%=i%>' size="5" maxlength="3" value="1"></TD>
    <TD><input type='text' class=inputstyle name='nodename_<%=i%>' value="<%=SystemEnv.getHtmlLabelName(18731, user.getLanguage())%><%=i+1%>" onBlur="checkstr('nodename_<%=i%>',60);checkinput('nodename_<%=i%>','nodenamespan_<%=i%>')"><SPAN id="nodenamespan_<%=i%>"></SPAN></TD>
    <%if(iscnodefree.equals("0")){%>
    <TD><select class=inputstyle name='Signtype_<%=i%>'>
        <option value="0"><%=SystemEnv.getHtmlLabelName(15556, user.getLanguage())%></option>
        <option value="1"><%=SystemEnv.getHtmlLabelName(15557, user.getLanguage())%></option>
        <option value="2"><%=SystemEnv.getHtmlLabelName(15558, user.getLanguage())%></option>
    </select>
    </TD>
    <%}else{%>
     	<input type='hidden' class=inputstyle name='Signtype_<%=i%>' value='1'>
     <%}%>
    <TD>
        <button type=button  class=Browser onclick="ShowMultiResource('operatorsspan_<%=i%>','operators_<%=i%>')"></button><SPAN id="operatorsspan_<%=i%>"><IMG src='/images/BacoError_wev8.gif' align=absMiddle></SPAN>
        <input type='hidden' class=inputstyle name='operators_<%=i%>' value="">
    </TD>
</TR>
<%
        i++;
    }
%>
</TBODY>
</TABLE>
<input type='hidden' id="rownum" name="rownum" value="<%=i%>">
<input type='hidden' id="indexnum" name="indexnum" value="<%=i%>">
<input type='hidden' id="checkfield" name="checkfield" value="<%=checkfield%>">
<input type="hidden" name="f_weaver_belongto_userid" value="<%=request.getParameter("f_weaver_belongto_userid") %>">
<input type="hidden" name="f_weaver_belongto_usertype" value="<%=request.getParameter("f_weaver_belongto_usertype") %>">
</form>



<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context="" attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" class="zd_btn_cancle" onclick="dialog.closeByHand()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
</div>
</body>
</html>

<script language=javascript><!--
	var parentWin = null;
	var dialog = null;
	try{
		parentWin = parent.parent.getParentWindow(parent);
		dialog = parent.parent.getDialog(parent);
	}catch(e){}

    function menuhidden(){
        rightMenu.style.visibility="hidden";
    }

    var iscnodefree = "<%=iscnodefree%>";
    function onSave(obj) {
        if (check_form(document.FreeWorkflowSetform,document.FreeWorkflowSetform.checkfield.value)){
            document.FreeWorkflowSetform.submit();
            obj.disabled=true;
        }
    }

    function onClose() {
        if(dialog) {
			try {
				dialog.close();
			} catch(e) {}
		} else {
			window.parent.close();
		}
    }

    function addStep() {
        var oTable=document.all('freewfoTable');
	    var curindex=parseInt(document.all('rownum').value);
	    var rowindex=parseInt(document.all('indexnum').value);
	    var ncol = 5;
	    var oRow = oTable.insertRow(-1);
	    for(j=0; j<ncol; j++) {
	        var oCell = oRow.insertCell(-1);
			oCell.style.height = 24;
			oCell.style.background= "rgb(245, 250, 250)";
			switch(j) {
	            case 0:
	            {
	                var oDiv = document.createElement("div");
	                var sHtml = "<input type='checkbox' class=inputstyle name='check_node' value='"+rowindex+"'>";
	                oDiv.innerHTML = sHtml;
	                oCell.style.width = "8%";
	                oCell.appendChild(oDiv);
	                jQuery(oDiv).jNice();
	                break;
	            }
	            case 1:
	            {
	                var oDiv = document.createElement("div");
	                var sHtml = "<input type='text' class='inputstyle input styled' name='floworder_"+rowindex+"' size='5' maxlength='3' value='"+(rowindex+1)+"'>";
	                oDiv.innerHTML = sHtml;
	                oCell.style.width = "10%";
	                oCell.appendChild(oDiv);
	                break;
	            }
	            case 2:
	            {
	                var oDiv = document.createElement("div");
	                var sHtml = "<input type='text' class='inputstyle input styled' name='nodename_"+rowindex+"' value='<%=SystemEnv.getHtmlLabelName(18731, user.getLanguage())%>"+(rowindex+1)+"' onBlur=\"checkinput('nodename_"+rowindex+"','nodenamespan_"+rowindex+"');checkstr('nodename_"+rowindex+"',60)\" >";
	                sHtml+="<span id='nodenamespan_"+rowindex+"'></span>";
	                oDiv.innerHTML = sHtml;
	                oCell.style.width = "35%";
	                oCell.appendChild(oDiv);
	                break;
	            }
	            case 3:
	            {
	                var oDiv = document.createElement("div");
	                var sHtml = "<select class=inputstyle name='Signtype_"+rowindex+"'>";
	                sHtml+="<option value='0'><%=SystemEnv.getHtmlLabelName(15556, user.getLanguage())%></option>";
	                sHtml+="<option value='1'><%=SystemEnv.getHtmlLabelName(15557, user.getLanguage())%></option>";
	                sHtml+="<option value='2'><%=SystemEnv.getHtmlLabelName(15558, user.getLanguage())%></option>";
	                sHtml+="</select>";
	                oDiv.innerHTML = sHtml;
	                oCell.style.width = "23%";
	                oCell.appendChild(oDiv);
	    			jQuery('select', oDiv).selectbox();
	                break;
	            }
	            case 4:
	            {
	                var oDiv = document.createElement("div");
	                var sHtml = "<button type=button  class=Browser onclick=\"ShowMultiResource('operatorsspan_"+rowindex+"','operators_"+
	                            rowindex+"')\"></button><SPAN id='operatorsspan_"+rowindex+
	                            "'><IMG src='/images/BacoError_wev8.gif' align=absMiddle></SPAN><input type='hidden' class=inputstyle name='operators_"+rowindex+"'>";
	                oDiv.innerHTML = sHtml;
	                oCell.style.width = "24%";
	                oCell.appendChild(oDiv);
	                break;
	            }
	        }
	    }
	    document.all('checkfield').value = document.all('checkfield').value+"nodename_"+rowindex+",operators_"+rowindex+",";
	    document.all("rownum").value = curindex+1 ;
	    document.all('indexnum').value = rowindex+1;
    }
    
    function addStep1() {
        var oTable=document.all('freewfoTable');
	    var curindex=parseInt(document.all('rownum').value);
	    var rowindex=parseInt(document.all('indexnum').value);
	    var ncol = 4;
	    var oRow = oTable.insertRow(-1);
	    for(j=0; j<ncol; j++) {
	        var oCell = oRow.insertCell(-1);
			oCell.style.height = 24;
			oCell.style.background= "rgb(245, 250, 250)";
			switch(j) {
	            case 0:
	            {
	                var oDiv = document.createElement("div");
	                var sHtml = "<input type='checkbox' class=inputstyle name='check_node' value='"+rowindex+"'>";
	                oDiv.innerHTML = sHtml;
	                oCell.style.width = "8%";
	                oCell.appendChild(oDiv);
	                jQuery(oDiv).jNice();
	                break;
	            }
	            case 1:
	            {
	                var oDiv = document.createElement("div");
	                var sHtml = "<input type='text' class='inputstyle input styled' name='floworder_"+rowindex+"' size='5' maxlength='3' value='"+(rowindex+1)+"'>";
	                oDiv.innerHTML = sHtml;
	                oCell.style.width = "10%";
	                oCell.appendChild(oDiv);
	                break;
	            }
	            case 2:
	            {
	                var oDiv = document.createElement("div");
	                var sHtml = "<input type='text' class='inputstyle input styled' name='nodename_"+rowindex+"' value='<%=SystemEnv.getHtmlLabelName(18731, user.getLanguage())%>"+(rowindex+1)+"' onBlur=\"checkinput('nodename_"+rowindex+"','nodenamespan_"+rowindex+"');checkstr('nodename_"+rowindex+"',60)\" >";
	                sHtml+="<span id='nodenamespan_"+rowindex+"'></span>";
	                oDiv.innerHTML = sHtml;
	                oCell.style.width = "35%";
	                oCell.appendChild(oDiv);
	                break;
	            }
	            case 3:
	            {
	                var oDiv = document.createElement("div");
	                var sHtml = "<button type=button  class=Browser onclick=\"ShowMultiResource('operatorsspan_"+rowindex+"','operators_"+
	                            rowindex+"')\"></button><SPAN id='operatorsspan_"+rowindex+
	                            "'><IMG src='/images/BacoError_wev8.gif' align=absMiddle></SPAN><input type='hidden' class=inputstyle name='operators_"+rowindex+"'>";
	                oDiv.innerHTML = sHtml;
	                oCell.style.width = "24%";
	                oCell.appendChild(oDiv);
	                break;
	            }
	        }
	    }
	    document.all('checkfield').value = document.all('checkfield').value+"nodename_"+rowindex+",operators_"+rowindex+",";
	    document.all("rownum").value = curindex+1 ;
	    document.all('indexnum').value = rowindex+1;
    }

    function delStep(){
        var oTable=document.all('freewfoTable');
        curindex=parseInt(document.all("rownum").value);
        len = document.FreeWorkflowSetform.elements.length;
        var i=0;
        var rowsum1 = 0;
        var checknum=0;
        for(i=len-1; i >= 0;i--) {
            if (document.FreeWorkflowSetform.elements[i].name=='check_node'){
                rowsum1 += 1;
                if(document.FreeWorkflowSetform.elements[i].checked==true) checknum+=1;
            }
        }
        if(checknum>0) {
        	top.Dialog.confirm('<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>', function() {
        		for(i=len-1; i >= 0;i--) {
                    if (document.FreeWorkflowSetform.elements[i].name=='check_node'){
                        if(document.FreeWorkflowSetform.elements[i].checked==true) {
                            document.all('checkfield').value = (document.all('checkfield').value).replace("nodename_"+document.FreeWorkflowSetform.elements[i].value+",","");
                            document.all('checkfield').value = (document.all('checkfield').value).replace("operators_"+document.FreeWorkflowSetform.elements[i].value+",","");
                            oTable.deleteRow(rowsum1+2);
                            curindex--;
                        }
                        rowsum1 -=1;
                    }
                }
                document.all("rownum").value=curindex;
        	});
        }else{
            top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15543,user.getLanguage())%>");
        }
    }

    function picreload(){
    	/*新的流程图的id：piciframe；老的流程图的id：picInnerFrame；流程图iframe的上层节点的id：divWfPic*/
    	/*
    	try{
    		dialogArguments.parent.document.frames("piciframe").location.reload(true);
    	}catch(ex){
    		try{
    			var _divWfPic=dialogArguments.parent.document.getElementById("divWfPic");
    			_divWfPic.innerHTML="<IFRAME src='' id=piciframe name=piciframe style='width:100%;height:100%' BORDER=0 FRAMEBORDER=no NORESIZE=NORESIZE scrolling='auto'></IFRAME>";
    		}catch(ex){
    			alert("ex2="+ex.message);
    		}
    	}
    	*/
        //dialogArguments.document.all("picframe").src=dialogArguments.document.all("picframe").src;
       /*
        var piciframe=jQuery("#piciframe",top.dialogArguments.parent.document);
        if(piciframe.length==0){
    	    var _divWfPic=top.dialogArguments.parent.document.getElementById("divWfPic");
    	    _divWfPic.innerHTML="<IFRAME src='' id=piciframe name=piciframe style='width:100%;height:100%' BORDER=0 FRAMEBORDER=no NORESIZE=NORESIZE scrolling='auto'></IFRAME>";
    	}else{
    	    piciframe.attr("src",piciframe.attr("src"));
    	}
    	
        */
        jQuery('#divWfPic', top.document).html("<IFRAME src='' id=piciframe name=piciframe style='width:100%;height:100%' BORDER=0 FRAMEBORDER=no NORESIZE=NORESIZE scrolling='auto'></IFRAME>");
        if(iscnodefree == "0"){
        	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22527,user.getLanguage())%>");
        }else{
        	if(parentWin) {
    			try {
    				parentWin.doSubmitBack();
    			} catch(e) {}
    		} else {
    			window.parent.parentWin.doSubmitBack();
    		}
        }
        onClose();
        //dialogArguments.alert("<%=SystemEnv.getHtmlLabelName(22527,user.getLanguage())%>");
    }

	jQuery(document).ready(function() {
		<%
	    if(src.equals("save")){
	    if(saveflag){
	    %>
	    picreload();
	    <%
	    }else{
	    %>
	    top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(21809,user.getLanguage())%>");
	    <%
	    }
	    }
	    %>
	    menuhidden();
	});

function ShowMultiResource(spanname,hiddenidname) {	
	var browserDialog = new top.Dialog();
	browserDialog.Width = 550;
	browserDialog.Height = 600;
	browserDialog.URL = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=" + $G(hiddenidname).value;
	browserDialog.Title = '<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%>';
	browserDialog.checkDataChange = false;
	browserDialog.callback = function(data) {
		browserDialog.close();
		var rid = wuiUtil.getJsonValueByIndex(data, 0);
		var rname = wuiUtil.getJsonValueByIndex(data, 1);

		if (rid != "" && rid != "0") {
            $G(spanname).innerHTML = rname;
            $G(hiddenidname).value= rid;
	    } else {
            $G(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
            $G(hiddenidname).value = "";
        }
	};
	browserDialog.show();
}



function checkstr(inputname, len) {
	var str = $G(inputname).value;
	var newLength = 0;
	var newStr = "";
	var chineseRegex = /[^\x00-\xff]/g;
	var singleChar = "";
	var strLength = str.replace(chineseRegex, "**").length;
	for (var i = 0; i < strLength; i++) {
		singleChar = str.charAt(i).toString();
		if (singleChar.match(chineseRegex) != null) {
			newLength += 2;
		} else {
			newLength++;
		}
		if (newLength > len) {
			break;
		}
		newStr += singleChar;
	}
	//return newStr;
	$G(inputname).value = newStr ;
}
--></script>
<!-- 
<script language="VBScript">
sub ShowMultiResource(spanname,hiddenidname)
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+hiddenidname.value)
	if (Not IsEmpty(id)) then
        If id(0) <> "" and id(0) <> "0" Then
            spanname.innerHtml = Mid(id(1),2,len(id(1)))
            hiddenidname.value= Mid(id(0),2,len(id(0)))
	    else
            spanname.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
            hiddenidname.value=""
        end if
    end if
end sub
</script>
 -->