<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,weaver.conn.RecordSetDataSource" %>
<%@ page import="java.util.*,java.sql.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.interfaces.datasource.DataSource"%>
<%@ page import="weaver.general.StaticObj,weaver.workflow.exchange.ExchangeUtil"%>

<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RDataUtil" class="weaver.workflow.exchange.rdata.RDataUtil" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
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

String viewid = Util.null2String(request.getParameter("viewid"));
String _fromURL = Util.null2String(request.getParameter("_fromURL"));

String setname = "";
String workflowid = "";
String datasourceid = "";
String workflowname = "";
String outermaintable = "";
String requestid = "";
String outermainwhere = "";
String outerdetailtables = "";




String formid = "";
String isbill = "";
RecordSet.executeSql("select * from wfec_outdatawfset where id="+viewid);
if(RecordSet.next()){
    setname = Util.null2String(RecordSet.getString("setname"));
    workflowid = Util.null2String(RecordSet.getString("workflowid"));
    datasourceid = Util.null2String(RecordSet.getString("datasourceid"));
    formid = WorkflowComInfo.getFormId(workflowid);
    isbill = WorkflowComInfo.getIsBill(workflowid);
    workflowname = Util.null2String(WorkflowComInfo.getWorkflowname(workflowid));
    outermaintable = Util.null2String(RecordSet.getString("outermaintable"));
    requestid = Util.null2String(RecordSet.getString("requestid"));
    outermainwhere = Util.null2String(RecordSet.getString("outermainwhere"));
    outerdetailtables = Util.null2String(RecordSet.getString("outerdetailtables"));
}

%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
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
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(84594, user.getLanguage());
String needfav ="";
String needhelp ="";
String maintablename = "";
String maintableid = "";
ArrayList detailtablelist = new ArrayList();
ArrayList detailtableidlist = new ArrayList();

if(maintablename.equals("")){
    maintablename = outermaintable ;
    detailtablelist = Util.TokenizerString(outerdetailtables,",");
}
String dbtype = "";
Connection conn = null ;
try{
    ExchangeUtil eu = new ExchangeUtil();
    conn = eu.getConnection(datasourceid);
    dbtype = eu.getDbType();
}catch(Exception e){
    e.printStackTrace();
}
String texttype = ExchangeUtil.getDbtype(dbtype,"0");
String filetype = ExchangeUtil.getDbtype(dbtype,"1");
%>
</head>
<body>
<table id="topTitle" cellpadding="0" cellspacing="0">
    <tr>
        <td></td>
        <td class="rightSearchSpan" style="text-align:right; width:500px!important">
            <input type="button" id="doSubmit" value="<%=SystemEnv.getHtmlLabelName(86 ,user.getLanguage()) %>" class="e8_btn_top" onclick="doSubmit()"/>
            <span title="<%=SystemEnv.getHtmlLabelName(23036 ,user.getLanguage()) %>" class="cornerMenu"></span>
        </td>
    </tr>
</table>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%
    String tmptype = "";
    String tmpattribute = "";
    String tiptitle1 = SystemEnv.getHtmlLabelName(84603,user.getLanguage()); //"字段名不能用中文,而且必须以英文字母开头(如field4),长度不能超过30位。";
