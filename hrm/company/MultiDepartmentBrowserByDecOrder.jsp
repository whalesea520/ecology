
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="org.json.JSONObject"%>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
String f_weaver_belongto_userid=Util.fromScreen(request.getParameter("f_weaver_belongto_userid"),user.getLanguage());
String f_weaver_belongto_usertype=Util.fromScreen(request.getParameter("f_weaver_belongto_usertype"),user.getLanguage());
int uid=user.getUID();
int beagenter = Util.getIntValue((String)session.getAttribute("beagenter_"+user.getUID()));
if(beagenter <= 0){
	beagenter = uid;
}
String isruledesign = Util.null2String(request.getParameter("isruledesign"));
//判断是否是管理员
boolean isadmin = false;
String adminsql = "select * from HrmResourceManager where id = " + beagenter;
RecordSet.executeSql(adminsql);
if(RecordSet.next()){
	isadmin = true;
}

if(isadmin && "true".equals(isruledesign)){
	beagenter = 1;
}

String selectedids = Util.null2String(request.getParameter("selectedids"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
int fieldid=Util.getIntValue(request.getParameter("fieldid"));
    int isdetail=Util.getIntValue(request.getParameter("isdetail"));
    int isbill=Util.getIntValue(request.getParameter("isbill"),1);
    boolean onlyselfdept=CheckSubCompanyRight.getDecentralizationAttr(beagenter,"Departments:decentralization",fieldid,isdetail,isbill);
    String departments=CheckSubCompanyRight.getDepartmentids();
    String subcompanyids=CheckSubCompanyRight.getSubcompanyids();
    boolean isall=CheckSubCompanyRight.getIsall();
    if(!isall){
        if(onlyselfdept){
            sqlwhere=" where id in("+CheckSubCompanyRight.getDepartmentids()+")";
        }else{
            sqlwhere=" where subcompanyid1 in("+CheckSubCompanyRight.getSubcompanyids()+")";
        }
    }
Cookie[] cks= request.getCookies();
String rem=null;
for(int i=0;i<cks.length;i++){
//System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
if(cks[i].getName().equals("departmentmultiDecOrder"+uid)){
  rem=cks[i].getValue();
  break;
}
}
String tabid="0";
if(rem!=null&&rem.length()>1){
String[] atts=Util.TokenizerString2(rem,"|");
tabid=atts[0];
} 



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
        <div>
        		<IFRAME name=frame1 id=frame1 style="width: 100%" onload="update();" height="160px" frameborder=no scrolling=no>
						<%=SystemEnv.getHtmlLabelName(15017, user.getLanguage())%></IFRAME>
            <iframe  src="/hrm/company/MultiSelect.jsp?isdec=1&tabid=<%=tabid%>&selectedids=<%=selectedids%>&sqlwhere=<%=xssUtil.put(sqlwhere)%>" id="frame2" name="frame2" class="flowFrame" frameborder="0" height="370px" width="100%;"></iframe>
        </div>
	    </div>
	</div>
<script language=javascript>
	function resetbanner(objid){
		if(objid == 0 ){
		        window.frame1.location="/hrm/company/SearchByOrganByDec.jsp?fieldid=<%=fieldid%>&isbill=<%=isbill%>&isdetail=<%=isdetail%>&detachable=1&onlyselfdept=<%=onlyselfdept%>&sqlwhere=<%=xssUtil.put(sqlwhere)%>&departments=<%=departments%>&subcompanyids=<%=subcompanyids%>&isall=<%=isall%>&f_weaver_belongto_userid=<%=f_weaver_belongto_userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&isruledesign=<%=isruledesign%>";
		        try{
                    //document.getElementById("subdepttr").style.display='inlime';
                    $(curDoc).find("#subdepttr").css("display","inlime")
		            //window.frame2.btnsub.style.display="none"; //修改之前
		             $(curDoc).find("#btnsub").css("display","none"); //ypc 修改
		        }catch(err){}
		        }
		else if(objid == 1){
			window.frame1.location="/hrm/company/SearchByDec.jsp?sqlwhere=<%=xssUtil.put(sqlwhere)%>&f_weaver_belongto_userid=<%=f_weaver_belongto_userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>";
			try{
               // document.getElementById("subdepttr").style.display="none";
                  $(curDoc).find("#subdepttr").css("display","none")
			    //window.frame2.btnsub.style.display="inline"; //修改之前
			    $(curDoc).find("#btnsub").css("display","inline"); //ypc 修改
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