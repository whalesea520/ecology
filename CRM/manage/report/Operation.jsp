
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="java.text.*" %>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.hrm.resource.ResourceComInfo"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SellstatusComInfo" class="weaver.crm.sellchance.SellstatusComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="cmutil" class="weaver.workrelate.util.CommonTransUtil" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<%
	String operation = Util.fromScreen3(request.getParameter("operation"), user.getLanguage());
	String sql = "";
	StringBuffer restr = new StringBuffer();
	
	//获取商机数据
	if("get_sellchance".equals(operation)){
		String orderby1 = " order by createdate desc,createtime desc";
		String orderby2 = " order by createdate asc,createtime asc";
		String orderby3 = " order by t.createdate desc,t.createtime desc";
		int currentpage = Util.getIntValue(request.getParameter("currentpage"),0);
		int pagesize = Util.getIntValue(request.getParameter("pagesize"),0);
		int total = Util.getIntValue(request.getParameter("total"),0);
		//String querysql = URLDecoder.decode(Util.null2String(request.getParameter("querysql")),"utf-8");//.replaceAll("t3.createdate ' ' t3.createtime","t3.createdate+' '+t3.createtime").replaceAll("t2.operatedate ' ' t2.operatetime","t2.operatedate+' '+t2.operatetime");
		String querysql = (String)request.getSession().getAttribute("CRM_LIST_SQL");
		int iTotal =total; 
		int iNextNum = currentpage * pagesize;
		int ipageset = pagesize;
		if(iTotal - iNextNum + pagesize < pagesize) ipageset = iTotal - iNextNum + pagesize;
		if(iTotal < pagesize) ipageset = iTotal;
		sql = "select top " + ipageset +" A.* from (select top "+ iNextNum + querysql+ orderby3 + ") A "+orderby2;
		sql = "select top " + ipageset +" B.* from (" + sql + ") B "+orderby1;
		//System.out.println(total+"---"+sql);
		rs.executeSql(sql);
		int index = (currentpage-1) * pagesize;
		String _preyield = "";
		String _createdate = "";
		String _customerid = "";
		String _endtatusid = "";
		String _endtatusname = "";
		int _days = 0;
		int _nods = 0;
		while(rs.next()){
			index++;
			_preyield = comma(Util.getDoubleValue(rs.getString("preyield"),0)+"",2);
			_customerid = Util.null2String(rs.getString("customerid"));
			_createdate = Util.null2String(rs.getString("createdate"));
			_endtatusid = Util.null2String(rs.getString("endtatusid"));
			_days = TimeUtil.dateInterval(_createdate,TimeUtil.getCurrentDateString())+1;
			if(_endtatusid.equals("0")){
				//rs2.executeSql("select begindate from WorkPlan where type_n='3' and crmid ='"+_customerid+"' and begindate>='"+_createdate+"' group by begindate");
				//_nods = _days - rs2.getCounts();
				rs2.executeSql("select top 1 begindate from WorkPlan a "
						+" where a.type_n=3 and a.createrType='1' and a.crmid ='"+_customerid+"' and (a.sellchanceid="+rs.getString("id")+" or (a.sellchanceid is null and a.contacterid is null)) and a.begindate>='"+_createdate+"'"
						+" order by a.id desc");
				if(rs2.next()){
					_nods = TimeUtil.dateInterval(rs2.getString(1),TimeUtil.getCurrentDateString());
				}else{
					_nods = _days;
				}
			}else{
				if(_endtatusid.equals("1")){
					_endtatusname = "成功";
				}else if(_endtatusid.equals("2")){
					_endtatusname = "失败";
				}else if(_endtatusid.equals("3")){
					_endtatusname = "暂停";
				}else{
					_endtatusname = "";
				}
			}
	%>
		<tr class="item_tr">
			<td class='item_td' style="cursor: pointer;" width="*" onclick="showDetail('/CRM/manage/sellchance/SimpleView.jsp?id=<%=rs.getString("id")%>')"
					title="<%=Util.null2String(rs.getString("subject")) %>--><%=CustomerInfoComInfo.getCustomerInfoname(rs.getString("customerid")) %>">
				<%=Util.null2String(rs.getString("subject")) %>
			</td>
			<td width="60">
				<%if(_endtatusid.equals("0")){ %>
					<%if(_nods>0){%><font style="color: red" title="<%=_nods %>天未联系"><%=_nods %></font>/<%}%><font style="" title="商机已建立<%=_days %>天"><%=_days %></font>
				<%}else{ %>
					<%=_endtatusname %>
				<%} %>
			</td>
			<td width='70' style="text-align:left;" title="预期收益：<%=_preyield%>"><%=_preyield%></td>
			<td width='60' title="商机阶段：<%=SellstatusComInfo.getSellStatusname(Util.null2String(rs.getString("sellstatusid")))%>">
				<%=SellstatusComInfo.getSellStatusname(Util.null2String(rs.getString("sellstatusid")))%>
			</td>
			<td class='item_hrm' width='40'><%=cmutil.getHrm(rs.getString("creater")) %></td>
		</tr>
<%
		} 
	}//获取客户数据
	else if("get_customer".equals(operation)){
		String orderby1 = " order by createdate desc,id desc";
		String orderby2 = " order by createdate asc,id asc";
		String orderby3 = " order by t.createdate desc,t.id desc";
		int currentpage = Util.getIntValue(request.getParameter("currentpage"),0);
		int pagesize = Util.getIntValue(request.getParameter("pagesize"),0);
		int total = Util.getIntValue(request.getParameter("total"),0);
		//String querysql = URLDecoder.decode(Util.null2String(request.getParameter("querysql")),"utf-8");//.replaceAll("t3.createdate ' ' t3.createtime","t3.createdate+' '+t3.createtime").replaceAll("t2.operatedate ' ' t2.operatetime","t2.operatedate+' '+t2.operatetime");
		String querysql = (String)request.getSession().getAttribute("CRM_LIST_SQL");
		int iTotal =total; 
		int iNextNum = currentpage * pagesize;
		int ipageset = pagesize;
		if(iTotal - iNextNum + pagesize < pagesize) ipageset = iTotal - iNextNum + pagesize;
		if(iTotal < pagesize) ipageset = iTotal;
		sql = "select top " + ipageset +" A.* from (select top "+ iNextNum + querysql+ orderby3 + ") A "+orderby2;
		sql = "select top " + ipageset +" B.* from (" + sql + ") B "+orderby1;
		//System.out.println(total+"---"+sql);
		rs.executeSql(sql);
		int index = (currentpage-1) * pagesize;
		String contactdate = "";
		String contactstr = "";
		String contacttitle = "";
		String _customerid = "";
		String _manager = "";
		while(rs.next()){
			index++;
			_customerid = Util.null2String(rs.getString("id"));
			_manager = Util.null2String(rs.getString("manager"));
			
			rs2.executeSql("select top 1 begindate from WorkPlan a "
					+" where a.crmid ='"+_customerid+"' and a.createrType='1' and a.type_n=3 "
					+" order by a.id desc");
			if(rs2.next()){
				contactdate = Util.null2String(rs2.getString("begindate"));
			}else{
				contactdate = "";
			}
			if("".equals(contactdate)){
				contactstr = "<font style='color:red' title='无联系记录'>无记录</font>";
				contacttitle = "";
			}else{
				int days = TimeUtil.dateInterval(contactdate,TimeUtil.getCurrentDateString());
				if(days==0){
					contactstr = "<font style='color:green' title='今天已联系'>已联系</font>";
				}else{
					contactstr = "<font style='color:red' title='"+days+"天未联系'>"+days+"</font>";
				}
				//客户经理最后联系日期
				rs2.executeSql("select top 1 begindate from WorkPlan a"
						+" where a.crmid ='"+_customerid+"' and a.createrType='1' and a.type_n=3 and a.createrid="+_manager
						+" order by a.id desc");
				if(rs2.next()){
					int days2 = TimeUtil.dateInterval(rs2.getString(1),TimeUtil.getCurrentDateString());
					if(days2!=days){
						contactstr += "(<font style='color:red' title='负责人"+days2+"天未联系'>"+days2+"</font>)";
					}
				}else{
					contactstr += "(<font style='color:red' title='无负责人联系记录'>-</font>)";
				}
				
				contacttitle = "最后联系日期:"+contactdate;
				contactdate = contactdate.substring(5)+"|";
			}
	%>
		<tr class="item_tr">
			<td class='item_td' style="cursor: pointer;" width="*" onclick="showDetail('/CRM/manage/customer/SimpleView.jsp?CustomerID=<%=_customerid%>')"
					title="<%=CustomerInfoComInfo.getCustomerInfoname(_customerid) %>">
				<%=Util.null2String(rs.getString("name")) %>
			</td>
			<td width='120'><font title="<%=contacttitle %>"><%=contactdate%></font><%=contactstr%></td>
			<td class='item_hrm' width='40'><%=cmutil.getHrm(rs.getString("manager")) %></td>
		</tr>
<%
		} 
	}
	//获取联系人
	else if("get_contacter".equals(operation)){
		String orderby1 = " order by id desc";
		String orderby2 = " order by id asc";
		String orderby3 = " order by cc.id desc";
		int currentpage = Util.getIntValue(request.getParameter("currentpage"),0);
		int pagesize = Util.getIntValue(request.getParameter("pagesize"),0);
		int total = Util.getIntValue(request.getParameter("total"),0);
		//String querysql = URLDecoder.decode(Util.null2String(request.getParameter("querysql")),"utf-8");//.replaceAll("t3.createdate ' ' t3.createtime","t3.createdate+' '+t3.createtime").replaceAll("t2.operatedate ' ' t2.operatetime","t2.operatedate+' '+t2.operatetime");
		String querysql = (String)request.getSession().getAttribute("CRM_LIST_SQL");
		int iTotal =total; 
		int iNextNum = currentpage * pagesize;
		int ipageset = pagesize;
		if(iTotal - iNextNum + pagesize < pagesize) ipageset = iTotal - iNextNum + pagesize;
		if(iTotal < pagesize) ipageset = iTotal;
		sql = "select top " + ipageset +" A.* from (select top "+ iNextNum + querysql+ orderby3 + ") A "+orderby2;
		sql = "select top " + ipageset +" B.* from (" + sql + ") B "+orderby1;
		//System.out.println(total+"---"+sql);
		rs.executeSql(sql);
		int index = (currentpage-1) * pagesize;
		String _customerid = "";
		String _manager = "";
		while(rs.next()){
			index++;
			_customerid = Util.null2String(rs.getString("customerid"));
			_manager = Util.null2String(rs.getString("manager"));
	%>
		<tr class="item_tr">
			<td class='item_td' style="cursor: pointer;" width="60" onclick="showDetail('/CRM/manage/contacter/SimpleView.jsp?ContacterID=<%=rs.getString("id")%>')"
					title="<%=Util.null2String(rs.getString("firstname")) %>">
				<%=Util.null2String(rs.getString("firstname")) %>
			</td>
			<td class='item_td' style="cursor: pointer;" width="*" onclick="showDetail('/CRM/manage/customer/SimpleView.jsp?CustomerID=<%=_customerid%>')"
					title="<%=CustomerInfoComInfo.getCustomerInfoname(_customerid) %>">
				<%=CustomerInfoComInfo.getCustomerInfoname(_customerid) %>
			</td>
			<td class='item_hrm' width='40'><%=cmutil.getHrm(_manager) %></td>
		</tr>
<%
		} 
	}
	//获取客户数据
	else if("get_place".equals(operation)){
		int currentpage = Util.getIntValue(request.getParameter("currentpage"),0);
		int pagesize = Util.getIntValue(request.getParameter("pagesize"),0);
		int total = Util.getIntValue(request.getParameter("total"),0);
		int iscommafy = Util.getIntValue(request.getParameter("iscommafy"),0);
		int dp = Util.getIntValue(request.getParameter("dp"),0);
		String ym = Util.null2String(request.getParameter("ym"));
		int detailtype = Util.getIntValue(request.getParameter("detailtype"),1);
		int reporttype = Util.getIntValue(request.getParameter("reporttype"),1);
		int ordertype = Util.getIntValue(request.getParameter("ordertype"),1);//排序类型
		int stattype = Util.getIntValue(request.getParameter("stattype"),1);//统计类型
		String orderby1 = " order by value asc,hrm asc";
		String orderby2 = " order by value desc,hrm desc";
		String orderby3 = " order by value asc,hrm asc";
		if(ordertype==1){
		 	orderby1 = " order by value desc,hrm asc";
			orderby2 = " order by value asc,hrm desc";
			orderby3 = " order by value desc,hrm asc";
		}
		//String querysql = URLDecoder.decode(Util.null2String(request.getParameter("querysql")),"utf-8");//.replaceAll("t3.createdate ' ' t3.createtime","t3.createdate+' '+t3.createtime").replaceAll("t2.operatedate ' ' t2.operatetime","t2.operatedate+' '+t2.operatetime");
		String querysql = (String)request.getSession().getAttribute("CRM_PLACE_SQL");
		int iTotal =total; 
		int iNextNum = currentpage * pagesize;
		int ipageset = pagesize;
		if(iTotal - iNextNum + pagesize < pagesize) ipageset = iTotal - iNextNum + pagesize;
		if(iTotal < pagesize) ipageset = iTotal;
		sql = "select top " + ipageset +" A.* from (select top "+ iNextNum + querysql+ orderby3 + ") A "+orderby2;
		sql = "select top " + ipageset +" B.* from (" + sql + ") B "+orderby1;
		//System.out.println(total+"---"+sql);
		rs.executeSql(sql);
		int index = (currentpage-1) * pagesize;
		int temp=0;
		String value = "";
		boolean ismine = false;
		String hrm = "";
		while(rs.next()){
			index++;
			if(iscommafy==1){
				value = this.comma(Util.getDoubleValue(rs.getString("value"),0)+"",dp);
			}else{
				value = this.round(Util.getDoubleValue(rs.getString("value"),0)+"",dp);
			}
			if((reporttype==1 || reporttype==2) && detailtype==3){
				value += "%("+this.comma(Util.getDoubleValue(rs.getString("v1"),0)+"",0)+"/"+this.comma(Util.getDoubleValue(rs.getString("v2"),0)+"",0)+")";
			}
			hrm = Util.null2String(rs.getString("hrm"));
			if(stattype==1){
				if((user.getUID()+"").equals(hrm)) ismine=true; else ismine=false;
			}else{
				if((user.getUserDepartment()+"").equals(hrm)) ismine=true; else ismine=false;
			}
	%>
										<%if(temp%2==0){%><tr><%}%>
											<td <%if(ismine){%>style="background: #F6EABF"<%} %>>
											<%if(stattype==1){ %>
												<div class="listplace"><%=(iNextNum++)+1-10 %></div>
												<div style="width: 15%"><%=cmutil.getHrm(hrm) %></div>
												<div style="width: 20%;text-align: left;cursor: pointer;" onclick="loadDetail2('<%=ym %>','<%=hrm %>','<%=detailtype %>')" title="<%=value %>"><%=value %></div>
												<div style="width: 28%" title="<%=JobTitlesComInfo.getJobTitlesname(ResourceComInfo.getJobTitle(hrm))%>"
													><%=JobTitlesComInfo.getJobTitlesname(ResourceComInfo.getJobTitle(hrm))%></div>
												<div style="width: 28%" title="<%=SubCompanyComInfo.getSubCompanyname(ResourceComInfo.getSubCompanyID(hrm)) %>"
													><%=SubCompanyComInfo.getSubCompanyname(ResourceComInfo.getSubCompanyID(hrm)) %></div>
											<%}else{ %>
												<div class="listplace"><%=(iNextNum++)+1-10 %></div>
												<div style="width: 30%"><%=DepartmentComInfo.getDepartmentname(hrm) %></div>
												<div style="width: 20%;text-align: left;cursor: pointer;" onclick="loadDetail4('<%=ym %>','<%=hrm %>','<%=detailtype %>')" title="<%=value %>"><%=value %></div>
												<div style="width: 30%" title="<%=SubCompanyComInfo.getSubCompanyname(DepartmentComInfo.getSubcompanyid1(hrm)) %>"
													><%=SubCompanyComInfo.getSubCompanyname(DepartmentComInfo.getSubcompanyid1(Util.null2String(hrm))) %></div>
											<%} %>
											</td>
										<%if(temp%2!=0){%></tr><%}%>
	<%		temp++;
		}
	%>
	<%if(temp%2!=0){ %>
		<td></td></tr>
	<%} %>
<%
	}
	
	out.print(restr.toString());
	out.close();
