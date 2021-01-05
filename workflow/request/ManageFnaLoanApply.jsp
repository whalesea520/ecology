<%@page import="weaver.workflow.field.BrowserComInfo"%>
<%@ page import="java.math.*" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
 <%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
 <%@ taglib uri="/browserTag" prefix="brow"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/workflow/request/WorkflowManageRequestTitle.jsp" %>
<jsp:useBean id="WFNodeDtlFieldManager" class="weaver.workflow.workflow.WFNodeDtlFieldManager" scope="page" />
<form name="frmmain" method="post" action="FnaLoanApplyOperation.jsp" enctype="multipart/form-data">
<input type="hidden" name="needwfback" id="needwfback" value="1" />
<input type="hidden" name="lastOperator"  id="lastOperator" value="<%=lastOperator%>"/>
<input type="hidden" name="lastOperateDate"  id="lastOperateDate" value="<%=lastOperateDate%>"/>
<input type="hidden" name="lastOperateTime"  id="lastOperateTime" value="<%=lastOperateTime%>"/>

<jsp:include page="WorkflowManageRequestBodyAction.jsp" flush="true">

	<jsp:param name="userid" value="<%=userid%>" />
    <jsp:param name="languageid" value="<%=user.getLanguage()%>" />
    <jsp:param name="fromFlowDoc" value="<%=fromFlowDoc%>" />
    <jsp:param name="requestid" value="<%=requestid%>" />
    <jsp:param name="requestlevel" value="<%=requestlevel%>" />

    <jsp:param name="creater" value="<%=creater%>" />
    <jsp:param name="creatertype" value="<%=creatertype%>" />
    <jsp:param name="deleted" value="<%=deleted%>" />
    <jsp:param name="billid" value="<%=billid%>" />
	<jsp:param name="isbill" value="<%=isbill%>" />
    <jsp:param name="workflowid" value="<%=workflowid%>" />
    <jsp:param name="workflowtype" value="<%=workflowtype%>" />
    <jsp:param name="formid" value="<%=formid%>" />
    <jsp:param name="nodeid" value="<%=nodeid%>" />
    <jsp:param name="nodetype" value="<%=nodetype%>" />
    <jsp:param name="isreopen" value="<%=isreopen%>" />
    <jsp:param name="isreject" value="<%=isreject%>" />
    <jsp:param name="isremark" value="<%=isremark%>" />
	<jsp:param name="currentdate" value="<%=currentdate%>" />
	<jsp:param name="currenttime" value="<%=currenttime%>" />
    <jsp:param name="needcheck" value="<%=needcheck%>" />
	<jsp:param name="topage" value="<%=topage%>" />
	<jsp:param name="newenddate" value="<%=newenddate%>" />
	<jsp:param name="newfromdate" value="<%=newfromdate%>" />
	<jsp:param name="docfileid" value="<%=docfileid%>" />
	<jsp:param name="newdocid" value="<%=newdocid%>" />
</jsp:include>


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
    %>
    <script language=javascript>
        fieldorders = new Array() ;
        isedits = new Array() ;
        ismands = new Array() ;
        var organizationidismand=0;
        var organizationidisedit=0;
    </script>
	<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
	<script language="JavaScript" src="/js/addRowBg_wev8.js" ></script>
