
<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ include file="/systeminfo/init_wev8.jsp"%>

<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.conn.RecordSet"%>
<%@ page import="java.sql.Timestamp" %>

<jsp:useBean id="ResourceComInfo"
    class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<HTML>
    <HEAD>

        <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
        <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
        <script language="javascript"
            src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
    </head>
    <%
	    if (!HrmUserVarify.checkUserRight("eAssistant:crm", user)) {
	        response.sendRedirect("/notice/noright.jsp");
	        return;
	    }
        // 高级搜索框中的客户名称
        String CrmName = Util.fromScreen(request.getParameter("CrmName"),
                user.getLanguage());
        // 高级搜索框中的标签
        String label = Util.fromScreen(request.getParameter("label"), user
                .getLanguage());
        // 高级搜索中框的客户经理
        String managerId = Util.null2String(request.getParameter("managerId"));
        // 操作的标识FLG
        String crmOperType = Util.null2String(request.getParameter("crmOperType"));
        // 编辑页面修改过后的标签
        String changeLabel = Util.null2String(request.getParameter("changeLabel"));
        changeLabel = Util.convertInput2DB(changeLabel);
        // 编辑页面:编辑过的客户ID
        String sourceId = Util.null2String(request.getParameter("sourceId"));
        //本页面要删除的客户ID
        String crmLibIDs = Util.null2String(request.getParameter("crmLibIDs"));
        // 正常搜索框中搜索条件
        String c_name = Util.null2String(request.getParameter("c_name"));
        String searchCrm = Util.null2String(request.getParameter("searchCrm"));
        c_name = searchCrm;
        if(!"".equals(CrmName) && "".equals(c_name)){
        	c_name = CrmName;
        }
        //获得当前的日期和时间
        Date newdate = new Date() ;
        long datetime = newdate.getTime() ;
        Timestamp timestamp = new Timestamp(datetime) ;
        String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
        String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);
        
        // 批量删除时,取sourceID以便对表indexupdatelog进行一条一条插入
        String[] sourceIDForDelArr = crmLibIDs.split(","); 
        
        RecordSet rs = new RecordSet();
        RecordSet rsUpdLog = new RecordSet();
        if("edit".equals(Util.null2String(crmOperType))){
            // 对单一文档标签进行更新
            String ChangeSql = "update FullSearch_CusLabel set label = '"+changeLabel+"' , updateTime = CURRENT_TIMESTAMP where type = 'CRM' and sourceId = "+sourceId;
            
             // FullSearch_CusLabel更新成功后,对表indexupdatelog进行插入操作
            if(rs.executeSql(ChangeSql)){
                String updLogSql = "insert into  indexupdatelog (DOCID,CTYPE,MODTYPE,CREATETIME,DOCCREATEDATE,DONEFLAG) values ("+sourceId+",'CRM','UPDATE','"+ CurrentDate+" "+ CurrentTime +"','"+CurrentDate+"',0) ";
                rsUpdLog.executeSql(updLogSql);
            }
            
        }else if("del".equals(Util.null2String(crmOperType))){
            // 对单一或者批量标签进行删除
            String delSql = "delete from FullSearch_CusLabel where type = 'CRM' and SOURCEID in(" + crmLibIDs+")";
            
            // FullSearch_CusLabel删除成功后,对表indexupdatelog进行插入操作
            if(rs.executeSql(delSql)){
            	String updLogSql = "";
                for(int i = 0; i<sourceIDForDelArr.length; i++){
                    updLogSql = "insert into  indexupdatelog (DOCID,CTYPE,MODTYPE,CREATETIME,DOCCREATEDATE,DONEFLAG) values ("+sourceIDForDelArr[i]+",'CRM','UPDATE','"+ CurrentDate+" "+ CurrentTime +"','"+CurrentDate+"',0) ";
                    rsUpdLog.executeSql(updLogSql);
                }
            }
            
        }else if ("add".equals(Util.null2String(crmOperType))){
            // 所有ID集合
            List listIdAll = new ArrayList();
            List listExitId = new ArrayList();
            String[] idStr = sourceId.split(",");
            for(int i = 0; i < idStr.length; i++){
                listIdAll.add(idStr[i]);          
            }
            // 查询要添加标签的客户是否已存在标签,存在的话对该客户标签进行更新操作
            String exitIdSql = "select t1.sourceid exitId from FullSearch_CusLabel t1, crm_customerinfo t2 where t1.type='CRM' and t1.sourceid = t2.id and t1.sourceid in ("+sourceId+")";
            rs.executeSql(exitIdSql);
            while(rs.next()){
                String exitId = rs.getString("exitId");
                listExitId.add(exitId);
                String updateExitIdSql = "";
                if(rs.getDBType().equals("oracle")){
                    updateExitIdSql = "update FullSearch_CusLabel set label = (select label from FullSearch_CusLabel where sourceid = '" + exitId + "' and type='CRM' )|| ' ' || '"
                        + changeLabel
                        + "', updateTime = sysdate where sourceid = '" + exitId + "' and type='CRM' ";
                }else{
                    updateExitIdSql = "update FullSearch_CusLabel set label = label+ ' ' + '"+changeLabel+"', updateTime = CURRENT_TIMESTAMP where sourceid = '"+exitId+"' and type='CRM'";
                }
                RecordSet rs1 = new RecordSet(); 
                
                // FullSearch_CusLabel更新成功后,对表indexupdatelog进行插入操作
                if(rs1.execute(updateExitIdSql)){
                    String updLogSql = "insert into  indexupdatelog (DOCID,CTYPE,MODTYPE,CREATETIME,DOCCREATEDATE,DONEFLAG) values ("+exitId+",'CRM','UPDATE','"+ CurrentDate+" "+ CurrentTime +"','"+CurrentDate+"',0) ";
                    rsUpdLog.executeSql(updLogSql);
                }
            }
            // 查询要添加标签的文档是否已存在标签,不存在的话对该文档标签进行插入操作
            for(int j = 0; j < listExitId.size(); j++){
                if(listIdAll.contains(listExitId.get(j))){
                    listIdAll.remove(listExitId.get(j));
                }
            }
            for(int j = 0; j < listIdAll.size(); j++){
                
                String notExitIdSql = "insert into FullSearch_CusLabel (type,sourceid,label,updateTime) values ('CRM','"+listIdAll.get(j)+"','"+changeLabel+"',CURRENT_TIMESTAMP)";
                RecordSet rs2 = new RecordSet(); 
                
                // FullSearch_CusLabel插入成功后,对表indexupdatelog进行插入操作
                if(rs2.execute(notExitIdSql)){
                    String updLogSql = "insert into  indexupdatelog (DOCID,CTYPE,MODTYPE,CREATETIME,DOCCREATEDATE,DONEFLAG) values ("+listIdAll.get(j)+",'CRM','UPDATE','"+ CurrentDate+" "+ CurrentTime +"','"+CurrentDate+"',0) ";
                    rsUpdLog.executeSql(updLogSql);
                }
            }
            
            
        }
        
        StringBuffer sqlwhere = new StringBuffer(" where t1.type='CRM'");

        if (!"".equals(CrmName)) {
            sqlwhere.append(" and t2.name like '%" + CrmName + "%'");
        }
        if (!"".equals(c_name)) {
            sqlwhere.append(" and t2.name like '%" + CrmName + "%'");
        }
        
        if (!"".equals(label)) {
            String[] labelArr = label.split(" ");
            if(labelArr.length > 0){
                for (int i = 0; i < labelArr.length; i++) {
                    sqlwhere.append(" and t1.label like '%" + labelArr[i]
                            + "%'");
                }   
            }else {
                sqlwhere.append(" and t1.label like '%" + label + "%'");
            }
            
        }
        
        if (!"".equals(managerId)) {
            sqlwhere.append(" and t2.manager like '%" + managerId + "%'");
        }

        String sqlOrderBy = "t1.updateTime";

        String imagefilename = "/images/hdReport_wev8.gif";
        String titlename =SystemEnv.getHtmlLabelName(128696,user.getLanguage());
        String needfav = "1";
        String needhelp = "";
    %>
    <BODY>

        <%@ include file="/systeminfo/TopTitle_wev8.jsp"%>
        <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp"%>
        <%
            RCMenu += "{"
                    + SystemEnv.getHtmlLabelName(83476, user.getLanguage())
                    + ",javascript:doCrmLibAdd(),_self} ";
            RCMenu += "{"
                    + SystemEnv.getHtmlLabelName(32136, user.getLanguage())
                    + ",javascript:delCrm(),_self} ";
            RCMenuHeight += RCMenuHeightStep;
        %>
        <%@ include file="/systeminfo/RightClickMenu_wev8.jsp"%>
        <form id="weaverA" name="weaverA" method="post"
                action="ViewCrmLib.jsp">
        <table id="topTitle" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                </td>
                <td class="rightSearchSpan" style="text-align: right;">
                    <input type="button"
                        value="<%=SystemEnv.getHtmlLabelName(83476, user.getLanguage())%>"
                        class="e8_btn_top middle" onclick="doCrmLibAdd()" />
                    <input type="button"
                        value="<%=SystemEnv.getHtmlLabelName(32136, user.getLanguage())%>"
                        class="e8_btn_top middle" onclick="delCrm()" />
                    <input type="text" class="searchInput" id="c_name" name="c_name" value="<%=c_name %>"/>
                    <span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995, user.getLanguage())%></span>
                    <span
                        title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>"
                        class="cornerMenu middle"></span>
                </td>
            </tr>
        </table>
        <div class="advancedSearchDiv" id="advancedSearchDiv">
            
                <input type="hidden" name="crmOperType" id="crmOperType">
                <input type="hidden" name="crmLibIDs">
                <input type="hidden" id="searchCrm" name="searchCrm" value="">
                <wea:layout type="4col">
                    <wea:group
                        context='<%=SystemEnv.getHtmlLabelName(20331, user
                                    .getLanguage())%>'>
                        <wea:item><%=SystemEnv.getHtmlLabelName(1268, user
                                        .getLanguage())%></wea:item>
                        <wea:item>
                            <input type="text" id="CrmName" name="CrmName"
                                value="<%=CrmName%>" class="InputStyle" onchange="setKeyword('CrmName','searchCrm')">
                        </wea:item>

                        <wea:item><%=SystemEnv.getHtmlLabelName(176, user
                                        .getLanguage())%></wea:item>
                        <wea:item>
                            <input type="text" id="label" name="label" value="<%=label%>"
                                class="InputStyle">
                            </span>
                        </wea:item>
                        <wea:item><%=SystemEnv.getHtmlLabelName(1278, user
                                        .getLanguage())%></wea:item>
                        <wea:item>
                            <span id="doccreateridselspan"> <brow:browser viewType="0"
                                    name="managerId" browserValue='<%=managerId%>' browserOnClick=""
                                    browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?resourceids="
                                    hasInput="true" isSingle="true" hasBrowser="true"
                                    isMustInput='1' width="150px" completeUrl="/data.jsp"
                                    linkUrl="javascript:openhrm($managerId$)"
                                    browserSpanValue='<%=ResourceComInfo.getLastname(managerId)%>'></brow:browser>
                            </span>
                        </wea:item>
                    </wea:group>
                    <wea:group context="">
                        <wea:item type="toolbar">
                            <input type="button" onclick="doSubmit();" class="e8_btn_submit"
                                value="<%=SystemEnv.getHtmlLabelName(197, user
                                        .getLanguage())%>" />
                            <input type="button"
                                value="<%=SystemEnv.getHtmlLabelName(2022, user
                                        .getLanguage())%>"
                                class="e8_btn_cancel" onclick="resetCondtion();jQuery('#c_name').val('');jQuery('#c_name',parent.document).val('')" />
                            <input type="button"
                                value="<%=SystemEnv.getHtmlLabelName(201, user
                                        .getLanguage())%>"
                                class="e8_btn_cancel" id="cancel" />
                        </wea:item>
                    </wea:group>
                </wea:layout>
            </form>
        </div>
        <%
            String tableString = "";
            int perpage = 10;
            String backfields = " t1.id, t1.updateTime, t1.label, t1.sourceid, t2.name, t2.manager";
            String fromSql = " FullSearch_CusLabel t1 left join crm_customerinfo t2 on t1.sourceid = t2.id ";
            tableString = " <table instanceid=\"\" tabletype=\"checkbox\" pagesize=\""
                    + PageIdConst.getPageSize(PageIdConst.CRM_ViewMessage, user
                            .getUID())
                    + "\" >"
                    + " <checkboxpopedom  id=\"checkbox\" popedompara=\"column:sourceid\" showmethod=\"weaver.fullsearch.EAssistantViewMethod.getCheckbox\"  />"
                    + "       <sql backfields=\""
                    + backfields
                    + "\" sqlform=\""
                    + fromSql
                    + "\"  sqlwhere=\""
                    + Util.toHtmlForSplitPage(sqlwhere.toString())
                    + "\"  sqlorderby=\""
                    + sqlOrderBy
                    + "\" sqlprimarykey=\"sourceid\" sqlsortway=\"DESC\" />" 
                    
                    + "       <head>"
                    
                    + "           <col width=\"40%\"  text=\""
                    + SystemEnv.getHtmlLabelName(1268, user.getLanguage())
                    + "\" column=\"name\" orderkey=\"name\" otherpara=\"column:sourceid\" transmethod=\"weaver.fullsearch.EAssistantViewMethod.changeLabelInfo\"  />"
                    
                    + "           <col width=\"40%\"  text=\""
                    + SystemEnv.getHtmlLabelName(176, user.getLanguage())
                    + "\" column=\"label\" orderkey=\"label\" />"
                    
                    + "           <col width=\"30%\"  text=\""
                    + SystemEnv.getHtmlLabelName(1278, user.getLanguage())
                    + "\" column=\"manager\" orderkey=\"manager\"  transmethod=\"weaver.fullsearch.EAssistantViewMethod.getMangerResource\" />"
                    
                    + "</head>";
                    
            tableString += "<operates>"
                    + "     <popedom column=\"sourceid\" transmethod=\"weaver.fullsearch.EAssistantViewMethod.getLabelId\"></popedom> "
                    + "     <operate href=\"javascript:changeLabel();\" text=\"" + SystemEnv.getHtmlLabelName(31231, user.getLanguage()) + "\" target=\"_self\" index=\"1\"/>"
                    + "     <operate href=\"javascript:delCrm();\" text=\"" + SystemEnv.getHtmlLabelName(91, user.getLanguage()) + "\" target=\"_self\" index=\"2\"/>" 
                    + "</operates>";
            tableString += "</table>";
        %>
        <input type="hidden" name="pageId" id="pageId"
            value="<%=PageIdConst.CRM_ViewMessage%>" />
        <wea:SplitPageTag tableString='<%=tableString%>' mode="info" />
    </body>
    <script language="javascript">
