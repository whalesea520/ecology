
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="org.json.JSONObject"%>
<%@ page import="java.util.*,weaver.hrm.appdetach.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<%

String f_weaver_belongto_userid=Util.fromScreen(request.getParameter("f_weaver_belongto_userid"),user.getLanguage());
String f_weaver_belongto_usertype=Util.fromScreen(request.getParameter("f_weaver_belongto_usertype"),user.getLanguage());
user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
int uid=user.getUID();
String show_virtual_org = Util.null2String(request.getParameter("show_virtual_org"));
String selectedDepartmentIds = Util.null2String(request.getParameter("selectedDepartmentIds"));
String selectedids=Util.null2String(request.getParameter("selectedids"));
String resourceids=Util.null2String(request.getParameter("resourceids"));
if(resourceids.length()==0)resourceids=selectedids;
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));

Cookie[] cks= request.getCookies();
String rem="";
for(int i=0;i<cks.length;i++){
//System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
if(cks[i].getName().equals("departmentmultiOrder"+uid)){
  rem=cks[i].getValue();
  break;
}
}
if(resourceids.equals("")) resourceids=selectedDepartmentIds;
String tabid="0";
if(rem!=null&&rem.length()>1){
    String[] atts=Util.TokenizerString2(rem,"|");
    tabid=atts[0];
}

String showId = "";//new AppDetachComInfo().getScopeIds(user, "department");
%>
<HTML><HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
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
		    		<li class="<%=tabid.equals("0")?"current":"" %>">
			        	<a id="tabId0" href="javascript:resetbanner(0);">
			        		<%=SystemEnv.getHtmlLabelName(18770,user.getLanguage())%><!-- 按组织结构 --> 
			        	</a>
			      </li>
		    		<li class="<%=tabid.equals("1")?"current":"" %>">
			        	<a id="tabId1" href="javascript:resetbanner(1);">
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
	    	<table class="table_box" style="height: 100%;width: 100%">
	    		<tr>
	    			<td class='td1' style="height: 40%;width: 100%">
	    				<IFRAME name=frame1 id=frame1 width="100%" onload="update();" height="100%" frameborder=no scrolling="no">
							<%=SystemEnv.getHtmlLabelName(15017, user.getLanguage())%></IFRAME>
						</td>
					</tr>
	    		<tr>
	    			<td class='td2' style="height: 60%;width: 100%">
	    				<iframe  src="/hrm/company/MultiSelect.jsp?tabid=<%=tabid%>&showId=<%=showId%>&resourceids=<%=resourceids%>&sqlwhere=<%=sqlwhere%>" id="frame2" name="frame2" class="flowFrame" frameborder="0" height="100%" width="100%;" scrolling="no"></iframe>
	    			</td>
	    		</tr>
	    	</table>
        </div>
        <script type="text/javascript">
        	jQuery(".tab_box").height(jQuery(window).height()-62);
					jQuery(".table_box").height(jQuery(window).height()-62);
					jQuery(".td1").height(jQuery(".table_box").height()*0.35-5);
					jQuery(".td2").height(jQuery(".table_box").height()-jQuery(".td1").height());
        </script>
	    </div>
	</div>
	
<script language=javascript>
	function resetbanner(objid){
		//增加的代码 start　2012-08-13 ypc 修改
		 var curDoc;
		 if(document.all){
			curDoc=window.frames["frame2"].document
		 }
		 else{
			curDoc=document.getElementById("frame2").contentDocument	
		 }
		//增加的代码 end 2012-08-13 ypc 修改
		if(objid == 0 ){
		        window.frame1.location="/hrm/company/SearchByOrgan.jsp?show_virtual_org=<%=show_virtual_org%>&sqlwhere=<%=sqlwhere%>&showId=<%=showId%>";
		        try{
                    $("#subdepttr").show();
		           	//window.frame2.btnsub.style.display="none" //修改之前 这种写法不兼容火狐浏览器
                    $(curDoc).find("#btnsub").css("display","none"); //2012-08-13 ypc 修改
		        }catch(err){}
		        }
		else if(objid == 1){
			window.frame1.location="/hrm/company/Search.jsp?show_virtual_org=<%=show_virtual_org%>&sqlwhere=<%=sqlwhere%>&showId=<%=showId%>";
			try{
               $("#subdepttr").hide();
			   //window.frame2.btnsub.style.display="inline"  //修改之前 这种写法不兼容火狐浏览器
			   $(curDoc).find("#btnsub").css("display","inline"); //2012-08-13 ypc 修改
			}catch(err){}
			}
	}

	resetbanner(<%=tabid%>);
	
jQuery('.e8_box').Tabs({
	getLine:1,
	iframe:"frame1",
	needNotCalHeight:true,
	//contentID:"#frame1",
  mouldID:"<%=MouldIDConst.getID("hrm") %>",
  objName:<%=JSONObject.quote(SystemEnv.getHtmlLabelName(124, user.getLanguage())) %>,
	staticOnLoad:true
});
</script>

</body>
</html>