<script type="text/javascript">
var browserUtl_subject = "<%=new BrowserComInfo().getBrowserurl("22") %>";
var browserUtl_hrm = "<%=new BrowserComInfo().getBrowserurl("1") %>%3Fshow_virtual_org=-1";
var browserUtl_dep = "<%=new BrowserComInfo().getBrowserurl("4") %>%3Fshow_virtual_org=-1";
var browserUtl_sub = "<%=new BrowserComInfo().getBrowserurl("164") %>%3Fshow_virtual_org=-1";
var browserUtl_prj = "<%=new BrowserComInfo().getBrowserurl("8") %>";
var browserUtl_crm = "<%=new BrowserComInfo().getBrowserurl("7") %>";
</script>
            <%
            sql="select applicant from Bill_FnaLoanApply where id="+billid;
             RecordSet.executeSql(sql);
             RecordSet.next();
             String uid=RecordSet.getString("applicant");

             String uname=ResourceComInfo.getLastname(uid);
             String udept=ResourceComInfo.getDepartmentID(uid);
             String udeptname= DepartmentComInfo.getDepartmentname(udept);
             String usubcom=DepartmentComInfo.getSubcompanyid1(udept);
             weaver.hrm.company.SubCompanyComInfo scci=new weaver.hrm.company.SubCompanyComInfo();
             String usubcomname=scci.getSubCompanyname(usubcom);

            int colcount = 0 ;
            int colwidth = 0 ;
            //fieldids.clear() ;
            //fieldlabels.clear() ;
            //fieldhtmltypes.clear() ;
            //fieldtypes.clear() ;
            //fieldnames.clear() ;
            //fieldviewtypes.clear() ;
			ArrayList fieldids=new ArrayList();
			ArrayList fieldlabels=new ArrayList();
			ArrayList fieldhtmltypes=new ArrayList();
			ArrayList fieldtypes=new ArrayList();
			ArrayList fieldnames=new ArrayList();
			ArrayList fieldviewtypes=new ArrayList();


                String temporganizationidisview="0";
                String temporganizationidisedit="0";
                String temporganizationidismandatory="0";
                String temprogtypeisview="0";

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
            //isfieldids.clear() ;              //字段队列
            //isviews.clear() ;              //字段是否显示队列
            //isedits.clear() ;              //字段是否可以编辑队列
            //ismands.clear() ;              //字段是否必须输入队列
			ArrayList isfieldids=new ArrayList();
			ArrayList isviews=new ArrayList();
			ArrayList isedits=new ArrayList();
			ArrayList ismands=new ArrayList();


            RecordSet.executeProc("workflow_FieldForm_Select",nodeid+"");
            while(RecordSet.next()){
                String thefieldid = Util.null2String(RecordSet.getString("fieldid")) ;
                int thefieldidindex = fieldids.indexOf( thefieldid ) ;
                if( thefieldidindex == -1 ) continue ;
                String theisview = Util.null2String(RecordSet.getString("isview")) ;
                String theisedit = Util.null2String(RecordSet.getString("isedit"));
                 String theismandatory = Util.null2String(RecordSet.getString("ismandatory"));
                 String thefieldname=(String)fieldnames.get(thefieldidindex);
//                 if(nodetype.equals("0")){
//                     if(thefieldname.equals("organizationtype")||thefieldname.equals("organizationid")){
//                        theisview="1";
//                        theisedit="1";
//                        theismandatory="1";
//                    }
//                 }
                 if(thefieldname.equals("organizationid")){
                     temporganizationidisview=theisview;
                     temporganizationidisedit=theisedit;
                     temporganizationidismandatory=theismandatory;
                 }
                 if(thefieldname.equals("organizationtype")) temprogtypeisview=theisview;
                if( theisview.equals("1") ) colcount ++ ;
                isfieldids.add(thefieldid);
                isviews.add(theisview);
                isedits.add(theisedit);
                ismands.add(theismandatory);
            }
            if(temporganizationidisview.equals("1")&&temprogtypeisview.equals("0")) colcount++;
            if( colcount != 0 ) colwidth = 95/colcount ;

            // 得到每个字段的信息并在页面显示
            int detailfieldcount = -1 ;
            String needcheckdtl="";

            ArrayList viewfieldnames = new ArrayList() ;

            BigDecimal amountsum = new BigDecimal("0") ;
            int quantitysum = 0 ;
            boolean isttLight = false;
            int recorderindex = 0 ;
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
            <table class="ListStyle" cellspacing=1   id="oTable">
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
                String fieldname = "" ;                         //字段数据库表中的字段名
                String fieldlable = "" ;                        //字段显示名
                int languageid = 0 ;

                fieldname=(String)fieldnames.get(i);
                if(! isview.equals("1") &&fieldname.equals("organizationtype")){
                    isview=temporganizationidisview;
                    isedit=temporganizationidisedit;
                    ismand=temporganizationidismandatory;
                 }
                if( ! isview.equals("1") ) continue ;           //不显示即进行下一步循环


                languageid = user.getLanguage() ;
                fieldlable = SystemEnv.getHtmlLabelName( Util.getIntValue((String)fieldlabels.get(i),0),languageid );

                viewfieldnames.add(fieldname) ;
