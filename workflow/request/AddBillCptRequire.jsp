
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.general.browserData.BrowserManager"%>
<%@ page import="weaver.workflow.request.RevisionConstants" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/workflow/request/WorkflowAddRequestTitle.jsp" %>
<jsp:useBean id="WFNodeDtlFieldManager" class="weaver.workflow.workflow.WFNodeDtlFieldManager" scope="page" />
<form name="frmmain" method="post" action="BillCptRequireOperation.jsp" enctype="multipart/form-data">
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

String groupIdName = "" ;
for(int i=0;i<fieldids.size();i++){         // ???·????
	 groupIdName = (String)fieldnames.get(i) ;
	 if (groupIdName.equals("groupid")) {
		groupIdName = "field" + (String)fieldids.get(i) ;
		break;
	 }	  
}
		  
String thefileid = "" ;
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
	
	if(tmpcount<10){
		dsptypes +=",0"+tmpcount+"_"+isview;
		edittypes +=",0"+tmpcount+"_"+isedit;
		mandtypes +=",0"+tmpcount+"_"+ismand;
	}else{
		
		dsptypes +=","+tmpcount+"_"+isview;
		edittypes +=","+tmpcount+"_"+isedit;
		mandtypes +=","+tmpcount+"_"+ismand;
	}
	tmpcount++;
}
%>
<wea:layout>
	<wea:group attributes="{\"groupOperDisplay\":\"none\"}" context='<%=SystemEnv.getHtmlLabelNames("535,17463",user.getLanguage()) %>'>
		<wea:item type="groupHead">
		<%if(dtladd.equals("1")){%>
		<input type=button  Class="addbtn" type=button accessKey=A onclick="addRow()" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input>
		<%}
		if(dtladd.equals("1") || dtldelete.equals("1")){%>
		<input type=button  Class="delbtn" type=button accessKey=E onclick="deleteRow1();" title="<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>"></input>
		<%}%>
		</wea:item>
		<wea:item attributes="{\"isTableList\":\"true\"}">
			<table Class="ListStyle" cellspacing=1 id="oTable">
		   		<tr class=header> 
		   			<td width="5%">&nbsp;</td>
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
    	  
            <td <%if(isview.equals("0")){%> style="display:none" <%}%> width="<%=95/viewCount%>%"><%=Util.toScreen(fieldlable,user.getLanguage())%></td>
<%}%>
            </tr>    
	
  			</table>
  		</wea:item>
  </wea:group>
</wea:layout>
    <input type='hidden' id=nodesnum name=nodesnum>
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
</form> 
<script language=javascript>
rowindex = 0;
needcheck = "";
groupid = "1";
function changetype(obj){
	groupid = obj.value;		
//	obj.disabled = true;
}

