
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.general.browserData.BrowserManager"%>
<%@ page import="weaver.workflow.request.RevisionConstants" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ include file="/workflow/request/WorkflowAddRequestTitle.jsp" %>
<jsp:useBean id="WFNodeDtlFieldManager" class="weaver.workflow.workflow.WFNodeDtlFieldManager" scope="page" />
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<form name="frmmain" method="post" action="BillCptDiscardOperation.jsp" enctype="multipart/form-data">
<input type="hidden" name="needwfback" id="needwfback" value="1" />
    <%@ include file="/workflow/request/WorkflowAddRequestBody.jsp" %>
<%
//获取明细表设置
WFNodeDtlFieldManager.resetParameter();
WFNodeDtlFieldManager.setNodeid(Util.getIntValue(""+nodeid));
WFNodeDtlFieldManager.setGroupid(0);
WFNodeDtlFieldManager.selectWfNodeDtlField();
String dtladd = WFNodeDtlFieldManager.getIsadd();
String dtledit = WFNodeDtlFieldManager.getIsedit();
String dtldelete = WFNodeDtlFieldManager.getIsdelete();
String dtldefault = WFNodeDtlFieldManager.getIsdefault();
String dtlneed = WFNodeDtlFieldManager.getIsneed();
int dtldefaultrows = WFNodeDtlFieldManager.getDefaultrows();

fieldids.clear();
fieldlabels.clear();
fieldhtmltypes.clear();
fieldtypes.clear();
fieldnames.clear();
ArrayList viewtypes=new ArrayList();
RecordSet.executeProc("workflow_billfield_Select",formid+"");
while(RecordSet.next()){
	String theviewtype = Util.null2String(RecordSet.getString("viewtype")) ;
	if( !theviewtype.equals("1") ) continue ;   // 如果是单据的主表字段,不显示
	fieldids.add(RecordSet.getString("id"));
	fieldlabels.add(RecordSet.getString("fieldlabel"));
	fieldhtmltypes.add(RecordSet.getString("fieldhtmltype"));
	fieldtypes.add(RecordSet.getString("type"));
	fieldnames.add(RecordSet.getString("fieldname"));
	viewtypes.add(RecordSet.getString("viewtype"));
}

isviews.clear();
isedits.clear();
ismands.clear();
RecordSet.executeProc("workflow_FieldForm_Select",nodeid+"");
while(RecordSet.next()){
	String thefieldid = Util.null2String(RecordSet.getString("fieldid")) ;
	int thefieldidindex = fieldids.indexOf( thefieldid ) ;
	if( thefieldidindex == -1 ) continue ;
	isviews.add(RecordSet.getString("isview"));
	isedits.add(RecordSet.getString("isedit"));
	ismands.add(RecordSet.getString("ismandatory"));
}

String dsptypes ="";
String edittypes ="";
String mandtypes ="";
int tmpcount = 1;
int viewCount = 0; 
for(int ii=0;ii<fieldids.size();ii++){
	String isview1=(String)isviews.get(ii);
	if(isview1.equals("1")) viewCount++;
}
for(int i=0;i<fieldids.size();i++){
	String fieldname=(String)fieldnames.get(i);
	String fieldid=(String)fieldids.get(i);
	String isview=(String)isviews.get(i);
	String isedit=(String)isedits.get(i);
	String ismand=(String)ismands.get(i);
	String fieldhtmltype=(String)fieldhtmltypes.get(i);
	String fieldtype=(String)fieldtypes.get(i);
	String fieldlable=SystemEnv.getHtmlLabelName(Util.getIntValue((String)fieldlabels.get(i),0),user.getLanguage());
	String viewtype = (String)viewtypes.get(i);
	if(viewtype.equals("0"))
		continue;
	
	dsptypes +=","+tmpcount+"_"+isview;
	edittypes +=","+tmpcount+"_"+isedit;
	mandtypes +=","+tmpcount+"_"+ismand;
	tmpcount++;
}%>

