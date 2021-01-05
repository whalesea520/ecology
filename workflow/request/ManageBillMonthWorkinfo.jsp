<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/workflow/request/WorkflowManageRequestTitle.jsp" %>
<!--请求的标题开始 -->
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/js/ecology8/weaverautocomplete/css/weaverautocomplete_wev8.css">
<script type="text/javascript" src="../../js/weaver_wev8.js"></script>

<!--签字意见-->
<link rel="stylesheet" type="text/css" href="/css/ecology8/workflowsign_wev8.css" />

<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<!-- browser 相关 -->
<script type="text/javascript" src="/js/workflow/wfbrow_wev8.js"></script>
<script type='text/javascript' src="/js/ecology8/request/autoSelect_wev8.js"></script>
<link type="text/css" href="/js/ecology8/base/jquery-ui_wev8.css" rel=stylesheet>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type="text/javascript" src="/js/jquery-autocomplete/jquery.autocomplete_wev8.js"></script>
<!-- 明细样式 -->
<link href="/css/ecology8/workflowdetail_wev8.css" type="text/css" rel="stylesheet">
<script type="text/javascript">
window.__userid = '<%=request.getParameter("f_weaver_belongto_userid")%>';
window.__usertype = '<%=request.getParameter("f_weaver_belongto_usertype")%>';
</script>

<form name="frmmain" method="post" action="BillMonthWorkinfoOperation.jsp" enctype="multipart/form-data">
<input type="hidden" name="needwfback" id="needwfback" value="1" />
<input type="hidden" name="lastOperator"  id="lastOperator" value="<%=lastOperator%>"/>
<input type="hidden" name="lastOperateDate"  id="lastOperateDate" value="<%=lastOperateDate%>"/>
<input type="hidden" name="lastOperateTime"  id="lastOperateTime" value="<%=lastOperateTime%>"/>

 <%@ include file="/workflow/request/WorkflowManageRequestBody.jsp" %>   
 <%
    
    int rowindex1=0;
    int rowindex2=0;
    
 %>
<table class="viewform" style="width:100%">
	  <tr><td height=15></td></tr>
<%if(!nodetype.equals("0")||(nodetype.equals("0")&&isremark!=0)) {
		rowindex1=0;
		rowindex2=0;
	%>
    <tr> 
		<th colspan=2 align=center><%=SystemEnv.getHtmlLabelName(16276,user.getLanguage())%></th>
	</tr>
	<tr class="Title"> 
      <td colspan=2>
	  <table class="viewform" style="width:100%">
	  <!-- 工作总结 -->
      <TR class="Spacing">
    	  <TD class="Line1"></TD></TR>
	  <tr><td>
	    <table class="ListStyle ViewForm" cellspacing=1   cols=4 id="oTable1" style="width:100%">
	      <COLGROUP> 
	      <COL width="10%"><COL width="30%"> <COL width="30%"><COL width="30%">
	      <tr class=header> 
	        <td>&nbsp;</td>
	        <td><%=SystemEnv.getHtmlLabelName(16274,user.getLanguage())%></td>
	        <td><%=SystemEnv.getHtmlLabelName(15488,user.getLanguage())%></td>
	        <td><%=SystemEnv.getHtmlLabelName(16275,user.getLanguage())%></td>
	      </tr>
<%	boolean islight=true;
	 String ids=",";
	RecordSet.executeProc("bill_monthinfodetail_SByType",""+billid+flag+"2");
	while(RecordSet.next()){
		String curid=RecordSet.getString("id");
		String curworkdesc=RecordSet.getString("targetresult");
		String curscale=RecordSet.getString("scale");
		String curpoint=RecordSet.getString("point");
        ids=ids+curid+",";
		if(curpoint.equals("0"))	curpoint="";
%>
		  <tr class="wfdetailrowblock">
		  <td>&nbsp;<input type="hidden" name="type1_<%=rowindex1%>_id" value="<%=curid%>"></td>
		  <td><%=Util.toScreen(curworkdesc,user.getLanguage())%><input type = "hidden" name="type1_<%=rowindex1%>_result" value="<%=Util.toScreen(curworkdesc,user.getLanguage())%>"></td>
		  <td><%=Util.toScreen(curscale,user.getLanguage())%>%<input type = "hidden" name="type1_<%=rowindex1%>_scale" value="<%=Util.toScreen(curscale,user.getLanguage())%>"></td>
		  <%if(nodetype.equals("1")){%>
		  <td><input type=text name="type1_<%=rowindex1%>_point" size=10
		  value="<%=Util.toScreenToEdit(curpoint,user.getLanguage())%>"
		  onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this)' maxlength=4>
		  <input type=hidden name="type1_<%=rowindex1%>_id" value="<%=curid%>"></td>
		  <%} else {%>
		  <td><%=Util.toScreen(curpoint,user.getLanguage())%><input type = "hidden" name="type1_<%=rowindex1%>_point" value="<%=Util.toScreen(curpoint,user.getLanguage())%>"></td>
		  <%}%>
		  </tr>
<%
		islight=!islight;
		rowindex1++;
	}