%>
<form action="automaticOperation.jsp" id="weaver" name="weaver">
<input type="hidden" id="viewid" name="viewid" value="<%=viewid %>" />
<input type="hidden" id="operate" name="operate" value="savetablefield" />
<input type="hidden" id="dtcount" name="dtcount" value="<%=detailtablelist.size() %>" />
<input type="hidden" id="datasourceid" name="datasourceid" value="<%=datasourceid %>"/>
<wea:layout type="2col">
    <wea:group context='<%=SystemEnv.getHtmlLabelNames("21778,15190",user.getLanguage())+"  ("+maintablename.toUpperCase()+")" %>'>
        <wea:item type="groupHead">
            <input type="button" class="addbtn" title="<%= SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" onclick="groupAction.addRow();"/>
            <input type="button" class="delbtn" title="<%= SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onclick="deleteAction();"/>
        </wea:item>
        <wea:item attributes="{'isTableList':'true','colspan':'full'}">
            <div id="FieldList"></div>
            <%  
                String ajaxDatas = "";
                int count = 0 ;
                //if(!maintableid.equals("")){
                //  RecordSet.executeSql("select * from wfec_tablefield where tableid="+maintableid+" order by id");//2外部接口
                //  count = RecordSet.getCounts();
                //  ajaxDatas = RDataUtil.getIntDatas("FieldList",user,RecordSet); 
                //}else{
                    ajaxDatas = RDataUtil.getDataSourceInitDatas(datasourceid,maintablename,-1) ;//直接显示字段
                    count = RDataUtil.getRcount() ;
                //}
                String typestr = "<select name='type' id='type' onchange='clearTxtOrBlob(this,#rowIndex#,null)'>"+
                                    "<option value='0'>"+SystemEnv.getHtmlLabelName(608,user.getLanguage())+"</option><option value='1'>"+SystemEnv.getHtmlLabelName(18493,user.getLanguage())+"</option></select>";
                %>
                <input type="hidden" id="maindeleterow" name="maindeleterow" value="0" />
                <input type="hidden" id="maintablerows" name="maintablerows" value="<%=count %>" />
                <input type="hidden" id="maintableid" name="maintableid" value="<%=maintableid %>" />
                <input type="hidden" id="maintablename" name="maintablename" value="<%=maintablename %>" />
                <input type="hidden" id="mainaddrows" name="mainaddrows" value="0" />
                <script type="text/javascript">
                    var groupAction = null;
                    jQuery(document).ready(function(){
                        var ajaxDatas = <%=ajaxDatas%>
                        var items=[
                            {width:"10%",display:"",colname:"<%=SystemEnv.getHtmlLabelName(124937,user.getLanguage())%><SPAN class=\".e8tips\" style=\"CURSOR: hand\" id=remind_m title=\"<%=tiptitle1 %>\"><IMG id=ext-gen124 align=absMiddle src=\"/images/remind_wev8.png\"></SPAN>",itemhtml:"<input name='dbname' id='dbname' type='text' onblur=\"checkinput_char_num(this.name);checkfield(this,'<%=maintablename %>')\"  /><span class='mustinput'></span>"},
                            {width:"20%",colname:"<%=SystemEnv.getHtmlLabelName(687,user.getLanguage())%>",itemhtml:"<%=typestr%>"},
                            {width:"20%",colname:"<%=SystemEnv.getHtmlLabelName(84113,user.getLanguage())%>",itemhtml:"<input name='dbtype' id='dbtype' type='text' value='<%=texttype%>' />"}
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
                            //jQuery("#maindeleterow").val(groupAction.deleteRowIds);
                        //});
                    }
                    function deletecallback($this,tr){
                        jQuery("#maindeleterow").val($this.deleteRowIds);
                    }
                    function marcallback($this,tr){
                        try{
                            jQuery("#maintablerows").val(groupAction.count);
                            var addidx = jQuery("#mainaddrows").val();
                            jQuery("#mainaddrows").val(addidx+","+groupAction.count);
                        }catch(e){
                        
                        }
                        return ;
                    }
                </script>
        </wea:item>
    </wea:group>
    
    <%
        for(int i = 0 ; i < detailtablelist.size() ; i++){
            String detailtablename = detailtablelist.get(i).toString();
    %>
        
    <wea:group context='<%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())+(i+1)+SystemEnv.getHtmlLabelName(15190,user.getLanguage())+"  ("+detailtablename.toUpperCase()+")" %>'>
        <wea:item type="groupHead">
            <input type="button" class="addbtn" title="<%= SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" onclick="groupAction_<%=i%>.addRow();"/>
            <input type="button" class="delbtn" title="<%= SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onclick="deleteAction_<%=i%>();"/>
        </wea:item>
        <wea:item attributes="{'isTableList':'true','colspan':'full'}">
            <div id="DtFieldList<%=i %>"></div>
            <%  
                 int count = 0;
                 String ajaxDatas = "";
                 String tempdttableid = "";
                //if(detailtableidlist.size()>0){
                //  RecordSet.executeSql("select * from wfec_tablefield where tableid="+detailtableidlist.get(i).toString()+" order by id");//2外部接口
                //  count = RecordSet.getCounts();  
                //  ajaxDatas = RDataUtil.getInitDetailDatas("DtFieldList",user,RecordSet,i); 
                //  tempdttableid = detailtableidlist.get(i).toString() ;
                //}else{
                    ajaxDatas = RDataUtil.getDataSourceInitDatas(datasourceid,detailtablename,i) ;//直接显示字段
                    count = RDataUtil.getRcount() ;
                //}
                String typestr = "<select name='dt"+i+"_type' id='dt"+i+"_type' onchange='clearTxtOrBlob(this,#rowIndex#,"+i+")'>"+
                                    "<option value='0'>"+SystemEnv.getHtmlLabelName(608,user.getLanguage())+"</option><option value='1'>"+SystemEnv.getHtmlLabelName(18493,user.getLanguage())+"</option></select>";
                %>
                <script type="text/javascript">
                    var groupAction_<%=i%> = null;
                    jQuery(document).ready(function(){
                        var ajaxDatas_<%=i%> = <%=ajaxDatas%>
                        var items_<%=i%>=[
                            {width:"10%",display:"",colname:"<%=SystemEnv.getHtmlLabelName(124937,user.getLanguage())%><SPAN class=\".e8tips\" style=\"CURSOR: hand\" id=remind_<%=i%> title=\"<%=tiptitle1 %>\"><IMG id=ext-gen124 align=absMiddle src=\"/images/remind_wev8.png\"></SPAN>",itemhtml:"<input name='dt<%=i %>_dbname' id='dt<%=i %>_dbname' type='text' onblur=\"checkinput_char_num(this.name);checkfield(this,'<%=detailtablename %>')\"  /><span class='mustinput'></span>"},
                            {width:"20%",colname:"<%=SystemEnv.getHtmlLabelName(687,user.getLanguage())%>",itemhtml:"<%=typestr%>"},
                            {width:"20%",colname:"<%=SystemEnv.getHtmlLabelName(84113,user.getLanguage())%>",itemhtml:"<input name='dt<%=i %>_dbtype' id='dt<%=i %>_dbtype' type='text' value='<%=texttype%>' />"}
                            ];
                        var option_<%=i%> = {
                            basictitle:"",
                            optionHeadDisplay:"none",
                            colItems:items_<%=i%>,
                            container:"#DtFieldList<%=i %>",
                            toolbarshow:false,
                            openindex:true,
                            configCheckBox:true,
                            usesimpledata:true,
                            initdatas:ajaxDatas_<%=i%>,
                            canDrag:false,
                            addrowCallBack:addrowcallback_<%=i%>,
                            deleterowCallBack:deletecallback<%=i %>,
                            checkBoxItem:{"itemhtml":'<input name="dt<%=i %>_fieldChecbox" class="groupselectbox" type="checkbox" value="-1">',width:"5%"}
                        };
                        groupAction_<%=i%> = new WeaverEditTable(option_<%=i%>);
                        jQuery("#DtFieldList<%=i %>").append(groupAction_<%=i%>.getContainer());
                    });
                    function deleteAction_<%=i%>(){
                        //top.Dialog.confirm("<%=SystemEnv.getHtmlLabelNames("15097",user.getLanguage())%>",function(){
                            try{
                                groupAction_<%=i%>.deleteRows();
                                //jQuery("#dt<%=i %>_deleterow").val(groupAction_<%=i%>.deleteRowIds);
                            }catch(e){

                            }
                        //});
                    }
                    function deletecallback<%=i %>($this,tr){
                        jQuery("#dt<%=i %>_deleterow").val($this.deleteRowIds);
                    }
                    function addrowcallback_<%=i%>($this,tr){
                        try{
                            jQuery("#dt<%=i %>_tablerows").val(groupAction_<%=i%>.count);
                            var addidx = jQuery("#dt<%=i %>_addrow").val();
                            jQuery("#dt<%=i %>_addrow").val(addidx+","+groupAction_<%=i%>.count);
                        }catch(e){
                        }
                        return ;
                    }
                </script>
                <input type="hidden" id="dt<%=i %>_deleterow" name="dt<%=i %>_deleterow" value="0" />
                <input type="hidden" id="dt<%=i %>_addrow" name="dt<%=i %>_addrow" value="" />
                <input type="hidden" id="dt<%=i %>_tablerows" name="dt<%=i %>_tablerows" value="<%=count %>" />
                <input type="hidden" id="dt<%=i %>_tableid" name="dt<%=i %>_tableid" value="<%=tempdttableid %>" />
                <input type="hidden" id="dt<%=i %>_tablename" name="dt<%=i %>_tablename" value="<%=detailtablename %>" />   
        </wea:item>
    </wea:group>
    <%      
        }
    %>
</wea:layout>
</form>
<script type="text/javascript">
jQuery(function(){
    jQuery("span[id^=remind]").wTooltip({html:true});
});

function clearTxtOrBlob(objvalue,idx,dt){
    var v = objvalue.value ; 
    if(v == '0'){
        if(dt==null){
            jQuery("#dbtype_"+idx).val("<%=texttype %>");
        }else{
            jQuery("#dt"+dt+"_dbtype_"+idx).val("<%=texttype %>");
        }
    }else if(v == '1'){
        if(dt==null){
            jQuery("#dbtype_"+idx).val("<%=filetype %>");
        }else{
            jQuery("#dt"+dt+"_dbtype_"+idx).val("<%=filetype %>");
        }
    }else if(v =='-1'){
        if(dt==null){
            jQuery("#dbtype_"+idx).val("");
        }else{
            jQuery("#dt"+dt+"_dbtype_"+idx).val("");
        }
    }
}

function doSubmit(){
    var checkfields = "viewid";
    var rows = jQuery("#mainTableRows").val();
    for(var i = 0 ; i<rows ; i++){
        checkfields += ",dbname_"+i+"" ;
    }
    <%
        for(int i = 0 ;i<detailtableidlist.size();i++){
    %>  
        var rows<%=i %> = jQuery("#dt<%=i %>_tablerows").val(); 
        for(var i = 0 ; i<rows<%=i %> ; i++){
            checkfields += ",dt<%=i%>_dbname_"+i+"" ;
        }   
    <%      
        }
    %>
    if(check_form($GetEle("weaver"),checkfields)){
        e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(25666,user.getLanguage())%>",true,"xTable_message");
        $GetEle("weaver").submit();
    }
}

function checkfield(obj,tablename){
    var fieldname = jQuery(obj).val();
    var ro = jQuery(obj).attr("readonly");
    if(ro||ro=='true'){
       return true ;
    }
    jQuery.ajax({
        url:'/workflow/exchange/CheckData.jsp',
        data:{changetype:'0',type:'checkdbfield',mainid:'<%=viewid %>',tablename:tablename,fieldname:fieldname,datasourceid:'<%=datasourceid%>',flag:Math.random()},
        success:function(data){
            if(data==1){
                top.Dialog.alert("["+fieldname+"] <%=SystemEnv.getHtmlLabelName(129042, user.getLanguage())%>");
                try{
                    jQuery(obj).val("");
                }catch(e){
                }
            }
            return false ;
        }
    });
}
</script>
<%
if(conn!=null){
    try{
        conn.close();
    }catch(Exception e){
        
    }
}
%>
</body>
</html>
