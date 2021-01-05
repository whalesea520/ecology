
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="java.util.*"%>
<%@ page import="weaver.general.Util,weaver.workflow.exchange.ExchangeUtil"%>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="AutomaticCols" class="weaver.workflow.exchange.DataSourceCols" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="RDataUtil" class="weaver.workflow.exchange.rdata.RDataUtil" scope="page" />
<jsp:useBean id="manageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("WFEC:SETTING", user))
{
    response.sendRedirect("/notice/noright.jsp");       
    return;
}
boolean isUseWfManageDetach = manageDetachComInfo.isUseWfManageDetach();
int tempsubcomid = -1 ;
if(isUseWfManageDetach){
    RecordSet.executeSql("select wfdftsubcomid from SystemSet");
    RecordSet.next();
    tempsubcomid = Util.getIntValue(RecordSet.getString(1),0);
}
int detachable = Util.getIntValue(request.getParameter("detachable"),0);
int operatelevel = -1  ;
if(isUseWfManageDetach){
    detachable = 1 ;
}
if(detachable==1){
    int subcompanyid = Util.getIntValue(request.getParameter("subcompanyid"),0);
    if(request.getParameter("subcompanyid")==null){
        subcompanyid=Util.getIntValue(String.valueOf(session.getAttribute("managefield_subCompanyId")),0);
    }
    if(subcompanyid == -1){
        subcompanyid = user.getUserSubCompany1();
    }
    operatelevel = CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),ExchangeUtil.WFEC_SETTING_RIGHTSTR,subcompanyid);
    if(operatelevel < 0 ){
        response.sendRedirect("/notice/noright.jsp");       
        return;
    }
}
%>
<%
ExchangeUtil ExchangeUtil = new ExchangeUtil();
ExchangeUtil.setLanguageid(user.getLanguage());
String dbtype = RecordSet.getDBType();
String requestnamedbtype = "varchar(400)";
String createrdbtype = "int";
if(dbtype.equals("oracle")){
    requestnamedbtype = "varchar2(400)";
    createrdbtype = "integer";
}

String typename = Util.null2String(request.getParameter("typename"));
String viewid=Util.null2String(request.getParameter("viewid"));
String setname = "";
String workFlowId = "";
String datasourceid = "";
String workFlowName = "";
String isbill = "";
String formID = "";
String outermaintable = "";
String outerdetailtables = "";
RecordSet.executeSql("select * from wfec_outdatawfset where id="+viewid);
if(RecordSet.next()){
    setname = Util.null2String(RecordSet.getString("setname"));
    workFlowId = Util.null2String(RecordSet.getString("workflowid"));
    datasourceid = Util.null2String(RecordSet.getString("datasourceid"));
    workFlowName=Util.null2String(WorkflowComInfo.getWorkflowname(workFlowId));
    isbill=Util.null2String(WorkflowComInfo.getIsBill(workFlowId));
    formID=Util.null2String(WorkflowComInfo.getFormId(workFlowId));
    outermaintable = Util.null2String(RecordSet.getString("outermaintable"));
    outerdetailtables = Util.null2String(RecordSet.getString("outerdetailtables"));
}
//ArrayList maintablecolsList = DataSourceCols.getAllColumns(datasourceid,outermaintable);
ArrayList outerdetailtablesArr = Util.TokenizerString(outerdetailtables,",");
int detailcount = outerdetailtablesArr.size() ;
String texttype = ExchangeUtil.getDbtype(dbtype,"0");
String filetype = ExchangeUtil.getDbtype(dbtype,"1");