<wea:layout>
	<wea:group attributes="{\"groupOperDisplay\":\"none\"}" context='<%=SystemEnv.getHtmlLabelName(17463,user.getLanguage()) %>'>
		<wea:item type="groupHead">
			&nbsp;
		<%if(dtladd.equals("1")){%>
		<input type=button  Class="addbtn" type=button accessKey=A onclick="addRow()" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input>
		<%}
		if(dtladd.equals("1") || dtldelete.equals("1")){%>
		<input type=button  Class="delbtn" type=button accessKey=E onclick="deleteRow1();" title="<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>"></input>
		<%}%>
		</wea:item>
		<wea:item attributes="{\"isTableList\":\"true\"}">
            <table Class="ListStyle" cellspacing=1 cols=6 id="oTable">
              <COLGROUP>
              <tr class=header>
                <td width="5%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(15486,user.getLanguage())%></td>
<!---
从表信息读取..
-->
<%
for(int i=0;i<fieldids.size();i++){
	String fieldname=(String)fieldnames.get(i);
	String fieldid=(String)fieldids.get(i);
	String isview=(String)isviews.get(i);
	String isedit=(String)isedits.get(i);
	String ismand=(String)ismands.get(i);
	String fieldhtmltype=(String)fieldhtmltypes.get(i);
	String fieldtype=(String)fieldtypes.get(i);
	String fieldlable=SystemEnv.getHtmlLabelName(Util.getIntValue((String)fieldlabels.get(i),0),user.getLanguage());
	String viewtype = (String)viewtypes.get(i);
	if(viewtype.equals("0"))
		continue;
%>
    	  
            <td <%if(isview.equals("0")){%> style="display:none" <%}%> width="<%=90/viewCount%>%"><%=Util.toScreen(fieldlable,user.getLanguage())%></td>
<%}%>
            </tr>
</table>
		</wea:item>
	</wea:group>
