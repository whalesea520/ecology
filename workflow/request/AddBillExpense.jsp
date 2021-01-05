<%@page import="weaver.workflow.field.BrowserComInfo"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/workflow/request/WorkflowAddRequestTitle.jsp" %>
<jsp:useBean id="WFNodeDtlFieldManager" class="weaver.workflow.workflow.WFNodeDtlFieldManager" scope="page" />
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<form name="frmmain" method="post" action="BillExpenseOperation.jsp" enctype="multipart/form-data">
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

RecordSet.executeSql("select sum(amount) from fnaloaninfo where organizationtype=3 and organizationid="+userid);
RecordSet.next();
double loanamount=Util.getDoubleValue(RecordSet.getString(1),0);   

int subjectFieldId = 0;
RecordSet.executeSql("select * from workflow_billfield where billid = 7  and   fieldname='feetypeid' ");
if(RecordSet.next()){
	subjectFieldId = RecordSet.getInt("id");
}
%>
<wea:layout>
	<wea:group attributes="{\"groupOperDisplay\":\"none\"}" context='<%=SystemEnv.getHtmlLabelNames("368,15805",user.getLanguage()) %>'>
		<wea:item attributes="{\"isTableList\":\"true\"}">
    <table class="ViewForm">
		<colgroup>
			<col width="20%">
			<col width="80%">
		<tr style="height:1px;"><td class=Line1 colSpan=2></td></tr>
		<tr>
			<td class="fieldnameClass"><%=SystemEnv.getHtmlLabelName(16271,user.getLanguage())%></td>
        	<td class="fieldvalueClass"><%=loanamount%></td>
		</tr>
		<tr style="height:1px;"><td class=Line1 colSpan=2></td></tr>
	</table>
		</wea:item>
	</wea:group>
</wea:layout>

    <script language=javascript>
        fieldorders = new Array() ;
        isedits = new Array() ;
        ismands = new Array() ;
    </script>
    
	<%
            int colcount = 0 ;
            int colwidth = 0 ;
            fieldids.clear() ;
            fieldlabels.clear() ;
            fieldhtmltypes.clear() ;
            fieldtypes.clear() ;
            fieldnames.clear() ;
            fieldviewtypes.clear() ;

            RecordSet.executeProc("workflow_billfield_Select",formid+"");
            while(RecordSet.next()){
                String theviewtype = Util.null2String(RecordSet.getString("viewtype")) ;
                if( !theviewtype.equals("1") ) continue ;   // 如果是单据的主表字段,不显示

                fieldids.add(Util.null2String(RecordSet.getString("id")));
                fieldlabels.add(Util.null2String(RecordSet.getString("fieldlabel")));
                fieldhtmltypes.add(Util.null2String(RecordSet.getString("fieldhtmltype")));
                fieldtypes.add(Util.null2String(RecordSet.getString("type")));
                fieldnames.add(Util.null2String(RecordSet.getString("fieldname")));
                fieldviewtypes.add(theviewtype);
            }

            // 确定字段是否显示，是否可以编辑，是否必须输入
            isfieldids.clear() ;              //字段队列
            isviews.clear() ;              //字段是否显示队列
            isedits.clear() ;              //字段是否可以编辑队列
            ismands.clear() ;              //字段是否必须输入队列

            RecordSet.executeProc("workflow_FieldForm_Select",nodeid+"");
            while(RecordSet.next()){
                String thefieldid = Util.null2String(RecordSet.getString("fieldid")) ;
                int thefieldidindex = fieldids.indexOf( thefieldid ) ;
                if( thefieldidindex == -1 ) continue ;
                String theisview = Util.null2String(RecordSet.getString("isview")) ;
                if( theisview.equals("1") ) colcount ++ ;
                isfieldids.add(thefieldid);
                isviews.add(theisview);
                isedits.add(Util.null2String(RecordSet.getString("isedit")));
                ismands.add(Util.null2String(RecordSet.getString("ismandatory")));
            }

            if( colcount != 0 ) colwidth = 95/colcount ;

            ArrayList viewfieldnames = new ArrayList() ;

            // 得到每个字段的信息并在页面显示

            int detailfieldcount = -1 ;
            //modify by xhheng @20050323 for TD 1703，组装明细部check串
            String needcheckdtl="";
            		
    %>
