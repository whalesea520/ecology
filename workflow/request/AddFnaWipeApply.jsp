<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.fna.maintenance.FnaCostCenter"%>
<%@page import="weaver.workflow.field.BrowserComInfo"%>
<%@page import="weaver.fna.general.FnaBrowserElement"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.fna.general.BrowserElement"%>
<%@page import="weaver.general.Util"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/workflow/request/WorkflowAddRequestTitle.jsp" %>
<jsp:useBean id="WFNodeDtlFieldManager" class="weaver.workflow.workflow.WFNodeDtlFieldManager" scope="page" />
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<form name="frmmain" method="post" action="FnaWipeApplyOperation.jsp" enctype="multipart/form-data">
<input type="hidden" name="needwfback" id="needwfback" value="1" />
    <%@ include file="/workflow/request/WorkflowAddRequestBody.jsp" %>


    <script language=javascript>
	    var browserUtl_subject = "<%=new BrowserComInfo().getBrowserurl("22") %>";
	    var browserUtl_hrm = "<%=new BrowserComInfo().getBrowserurl("1") %>%3Fshow_virtual_org=-1";
	    var browserUtl_dep = "<%=new BrowserComInfo().getBrowserurl("4") %>%3Fshow_virtual_org=-1";
	    var browserUtl_sub = "<%=new BrowserComInfo().getBrowserurl("164") %>%3Fshow_virtual_org=-1";
	    var browserUtl_prj = "<%=new BrowserComInfo().getBrowserurl("8") %>";
	    var browserUtl_crm = "<%=new BrowserComInfo().getBrowserurl("7") %>";
	    var browserUtl_fcc = "<%=new BrowserComInfo().getBrowserurl("251") %>";
	    var _FnaBillRequestJsFlag = 1;
	    
        fieldorders = new Array() ;
        isedits = new Array() ;
        ismands = new Array() ;
        var organizationidismand=0;
        var organizationidisedit=0;
    </script>
    <style id="balancestyle">
        td.balancehide {
            display:none;
        }
    </style>
    <script type='text/javascript' src='/dwr/interface/BudgetHandler.js'></script>
    <script type='text/javascript' src='/dwr/engine.js'></script>
    <script type='text/javascript' src='/dwr/util.js'></script>


<%
RecordSet rs_11 = new RecordSet();
boolean fnaBudgetOAOrg = false;//OA组织机构
boolean fnaBudgetCostCenter = false;//成本中心
boolean subjectFilter = false;
rs_11.executeSql("select * from FnaSystemSet");
if(rs_11.next()){
	fnaBudgetOAOrg = 1==rs_11.getInt("fnaBudgetOAOrg");
	fnaBudgetCostCenter = 1==rs_11.getInt("fnaBudgetCostCenter");
	subjectFilter = 1==Util.getIntValue(rs_11.getString("subjectFilter"), 0);
}

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
int organizationidFieldId = 0;
RecordSet.executeSql("select * from workflow_billfield where  billid = 158");
while(RecordSet.next()){
	String fieldname = Util.null2String(RecordSet.getString("fieldname")).trim();
	if(fieldname.equals("subject")){
		subjectFieldId = RecordSet.getInt("id");
	}else if(fieldname.equals("organizationid")){
		organizationidFieldId = RecordSet.getInt("id");
	}
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
<br />
            <%
                String uid = "" + user.getUID();

                String uname = ResourceComInfo.getLastname(uid);
                String udept = ""+Util.getIntValue(ResourceComInfo.getDepartmentID(uid));
                String udeptname = DepartmentComInfo.getDepartmentname(udept);
                String usubcom = ""+Util.getIntValue(DepartmentComInfo.getSubcompanyid1(udept));
                weaver.hrm.company.SubCompanyComInfo scci = new weaver.hrm.company.SubCompanyComInfo();
                String usubcomname = scci.getSubCompanyname(usubcom);
				
	
            int colcount = 0;
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
                String theisedit = Util.null2String(RecordSet.getString("isedit")) ;
                String theismandatory = Util.null2String(RecordSet.getString("ismandatory")) ;
                String thefieldname=(String)fieldnames.get(thefieldidindex);

                if( theisview.equals("1") ) colcount ++ ;
                isfieldids.add(thefieldid);
                isviews.add(theisview);
                isedits.add(theisedit);
                ismands.add(theismandatory);
            }

            if( colcount != 0 ) colwidth = 95/colcount ;

            ArrayList viewfieldnames = new ArrayList() ;

            // 得到每个字段的信息并在页面显示

            int detailfieldcount = -1 ;
            //modify by xhheng @20050323 for TD 1703，组装明细部check串
            String needcheckdtl="";
            int languageid = 7;

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

                fieldname=(String)fieldnames.get(i);
                languageid = user.getLanguage() ;
                fieldlable = SystemEnv.getHtmlLabelName( Util.getIntValue((String)fieldlabels.get(i),0),languageid );

                viewfieldnames.add(fieldname) ;