var dialog;
function changeLabel(sourceid){
    dialog = new window.top.Dialog();
    dialog.currentWindow = window;
    var url = "/fullsearch/EditCrmLibrary.jsp?crmOperType=edit&sourceid="+sourceid;
    dialog.Title = "<%=SystemEnv.getHtmlLabelName(31231, user.getLanguage())%>";
    dialog.Width = 600;
    dialog.Height = 400;
    dialog.Drag = true;
    dialog.URL = url;
    dialog.show();
}

function doCrmLibAdd(){
    __browserNamespace__.showModalDialogForBrowser(event,'/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids=','/CRM/data/ViewCustomer.jsp?isrequest=1&CustomerID=','crmmembers',false,1,'',{name:'crmmembers',hasInput:true,zDialog:true,needHidden:true,dialogTitle:'',_callback:showEditCrmLib});
    ////__browserNamespace__.showModalDialogForBrowser(event,'/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?documentids=','/docs/docs/DocDsp.jsp?isrequest=1&id=','docs',false,1,'',{name:'docs',hasInput:true,zDialog:true,needHidden:true,dialogTitle:'',_callback:showEditCrmLib});
}

function showEditCrmLib(event,datas,name,ismand){
    if("" == datas.id){
        return "";
    }
    jQuery("input[name=crmOperType]").val("add");
    dialog = new window.top.Dialog();
    dialog.currentWindow = window;
    var url = "/fullsearch/EditCrmLibrary.jsp?crmOperType=add&sourceid="+datas.id;
    dialog.Title = '<%=SystemEnv.getHtmlLabelNames("83476,84236", user.getLanguage())%>';
    dialog.Width = 600;
    dialog.Height = 400;
    dialog.Drag = true;
    dialog.URL = url;
    dialog.show();
}

