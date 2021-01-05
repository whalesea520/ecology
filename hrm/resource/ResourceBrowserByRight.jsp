
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="org.json.JSONObject"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
		String fromHrmStatusChange = Util.null2String(request.getParameter("fromHrmStatusChange"));
    String sqlwhere = "";
    int uid = user.getUID();
    String tabid = "0";
    int fieldid=Util.getIntValue(request.getParameter("fieldid"));
    int isdetail=Util.getIntValue(request.getParameter("isdetail"));
    String rightStr= Util.null2String(request.getParameter("rightStr"));
    int isbill=Util.getIntValue(request.getParameter("isbill"),1);
    boolean onlyselfdept=CheckSubCompanyRight.getDecentralizationAttr(uid,rightStr,fieldid,isdetail,isbill);
    boolean isall=CheckSubCompanyRight.getIsall();
    String departments=CheckSubCompanyRight.getDepartmentids();
    String subcompanyids=CheckSubCompanyRight.getSubcompanyids();
    if(!isall){
        if(onlyselfdept){
            sqlwhere=" where departmentid in("+departments+")";
        }else{
            sqlwhere=" where subcompanyid1 in("+subcompanyids+")";
        }
    }
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
</HEAD>
<body>
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
		    		<li class="<%=tabid.equals("0") ?"current":"" %>">
			        	<a id="tabId0" href="javascript:resetbanner(0);">
			        		<%=SystemEnv.getHtmlLabelName(18770,user.getLanguage())%><!-- 按组织结构 --> 
			        	</a>
			      </li>
			      <li class="<%=tabid.equals("1") ?"current":"" %>">
			        	<a id="tabId1" href="javascript:resetbanner(1);">
			        		<%=SystemEnv.getHtmlLabelName(18771,user.getLanguage())%><!-- 按定义的组 --> 
			        	</a>
			      </li>
		    		<li class="<%=tabid.equals("2") ?"current":"" %>">
			        	<a id="tabId2" href="javascript:resetbanner(2);">
			        		<%=SystemEnv.getHtmlLabelName(18412,user.getLanguage())%><!-- 组合查询 --> 
			        	</a>
			      </li>
			    </ul>
			    <div id="rightBox" class="e8_rightBox">
			    </div>
			</div>
		</div>
	</div>
	    <div class="tab_box">
        <div>
        	<IFRAME name=frame1 id=frame1   width=100%  onload="update();" height=160px frameborder=no scrolling=no>
					<%=SystemEnv.getHtmlLabelName(15017, user.getLanguage())%>
					</IFRAME>
					<IFRAME name=frame2 id=frame2 src="/hrm/resource/SelectByDec.jsp?tabid=<%=tabid%>&sqlwhere=<%=xssUtil.put(sqlwhere)%>" class="flowFrame" width=100%  frameborder="0" height="375px" frameborder=no scrolling=no>
					<%=SystemEnv.getHtmlLabelName(15017, user.getLanguage())%>
					</IFRAME>
        </div>
	    </div>
	</div>
<script language=javascript>
	jQuery('.e8_box').Tabs({
		getLine:1,
		iframe:"frame1",
		needNotCalHeight:true,
		//contentID:"#frame1",
	  mouldID:"<%=MouldIDConst.getID("resource") %>",
	  objName:<%=JSONObject.quote(SystemEnv.getHtmlLabelName(33210, user.getLanguage())) %>,
		staticOnLoad:true
	});

	function resetbanner(objid){
		if(objid == 0 ){
		  window.frame1.location="/hrm/resource/SingleSearchByOrganRight.jsp?onlyselfdept=<%=onlyselfdept%>&sqlwhere=<%=xssUtil.put(sqlwhere)%>&departments=<%=departments%>&subcompanyids=<%=subcompanyids%>&isall=<%=isall%>&rightStr=<%=rightStr%>&fromHrmStatusChange=<%=fromHrmStatusChange%>";
		}else if(objid == 1){
			window.frame1.location="/hrm/resource/SingleSearchByGroupDec.jsp?sqlwhere=<%=xssUtil.put(sqlwhere)%>&fromHrmStatusChange=<%=fromHrmStatusChange%>";
		}else if(objid == 2){
			window.frame1.location="/hrm/resource/SingleSearchDec.jsp?sqlwhere=<%=xssUtil.put(sqlwhere)%>&fromHrmStatusChange=<%=fromHrmStatusChange%>";
		}
	}
	resetbanner(<%=tabid%>);
</script>	
</body>
</html>