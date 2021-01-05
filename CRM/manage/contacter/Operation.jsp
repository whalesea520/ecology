
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="java.io.File"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@page import="java.net.URLDecoder"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.crm.CrmShareBase"%>
<%@ page import="weaver.conn.*"%>
<jsp:useBean id="cmutil" class="weaver.workrelate.util.CommonTransUtil" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ContacterTitleComInfo" class="weaver.crm.Maint.ContacterTitleComInfo" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="SptmForCrmModiRecord" class="weaver.crm.SptmForCrmModiRecord" scope="page" />
<%
	String operation = Util.fromScreen3(request.getParameter("operation"), user.getLanguage());
	String sql = "";
	StringBuffer restr = new StringBuffer();
	char flag = 2;
	String ProcPara = "";
	String userid = user.getUID()+"";
	String CurrentDate = TimeUtil.getCurrentDateString();
	String CurrentTime = TimeUtil.getOnlyCurrentTimeString();
	
	//获取指定客户的联系人列表数据
	if("get_list_contacter".equals(operation)){
		String customerid = Util.fromScreen3(request.getParameter("customerid"),user.getLanguage());
		//判断是否有查看该客户权限
		if(!checkRight(customerid,"",userid,1)) return;
		
		int currentpage = Util.getIntValue(request.getParameter("currentpage"),0);
		int pagesize = 20;
		int total = Util.getIntValue(request.getParameter("total"),0);
		
		int maintype = Util.getIntValue(request.getParameter("maintype"),1);
		
		if(currentpage==0){
			rs2.executeSql("select count(id) from CRM_CustomerContacter where customerid="+customerid + (maintype==3?" and isperson=1":""));
			if(rs2.next()){
				total = rs2.getInt(1);
			}
			currentpage = 1;
		}
		
		String orderby1 = " order by main desc,id desc";
		String orderby2 = " order by main asc,id asc";
		String orderby3 = " order by main desc,id desc";
		
		int iTotal =total; 
		int iNextNum = currentpage * pagesize;
		int ipageset = pagesize;
		if(iTotal - iNextNum + pagesize < pagesize) ipageset = iTotal - iNextNum + pagesize;
		if(iTotal < pagesize) ipageset = iTotal;
		String querysql = " id,firstname,title,jobtitle,department,email,phoneoffice,phonehome,mobilephone,main"
			+ " from CRM_CustomerContacter where customerid="+ customerid + (maintype==3?" and isperson=1":"");
		sql = "select top " + ipageset +" A.* from (select top "+ iNextNum + querysql + orderby3 + ") A "+orderby2;
		sql = "select top " + ipageset +" B.* from (" + sql + ") B "+orderby1;

		String sellchanceid = Util.fromScreen3(request.getParameter("sellchanceid"),user.getLanguage());
		rs2.executeSql(sql);
		String _contacterid = "";
		while(rs2.next()){
			_contacterid = Util.null2String(rs2.getString("id"));
%>
	<tr id="contacter<%=_contacterid%>" class="item_tr contacter_tr <%if(sellchanceid.equals("")){%>contacter<%=customerid%><%}else{%>contacter_<%=sellchanceid%>_<%=customerid%><%}%>" _contacterid="<%=_contacterid %>" _customerid="<%=customerid%>" _lastdate="">
		<td class='td_blank'>&nbsp;</td>
		<td colspan="7">
			<div style="float: left;width: 5%" title="客户联系人">&nbsp;</div>
			<div style="float: left;margin-left: 0px;" title="姓名：<%=Util.null2String(rs2.getString("firstname")) %> 称呼：<%=Util.null2String(ContacterTitleComInfo.getContacterTitlename(rs2.getString("title"))) %>">
				<%=Util.getMoreStr(rs2.getString("firstname"),3,"...") %> <%=Util.null2String(ContacterTitleComInfo.getContacterTitlename(rs2.getString("title"))) %>
			</div>
			<div style="float: left;margin-left: 8px;" title="部门：<%=Util.null2String(rs2.getString("department")) %>"><%=Util.getMoreStr(Util.null2String(rs2.getString("department")),5,"...") %></div>
			<div style="float: left;margin-left: 8px;" title="职务：<%=Util.null2String(rs2.getString("jobtitle")) %>"><%=Util.getMoreStr(Util.null2String(rs2.getString("jobtitle")),5,"...") %></div>
			<div style="float: left;margin-left: 8px;" title="电话：<%=Util.null2String(rs2.getString("phoneoffice")) %>"><%=Util.null2String(rs2.getString("phoneoffice")) %></div>
			<div style="float: left;margin-left: 8px;" title="手机：<%=Util.null2String(rs2.getString("mobilephone")) %>"><%=Util.getMoreStr(Util.null2String(rs2.getString("mobilephone")),11,"...") %></div>
			<div style="float: left;margin-left: 8px;" title="邮箱：<%=Util.null2String(rs2.getString("email")) %>"><%=Util.getMoreStr(Util.null2String(rs2.getString("email")),9,"...") %></div>
		</td>	
	</tr>
<%			
		}
		if(total>pagesize && currentpage==1){
%>
	<tr>
		<td class='td_blank'>&nbsp;</td>
		<td colspan="7" valign="top">
			<div class="listmore" style="" onclick="getMoreContacterList(this)" _currentpage="1" _pagesize="<%=pagesize %>" _total="<%=total %>" _customerid="<%=customerid %>" _sellchanceid="<%=sellchanceid %>" _querysql=""  title="显示更多数据">更多</div>
		</td>
	</tr>
<%			
		}
	}
	//获取指定联系人信息
	else if("get_contacter".equals(operation)){
		String contacterid = Util.fromScreen3(request.getParameter("contacterid"),user.getLanguage());
		String customerid = "";
		String contact = Util.fromScreen3(request.getParameter("contact"),user.getLanguage());
		sql = "select t2.id,t2.title,t2.firstname,t2.jobtitle,t2.lastname,t2.department,t2.email,t2.phoneoffice,t2.mobilephone,t2.projectrole,t2.attitude,t2.attention,t2.customerid,t2.imcode"
			+ " from CRM_CustomerContacter t2 where t2.id=" + contacterid;
		rs.executeSql(sql);
		if(rs.next()){
			customerid = Util.null2String(rs.getString("customerid"));
			//判断是否有查看该客户权限
			int sharelevel = CrmShareBase.getRightLevelForCRM(userid,customerid);
			if(sharelevel<1) return;
%>
				<tr id="tr_<%=contacterid%>" class="DataLight">
					
					<td class="info" title="姓名:<%=Util.toScreen(rs.getString("firstname"), user
						.getLanguage())%>">
						<input _fieldname="firstname" _contacterid="<%=contacterid %>"
							class="rel_input" _def="姓名" _value="<%=Util.null2String(rs.getString("firstname")) %>"
							value="<%=Util.null2String(rs.getString("firstname")) %>" />
					</td>
					<td class="info"
						title="称呼:<%=Util.toScreen(ContacterTitleComInfo
						.getContacterTitlename(rs.getString("title")), user
						.getLanguage())%>">
						<input _fieldname="title" _contacterid="<%=contacterid %>" readonly="readonly" _select="ct_select" _val="<%=Util.null2String(rs.getString("title")) %>"
							class="rel_input <%if (Util.null2String(rs.getString("title"))
							.equals("")) {%>input_blur<%}%>"
							_def="称呼" _value="<%=Util.toScreen(ContacterTitleComInfo
								.getContacterTitlename(rs.getString("title")),
								user.getLanguage()) %>"
							value="<%=Util.null2String(rs.getString("title"))
							.equals("") ? "称呼" : Util.toScreen(ContacterTitleComInfo
									.getContacterTitlename(rs.getString("title")),
									user.getLanguage())%>" />
					</td>
					<td class="info" title="岗位:<%=Util.null2String(rs.getString("jobtitle"))%>">
						<input _fieldname="jobtitle" _contacterid="<%=contacterid %>"
							class="rel_input <%if (Util.null2String(rs.getString("jobtitle")).equals("")) {%>input_blur<%}%>"
							_def="岗位" _value="<%=Util.null2String(rs.getString("jobtitle")) %>"
							value="<%=Util.null2String(rs.getString("jobtitle"))
							.equals("") ? "岗位" : Util.null2String(rs
							.getString("jobtitle"))%>" />
					</td>
					<td class="info" title="部门:<%=Util.null2String(rs.getString("department"))%>">
						<input _fieldname="department" _contacterid="<%=contacterid %>"
							class="rel_input <%if (Util.null2String(rs.getString("department")).equals("")) {%>input_blur<%}%>"
							_def="部门" _value="<%=Util.null2String(rs.getString("department")) %>"
							value="<%=Util.null2String(rs.getString("department"))
							.equals("") ? "部门" : Util.null2String(rs
							.getString("department"))%>" />
					</td>
					<td class="info" title="办公电话:<%=Util.null2String(rs.getString("phoneoffice"))%>">
						<input _fieldname="phoneoffice" _contacterid="<%=contacterid %>"
							class="rel_input <%if (Util.null2String(rs.getString("phoneoffice"))
							.equals("")) {%>input_blur<%}%>"
							_def="办公电话" _value="<%=Util.null2String(rs.getString("phoneoffice")) %>"
							value="<%=Util.null2String(rs.getString("phoneoffice"))
							.equals("") ? "办公电话" : Util.null2String(rs
							.getString("phoneoffice"))%>" />
					</td>
					<td class="info" title="移动电话:<%=Util.null2String(rs.getString("mobilephone"))%>">
						<input _fieldname="mobilephone" _contacterid="<%=contacterid %>"
							class="rel_input <%if (Util.null2String(rs.getString("mobilephone"))
							.equals("")) {%>input_blur<%}%>"
							_def="移动电话" _value="<%=Util.null2String(rs.getString("mobilephone")) %>"
							value="<%=Util.null2String(rs.getString("mobilephone"))
							.equals("") ? "移动电话" : Util.null2String(rs
							.getString("mobilephone"))%>" />
					</td>
					<td class="info" title="邮箱:<%=Util.null2String(rs.getString("email"))%>">
						<input _fieldname="email" _contacterid="<%=contacterid %>"
							class="rel_input <%if (Util.null2String(rs.getString("email")).equals("")) {%>input_blur<%}%>"
							_def="邮箱" _value="<%=Util.null2String(rs.getString("email")) %>"
							value="<%=Util.null2String(rs.getString("email"))
							.equals("") ? "邮箱" : Util.null2String(rs
							.getString("email"))%>" />
					</td>
					<td class="info" title="IM号码:<%=Util.null2String(rs.getString("imcode"))%>">
						<input _fieldname="imcode" _contacterid="<%=contacterid %>"
							class="rel_input <%if (Util.null2String(rs.getString("imcode")).equals("")) {%>input_blur<%}%>"
							_def="IM号码" _value="<%=Util.null2String(rs.getString("imcode")) %>"
							value="<%=Util.null2String(rs.getString("imcode"))
							.equals("") ? "IM号码" : Util.null2String(rs
							.getString("imcode"))%>" style="width: 80%"/>
						<a id="imlink_<%=contacterid %>" class="imlink" href="tencent://message/?uin=<%=Util.null2String(rs.getString("imcode")) %>&Site=&Menu=yes" title="点击发起QQ会话" style="display: none;">Q</a>
					</td>
					<td class="info" title="意向判断:<%=Util.null2String(rs.getString("attitude"))%>">
						<input _fieldname="attitude" _contacterid="<%=contacterid %>" readonly="readonly" _select="at_select"
							class="rel_input <%if (Util.null2String(rs.getString("attitude")).equals("")) {%>input_blur<%}%>"
							_def="意向判断" _value="<%=Util.null2String(rs.getString("attitude")) %>"
							value="<%=Util.null2String(rs.getString("attitude"))
							.equals("") ? "意向判断" : Util.null2String(rs
							.getString("attitude"))%>" />
					</td>
					<td class="info" title="关注点及应对策略:<%=Util.null2String(rs.getString("attention"))%>">
						<input _fieldname="attention" _contacterid="<%=contacterid %>"
							class="rel_input <%if (Util.null2String(rs.getString("attention")).equals("")) {%>input_blur<%}%>"
							_def="关注点及应对策略" _value="<%=Util.null2String(rs.getString("attention")) %>"
							value="<%=Util.null2String(rs.getString("attention"))
							.equals("") ? "关注点及应对策略" : Util.null2String(rs
							.getString("attention"))%>" />
					</td>
					<td class="info">
						<div class="c_view" onclick="openFullWindowHaveBar('/CRM/manage/contacter/ContacterView.jsp?ContacterID=<%=contacterid%>')" title="明细"></div>
						<%if(contact.equals("0")&false){ %>
						<div class="c_view ci_add" style="background: url('../images/btn_add2_wev8.png') center no-repeat;" onclick="addContact('<%=contacterid %>',2)" title="添加联系记录"></div>
						<%} %>
						<!-- <div class="c_del" onclick="delContacter('<%=contacterid %>')" title="删除"></div> -->
					</td>
				</tr>
