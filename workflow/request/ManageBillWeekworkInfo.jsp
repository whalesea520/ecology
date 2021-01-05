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


<form name="frmmain" method="post" action="BillWeekWorkinfoOperation.jsp"  enctype="multipart/form-data">
<input type="hidden" name="needwfback" id="needwfback" value="1" />
<input type="hidden" name="lastOperator"  id="lastOperator" value="<%=lastOperator%>"/>
<input type="hidden" name="lastOperateDate"  id="lastOperateDate" value="<%=lastOperateDate%>"/>
<input type="hidden" name="lastOperateTime"  id="lastOperateTime" value="<%=lastOperateTime%>"/>

<%@ include file="/workflow/request/WorkflowManageRequestBody.jsp" %>
<%   String resourceidown="0";
    rs.execute("select resourceid from bill_workinfo where requestid="+requestid);
	if (rs.next())
	{
	resourceidown=rs.getString(1);
	}
	String resourceid=user.getUID()+"";

    if(resourceidown==null||resourceidown.trim().equals("")){
		resourceidown=resourceid;
	}
	String needcheck15494 = "";
	String needcheck15498 = "";
	String needcheck15499 = "";
	int rowindex1=0 ;
	int rowindex2=0 ;
	int rowindex3=0 ;
%>
  <table class="viewform" style="width:100%">
    <colgroup> <col width="20%"> <col width="80%"> 
	 <tr> 
		<th colspan=2 align=center><%=SystemEnv.getHtmlLabelName(20561,user.getLanguage())%></th>
	</tr>
	   <TR class="Spacing">
    	  <TD class="Line1"></TD></TR>
	<tr><td colspan="2">
	
	 <table Class="ListStyle ViewForm" cellspacing=1   cols=3 >
	      <COLGROUP> 
	      <COL width="30%"> <COL width="20%"><COL width="40%">
	      <tr class=header> 
	        <td><%=SystemEnv.getHtmlLabelName(15499,user.getLanguage())%></td>
	        <td><%=SystemEnv.getHtmlLabelName(15500,user.getLanguage())%></td>
	        <td><%=SystemEnv.getHtmlLabelName(15501,user.getLanguage())%></td>
	      </tr>
		  <%
		  if (rs.getDBType().equals("oracle"))
		  {
		   rs.execute("select * from bill_weekinfodetail where  type=3 and infoid=(select id from (select  b.* from bill_workinfo b,bill_weekinfodetail a where a.infoid=b.id and a.type=3 and b.resourceid="+resourceidown+" and requestid<"+requestid+"  order by requestid desc) where rownum=1 ) order by id");
		  }
		  else
		  {
		  rs.execute("select * from bill_weekinfodetail where type=3 and infoid=(select  top 1 b.id  from bill_weekinfodetail a,bill_workinfo b where a.type=3 and a.infoid=b.id and   b.resourceid="+resourceidown+" and requestid<"+requestid+" order by requestid desc) order by id");
		  }
		  boolean islights=true;
		  while (rs.next())
		  {
		  
			String curworknameold=rs.getString("workname");
    		String curdateold=rs.getString("forecastdate");
    		String curworkdescold=rs.getString("workdesc");
			%>
		  <tr class="wfdetailrowblock">
		
		  <td> <%=Util.toScreenToEdit(curworknameold,user.getLanguage())%></td>
		  <td><%=Util.toScreenToEdit(curdateold,user.getLanguage())%></td>
		   <td><%=Util.toScreenToEdit(curworkdescold,user.getLanguage())%></td>
		  </tr>
<%
    		islights=!islights;
    	
    	}
	