%>
                <td width="<%=colwidth%>%"><%=fieldlable%></td>
                <script language=javascript>
                    <% if (fieldname.equals("organizationid")) { detailfieldcount++ ;
                       if(ismand.equals("1")) needcheckdtl += ",organizationid_\"+insertindex+\"";
                    %>
                    fieldorders[<%=detailfieldcount%>] = 1 ;
                    organizationidismand=<%=ismand%>;
                    organizationidisedit=<%=isedit%>;
                    <% }  else if (fieldname.equals("relatedprj")) { detailfieldcount++ ;
                          if(ismand.equals("1")) needcheckdtl += ",relatedprj_\"+insertindex+\"";
                    %>
                    fieldorders[<%=detailfieldcount%>] = 2 ;
                    <% } else if (fieldname.equals("relatedcrm")) { detailfieldcount++ ;
                          if(ismand.equals("1")) needcheckdtl += ",relatedcrm_\"+insertindex+\"";
                    %>
                    fieldorders[<%=detailfieldcount%>] = 3 ;
                    <% } else if (fieldname.equals("description")) { detailfieldcount++ ;
                          if(ismand.equals("1")) needcheckdtl += ",description_\"+insertindex+\"";
                    %>
                    fieldorders[<%=detailfieldcount%>] = 4 ;
                    <% } else if (fieldname.equals("amount")) { detailfieldcount++ ;
                          if(ismand.equals("1")) needcheckdtl += ",amount_\"+insertindex+\"";
                    %>
                    fieldorders[<%=detailfieldcount%>] = 5 ;
                    <% } else if (fieldname.equals("organizationtype")) { detailfieldcount++ ;
                          if(ismand.equals("1")) needcheckdtl += ",organizationtype_\"+insertindex+\"";
                    %>
                    fieldorders[<%=detailfieldcount%>] = 6 ;
                    <% } %>
                    isedits[<%=detailfieldcount%>] = <%=isedit%> ;
                    ismands[<%=detailfieldcount%>] = <%=ismand%> ;
                </script>
<%          }
%>
              </tr>