</wea:layout>
<input type='hidden' id=nodesnum name=nodesnum value="0">
<input type='hidden' id=rowneed name=rowneed value="<%=dtlneed %>">
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
<input type="hidden" name="f_weaver_belongto_userid" value="<%=request.getParameter("f_weaver_belongto_userid") %>">
<input type="hidden" name="f_weaver_belongto_usertype" value="<%=request.getParameter("f_weaver_belongto_usertype") %>">
</form> 
<script language=javascript>
rowindex = 0;
needcheck = "<%=needcheck%>";
function addRow()
{
	ncol = 6;
	dsptypes = "<%=dsptypes%>";
	edittypes = "<%=edittypes%>";
	mandtypes = "<%=mandtypes%>";
	var rownum = oTable.rows.length;
	oRow = oTable.insertRow(rownum);
	//rowindex = oRow.rowIndex;
	if (0 == rowindex % 2)
    {
        oRow.className = "DataLight";
    }
    else
    {
        oRow.className = "DataDark";
    }
	
	//alert("ncol : "+ncol+" rowindex : "+rowindex);
	
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(j);  
		oCell.style.height=24;
		//oCell.style.background= "#D2D1F1";
		if(dsptypes.indexOf(j+"_0")!=-1){
			oCell.style.display="none";
		}
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_node' value='"+rowindex+"'><input type='hidden' name='check_node_val' value='"+rowindex+"'>"; 
				oDiv.innerHTML = sHtml+"<span serialno>&nbsp;&nbsp;&nbsp;"+rownum+"</span>";
				oCell.appendChild(oDiv);
				jQuery(oCell).jNice();
				break;
			
			case 1: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
				if(edittypes.indexOf("1_1")!=-1){
					//sHtml = "<button class=Browser onClick='onShowCptCapital(node_"+rowindex+"_capitalidspan,node_"+rowindex+"_capitalid,node_"+rowindex+"_number,node_"+rowindex+"_numberspan,node_"+rowindex+"_capitalcount)'></button> " + 
        			//		"<span id=node_"+rowindex+"_capitalidspan>";
        			oDiv.innerHTML="<div class='e8Browser'></div><input type='hidden' name='node_"+rowindex+"_capitalcount' id='node_"+rowindex+"_capitalcount'>";
        			oCell.appendChild(oDiv);
			        try
			        {
			        	var tempisMustInput = "1";
			        	if(mandtypes.indexOf("1_1")!=-1){
        					tempisMustInput = "2";
        					needcheck += ","+"node_"+rowindex+"_capitalid";
        				}
				       	jQuery(oDiv).find(".e8Browser").e8Browser({
						   name:"node_"+rowindex+"_capitalid",
						   viewType:"0",
						   browserValue:"",
						   isMustInput:tempisMustInput,
						   browserSpanValue:"",
						   getBrowserUrlFn:'onShowTableUrl',
						   getBrowserUrlFnParams:"",
						   hasInput:true,
						   linkUrl:"#",
						   isSingle:true,
						   completeUrl:"/data.jsp?type=23&cptstateid=1,2,3,4&inculdeNumZero=0",
						   browserUrl:"",
						   width:'160px',
						   hasAdd:false,
						   isSingle:true,
						   _callback:"onSetCptCapital"
						});
					}
					catch(e)
					{
						alert(e);
					}
				}
				break;
			case 2: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
				if(edittypes.indexOf("2_1")!=-1){
					if(mandtypes.indexOf("2_1")!=-1){
						sHtml = "<input type='text' class=Inputstyle  id='node_"+rowindex+"_number' name='node_"+rowindex+"_number' onKeyPress='ItemNum_KeyPress()' onBlur=\"checknumber1(this);checkinput('node_"+rowindex+"_number','node_"+rowindex+"_numberspan');checkCount("+rowindex+")\"><span id='node_"+rowindex+"_numberspan'>";
						sHtml += "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
						sHtml+="</span>";
        					needcheck += ","+"node_"+rowindex+"_number";
        				}else{
        					sHtml = "<input type='text' class=Inputstyle  id='node_"+rowindex+"_number' name='node_"+rowindex+"_number'onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this);checkCount("+rowindex+")'><span id='node_"+rowindex+"_numberspan'></span>";
        				}
	        			oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
				}else{
                    sHtml = "<input type='hidden' class=Inputstyle  id='node_"+rowindex+"_number' name='node_"+rowindex+"_number'><span id='node_"+rowindex+"_numberspan'></span>";
	        	    oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv); 
                }
				break;
				
			case 3: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
				if(edittypes.indexOf("3_1")!=-1){
					sHtml = "<button class=e8_browflow type=button onClick='onBillCPTShowDate(node_"+rowindex+"_needdatespan,node_"+rowindex+"_needdate,"+mandtypes.indexOf("3_1")+")'></button> " + 
						"<span id=node_"+rowindex+"_needdatespan> ";
					if(mandtypes.indexOf("3_1")!=-1){
        					sHtml += "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
        					needcheck += ","+"node_"+rowindex+"_needdate";
        				}
        				sHtml+="</span>"
        				sHtml += "<input type='hidden' name='node_"+rowindex+"_needdate' id='node_"+rowindex+"_needdate'>";
        				oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
        			}
				break;
				
			case 4: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
				if(edittypes.indexOf("4_1")!=-1){
					if(mandtypes.indexOf("4_1")!=-1){
						sHtml = "<input type='text' class=Inputstyle  value='0'  name='node_"+rowindex+"_fee'  onKeyPress='ItemNum_KeyPress()' onBlur=checknumber1(this);checkinput('node_"+rowindex+"_fee','node_"+rowindex+"_feespan')><span id='node_"+rowindex+"_feespan'>";
						sHtml += "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
        					needcheck += ","+"node_"+rowindex+"_fee";
        					sHtml+="</span>"
        				}else{
        					sHtml = "<input type='text'  value='0' onBlur='checknumber1(this);' class=Inputstyle  name='node_"+rowindex+"_fee'>";
        				}
        				
        				oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
        			}
				break;
			case 5: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
				if(edittypes.indexOf("5_1")!=-1){
					if(mandtypes.indexOf("5_1")!=-1){
						sHtml = "<input type='text' class=Inputstyle   name='node_"+rowindex+"_remark'  onKeyPress='ItemNum_KeyPress()' onBlur=checkinput('node_"+rowindex+"_remark','node_"+rowindex+"_remarkspan')><span id='node_"+rowindex+"_remarkspan'>";
						sHtml += "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
        					needcheck += ","+"node_"+rowindex+"_remark";
        					sHtml+="</span>"
        				}else{
        					sHtml = "<input type='text' class=Inputstyle   name='node_"+rowindex+"_remark'>";
        				}
        				
        				oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
        			}
				break;
				
		}
	}
	//if ("<%=needcheck%>" != ""){
	    document.all("needcheck").value += ","+needcheck;
	//}
	rowindex = rowindex*1+1;
	document.frmmain.nodesnum.value = rowindex ;
}

