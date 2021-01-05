<%@ page import="weaver.general.Util"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("GP_BaseSettingMaint", user))  {
    response.sendRedirect("/notice/noright.jsp") ;
    return ;
}
String titlename = "执行力-考核结果分析共享设置";
%>
<HTML>
    <HEAD>
        <title>报表共享</title>
        <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
        <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
        <style type="text/css">
            body{
                 padding-left:12px;
                 background: #ffffff;
                 width:100%;
                 height:100%;
                 overflow:hidden;
            }
            .listtabel{
                margin-top:30px;
            }
            .listtabel td{
                padding-left:10px;
                background:#F5FAFA;
                border-bottom:2px solid #D8ECEF;
                line-height:30px;
                height:30px;
            }
            .listtabel thead td {
                color: #999999;
                border-bottom: 1px solid #59D445;
                letter-spacing: 2px;
                text-transform: uppercase;
                padding: 6px 6px 6px 12px;
            }
            .msgcls {
                position: absolute;
                width: 270px;
                line-height: 30px;
                text-align: center;
                left: 100px;
                top: 300px;
                background: #FBFDFF;
                color: #808080;
                font-size: 14px;
                font-family: '微软雅黑';
                display: none;
                border: 1px #1A8CFF solid;
                box-shadow: 0px 0px 1px #1A8CFF;
                -moz-box-shadow: 0px 0px 1px #1A8CFF;
                -webkit-box-shadow: 0px 0px 1px #1A8CFF;
                border-radius: 2px;
                -moz-border-radius: 2px;
                -webkit-border-radius: 2px;
            }
        </style>
        <%@ include file="/secondwev/common/head.jsp" %>
    </HEAD>
    <BODY>
    <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
    <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
    <%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_self} " ;
    RCMenuHeight += RCMenuHeightStep;
    %>
    <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
        <div>
            <div id="msg" class="msgcls">保存成功!</div> 
            <FORM id="weaver" name="weaver" action="ReportShareOperation.jsp" method="post">
            <input type="hidden" name="method" value="add">
            <input type="hidden" name="reportid" value="1">
            <table class="listtabel"  cellspacing="0" cellpadding="0" style="width:99%;border-collapse:collapse;">
               <colgroup>
                   <col width="20%">
                   <col width="80%">
               </colgroup>
               <tbody>
                   <tr>
                       <td>
                           <select id="sharetype" name="sharetype" onchange="onChangeSharetype()">
                               <option value="1">人力资源</option>
                               <option value="2">部门</option>
                               <option value="3">角色</option>
                               <option value="4">所有人</option>
                           </select>
                       </td>
                       <td>
                       		 <div id=showrelatedshareid name=showrelatedshareid style="display:inline-block;width:60%;">
                           	<span id="selectresource" class="selectrelate">
                           		<input class="wuiBrowser" type="hidden" id="resourceid" name="resourceid"
                                 _param="resourceids" _required="yes" _callBack="setRelatedshare"
                                _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp" />
                            </span>
                            <span id="selectdepart" class="selectrelate" style="display:none">
                            	<input class="wuiBrowser" type="hidden" id="departid" name="departid"
                                 _param="selectedids" _required="yes" _callBack="setRelatedshare"
                                _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp" />
                            </span>
                            <span id="selectrole" class="selectrelate" style="display:none">
                            	<input class="wuiBrowser" type="hidden" id="roleid" name="roleid"
                                 _param="selectedids" _required="yes" _callBack="setRelatedshare"
                                _url="/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp" />
                            </span>
                            <input type="hidden" id="relatedshareid" name="relatedshareid" value=""/>
                           </div>
                           <label style="margin-left:30px;display:none;">级别</label>
                           <select id="rolelevel" name="rolelevel" style="display:none;">
                               <option value="0">部门</option>
                               <option value="1">分部</option>
                               <option value="2">总部</option>
                           </select>
                           <label style="margin-left:30px;display:none;">安全级别:</label><input id="seclevel" name="seclevel" style="display:none;" size="3" maxlength="3" value="10">
                       </td>
                   </tr>
                   <tr>
                       <td>
                          <label>共享级别</label>
                       </td>
                       <td>
                           <select id="sharelevel" name="sharelevel" onchange="onChangeShareLevel()">
                               <option value="1">个人</option>
                               <option value="2">同部门</option>
                               <option value="3">同分部</option>
                               <option value="4">总部</option>
                               <option value="5">同部门及下级部门</option>
                               <option value="6">多部门</option>
                               <option value="7">同分部及下级分部</option>
                               <option value="8">多分部</option>
                               <option value="9">多人员</option>
                           </select>
                           
                           
                           <div id=mshareid name=mshareid style="display:inline-block;width:60%;">
                           	<span id="mselectresource" class="mselectrelate" style="display:none">
                           		<input class="wuiBrowser" type="hidden" id="mresourceid" name="mresourceid"
                                 _param="resourceids" _required="yes" _callBack="setMshare"
                                _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp" />
                            </span>
                            <span id="mselectdepart" class="mselectrelate" style="display:none">
                            	<input class="wuiBrowser" type="hidden" id="mdepartid" name="mdepartid"
                                 _param="selectedids" _required="yes" _callBack="setMshare"
                                _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp" />
                            </span>
                            <span id="mselectsub" class="mselectrelate" style="display:none">
                            	<input class="wuiBrowser" type="hidden" id="msubid" name="msubid"
                                 _param="selectedids" _required="yes" _callBack="setMshare"
                                _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubcompanyBrowser.jsp" />
                            </span>
                            <input type="hidden" id="mutiids" name="mutiids" value=""/>
                           </div>
                       </td>
                   </tr>
               </tbody>
            </table>
            </FORM>
        </div>
        <div>
            <table class="listtabel"  cellspacing="0" cellpadding="0" style="width:99%;border-collapse:collapse;">
                 <colgroup>
                   <col style="width:20%">
                   <col style="width:30%">
                   <col style="width:40%">
                   <col style="width:10%">
               </colgroup>
               <thead>
                   <tr>
                       <td>共享类型</td>
                       <td>共享明细</td>
                       <td>共享级别</td>
                       <td>操作</td>
                   </tr>
               </thead>
               <tbody>
                   <%
                   String method = Util.null2String(request.getParameter("method"));
                   rs.execute("SELECT * FROM WR_ReportShare WHERE reportid=1 order by id");
                   
                   while(rs.next()){
                       String sharetype = Util.null2String(rs.getString("sharetype")); 
                       String sharetypename = getShareTypeName(rs);
                       String showTypeContent = getShowTypeContent(rs,sharetype);
                       String showLevelContent = getShowLevelContent(rs);
                   %> 
                   <tr>
                       <td><%=sharetypename %></td>
                       <td><%=showTypeContent %></td>
                       <td><%=showLevelContent %></td>
                       <td><a href="javascript:doDelete('<%=rs.getString("id")%>')">删除</a> </td>
                   </tr>
                 <% 
                   }
                   %>
               </tbody>
            </table>
        </div>
    </BODY>
    <script type="text/javascript">
        /**
         * 查询组织结构
         */
        function doSave(){
            var sharetype = $("#sharetype").val();
            if(sharetype==1 || sharetype==2 || sharetype==3){
                if($("#relatedshareid").val()==""){
                    $("#msg").html("请完成必填项!");
                    showMsg();
                    return true;
                }
            }
            var sharelevel = $("#sharelevel").val();
            if(sharelevel==6 || sharelevel==8 || sharelevel==9){
                if($("#mutiids").val()==""){
                    $("#msg").html("请完成必填项!");
                    showMsg();
                    return true;
                }
            }
            $("#weaver").submit();
        }
        function doDelete(shareid){
        	if(confirm("确定删除此共享？")){
        		window.location = "ReportShareOperation.jsp?method=delete&id="+shareid+"&reportid=1";	
        	}
        }
        /**
         * 查询组织结构
         */
        function onChangeSharetype(){
            var sharetype = $("#sharetype").val();
            //showBtn("relatedshareid");
            hideSelect("rolelevel");
            showSelect("seclevel");
            jQuery(".selectrelate").hide();
            if(sharetype==1){
                hideSelect("seclevel");
                jQuery("#selectresource").show();
                //$("#relatedshareid").attr("_url","/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp");
                //$("#relatedshareidSpan").html('<img align="absMiddle" src="/images/BacoError_wev8.gif">');
            }else if(sharetype==2){
                jQuery("#selectdepart").show();
                //$("#relatedshareid").attr("_url","/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp");
                //$("#relatedshareidSpan").html('<img align="absMiddle" src="/images/BacoError_wev8.gif">');
            }else if(sharetype==3){
                showSelect("rolelevel");
                jQuery("#selectrole").show();
                //$("#relatedshareid").attr("_url","/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp");
                //$("#relatedshareidSpan").html('<img align="absMiddle" src="/images/BacoError_wev8.gif">');
            }else if(sharetype==4){
                //hideBtn("relatedshareid");
                $("#relatedshareid").attr("_url","");
            }
        }
        function setRelatedshare(event,datas){
        	var sharetype = $("#sharetype").val();
        	if(sharetype==1){
              jQuery("#relatedshareid").val(jQuery("#resourceid").val()); 	
          }else if(sharetype==2){
          		jQuery("#relatedshareid").val(jQuery("#departid").val()); 
          }else if(sharetype==3){
              jQuery("#relatedshareid").val(jQuery("#roleid").val()); 
          }else if(sharetype==4){
              jQuery("#relatedshareid").val("");
          }
        }
        
        /**
         * 查询组织结构
         */
        function onChangeShareLevel(){
            var sharelevel = $("#sharelevel").val();
            //hideBtn("mutiids");
            jQuery(".mselectrelate").hide();
            if(sharelevel==6){
            	jQuery("#mselectdepart").show();
               // showBtn("mutiids");
               // $("#mutiids").attr("_url","/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp");
               // $("#mutiidsSpan").html('<img align="absMiddle" src="/images/BacoError_wev8.gif">');
            }else if(sharelevel==8){
            	jQuery("#mselectsub").show();
                //showBtn("mutiids");
               // $("#mutiids").attr("_url","/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubcompanyBrowser.jsp");
               // $("#mutiidsSpan").html('<img align="absMiddle" src="/images/BacoError_wev8.gif">');
            }else if(sharelevel==9){
            	jQuery("#mselectresource").show();
               // showBtn("mutiids");
               // $("#mutiids").attr("_url","/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp");
               // $("#mutiidsSpan").html('<img align="absMiddle" src="/images/BacoError_wev8.gif">');
            }
        }
        function setMshare(event,datas){
        	var sharelevel = $("#sharelevel").val();
        	if(sharelevel==6){              
              jQuery("#mutiids").val(jQuery("#mdepartid").val()); 	
          }else if(sharelevel==8){
          		jQuery("#mutiids").val(jQuery("#msubid").val()); 
          }else if(sharelevel==9){
              jQuery("#mutiids").val(jQuery("#mresourceid").val()); 
          }
        }
        
        /**
         * 展示浏览图标
         */
        function showBtn(id){
            $("#"+id).val("");
            $("#"+id+"Btn").show();
            $("#"+id+"Span").show();
            $("#"+id+"Span").html("");
        }
        /**
         * 展示浏览图标
         */
        function hideBtn(id){
            $("#"+id+"Btn").hide();
            $("#"+id+"Span").hide();
        }
        function showMsg(){
            var _left = Math.round(($(window).width()-$("#msg").width())/2);
            $("#msg").css({"left":_left,"top":300}).show().animate({top:250},500,null,function(){
                $(this).fadeOut(800);
            });
        }
        $().ready(function(){
            hideBtn("mutiids");
            if("add" == "<%=method%>"){
                showMsg();
            }else if("delete" == "<%=method%>"){
                $("#msg").html("删除成功!");
                showMsg();
            }
        });
        /**
         * 展示下拉选择框和前面的label
         */
        function showSelect(id){
            $("#"+id).show();
            $("#"+id).prev("label").show();
        }
        /**
         * 展示下拉选择框和前面的label
         */
        function hideSelect(id){
            $("#"+id).hide();
            $("#"+id).prev("label").hide();
        }
    </script>
    <%!
    /**
     * 得到共享类型名称
     */
    private String getShareTypeName(weaver.conn.RecordSet rs){
        String sharetype = Util.null2String(rs.getString("sharetype")); 
        String sharetypename = null;
        if("1".equals(sharetype)){
            sharetypename="人力资源";
        }else if("2".equals(sharetype)){
            sharetypename="部门";
        }else if("3".equals(sharetype)){
            sharetypename="角色";
        }else if("4".equals(sharetype)){
            sharetypename="所有人";
        }
        return sharetypename;
    }
    /**
     * 得到共享类型内容
     */
    private String getShowTypeContent(weaver.conn.RecordSet rs,String sharetype)throws Exception{
        String seclevel = Util.null2String(rs.getString("seclevel"));
        String userid = null;
        String deptid = null;
        String roleid = null;
        int rolelevel = 0;
        String showTypeContent = "";
        if("1".equals(sharetype)){
            userid = Util.null2String(rs.getString("userid"));
            String[] useridArr = userid.split(",");
            weaver.hrm.resource.ResourceComInfo ResourceComInfo = new weaver.hrm.resource.ResourceComInfo();
            for(int i=0;i<useridArr.length;i++){
                if(i==0){
                    showTypeContent+=ResourceComInfo.getResourcename(useridArr[i]);
                }else{
                    showTypeContent+=","+ResourceComInfo.getResourcename(useridArr[i]);
                }
            }
        }else if("2".equals(sharetype)){
            deptid = Util.null2String(rs.getString("deptid")); 
            String[] deptArr = deptid.split(",");
            weaver.hrm.company.DepartmentComInfo DepartmentComInfo = new weaver.hrm.company.DepartmentComInfo();
            for(int i=0;i<deptArr.length;i++){
                if(i==0){
                    showTypeContent+=DepartmentComInfo.getDepartmentname(deptArr[i]);
                }else{
                    showTypeContent+=","+DepartmentComInfo.getDepartmentname(deptArr[i]);
                }
            }
            showTypeContent += "/安全级别:"+seclevel;
        }else if("3".equals(sharetype)){
            roleid = Util.null2String(rs.getString("roleid"));
            rolelevel = Util.getIntValue(rs.getString("rolelevel"));
            weaver.conn.RecordSet rstemp = new weaver.conn.RecordSet();
            rstemp.executeSql("select rolesmark from hrmroles where id = "+roleid);
            while(rstemp.next()){
                showTypeContent = Util.null2String(rstemp.getString("rolesmark"));
            }
            if(1==rolelevel){
                showTypeContent+="(部门)";
            }else if(2==rolelevel){
                showTypeContent+="(分部)";
            }else if(2==rolelevel){
                showTypeContent+="(总部)";
            }
            showTypeContent += "/安全级别:"+seclevel;
        }else if("4".equals(sharetype)){
            showTypeContent += "安全级别:"+seclevel;
        }
        return showTypeContent;
    }
    /**
     * 得到共享级别内容
     */
    private String getShowLevelContent(weaver.conn.RecordSet rs)throws Exception{
        String sharelevel = Util.null2String(rs.getString("sharelevel"));
        String showLevelContent = "";
        if("1".equals(sharelevel)){
            showLevelContent = "个人";
        }else if("2".equals(sharelevel)){
            showLevelContent = "同部门";
        }else if("3".equals(sharelevel)){
            showLevelContent = "同分部";
        }else if("4".equals(sharelevel)){
            showLevelContent = "总部";
        }else if("5".equals(sharelevel)){
            showLevelContent = "同部门及下级部门";
        }else if("6".equals(sharelevel)){
            showLevelContent = "多部门";
            String deptid = Util.null2String(rs.getString("mutideptid")); 
            String[] deptArr = deptid.split(",");
            weaver.hrm.company.DepartmentComInfo DepartmentComInfo = new weaver.hrm.company.DepartmentComInfo();
            String deptNames = "";
            for(int i=0;i<deptArr.length;i++){
                if(i==0){
                    deptNames+=DepartmentComInfo.getDepartmentname(deptArr[i]);
                }else{
                    deptNames+=","+DepartmentComInfo.getDepartmentname(deptArr[i]);
                }
            }
            showLevelContent += "("+deptNames+")";
        }else if("7".equals(sharelevel)){
            showLevelContent = "同分部及下级分部";
        }else if("8".equals(sharelevel)){
            showLevelContent = "多分部";
            String cpyid = Util.null2String(rs.getString("muticpyid"));
            String[] cpyArr = cpyid.split(",");
            weaver.docs.category.SubCategoryComInfo SubCategoryComInfo = new weaver.docs.category.SubCategoryComInfo();
            String cpyNames = "";
            for(int i=0;i<cpyArr.length;i++){
                if(i==0){
                    cpyNames+=SubCategoryComInfo.getSubCategoryname(cpyArr[i]);
                }else{
                    cpyNames+=","+SubCategoryComInfo.getSubCategoryname(cpyArr[i]);
                }
            }
            showLevelContent+="("+cpyNames+")";
        }else if("9".equals(sharelevel)){
            showLevelContent = "多人员";
            String userid = Util.null2String(rs.getString("mutiuserid"));
            String[] useridArr = userid.split(",");
            weaver.hrm.resource.ResourceComInfo ResourceComInfo = new weaver.hrm.resource.ResourceComInfo();
            String userNames = "";
            for(int i=0;i<useridArr.length;i++){
                if(i==0){
                    userNames+=ResourceComInfo.getResourcename(useridArr[i]);
                }else{
                    userNames+=","+ResourceComInfo.getResourcename(useridArr[i]);
                }
            }
            showLevelContent+="("+userNames+")";
        }
        return showLevelContent;
    }
    %>
</HTML>