<%
            sql="select *  from Bill_FnaLoanApplyDetail where id="+billid+" order by dsporder";
            RecordSet.executeSql(sql);
            while(RecordSet.next()) {
                isttLight = !isttLight ;
%>
              <TR class='<%=( isttLight ? "datalight" : "datadark" )%>'>
                <td width="5%"><input type='checkbox' name='check_node' value='<%=recorderindex%>' <%if(!dtldelete.equals("1")){%>disabled<%}%>></td>
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
                    if(!"1".equals(dtledit)){
                        isedit="0";
				    }
                    String fieldname = (String)fieldnames.get(i);   //字段数据库表中的字段名
                    String fieldvalue =  Util.null2String(RecordSet.getString(fieldname)) ;
					String fieldlable = SystemEnv.getHtmlLabelName( Util.getIntValue((String)fieldlabels.get(i),0),user.getLanguage());
                    if(! isview.equals("1") &&fieldname.equals("organizationtype")){
                        isview=temporganizationidisview;
                        isedit=temporganizationidisedit;
                        ismand=temporganizationidismandatory;
                     }
                    if( ! isview.equals("1") ) {
%>
                    <input type=hidden name="<%=fieldname%>_<%=recorderindex%>" value="<%=fieldvalue%>">
<%
                    }
                    else {
                        if(ismand.equals("1"))  needcheck+= ","+fieldname+"_"+recorderindex;
                        //如果必须输入,加入必须输入的检查中
%>                  <td>
<%
                        String showname = "" ;
                        if( fieldname.equals("organizationtype"))  {
                             String orgtype= RecordSet.getString("organizationtype");
                             if(orgtype.equals("3")){
                            showname = SystemEnv.getHtmlLabelName(6087,user.getLanguage());
                            }else if(orgtype.equals("2")){
                            showname = SystemEnv.getHtmlLabelName(124,user.getLanguage());
                            }else if(orgtype.equals("1")){
                            showname = SystemEnv.getHtmlLabelName(141,user.getLanguage());
                            }
                             if(isedit.equals("1") && isremark==0 ){
%>
                     <select id="organizationtype_<%=recorderindex%>" name="organizationtype_<%=recorderindex%>" onchange="clearSpan(<%=recorderindex%>)"><option value=3 <%if(orgtype.equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6087,user.getLanguage())%></option><option value=2  <%if(orgtype.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option><option value=1 <%if(orgtype.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option></select>
<%
                             }else{
%>
                     <input type=hidden id="organizationtype_<%=recorderindex%>" name="organizationtype_<%=recorderindex%>"  value="<%=orgtype%>"><%=showname%>
<%}%>
                     <%
                         }else if( fieldname.equals("organizationid"))  {
							showname = "";
                            String orgtype= RecordSet.getString("organizationtype");
                            if(orgtype.equals("3")){
                            	showname = "<A href='/hrm/resource/HrmResource.jsp?id="+fieldvalue+"'>"+Util.toScreen(ResourceComInfo.getLastname(fieldvalue),user.getLanguage()) +"</A>";
                            }else if(orgtype.equals("2")){
                            	showname = "<A href='/hrm/company/HrmDepartmentDsp.jsp?id="+fieldvalue+"'>"+Util.toScreen(DepartmentComInfo.getDepartmentname(fieldvalue),user.getLanguage()) +"</A>";
                            }else if(orgtype.equals("1")){
                            	showname = "<A href='/hrm/company/HrmSubCompanyDsp.jsp?id="+fieldvalue+"'>"+Util.toScreen(SubCompanyComInfo.getSubCompanyname(fieldvalue),user.getLanguage())+"</A>";
                            }
							if( fieldvalue.equals("0") ) {
								fieldvalue = "" ;
							}
							if(isedit.equals("1") && isremark==0){
%>
					<span id='organizationid_<%=recorderindex %>wrapspan'></span>
					<!-- 
					<input type=hidden viewtype="<%=ismand %>" id="organizationid_<%=recorderindex%>" name="organizationid_<%=recorderindex%>" value="<%=fieldvalue%>" />
					 -->
					<script type="text/javascript">
						jQuery(document).ready(function(){
							onShowOrganizationBtn(<%=ismand %>, <%=recorderindex %>, "<%=fieldvalue %>", "<%=showname %>");
						});
					</script>
<%
							}else{
%>
					<input type=hidden viewtype="<%=ismand %>" id="organizationid_<%=recorderindex%>" name="organizationid_<%=recorderindex%>" value="<%=fieldvalue%>" />
					<%=showname %>
<%							
							}
						}
                        else if( fieldname.equals("relatedprj"))  {
							showname = Util.toScreen(ProjectInfoComInfo.getProjectInfoname(fieldvalue),user.getLanguage()) ;
							if( fieldvalue.equals("0") ) fieldvalue = "" ;
							if(isedit.equals("1") && isremark==0 ){
%>
					<span id='relatedprj_<%=recorderindex %>wrapspan'></span>
					<!-- 
					<input type="hidden" viewtype="<%=ismand %>" temptitle="" name="relatedprj_<%=recorderindex%>" id="relatedprj_<%=recorderindex%>" value="<%=fieldvalue%>" />
					 -->
					<script type="text/javascript">
						jQuery(document).ready(function(){
							var detailbrowclick = "onShowBrowser2_fna('relatedprj_<%=recorderindex %>','"+browserUtl_prj+"','','8','<%=ismand %>')";
							initE8Browser("relatedprj_<%=recorderindex %>", <%=recorderindex %>, <%=ismand %>, "<%=fieldvalue%>", "<%=showname%>", detailbrowclick, "/data.jsp?type=8");
						});
					</script>
<%
							}else{
%>
					<input type="hidden" viewtype="<%=ismand %>" temptitle="" name="relatedprj_<%=recorderindex%>" id="relatedprj_<%=recorderindex%>" value="<%=fieldvalue%>" />
					<%=showname %>
<%		
							}
						}

                        else if( fieldname.equals("relatedcrm")) {
							showname = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(fieldvalue),user.getLanguage()) ;
							if( fieldvalue.equals("0") ) fieldvalue = "" ;
							if(isedit.equals("1") && isremark==0 ){
%>
					<span id='relatedcrm_<%=recorderindex %>wrapspan'></span>
					<!-- 
					<input type="hidden" viewtype="<%=ismand %>" temptitle="" name="relatedcrm_<%=recorderindex%>" id="relatedcrm_<%=recorderindex%>" value="<%=fieldvalue%>" />
					 -->
					<script type="text/javascript">
						jQuery(document).ready(function(){
							var detailbrowclick = "onShowBrowser2_fna('relatedcrm_<%=recorderindex %>','"+browserUtl_crm+"','','7','<%=ismand %>')";
							initE8Browser("relatedcrm_<%=recorderindex %>", <%=recorderindex %>, <%=ismand %>, "<%=fieldvalue%>", "<%=showname%>", detailbrowclick, "/data.jsp?type=7");
						});
					</script>
<%
							}else{
%>
					<input type="hidden" viewtype="<%=ismand %>" temptitle="" name="relatedcrm_<%=recorderindex%>" id="relatedcrm_<%=recorderindex%>" value="<%=fieldvalue%>" />
					<%=showname %>
<%		
							}
						}                                          // customerid 按钮条件结束


                   else if( fieldname.equals("description")) {
                            if(isedit.equals("1") && isremark==0 ){
                                if(ismand.equals("1")) {
%>
                    <input type=text class=inputstyle  name="description_<%=recorderindex%>" style="width:85%" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>" onChange="checkLength('description_<%=recorderindex%>','100','<%=fieldlable%>','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>');checkinput('description_<%=recorderindex%>','descriptionspan_<%=recorderindex%>')">
                    <span id="descriptionspan_<%=recorderindex%>"><% if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
<%

                                }else{%>
                    <input type=text class=inputstyle  onBlur="checkLength('description_<%=recorderindex%>','100','<%=fieldlable%>','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')" name="description_<%=recorderindex%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>" style="width:85%">
<%                              }
                            }
                            else {
%>
                    <%=Util.toScreen(fieldvalue,user.getLanguage())%>
                    <input type=hidden name="description_<%=recorderindex%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>">
<%
                            }
                        }

                            else if( fieldname.equals("amount")) {
                                                        if( Util.getDoubleValue(fieldvalue,0) == 0 ) fieldvalue="" ;
                                                        else
                                                            amountsum = amountsum.add(new BigDecimal(Util.getDoubleValue(fieldvalue,0))) ;
                                                        if(isedit.equals("1") && isremark==0 ){
                                                            if(ismand.equals("1")) {
%>
                                                <input type=text class=inputstyle  name="amount_<%=recorderindex%>" style="width:85%" value="<%=fieldvalue%>" maxlength="10" onKeyPress="ItemNum_KeyPress()" onBlur="checknumber1(this);checkinput('amount_<%=recorderindex%>','amountspan_<%=recorderindex%>');changenumber();">
                                                <span id="amountspan_<%=recorderindex%>"><% if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
<%
                                                            }else{
%>
                                                <input type=text class=inputstyle  name="amount_<%=recorderindex%>" style="width:85%" value="<%=fieldvalue%>" maxlength="10" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber1(this);changenumber();'>
<%                               }
                                                        }
                                                        else {
%>
                    <%=fieldvalue%><input type=hidden name="amount_<%=recorderindex%>" value="<%=fieldvalue%>">
<%
                                                        }
                                                    }

%>
                    </td>
<%
                    }
                }
                recorderindex ++ ;
%>
              </tr>
<%          }   %>
              <tr class="header" style="FONT-WEIGHT: bold; COLOR: red">
                <td><%=SystemEnv.getHtmlLabelName(358,user.getLanguage())%></td>