<wea:layout>
	<wea:group attributes="{\"groupOperDisplay\":\"none\"}" context='<%=SystemEnv.getHtmlLabelName(27575,user.getLanguage()) %>'>
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
            <table Class="ListStyle" id="oTable">
              <COLGROUP>
              <tr class=header>
                <td width="5%">&nbsp;</td>
   <%
            for(int i=0;i<fieldids.size();i++){         // 循环开始

                String fieldid=(String)fieldids.get(i);  //字段id
                String isview="0" ;    //字段是否显示
                String isedit="0" ;    //字段是否可以编辑
                String ismand="0" ;    //字段是否必须输入

                int isfieldidindex = isfieldids.indexOf(fieldid) ;
                if( isfieldidindex != -1 ) {
                    isview=(String)isviews.get(isfieldidindex);    //字段是否显示
                    isedit=(String)isedits.get(isfieldidindex);    //字段是否可以编辑
                    ismand=(String)ismands.get(isfieldidindex);    //字段是否必须输入
                }
                if( ! isview.equals("1") ) continue ;           //不显示即进行下一步循环

                String fieldname = "" ;                         //字段数据库表中的字段名
                String fieldlable = "" ;                        //字段显示名
                int languageid = 0 ;

                fieldname=(String)fieldnames.get(i);
                languageid = user.getLanguage() ;
                fieldlable = SystemEnv.getHtmlLabelName( Util.getIntValue((String)fieldlabels.get(i),0),languageid );

                viewfieldnames.add(fieldname) ;
%>
                <td width="<%=colwidth%>%"><%=fieldlable%></td>
                <script language=javascript>
                    <% if (fieldname.equals("relatedate")) { 
                      detailfieldcount++ ;  
                      if(ismand.equals("1")) needcheckdtl += ",relatedate_\"+insertindex+\"";%>
                      fieldorders[<%=detailfieldcount%>] = 1 ;
                    <% } else if (fieldname.equals("feetypeid")) { 
                      detailfieldcount++ ;
                      if(ismand.equals("1")) needcheckdtl += ",feetypeid_\"+insertindex+\"";%>
                      fieldorders[<%=detailfieldcount%>] = 2 ;
                    <% } else if (fieldname.equals("detailremark")) { 
                      detailfieldcount++ ;
                      if(ismand.equals("1")) needcheckdtl += ",detailremark_\"+insertindex+\"";%>
                      fieldorders[<%=detailfieldcount%>] = 3 ;
                    <% } else if (fieldname.equals("accessory")) { 
                      detailfieldcount++ ;
                      if(ismand.equals("1")) needcheckdtl += ",accessory_\"+insertindex+\"";%>
                      fieldorders[<%=detailfieldcount%>] = 4 ;
                    <% } else if (fieldname.equals("relatedcrm")) { 
                      detailfieldcount++ ;
                      if(ismand.equals("1")) needcheckdtl += ",relatedcrm_\"+insertindex+\"";%>
                      fieldorders[<%=detailfieldcount%>] = 5 ;
                    <% } else if (fieldname.equals("relatedproject")) { 
                      detailfieldcount++ ;
                      if(ismand.equals("1")) needcheckdtl += ",relatedproject_\"+insertindex+\"";%>
                      fieldorders[<%=detailfieldcount%>] = 6 ;
                    <% } else if (fieldname.equals("feesum")) { 
                      detailfieldcount++ ;
                      if(ismand.equals("1")) needcheckdtl += ",feesum_\"+insertindex+\"";%>
                      fieldorders[<%=detailfieldcount%>] = 7 ;
                    <% } else if (fieldname.equals("realfeesum")) { 
                      detailfieldcount++ ;
                      if(ismand.equals("1")) needcheckdtl += ",realfeesum_\"+insertindex+\"";%>
                      fieldorders[<%=detailfieldcount%>] = 8 ;
                    <% } else if (fieldname.equals("invoicenum")) { 
                      detailfieldcount++ ;
                      if(ismand.equals("1")) needcheckdtl += ",invoicenum_\"+insertindex+\"";%>
                      fieldorders[<%=detailfieldcount%>] = 9 ;

					<% } else if (fieldname.equals("relaterequest")) { 
                      detailfieldcount++ ;
                      if(ismand.equals("1")) needcheckdtl += ",relaterequest_\"+insertindex+\"";%>
                      fieldorders[<%=detailfieldcount%>] = 10 ;

                    <% } %>
                    isedits[<%=detailfieldcount%>] = <%=isedit%> ;
                    ismands[<%=detailfieldcount%>] = <%=ismand%> ;
                </script>
<%          }
%>
              </tr>


              <tr class="header" style="FONT-WEIGHT: bold; COLOR: red">
                <td>合计</td>