<%			
			
		}
	}
	//读取更多联系人
	else if("get_more_contacter".equals(operation)){
		boolean canedit = Util.null2String(request.getParameter("canedit")).equals("true")?true:false;
		String contact = Util.fromScreen3(request.getParameter("contact"),user.getLanguage());
		String customerid = Util.null2String(request.getParameter("customerid"));
		int currentpage = Util.getIntValue(request.getParameter("currentpage"),0);
		int pagesize = Util.getIntValue(request.getParameter("pagesize"),0);
		int total = Util.getIntValue(request.getParameter("total"),0);
		
		//判断是否有查看该客户权限
		if(!checkRight(customerid,"",userid,1)) return;
		
		String orderby1 = " order by id asc";
		String orderby2 = " order by id desc";
		String orderby3 = " order by t2.id asc";
		
		int iTotal =total; 
		int iNextNum = currentpage * pagesize;
		int ipageset = pagesize;
		if(iTotal - iNextNum + pagesize < pagesize) ipageset = iTotal - iNextNum + pagesize;
		if(iTotal < pagesize) ipageset = iTotal;
		String querysql = " t2.id,t2.title,t2.firstname,t2.jobtitle,t2.lastname,t2.department,t2.email,t2.phoneoffice,t2.mobilephone,t2.projectrole,t2.attitude,t2.attention,t2.imcode"
			+ " from CRM_CustomerContacter t2 where t2.customerid="+ customerid;
		sql = "select top " + ipageset +" A.* from (select top "+ iNextNum + querysql + orderby3 + ") A "+orderby2;
		sql = "select top " + ipageset +" B.* from (" + sql + ") B "+orderby1;
		rs.executeSql(sql);
		while (rs.next()) {
			String contacterid = Util.null2String(rs.getString("id"));
%>
			<tr id="tr_<%=contacterid%>" class="tr_contacter">
				<td class="title2" title="项目角色:<%=Util.toScreen(rs.getString("projectrole"), user.getLanguage())%>">
					<%if (canedit) {%>
					<input _fieldname="projectrole" _contacterid="<%=contacterid %>" _select="pr_select"
						class="rel_input rel_pr <%if (Util.null2String(rs.getString("projectrole"))
						.equals("")) {%>input_blur<%}%>" _value="<%=Util.null2String(rs.getString("projectrole")) %>"
						_def="项目角色"
						value="<%=Util.null2String(rs.getString("projectrole"))
						.equals("") ? "项目角色" : Util.null2String(rs
						.getString("projectrole"))%>" />
					<%} else {%>
					<%if (Util.null2String(rs.getString("projectrole"))
						.equals("")) {%>
					<div class="input_blur">
						项目角色
					</div>
					<%} else {%>
					<%=Util.null2String(rs.getString("projectrole"))%>
					<%}%>
					<%}%>
				</td>
				<td class="info" title="姓名:<%=Util.toScreen(rs.getString("firstname"), user
					.getLanguage())%>">
					<%if (canedit) {%>
					<input _fieldname="firstname" _contacterid="<%=contacterid %>"
						class="rel_input" _def="姓名" _value="<%=Util.null2String(rs.getString("firstname")) %>"
						value="<%=Util.null2String(rs.getString("firstname")) %>" />
					<%} else {%>
						<div style="float: left;"><a href="###"
						onclick="openFullWindowHaveBar('/CRM/manage/contacter/ContacterView.jsp?ContacterID=<%=contacterid%>')"
						target="_self"> <%=Util.toScreen(rs.getString("firstname"), user.getLanguage())%> </a></div>
						<%if(contact.equals("0")){ %>
							<div class="c_view ci_add" style="display:block;margin-top:1px;background: url('../images/btn_add2_wev8.png') center no-repeat;" onclick="addContact('<%=contacterid %>',2)" title="添加联系记录"></div>
						<%} %>
					<%}%>
				</td>
				<td class="info"
					title="称呼:<%=Util.toScreen(ContacterTitleComInfo
					.getContacterTitlename(rs.getString("title")), user
					.getLanguage())%>">
					<%if (canedit) {%>
					<input _fieldname="title" _contacterid="<%=contacterid %>" readonly="readonly" _select="ct_select" _val="<%=Util.null2String(rs.getString("title")) %>"
						class="rel_input <%if (Util.null2String(rs.getString("title"))
						.equals("")) {%>input_blur<%}%>"
						_def="称呼"  _value="<%=Util.toScreen(ContacterTitleComInfo
							.getContacterTitlename(rs.getString("title")),
							user.getLanguage()) %>"
						value="<%=Util.null2String(rs.getString("title"))
						.equals("") ? "称呼" : Util.toScreen(ContacterTitleComInfo
								.getContacterTitlename(rs.getString("title")),
								user.getLanguage())%>" />
					<%} else {%>
					<%if (Util.null2String(rs.getString("title"))
						.equals("")) {%>
					<div class="input_blur">
						称呼
					</div>
					<%} else {%>
					<%=Util.null2String(rs.getString("title"))%>
					<%}%>
					<%}%>
				</td>
				<td class="info" title="岗位:<%=Util.null2String(rs.getString("jobtitle"))%>">
					<%if (canedit) {%>
					<input _fieldname="jobtitle" _contacterid="<%=contacterid %>"
						class="rel_input <%if (Util.null2String(rs.getString("jobtitle")).equals("")) {%>input_blur<%}%>"
						_def="岗位" _value="<%=Util.null2String(rs.getString("jobtitle")) %>"
						value="<%=Util.null2String(rs.getString("jobtitle"))
						.equals("") ? "岗位" : Util.null2String(rs
						.getString("jobtitle"))%>" />
					<%} else {%>
					<%if (Util.null2String(rs.getString("jobtitle")).equals("")) {%>
					<div class="input_blur">
						岗位
					</div>
					<%} else {%>
					<%=Util.null2String(rs.getString("jobtitle"))%>
					<%}%>
					<%}%>
				</td>
				<td class="info" title="部门:<%=Util.null2String(rs.getString("department"))%>">
					<%if (canedit) {%>
					<input _fieldname="department" _contacterid="<%=contacterid %>"
						class="rel_input <%if (Util.null2String(rs.getString("department")).equals("")) {%>input_blur<%}%>"
						_def="部门" _value="<%=Util.null2String(rs.getString("department")) %>"
						value="<%=Util.null2String(rs.getString("department"))
						.equals("") ? "部门" : Util.null2String(rs
						.getString("department"))%>" />
					<%} else {%>
					<%if (Util.null2String(rs.getString("department")).equals("")) {%>
					<div class="input_blur">
						部门
					</div>
					<%} else {%>
					<%=Util.null2String(rs.getString("department"))%>
					<%}%>
					<%}%>
				</td>
				<td class="info" title="办公电话:<%=Util.null2String(rs.getString("phoneoffice"))%>">
					<%if (canedit) {%>
					<input _fieldname="phoneoffice" _contacterid="<%=contacterid %>"
						class="rel_input <%if (Util.null2String(rs.getString("phoneoffice"))
						.equals("")) {%>input_blur<%}%>"
						_def="办公电话" _value="<%=Util.null2String(rs.getString("phoneoffice")) %>"
						value="<%=Util.null2String(rs.getString("phoneoffice"))
						.equals("") ? "办公电话" : Util.null2String(rs
						.getString("phoneoffice"))%>" />
					<%} else {%>
					<%if (Util.null2String(rs.getString("phoneoffice"))
						.equals("")) {%>
					<div class="input_blur">
						办公电话
					</div>
					<%} else {%>
					<%=Util.null2String(rs.getString("phoneoffice"))%>
					<%}%>
					<%}%>
				</td>
				<td class="info" title="移动电话:<%=Util.null2String(rs.getString("mobilephone"))%>">
					<%if (canedit) {%>
					<input _fieldname="mobilephone" _contacterid="<%=contacterid %>"
						class="rel_input <%if (Util.null2String(rs.getString("mobilephone"))
						.equals("")) {%>input_blur<%}%>"
						_def="移动电话" _value="<%=Util.null2String(rs.getString("mobilephone")) %>"
						value="<%=Util.null2String(rs.getString("mobilephone"))
						.equals("") ? "移动电话" : Util.null2String(rs
						.getString("mobilephone"))%>" />
					<%} else {%>
					<%if (Util.null2String(rs.getString("mobilephone"))
						.equals("")) {%>
					<div class="input_blur">
						移动电话
					</div>
					<%} else {%>
					<%=Util.null2String(rs.getString("mobilephone"))%>
					<%}%>
					<%}%>
				</td>
				<td class="info" title="邮箱:<%=Util.null2String(rs.getString("email"))%>">
					<%if (canedit) {%>
					<input _fieldname="email" _contacterid="<%=contacterid %>"
						class="rel_input <%if (Util.null2String(rs.getString("email")).equals("")) {%>input_blur<%}%>"
						_def="邮箱" _value="<%=Util.null2String(rs.getString("email")) %>"
						value="<%=Util.null2String(rs.getString("email"))
						.equals("") ? "邮箱" : Util.null2String(rs
						.getString("email"))%>" />
					<%} else {%>
					<%if (Util.null2String(rs.getString("email")).equals("")) {%>
					<div class="input_blur">
						邮箱
					</div>
					<%} else {%>
					<%=Util.toScreenToEdit(rs.getString("email"),user.getLanguage())%>
					<%}%>
					<%}%>
				</td>
				<td class="info" title="IM号码:<%=Util.null2String(rs.getString("imcode"))%>">
						<%if (canedit) {%>
						<input _fieldname="imcode" _contacterid="<%=contacterid %>"
							class="rel_input <%if (Util.null2String(rs.getString("imcode")).equals("")) {%>input_blur<%}%>"
							_def="IM号码" _value="<%=Util.null2String(rs.getString("imcode")) %>"
							value="<%=Util.null2String(rs.getString("imcode"))
							.equals("") ? "IM号码" : Util.null2String(rs
							.getString("imcode"))%>" style="width: 80%"/>
						<a id="imlink_<%=contacterid %>" class="imlink" href="tencent://message/?uin=<%=Util.null2String(rs.getString("imcode")) %>&Site=&Menu=yes" title="点击发起QQ会话" style="display: none;">Q</a>
						<%} else {%>
						<%if (Util.null2String(rs.getString("imcode")).equals("")) {%>
						<div class="input_blur">
							IM号码
						</div>
						<%} else {%>
						<a href="tencent://message/?uin=<%=Util.null2String(rs.getString("imcode")) %>&Site=&Menu=yes" title="点击发起QQ会话">
							<%=Util.toScreenToEdit(rs.getString("imcode"),user.getLanguage())%>
						</a>
						<%}%>
						<%}%>
				</td>		
				<td class="info" title="意向判断:<%=Util.null2String(rs.getString("attitude"))%>">
					<%if (canedit) {%>
					<input _fieldname="attitude" _contacterid="<%=contacterid %>" readonly="readonly" _select="at_select"
						class="rel_input <%if (Util.null2String(rs.getString("attitude")).equals("")) {%>input_blur<%}%>"
						_def="意向判断" _value="<%=Util.null2String(rs.getString("attitude")) %>"
						value="<%=Util.null2String(rs.getString("attitude"))
						.equals("") ? "意向判断" : Util.null2String(rs
						.getString("attitude"))%>" />
					<%} else {%>
					<%if (Util.null2String(rs.getString("attitude")).equals("")) {%>
					<div class="input_blur">
						意向判断
					</div>
					<%} else {%>
					<%=Util.null2String(rs.getString("attitude"))%>
					<%}%>
					<%}%>
				</td>
				<td class="info" title="关注点及应对策略:<%=Util.null2String(rs.getString("attention"))%>">
					<%if (canedit) {%>
					<input _fieldname="attention" _contacterid="<%=contacterid %>"
						class="rel_input <%if (Util.null2String(rs.getString("attention")).equals("")) {%>input_blur<%}%>"
						_def="关注点及应对策略" _value="<%=Util.null2String(rs.getString("attention")) %>"
						value="<%=Util.null2String(rs.getString("attention"))
						.equals("") ? "关注点及应对策略" : Util.null2String(rs
						.getString("attention"))%>" />
					<%} else {%>
					<%if (Util.null2String(rs.getString("attention")).equals("")) {%>
					<div class="input_blur">
						关注点及应对策略
					</div>
					<%} else {%>
					<%=Util.null2String(rs.getString("attention"))%>
					<%}%>
					<%}%>
				</td>
				<%if(canedit){ %>
				<td class="info">
					<div class="c_view" onclick="openFullWindowHaveBar('/CRM/manage/contacter/ContacterView.jsp?ContacterID=<%=contacterid%>')" title="明细"></div>
					<%if(contact.equals("0")){ %>
					<div class="c_view ci_add" style="background: url('../images/btn_add2_wev8.png') center no-repeat;" onclick="addContact('<%=contacterid %>',2)" title="添加联系记录"></div>
					<%} %>
					<!-- <div class="c_del" onclick="delContacter('<%=contacterid %>')" title="删除"></div> -->
				</td>
				<%} %>
			</tr>
