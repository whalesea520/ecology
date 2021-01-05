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

<form name="frmmain" method="post" action="BillMonthWorkinfoOperation.jsp" enctype="multipart/form-data">
<input type="hidden" name="needwfback" id="needwfback" value="1" />
    <%@ include file="/workflow/request/WorkflowAddRequestBody.jsp" %> 
<table class="viewform" style="width:100%">
	<tr> 
		<th colspan=2 align=center><%=SystemEnv.getHtmlLabelName(16276,user.getLanguage())%></th>
	</tr>
	<tr class="Title"> 
      <td colspan=2>
	  <table class="viewform" style="width:100%">
	  <!-- 工作总结 -->
	  <tr><td>
		<BUTTON Class=BtnFlow type=button accessKey=A onclick="addRow1()"><U>A</U>-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></BUTTON>
		<BUTTON Class=BtnFlow type=button accessKey=E onclick="deleteRow1();"><U>E</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
		<br> </td>
      </tr>
      <TR class="Spacing">
    	  <TD class="Line1"></TD></TR>
	  <tr><td>
	    <table class="ListStyle ViewForm" cellspacing=1 cols=4 id="oTable1" style="width:100%">
	      <COLGROUP> 
	      <COL width="10%"><COL width="50%"><COL width="20%"><COL width="20%">
	      <tr class=header> 
	        <td>&nbsp;</td>
	        <td><%=SystemEnv.getHtmlLabelName(16274,user.getLanguage())%></td>
	        <td><%=SystemEnv.getHtmlLabelName(15488,user.getLanguage())%></td>
	        <td><%=SystemEnv.getHtmlLabelName(16275,user.getLanguage())%></td>
	      </tr>