%>
	
	    </table>
	</td></tr>
    <tr class="Title"> 
      <td colspan=2>
	  <!--table class="viewform"-->
	  <tr><td height=15></td></tr>
	<%if(!nodetype.equals("0")||(nodetype.equals("0")&&isremark!=0)) {%>
    <tr> 
		<th colspan=2 align=center><%=SystemEnv.getHtmlLabelName(15493,user.getLanguage())%></th>
	</tr>
	<tr class="Title"> 
      <td colspan=2>
	  <table class="viewform" style="width:100%">
	  <!-- 完成事项 -->
      <TR class="Spacing">
    	  <TD class="Line1"></TD></TR>
	  <tr><td>
	    <table Class="ListStyle ViewForm" cellspacing=1   cols=3 id="oTable1">
	      <COLGROUP> 
	      <COL width="10%"><COL width="40%"> <COL width="50%">
	      <tr class=header> 
	        <td>&nbsp;</td>
	        <td><%=SystemEnv.getHtmlLabelName(15494,user.getLanguage())%></td>
	        <td><%=SystemEnv.getHtmlLabelName(16280,user.getLanguage())%></td>
	      </tr>
<%		  
	boolean islight=true;
	String ids=",";
	RecordSet.executeProc("bill_workinfodetail_SByType",""+billid+flag+"1");
	while(RecordSet.next()){
		String id=RecordSet.getString("id");
		String curworkname=RecordSet.getString("workname");
		String curworkdesc=RecordSet.getString("workdesc");
		ids=ids+id+",";
%>
		  <tr class="wfdetailrowblock">
		  <td>&nbsp;<input type="hidden" name="type1_<%=rowindex1%>_id" value="<%=id%>"></td></td>
		  <td><%=Util.toScreen(curworkname,user.getLanguage())%>
			  <input type="hidden" name="type1_<%=rowindex1%>_name" value="<%=Util.toScreenToEdit(curworkname,user.getLanguage())%>"></td>
		  <td><%=Util.toScreen(curworkdesc,user.getLanguage())%>
			  <input type="hidden" name="type1_<%=rowindex1%>_desc" value="<%=Util.toScreenToEdit(curworkdesc,user.getLanguage())%>"> 
			  </td>
<%
		islight=!islight;
		rowindex1++;
	}
%>
	    </table>
	   </td></tr>
      </table>
		<input type="hidden" name="type1_id" value="<%=ids%>">
      </td>
    </tr>
    <tr class="Title">
      <td colspan=2>
	  <table class="viewform" style="width:100%">
	  <!-- 未完成事项 -->
 
	  <tr><td>
	    <table Class="ListStyle ViewForm" cellspacing=1   cols=3 id="oTable2">
	      <COLGROUP> 
	      <COL width="10%"><COL width="40%"> <COL width="50%">
	      <tr class=header> 
	        <td>&nbsp;</td>
	        <td><%=SystemEnv.getHtmlLabelName(16281,user.getLanguage())%></td>
	        <td><%=SystemEnv.getHtmlLabelName(15497,user.getLanguage())%></td>
	      </tr>
<%	islight=true;
	  ids=",";
	RecordSet.executeProc("bill_workinfodetail_SByType",""+billid+flag+"2");
	while(RecordSet.next()){
        String id=RecordSet.getString("id");
		String curworkname=RecordSet.getString("workname");
		String curworkdesc=RecordSet.getString("workdesc");
		ids=ids+id+",";
%>
		  <tr class="wfdetailrowblock">
		  <td>&nbsp;<input type="hidden" name="type2_<%=rowindex2%>_id" value="<%=id%>"></td>
		  <td><%=Util.toScreen(curworkname,user.getLanguage())%>
			  <input type="hidden" name="type2_<%=rowindex2%>_name" value="<%=Util.toScreenToEdit(curworkname,user.getLanguage())%>"></td>
		  <td><%=Util.toScreen(curworkdesc,user.getLanguage())%>
			   <input type="hidden" name="type2_<%=rowindex2%>_desc" value="<%=Util.toScreenToEdit(curworkdesc,user.getLanguage())%>"></td>
<%
		islight=!islight;
		rowindex2++;
	}
%>
	    </table>
	   </td></tr>
      </table>
		<input type="hidden" name="type2_id" value="<%=ids%>">
      </td>
    </tr>
    
    <tr> 
		<th colspan=2 align=center><%=SystemEnv.getHtmlLabelName(15498,user.getLanguage())%></th>
	</tr>  <TR class="Spacing">
    	  <TD class="Line1"></TD></TR>
	<tr class="Title"> 
      <td colspan=2>
	  <table class="viewform" style="width:100%">
	  <!-- 未完成事项 -->

	  <tr><td>
	    <table Class="ListStyle ViewForm" cellspacing=1   cols=4 id="oTable3">
	      <COLGROUP> 
	      <COL width="10%"><COL width="30%"> <COL width="20%"><COL width="40%">
		 
	      <tr class=header> 
	        <td>&nbsp;</td>
	        <td><%=SystemEnv.getHtmlLabelName(15499,user.getLanguage())%></td>
	        <td><%=SystemEnv.getHtmlLabelName(15500,user.getLanguage())%></td>
	        <td><%=SystemEnv.getHtmlLabelName(15501,user.getLanguage())%></td>
	      </tr>
<%	islight=true;
	  ids=",";
	RecordSet.executeProc("bill_workinfodetail_SByType",""+billid+flag+"3");
	while(RecordSet.next()){
		String id=RecordSet.getString("id");
		String curworkname=RecordSet.getString("workname");
		String curdate=RecordSet.getString("forecastdate");
		String curworkdesc=RecordSet.getString("workdesc");
		ids=ids+id+",";
%>
		  <tr class="wfdetailrowblock">
		  <td>&nbsp;<input type="hidden" name="type3_<%=rowindex3%>_id" value="<%=id%>"></td>
		  <td><%=Util.toScreen(curworkname,user.getLanguage())%>
			  <input type="hidden" name="type3_<%=rowindex3%>_name" value="<%=Util.toScreenToEdit(curworkname,user.getLanguage())%>"></td>
		  <td><%=Util.toScreen(curdate,user.getLanguage())%>
			  <input type=hidden name="type3_<%=rowindex3%>_date" value="<%=curdate%>"></td>
		  <td><%=Util.toScreen(curworkdesc,user.getLanguage())%>
			  <input type="hidden" name="type3_<%=rowindex3%>_desc" value="<%=Util.toScreenToEdit(curworkdesc,user.getLanguage())%>"></td>
<%
		islight=!islight;
		rowindex3++;
	}
%>
	     </table>
	   </td></tr>
  	   <tr><td height=15></td></tr>
      </table>
		<input type="hidden" name="type3_id" value="<%=ids%>">
      </td>
    </tr>     
	<%} else {%>
    <tr> 
		<th colspan=2 align=center><%=SystemEnv.getHtmlLabelName(15493,user.getLanguage())%></th>
	</tr>
	<tr class="Title"> 
      <td colspan=2>
	  <table class="viewform" style="width:100%">
	  <!-- 完成事项 -->
	  <tr><td>
		<BUTTON Class=BtnFlow type=button accessKey=A onclick="addRow1()"><U>A</U>-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></BUTTON>
		<BUTTON Class=BtnFlow type=button accessKey=E onclick="deleteRow1();"><U>E</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
		<br> </td>
      </tr>

	  <tr><td>
	    <table Class="ListStyle ViewForm" cellspacing=1   cols=3 id="oTable1">
	      <COLGROUP> 
	      <COL width="10%"><COL width="40%"> <COL width="50%">
	      <tr class=header> 
	        <td>&nbsp;</td>
	        <td><%=SystemEnv.getHtmlLabelName(15494,user.getLanguage())%></td>
	        <td><%=SystemEnv.getHtmlLabelName(16280,user.getLanguage())%></td>
	      </tr>
<%	boolean islight=true;
	String ids=",";
	RecordSet.executeProc("bill_workinfodetail_SByType",""+billid+flag+"1");
	while(RecordSet.next()){
		String id=RecordSet.getString("id");
		String curworkname=RecordSet.getString("workname");
		String curworkdesc=RecordSet.getString("workdesc");
		ids=ids+id+",";
%>
		  <tr class="wfdetailrowblock">
		  <td><input type="hidden" name="type1_<%=rowindex1%>_id" value="<%=id%>"><input type=checkbox name="check_type1" value=<%=rowindex1%>></td>
		  <td><input type=input class=inputstyle name="type1_<%=rowindex1%>_name" style=width:80% value="<%=Util.toScreenToEdit(curworkname,user.getLanguage())%>"></td>
		  <td><textarea class=inputstyle  name="type1_<%=rowindex1%>_desc" rows=2 style="width:80%" onchange='checkinput1(type1_<%=rowindex1%>_desc,type1_<%=rowindex1%>_descspan)'><%=Util.toScreenToEdit(curworkdesc,user.getLanguage())%></textarea>
		  <span id="type1_<%=rowindex1%>_descspan"></span>  
		  </td>
		  </tr>
<%
		needcheck15494 += ",type1_"+rowindex1+"_desc";
		islight=!islight;
		rowindex1++;
	}
%>
	    <input type="hidden" name="type1_id" value="<%=ids%>"></table>
	   </td></tr>
      </table>
      </td>
    </tr>
    <tr class="Title">
      <td colspan=2>
	  <table class="viewform" style="width:100%">
	  <!-- 未完成事项 -->
	  <tr><td>
		<BUTTON Class=BtnFlow type=button accessKey=N onclick="addRow2()"><U>N</U>-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></BUTTON>
		<BUTTON Class=BtnFlow type=button accessKey=D onclick="deleteRow2();"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
		<br> </td>
      </tr>
   
	  <tr><td>
	    <table Class="ListStyle ViewForm" cellspacing=1   cols=3 id="oTable2">
	      <COLGROUP> 
	      <COL width="10%"><COL width="40%"> <COL width="50%">
	      <tr class=header> 
	        <td>&nbsp;</td>
	        <td><%=SystemEnv.getHtmlLabelName(16281,user.getLanguage())%></td>
	        <td><%=SystemEnv.getHtmlLabelName(15497,user.getLanguage())%></td>
	      </tr>
<%	islight=true;
	  ids=",";
	RecordSet.executeProc("bill_workinfodetail_SByType",""+billid+flag+"2");
	while(RecordSet.next()){
        String id=RecordSet.getString("id");
		String curworkname=RecordSet.getString("workname");
		String curworkdesc=RecordSet.getString("workdesc");
		ids=ids+id+",";
%>
		  <tr class="wfdetailrowblock">
		  <td><input type="hidden" name="type2_<%=rowindex2%>_id" value="<%=id%>"><input type=checkbox name="check_type2" value=<%=rowindex2%>></td>
		  <td><input class=inputstyle  type=input name="type2_<%=rowindex2%>_name" style="width:80%" value="<%=Util.toScreenToEdit(curworkname,user.getLanguage())%>"></td>
		  <td><textarea class=inputstyle  name="type2_<%=rowindex2%>_desc" rows=2 style="width:80%" onchange='checkinput1(type2_<%=rowindex2%>_desc,type2_<%=rowindex2%>_descspan)'><%=Util.toScreenToEdit(curworkdesc,user.getLanguage())%></textarea>
		      <span id="type2_<%=rowindex2%>_descspan"></span>
		  </td>
		  </tr>
<%
		needcheck15498 += ",type2_"+rowindex2+"_desc";
		islight=!islight;
		rowindex2++;
	}
%>
	    <input type="hidden" name="type2_id" value="<%=ids%>"></table>
	   </td></tr>
      </table>
      </td>
    </tr>
    
    <tr> 
		<th colspan=2 align=center><%=SystemEnv.getHtmlLabelName(15498,user.getLanguage())%></th>
	</tr>
	<tr class="Title"> 
      <td colspan=2>
	  <table class="viewform" style="width:100%">
	  <!-- 未完成事项 -->
	  <tr><td>
		<BUTTON Class=BtnFlow type=button accessKey=T onclick="addRow3()"><U>T</U>-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></BUTTON>
		<BUTTON Class=BtnFlow type=button accessKey=X onclick="deleteRow3();"><U>X</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
		<br> </td>
      </tr>
     
	  <tr><td>
	    <table Class="ListStyle ViewForm" cellspacing=1   cols=4 id="oTable3">
	      <COLGROUP> 
	      <COL width="10%"><COL width="30%"> <COL width="20%"><COL width="40%">
	      <tr class=header> 
	        <td>&nbsp;</td>
	        <td><%=SystemEnv.getHtmlLabelName(15499,user.getLanguage())%></td>
	        <td><%=SystemEnv.getHtmlLabelName(15500,user.getLanguage())%></td>
	        <td><%=SystemEnv.getHtmlLabelName(15501,user.getLanguage())%></td>
	      </tr>
<%	islight=true;
	ids=",";
	RecordSet.executeProc("bill_workinfodetail_SByType",""+billid+flag+"3");
	while(RecordSet.next()){
		 String id=RecordSet.getString("id");
		String curworkname=RecordSet.getString("workname");
		String curdate=RecordSet.getString("forecastdate");
		String curworkdesc=RecordSet.getString("workdesc");
		ids=ids+id+",";
%>
		  <tr class="wfdetailrowblock">
		  <td><input type="hidden" name="type3_<%=rowindex3%>_id" value="<%=id%>"><input type=checkbox name="check_type3" value=<%=rowindex3%>></td>
		  <td><input class=inputstyle  type=input name="type3_<%=rowindex3%>_name" style="width:80%" value="<%=Util.toScreenToEdit(curworkname,user.getLanguage())%>"></td>
		  <td><button class=Calendar type='button' onClick='onShowDate(type3_<%=rowindex3%>_datespan,type3_<%=rowindex3%>_date)'></button>
		  <span id=type3_<%=rowindex3%>_datespan><%=curdate%></span>
		  <input type=hidden name=type3_<%=rowindex3%>_date value="<%=curdate%>">
		  </td>
		  <td><textarea class=inputstyle  name="type3_<%=rowindex3%>_desc" rows=2 style="width:80%" onchange='checkinput1(type3_<%=rowindex3%>_desc,type3_<%=rowindex3%>_descspan)'><%=Util.toScreenToEdit(curworkdesc,user.getLanguage())%></textarea>
		      <span id="type3_<%=rowindex3%>_descspan"></span>
		  </td>
<%
		needcheck15499 += ",type3_"+rowindex3+"_desc"+",type3_"+rowindex3+"_date";
		islight=!islight;
		rowindex3++;
	}
%>
	     </table>
		<input type="hidden" name="type3_id" value="<%=ids%>">
	   </td></tr>
  	   <tr><td height=15></td></tr>
      </table>
      </td>
    </tr> 
	<%}%>
    </td>
  </tr>
  <tr><td height=15></td></tr>
  <!--/table-->
  </td>
  </tr>  
  </table><br>
  <br>

  <%@ include file="WorkflowManageSign.jsp" %>
  