<% 		}
	}
	
	Map fn = new HashMap();
	fn.put("firstname",SystemEnv.getHtmlLabelName(413, user.getLanguage()));
	fn.put("title",SystemEnv.getHtmlLabelName(462, user.getLanguage()));
	fn.put("lastName",SystemEnv.getHtmlLabelName(475, user.getLanguage()));
	fn.put("department","部门");
	fn.put("jobtitle",SystemEnv.getHtmlLabelName(640, user.getLanguage()));
	fn.put("projectrole","项目角色");
	fn.put("attitude","意向判断");
	fn.put("attention","关注点");
	fn.put("email",SystemEnv.getHtmlLabelName(477, user.getLanguage()));
	fn.put("phoneoffice",SystemEnv.getHtmlLabelName(420, user.getLanguage())+SystemEnv.getHtmlLabelName(421, user.getLanguage()));
	fn.put("phonehome",SystemEnv.getHtmlLabelName(619, user.getLanguage())+SystemEnv.getHtmlLabelName(421, user.getLanguage()));
	fn.put("mobilephone",SystemEnv.getHtmlLabelName(620, user.getLanguage()));
	fn.put("fax",SystemEnv.getHtmlLabelName(494, user.getLanguage()));
	fn.put("interest",SystemEnv.getHtmlLabelName(6066, user.getLanguage()));
	fn.put("hobby",SystemEnv.getHtmlLabelName(6067, user.getLanguage()));
	fn.put("managerstr",SystemEnv.getHtmlLabelName(572, user.getLanguage())+SystemEnv.getHtmlLabelName(596, user.getLanguage()));
	fn.put("subordinate",SystemEnv.getHtmlLabelName(442, user.getLanguage())+SystemEnv.getHtmlLabelName(460, user.getLanguage()));
	fn.put("strongsuit",SystemEnv.getHtmlLabelName(6068, user.getLanguage()));
	fn.put("birthday",SystemEnv.getHtmlLabelName(1884, user.getLanguage()));
	fn.put("birthdaynotifydays",SystemEnv.getHtmlLabelName(17534, user.getLanguage()));
	fn.put("home",SystemEnv.getHtmlLabelName(1967, user.getLanguage()));
	fn.put("school",SystemEnv.getHtmlLabelName(1518, user.getLanguage()));
	fn.put("speciality",SystemEnv.getHtmlLabelName(803, user.getLanguage()));
	fn.put("nativeplace",SystemEnv.getHtmlLabelName(1840, user.getLanguage()));
	fn.put("IDCard",SystemEnv.getHtmlLabelName(1518, user.getLanguage()));
	fn.put("experience",SystemEnv.getHtmlLabelName(812, user.getLanguage()));
	fn.put("language",SystemEnv.getHtmlLabelName(231, user.getLanguage()));
	fn.put("manager",SystemEnv.getHtmlLabelName(572, user.getLanguage())+SystemEnv.getHtmlLabelName(144, user.getLanguage()));
	fn.put("main",SystemEnv.getHtmlLabelName(1262, user.getLanguage()));
	fn.put("imcode",SystemEnv.getHtmlLabelName(25101,user.getLanguage()));
	fn.put("status",SystemEnv.getHtmlLabelName(25102, user.getLanguage()));
	fn.put("isneedcontact",SystemEnv.getHtmlLabelName(25103, user.getLanguage()));
	fn.put("principalIds","客服负责人");
	fn.put("remark",SystemEnv.getHtmlLabelName(454, user.getLanguage()));
	fn.put("remarkDoc",SystemEnv.getHtmlLabelName(454, user.getLanguage())+SystemEnv.getHtmlLabelName(58, user.getLanguage()));
	fn.put("contacterimageid",SystemEnv.getHtmlLabelName(15707, user.getLanguage()));
	
	//编辑联系人字段
	if("edit_contacter_field".equals(operation)){
		String contacterid = Util.fromScreen3(request.getParameter("contacterid"),user.getLanguage());
		System.err.println("contacterid==="+contacterid);
		
		String customerid = "";
		rs.executeSql("select customerid from CRM_CustomerContacter where id="+contacterid);
		if (rs.next()) {
			customerid = rs.getString(1);
			//判断是否有编辑该客户权限
			if(!checkRight(customerid,"",userid,2)) return;
		}else{
			return;
		}
		String fieldname = URLDecoder.decode(Util.fromScreen3(request.getParameter("fieldname"),user.getLanguage()),"utf-8");
		String oldvalue = Util.convertInput2DB(URLDecoder.decode(Util.null2String(request.getParameter("oldvalue")),"utf-8"));
		String newvalue = Util.convertInput2DB(URLDecoder.decode(Util.null2String(request.getParameter("newvalue")),"utf-8"));
		String fieldtype = Util.fromScreen3(request.getParameter("fieldtype"),user.getLanguage());
		
		String addvalue = Util.convertInput2DB(URLDecoder.decode(Util.null2String(request.getParameter("addvalue")),"utf-8"));
		String delvalue = Util.convertInput2DB(URLDecoder.decode(Util.null2String(request.getParameter("delvalue")),"utf-8"));
		
		if(fieldname.equals("main")){
			//设置为主联系人时取消原主联系人
			if(newvalue.equals("1")){
				String mainid = "";
				rs.executeSql("select id from CRM_CustomerContacter where main=1 and customerid="+customerid);
				if(rs.next()){
					mainid = Util.null2String(rs.getString("id"));
					rs.executeSql("update CRM_CustomerContacter set main=0 where id="+mainid);
					//记录日志
					ProcPara = customerid+flag+"2"+flag+mainid+flag+"0";
					ProcPara += flag+(String)fn.get(fieldname)+flag+CurrentDate+flag+CurrentTime+flag+"1"+flag+"0";
					ProcPara += flag+(user.getUID()+"")+flag+(user.getLogintype()+"")+flag+request.getRemoteAddr();
					rs.executeProc("CRM_Modify_Insert",ProcPara);
				}
			}
			rs.executeSql("update CRM_CustomerContacter set main="+newvalue+" where id="+contacterid);
		}else if(fieldname.equals("principalIds")){//客服负责人
			if(!addvalue.equals("")){//添加人员
				List idList = Util.TokenizerString(addvalue, ",");
				for(int i=0;i<idList.size();i++){
					if(!"".equals(idList.get(i))){
						rs.executeSql("insert into CS_ContacterPrincipal (contacterId,principalId) values ("+contacterid+","+idList.get(i)+")");
					}
				}
			}
			if(!delvalue.equals("")){//删除人员
				rs.executeSql("delete from CS_ContacterPrincipal where principalId in (" + delvalue + ") and contacterId="+contacterid);
			}
		}else if(fieldname.equals("firstname")){//名字
			rs.executeSql("update CRM_CustomerContacter set firstname='"+newvalue+"',fullname='"+newvalue+"' where id="+contacterid);
		}else{
			if(fieldtype.equals("attachment")){
				rs.execute("select "+fieldname+" from CRM_CustomerContacter where id = "+contacterid);
				rs.next();
				String att = rs.getString(1);
				if(att.equals(delvalue)){
					att = "";
				}else{
					att = (","+att+",").replace((","+delvalue+","), "");
					att = att.indexOf(",")==0?att.substring(1):att;
					att = att.lastIndexOf(",")==att.length()-1?att.substring(0,att.length()-1):att;
				}
				rs.execute("update CRM_CustomerContacter set "+fieldname+" = '"+att +"' where id = "+customerid);
				rs.execute("select filerealpath from ImageFile where imagefileid = "+delvalue);
				while(rs.next()){
					File file = new File(rs.getString("filerealpath"));
					if(file.exists()) file.delete();
				}
				rs.execute("delete from ImageFile where imagefileid = "+delvalue);
				
			}else if(fieldtype.equals("num")){
				sql = "update CRM_CustomerContacter set "+fieldname+"="+newvalue+" where id="+contacterid;
			}else if(fieldtype.equals("str")){
				sql = "update CRM_CustomerContacter set "+fieldname+"='"+newvalue+"' where id="+contacterid;
			}
			System.err.println(sql);
			rs.executeSql(sql);
		}
		
		//记录日志
		ProcPara = customerid+flag+"2"+flag+contacterid+flag+"0";
		ProcPara += flag+(String)fn.get(fieldname)+flag+CurrentDate+flag+CurrentTime+flag+oldvalue+flag+newvalue;
		ProcPara += flag+(user.getUID()+"")+flag+(user.getLogintype()+"")+flag+request.getRemoteAddr();
		rs.executeProc("CRM_Modify_Insert",ProcPara);
		
		ProcPara = customerid;
		ProcPara += flag+"mc";
		ProcPara += flag+"";
		ProcPara += flag+"";
		ProcPara += flag+CurrentDate;
		ProcPara += flag+CurrentTime;
		ProcPara += flag+(user.getUID()+"");
		ProcPara += flag+(user.getLogintype()+"");
		ProcPara += flag+request.getRemoteAddr();
		rs.executeProc("CRM_Log_Insert",ProcPara);
	}	
	
	//保存联系人照片
	if("".equals(operation)){
		FileUpload fu = new FileUpload(request);
		String method = Util.fromScreen3(fu.getParameter("method"),user.getLanguage());
		if(method.equals("savepic")){
			String contacterid = Util.fromScreen3(fu.getParameter("contacterid"),user.getLanguage());
			//判断是否有编辑权限
			if(!checkRight("",contacterid,userid,2)) return;
			String customerid = Util.fromScreen3(fu.getParameter("customerid"),user.getLanguage());
			String contacterimageid = Util.fromScreen3(fu.uploadFiles("contacterimageid"),user.getLanguage());
			contacterimageid = Util.getIntValue(contacterimageid,0)+"";
			//System.out.println("update CRM_CustomerContacter set contacterimageid="+contacterimageid+" where id = " + contacterid);
			rs.executeSql("update CRM_CustomerContacter set contacterimageid="+contacterimageid+" where id = " + contacterid);
			//记录日志
			ProcPara = customerid+flag+"2"+flag+contacterid+flag+"0";
			ProcPara += flag+(String)fn.get("contacterimageid")+flag+CurrentDate+flag+CurrentTime+flag+contacterimageid+flag+"0";
			ProcPara += flag+(user.getUID()+"")+flag+(user.getLogintype()+"")+flag+request.getRemoteAddr();
			rs.executeProc("CRM_Modify_Insert",ProcPara);
			%>
			<script>parent.setPic("<%=contacterimageid%>")</script>
			<%
		}
	}
	//删除联系人照片
	if("delpic".equals(operation)){
		String contacterid = Util.fromScreen3(request.getParameter("contacterid"),user.getLanguage());
		//判断是否有编辑权限
		if(!checkRight("",contacterid,userid,2)) return;
		String customerid = Util.fromScreen3(request.getParameter("customerid"),user.getLanguage());
		String contacterimageid = Util.fromScreen3(request.getParameter("contacterimageid"),user.getLanguage());
		rs.executeSql("update CRM_CustomerContacter set contacterimageid=0 where id = " + contacterid);
		//记录日志
		ProcPara = customerid+flag+"2"+flag+contacterid+flag+"0";
		ProcPara += flag+(String)fn.get("contacterimageid")+flag+CurrentDate+flag+CurrentTime+flag+contacterimageid+flag+"0";
		ProcPara += flag+(user.getUID()+"")+flag+(user.getLogintype()+"")+flag+request.getRemoteAddr();
		rs.executeProc("CRM_Modify_Insert",ProcPara);
	}
	if("delete".equals(operation)){
		String contacterid = Util.fromScreen3(request.getParameter("contacterid"),user.getLanguage());
		//判断是否有编辑权限
		if(!checkRight("",contacterid,userid,2)) return;
		
		rs.executeProc("CRM_CustomerContacter_SByID",contacterid);
		if(rs.getCounts()<=0) return;
		rs.first();
		String customerid = rs.getString(2);

		rs.executeProc("CRM_Find_CustomerContacter",customerid);
		if(rs.getCounts()<=1) return;
		rs.first();
		if(rs.getString(1).equals(contacterid)){
			rs.executeProc("CRM_CustomerContacter_Delete",contacterid);
			rs.next();

			ProcPara = customerid+flag+"2"+flag+rs.getString(1)+flag+"0";
			ProcPara += flag+SystemEnv.getHtmlLabelName(388,user.getLanguage())+flag+CurrentDate+flag+CurrentTime+flag+"0"+flag+"1";
			ProcPara += flag+(user.getUID()+"")+flag+(user.getLogintype()+"")+flag+request.getRemoteAddr();
			rs2.executeProc("CRM_Modify_Insert",ProcPara);
			rs2.executeProc("CRM_CustomerContacter_UMain",rs.getString(1)+flag+"1");
		}
		else
			rs2.executeProc("CRM_CustomerContacter_Delete",contacterid);

		ProcPara = customerid;
		ProcPara += flag+"dc";
		ProcPara += flag+"";
		ProcPara += flag+"";
		ProcPara += flag+CurrentDate;
		ProcPara += flag+CurrentTime;
		ProcPara += flag+(user.getUID()+"");
		ProcPara += flag+(user.getLogintype()+"");
		ProcPara += flag+request.getRemoteAddr();
		rs.executeProc("CRM_Log_Insert",ProcPara);
	}
	//读取日志明细
	if("get_log_count".equals(operation)){
		//无需判断权限
		String contacterid = Util.fromScreen3(request.getParameter("contacterid"),user.getLanguage());
		String customerid = Util.fromScreen3(request.getParameter("customerid"),user.getLanguage());
		rs.executeSql("select count(*) from CRM_Log t1,CRM_Modify t2" 
			+" where t1.submitdate=t2.modifydate and t1.submittime=t2.modifytime and t1.customerid=t2.customerid"
			+" and (t1.logtype='mc' or t1.logtype='nc') and t1.customerid="+customerid+" and t2.type="+contacterid);
		int count = 0;
		if(rs.next()) count = Util.getIntValue(rs.getString(1),0);
		restr.append(count);
	}
	if("get_log_list".equals(operation)){
		String contacterid = Util.fromScreen3(request.getParameter("contacterid"),user.getLanguage());
		//判断是否有查看权限
		if(!checkRight("",contacterid,userid,1)) return;
		String orderby1 = " order by submitdate desc,submittime desc";
		String orderby2 = " order by submitdate asc,submittime asc";
		String orderby3 = " order by t1.submitdate desc,t1.submittime desc";
		String customerid = Util.fromScreen3(request.getParameter("customerid"),user.getLanguage());
		int currentpage = Util.getIntValue(request.getParameter("currentpage"),0);
		int pagesize = Util.getIntValue(request.getParameter("pagesize"),0);
		int total = Util.getIntValue(request.getParameter("total"),0);
		String querysql = "t1.logtype,t1.documentid,t1.logcontent,t1.submitdate,t1.submittime,t1.submiter,t1.clientip,t1.submitertype"
			 +",t2.fieldname,t2.original,t2.modified from  CRM_Log t1,CRM_Modify t2"
			 +" where t1.submitdate=t2.modifydate and t1.submittime=t2.modifytime and t1.customerid=t2.customerid"
			 +" and (t1.logtype='mc' or t1.logtype='nc') and t1.customerid="+customerid+" and t2.type="+contacterid;
		int iTotal =total; 
		int iNextNum = currentpage * pagesize;
		int ipageset = pagesize;
		if(iTotal - iNextNum + pagesize < pagesize) ipageset = iTotal - iNextNum + pagesize;
		if(iTotal < pagesize) ipageset = iTotal;
		sql = "select top " + ipageset +" A.* from (select top "+ iNextNum + querysql+ orderby3 + ") A "+orderby2;
		sql = "select top " + ipageset +" B.* from (" + sql + ") B "+orderby1;
		//System.out.println(total+"---"+sql);
		rs.executeSql(sql);
		String logtxt = "";
		while(rs.next()){
			String contentmp = "";
			String modifytime = rs.getString("submittime");
			String modifydata = rs.getString("submitdate");
			String logtype = Util.null2String(rs.getString("logtype"));
			if(logtype.equals("nc")){
				logtxt="<font class='log_txt'>新建联系人";
			}else if(logtype.startsWith("mc")){
				logtxt="<font class='log_txt'>编辑";
			}else if(logtype.startsWith("d")){
				logtxt="<font class='log_txt'>删除";
			}
			logtxt += "</font> ";
			
			String fieldname = Util.null2String(rs.getString("fieldname"));
            String original = rs.getString("original");
			String modified = rs.getString("modified");
			String oldstr = "";
			String newstr = "";
			if(!"".equals(original)) {
				oldstr = SptmForCrmModiRecord.getCrmModiInfo(fieldname,original);
			}
			if(!"".equals(modified)) {
				newstr = SptmForCrmModiRecord.getCrmModiInfo(fieldname,modified);
			}
			if(!"".equals(oldstr) || !"".equals(newstr)) {
				if("".equals(oldstr)) oldstr = "&nbsp;&nbsp;";
                contentmp += "<font class='log_txt'>将</font> <font class='log_field'>"+fieldname+"</font> <font class='log_txt'>由</font> <font class='log_value'>'"+oldstr+"'</font> <font class='log_txt'>更新为</font> <font class='log_value'>'"+ newstr +"\"</font>";
			} else {
				if("".equals(original)) original = "&nbsp;&nbsp;";
				contentmp += "<font class='log_txt'>将</font> <font class='log_field'>"+fieldname+"</font> <font class='log_txt'>由</font> <font class='log_value'>'"+original+"'</font> <font class='log_txt'>更新为</font> <font class='log_value'>'"+ modified +"\"</font>";
			}
	        logtxt += contentmp;
%>
	<div class='logitem'>
		<%=cmutil.getHrm(rs.getString("submiter")) %>&nbsp;&nbsp;<font class='datetxt'><%=modifydata+" "+modifytime %></font>&nbsp;&nbsp;
		<%=logtxt %>
	</div>
<%
			
		} 
	}
	
	out.print(restr.toString());
	//out.close();