function addRow()
{
	needcheck = "";
	ncol = 11;
	dsptypes = "<%=dsptypes%>";
	edittypes = "<%=edittypes%>";
	mandtypes = "<%=mandtypes%>";
	needcheck = "";
	var rownum = oTable.rows.length;
	oRow = oTable.insertRow(rownum);
	rowindex = oRow.rowIndex;
	if (0 == rowindex % 2)
    {
        oRow.className = "DataLight";
    }
    else
    {
        oRow.className = "DataDark";
    }
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1);  
		oCell.style.height=24;
		oCell.style.background= "#D2D1F1";
		
		if(j<10 && dsptypes.indexOf("0"+j+"_0")!=-1){
			oCell.style.display="none";
		}
		else if(j>9 && dsptypes.indexOf(j+"_0")!=-1){
			oCell.style.display="none";
		}
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_node' value='"+rowindex+"'>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			
			case 1: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
				if(edittypes.indexOf("01_1")!=-1){					
					oDiv.innerHTML="<div class='e8Browser'></div>";
        			oCell.appendChild(oDiv);
        			var tempisMustInput = "1";
        			if(mandtypes.indexOf("01_1")!=-1){
       					tempisMustInput = "2";
       					needcheck += ","+"node_"+rowindex+"_cpttype";
       				}
					
					jQuery(oDiv).find(".e8Browser").e8Browser({
						   name:"node_"+rowindex+"_cptid",
						   viewType:"0",
						   browserValue:"",
						   isMustInput:"1",
						   browserSpanValue:"",
						   getBrowserUrlFn:'onShowTableUrl',
						   getBrowserUrlFnParams:"",
						   hasInput:true,
						   linkUrl:"#",
						   isSingle:true,
						   isMustInput:'1',
						   completeUrl:"/data.jsp",
						   browserUrl:"",
						   width:'90%',
						   hasAdd:false,
						   isSingle:true,
						   _callback:"onSetCptCapital"
					});
				}
				break;
			case 2: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
				if(edittypes.indexOf("02_1")!=-1){					
					oDiv.innerHTML="<div class='e8Browser'></div>";
        			oCell.appendChild(oDiv);
        			var tempisMustInput = "1";
        			if(mandtypes.indexOf("02_1")!=-1){
       					tempisMustInput = "2";
       					needcheck += ","+"node_"+rowindex+"_cptid";
       				}
					
					jQuery(oDiv).find(".e8Browser").e8Browser({
						   name:"node_"+rowindex+"_cptid",
						   viewType:"0",
						   browserValue:"",
						   isMustInput:"1",
						   browserSpanValue:"",
						   getBrowserUrlFn:'onShowTableUrl1',
						   getBrowserUrlFnParams:"",
						   hasInput:true,
						   linkUrl:"#",
						   isSingle:true,
						   isMustInput:'1',
						   completeUrl:"/data.jsp",
						   browserUrl:"",
						   width:'90%',
						   hasAdd:false,
						   isSingle:true,
						   _callback:"onSetCptCapital1"
					});
				}
				break;
			case 3: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
				if(edittypes.indexOf("03_1")!=-1){
					if(mandtypes.indexOf("03_1")!=-1){ 
						sHtml = "<input type='text' class=Inputstyle  name='node_"+rowindex+"_number' onKeyPress='ItemNum_KeyPress()' onBlur=\"checknumber1(this);checkinput('node_"+rowindex+"_number','node_"+rowindex+"_numberspan')\"  maxlength=6 ><span id='node_"+rowindex+"_numberspan'>";
						sHtml += "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
						sHtml+="</span>";
        					needcheck += ","+"node_"+rowindex+"_number";
        				}else{
        					sHtml = "<input type='text' class=Inputstyle  name='node_"+rowindex+"_number' onKeyPress='ItemNum_KeyPress()' onBlur=checknumber('node_"+rowindex+"_number')  maxlength=6 >";
        				}
	        			oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
				}
				break;
			case 4: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
				if(edittypes.indexOf("04_1")!=-1){
					if(mandtypes.indexOf("04_1")!=-1){
						sHtml = "<input type='text'  class=Inputstyle  name='node_"+rowindex+"_unitprice'  onKeyPress='ItemNum_KeyPress()' onBlur=\"checknumber1(this);checkinput('node_"+rowindex+"_unitprice','node_"+rowindex+"_unitpricespan')\"  maxlength=9 ><span id='node_"+rowindex+"_unitpricespan'>";
						sHtml += "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
        					needcheck += ","+"node_"+rowindex+"_unitprice";
        					sHtml+="</span>"
        				}else{
        					sHtml = "<input type='text' class=Inputstyle   name='node_"+rowindex+"_unitprice' onKeyPress='ItemNum_KeyPress()' onBlur=checknumber('node_"+rowindex+"_unitprice')  maxlength=9 >";
        				}
        				
        				oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
        			}
				break;
			case 5: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
				if(edittypes.indexOf("05_1")!=-1){
					sHtml = "<button class=Browser onClick='onBillCPTShowDate(node_"+rowindex+"_needdatespan,node_"+rowindex+"_needdate,"+mandtypes.indexOf("05_1")+")'></button> " + 
						"<span class=Inputstyle id=node_"+rowindex+"_needdatespan> ";
					if(mandtypes.indexOf("05_1")!=-1){
        					sHtml += "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
        					needcheck += ","+"node_"+rowindex+"_needdate";
        				}
        				sHtml+="</span>"
        				sHtml += "<input type='hidden' name='node_"+rowindex+"_needdate' id='node_"+rowindex+"_needdate'>";
        				oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
        			}
				break;
			case 6: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
				if(edittypes.indexOf("06_1")!=-1){
					if(mandtypes.indexOf("06_1")!=-1){
						sHtml = "<input type='text' class=Inputstyle  name='node_"+rowindex+"_purpose' onBlur=checkinput('node_"+rowindex+"_purpose','node_"+rowindex+"_purposespan')><span id='node_"+rowindex+"_purposespan'>";
						sHtml += "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
        					needcheck += ","+"node_"+rowindex+"_purpose";
        					sHtml+="</span>"
        				}else{
        					sHtml = "<input type='text' class=Inputstyle  name='node_"+rowindex+"_purpose'>";
					}	
        				
        				oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
        			}
				break;
			case 7: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";;
				if(edittypes.indexOf("07_1")!=-1){
					if(mandtypes.indexOf("07_1")!=-1){
						sHtml = "<input type='text' class=Inputstyle  name='node_"+rowindex+"_cptdesc' onBlur=checkinput('node_"+rowindex+"_cptdesc','node_"+rowindex+"_cptdescspan')><span id='node_"+rowindex+"_cptdescspan'>";
						sHtml += "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
        					needcheck += ","+"node_"+rowindex+"_cptdesc";
        					sHtml+="</span>"        				
        				}else{
        					sHtml = "<input type='text' class=Inputstyle  name='node_"+rowindex+"_cptdesc'>";
        				}
        				oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
        			}
				break;	
			case 8: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
				if(edittypes.indexOf("08_1")!=-1){
					if(mandtypes.indexOf("08_1")!=-1){ 
						sHtml = "<input type='text' class=Inputstyle  name='node_"+rowindex+"_buynumber' onKeyPress='ItemNum_KeyPress()' onBlur=\"checknumber1(this);checkinput('node_"+rowindex+"_buynumber','node_"+rowindex+"_buynumberspan')\"  maxlength=6 ><span id='node_"+rowindex+"_buynumberspan'>";
						sHtml += "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
						sHtml+="</span>";
        					needcheck += ","+"node_"+rowindex+"_buynumber";
        				}else{
        					sHtml = "<input type='text' class=Inputstyle  name='node_"+rowindex+"_buynumber' onKeyPress='ItemNum_KeyPress()' onBlur=checknumber('node_"+rowindex+"_buynumber')  maxlength=6 >";
        				}
	        			oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
				}
				break;	
			case 9: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
				if(edittypes.indexOf("09_1")!=-1){
					if(mandtypes.indexOf("9_1")!=-1){ 
						sHtml = "<input type='text'  class=Inputstyle  name='node_"+rowindex+"_adjustnumber' onKeyPress='ItemNum_KeyPress()' onBlur=\"checknumber1(this);checkinput('node_"+rowindex+"_adjustnumber','node_"+rowindex+"_adjustnumberspan')\"  maxlength=6 ><span id='node_"+rowindex+"_adjustnumberspan'>";
						sHtml += "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
						sHtml+="</span>";
        					needcheck += ","+"node_"+rowindex+"_adjustnumber";
        				}else{
        					sHtml = "<input type='text'  class=Inputstyle  name='node_"+rowindex+"_adjustnumber' onKeyPress='ItemNum_KeyPress()' onBlur=checknumber('node_"+rowindex+"_adjustnumber') maxlength=6 >";
        				}
	        			oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
				}
				break;	
			case 10: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
				if(edittypes.indexOf("10_1")!=-1){
					if(mandtypes.indexOf("10_1")!=-1){ 
						sHtml = "<input type='text' class=Inputstyle  name='node_"+rowindex+"_fetchnumber' onKeyPress='ItemNum_KeyPress()' onBlur=\"checknumber1(this);checkinput('node_"+rowindex+"_fetchnumber','node_"+rowindex+"_fetchnumberspan')\"  maxlength=6 ><span id='node_"+rowindex+"_fetchnumberspan'>";
						sHtml += "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
						sHtml+="</span>";
        					needcheck += ","+"node_"+rowindex+"_fetchnumber";
        				}else{
        					sHtml = "<input type='text'  class=Inputstyle name='node_"+rowindex+"_fetchnumber' onKeyPress='ItemNum_KeyPress()' onBlur=checknumber('node_"+rowindex+"_fetchnumber')  maxlength=6 >";
        				}
	        			oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
				}
				break;		
		}
	}
	if (needcheck != ""){
        document.all("needcheck").value += needcheck;
    }

	rowindex = rowindex*1;
	document.frmmain.nodesnum.value = rowindex ;
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
            mandtypes = "<%=mandtypes%>";
            for(i=len-1; i >= 0;i--) {
                if (document.forms[0].elements[i].name=='check_node'){
                    if(document.forms[0].elements[i].checked==true) {
                        tmprow = document.forms[0].elements[i].value;
                        for(j=0; j<10; j++) {
                            if(mandtypes.indexOf("0"+j+"_1")!=-1){
                                if(j==1)
                                    needcheck = needcheck.replace(",node_"+tmprow+"_cpttype","");
                                if(j==2)
                                    needcheck = needcheck.replace(",node_"+tmprow+"_cptid","");
                                if(j==3)
                                    needcheck = needcheck.replace(",node_"+tmprow+"_number","");
                                if(j==4)
                                    needcheck = needcheck.replace(",node_"+tmprow+"_unitprice","");
                                if(j==5)
                                    needcheck = needcheck.replace(",node_"+tmprow+"_needdate","");
                                if(j==6)
                                    needcheck = needcheck.replace(",node_"+tmprow+"_purpose","");
                                if(j==7)
                                    needcheck = needcheck.replace(",node_"+tmprow+"_cptdesc","");
                                if(j==8)
                                    needcheck = needcheck.replace(",node_"+tmprow+"_buynumber","");
                                if(j==9)
                                    needcheck = needcheck.replace(",node_"+tmprow+"_adjustnumber","");
                                if(j==10)
                                    needcheck = needcheck.replace(",node_"+tmprow+"_fetchnumber","");

                            }
                        }
                        thetemprow = rowsum1 - 1 ;
                        oTable.deleteRow(rowsum1);
                        }
                    rowsum1 -=1;
                }
            }
            document.all("needcheck").value = needcheck;
        }
    }else{
        alert('<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>');
		return;
    }
}	
function onShowTableUrl()
{
	return "/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CptAssortmentBrowser.jsp?supassortmentid="+document.all("<%=groupIdName%>").value+"&fromcapital=2";
}

