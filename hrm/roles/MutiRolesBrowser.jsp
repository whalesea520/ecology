<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!-- modified by wcd 2014-07-07 [E7 to E8] -->
<%@ page import="org.json.JSONObject"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RoleComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
	Calendar today = Calendar.getInstance();
	String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
					 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
					 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;


	String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));

	String rolesname = Util.null2String(request.getParameter("rolesname"));

	String hrm_id = Util.null2String(request.getParameter("hrm_id"));

	String check_per = Util.null2String(request.getParameter("selectedids"));
	String resourceids = Util.null2String(request.getParameter("resourceids"));
	if(check_per.length()==0){
		check_per = resourceids;
	}
	String selectids = "" ;
	String resourcenames ="";
	if(!check_per.equals("")){
		try{
			String strtmp = "select id,rolesmark from HrmRoles where id in ("+check_per+")";
			RecordSet.executeSql(strtmp);
			Hashtable ht = new Hashtable();
			while(RecordSet.next()){
				ht.put(RecordSet.getString("id"),RecordSet.getString("rolesmark"));
			}

			StringTokenizer st = new StringTokenizer(check_per,",");

			while(st.hasMoreTokens()){
				String s = st.nextToken();
				selectids +=","+s;
				resourcenames += ","+ht.get(s).toString();
			}
		}catch(Exception e){
			
		}
	}

	int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
	int hrmdetachable=Util.getIntValue(String.valueOf(session.getAttribute("hrmdetachable")),0);

	if(!"".equals(hrm_id) && !"1".equals(hrm_id) && hrmdetachable == 1){
		sqlwhere += " where exists (select distinct subcompanyid from SysRoleSubcomRight where subcompanyid = HrmRoles.Subcompanyid and  exists (select roleid from hrmrolemembers where roleid = SysRoleSubcomRight.Roleid and resourceid = "+hrm_id+"))";
	} else {
		sqlwhere += " where 1=1 ";
	}

	if(!rolesname.equals(""))
		sqlwhere += " and HrmRoles.rolesmark like '%"+rolesname+"%'";
%>
<HTML>
	<HEAD>
		<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
		<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<STYLE type=text/css>
			PRE {}
			A {
				COLOR:#000000;FONT-WEIGHT: bold; TEXT-DECORATION: none
			}
			A:hover {
				COLOR:#56275D;TEXT-DECORATION: none
			}
		</STYLE>
	</HEAD>
	<body scroll="no">
		<div class="e8_box demo2">
			<div class="e8_boxhead">
				<div class="div_e8_xtree" id="div_e8_xtree"></div>
				<div class="e8_tablogo" id="e8_tablogo"></div>
				<div class="e8_ultab">
					<div class="e8_navtab" id="e8_navtab">
						<span id="objName"></span>
					</div>
					<div>
						<div id="rightBox" class="e8_rightBox"></div>
					</div>
				</div>
			</div>
			<div class="tab_box">
				<div>
				<!-- 
				<iframe name=frame1 id=frame1 src="/hrm/roles/MultiSearch.jsp?sqlwhere=<%=xssUtil.put(sqlwhere)%>" width="100%" height="80px" frameborder=no scrolling=yes>浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。</iframe>
				 -->
					<iframe src="/hrm/roles/MultiSelect.jsp?selectids=<%=check_per%>&sqlwhere=<%=xssUtil.put(sqlwhere)%>" onload="update();" id="frame2" name="frame2" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
				</div>
			</div>
		</div>
		<script type="text/javascript">
			function onCancel(){
				try{
					var dialog = parent.getDialog(window);	
					dialog.close();
				}catch(ex1){}
				doClose();
			}

			function doClose(){
				try{
					var parentWin = parent.parent.getParentWindow(window);
					parentWin.closeDialog();
				}catch(ex1){}
			}
			jQuery('.e8_box').Tabs({
				getLine:1,
				iframe:"frame2",
				contentID:"#frame1",
				mouldID:"<%=MouldIDConst.getID("hrm") %>",
				objName:<%=JSONObject.quote(SystemEnv.getHtmlLabelNames("33251,122", user.getLanguage())) %>,
				staticOnLoad:true
			});
		</script>
	</body>
</html>