function delCrm(id){
    var ids = "";
    if(id==null ||id=="" || id == "NULL" || id == "Null" || id == "null"){
    $("input[name='chkInTableTag']").each(function(){
        if($(this).attr("checked"))
            ids = ids +$(this).attr("checkboxId")+",";
    });
    }else {
        ids = id;
    }
    if(ids.match(/,$/)){
        ids = ids.substring(0,ids.length-1);
    }
    if(ids==""){
        window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15543, user.getLanguage())%>");
        return;
    }else{
        window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097, user.getLanguage())%>",function(){
            
            jQuery("input[name=crmOperType]").val("del");
            jQuery("input[name=crmLibIDs]").val(ids);
            document.forms[0].submit();
        });
    }
}

function doSubmit()
{
    document.forms[0].submit();
}
function resetCondtion(){
    resetCondtionBrw("advancedSearchDiv");
}
</script>
    <SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
    <SCRIPT language="javascript" defer="defer"
        src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>


<script language="javascript">

function preDo(){
    $("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
}

function onBtnSearchClick(){
    var name=$("input[name='c_name']",parent.document).val();
    $("#CrmName").val(name);
    $("#searchCrm").val(name);
    doSubmit();
}

function doSearchsubmit(){
    $('#weaverA').submit();
}

function closeDialog(){
    _table. reLoad();
    dialog.close();
}

function setKeyword(source,target){
    var targetVal =document.getElementById(source).value; 
    document.getElementById(target).value=targetVal;
}

</script>