String tiptitle1 = SystemEnv.getHtmlLabelName(84602,user.getLanguage()) ; //"如果转换规则为自定义sql，此设置查询的是当前系统，格式为：select 最终字段 from tablename where 条件字段={?currentvalue}，{?currentvalue}为固定格式。";//如果转换规则为自定义sql，此设置查询的是当前系统，格式为：select 最终字段 from tablename where 条件字段={?currentvalue}，{?currentvalue}为固定格式。
%>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript" src="/js/weaver_wev8.js"></script>
<link type="text/css" href="/js/ecology8/base/jquery-ui_wev8.css" rel=stylesheet>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type="text/javascript" src="/js/dojo_wev8.js"></script>
<script type="text/javascript" src="/js/tab_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/dragBox/parentShowcol_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestView_wev8.css" type="text/css" />
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<link rel="stylesheet" href="/js/ecology8/selectbox/css/jquery.selectbox_wev8.css" type="text/css" />
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script type="text/javascript" src="/js/jquery-autocomplete/jquery.autocomplete_wev8.js"></script>
<script type="text/javascript" src="/js/jquery-autocomplete/browser_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(23076,user.getLanguage())+" - "+SystemEnv.getHtmlLabelName(19342,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<body id="setbody">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
    <tr>
        <td></td>
        <td class="rightSearchSpan" style="text-align:right; width:500px!important">
            <input type="button" id="doSubmit" value="<%=SystemEnv.getHtmlLabelName(86 ,user.getLanguage()) %>" class="e8_btn_top" onclick="doSubmit()"/>
            <span title="<%=SystemEnv.getHtmlLabelName(23036 ,user.getLanguage()) %>" class="cornerMenu"></span>
        </td>
    </tr>