%>
	    <input type="hidden" name="type1_id" value="<%=ids%>"></table>
	   </td></tr>
      </table>
      </td>
    </tr> 
    <!-- 工作计划 -->
    <tr> 
		<th colspan=2 align=center><%=SystemEnv.getHtmlLabelName(16272,user.getLanguage())%></th>
	</tr>
	<tr class="Title"> 
      <td colspan=2>
	  <table class="viewform" style="width:100%">
	  <!-- 完成事项 -->
      <TR class="Spacing">
    	  <TD class="Line1"></TD></TR>
	  <tr><td>
	    <table class="ListStyle ViewForm" cols=5 id="oTable2">
	      <COLGROUP> 
	      <COL width="10%"><COL width="20%"> <COL width="20%"><COL width="20%"><COL width="20%">
	      <tr class=header> 
	        <td>&nbsp;</td>
	        <td><%=SystemEnv.getHtmlLabelName(16272,user.getLanguage())%></td>
	        <td><%=SystemEnv.getHtmlLabelName(15492,user.getLanguage())%></td>
	        <td><%=SystemEnv.getHtmlLabelName(1035,user.getLanguage())%></td>
	        <td><%=SystemEnv.getHtmlLabelName(15488,user.getLanguage())%></td>
	      </tr>
<%	islight=true;
	ids=",";
	RecordSet.executeProc("bill_monthinfodetail_SByType",""+billid+flag+"1");
	while(RecordSet.next()){
		String curid=RecordSet.getString("id");
		String curworkname=RecordSet.getString("targetname");
		String curworkdesc=RecordSet.getString("targetresult");
		String curdate=RecordSet.getString("forecastdate");
		String curscale=RecordSet.getString("scale");
		ids=ids+curid+",";
%>
		  <tr class="wfdetailrowblock">
		  <td>&nbsp;<input type="hidden" name="type2_<%=rowindex2%>_id" value="<%=curid%>"></td>
		  <td><%=Util.toScreen(curworkname,user.getLanguage())%><input type = "hidden" name="type2_<%=rowindex2%>_name" value="<%=Util.toScreen(curworkname,user.getLanguage())%>"></td>
		  <td><%=Util.toScreen(curworkdesc,user.getLanguage())%><input type = "hidden" name="type2_<%=rowindex2%>_desc" value="<%=Util.toScreen(curworkdesc,user.getLanguage())%>"></td>
		  <td><%=Util.toScreen(curdate,user.getLanguage())%><input type = "hidden" name="type2_<%=rowindex2%>_date" value="<%=Util.toScreen(curdate,user.getLanguage())%>"></td>
		  <td><%=Util.toScreen(curscale,user.getLanguage())%>%<input type = "hidden" name="type2_<%=rowindex2%>_scale" value="<%=Util.toScreen(curscale,user.getLanguage())%>"></td>
		  </tr>
<%
		islight=!islight;
		rowindex2++;
	}
%>
	    <input type="hidden" name="type2_id" value="<%=ids%>"></table>
	   </td></tr>
      </table>
      </td>
    </tr>  