<%          for(int i=0;i<viewfieldnames.size();i++){
                String thefieldname = (String)viewfieldnames.get(i) ;
%>
                <td <% if(thefieldname.equals("amount")) {%> id=amountsum
                    <% } %>>
                    <% if(thefieldname.equals("amount")) {
                        amountsum = amountsum.divide ( new BigDecimal ( 1 ), 3, BigDecimal.ROUND_HALF_UP ) ;
                        String amountsumstr = "&nbsp;" ;
                        if( amountsum.doubleValue() != 0 ) amountsumstr = ""+amountsum.doubleValue() ;
                    %><%=amountsum%>
                    <% } %>
                </td>
<%          }
%>
              </tr>
            </table>
		</wea:item>
	</wea:group>
</wea:layout>
    <br>
    <input type='hidden' id=nodesnum name=nodesnum value="<%=recorderindex%>">
    <input type='hidden' id="indexnum" name="indexnum" value="<%=recorderindex%>">
    <input type='hidden' id=rowneed name=rowneed value="<%=dtlneed %>">
<input type="hidden" name="f_weaver_belongto_userid" value="<%=request.getParameter("f_weaver_belongto_userid") %>">
<input type="hidden" name="f_weaver_belongto_usertype" value="<%=request.getParameter("f_weaver_belongto_usertype") %>">

    <%--@ include file="/workflow/request/WorkflowManageSign.jsp" --%>