<%	
    char flag=2;
    int rowindex1=0;
    int rowindex2=0;
    String resourceid=user.getUID()+"";
    if(hrmid.equals(""))	hrmid=resourceid;

    
    boolean islight=true;
	rs.executeProc("bill_workinfo_SSubordinate",""+formid+flag+"-1");
	while(rs.next()){
	    String curid=rs.getString("id");
	    RecordSet.executeProc("bill_monthinfodetail_SByType",curid+flag+"2");
    	while(RecordSet.next()){
    		String curworkdesc=RecordSet.getString("targetresult");
    		String curscale=RecordSet.getString("scale");
    		String curpoint=RecordSet.getString("point");
    		if(curpoint.equals("0"))	curpoint="";
    		needcheck += ",type1_"+rowindex1+"_result";
    %>
    		  <tr class="wfdetailrowblock">
    		  <td><input type=checkbox name="check_type1" value=<%=rowindex1%>></td>
    		  <td><textarea class="inputstyle" id="type1_<%=rowindex1%>_result" name="type1_<%=rowindex1%>_result" temptitle="<%=SystemEnv.getHtmlLabelName(16274,user.getLanguage())%>" rows=2 style="width:80%" viewtype="1" onChange="checkinput2('type1_<%=rowindex1%>_result','type1_<%=rowindex1%>_resultspan',this.getAttribute('viewtype'));"><%=Util.toScreenToEdit(curworkdesc,user.getLanguage())%></textarea>
				<span id="type1_<%=rowindex1%>_resultspan"><%if("".equals(Util.toScreenToEdit(curworkdesc,user.getLanguage()).trim())){%><img src="/images/BacoError_wev8.gif" align="absmiddle"><%}%></span>
				</td>
    		  <td><input type=input class=inputstyle name="type1_<%=rowindex1%>_scale" style="width:60%" 
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
	}
%>
	    </table>
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
	  <!-- 工作目标 -->
	  <tr>
	  	<td>
			<BUTTON Class=BtnFlow type=button accessKey=N onclick="addRow2()"><U>N</U>-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></BUTTON>
			<BUTTON Class=BtnFlow type=button accessKey=D onclick="deleteRow2();"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
			<br> 
		</td>
      </tr>
      <TR class="Spacing">
    	  <TD class="Line1"></TD></TR>
	  <tr><td>
	    <table class="ListStyle ViewForm"   cols=5 id="oTable2">
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
    rs.executeProc("bill_workinfo_SSubordinate",""+formid+flag+"-1");
	while(rs.next()){
	    String curid=rs.getString("id");
	    RecordSet.executeProc("bill_monthinfodetail_SByType",curid+flag+"1");
    	while(RecordSet.next()){
    		String curworkname=RecordSet.getString("targetname");
    		String curworkdesc=RecordSet.getString("targetresult");
    		String curdate=RecordSet.getString("forecastdate");
    		String curscale=RecordSet.getString("scale");
    		needcheck += ",type2_"+rowindex2+"_name";
    %>
    		  <tr class="wfdetailrowblock">
    		  <td><input type=checkbox name="check_type2" value=<%=rowindex2%>></td>
    		  <td><input type="text" class="inputstyle" id="type2_<%=rowindex2%>_name" name="type2_<%=rowindex2%>_name" temptitle="<%=SystemEnv.getHtmlLabelName(16272,user.getLanguage())%>" style="width:80%" onChange="checkinput2('type2_<%=rowindex2%>_name','type2_<%=rowindex2%>_namespan','1');" value="<%=Util.toScreenToEdit(curworkname,user.getLanguage())%>">
				<span id="type2_<%=rowindex2%>_namespan"><%if("".equals(Util.toScreenToEdit(curworkname,user.getLanguage()).trim())){%><img src='/images/BacoError_wev8.gif' align='absmiddle'><%}%></span>
				</td>
    		  <td><input type=input class=inputstyle name="type2_<%=rowindex2%>_desc" style=width:80% value=<%=Util.toScreenToEdit(curworkdesc,user.getLanguage())%> onchange='checkinput1(type2_<%=rowindex2%>_desc,type2_<%=rowindex2%>_descspan)'>
    		      <span id='type2_<%=rowindex2%>_descspan'></span>
    		  </td>
    		  <td><button class=Calendar type='button' onClick='getMontPlanDate(type2_<%=rowindex2%>_date,type2_<%=rowindex2%>_datespan)'></button>
    		  <span id=type2_<%=rowindex2%>_datespan><%=curdate%></span>
    		  <input type=hidden name=type2_<%=rowindex2%>_date value="<%=curdate%>">
    		  </td>
    		  <td><input type=input class=inputstyle name="type2_<%=rowindex2%>_scale" style="width:80%" 
    		  value="<%=Util.toScreenToEdit(curscale,user.getLanguage())%>"
    		  onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this);checkinput1(type2_<%=rowindex2%>_scale,type2_<%=rowindex2%>_scalespan)'>%
    		  <span id='type2_<%=rowindex2%>_scalespan'></span>
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
  </table>
<input type="hidden" value="0" name="nodesnum1">
<input type="hidden" value="0" name="nodesnum2">
<input type="hidden" value="0" id="needcheck" name="needcheck" value="<%=needcheck%>">
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
				var sHtml = "<input  type='checkbox' name='check_type1' value="+rowindex1+">"; 
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
				var sHtml = "<input type='input'  class=inputstyle name='type1_"+rowindex1+"_scale' style='width:60%;' onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this);checkinput1(type1_"+rowindex1+"_scale,type1_"+rowindex1+"_scalespan)'>%"+
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
				var sHtml = "<input type='text' class='inputstyle' id='type2_"+rowindex2+"_name' name='type2_"+rowindex2+"_name' temptitle='<%=SystemEnv.getHtmlLabelName(16272,user.getLanguage())%>' style='width:80%' onChange=\"checkinput2('type2_"+rowindex2+"_name','type2_"+rowindex2+"_namespan','1');\"><span id='type2_"+rowindex2+"_namespan'><img src='/images/BacoError_wev8.gif' align='absmiddle'></span>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);
				break;
			case 2: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type='input' class=inputstyle name='type2_"+rowindex2+"_desc' style='width=80%' onchange='checkinput1(type2_"+rowindex2+"_desc,type2_"+rowindex2+"_descspan)'>"+
				            "<span id='type2_"+rowindex2+"_descspan'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
			case 3: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<button class=Calendar type='button' onClick='getMontPlanDate(type2_"+rowindex2+"_date,type2_"+rowindex2+"_datespan)'></button> " + 
        					"<span class=Inputstyle id=type2_"+rowindex2+"_datespan><img src='/images/BacoError_wev8.gif' align=absmiddle></span> "+
        					"<input type='hidden' name='type2_"+rowindex2+"_date' id='type2_"+rowindex2+"_date'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
			case 4: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type='input' class=inputstyle name='type2_"+rowindex2+"_scale' style='width=60%' onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this);checkinput1(type2_"+rowindex2+"_scale,type2_"+rowindex2+"_scalespan)'>%"+
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


function doSave(){
	//parastr = document.getElementById("needcheck").value;
	parastr = "<%=needcheck%>" ;
	len = document.forms[0].elements.length;
	tmpscale1=0;
	tmpscale2=0;
	var i=0;
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
	//if(check_form(document.frmmain,parastr)){
	if(check_form(document.frmmain, "requestname")){
		document.frmmain.src.value='save';
		document.frmmain.nodesnum1.value=rowindex1;
		document.frmmain.nodesnum2.value=rowindex2;
		if(checktimeok())
		{
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
        //alert(tmpscale1);
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
        //alert(tmpscale2);
        alert("<%=SystemEnv.getHtmlLabelName(16278,user.getLanguage())%>");
        return;
    }

	if(check_form(document.frmmain,parastr)){
		document.frmmain.src.value='submit';
		document.frmmain.nodesnum1.value=rowindex1;
		document.frmmain.nodesnum2.value=rowindex2;
		document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
		if(checktimeok()){
			jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
			//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
        }
	}
}   
</script> 