<%} else {	
	rowindex1=0;
	rowindex2=0;
	%>
    <tr> 
		<th colspan=2 align=center><%=SystemEnv.getHtmlLabelName(16276,user.getLanguage())%></th>
	</tr>
	<tr class="Title"> 
      <td colspan=2>
	  <table class="viewform" style="width:100%">
	  <!-- 工作总结 -->
	  <tr><td>
		<BUTTON Class=BtnFlow type=button accessKey=A onclick="addRow1()"><U>A</U>-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></BUTTON>
		<BUTTON Class=BtnFlow type=button accessKey=E onclick="deleteRow1()"><U>E</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
		<br> </td>
      </tr>
      <TR class="Spacing">
    	  <TD class="Line1"></TD></TR>
	  <tr><td>
	    <table class="ListStyle ViewForm" cols=4 id="oTable1">
	      <COLGROUP> 
	      <COL width="10%"><COL width="30%"> <COL width="30%"><COL width="30%">
	      <tr class=header> 
	        <td>&nbsp;</td>
	        <td><%=SystemEnv.getHtmlLabelName(16274,user.getLanguage())%></td>
	        <td><%=SystemEnv.getHtmlLabelName(15488,user.getLanguage())%></td>
	        <td><%=SystemEnv.getHtmlLabelName(16275,user.getLanguage())%></td>
	      </tr>
<%	boolean islight=true;
	String ids=",";
	RecordSet.executeProc("bill_monthinfodetail_SByType",""+billid+flag+"2");
	while(RecordSet.next()){
        String curid=RecordSet.getString("id");
		String curworkdesc=RecordSet.getString("targetresult");
		String curscale=RecordSet.getString("scale");
		String curpoint=RecordSet.getString("point");
		ids=ids+curid+",";
		if(curpoint.equals("0"))	curpoint="";
		needcheck += ",type1_"+rowindex1+"_result";
%>
		  <tr class="wfdetailrowblock">
		  <td><input type="hidden" name="type1_<%=rowindex1%>_id" value="<%=curid%>"><input type=checkbox name="check_type1" value=<%=rowindex1%>></td>
		  <td><textarea class="inputstyle" id="type1_<%=rowindex1%>_result" name="type1_<%=rowindex1%>_result" temptitle="<%=SystemEnv.getHtmlLabelName(16274,user.getLanguage())%>" rows=2 style="width:80%" viewtype="1" onChange="checkinput2('type1_<%=rowindex1%>_result','type1_<%=rowindex1%>_resultspan',this.getAttribute('viewtype'));"><%=Util.toScreenToEdit(curworkdesc,user.getLanguage())%></textarea>
				<span id="type1_<%=rowindex1%>_resultspan"><%if("".equals(Util.toScreenToEdit(curworkdesc,user.getLanguage()).trim())){%><img src="/images/BacoError_wev8.gif" align="absmiddle"><%}%></span>
				</td>
		  <td><input type=input class=inputstyle  name="type1_<%=rowindex1%>_scale" style="width:60%" 
		  value="<%=Util.toScreen(curscale,user.getLanguage())%>" 
		  onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this);checkinput1(type1_<%=rowindex1%>_scale,type1_<%=rowindex1%>_scalespan)'>%
		  <span id='type1_<%=rowindex1%>_scalespan'></span>
		  </td>
		  <td>&nbsp;</td>
		  </tr>
<%
		islight=!islight;
		rowindex1++;
	}
%>
	    <input type="hidden" name="type1_id" value="<%=ids%>"></table>
	   </td></tr>
      </table>
      </td>
    </tr> 
    
    <tr> 
		<th colspan=2 align=center><%=SystemEnv.getHtmlLabelName(16272,user.getLanguage())%></th>
	</tr>
	<tr class="Title"> 
      <td colspan=2>
	  <table class="viewform" style="width:100%">
	  <!-- 完成事项 -->
	  <tr><td>
		<BUTTON Class=BtnFlow type=button accessKey=N onclick="addRow2()"><U>N</U>-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></BUTTON>
		<BUTTON Class=BtnFlow type=button accessKey=D onclick="deleteRow2()"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
		<br> </td>
      </tr>
      <TR class="Spacing">
    	  <TD class="Line1"></TD></TR>
	  <tr><td>
	    <table class="ListStyle ViewForm" cols=5 id="oTable2">
	      <COLGROUP> 
	      <COL width="10%"><COL width="20%"> <COL width="20%"><COL width="20%"><COL width="20%">
	      <tr class=header> 
	        <td>&nbsp;</td>
	        <td><%=SystemEnv.getHtmlLabelName(16272,user.getLanguage())%></td>
	        <td><%=SystemEnv.getHtmlLabelName(15492,user.getLanguage())%></td>
	        <td><%=SystemEnv.getHtmlLabelName(1035,user.getLanguage())%></td>
	        <td><%=SystemEnv.getHtmlLabelName(15488,user.getLanguage())%></td>
	      </tr>