<input type="hidden" name="nodesnum1" value=<%=rowindex1%>>
<input type="hidden" name="nodesnum2" value=<%=rowindex2%>>
<input type="hidden" name="nodesnum3" value=<%=rowindex3%>>
<input type=hidden name="f_weaver_belongto_userid" value=<%=f_weaver_belongto_userid%>>
<input type=hidden name ="f_weaver_belongto_usertype" value="<%=f_weaver_belongto_usertype%>">
</form>
 
<script language=javascript>
rowindex1 = <%=rowindex1%> ;
rowindex2 = <%=rowindex2%> ;
rowindex3 = <%=rowindex3%> ;
document.all("needcheck").value +="<%=needcheck15494%>"+"<%=needcheck15498%>"+"<%=needcheck15499%>";
function addRow1()
{	
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
		oCell.style.background= "#D2D1F1";
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_type1' value="+rowindex1+">"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input class=inputstyle  type='input' name='type1_"+rowindex1+"_name' style='width=80%'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
			case 2: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<textarea class=inputstyle  rows=2 cols=70 name='type1_"+rowindex1+"_desc' style='width=80%' onchange='checkinput1(type1_"+rowindex1+"_desc,type1_"+rowindex1+"_descspan)'></textarea>"+
				            "<span id='type1_"+rowindex1+"_descspan'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
		}
	}
	document.all("needcheck").value += ",type1_"+rowindex1+"_desc";
	rowindex1 = rowindex1*1 +1;
	document.frmmain.nodesnum1.value=rowindex1;
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