%>
                <td width="<%=colwidth%>%" <%if (fieldname.equals("loanbalance")) {%> class=balancehide<%}%>><%=fieldlable%></td>
                <script language=javascript>
                    <% if (fieldname.equals("organizationid")) {
                      detailfieldcount++ ;
                      if(ismand.equals("1")) needcheckdtl += ",organizationid_\"+insertindex+\"";%>
                      fieldorders[<%=detailfieldcount%>] = 1 ;
                      organizationidismand=<%=ismand%>;
                      organizationidisedit=<%=isedit%>;
                    <% } else if (fieldname.equals("subject")) {
                      detailfieldcount++ ;
                      if(ismand.equals("1")) needcheckdtl += ",subject_\"+insertindex+\"";%>
                      fieldorders[<%=detailfieldcount%>] = 2 ;
                    <% } else if (fieldname.equals("budgetperiod")) {
                      detailfieldcount++ ;
                      if(ismand.equals("1")) needcheckdtl += ",budgetperiod_\"+insertindex+\"";%>
                      fieldorders[<%=detailfieldcount%>] = 3 ;
                    <% } else if (fieldname.equals("attachcount")) {
                      detailfieldcount++ ;
                      if(ismand.equals("1")) needcheckdtl += ",attachcount_\"+insertindex+\"";%>
                      fieldorders[<%=detailfieldcount%>] = 4 ;
                    <% } else if (fieldname.equals("hrmremain")) {
                      detailfieldcount++ ;
                      if(ismand.equals("1")) needcheckdtl += ",hrmremain_\"+insertindex+\"";%>
                      fieldorders[<%=detailfieldcount%>] = 5 ;
                    <% } else if (fieldname.equals("deptremain")) {
                      detailfieldcount++ ;
                      if(ismand.equals("1")) needcheckdtl += ",deptremain_\"+insertindex+\"";%>
                      fieldorders[<%=detailfieldcount%>] = 6 ;
                    <% } else if (fieldname.equals("subcomremain")) {
                      detailfieldcount++ ;
                      if(ismand.equals("1")) needcheckdtl += ",subcomremain_\"+insertindex+\"";%>
                      fieldorders[<%=detailfieldcount%>] = 7 ;
                    <% } else if (fieldname.equals("loanbalance")) {
                      detailfieldcount++ ;
                      if(ismand.equals("1")) needcheckdtl += ",loanbalance_\"+insertindex+\"";%>
                      fieldorders[<%=detailfieldcount%>] = 8 ;
                    <% } else if (fieldname.equals("relatedprj")) {
                      detailfieldcount++ ;
                      if(ismand.equals("1")) needcheckdtl += ",relatedprj_\"+insertindex+\"";%>
                      fieldorders[<%=detailfieldcount%>] = 9 ;
                    <% } else if (fieldname.equals("relatedcrm")) {
                      detailfieldcount++ ;
                      if(ismand.equals("1")) needcheckdtl += ",relatedcrm_\"+insertindex+\"";%>
                      fieldorders[<%=detailfieldcount%>] = 10 ;
                    <% } else if (fieldname.equals("description")) {
                      detailfieldcount++ ;
                      if(ismand.equals("1")) needcheckdtl += ",description_\"+insertindex+\"";%>
                      fieldorders[<%=detailfieldcount%>] = 11 ;
                    <% } else if (fieldname.equals("applyamount")) {
                      detailfieldcount++ ;
                      if(ismand.equals("1")) needcheckdtl += ",applyamount_\"+insertindex+\"";%>
                      fieldorders[<%=detailfieldcount%>] = 12 ;
                    <% } else if (fieldname.equals("amount")) {
                      detailfieldcount++ ;
                      if(ismand.equals("1")) needcheckdtl += ",amount_\"+insertindex+\"";%>
                      fieldorders[<%=detailfieldcount%>] = 13 ;
                    <% } else if (fieldname.equals("organizationtype")) {
                      detailfieldcount++ ;
                      if(ismand.equals("1")) needcheckdtl += ",organizationtype_\"+insertindex+\"";%>
                      fieldorders[<%=detailfieldcount%>] = 14 ;
                    <% } else if (fieldname.equals("fccremain")) {
                        detailfieldcount++ ;
                        if(ismand.equals("1")) needcheckdtl += ",fccremain_\"+insertindex+\"";%>
                        fieldorders[<%=detailfieldcount%>] = 999 ;
                    <% }%>
                    isedits[<%=detailfieldcount%>] = <%=isedit%> ;
                    ismands[<%=detailfieldcount%>] = <%=ismand%> ;
                </script>