<%	islight=true;
     ids=",";
	RecordSet.executeProc("bill_monthinfodetail_SByType",""+billid+flag+"1");
	while(RecordSet.next()){
		String curid=RecordSet.getString("id");
		String curworkname=RecordSet.getString("targetname");
		String curworkdesc=RecordSet.getString("targetresult");
		String curdate=RecordSet.getString("forecastdate");
		String curscale=RecordSet.getString("scale");
		ids=ids+curid+",";
		needcheck += ",type2_"+rowindex2+"_name";
%>
		  <tr class="wfdetailrowblock">
		  <td><input type="hidden" name="type2_<%=rowindex2%>_id" value="<%=curid%>"><input type=checkbox name="check_type2" value=<%=rowindex2%>></td>
		  <td><input type="text" class="inputstyle" id="type2_<%=rowindex2%>_name" name="type2_<%=rowindex2%>_name" temptitle="<%=SystemEnv.getHtmlLabelName(16272,user.getLanguage())%>" style="width:80%" onChange="checkinput2('type2_<%=rowindex2%>_name','type2_<%=rowindex2%>_namespan','1');" value="<%=Util.toScreenToEdit(curworkname,user.getLanguage())%>">
				<span id="type2_<%=rowindex2%>_namespan"><%if("".equals(Util.toScreenToEdit(curworkname,user.getLanguage()).trim())){%><img src='/images/BacoError_wev8.gif' align='absmiddle'><%}%></span>
				</td>
		  <td><input type=input class=inputstyle  name="type2_<%=rowindex2%>_desc" style=width:80% value='<%=Util.toScreenToEdit(curworkdesc,user.getLanguage())%>' onchange='checkinput1(type2_<%=rowindex2%>_desc,type2_<%=rowindex2%>_descspan)'>
    		      <span id='type2_<%=rowindex2%>_descspan'></span>
    	  </td>
		  <td><button class=Calendar type='button' onClick='onShowDate(type2_<%=rowindex2%>_datespan,type2_<%=rowindex2%>_date)'></button>
		  <span id='type2_<%=rowindex2%>_datespan'><%=curdate%></span>
		  <input type=hidden name=type2_<%=rowindex2%>_date value="<%=curdate%>">
		  </td>
		  <td><input type=input class=inputstyle  name="type2_<%=rowindex2%>_scale" style="width:80%" 
		  value="<%=Util.toScreenToEdit(curscale,user.getLanguage())%>"
		  onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this);checkinput1(type2_<%=rowindex2%>_scale,type2_<%=rowindex2%>_scalespan)'>%
		  <span id='type2_<%=rowindex2%>_scalespan'></span>
		  </td>
		  </tr>
<%
		islight=!islight;
		rowindex2++;
	}
%>
	   <input type="hidden" name="type2_id" value="<%=ids%>"> </table>
	   </td></tr>
      </table>
      </td>
    </tr>
<%}%>
    </td>
  </tr>
  <tr><td height=15></td></tr>
  <%if(nodetype.equals("1")){ %>
  <tr>
  	<td><%=SystemEnv.getHtmlLabelName(16328,user.getLanguage())%></td>
  	<td>
  		<table border=1 class="viewform" style="width:60%">
  		<tr>
  		<td width=10%><%=SystemEnv.getHtmlLabelName(15700,user.getLanguage())%> </td>
  		<td width=10%><%=SystemEnv.getHtmlLabelName(16329,user.getLanguage())%> </td>
  		<td width=10%><%=SystemEnv.getHtmlLabelName(16330,user.getLanguage())%> </td>
  		<td width=10%><%=SystemEnv.getHtmlLabelName(16131,user.getLanguage())%> </td>
  		<td width=10%><%=SystemEnv.getHtmlLabelName(15660,user.getLanguage())%> </td>
  		</tr>
  		<tr>
  		<td width=10%>5</td>	
  		<td width=10%>4</td>	
  		<td width=10%>3</td>	
  		<td width=10%>2</td>	
  		<td width=10%>1</td>	
  		</tr>
  		</table>
  	</td>
  </tr>
  <%}%>  
  </table>
  <br>
