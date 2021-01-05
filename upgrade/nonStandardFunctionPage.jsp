

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.page.element.ElementBaseCominfo"%>
<%@ page import="weaver.conn.RecordSet" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="scc" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<jsp:useBean id="fu" class="com.weaver.upgrade.FunctionUpgrade" scope="page" />
<jsp:useBean id="basebean" class="weaver.general.BaseBean" scope="page" />

<%@ page language="java" import="weaver.file.Prop" %>
<%
    String imagefilename = "/images/hdMaintenance_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(23142,user.getLanguage());
    String needfav ="1";
    String needhelp ="";
    //进页面扫描非标文件
    fu.doUpgrade();
    //判断是否开启了IP集群化控制，1启用，0未启用
    if("1".equals(Prop.getPropValue("ClusterIpController", "flag"))){
        // 获取服务器的本机ip地址。去hp_server_info里查询，是否已经有对应的ip纪录（防止ip变更引起异常）,若无，则重新对对非标进行扫描更新操作
        String hostaddr="";
        try{
            InetAddress ia =InetAddress.getLocalHost();
            //获取本机的ip地址
            hostaddr= ia.getHostAddress();
        }catch (UnknownHostException e){
            //如果获取不到本机IP则默认ip地址为127.0.0.1
            hostaddr="127.0.0.1";
        }
        rs.executeQuery("select id from hp_server_info where serverIP=? order by id",hostaddr);
        if(!rs.next()){
            fu.doUpgrade();
            basebean.writeLog("若当前服务器IP没有备案，重新扫描更新非标补丁包信息++++++++++++++++++++++++");
        }
    }

//add by wshen
    String isshowelemflag = Util.null2String(request.getParameter("isshowelemflag"));;//0表示不显示特定的列表，1表示显示特定的列表
    String elemids = Util.null2String(request.getParameter("elemids"));//存放需要显示的元素id，用,分隔
    String url="";
    String navName="";
    HashMap kv = (HashMap)pack.packageParams(request, HashMap.class);
    String _fromURL = Util.null2String((String)kv.get("_fromURL"));
    String loginview = Util.null2String((String)kv.get("loginview"));
    String isCustom=Util.null2String((String)kv.get("isCustom"));
    String type = Util.null2String((String)kv.get("type"));// top left
    String openDialog=Util.null2String((String)kv.get("openDialog"));
    if(1!=user.getUID()){
        response.sendRedirect("/upgrade/noright.jsp");
        return;
    }
    if("nonStandardFuncManage".equals(_fromURL)){//非标功能包
        url = "/upgrade/nonStandardFunctionList.jsp";
    }

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
    <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>

    <script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
    <link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
    <link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
    <script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

    <link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
    <link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
    <script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
    <script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
</head>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<div class="e8_box demo2">
    <div class="e8_boxhead">
        <div class="div_e8_xtree" id="div_e8_xtree"></div>
        <div class="e8_tablogo" id="e8_tablogo"></div>
        <div class="e8_ultab">
            <div class="e8_navtab" id="e8_navtab">
                <span id="objName"></span>
            </div>
            <div>

                <ul class="tab_menu">
                    <% if("nonStandardFuncManage".equals(_fromURL)){//非标补丁包管理 %>
                    <%navName=SystemEnv.getHtmlLabelName(131290,user.getLanguage()); %>
                    <li class="current">
                        <a href="<%=url %>?templatetype=0" target="tabcontentframe">
                            <%=SystemEnv.getHtmlLabelName(32626,user.getLanguage()) %>
                        </a>
                    </li>
                    <li>
                        <a href="<%=url %>?templatetype=1" target="tabcontentframe">
                            <%=SystemEnv.getHtmlLabelName(32386,user.getLanguage()) %>
                        </a>
                    </li>
                    <%}%>
                </ul>
                <div id="rightBox" class="e8_rightBox"></div>
            </div>
        </div>
    </div>

    <div class="tab_box">
        <div>
            <iframe src="<%=url %>" onload="update();" id="tabcontentframe" name="tabcontentframe" frameborder="0" height="100%" width="100%;"></iframe>
        </div>
    </div>
</div>
</body>
</html>

<script language="javascript">

    <%
     //检查表hp_nonstandard_function_info是否存在，来判断脚本是否执行
    if("sqlserver".equals(rs.getDBType())){
        rs.execute("SELECT id FROM sysobjects WHERE name='hp_nonstandard_function_info'");
        if(!rs.next()){
%>
    alert("非标信息表hp_nonstandard_function_info不存在，请检查非标补丁包里脚本是否全部执行成功！");
    <% }
      }else if("oracle".equals(rs.getDBType())){
          rs.execute(" SELECT table_name FROM user_tables where table_name = 'HP_NONSTANDARD_FUNCTION_INFO'");
          if(!rs.next()){ %>
    alert("非标信息表hp_nonstandard_function_info不存在，请检查非标补丁包里脚本是否全部执行成功！");
    <%
            }
        }%>

    jQuery(function(){
        jQuery('.e8_box').Tabs({
            getLine:1,
            iframe:"tabcontentframe",
            staticOnLoad:true,
            mouldID:"<%= MouldIDConst.getID("portal")%>",
            objName:"<%=navName%>"
        });

    });

    function refreshTab(){
        var f = window.parent.oTd1.style.display;
        if (f != null) {
            if(f==''){
                window.parent.oTd1.style.display='none';
            }else{
                window.parent.oTd1.style.display='';
                window.parent.wfleftFrame.setHeight();
            }
        }
    }
</script>