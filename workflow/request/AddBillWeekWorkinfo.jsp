
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/workflow/request/WorkflowAddRequestTitle.jsp" %>
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

<form name="frmmain" method="post" action="BillWeekWorkinfoOperation.jsp" enctype="multipart/form-data">
<input type="hidden" name="needwfback" id="needwfback" value="1" />
 <%@ include file="/workflow/request/WorkflowAddRequestBody.jsp" %>
  <%int userids=user.getUID();

  %>
	<table class="viewform" style="width:100%">
    <colgroup> <col width="20%"> <col width="80%"> 
	 <tr> 
		<th colspan=2 align=center><%=SystemEnv.getHtmlLabelName(20561,user.getLanguage())%></th>
	</tr>
	<tr class="Title"> 
      <td colspan=2>
	  <table class="viewform" style="width:100%">

      <TR class="Spacing">
    	  <TD class="Line1"></TD></TR>
	  <tr><td>
	    <table Class="ListStyle ViewForm" cols=3 style="width:100%">
	      <COLGROUP> 
	      <COL width="30%"> <COL width="20%"><COL width="40%">
	      <tr class=header> 
	        <td align="center"><%=SystemEnv.getHtmlLabelName(15499,user.getLanguage())%></td>
	        <td align="center"><%=SystemEnv.getHtmlLabelName(15500,user.getLanguage())%></td>
	        <td align="center"><%=SystemEnv.getHtmlLabelName(15501,user.getLanguage())%></td>
	      </tr>
		  <%
		  if (rs.getDBType().equals("oracle"))
		  {
		   rs.execute("select * from bill_weekinfodetail where  type=3 and infoid=(select id from (select  b.* from bill_workinfo b,bill_weekinfodetail a where a.infoid=b.id and a.type=3 and b.resourceid="+userids+"  order by requestid desc) where rownum=1 ) order by id  ");
		 
		  }
		  else
		  {
		  rs.execute("select * from bill_weekinfodetail where type=3 and infoid=(select  top 1 b.id  from bill_weekinfodetail a,bill_workinfo b where a.type=3 and a.infoid=b.id and   b.resourceid="+userids+"  order by requestid desc) order by id");
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
	   </td></tr></table></td></tr>
  	   <tr><td height=15></td></tr>

    <tr > 
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
      <TR class="Spacing">
    	  <TD class="Line1"></TD></TR>
	  <tr><td>
	    <table Class="ListStyle ViewForm" cols=3 id="oTable1">
	      <COLGROUP> 
	      <COL width="10%"><COL width="40%"> <COL width="50%">
	      <tr class=header> 
	        <td>&nbsp;</td>
	        <td><%=SystemEnv.getHtmlLabelName(15494,user.getLanguage())%></td>
	        <td><%=SystemEnv.getHtmlLabelName(16280,user.getLanguage())%></td>
	      </tr>
<%		
	char flag = 2 ;
	String resourceid=user.getUID()+"";
	int rowindex1=0 ;
	int rowindex2=0 ;
	int rowindex3=0 ;
	boolean islight=true;
	rs.executeProc("bill_workinfo_SSubordinate",""+formid+flag+"-1");
	while(rs.next()){
	    String curid=rs.getString("id");
	    RecordSet.executeProc("bill_workinfodetail_SByType",curid+flag+"1");
	    while(RecordSet.next()){
    		String curworkname=RecordSet.getString("workname");
    		String curworkdesc=RecordSet.getString("workdesc");
%>
		  <tr class="wfdetailrowblock">
		  <td><input type=checkbox name="check_type1" value=<%=rowindex1%>></td>
		  <td><input type=input class=inputstyle  name="type1_<%=rowindex1%>_name" style=width:80% value="<%=Util.toScreenToEdit(curworkname,user.getLanguage())%>"></td>
		  <td><textarea class=inputstyle  name="type1_<%=rowindex1%>_desc" rows=2 style="width:80%" onchange='checkinput1(type1_<%=rowindex1%>_desc,type1_<%=rowindex1%>_descspan)'><%=Util.toScreenToEdit(curworkdesc,user.getLanguage())%></textarea>
		  <span id="type1_<%=rowindex1%>_descspan"></span>  
		  </td>
		  </tr>
<%
    		islight=!islight;
    		rowindex1++;
    	}
	}
%>
	    </table>
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
      <TR class="Spacing">
    	  <TD class="Line1"></TD></TR>
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
    rs.executeProc("bill_workinfo_SSubordinate",""+formid+flag+"-1");
	while(rs.next()){
	    String curid=rs.getString("id");
	    RecordSet.executeProc("bill_workinfodetail_SByType",curid+flag+"2");
	    while(RecordSet.next()){
    		String curworkname=RecordSet.getString("workname");
    		String curworkdesc=RecordSet.getString("workdesc");
%>
		  <tr class="wfdetailrowblock">
		  <td><input type=checkbox name="check_type2" value=<%=rowindex2%>></td>
		  <td><input type=input class=inputstyle  name="type2_<%=rowindex2%>_name" style=width:80% value="<%=Util.toScreenToEdit(curworkname,user.getLanguage())%>"></td>
		  <td><textarea class=inputstyle  name="type2_<%=rowindex2%>_desc" rows=2 style="width:80%" onchange='checkinput1(type2_<%=rowindex2%>_desc,type2_<%=rowindex2%>_descspan)'><%=Util.toScreenToEdit(curworkdesc,user.getLanguage())%></textarea>
		      <span id="type2_<%=rowindex2%>_descspan"></span>
		  </td>
		  </tr>
<%
    		islight=!islight;
    		rowindex2++;
    	}
	}
%>
	    </table>
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
      <TR class="Spacing">
    	  <TD class="Line1"></TD></TR>
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
    rs.executeProc("bill_workinfo_SSubordinate",""+formid+flag+"-1");
    while(rs.next()){
        String curid=rs.getString("id");
    	RecordSet.executeProc("bill_workinfodetail_SByType",curid+flag+"3");
    	while(RecordSet.next()){
    		String curworkname=RecordSet.getString("workname");
    		String curdate=RecordSet.getString("forecastdate");
    		String curworkdesc=RecordSet.getString("workdesc");
%>
		  <tr class="wfdetailrowblock">
		  <td><input type=checkbox name="check_type3" value=<%=rowindex3%>></td>
		  <td><input type=input class=inputstyle  name="type3_<%=rowindex3%>_name" style="width:80%" value="<%=Util.toScreenToEdit(curworkname,user.getLanguage())%>"></td>
		  <td><button class=Calendar type="button" onClick='getMontPlanDate(type3_<%=rowindex3%>_date,type3_<%=rowindex3%>_datespan)'></button>
		  <span id=type3_<%=rowindex3%>_datespan><%=curdate%></span>
		  <input type=hidden name=type3_<%=rowindex3%>_date value="<%=curdate%>">
		  </td>
		  <td><textarea class=inputstyle  name="type3_<%=rowindex3%>_desc" rows=2 style="width:80%" onchange='checkinput1(type3_<%=rowindex3%>_desc,type3_<%=rowindex3%>_descspan)'><%=Util.toScreenToEdit(curworkdesc,user.getLanguage())%></textarea>
		      <span id="type3_<%=rowindex3%>_descspan"></span>
		  </td>
<%
    		islight=!islight;
    		rowindex3++;
    	}
	}
%>
	    </table>
	   </td></tr>
  	   <tr><td height=15></td></tr>
      </table>
      </td>
    </tr>
  </table>
<input type="hidden" value="0" name="nodesnum1">
<input type="hidden" value="0" name="nodesnum2">
<input type="hidden" value="0" name="nodesnum3">
<input type=hidden name="f_weaver_belongto_userid" value=<%=f_weaver_belongto_userid%>>
<input type=hidden name ="f_weaver_belongto_usertype" value="<%=f_weaver_belongto_usertype%>">
<!-- 单独写签字意见Start ecology8.0 -->
    <%
  //String workflowPhrases[] = WorkflowPhrase.getUserWorkflowPhrase(""+userid);
    //add by cyril on 2008-09-30 for td:9014
		boolean isSuccess  = RecordSet_nf1.executeProc("sysPhrase_selectByHrmId",""+userid);
		String workflowPhrases[] = new String[RecordSet_nf1.getCounts()];
		String workflowPhrasesContent[] = new String[RecordSet_nf1.getCounts()];
		int m = 0 ;
		if (isSuccess) {
			while (RecordSet_nf1.next()){
				workflowPhrases[m] = Util.null2String(RecordSet_nf1.getString("phraseShort"));
				workflowPhrasesContent[m] = Util.toHtml(Util.null2String(RecordSet_nf1.getString("phrasedesc")));
				m ++ ;
			}
		}
		//end by cyril on 2008-09-30 for td:9014
		
		//String isSignMustInput="0";
		//String isHideInput="0";
		//String isFormSignature=null;
		//int formSignatureWidth=RevisionConstants.Form_Signature_Width_Default;
		//int formSignatureHeight=RevisionConstants.Form_Signature_Height_Default;
		RecordSet_nf1.executeSql("select isFormSignature,formSignatureWidth,formSignatureHeight,issignmustinput,ishideinput from workflow_flownode where workflowId="+workflowid+" and nodeId="+nodeid);
		if(RecordSet_nf1.next()){
		isFormSignature = Util.null2String(RecordSet_nf1.getString("isFormSignature"));
		formSignatureWidth= Util.getIntValue(RecordSet_nf1.getString("formSignatureWidth"),RevisionConstants.Form_Signature_Width_Default);
		formSignatureHeight= Util.getIntValue(RecordSet_nf1.getString("formSignatureHeight"),RevisionConstants.Form_Signature_Height_Default);
		isSignMustInput = ""+Util.getIntValue(RecordSet_nf1.getString("issignmustinput"), 0);
		isHideInput = ""+Util.getIntValue(RecordSet_nf1.getString("ishideinput"), 0);
		}
		//int isUseWebRevision_t = Util.getIntValue(new weaver.general.BaseBean().getPropValue("weaver_iWebRevision","isUseWebRevision"), 0);
		if(isUseWebRevision_t != 1){
		isFormSignature = "";
		}
	String workflowRequestLogId = "";
	String isSignDoc_edit=isSignDoc_add;
	String signdocids = "";
	String signdocname = "";
	String isSignWorkflow_edit = isSignWorkflow_add; 
	String signworkflowids = "";
	String signworkflowname = "";
	
	String isannexupload_add=(String)session.getAttribute(userid+"_"+workflowid+"isannexupload");
	String isannexupload_edit = isannexupload_add;
	String annexdocids = "";
	String requestid = "-1";
	
	
	String myremark = "";
	int annexmainId=0;
    int annexsubId=0;
    int annexsecId=0;
    int annexmaxUploadImageSize = 0;
	if("1".equals(isannexupload_add)){
        
        String annexdocCategory_add=(String)session.getAttribute(userid+"_"+workflowid+"annexdocCategory");
         if("1".equals(isannexupload_add) && annexdocCategory_add!=null && !annexdocCategory_add.equals("")){
            annexmainId=Util.getIntValue(annexdocCategory_add.substring(0,annexdocCategory_add.indexOf(',')));
            annexsubId=Util.getIntValue(annexdocCategory_add.substring(annexdocCategory_add.indexOf(',')+1,annexdocCategory_add.lastIndexOf(',')));
            annexsecId=Util.getIntValue(annexdocCategory_add.substring(annexdocCategory_add.lastIndexOf(',')+1));
          }
         annexmaxUploadImageSize=Util.getIntValue(SecCategoryComInfo1.getMaxUploadFileSize(""+annexsecId),5);
         if(annexmaxUploadImageSize<=0){
            annexmaxUploadImageSize = 5;
         }
     }
    %>
	<%@ include file="/workflow/request/WorkflowSignInput.jsp" %>
<!-- 单独写签字意见End ecology8.0 -->
</form>

<script language="JavaScript" src="/js/addRowBg_wev8.js"></script>  
<script language=javascript>
rowindex1 = <%=rowindex1%> ;
rowindex2 = <%=rowindex2%> ;
rowindex3 = <%=rowindex3%> ;
var rowColor="" ;
function addRow1(){
	var oTable=$GetEle('oTable1');
	var rowColor = getRowBg();
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
		oCell.style.background=rowColor;
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_type1' value="+rowindex1+">"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type='input' class=inputstyle  name='type1_"+rowindex1+"_name' style='width=80%'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
			case 2: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<textarea  class=inputstyle rows=2 cols=70 name='type1_"+rowindex1+"_desc' style='width=80%' onchange='checkinput1(type1_"+rowindex1+"_desc,type1_"+rowindex1+"_descspan)'></textarea>"+
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

function addRow2(){	
	var oTable=$GetEle('oTable2');
	var rowColor = getRowBg();
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
		oCell.style.background= rowColor;
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_type2' value="+rowindex2+">"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type='input' class=inputstyle name='type2_"+rowindex2+"_name' style='width=80%'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
			case 2: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<textarea class=inputstyle  rows=2 cols=70 class=inputstyle name='type2_"+rowindex2+"_desc' style='width=80%' onchange='checkinput1(type2_"+rowindex2+"_desc,type2_"+rowindex2+"_descspan)'></textarea>"+
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

function addRow3(){	
	var oTable=$GetEle('oTable3');
	var rowColor = getRowBg();
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
		oCell.style.background= rowColor;
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_type3' value="+rowindex3+">"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type='input' class=inputstyle  name='type3_"+rowindex3+"_name' style='width=80%'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
			case 2: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<button class=Calendar type='button' onClick='getMontPlanDate(type3_"+rowindex3+"_date,type3_"+rowindex3+"_datespan)'></button> " + 
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