<%@ include file="/workflow/request/WorkflowManageSign.jsp" %>
<input type="hidden" value="0" name="nodesnum1">
<input type="hidden" value="0" name="nodesnum2">
<input type="hidden" value="0" id="needcheck" name="needcheck" value="<%=needcheck%>">
<input type=hidden name="f_weaver_belongto_userid" value=<%=f_weaver_belongto_userid%>>
<input type=hidden name ="f_weaver_belongto_usertype" value="<%=f_weaver_belongto_usertype%>">
</form>
<script language="JavaScript" src="/js/addRowBg_wev8.js" >   
</script>   
<script language=javascript>
rowindex1 = <%=rowindex1%> ;
rowindex2 = <%=rowindex2%> ;
var rowColor="" ;
function addRow1(){	
	var oTable=$GetEle('oTable1');
	var ncol = oTable1.rows[0].cells.length;
	var oRow = oTable1.insertRow(-1);
	oRow.className = "wfdetailrowblock";
	jQuery(oRow).hover(function () {
    	jQuery(this).addClass("Selected");
    }, function () {
    	jQuery(this).removeClass("Selected");
    });
	
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1);  
		oCell.style.height=24;
		oCell.style.background= rowColor;
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_type1' value="+rowindex1+">"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<textarea class=inputstyle rows='2' id='type1_"+rowindex1+"_result' name='type1_"+rowindex1+"_result' temptitle='<%=SystemEnv.getHtmlLabelName(16274,user.getLanguage())%>' style='width:80%' viewtype='1' onChange=\"checkinput2('type1_"+rowindex1+"_result','type1_"+rowindex1+"_resultspan',this.getAttribute('viewtype'));\"></textarea><span id='type1_"+rowindex1+"_resultspan'><img src='/images/BacoError_wev8.gif' align='absmiddle'></span>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);
				break;
			case 2: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input class=inputstyle  type='input' name='type1_"+rowindex1+"_scale' style='width=60%' onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this);checkinput1(type1_"+rowindex1+"_scale,type1_"+rowindex1+"_scalespan)'>%"+
				            "<span id='type1_"+rowindex1+"_scalespan'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);   
				break;
			case 3: 
				var oDiv = document.createElement("div"); 
				var sHtml = "&nbsp;";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
		}
	}
	rowindex1 = rowindex1*1 +1;
	document.getElementById("needcheck").value = document.getElementById("needcheck").value + ",type1_"+rowindex1+"_result";
}