<%
if(dtldefault.equals("1"))
{
%>
for(var k=0;k<'<%=dtldefaultrows %>';k++){
addRow();
}
<%	
}
%>
function checkCount(index){
    var stockamount = document.all("node_"+index+"_capitalcount").value;
    var useamount = document.all("node_"+index+"_number").value;
    if(eval(useamount)>eval(stockamount)){
        alert("<%=SystemEnv.getHtmlLabelName(1386,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1331,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1446,user.getLanguage())%>");
        document.all("node_"+index+"_number").value = stockamount;
    }
}

function deleteRow1()
{
    var flag = false;
	var ids = document.getElementsByName('check_node');
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
                if (document.forms[0].elements[i].name=='check_node')
                    rowsum1 += 1;
            }
           
            var sumnum = rowsum1;
            mandtypes = "<%=mandtypes%>";
            for(i=len-1; i >= 0;i--) {
                if (document.forms[0].elements[i].name=='check_node'){
                    if(document.forms[0].elements[i].checked==true) {
                        tmprow = document.forms[0].elements[i].value;
                        oTable.deleteRow(rowsum1);
						sumnum -=1;
                    }
                    rowsum1 -=1;
                }
            }
            //document.frmmain.nodesnum.value = sumnum ;
            reloadSerialNum();
        }
    }else{
        alert('<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>');
		return;
    }
	
}	
function reloadSerialNum(){
	jQuery(oTable).find("tr").each(function(index,item){
		jQuery(item).find("span[serialno]").html("&nbsp;&nbsp;&nbsp;"+index);
	});
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
function onShowTableUrl()
{
	return "/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp?sqlwhere=where isdata=2&cptstateid=1,2,3,4&inculdeNumZero=0";
}
function onSetCptCapital(event,data,name)
{
	var obj= event.target || event.srcElement;
	try
	{
		var rowindex = 0;
		var namearr=name.split("_");
		if(namearr&&namearr[1]){
			rowindex=namearr[1];
		}
		if (data) 
		{
			if (wuiUtil.getJsonValueByIndex(data, 0) != "") 
			{
				
				jQuery("#node_"+rowindex+"_capitalidspan").html("<a href='/cpt/capital/CptCapital.jsp?id="+data.id+"' target='_blank'>"+data.name+"</a>");
				jQuery("#node_"+rowindex+"_capitalid").val(data.id);
		        jQuery("#node_"+rowindex+"_number").val(data.other6);
		        jQuery("#node_"+rowindex+"_capitalcount").val(data.other6);
		        jQuery("#node_"+rowindex+"_numberspan").html("");
		    }
			else
			{
				jQuery("#node_"+rowindex+"_capitalidspan").html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
				jQuery("#node_"+rowindex+"_capitalid").val('');
			}
		}
	}
	catch(e)
	{
	}
}
</script>
<script language=vbs>
sub onShowAsset(spanname,inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CptAssortmentBrowser.jsp")
	if NOT isempty(id) then
	    if id(0)<> "" and id(0)<> "0" then
		spanname.innerHtml = id(1)
		inputname.value=id(0)
		else
		spanname.innerHtml =  "<img src='/images/BacoError_wev8.gif' align=absmiddle>"
		inputname.value=""
		end if
	end if
end sub

sub onShowCptCapital(spanname,inputname,inputnumber,inputnumberspan,inputcount)
	mand = 1
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp?sqlwhere=where isdata=2&cptstateid=1,2,3,4")
	if NOT isempty(id) then
	    if id(0)<> "" and id(0)<> "0" then
		spanname.innerHtml = "<a href='/cpt/capital/CptCapital.jsp?id="&id(0)&"'>"&id(1)&"</a>"
		inputname.value=id(0)
        inputnumber.value=id(7)
        inputcount.value=id(7)
        inputnumberspan.innerHtml =  ""
		else
		if mand=1 then
		spanname.innerHtml =  "<img src='/images/BacoError_wev8.gif' align=absmiddle>"
		else 
		spanname.innerHtml =  ""
		end if
		inputname.value=""
		end if
	end if
end sub
</script>