<jsp:include page="/workflow/request/WorkflowManageSign1.jsp" flush="true">
    <jsp:param name="requestid" value="<%=requestid%>" />
    <jsp:param name="requestlevel" value="<%=requestlevel%>" />
    <jsp:param name="requestmark" value="<%=requestmark%>" />
    <jsp:param name="creater" value="<%=creater%>" />
    <jsp:param name="creatertype" value="<%=creatertype%>" />
    <jsp:param name="deleted" value="<%=deleted%>" />
    <jsp:param name="billid" value="<%=billid%>" />
	<jsp:param name="isbill" value="1" />
    <jsp:param name="workflowid" value="<%=workflowid%>" />
    <jsp:param name="workflowtype" value="<%=workflowtype%>" />
    <jsp:param name="formid" value="<%=formid%>" />
    <jsp:param name="nodeid" value="<%=nodeid%>" />
    <jsp:param name="nodetype" value="<%=nodetype%>" />
    <jsp:param name="isreopen" value="<%=isreopen%>" />
    <jsp:param name="isreject" value="<%=isreject%>" />
    <jsp:param name="isremark" value="<%=isremark%>" />
		<jsp:param name="currentdate" value="<%=currentdate%>" />
		<jsp:param name="docfileid" value="<%=docfileid%>" />
    <jsp:param name="newdocid" value="<%=newdocid%>" />
    <jsp:param name="topage" value="<%=topage%>" />
</jsp:include>
</form>



<script language=javascript>
 $GetEle("needcheck").value+=",<%=needcheck%>";
rowindex = <%=recorderindex%> ;
insertindex=<%=recorderindex%>;
deleteindex=0;
deletearray = new Array() ;
thedeletelength=0;