function deleteRow1()
{
    var flag = false;
	var ids = document.getElementsByName('check_type1');
	for(i=0; i<ids.length; i++) {
		if(ids[i].checked==true) {
			flag = true;
			break;
		}
	}
    if(flag) {
		if(isdel()){
            len = document.forms[0].elements.length;
            var i=0;
            var rowsum1 = 0;
            for(i=len-1; i >= 0;i--) {
                if (document.forms[0].elements[i].name=='check_type1')
                    rowsum1 ++;
            }
            for(i=len-1; i >= 0;i--) {
                if (document.forms[0].elements[i].name=='check_type1'){
                    if(document.forms[0].elements[i].checked==true)
                        oTable1.deleteRow(rowsum1);
                    rowsum1--;
                }
            }
        }
    }else{
        alert('<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>');
		return;
    }
}	
function addRow2(){	
	var oTable=$GetEle('oTable2');
	var ncol = oTable2.rows[0].cells.length;
	var oRow = oTable2.insertRow(-1);
	oRow.className = "wfdetailrowblock";
	jQuery(oRow).hover(function () {
    	jQuery(this).addClass("Selected");
    }, function () {
    	jQuery(this).removeClass("Selected");
    });
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1);  
		oCell.style.height=24;
		oCell.style.background=rowColor;
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_type2' value="+rowindex2+">"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type='text' class='inputstyle' id='type2_"+rowindex2+"_name' name='type2_"+rowindex2+"_name' temptitle='<%=SystemEnv.getHtmlLabelName(16272,user.getLanguage())%>' style='width:80%' onChange=\"checkinput2('type2_"+rowindex2+"_name','type2_"+rowindex2+"_namespan','1');\"><span id='type2_"+rowindex2+"_namespan'><img src='/images/BacoError_wev8.gif' align='absmiddle'></span>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);
				break;
			case 2: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input class=inputstyle  type='input' name='type2_"+rowindex2+"_desc' style='width=80%' onchange='checkinput1(type2_"+rowindex2+"_desc,type2_"+rowindex2+"_descspan)'>"+
				            "<span id='type2_"+rowindex2+"_descspan'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
			case 3: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<button class=Calendar type='button' onClick='onShowDate(type2_"+rowindex2+"_datespan,type2_"+rowindex2+"_date)'></button> " + 
        					"<span class=Inputstyle id=type2_"+rowindex2+"_datespan><img src='/images/BacoError_wev8.gif' align=absmiddle></span> "+
        					"<input type='hidden' name='type2_"+rowindex2+"_date' id='type2_"+rowindex2+"_date'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
			case 4: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input class=inputstyle  type='input' name='type2_"+rowindex2+"_scale' style='width=60%' onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this);checkinput1(type2_"+rowindex2+"_scale,type2_"+rowindex2+"_scalespan)'>%"+
				            "<span id='type2_"+rowindex2+"_scalespan'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
		}
	}
	rowindex2 = rowindex2*1 +1;
	document.getElementById("needcheck").value = document.getElementById("needcheck").value + ",type2_"+rowindex2+"_name";
}