<%          }
%>
              </tr>


              <tr class="header" style="FONT-WEIGHT: bold; COLOR: red">
                <td><%=SystemEnv.getHtmlLabelName(358,user.getLanguage())%></td>
<%          for(int i=0;i<viewfieldnames.size();i++){
                String thefieldname = (String)viewfieldnames.get(i) ;
%>
                <td <% if(thefieldname.equals("applyamount")) {%> id=applyamountsum
                    <%}%>
                    <% if(thefieldname.equals("amount")) {%> id=amountsum
                    <%}%>
                    <% if(thefieldname.equals("attachcount")) {%> id=attachcountsum
                    <%}%>
                    <% if(thefieldname.equals("loanbalance")) {%> class=balancehide
                    <%}%>>
                    &nbsp;
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
		RecordSet_nf1.executeSql("select isFormSignature,formSignatureWidth,formSignatureHeight,issignmustinput from workflow_flownode where workflowId="+workflowid+" and nodeId="+nodeid);
		if(RecordSet_nf1.next()){
		isFormSignature = Util.null2String(RecordSet_nf1.getString("isFormSignature"));
		formSignatureWidth= Util.getIntValue(RecordSet_nf1.getString("formSignatureWidth"),RevisionConstants.Form_Signature_Width_Default);
		formSignatureHeight= Util.getIntValue(RecordSet_nf1.getString("formSignatureHeight"),RevisionConstants.Form_Signature_Height_Default);
		isSignMustInput = ""+Util.getIntValue(RecordSet_nf1.getString("issignmustinput"), 0);
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
<script language="JavaScript" src="/js/addRowBg_wev8.js" ></script>

<%
   String totallabel="";
   String wipetypelabel="";
   RecordSet.executeProc("workflow_billfield_Select",formid+"");
    while(RecordSet.next()){
        if(Util.null2String(RecordSet.getString("fieldname")).equals("total"))
          totallabel=Util.null2String(RecordSet.getString("id"));
        if(Util.null2String(RecordSet.getString("fieldname")).equals("wipetype"))
        wipetypelabel=Util.null2String(RecordSet.getString("id"));
    }
 %>
<script language=javascript>
$GetEle("needcheck").value+=",<%=needcheck%>";
var rowColor="" ;
rowindex = 0 ;
insertindex=0;
deleteindex=0;
deletearray = new Array() ;
thedeletelength=0;

function addRow()
{rowColor = getRowClassName();//getRowBg();
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

                switch (dsporder) {
                    case 1 :
                         var oDiv = document.createElement("div");
                         <%if(fnaBudgetOAOrg){ %>
                        var sHtml = "<span id='organizationid_"+insertindex+"span'>" ;
                        sHtml += "<a href='/hrm/company/HrmDepartmentDsp.jsp?id=<%=udept%>'><%=udeptname%></a>"; sHtml += "</span><input type=hidden id='organizationid_"+insertindex+"' name='organizationid_"+insertindex+"' value='<%=udept%>'>" ;
                        <%}else{ %>
                        var sHtml = "";
                        <%} %>
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                    case 5 :
                        var oDiv = document.createElement("div");
                        sHtml = "<span id='hrmremainspan_" + insertindex + "'></span>";
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break;
                    case 6 :
                        var oDiv = document.createElement("div");
                        sHtml = "<span id='deptremainspan_" + insertindex + "'></span>";
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break;
                    case 7 :
                        var oDiv = document.createElement("div");
                        sHtml = "<span id='subcomremainspan_" + insertindex + "'></span>";
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break;
                    case 8 :
                        var oDiv = document.createElement("div");
                        sHtml = "<span id='loanbalancespan_"+insertindex+"'><%=loanamount%></span>";
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        if( $GetEle("balancestyle").disabled){
                                 $GetEle("balancestyle").disabled=false;
                                oCell.className = "balancehide";
                                 $GetEle("balancestyle").disabled=true;
                            } else
                                oCell.className = "balancehide";
                        break ;
                    case 14 :
                        var oDiv = document.createElement("div");
                         <%if(fnaBudgetOAOrg){ %>
                        var sHtml = "<input type=hidden id='organizationtype_"+insertindex+"' name='organizationtype_"+insertindex+"' value=2><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>" ;
                        <%}else{ %>
                        var sHtml = "";
                        <%} %>
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                    case 999 :
                        var oDiv = document.createElement("div");
                        sHtml = "<span id='fccremainspan_"+insertindex+"'></span>";
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                    default:
                        var oDiv = document.createElement("div");
                        var sHtml = "&nbsp;";
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                }
            } else {
                switch (dsporder)  {
                    case 1 :
                        var oDiv = document.createElement("div");
					    oDiv.innerHTML = "<span id='organizationid_"+insertindex+"wrapspan'></span>"+
					    	//"<input type=\"hidden\" viewtype=\""+ismand+"\" temptitle=\"\" name=\"organizationid_"+insertindex+"\" id=\"organizationid_"+insertindex+"\" value=\"\">"+
					    	"";
					    oCell.appendChild(oDiv);


                        <%if(fnaBudgetOAOrg){ %>
                        onShowOrganizationBtn(ismand, insertindex, "<%=udept %>", "<%=udeptname %>");
                        <%}else if(fnaBudgetCostCenter){ %>
                        onShowOrganizationBtn(ismand, insertindex, "", "");
                        <%} %>
                        
                        break ;
                    case 2 :
                        var oDiv = document.createElement("div");
                        var detailbrowclick = "onShowBrowser2_fna('subject_"+insertindex+"','"+browserUtl_subject+"','','22','"+ismand+"')";
                        oDiv.innerHTML = "<span id='subject_"+insertindex+"wrapspan'></span>"+
                        	//"<input type=\"hidden\" viewtype=\""+ismand+"\" temptitle=\"\" name=\"subject_"+insertindex+"\" id=\"subject_"+insertindex+"\" value=\"\">"+
                        	"";
                        oCell.appendChild(oDiv);
                        
                        onShowSubjectBtn("subject_"+insertindex, insertindex, ismand, "", "", detailbrowclick, "/data.jsp?type=22" );
						//initE8Browser("subject_"+insertindex, insertindex, ismand, "", "", detailbrowclick, "/data.jsp?type=22");
                        
                        break ;
                    case 3 :
                        var oDiv = document.createElement("div");
                        var detailbrowclick = "onShowBrowser2_fna('budgetperiod_"+insertindex+"','','','2','"+ismand+"')";
                        oDiv.innerHTML = "<span id='budgetperiod_"+insertindex+"wrapspan'></span>"+
                        	//"<input type=\"hidden\" viewtype=\""+ismand+"\" temptitle=\"\" name=\"budgetperiod_"+insertindex+"\" id=\"budgetperiod_"+insertindex+"\" value=\"\">"+
                        	"";
                        oCell.appendChild(oDiv);

                        initE8Browser("budgetperiod_"+insertindex, insertindex, ismand, "", "", detailbrowclick, "");
                        
                        break ;
                    case 4 :
                        var oDiv = document.createElement("div");
                        var sHtml = "<nobr><input type='text' class=inputstyle style=width:85% maxlength=10 id='attachcount_"+insertindex+"' name='attachcount_"+insertindex+"' maxlength='10' onKeyPress='ItemCount_KeyPress()' onBlur='checkcount1(this);" ;
                        if(ismand == 1)
                            sHtml += "checkinput1(attachcount_"+ insertindex+",attachcountspan_"+insertindex+");" ;
                        sHtml += "changecount();'>" ;
                        if(ismand == 1)
                            sHtml += "<span id='attachcountspan_"+insertindex+"'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>";
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                    case 5 :
                        var oDiv = document.createElement("div");
                        sHtml = "<span id='hrmremainspan_"+insertindex+"'></span>";
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                    case 6 :
                        var oDiv = document.createElement("div");
                        sHtml = "<span id='deptremainspan_"+insertindex+"'></span>";
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                    case 7 :
                        var oDiv = document.createElement("div");
                        sHtml = "<span id='subcomremainspan_"+insertindex+"'></span>";
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                    case 8 :
                        var oDiv = document.createElement("div");
                        sHtml = "<span id='loanbalancespan_"+insertindex+"'><%=loanamount%></span>";
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        if( $GetEle("balancestyle").disabled){
                                 $GetEle("balancestyle").disabled=false;
                                oCell.className = "balancehide";
                                 $GetEle("balancestyle").disabled=true;
                            } else
                                oCell.className = "balancehide";
                        break ;
                    case 9 :
                        var oDiv = document.createElement("div");
                        var detailbrowclick = "onShowBrowser2_fna('relatedprj_"+insertindex+"','"+browserUtl_prj+"','','8','"+ismand+"')";
                        oDiv.innerHTML = "<span id='relatedprj_"+insertindex+"wrapspan'></span>"+
                        	//"<input type=\"hidden\" viewtype=\""+ismand+"\" temptitle=\"\" name=\"relatedprj_"+insertindex+"\" id=\"relatedprj_"+insertindex+"\" value=\"\">"+
                        	"";
                        oCell.appendChild(oDiv);
                        
						initE8Browser("relatedprj_"+insertindex, insertindex, ismand, "", "", detailbrowclick, "/data.jsp?type=8");
                        
                        break ;
                    case 10 :
                        var oDiv = document.createElement("div");
                        var detailbrowclick = "onShowBrowser2_fna('relatedcrm_"+insertindex+"','"+browserUtl_crm+"','','7','"+ismand+"')";
                        oDiv.innerHTML = "<span id='relatedcrm_"+insertindex+"wrapspan'></span>"+
                        	//"<input type=\"hidden\" viewtype=\""+ismand+"\" temptitle=\"\" name=\"relatedcrm_"+insertindex+"\" id=\"relatedcrm_"+insertindex+"\" value=\"\">"+
                        	"";
                        oCell.appendChild(oDiv);

						initE8Browser("relatedcrm_"+insertindex, insertindex, ismand, "", "", detailbrowclick, "/data.jsp?type=7");
                        
                        break ;
                    case 11 :
                        var oDiv = document.createElement("div");
					    var sfield="<%=user.getLanguage()%>";
                        var sHtml = "<nobr><input type='text' class=inputstyle style=width:85%  title='<%=SystemEnv.getHtmlLabelName(85, user.getLanguage())%>' id='description_"+insertindex+"' name='description_"+insertindex+"'  onBlur='" ;
						    sHtml+="checkLength1(description_"+insertindex+",500,this.title,"+sfield+");";
                        if(ismand == 1)
                            sHtml += "checkinput1(description_"+ insertindex+",descriptionspan_"+insertindex+");" ;
                        sHtml += "'>" ;
                        if(ismand == 1)
                            sHtml += "<span id='descriptionspan_"+insertindex+"'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>";
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                    case 12 :
                        var oDiv = document.createElement("div");
                        var sHtml = "<nobr><input type='text' class=inputstyle style=width:85%  id='applyamount_"+insertindex+"' name='applyamount_"+insertindex+"' onKeyPress='ItemDecimal_KeyPress(this.name,15,3)' onBlur='checknumber1(this);" ;
                        if(ismand == 1)
                            sHtml += "checkinput1(applyamount_"+ insertindex+",applyamountspan_"+insertindex+");" ;
                        sHtml += "changeapplynumber();'>" ;
                        if(ismand == 1)
                            sHtml += "<span id='applyamountspan_"+insertindex+"'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>";
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                    case 13 :
                        var oDiv = document.createElement("div");
                        var sHtml = "<nobr><input type='text' class=inputstyle style=width:85%  id='amount_"+insertindex+"' name='amount_"+insertindex+"' onKeyPress='ItemDecimal_KeyPress(this.name,15,3)' onBlur='checknumber1(this);" ;
                        if(ismand == 1)
                            sHtml += "checkinput1(amount_"+ insertindex+",amountspan_"+insertindex+");" ;
                        sHtml += "changenumber();'>" ;
                        if(ismand == 1)
                            sHtml += "<span id='amountspan_"+insertindex+"'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>";
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                    case 14 :
                        var oDiv = document.createElement("div");
                        var sHtml = "<select id='organizationtype_"+insertindex+"' name='organizationtype_"+insertindex+"' onchange='clearSpan("+insertindex+")'>"+
                        <%if(fnaBudgetOAOrg){ %>
                        	"<option value=2 default><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>"+
                        	"<option value=1><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>"+
                        	"<option value=3><%=SystemEnv.getHtmlLabelName(6087,user.getLanguage())%></option>"+
                        <%} %>
                        <%if(fnaBudgetCostCenter){ %>
                        	"<option value='<%=FnaCostCenter.ORGANIZATION_TYPE+"" %>'><%=SystemEnv.getHtmlLabelName(515,user.getLanguage())%></option>"+
                        <%} %>
                        	"</select>" ;
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                    case 999 :
                        var oDiv = document.createElement("div");
                        sHtml = "<span id='fccremainspan_"+insertindex+"'></span>";
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
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

function changecount() {
    count = 0 ;
    try{
    for(j=0;j<insertindex;j++) {
        hasdelete = false ;
        for(k=0;k<deletearray.length;k++){
            if(j==deletearray[k])
            hasdelete=true;
        }
        if(hasdelete) continue ;
        count += eval(toInt($GetEle("attachcount_"+j).value,0)) ;
    }
    attachcountsum.innerHTML = count ;
    }catch(e){}
}
function changenumber(){

    count = 0 ;
    try{
    for(j=0;j<insertindex;j++) {
        hasdelete = false ;
        for(k=0;k<deletearray.length;k++){
            if(j==deletearray[k])
            hasdelete=true;
        }
        if(hasdelete) continue ;
        count+= eval(toFloat($GetEle("amount_"+j).value,0)) ;
    }
    var hasedit=false;
    amountsum.innerHTML = count.toFixed(3);
    if($GetEle("field<%=totallabel%>")!=null){
        $GetEle("field<%=totallabel%>").value =  count.toFixed(3);
        if($GetEle("field<%=totallabel%>").type!="hidden") hasedit=true;
    }
    if(!hasedit&&$GetEle("field<%=totallabel%>span")!=null)
    $GetEle("field<%=totallabel%>span").innerHTML =  count.toFixed(3);
    }catch(e){}
}

function changeapplynumber(){

    count = 0 ;
    try{
    for(j=0;j<insertindex;j++) {
        hasdelete = false ;
        for(k=0;k<deletearray.length;k++){
            if(j==deletearray[k])
            hasdelete=true;
        }
        if(hasdelete) continue ;
        count+= eval(toFloat($GetEle("applyamount_"+j).value,0)) ;
    }
    var hasedit=false;
    applyamountsum.innerHTML = count.toFixed(3);
    if($GetEle("field<%=totallabel%>")!=null){
        $GetEle("field<%=totallabel%>").value =  count.toFixed(3);
        if($GetEle("field<%=totallabel%>").type!="hidden") hasedit=true;
    }
    if(!hasedit&&$GetEle("field<%=totallabel%>span")!=null)
    $GetEle("field<%=totallabel%>span").innerHTML =  count.toFixed(3);
    }catch(e){}
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
            changeapplynumber() ;
            changenumber() ;
            changecount() ;
            $GetEle("nodesnum").value = rowindex ;
        }
    }else{
        alert('<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>');
		return;
    }
}

function clearBtnById(index){
<%if(subjectFilter){ %>
	var _objIdWrapspan = jQuery("#subject_"+index+"wrapspan");
	if(_objIdWrapspan.length==1){
		var _objId = jQuery("#subject_"+index);
		var _objSpan = jQuery("#subject_"+index+"span");
		_objId.val("");
		_objSpan.html("");
	}else{
		jQuery("#subject_"+index+"span").html("");
	}
<%} %>
}

function wfbrowvaluechange(obj, fieldid, index) {
	//alert("obj="+obj+";fieldid="+fieldid+";index="+index);
	if("organizationid_"+index==fieldid){
		clearBtnById(index);
	}
	
	var organizationtypeval = jQuery("#organizationtype_" + index).val();
	var organizationidval = jQuery("#organizationid_" + index).val();
	var subjid = jQuery("#subject_" + index).val();

	getBudgetKpi(index, organizationtypeval, organizationidval, subjid);
	getLoan(index, organizationtypeval, organizationidval);
}

function clearSpan(index) {
	if(jQuery("#organizationid_"+index+"span").length>0&&organizationidisedit==1){
		if(organizationidismand==1){
			jQuery("#organizationid_"+index+"span").html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
		}else{
			jQuery("#organizationid_"+index+"span").html("");
		}
		jQuery("#organizationid_"+index+"span")[0].parentElement.parentElement.style.background=jQuery("#organizationtype_"+index)[0].parentElement.parentElement.style.background;
		if (jQuery("#organizationid_" + index).length>0){
			jQuery("#organizationid_"+index).val("");
		}
		if (jQuery("#hrmremainspan_" + index).length>0) {
			jQuery("#hrmremainspan_" + index).html("");
		}
		if (jQuery("#deptremainspan_" + index).length>0) {
			jQuery("#deptremainspan_" + index).html("");
		}
		if (jQuery("#subcomremainspan_" + index).length>0) {
			jQuery("#subcomremainspan_" + index).html("");
		}
		if (jQuery("#fccremainspan_" + index).length>0) {
			jQuery("#fccremainspan_" + index).html("");
		}
	}

	clearBtnById(index);
	onShowOrganizationBtn(organizationidismand, index, "", "");
    
}
function onShowOrganizationBtn(organizationidismand, insertindex, _browserId, _browserName) {
	jQuery("#organizationid_"+insertindex).val("");
    jQuery("#organizationid_"+insertindex+"wrapspan").html("");
    
	var orgType = jQuery("#organizationtype_"+insertindex).val();
	
	var btnType = "4";//部门
	var browserUtl = browserUtl_dep;
    if (orgType == "3"){//个人
    	btnType = "1";
    	browserUtl = browserUtl_hrm;
    }else if (orgType == "2"){//部门
    	btnType = "4";
    	browserUtl = browserUtl_dep;
    }else if (orgType == "1"){//分部
    	btnType = "164";
    	browserUtl = browserUtl_sub;
    }else if (orgType == "<%=FnaCostCenter.ORGANIZATION_TYPE+"" %>"){//成本中心
    	btnType = "251";
    	browserUtl = browserUtl_fcc;
    }

    var detailbrowclick = "onShowBrowser2_fna('organizationid_"+insertindex+"','"+browserUtl+"','','"+btnType+"','"+organizationidismand+"')";
    initE8Browser("organizationid_"+insertindex, insertindex, organizationidismand, _browserId, _browserName, detailbrowclick, "/data.jsp?show_virtual_org=-1&type="+btnType+"&bdf_wfid=<%=workflowid%>&bdf_fieldid=<%=organizationidFieldId%>");
}

function onShowSubjectBtn(fieldId, insertindex, ismand, fieldvalue, showname, detailbrowclick, url){
	initE8Browser(fieldId, insertindex, ismand, fieldvalue, showname, detailbrowclick, "javascript:getSubjectId_completeUrl('"+fieldId+"','"+insertindex+"')");
}

function getSubjectId_completeUrl(fieldId, insertindex){
	var __orgType = jQuery("#organizationtype_"+insertindex).val();
	var __orgId = jQuery("#organizationid_"+insertindex).val();
	return "/data.jsp?type=22&orgType="+__orgType+"&orgId="+__orgId+"&fromFnaRequest=1&bdf_wfid=<%=workflowid%>&bdf_fieldid=<%=subjectFieldId%>";
}

function callback(o, index) {
	if(o==null||o==""){
		jQuery("#hrmremainspan_" + index).html("");
		jQuery("#deptremainspan_" + index).html("");
		jQuery("#subcomremainspan_" + index).html("");
	}else{
	    val = o.split("|");
	    if (jQuery("#hrmremainspan_" + index).length>0) {
	        if (val[0] != "") {
	            v = val[0].split(",");
	            jQuery("#hrmremainspan_" + index).html("<span ><span style='white-space :nowrap'><%=SystemEnv.getHtmlLabelName(18768,user.getLanguage())%>:" + v[0] + "</span><br><span style='white-space :nowrap;color:red' ><%=SystemEnv.getHtmlLabelName(18503,user.getLanguage())%>:" + v[1] + "</span><br><span style='white-space :nowrap;color:green' ><%=SystemEnv.getHtmlLabelName(18769,user.getLanguage())%>:" + v[2] + "</span></span>");
	        }
	    }
	    if (jQuery("#deptremainspan_" + index).length>0) {
	        if (val[1] != "") {
	            v = val[1].split(",");
	            jQuery("#deptremainspan_" + index).html("<span ><span style='white-space :nowrap'><%=SystemEnv.getHtmlLabelName(18768,user.getLanguage())%>:" + v[0] + "</span><br><span style='white-space :nowrap;color:red' ><%=SystemEnv.getHtmlLabelName(18503,user.getLanguage())%>:" + v[1] + "</span><br><span style='white-space :nowrap;color:green' ><%=SystemEnv.getHtmlLabelName(18769,user.getLanguage())%>:" + v[2] + "</span></span>");
	        }
	    }
	    if (jQuery("#subcomremainspan_" + index).length>0) {
	        if (val[2] != "") {
	            v = val[2].split(",");
	            jQuery("#subcomremainspan_" + index).html("<span ><span style='white-space :nowrap'><%=SystemEnv.getHtmlLabelName(18768,user.getLanguage())%>:" + v[0] + "</span><br><span style='white-space :nowrap;color:red' ><%=SystemEnv.getHtmlLabelName(18503,user.getLanguage())%>:" + v[1] + "</span><br><span style='white-space :nowrap;color:green' ><%=SystemEnv.getHtmlLabelName(18769,user.getLanguage())%>:" + v[2] + "</span></span>");
	        }
	    }
	    if (jQuery("#fccremainspan_" + index).length>0) {
	        if (val[3] != "") {
	            v = val[3].split(",");
	            jQuery("#fccremainspan_" + index).html("<span ><span style='white-space :nowrap'><%=SystemEnv.getHtmlLabelName(18768,user.getLanguage())%>:" + v[0] + "</span><br><span style='white-space :nowrap;color:red' ><%=SystemEnv.getHtmlLabelName(18503,user.getLanguage())%>:" + v[1] + "</span><br><span style='white-space :nowrap;color:green' ><%=SystemEnv.getHtmlLabelName(18769,user.getLanguage())%>:" + v[2] + "</span></span>");
	        }
	    }
	}
}
function getBudgetKpi(index, organizationtype, organizationid, subjid) {
	var budgetperiod = jQuery("#budgetperiod_"+index).val();
	if(subjid!=""&&organizationtype!=""&&organizationid!=""&&budgetperiod!=""){
		var _data = "budgetfeetype="+subjid+"&orgtype="+organizationtype+"&orgid="+organizationid+"&applydate="+budgetperiod;
		jQuery.ajax({
			url : "/workflow/request/BudgetHandlerGetBudgetKPI.jsp",
			type : "post",
			processData : false,
			data : _data,
			dataType : "html",
			success: function do4Success(msg){
				callback(msg, index);
			}
		});	
	}else{
		callback("", index);
	}
}

function callback1(o, index) {
    jQuery("#loanbalancespan_"+index).html(o);
}
function getLoan(index, organizationtype, organizationid) {
	if(organizationtype!=""&&organizationid!=""){
		var _data = "orgtype="+organizationtype+"&orgid="+organizationid;
		jQuery.ajax({
			url : "/workflow/request/BudgetHandlerLoanAmount.jsp",
			type : "post",
			processData : false,
			data : _data,
			dataType : "html",
			success: function do4Success(msg){
				callback1(msg, index);
			}
		});	
	}else{
		callback1("", index);
	}
}

function balancestyleShow(){
    if(jQuery("#field<%=wipetypelabel%>").length>0 && jQuery("#balancestyle").length>0){
        if (jQuery("#field<%=wipetypelabel%>").val() == "4") {
        	jQuery("#balancestyle")[0].disabled=true;
        }else{
        	jQuery("#balancestyle")[0].disabled=false;
        }
    }
}

function checknumber1(objectname)
{
	valuechar = objectname.value.split("") ;
	isnumber = false ;
	for(i=0 ; i<valuechar.length ; i++) { charnumber = parseInt(valuechar[i]) ; if( isNaN(charnumber)&& valuechar[i]!=".") isnumber = true ;}
	if(isnumber) objectname.value = "" ;
}
function checkcount1(objectname)
{
	valuechar = objectname.value.split("") ;
	isnumber = false ;
	for(i=0 ; i<valuechar.length ; i++) { charnumber = parseInt(valuechar[i]) ; if( isNaN(charnumber)) isnumber = true ;}
	if(isnumber) objectname.value = "" ;
}
</script>