function addRow()
{
	 var rowColor = getRowClassName();
	oRow = oTable.insertRow(rowindex+1);
	curindex=parseInt( $GetEle('nodesnum').value);

    for(j=0; j < fieldorders.length+1; j++) {
		oCell = oRow.insertCell(-1);
		oCell.style.height=24;
        //oCell.style.background= "#D2D1F1";
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
                        var sHtml = "<span id='organizationspan_"+insertindex+"'>" ;
                         sHtml += "<a href='/hrm/company/HrmDepartmentDsp.jsp?id=<%=udept%>'><%=udeptname%></a>"; sHtml += "</span><input type=hidden id='organizationid_"+insertindex+"' name='organizationid_"+insertindex+"' value='<%=udept%>'>" ;
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                    case 6 :
                         var oDiv = document.createElement("div");
                        var sHtml = "<input type=hidden id='organizationtype_"+insertindex+"' name='organizationtype_"+insertindex+"' value=2><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>" ;
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
						
						onShowOrganizationBtn(ismand, insertindex, "<%=udept %>", "<%=udeptname %>");
						
                        break ;
                    case 2 :
                        var oDiv = document.createElement("div");

						var detailbrowclick = "onShowBrowser2_fna('relatedprj_"+insertindex+"','"+browserUtl_prj+"','','8','"+ismand+"')";
						oDiv.innerHTML = "<span id='relatedprj_"+insertindex+"wrapspan'></span>"+
                         	//"<input type=\"hidden\" viewtype=\""+ismand+"\" temptitle=\"\" name=\"relatedprj_"+insertindex+"\" id=\"relatedprj_"+insertindex+"\" value=\"\">"+
                         	"";
						oCell.appendChild(oDiv);
                         
 						initE8Browser("relatedprj_"+insertindex, insertindex, ismand, "", "", detailbrowclick, "/data.jsp?type=8");
                         
                        break ;
                    case 3 :
                        var oDiv = document.createElement("div");

						var detailbrowclick = "onShowBrowser2_fna('relatedcrm_"+insertindex+"','"+browserUtl_crm+"','','7','"+ismand+"')";
						oDiv.innerHTML = "<span id='relatedcrm_"+insertindex+"wrapspan'></span>"+
                         	//"<input type=\"hidden\" viewtype=\""+ismand+"\" temptitle=\"\" name=\"relatedcrm_"+insertindex+"\" id=\"relatedcrm_"+insertindex+"\" value=\"\">"+
                         	"";
						oCell.appendChild(oDiv);

 						initE8Browser("relatedcrm_"+insertindex, insertindex, ismand, "", "", detailbrowclick, "/data.jsp?type=7");
                         
                        break ;
                    case 4 :
                        var oDiv = document.createElement("div");
						var sfield="<%=user.getLanguage()%>";
                        var sHtml = "<nobr><input type='text' class=inputstyle style=width:85%  id='description_"+insertindex+"' title='<%=SystemEnv.getHtmlLabelName(85, user.getLanguage())%>' name='description_"+insertindex+"'  onBlur='" ;
						sHtml+="checkLength1(description_"+insertindex+",100,this.title,"+sfield+");";
                        if(ismand == 1)
                            sHtml += "checkinput1(description_"+ insertindex+",descriptionspan_"+insertindex+");" ;
                        sHtml += "'>" ;
                        if(ismand == 1)
                            sHtml += "<span id='descriptionspan_"+insertindex+"'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>";
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                    case 5 :
                        var oDiv = document.createElement("div");
                        var sHtml = "<nobr><input type='text' class=inputstyle style=width:85%  id='amount_"+insertindex+"' name='amount_"+insertindex+"' maxlength='10' onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this);" ;
                        if(ismand == 1)
                            sHtml += "checkinput1(amount_"+ insertindex+",amountspan_"+insertindex+");" ;
                        sHtml += "changenumber();'>" ;
                        if(ismand == 1)
                            sHtml += "<span id='amountspan_"+insertindex+"'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>";
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                    case 6 :
                        var oDiv = document.createElement("div");
                        var sHtml = "<select id='organizationtype_"+insertindex+"' name='organizationtype_"+insertindex+"' onchange='clearSpan("+insertindex+")'><option value=2 default><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option><option value=1><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option><option value=3><%=SystemEnv.getHtmlLabelName(6087,user.getLanguage())%></option></select>" ;
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
if(dtldefault.equals("1") && recorderindex == 0)
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

<%
   String totallabel="";
   RecordSet.executeProc("workflow_billfield_Select",formid+"");
    while(RecordSet.next()){
        if(Util.null2String(RecordSet.getString("fieldname")).equals("total"))
          totallabel=Util.null2String(RecordSet.getString("id"));
    }

 %>
function changenumber(){

    count = 0 ;

    for(j=0;j<insertindex;j++) {
        hasdelete = false ;
        for(k=0;k<deletearray.length;k++){
            if(j==deletearray[k])
            hasdelete=true;
        }
        if(hasdelete) continue ;
        count+= eval(toFloat( $GetEle("amount_"+j).value,0)) ;
    }
    var hasedit=false;
    amountsum.innerHTML = count.toFixed(3);
    if( $GetEle("field<%=totallabel%>")!=null){
         $GetEle("field<%=totallabel%>").value =  count.toFixed(3);
        if( $GetEle("field<%=totallabel%>").type!="hidden") hasedit=true;
    }
    if(!hasedit&& $GetEle("field<%=totallabel%>span")!=null)
     $GetEle("field<%=totallabel%>span").innerHTML =  count.toFixed(3);
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
            rowindex=parseInt( $GetEle("nodesnum").value);
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
            changenumber() ;
            $GetEle("nodesnum").value = rowindex ;
        }
    }else{
        alert('<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>');
		return;
    }
}



//wfbrowvaluechange(this, 'subject_"+insertindex+"', "+insertindex+")"
function wfbrowvaluechange(obj, fieldid, index) {
	//alert("obj="+obj+";fieldid="+fieldid+";index="+index);
	
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
	}
	
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
  }

  var detailbrowclick = "onShowBrowser2_fna('organizationid_"+insertindex+"','"+browserUtl+"','','"+btnType+"','"+organizationidismand+"')";
  
	var isMustInput = "1";
	if(organizationidismand==1){
		isMustInput = "2";
	}
	initE8Browser("organizationid_"+insertindex, insertindex, organizationidismand, _browserId, _browserName, detailbrowclick, "/data.jsp?show_virtual_org=-1&type="+btnType);
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