%>
<%!
	public String cutString(String str,String temp,int type){
		str = Util.null2String(str);
		temp = Util.null2String(temp);
		if(str.equals("") || temp.equals("")){
			return str;
		}
		if(type == 1 || type == 3){
			if(str.startsWith(temp)){
				str = str.substring(temp.length());
			}
		}
		if(type == 2 || type == 3){
			if(str.endsWith(temp)){
				str = str.substring(0,str.length()-temp.length());
			}
		}
		return str;
	}
	private boolean checkRight(String customerid,String contacterid,String userid,int level) throws Exception{
		CrmShareBase crmShareBase = new CrmShareBase();
		RecordSet rs = new RecordSet();
		if(!"".equals(contacterid)){
			rs.executeSql("select t.customerid from CRM_CustomerContacter t where t.id="+contacterid);
			if(rs.next()) customerid = Util.null2String(rs.getString(1)); 
		}
		if(!customerid.equals("")){
			//判断此客户是否存在
			rs.executeProc("CRM_CustomerInfo_SelectByID",customerid);
			if(!rs.next()){
				return false;
			}
			int sharelevel = crmShareBase.getRightLevelForCRM(userid,customerid);
			if(level==1){
				//判断是否有查看该客户商机权限
				if(sharelevel<1){
					return false;
				}
			}else{
				//判断是否有编辑该客户商机权限
				if(sharelevel<2){
					return false;
				}
				if(rs.getInt("status")==7 || rs.getInt("status")==8 || rs.getInt("status")==10){
					return false;
				}
			}
			return true;
		}
		return false;
	}
%>