function onSetCptCapital(event,data,name)
{
	var ismust1 = <%=mandtypes.indexOf("01_1")!=-1%>
	var obj= event.target || event.srcElement;
	try
	{
		var rowindexstr = name.substring(name.indexOf("_"),name.length)
		var rowindex = rowindexstr.substring(0,rowindexstr.indexOf("_"));
		
		if (data) 
		{
			if (wuiUtil.getJsonValueByIndex(data, 0) != "") 
			{
				jQuery("#node_"+rowindex+"_cpttypespan").html(data.name);
				jQuery("#node_"+rowindex+"_cpttype").val(data.id);
		    }
			else
			{
				if(ismust1)
				{
					jQuery("#node_"+rowindex+"_cpttypespan").html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
					jQuery("#node_"+rowindex+"_cpttype").val('');
				}
				else
				{
					jQuery("#node_"+rowindex+"_cpttypespan").html("");
					jQuery("#node_"+rowindex+"_cpttype").val('');
				}
			}
		}
	}
	catch(e)
	{
	}
}
function onShowTableUrl1()
{
	return "/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp";
}

function onSetCptCapital1(event,data,name)
{
	var ismust1 = <%=mandtypes.indexOf("02_1")!=-1%>;
	var obj= event.target || event.srcElement;
	try
	{
		var rowindexstr = name.substring(name.indexOf("_"),name.length)
		var rowindex = rowindexstr.substring(0,rowindexstr.indexOf("_"));
		
		if (data) 
		{
			if (wuiUtil.getJsonValueByIndex(data, 0) != "") 
			{
				jQuery("#node_"+rowindex+"_cptidspan").html("<a href='/cpt/capital/CptCapital.jsp?id="+data.id+"'>"+data.name+"</a>");
				jQuery("#node_"+rowindex+"_cptid").val(data.id);
		    }
			else
			{
				if(ismust1)
				{
					jQuery("#node_"+rowindex+"_cptidspan").html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
					jQuery("#node_"+rowindex+"_cptid").val('');
				}
				else
				{
					jQuery("#node_"+rowindex+"_cptidspan").html("");
					jQuery("#node_"+rowindex+"_cptid").val('');
				}
			}
		}
	}
	catch(e)
	{
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
sub onShowAssetType(spanname,inputname)
    oldvalue = inputname.value
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CptAssortmentBrowser.jsp?supassortmentid="&document.all("<%=groupIdName%>").value&"&fromcapital=2")
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

sub onShowAsset(spanname,inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp")
	if NOT isempty(id) then
	    if id(0)<> "" and id(0)<> "0" then
		spanname.innerHtml = "<a href='/cpt/capital/CptCapital.jsp?id="&id(0)&"'>"&id(1)&"</a>"
		inputname.value=id(0)
		else
		spanname.innerHtml =  "<img src='/images/BacoError_wev8.gif' align=absmiddle>"
		inputname.value=""
		end if
	end if
end sub
</script>