<%          for(int i=0;i<viewfieldnames.size();i++){
                String thefieldname = (String)viewfieldnames.get(i) ;
%>
                <td <% if(thefieldname.equals("accessory")) {%> id=accessorycount
                    <% } else if(thefieldname.equals("feesum")) {%> id=expensecountspan
                    <% } else if(thefieldname.equals("realfeesum")) {%> id=realcountspan<%}%>>&nbsp;
                </td>
<%          }
%>
              </tr>
            </table>
		</wea:item>
	</wea:group>
</wea:layout>
    
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
    
    <input type='hidden' id=nodesnum name=nodesnum value="0">
    <input type='hidden' id="indexnum" name="indexnum" value="0">
    <input type='hidden' id=rowneed name=rowneed value="<%=dtlneed %>">
<input type="hidden" name="f_weaver_belongto_userid" value="<%=request.getParameter("f_weaver_belongto_userid") %>">
<input type="hidden" name="f_weaver_belongto_usertype" value="<%=request.getParameter("f_weaver_belongto_usertype") %>">
</form>
<script language="JavaScript" src="/js/addRowBg_wev8.js?r=9"></script>

<script type="text/javascript">
var browserUtl_subject = "<%=new BrowserComInfo().getBrowserurl("22") %>";
var browserUtl_hrm = "<%=new BrowserComInfo().getBrowserurl("1") %>%3Fshow_virtual_org=-1";
var browserUtl_dep = "<%=new BrowserComInfo().getBrowserurl("4") %>%3Fshow_virtual_org=-1";
var browserUtl_sub = "<%=new BrowserComInfo().getBrowserurl("164") %>%3Fshow_virtual_org=-1";
var browserUtl_prj = "<%=new BrowserComInfo().getBrowserurl("8") %>";
var browserUtl_crm = "<%=new BrowserComInfo().getBrowserurl("7") %>";
var browserUtl_req = "<%=new BrowserComInfo().getBrowserurl("16") %>";

var rowColor="" ;
rowindex = 0 ;
insertindex=0;
deleteindex=0;
deletearray = new Array() ;
thedeletelength=0;