function deleteRow2()
{
    var flag = false;
	var ids = document.getElementsByName('check_type2');
	for(i=0; i<ids.length; i++) {
		if(ids[i].checked==true) {
			flag = true;
			break;
		}
	}
    if(flag) {
		if(isdel()){
            len = document.forms[0].elements.length;
            var i=0;
            var rowsum1 = 0;
            for(i=len-1; i >= 0;i--) {
                if (document.forms[0].elements[i].name=='check_type2')
                    rowsum1 ++;
            }
            for(i=len-1; i >= 0;i--) {
                if (document.forms[0].elements[i].name=='check_type2'){
                    if(document.forms[0].elements[i].checked==true)
                        oTable2.deleteRow(rowsum1);
                    rowsum1--;
                }
            }
        }
    }else{
        alert('<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>');
		return;
    }
}

	
function DateCompare(YearFrom, MonthFrom, DayFrom,YearTo, MonthTo,DayTo)
{  
    YearFrom  = parseInt(YearFrom,10);
    MonthFrom = parseInt(MonthFrom,10);
    DayFrom = parseInt(DayFrom,10);
    YearTo    = parseInt(YearTo,10);
    MonthTo   = parseInt(MonthTo,10);
    DayTo = parseInt(DayTo,10);
    if(YearTo<YearFrom)
    return false;
    else{
        if(YearTo==YearFrom){
            if(MonthTo<MonthFrom)
            return false;
            else{
                if(MonthTo==MonthFrom){
                    if(DayTo<DayFrom)
                    return false;
                    else
                    return true;
                }
                else 
                return true;
            }
            }
        else
        return true;
        }
}

	
	function checktimeok(){
	if ("<%=newenddate%>"!="b" && "<%=newfromdate%>"!="a" && document.frmmain.<%=newenddate%>.value != ""){
				YearFrom=document.frmmain.<%=newfromdate%>.value.substring(0,4);
				MonthFrom=document.frmmain.<%=newfromdate%>.value.substring(5,7);
				DayFrom=document.frmmain.<%=newfromdate%>.value.substring(8,10);
				YearTo=document.frmmain.<%=newenddate%>.value.substring(0,4);
				MonthTo=document.frmmain.<%=newenddate%>.value.substring(5,7);
				DayTo=document.frmmain.<%=newenddate%>.value.substring(8,10);
				// window.alert(YearFrom+MonthFrom+DayFrom);
	                   if (!DateCompare(YearFrom, MonthFrom, DayFrom,YearTo, MonthTo,DayTo )){
	        window.alert("<%=SystemEnv.getHtmlLabelName(15273,user.getLanguage())%>");
	         return false;
	  			 }
	  }
	     return true; 
	}



	function doRemark(){
		//parastr = document.getElementById("needcheck").value;
		parastr = "<%=needcheck%>" ;
		document.frmmain.isremark.value='1';
		document.frmmain.src.value='save';
		document.frmmain.nodesnum1.value=rowindex1;
		document.frmmain.nodesnum2.value=rowindex2;
		document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
		//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
	}
	function doSave_n(obj){
		//parastr = document.getElementById("needcheck").value;
		parastr = "<%=needcheck%>" ;
		len = document.forms[0].elements.length;
        var i=0;
        tmpscale1=0;
	    tmpscale2=0;
        for(i=len-1; i >= 0;i--) {
        	if (document.forms[0].elements[i].name=='check_type1')
        		parastr+=",type1_"+document.forms[0].elements[i].value+"_scale";
        }
        for(i=len-1; i >= 0;i--) {
        	if (document.forms[0].elements[i].name=='check_type2')
        		parastr+=",type2_"+document.forms[0].elements[i].value+"_desc";
        		parastr+=",type2_"+document.forms[0].elements[i].value+"_date";
        		parastr+=",type2_"+document.forms[0].elements[i].value+"_scale";
        }
        for(i=len-1; i >= 0;i--){
        	for(j=rowindex1; j >= 0;j--) {
        	    if (document.forms[0].elements[i].name==('type1_'+j+'_scale'))
        	        tmpscale1+=eval(document.forms[0].elements[i].value);
        	}
        }
        if(tmpscale1>100){
            alert("<%=SystemEnv.getHtmlLabelName(16277,user.getLanguage())%>");
            return;
        }
        for(i=len-1; i >= 0;i--){
        	for(j=rowindex2; j >= 0;j--) {
        	    if (document.forms[0].elements[i].name==('type2_'+j+'_scale'))
        	        tmpscale2+=eval(document.forms[0].elements[i].value);
        	}
        }
        if(tmpscale2>100){
            alert("<%=SystemEnv.getHtmlLabelName(16278,user.getLanguage())%>");
            return;
        }
        
        for(i=len-1; i >= 0;i--){
        	for(j=rowindex2; j >= 0;j--) {
        	    if (document.forms[0].elements[i].name==('type1_'+j+'_point'))
        	        if(document.forms[0].document.forms[0].elements[i].value>5){
                        alert("<%=SystemEnv.getHtmlLabelName(16331,user.getLanguage())%>");
                        return;
                    }    
        	}
        }
		//if(check_form(document.frmmain,parastr)){
		if(check_form(document.frmmain, "requestname")){
			document.frmmain.src.value='save';
			document.frmmain.nodesnum1.value=rowindex1;
			document.frmmain.nodesnum2.value=rowindex2;
			if(checktimeok()){
				jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
			 //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
			}
		}
		
	}
	
	function doSubmit(obj){
		//parastr = document.getElementById("needcheck").value;
		parastr = "<%=needcheck%>" ;
		len = document.forms[0].elements.length;
        var i=0;
        tmpscale1=0;
	    tmpscale2=0;
        for(i=len-1; i >= 0;i--) {
        	if (document.forms[0].elements[i].name=='check_type1')
        		parastr+=",type1_"+document.forms[0].elements[i].value+"_scale";
        }
        for(i=len-1; i >= 0;i--) {
        	if (document.forms[0].elements[i].name=='check_type2')
        		parastr+=",type2_"+document.forms[0].elements[i].value+"_desc";
        		parastr+=",type2_"+document.forms[0].elements[i].value+"_date";
        		parastr+=",type2_"+document.forms[0].elements[i].value+"_scale";
        }
        for(i=len-1; i >= 0;i--){
        	for(j=rowindex1; j >= 0;j--) {
        	    if (document.forms[0].elements[i].name==('type1_'+j+'_scale'))
        	        tmpscale1+=eval(document.forms[0].elements[i].value);
        	}
        }
        if(tmpscale1>100){
            alert("<%=SystemEnv.getHtmlLabelName(16277,user.getLanguage())%>");
            return;
        }
        for(i=len-1; i >= 0;i--){
        	for(j=rowindex2; j >= 0;j--) {
        	    if (document.forms[0].elements[i].name==('type2_'+j+'_scale'))
        	        tmpscale2+=eval(document.forms[0].elements[i].value);
        	}
        }
        if(tmpscale2>100){
            alert("<%=SystemEnv.getHtmlLabelName(16278,user.getLanguage())%>");
            return;
        }
        for(i=len-1; i >= 0;i--){
        	for(j=rowindex2; j >= 0;j--) {
        	    if (document.forms[0].elements[i].name==('type1_'+j+'_point'))
        	        if(document.forms[0].elements[i].value>5){
                        alert("<%=SystemEnv.getHtmlLabelName(16331,user.getLanguage())%>");
                        return;
                    }    
        	}
        }
		if(check_form(document.frmmain,parastr)){
			document.frmmain.src.value='submit';
			document.frmmain.nodesnum1.value=rowindex1;
		    document.frmmain.nodesnum2.value=rowindex2;
			document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
			if(checktimeok())			{
				jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
			//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
            }
			
		}
	}
	function doSubmitBack(obj){
		//parastr = document.getElementById("needcheck").value;
		parastr = "<%=needcheck%>" ;
		len = document.forms[0].elements.length;
        var i=0;
        tmpscale1=0;
	    tmpscale2=0;
        for(i=len-1; i >= 0;i--) {
        	if (document.forms[0].elements[i].name=='check_type1')
        		parastr+=",type1_"+document.forms[0].elements[i].value+"_scale";
        }
        for(i=len-1; i >= 0;i--) {
        	if (document.forms[0].elements[i].name=='check_type2')
        		parastr+=",type2_"+document.forms[0].elements[i].value+"_desc";
        		parastr+=",type2_"+document.forms[0].elements[i].value+"_date";
        		parastr+=",type2_"+document.forms[0].elements[i].value+"_scale";
        }
        for(i=len-1; i >= 0;i--){
        	for(j=rowindex1; j >= 0;j--) {
        	    if (document.forms[0].elements[i].name==('type1_'+j+'_scale'))
        	        tmpscale1+=eval(document.forms[0].elements[i].value);
        	}
        }
        if(tmpscale1>100){
            alert("<%=SystemEnv.getHtmlLabelName(16277,user.getLanguage())%>");
            return;
        }
        for(i=len-1; i >= 0;i--){
        	for(j=rowindex2; j >= 0;j--) {
        	    if (document.forms[0].elements[i].name==('type2_'+j+'_scale'))
        	        tmpscale2+=eval(document.forms[0].elements[i].value);
        	}
        }
        if(tmpscale2>100){
            alert("<%=SystemEnv.getHtmlLabelName(16278,user.getLanguage())%>");
            return;
        }
        for(i=len-1; i >= 0;i--){
        	for(j=rowindex2; j >= 0;j--) {
        	    if (document.forms[0].elements[i].name==('type1_'+j+'_point'))
        	        if(document.forms[0].document.forms[0].elements[i].value>5){
                        alert("<%=SystemEnv.getHtmlLabelName(16331,user.getLanguage())%>");
                        return;
                    }    
        	}
        }
		if(check_form(document.frmmain,parastr)){
			document.frmmain.src.value='submit';
			document.frmmain.nodesnum1.value=rowindex1;
		    document.frmmain.nodesnum2.value=rowindex2;
			document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
			if(checktimeok())			{
				jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
			//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
            }
			
		}
	}
	function doReject(){
		document.frmmain.src.value='reject';
		document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
        if(onSetRejectNode()){
		//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
        }
	}
	function doReopen(){
		document.frmmain.src.value='reopen';
		document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
		//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
	}
	function doDelete(){
		document.frmmain.src.value='delete';
		document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
		//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
	}
	document.getElementById("needcheck").value = document.getElementById("needcheck").value + ",<%=needcheck%>";
</script>
</body>
</html>