</table>
<form name="frmmain" method="post" action="automaticOperation.jsp">
<input type="hidden" id="operate" name="operate" value="adddetail">
<input type="hidden" id="viewid" name="viewid" value="<%=viewid%>">
<input type="hidden" id="typename" name="typename" value="<%=typename%>">
<input type="hidden" id="detailcount" name="detailcount" value="<%=detailcount%>">
<input type="hidden" id="needcheck" name="needcheck" value="" />
<wea:layout>
        <%
        RDataUtil.setIsrdata(1);
        String tempfieldname = "";
        if(!workFlowId.equals("")){ %>
        <wea:group context='<%=SystemEnv.getHtmlLabelName(125442,user.getLanguage()) %>' attributes="{'samePair':'SetInfo','groupOperDisplay':'none','itemAreaDisplay':'block'}">
            <wea:item type="groupHead">
                <input type="button" class="addbtn" title="<%= SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" onclick="groupAction.addRow();"/>
                <input type="button" class="delbtn" title="<%= SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onclick="deleteAction();"/>
            </wea:item>
            <wea:item attributes="{'colspan':'full','isTableList':'true'}">
                <div id="FieldList" class="groupmain" style="width:100%"></div>
                <%  
                int count = 0 ;
                String ajaxDatas = "[]";
                String sql = "SELECT id,wffieldid,wffieldname,wffieldhtmltype,wffieldtype,wffielddbtype,outerfieldname,outfielddbtype,changetype,customtxt,customsql FROM wfec_outdatasetdetail where detailindex=0 and mainid="+viewid+" ORDER BY dsporder";
                RecordSet.executeSql(sql);
                count = RecordSet.getCounts() ;
                ajaxDatas = RDataUtil.getTableFieldInitDetailDatas("FieldList",user,RecordSet,-1,formID,isbill);
                //System.out.println(ajaxDatas);
                String outfieldtypestr = "<span id='outfieldtypespan_#rowIndex#' name='outfieldtypespan_#rowIndex#'></span><input type='hidden' name='outfieldtype' id='outfieldtype' value='' /><input type='hidden' name='id' id='id'  />";
                String wffieldtypestr = "<span id='fieldtypespan_#rowIndex#' name='fieldtypespan_#rowIndex#'></span><input type='hidden' name='fieldtype' id='fieldtype' value='' /><input type='hidden' name='fielddbtype' id='fielddbtype' value='' />";
                String ruletype = "<select id='rulesopt' name='rulesopt' notBeauty=true onchange=changecustom(this,'_#rowIndex#')>"+ExchangeUtil.getRuleOption(user.getLanguage())+"</select>" ;
                String rulestr = "<input type='text' name='customstr' id='customstr' value='' style='width:100%'/>" +
                                 "<span id=custiomhrm_#rowIndex# style=''><span class='browser'  _callback='changestrvalue' _callbackParams='_#rowIndex#' hasInput='true' name='chrmid_#rowIndex#' getBrowserUrlFn='getResourceUrl' isSingle='true' getBrowserUrlFnParams='0'  completeUrl='/data.jsp' ></span></span>" ;
                %>
                <input type="hidden" id="maindeleterow" name="maindeleterow" value="0" />
                <input type="hidden" id="maintablerows" name="maintablerows" value="<%=count %>" />
                <input type="hidden" id="mainaddrows" name="mainaddrows" value="0" />
                <input type="hidden" id="maintableaname" name="maintableaname" value="<%=outermaintable %>" />
                <script type="text/javascript">
                    var groupAction = null;
                    jQuery(document).ready(function(){
                        var ajaxDatas = <%=ajaxDatas%> ;
                        //completeUrl='/data.jsp?type=fieldBrowser&wfid=<%=workFlowId%>' isAutoComplete='true'
                        var db_fieldbrowser = "<span class='browser'  _callback='settablefieldtype'  _callbackParams='_#rowIndex#' name='outerfieldname'  getBrowserUrlFn='getTableField' getBrowserUrlFnParams='<%=outermaintable%>#0'></span>";
                        var wf_fieldbrowser  = "<span class='browser'  _callback='setwffieldtype' _callbackParams='_#rowIndex#' hasInput='true' name='fieldid' getBrowserUrlFn='getWorkflowTableField' isSingle='true' getBrowserUrlFnParams='0' completeUrl='' isMustInput='2' ></span><input type='hidden' name='fieldname' id='fieldname'  />" ;
                        var items=[
                            {width:"20%",colname:"<%=SystemEnv.getHtmlLabelName(19372,user.getLanguage()) %>",itemhtml:wf_fieldbrowser},
                            {width:"10%",colname:"<%=SystemEnv.getHtmlLabelName(84113,user.getLanguage()) %>",itemhtml:"<%=wffieldtypestr%>"},
                            {width:"20%",colname:"<%=SystemEnv.getHtmlLabelName(125365,user.getLanguage()) %>",itemhtml:db_fieldbrowser},
                            {width:"10%",colname:"<%=SystemEnv.getHtmlLabelName(84113,user.getLanguage()) %>",itemhtml:"<%=outfieldtypestr%>"},
                            {width:"10%",colname:"<%=SystemEnv.getHtmlLabelName(23128,user.getLanguage()) %><SPAN class=\".e8tips\" style=\"CURSOR: hand\" id=remind_m title=\"<%=tiptitle1 %>\"><IMG id=ext-gen124  align=absMiddle src=\"/images/remind_wev8.png\"></SPAN>",itemhtml:"<%=ruletype%>"},
                            {width:"30%",colname:"",itemhtml:"<%=rulestr%>"}
                            ];
                        var option = {
                            basictitle:"",
                            optionHeadDisplay:"none",
                            colItems:items,
                            container:"#FieldList",
                            toolbarshow:false,
                            openindex:true,
                            configCheckBox:true,
                            usesimpledata:true,
                            initdatas:ajaxDatas,
                            canDrag:false,
                            addrowCallBack:marcallback,
                            deleterowCallBack:deletecallback,
                            checkBoxItem:{"itemhtml":'<input name="fieldChecbox" class="groupselectbox" type="checkbox" value="-1">',width:"5%"}
                        };
                        groupAction=new WeaverEditTable(option);
                        jQuery("#FieldList").append(groupAction.getContainer());
                    });
                    function deleteAction(){
                        //top.Dialog.confirm("<%=SystemEnv.getHtmlLabelNames("15097",user.getLanguage())%>",function(){
                            groupAction.deleteRows();
                            jQuery("#maindeleterow").val(groupAction.deleteRowIds);
                        //});
                    }
                    function marcallback($this,tr){
                        try{
                            var ct = $this.count ;
                            jQuery("#maintablerows").val(ct);
                            var addidx = jQuery("#mainaddrows").val();
                            jQuery("#mainaddrows").val(addidx+","+ct);
                            jQuery("#customstr_"+(ct-1)).hide();
                            jQuery("#custiomhrm_"+(ct-1)).hide();
                            
                            var rulesopt = jQuery("#rulesopt_"+(ct-1)).val() ;
                            if(jQuery("#fieldtype_"+(ct-1)).val()=='3_1'&& rulesopt==9){
                                jQuery("#custiomhrm_"+(ct-1)).show();
                            }else if(rulesopt == 6 || rulesopt == 9){
                                jQuery("#customstr_"+(ct-1)).show();
                            }else{
                                jQuery("#customstr_"+(ct-1)).hide();
                            }
                            
                            var checkfield = jQuery("#needcheck").val();
                            jQuery("#needcheck").val(checkfield+",fieldid_"+(ct-1));
                        }catch(e){
                        
                        }
                        return ;
                    }
                  function deletecallback($this,tr){
                        jQuery("#maindeleterow").val($this.deleteRowIds);
                    }   
                </script>
            </wea:item>
        </wea:group>
        <%
            for(int i = 0 ; i < outerdetailtablesArr.size(); i++){
                String outdetailname = outerdetailtablesArr.get(i).toString();
                if(outdetailname.equals("-")||outdetailname.equals("")){
                    //continue ;
                }
        %>      
            <wea:group context='<%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())+(i+1)+SystemEnv.getHtmlLabelName(84679,user.getLanguage()) %>' attributes="{'samePair':'SetInfo1','groupOperDisplay':'none','itemAreaDisplay':'block'}">
            <wea:item type="groupHead">
                <input type="button" class="addbtn" title="<%= SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" onclick="groupAction<%=i %>.addRow();"/>
                <input type="button" class="delbtn" title="<%= SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onclick="deleteAction<%=i %>();"/>
            </wea:item>
            <wea:item attributes="{'colspan':'full','isTableList':'true'}">
                <div id="dtFieldList<%=i %>" class="groupmain" style="width:100%;"></div>
                <%  
                int count = 0 ;
                String ajaxDatas = "[]";
                String sql = "SELECT id,wffieldid,wffieldname,wffieldhtmltype,wffieldtype,wffielddbtype,outerfieldname,outfielddbtype,changetype,customtxt,customsql FROM wfec_outdatasetdetail where detailindex="+(i+1)+" and mainid="+viewid+" ORDER BY dsporder";
                RecordSet.executeSql(sql);
                count = RecordSet.getCounts() ;
                ajaxDatas = RDataUtil.getTableFieldInitDetailDatas("DtFieldList",user,RecordSet,i,formID,isbill);
                //System.out.println(ajaxDatas);
                String outfieldtypestr = "<span id='outfieldtypespan"+i+"_#rowIndex#' name='outfieldtypespan"+i+"_#rowIndex#'></span>";
                String wffieldtypestr = "<span id='fieldtypespan"+i+"_#rowIndex#' name='fieldtypespan"+i+"_#rowIndex#'></span>";
                String ruletype = "<select id='rulesopt"+i+"' name='rulesopt"+i+"' notBeauty=true onchange=changecustom(this,'"+i+"_#rowIndex#')>"+ExchangeUtil.getRuleOption(user.getLanguage())+"</select>" ;
                String rulestr = "<input type='text' name='customstr"+i+"' id='customstr"+i+"' value='' style='width:100%'/>" +
                                 "<span id=custiomhrm"+i+"_#rowIndex# style=''><span class='browser'  _callback='changestrvalue' _callbackParams='"+i+"_#rowIndex#' hasInput='true' name='chrmid"+i+"_#rowIndex#' getBrowserUrlFn='getResourceUrl' isSingle='true' getBrowserUrlFnParams='0'  completeUrl='/data.jsp' ></span></span>" ;
                
                String o1 = "<input type='hidden' name='id"+i+"' id='id"+i+"'  /><input type='hidden' name='outfieldtype"+i+"' id='outfieldtype"+i+"' value='' />";
                String f1 = "<input type='hidden' name='fieldtype"+i+"' id='fieldtype"+i+"' value='' />";
                String h1 = "<input type='hidden' name='fielddbtype"+i+"' id='fielddbtype"+i+"' value='' />";
                String n1 = "<input type='hidden' name='fieldname"+i+"' id='fieldname"+i+"'  />";
                %>
                <input type="hidden" id="dt<%=i %>deleterow" name="dt<%=i %>deleterow" value="0" />
                <input type="hidden" id="dt<%=i %>tablerows" name="dt<%=i %>tablerows" value="<%=count %>" />
                <input type="hidden" id="dt<%=i %>addrows" name="dt<%=i %>addrows" value="0" />
                <input type="hidden" id="dt<%=i %>tableaname" name="dt<%=i %>tableaname" value="<%=outdetailname %>" />
                <script type="text/javascript">
                    var groupAction<%=i %> = null;
                    jQuery(document).ready(function(){
                        var ajaxDatas = <%=ajaxDatas%> ;
                        //completeUrl='/data.jsp?type=fieldBrowser&wfid=<%=workFlowId%>' isAutoComplete='true'
                        var db_fieldbrowser = "<span class='browser'  _callback='settablefieldtype'  _callbackParams='<%=i %>_#rowIndex#' name='outerfieldname<%=i %>'  getBrowserUrlFn='getTableField' getBrowserUrlFnParams='<%=outdetailname%>#1'></span>";
                        var wf_fieldbrowser  = "<span class='browser'  _callback='setwffieldtype' _callbackParams='<%=i %>_#rowIndex#' hasInput='true' name='fieldid<%=i %>' getBrowserUrlFn='getWorkflowTableField' isSingle='true' getBrowserUrlFnParams='<%=(i+1)%>' completeUrl='' isMustInput='2' ></span>" ;
                        var items=[
                            {width:"20%",colname:"<%=SystemEnv.getHtmlLabelName(19372,user.getLanguage()) %>",itemhtml:wf_fieldbrowser},
                            {width:"10%",colname:"<%=SystemEnv.getHtmlLabelName(84113,user.getLanguage()) %>",itemhtml:"<%=wffieldtypestr%>"},
                            {width:"20%",display:"",colname:"<%=SystemEnv.getHtmlLabelName(125365,user.getLanguage()) %>",itemhtml:db_fieldbrowser},
                            {width:"10%",colname:"<%=SystemEnv.getHtmlLabelName(84113,user.getLanguage()) %>",itemhtml:"<%=outfieldtypestr%>"},
                            {width:"10%",colname:"<%=SystemEnv.getHtmlLabelName(23128,user.getLanguage()) %><SPAN class=\".e8tips\" style=\"CURSOR: hand\" id=remind_m title=\"<%=tiptitle1 %>\"><IMG id=ext-gen124  align=absMiddle src=\"/images/remind_wev8.png\"></SPAN>",itemhtml:"<%=ruletype%>"},
                            {width:"30%",colname:"",itemhtml:"<%=rulestr%>"},
                            {width:"0%",display:"none",colname:"",itemhtml:"<%=o1%>"},
                            {width:"0%",display:"none",colname:"",itemhtml:"<%=f1%>"},
                            {width:"0%",display:"none",colname:"",itemhtml:"<%=h1%>"},
                            {width:"0%",display:"none",colname:"",itemhtml:"<%=n1%>"}
                            ];
                        var option = {
                            basictitle:"",
                            optionHeadDisplay:"none",
                            colItems:items,
                            container:"#dtFieldList<%=i %>",
                            toolbarshow:false,
                            openindex:true,
                            configCheckBox:true,
                            usesimpledata:true,
                            initdatas:ajaxDatas,
                            canDrag:false,
                            addrowCallBack:marcallback<%=i %>,
                            deleterowCallBack:deletecallback<%=i %>,
                            checkBoxItem:{"itemhtml":'<input name="fieldChecbox<%=i %>" class="groupselectbox" type="checkbox" value="-1">',width:"5%"}
                        };
                        groupAction<%=i %> = new WeaverEditTable(option);
                        jQuery("#dtFieldList<%=i %>").append(groupAction<%=i %>.getContainer());
                    });
                    function deleteAction<%=i %>(){
                        //top.Dialog.confirm("<%=SystemEnv.getHtmlLabelNames("15097",user.getLanguage())%>",function(){
                            groupAction<%=i %>.deleteRows();
                            //jQuery("#dt<%=i %>deleterow").val(groupAction<%=i %>.deleteRowIds);
                        //});
                    }
                    function deletecallback<%=i %>($this,tr){
                        jQuery("#dt<%=i %>deleterow").val($this.deleteRowIds);
                    }
                    function marcallback<%=i %>($this,tr){
                        try{
                            var idx = $this.count ;
                            jQuery("#dt<%=i %>tablerows").val(idx);
                            var addidx = jQuery("#dt<%=i %>addrows").val();
                            jQuery("#dt<%=i %>addrows").val(addidx+","+ idx);
                            
                            jQuery("#customstr<%=i %>_"+(idx-1)).hide();
                            jQuery("#custiomhrm<%=i %>_"+(idx-1)).hide();
                            
                            var rulesopt = jQuery("#rulesopt<%=i %>_"+(idx-1)).val() ;
                            if(jQuery("#fieldtype<%=i %>_"+(idx-1)).val()=='3_1'&& rulesopt==9){
                                jQuery("#custiomhrm<%=i %>_"+(idx-1)).show();
                            }else if(rulesopt == 6 || rulesopt == 9){
                                jQuery("#customstr<%=i %>_"+(idx-1)).show();
                            }else{
                                jQuery("#customstr<%=i %>_"+(idx-1)).hide();
                            }
                            
                            var checkfield = jQuery("#needcheck").val();
                            jQuery("#needcheck").val(checkfield+",fieldid<%=i %>_"+(idx-1));
                        }catch(e){
                            //if(window.console)console.log("error : "+e.message);
                        }
                        return ;
                    }
                </script>
            </wea:item>
        </wea:group>
                
        <%}
        %>
        <%}//end if workflow is not null %>
        <wea:group context='<%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%>' attributes="{'samePair':'RemarkInfo','groupOperDisplay':'none','itemAreaDisplay':'block'}">
        <wea:item attributes="{'colspan':'2'}">
            <font>
                1:<%=SystemEnv.getHtmlLabelName(23127,user.getLanguage())%><br>
                2:<%=SystemEnv.getHtmlLabelName(23126,user.getLanguage())%><br>
                &nbsp;&nbsp;&nbsp;[<%=SystemEnv.getHtmlLabelName(23157,user.getLanguage())%>]<br>
                3:<%=SystemEnv.getHtmlLabelName(23123,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(23124,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(23125,user.getLanguage())%>               
            </font>
        </wea:item>
    </wea:group>
  </wea:layout>
</form>
</body>
</html>
<script language="javascript">
jQuery(function(){
    jQuery("span[id^=remind]").wTooltip({html:true});
});
function doSubmit(){
    jQuery($GetEle("setbody")).attr("onbeforeunload", "");
    var checkfields = jQuery("#needcheck").val();
    var count = <%=(detailcount+1)%> ;
    var ccount = 0 ;
    if(check_form($GetEle("frmmain"),checkfields)){     
        e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(25666,user.getLanguage())%>",true,"xTable_message");
        <%
            for (int i = -1 ; i < detailcount ; i++ ){
        %>
            if(loopInputs(getAllValues(<%=i %>),<%=i %>)){
                ccount++;
            }
        <%  
            }   
        %>
        if(ccount==count){
            document.frmmain.submit();
        }else{
            e8showAjaxTips("",false,"xTable_message");
        }
    }
}

function onShowHrmResource(inputename,tdname){
    var ids = jQuery("#"+inputename).val();            
    var datas=null;
    var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
    var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置; 
    datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?resourceids="+ids);
    
    if (datas){
        if (datas.id!= "" ){
            var strs="<a href=javaScript:openhrm("+datas.id+"); onclick='pointerXY(event);'>"+datas.name+"</a>&nbsp";
            
            jQuery("#"+tdname).html(strs);
            jQuery("#"+inputename).val(datas.id);
        }
        else{
            jQuery("#"+tdname).html("");
            jQuery("#"+inputename).val("");
        }
    }
}
function onBackUrl(url)
{
    jQuery($GetEle("setbody")).attr("onbeforeunload", "");
    document.location.href=url;
}

function getWorkflowTableField(params){
    var formid = '<%=formID %>';
    var isbill = '<%=isbill%>';
    var isdetail =  params ;
    var urls = "/systeminfo/BrowserMain.jsp?mouldID=workflow&formid="+formid+"&isbill="+isbill+"&url=/workflow/exchange/FormFieldsBrowser.jsp?mouldID=workflow&formid="+formid+"&isbill="+isbill+"&isr=1&isdetail="+isdetail;
    return urls;
}

/*数据表字段类型callback*/
function settablefieldtype(event,datas,name,_callbackParams){
    jQuery("#outfieldtypespan"+_callbackParams).html(datas.type);
    jQuery("#outfieldtype"+_callbackParams).val(datas.type);
}

/*表单字段类型callback*/
function setwffieldtype(event,datas,name,_callbackParams){
    jQuery("#fieldname"+_callbackParams).val(datas.dbname);
    jQuery("#fieldtypespan"+_callbackParams).html(datas.dbtype);
    jQuery("#fielddbtype"+_callbackParams).val(datas.dbtype);
    jQuery("#fieldtype"+_callbackParams).val(datas.htmltype);
    
    jQuery.ajax({
        url:'/workflow/exchange/ruleoption.jsp',
        data:{ruletype:'',htmltype:datas.htmltype,isradata:1},
        success:function(data){
            try{
                //jQuery("#rulesopt"+_callbackParams).selectbox("detach");
                jQuery("#rulesopt"+_callbackParams).empty();
                jQuery("#rulesopt"+_callbackParams).append(data);
                changecustom(jQuery("#rulesopt"+_callbackParams),_callbackParams);
                //beautySelect();
                //jQuery("#rulesopt"+_callbackParams).selectbox("attach");
            }catch(e){
                alert(e.message);
            }
        }
    });
    
    //checkfield(datas.id,"",_callbackParams,datas.name);
    jQuery("#rulesopt"+_callbackParams).selectbox("detach");
}

function changecustom(obj,_callbackParams){
/*
    var ruletype = jQuery("#rulesopt"+_callbackParams).val() ;
        
    if(ruletype==6 || ruletype==9){
        jQuery("#customstr"+_callbackParams).show();
        jQuery("#customstr"+_callbackParams).val("");
    }else{
        jQuery("#customstr"+_callbackParams).hide();
    }
*/
    var ruletype = jQuery("#rulesopt"+_callbackParams).val() ;
    var fieldtype = jQuery("#fieldtype"+_callbackParams).val() ;
    //if(window.console) console.log("fieldtype = "+fieldtype);
    if(ruletype==6){
        jQuery("#customstr"+_callbackParams).show();
        jQuery("#customstr"+_callbackParams).val("");
        jQuery("#custiomhrm"+_callbackParams).hide();
    }else if(ruletype==9){
        if(fieldtype!='3_1'){
            jQuery("#customstr"+_callbackParams).show();
            jQuery("#customstr"+_callbackParams).val("");
        }else{
            jQuery("#custiomhrm"+_callbackParams).show();
        }
    }else{
        jQuery("#customstr"+_callbackParams).hide();
        jQuery("#custiomhrm"+_callbackParams).hide();
    }   
}
/*表名 # 是否明细*/
function getTableField(params){
    var datasourceid = '<%=datasourceid %>';
    var needcheckds = "false";
    var dmlformid = '';
    var dmltablename = params.split("#")[0] ;
    var dmlisdetail = params.split("#")[1];
    var urls = "/systeminfo/BrowserMain.jsp?mouldID=workflow&datasourceid="+datasourceid+"&needcheckds="+needcheckds+"&dmlformid="+dmlformid+"&dmlisdetail="+dmlisdetail+"&dmltablename="+dmltablename+"&url=/workflow/exchange/TableFieldsBrowser.jsp";
    return urls;    
}
function getResourceUrl(){
    return "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp";
}

function changestrvalue(event,datas,name,_callbackParams){
    jQuery("customstr"+_callbackParams).val(datas.id);
}

function checkfield(fieldid,tablename,_callbackParams,showname){
    jQuery.ajax({
        url:'/workflow/exchange/CheckData.jsp',
        data:{changetype:'0',type:'checkset',mainid:'<%=viewid %>',tablename:tablename,fieldid:fieldid ,flag:Math.random()},
        success:function(data){
            if(data==1){
                top.Dialog.alert("["+showname+"] <%=SystemEnv.getHtmlLabelName(129041, user.getLanguage())%>");
                try{
                    jQuery("#fieldid"+_callbackParams).val("");
                    jQuery("#fieldid"+_callbackParams+"span").html("");
                    jQuery("#fieldid"+_callbackParams+"spanimg").html("<img align='absmiddle' src='/images/BacoError_wev8.gif'>");
                }catch(e){}
            }
            
            return false ;
        }
    });
}

function getAllValues(groupid){
  var arrValues = "";   
  var len = 0 ;
  if(groupid==-1){
    len = jQuery("#maintablerows").val();
    for(var i = 0; i < len; i++){
        var value = jQuery("#fieldid_"+i).val();
        if(value!=''){
            arrValues += ":"+value+":";
        }
        
    }    
  }else{
    len = jQuery("#dt"+groupid+"tablerows").val();
    for(var i = 0; i < len; i++){
        var value = jQuery("#fieldid"+groupid+"_"+i).val();
        if(value!=''){
            arrValues += ":"+value+":";
        }
    }   
  }
  return arrValues ;
}

function loopInputs(value,groupid){
    var rst = "";
    var showname = "";
    if(groupid==-1){
        showname = "【<b><%=SystemEnv.getHtmlLabelName(21778,user.getLanguage()) %></b>】" ;
    }else{
        showname = "【<b><%=SystemEnv.getHtmlLabelName(19325,user.getLanguage()) %>"+(groupid+1)+"</b>】" ;
    }
  if(/(:[^:]+:).*?\1/g.test(value)){
    rst =  showname+" <%=SystemEnv.getHtmlLabelName(84684,user.getLanguage()) %><br>";
  }else{
    rst = "" ;
  }
  if(groupid==-1){
    if(value.indexOf(":-9:")==-1){
        rst += " <%=SystemEnv.getHtmlLabelName(84685,user.getLanguage()) %>"
    }
  }
  if(rst==''){
    return true ;
  }else{
    top.Dialog.alert(rst);
    return false ;
  }
}
</script>
<script language=javascript src="/js/checkData_wev8.js"></script>