%>
<%!
	private String getHrmLink(String id) throws Exception{
		String returnstr = "";
		if(!"".equals(id) && !"0".equals(id)){
			ResourceComInfo rc = new ResourceComInfo();
			returnstr = "<a href=javascript:searchList("+id+",'"+rc.getLastname(id)+"')>"+rc.getLastname(id)+"</a>";
		}else{
			returnstr = "&nbsp;";
		}
		return returnstr;
	}
	/**
	 * 对金额加入千分位符号
	 * @param s
	 * @param len
	 * @return
	 */
	public static String comma(String s,int len) {
		
		if (s == null || s.length() < 1) {
			return "";
		}
		NumberFormat formater = null;
		double num = Double.parseDouble(s);
		if (len == 0) {
			formater = new DecimalFormat("###,##0");
		} else {
			StringBuffer buff = new StringBuffer();
			buff.append("###,##0.");
			for (int i = 0; i < len; i++) {
				buff.append("0");
			}
			formater = new DecimalFormat(buff.toString());
		}
	
	    return formater.format(num);
	}	
	/**
	 * 对金额进行四舍五入
	 * @param s 金额字符串
	 * @param len 小数位数
	 * @return
	 */
	public static String round(String s,int len){
		if (s == null || s.length() < 1) {
			return "";
		}
		NumberFormat formater = null;
		double num = Double.parseDouble(s);
		if (len == 0) {
			formater = new DecimalFormat("##0");
		} else {
			StringBuffer buff = new StringBuffer();
			buff.append("##0.");
			for (int i = 0; i < len; i++) {
				buff.append("0");
			}
			formater = new DecimalFormat(buff.toString());
		}
		return formater.format(num);
	}
%>