function addRow2()
{	
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
		oCell.style.background= "#D2D1F1";
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_type2' value="+rowindex2+">"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input class=inputstyle  type='input' name='type2_"+rowindex2+"_name' style='width=80%'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
			case 2: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<textarea class=inputstyle  rows=2 cols=70 name='type2_"+rowindex2+"_desc' style='width=80%' onchange='checkinput1(type2_"+rowindex2+"_desc,type2_"+rowindex2+"_descspan)'></textarea>"+
				            "<span id='type2_"+rowindex2+"_descspan'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
		}
	}
	document.all("needcheck").value += ",type2_"+rowindex2+"_desc";
	rowindex2 = rowindex2*1 +1;
	document.frmmain.nodesnum2.value=rowindex2;
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

function addRow3()
{	
	var oTable=$GetEle('oTable3');
	var ncol = oTable3.rows[0].cells.length;
	var oRow = oTable3.insertRow(-1);
	oRow.className = "wfdetailrowblock";
	jQuery(oRow).hover(function () {
    	jQuery(this).addClass("Selected");
    }, function () {
    	jQuery(this).removeClass("Selected");
    });
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1);  
		oCell.style.height=24;
		oCell.style.background= "#D2D1F1";
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_type3' value="+rowindex3+">"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input class=inputstyle  type='input' name='type3_"+rowindex3+"_name' style='width=80%'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
			case 2: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<button class=Calendar type='button' onClick='onShowDate(type3_"+rowindex3+"_datespan,type3_"+rowindex3+"_date)'></button> " + 
        					"<span class=Inputstyle id=type3_"+rowindex3+"_datespan><img src='/images/BacoError_wev8.gif' align=absmiddle></span> "+
        					"<input type='hidden' name='type3_"+rowindex3+"_date' id='type3_"+rowindex3+"_date'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
			case 3: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<textarea class=inputstyle  rows=2 cols=70 name='type3_"+rowindex3+"_desc' style='width=80%' onchange='checkinput1(type3_"+rowindex3+"_desc,type3_"+rowindex3+"_descspan)'></textarea>"+
				            "<span id='type3_"+rowindex3+"_descspan'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
		}
	}
	document.all("needcheck").value += ",type3_"+rowindex3+"_date"+",type3_"+rowindex3+"_desc";
	rowindex3 = rowindex3*1 +1;
	document.frmmain.nodesnum3.value=rowindex3;
}

function deleteRow3()
{
    var flag = false;
	var ids = document.getElementsByName('check_type3');
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
                if (document.forms[0].elements[i].name=='check_type3')
                    rowsum1 ++;
            }
            for(i=len-1; i >= 0;i--) {
                if (document.forms[0].elements[i].name=='check_type3'){
                    if(document.forms[0].elements[i].checked==true)
                        oTable3.deleteRow(rowsum1);
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

</script>
<script language=vbs>
sub onShowFeeType(inputname,spanname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/fna/maintenance/ExpensefeeTypeBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	spanname.innerHtml = "<A href='/fna/maintenance/FnaExpensefeeTypeEdit.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	inputname.value=id(0)
	else 
	spanname.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	inputname.value="0"
	end if
	end if
end sub
</script>
</body>
</html>