function addRow()
{
	rowColor = getRowClassName();//getRowBg();
    oRow = oTable.insertRow(rowindex+1);
    curindex=parseInt($GetEle('nodesnum').value);

    for(j=0; j < fieldorders.length+1; j++) {
        oCell = oRow.insertCell(-1);
        oCell.style.height=24;
        //oCell.style.background= rowColor;
        oCell.className = rowColor;
        if( j == 0 ) {
            var oDiv = document.createElement("div");
            var sHtml = "<input type='checkbox' name='check_node' value='"+insertindex+"'>";
            oDiv.innerHTML = sHtml;
            oCell.appendChild(oDiv);
        } else {
            dsporder = fieldorders[j-1] ;
            isedit = isedits[j-1] ;
            ismand = ismands[j-1] ;

            if( isedit != 1 ) {
                var oDiv = document.createElement("div");
                var sHtml = "&nbsp;";
                oDiv.innerHTML = sHtml;
                oCell.appendChild(oDiv);
            } else {
                switch (dsporder)  {
                    case 1 :
                        var oDiv = document.createElement("div");

                        var detailbrowclick = "onShowBrowser2_fna('relatedate_"+insertindex+"','','','2','"+ismand+"')";
                        oDiv.innerHTML = "<span id='relatedate_"+insertindex+"wrapspan'></span>"+
                        	//"<input type=\"hidden\" viewtype=\""+ismand+"\" temptitle=\"\" name=\"relatedate_"+insertindex+"\" id=\"relatedate_"+insertindex+"\" value=\"\">"+
                        	"";
                        oCell.appendChild(oDiv);

                        initE8Browser("relatedate_"+insertindex, insertindex, ismand, "", "", detailbrowclick, "");
                        
                        break ;
                    case 2 :
                        var oDiv = document.createElement("div");

                        var detailbrowclick = "onShowBrowser2_fna('feetypeid_"+insertindex+"','"+browserUtl_subject+"','','22','"+ismand+"')";
                        oDiv.innerHTML = "<span id='feetypeid_"+insertindex+"wrapspan'></span>"+
                        	//"<input type=\"hidden\" viewtype=\""+ismand+"\" temptitle=\"\" name=\"feetypeid_"+insertindex+"\" id=\"feetypeid_"+insertindex+"\" value=\"\">"+
                        	"";
                        oCell.appendChild(oDiv);
                        
						initE8Browser("feetypeid_"+insertindex, insertindex, ismand, "", "", detailbrowclick, "/data.jsp?type=22&bdf_wfid=<%=workflowid%>&bdf_fieldid=<%=subjectFieldId%>");
                        
                        break ;
                    case 3 :
                        var oDiv = document.createElement("div");
                        var sHtml = "<nobr><input type='text' class=inputstyle style=width:85% name='detailremark_"+insertindex+"'";
                        if(ismand == 1)
                            sHtml += "onchange='checkinput1(detailremark_"+insertindex+",detailremarkspan_"+insertindex+")'";
                        sHtml += ">" ;
                        if(ismand == 1)
                            sHtml += "<span id='detailremarkspan_"+insertindex+"'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>";
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                    case 4 :
                        var oDiv = document.createElement("div");
                        var sHtml = "<nobr><input type='text' class=inputstyle style=width:85%  id='accessory_"+insertindex+"' name='accessory_"+insertindex+"' maxlength='10' onKeyPress='ItemCount_KeyPress()' onBlur='checkcount1(this);" ;
                        if(ismand == 1)
                            sHtml += "checkinput1(accessory_"+ insertindex+",accessoryspan_"+insertindex+");" ;
                        sHtml += "changeaccessory();'>" ;
                        if(ismand == 1)
                            sHtml += "<span id='accessoryspan_"+insertindex+"'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>";
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                    case 5 :
                        var oDiv = document.createElement("div");

                        var detailbrowclick = "onShowBrowser2_fna('relatedcrm_"+insertindex+"','"+browserUtl_crm+"','','7','"+ismand+"')";
                        oDiv.innerHTML = "<span id='relatedcrm_"+insertindex+"wrapspan'></span>"+
                        	//"<input type=\"hidden\" viewtype=\""+ismand+"\" temptitle=\"\" name=\"relatedcrm_"+insertindex+"\" id=\"relatedcrm_"+insertindex+"\" value=\"\">"+
                        	"";
                        oCell.appendChild(oDiv);

						initE8Browser("relatedcrm_"+insertindex, insertindex, ismand, "", "", detailbrowclick, "/data.jsp?type=7");
                        
                        break ;
                    case 6 :
                        var oDiv = document.createElement("div");

                        var detailbrowclick = "onShowBrowser2_fna('relatedproject_"+insertindex+"','"+browserUtl_prj+"','','8','"+ismand+"')";
                        oDiv.innerHTML = "<span id='relatedproject_"+insertindex+"wrapspan'></span>"+
                        	//"<input type=\"hidden\" viewtype=\""+ismand+"\" temptitle=\"\" name=\"relatedproject_"+insertindex+"\" id=\"relatedproject_"+insertindex+"\" value=\"\">"+
                        	"";
                        oCell.appendChild(oDiv);
                        
						initE8Browser("relatedproject_"+insertindex, insertindex, ismand, "", "", detailbrowclick, "/data.jsp?type=8");
                        
                        break ;
                    case 7 :
                        var oDiv = document.createElement("div");
                        var sHtml = "<input type='text' class=inputstyle style=width:85%  id='feesum_"+insertindex+"' name='feesum_"+insertindex+"' maxlength='10' onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this);" ;
                        if(ismand == 1)
                            sHtml += "checkinput1(feesum_"+insertindex+",feesumspan_"+insertindex+");" ;
                        sHtml += "changenumber();'>" ;
                        if(ismand == 1)
                            sHtml += "<span id='feesumspan_"+insertindex+"'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>";
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                    case 8 :
                        var oDiv = document.createElement("div");
                        var sHtml = "<input type='text' class=inputstyle style=width:85%  id='realfeesum_"+insertindex+"' name='realfeesum_"+insertindex+"' maxlength='10' onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this);" ;
                        if(ismand == 1)
                            sHtml += "checkinput1(realfeesum_"+ insertindex+",realfeesumspan_"+insertindex+");" ;
                        sHtml += "changereal();'>" ;
                        if(ismand == 1)
                            sHtml += "<span id='realfeesumspan_"+insertindex+"'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>";
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                    case 9 :
                        var oDiv = document.createElement("div");
                        var sHtml = "<input type='text' class=inputstyle style=width:85%  id='invoicenum_"+insertindex+"' name='invoicenum_"+insertindex+"' " ;
                        if(ismand == 1)
                            sHtml += "onchange='checkinput1(invoicenum_"+insertindex+",invoicenumspan_"+insertindex+")'";
                        sHtml += ">" ;
                        if(ismand == 1)
                            sHtml += "<span id='invoicenumspan_"+insertindex+"'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>";
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
					case 10 :
                        var oDiv = document.createElement("div");

                        var detailbrowclick = "onShowBrowser2_fna('relaterequest_"+insertindex+"','"+browserUtl_req+"','/workflow/request/ViewRequest.jsp?isrequest=1&requestid=','16','"+ismand+"')";
                        oDiv.innerHTML = "<span id='relaterequest_"+insertindex+"wrapspan'></span>"+
                        	//"<input type=\"hidden\" viewtype=\""+ismand+"\" temptitle=\"\" name=\"relaterequest_"+insertindex+"\" id=\"relaterequest_"+insertindex+"\" value=\"\">"+
                        	"";
                        oCell.appendChild(oDiv);
                        
						initE8Browser("relaterequest_"+insertindex, insertindex, ismand, "", "", detailbrowclick, "/data.jsp?type=16", "/workflow/request/ViewRequest.jsp?isrequest=1&requestid=");
                        break ;
                }
            }
        }
    }
    if ("<%=needcheckdtl%>" != ""){
        $GetEle("needcheck").value += "<%=needcheckdtl%>";
    }
    insertindex = insertindex*1 +1;
    rowindex = curindex*1 +1;
    $GetEle("nodesnum").value = rowindex;
    $GetEle("indexnum").value = insertindex;

    try{jQuery('body').jNice();}catch(ex1){}
    try{beautySelect();}catch(ex1){}
}
<%
if(dtldefault.equals("1"))
{
%>
addRow();
<%
	RecordSet.executeSql(" select defaultrows from workflow_NodeFormGroup where nodeid=" + nodeid + " and groupid=0");
	RecordSet.next();
	int defaultrows = Util.getIntValue(RecordSet.getString("defaultrows"),0);
%>
var defaultrows = <%=defaultrows %>;
for(var k = 0; k < parseInt(defaultrows)-1; k++) {
	addRow();						
}
<%	
}
%>
function changeaccessory() {
    countaccessory = 0 ;
    for(j=0;j<insertindex;j++) {
        hasdelete = false ;
        for(k=0;k<deletearray.length;k++){
            if(j==deletearray[k])
            hasdelete=true;
        }
        if(hasdelete) continue ;
        countaccessory += eval(toInt($GetEle("accessory_"+j).value,0)) ;
    }
    accessorycount.innerHTML = countaccessory ;
}

function changenumber(){

    count_total = 0 ;

    for(j=0;j<insertindex;j++) {
        hasdelete = false ;
        for(k=0;k<deletearray.length;k++){
            if(j==deletearray[k])
            hasdelete=true;
        }
        if(hasdelete) continue ;
        count_total+= eval(toFloat($GetEle("feesum_"+j).value,0)) ;
    }
    expensecountspan.innerHTML = count_total.toFixed(3);


}

function changereal(){

	count_total = 0 ;

	for(j=0;j<insertindex;j++) {
		count_total+= eval(toFloat($GetEle("realfeesum_"+j).value,0)) ;
	}
	realcountspan.innerHTML = count_total.toFixed(3);
}

function toFloat(str , def) {
    if(isNaN(parseFloat(str))) return def ;
    else return str ;
}

function toInt(str , def) {
    if(isNaN(parseInt(str))) return def ;
    else return str ;
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
            var therowindex = 0 ;
            var rowsum1 = 0;
            rowindex=parseInt($GetEle("nodesnum").value);
            for(i=len-1; i >= 0;i--) {
                if (document.forms[0].elements[i].name=='check_node')
                    rowsum1 += 1;
            }
            for(i=len-1; i >= 0;i--) {
                if (document.forms[0].elements[i].name=='check_node'){
                    if(document.forms[0].elements[i].checked==true) {
                        therowindex = document.forms[0].elements[i].value ;
                        deletearray[thedeletelength] = therowindex ;
                        thedeletelength ++ ;
                        oTable.deleteRow(rowsum1);
                        rowindex--;
                    }
                    rowsum1 -=1;
                }

            }

            changeaccessory() ;
            changenumber() ;
            $GetEle("frmmain").nodesnum.value = rowindex ;
        }
    }else{
        alert('<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>');
		return;
    }
}
</script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
