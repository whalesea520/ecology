
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@page import="java.net.URLDecoder"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.hrm.resource.ResourceComInfo"%>
<%@ page import="weaver.conn.*"%>
<%@ page import="weaver.workrelate.util.*"%>
<%@ page import="weaver.docs.docs.*"%>
<%@ page import="weaver.crm.Maint.ContactWayComInfo"%>
<%@ page import="weaver.crm.sellchance.SellstatusComInfo"%>
<%@ page import="weaver.cm.base.ProductTypeComInfo"%>
<%@ page import="weaver.crm.CrmShareBase"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="cmutil" class="weaver.workrelate.util.CommonTransUtil" scope="page"/>
<jsp:useBean id="SellstatusComInfo" class="weaver.crm.sellchance.SellstatusComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page"/>
<jsp:useBean id="AssetUnitComInfo" class="weaver.lgc.maintenance.AssetUnitComInfo" scope="page"/>
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<jsp:useBean id="cmutil2" class="weaver.cs.util.CommonTransUtil" scope="page" />
<jsp:useBean id="SellChanceComInfo" class="weaver.cs.cominfo.SellChanceComInfo" scope="page" />
<%
	String operation = Util.fromScreen3(request.getParameter("operation"), user.getLanguage());
	String sql = "";
	StringBuffer restr = new StringBuffer();
	
	//获取列表数据
	if("get_list_data".equals(operation)){
		String orderby1 = " order by createdate desc,createtime desc";
		String orderby2 = " order by createdate asc,createtime asc";
		String orderby3 = " order by t.createdate desc,t.createtime desc";
		int currentpage = Util.getIntValue(request.getParameter("currentpage"),0);
		int pagesize = Util.getIntValue(request.getParameter("pagesize"),0);
		int total = Util.getIntValue(request.getParameter("total"),0);
		String endtatusid = Util.null2String(request.getParameter("endtatusid"));
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
		String _sellType = "";
		String _sellTypeTitle = "";
		String _att = "";
		String _createdate = "";
		String _customerid = "";
		int _days = 0;
		int _nods = 0;
		while(rs.next()){
			index++;
			_sellType = Util.null2String(rs.getString("sellType"));
			_att = Util.null2String(rs.getString("att"));
			if(_sellType.equals("1")){
				_sellType = "新签";
				_sellTypeTitle = "终端客户商机";
			}else if(_sellType.equals("2")){
				_sellType = "二次";
				_sellTypeTitle = "老客户二次商机";
			}else if(_sellType.equals("3")){
				_sellType = "压货";
				_sellTypeTitle = "代理压货商机";
			}else{
				_sellType = "&nbsp;";
				_sellTypeTitle = "";
			}
			_customerid = Util.null2String(rs.getString("customerid"));
			_createdate = Util.null2String(rs.getString("createdate"));
			_days = TimeUtil.dateInterval(_createdate,TimeUtil.getCurrentDateString())+1;
			if(endtatusid.equals("0")){
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
			}
			System.out.println("endtatusid:"+endtatusid);
	%>
		<tr id="item<%=rs.getString("id")%>" class="item_tr" _sellchanceid="<%=rs.getString("id")%>" _sellchancename="<%=rs.getString("subject")%>" _customerid="<%=rs.getString("customerid")%>" _lastdate="<%=rs.getString("createdate")%>">
			<%if(!_att.equals("")){%>
				<td class='td_move td_att' _index="<%=index%>" title="取消关注" _special="0" _sellchanceid="<%=rs.getString("id")%>">&nbsp;</td>
			<%}else{ %>
				<td class='td_move td_noatt' _index="<%=index%>" title="标记关注" _special="1" _sellchanceid="<%=rs.getString("id")%>"><%=index %></td>
			<%} %>
			<!-- <td class='item_td'><input readonly="readonly" onfocus="" onblur='' class="disinput" type="text" name="" id="<%=rs.getString("id") %>" title="<%=Util.null2String(rs.getString("subject")) %><%=CustomerInfoComInfo.getCustomerInfoname(rs.getString("customerid")) %>" value="<%=Util.null2String(rs.getString("subject")) %>" _index="<%=index %>"/></td> -->
			<td class='item_td'><div class="disinput" id="<%=rs.getString("id") %>" title="<%=Util.null2String(rs.getString("subject")) %>--><%=CustomerInfoComInfo.getCustomerInfoname(rs.getString("customerid")) %>" _index="<%=index %>"><%=Util.null2String(rs.getString("subject")) %></div></td>
			<td class=''>
				<%if(endtatusid.equals("0")){ %>
				<div><%if(_nods>0){%><font style="color: red" title="<%=_nods %>天未联系"><%=_nods %></font>/<%}%><font style="" title="商机已建立<%=_days %>天"><%=_days %></font></div>
				<%} %>
			</td>
			<td><div title="销售类型：<%=_sellTypeTitle %>"><%=_sellType %></div></td>
			<td><div title="预期收益：<%=Util.null2String(rs.getString("preyield"))%>"><%=Util.null2String(rs.getString("preyield"))%></div></td>
			<td><div title="商机阶段：<%=SellstatusComInfo.getSellStatusname(Util.null2String(rs.getString("sellstatusid")))%>"><%=SellstatusComInfo.getSellStatusname(Util.null2String(rs.getString("sellstatusid")))%></div></td>
			<td><div title="可能性：<%=Util.getDoubleValue(rs.getString("probability"),0)*100%>%"><%=Util.getDoubleValue(rs.getString("probability"),0)*100%>%</div></td>
			<td class='item_hrm' title=''><%=this.getHrmLink(rs.getString("creater")) %></td>
		</tr>
		<tr id="load_<%=rs.getString("id")%>_<%=_customerid%>" style="display: none">
			<td class='td_blank'>&nbsp;</td>
			<td colspan="7"><div style='width:20px;height:14px;background:url(../images/loading2_wev8.gif) center no-repeat'>&nbsp;</div></td>
		</tr>
<%
		} 
	}
	//设置商机数量及新商机提醒
	if("check_new".equals(operation)){
%>
		<script type="text/javascript">
			newMap = new Map();
<%
		String creater = Util.null2String(request.getParameter("creater"));
		String userid = user.getUID()+"";
		//String condition = cmutil2.getCustomerStr(user);
		String condition = "";
		//找到用户能看到的所有客户
		//如果属于总部级的CRM管理员角色，则能查看到所有客户。
		rs.executeSql("select id from HrmRoleMembers where  roleid = 8 and rolelevel = 2 and resourceid = " + userid);
		if (rs.next()) {
			condition = "(select id,name from CRM_CustomerInfo where (deleted=0 or deleted is null)) as customerIds";
		} else {
			String leftjointable = CrmShareBase.getTempTable(userid);
			condition = "(select distinct t1.id,t1.name "
				+ " from CRM_CustomerInfo t1 left join " + leftjointable + " t2 on t1.id = t2.relateditemid "
				+ " where t1.id = t2.relateditemid and (t1.deleted=0 or t1.deleted is null)) as customerIds";
		}
		
		String base = "select count(t.id) as amount from CRM_SellChance t join "+condition+" on t.customerid = customerIds.id";
		String self = " and (t.creater ="+creater+" or exists(select 1 from HrmResource hrm where hrm.id=t.creater and hrm.managerstr like '%,"+creater+",%'))";
		String where1 = base+" and t.endtatusid=0"+self;
		String where2 = base+" and t.endtatusid=0";
		
		List sqllist = new ArrayList();
		sqllist.add(where1); //本人
		sqllist.add(where1+" and exists (select 1 from CRM_Common_Remind r where r.operatetype=2 and r.objid=t.id)");//被提醒
		sqllist.add(where2+" and exists (select 1 from CRM_Common_Attention t2 where t.id=t2.objid and t2.operatetype=2 and t2.operator="+userid+")");//关注
		if(creater.equals(userid)){
			sqllist.add(where2+" and t.creater <> "+creater+" and not exists(select 1 from HrmResource hrm where hrm.id=t.creater and hrm.managerstr like '%,"+creater+",%')");//非本人
			sqllist.add(where2); //全部
		}else{
			sqllist.add("0");
			sqllist.add("0");
		}
		/**
		SellstatusComInfo.setTofirstRow();
		while(SellstatusComInfo.next()){
			sqllist.add(where1+" and t.sellstatusid="+SellstatusComInfo.getSellStatusid());
		}
		sqllist.add(base+self+" and t.endtatusid=1");
		sqllist.add(base+self+" and t.endtatusid=2");
		//联系
		String wpcond = " and not exists (select 1 from WorkPlan a where a.crmid=convert(varchar,t.customerid) "
				+" and (a.sellchanceid=t.id or (a.sellchanceid is null and a.contacterid is null))"
				+" and a.type_n=3 and a.createrType='1'";
		//String wpcond = "w.crmid=convert(varchar,t.customerid) and (w.sellchanceid=t.id or (w.sellchanceid is null and w.contacterid is null))";
		sqllist.add(where1 + wpcond+" and a.createrid=t.creater and a.begindate>='"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-3)+"')"
			+" and t.createdate<'"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-3)+"'");
		sqllist.add(where1 + wpcond+" and a.createrid=t.creater and a.begindate>='"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-7)+"')"
			+" and t.createdate<'"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-7)+"'");
		sqllist.add(where1 + wpcond+" and a.createrid=t.creater and a.begindate>='"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-14)+"')"
			+" and t.createdate<'"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-14)+"'");
		sqllist.add(where1 + wpcond+" and a.createrid=t.creater and a.begindate>='"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-30)+"')"
			+" and t.createdate<'"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-30)+"'");
		sqllist.add(where1 + wpcond+" and a.createrid=t.creater and a.begindate>='"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-90)+"')"
			+" and t.createdate<'"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-90)+"'");
		sqllist.add(where1 + wpcond+" and a.createrid=t.creater and a.begindate>='"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-180)+"')"
			+" and t.createdate<'"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-180)+"'");
		sqllist.add(where1 + wpcond+" and a.createrid=t.creater and a.begindate>='"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-360)+"')"
			+" and t.createdate<'"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-360)+"'");
		
		sqllist.add(where1 + wpcond+" and a.begindate>='"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-3)+"')"
			+" and t.createdate<'"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-3)+"'");
		sqllist.add(where1 + wpcond+" and a.begindate>='"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-7)+"')"
			+" and t.createdate<'"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-7)+"'");
		sqllist.add(where1 + wpcond+" and a.begindate>='"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-14)+"')"
			+" and t.createdate<'"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-14)+"'");
		sqllist.add(where1 + wpcond+" and a.begindate>='"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-30)+"')"
			+" and t.createdate<'"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-30)+"'");
		sqllist.add(where1 + wpcond+" and a.begindate>='"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-90)+"')"
			+" and t.createdate<'"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-90)+"'");
		sqllist.add(where1 + wpcond+" and a.begindate>='"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-180)+"')"
			+" and t.createdate<'"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-180)+"'");
		sqllist.add(where1 + wpcond+" and a.begindate>='"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-360)+"')"
			+" and t.createdate<'"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-360)+"'");
		*/
		String sqlstr = "";
		int amount = 0;
		for(int i=0;i<sqllist.size();i++){
			sqlstr = Util.null2String((String)sqllist.get(i));
			if(sqlstr.equals("0")){
%>
				newMap.put("cond<%=i+1%>","0");
<%					
			}else{
				amount = 0;
				rs.executeSql(sqlstr);
				if(rs.next()) amount = Util.getIntValue(rs.getString(1),0);
				//System.out.println(amount+":"+sqlstr);
%>
				newMap.put("cond<%=i+1%>","<%=amount%>");
<%		
			}
		}
%>
		</script>
<%			
	}
	
	Map fn = new HashMap();
	fn.put("manager","客户经理");
	fn.put("subject","商机名称");
	fn.put("customerid","相关客户");
	fn.put("content","中介机构");
	fn.put("source","商机来源");
	fn.put("selltype","商机类型");
	fn.put("endtatusid","商机状态");
	fn.put("predate","销售预期");
	fn.put("preyield","预期收益");
	fn.put("probability","可能性");
	fn.put("sellstatusid","商机阶段");
	fn.put("description","综合性描述");
	fn.put("remark","成功关键因素(风险)");
	fn.put("fileids","启动原因及需求");
	fn.put("fileids_","启动代理的原因");
	fn.put("fileids2","复盘文件");
	fn.put("fileids3","报价书/合同书");
	fn.put("product","产品");
	fn.put("producttype","产品类型");
	fn.put("ploytype","打单策略类型");
	fn.put("ploydesc","打单策略描述");
	fn.put("ploydesc_","代理成交的关键策略");
	
	//新建商机
	if("add_sellchance".equals(operation)){
		String customerid = Util.null2String(request.getParameter("customer"));
		//权限判断
		if(!checkRight(customerid,"",user.getUID()+"",2)) return;
		
		String subject = Util.null2String(request.getParameter("subject"));
		String creater = Util.null2String(request.getParameter("creater"));
		String content = Util.null2String(request.getParameter("agent"));
		String source = Util.null2String(request.getParameter("source"));
		String preselldate = Util.null2String(request.getParameter("preselldate"));
		double preyield = Util.getDoubleValue(request.getParameter("preyield"),0)*10000;
		double probability = Util.getDoubleValue(request.getParameter("probability"),0)/100;
		String fileids = Util.fromScreen(request.getParameter("relatedacc"),user.getLanguage());
		fileids = cutString(fileids,",",3);
		String remark = Util.convertInput2DB(request.getParameter("remark"));
		String producttype = Util.null2String(request.getParameter("producttype"));
		String ploytype = Util.null2String(request.getParameter("ploytype"));
		String ploydesc = Util.convertInput2DB(request.getParameter("ploydesc"));
		String sellstatusid = "1";
		String endtatusid = "0";
		int selltype = Util.getIntValue(request.getParameter("selltype"),1);
		String sellchanceid="";
		
		String currentdate = TimeUtil.getCurrentDateString();
		String currenttime = TimeUtil.getOnlyCurrentTimeString();
		
		sql = "insert into CRM_SellChance (subject,customerid,creater,content,source,predate,preyield,probability,fileids,remark,sellstatusid,endtatusid,selltype,createuserid,createdate,createtime,updatedate,updatetime,producttype,ploytype,ploydesc)"
			+" values('"+subject+"',"+customerid+","+creater+",'"+content+"',"+source+",'"+preselldate+"',"+preyield+","+probability+",'"+fileids+"','"+remark+"',"+sellstatusid+","+endtatusid+","+selltype+","+user.getUID()+",'"+currentdate+"','"+currenttime+"','"+currentdate+"','"+currenttime+"'"
					+","+producttype+",'"+ploytype+"','"+ploydesc+"')";
		boolean success = rs.executeSql(sql);
		if(success){
			rs.executeSql("select max(id) from CRM_SellChance");
			if(rs.next()){
				sellchanceid = rs.getString(1);
				this.writeLog(user,1,sellchanceid,"","","",fn);
				
				//增加客服平台销售机会
				if(cmutil2.hasPrincipal(customerid)){
					String productTypeId = producttype;
					if(producttype.equals("1")) productTypeId = "2";
					if(producttype.equals("2")) productTypeId = "1";
					String isConfirm = "0";
					if(HrmUserVarify.checkUserRight("CS_SellChanceConfirm:Confirm", user)){
						isConfirm = "1";
					}
					char separator = Util.getSeparator();
					StringBuffer para = new StringBuffer();
					para.append(customerid + separator);
					para.append(subject + separator);
					para.append(creater + separator);
					para.append("" + separator);
					para.append(creater + separator);
					para.append(ResourceComInfo.getSubCompanyID(creater) + separator);
					para.append(productTypeId + separator);
					para.append(subject + separator);
					para.append("" + separator);
					para.append("" + separator);
					para.append("" + separator);
					para.append(String.valueOf(preyield) + separator);
					para.append("" + separator);
					para.append("" + separator);
					para.append(preselldate + separator);
					para.append("0" + separator);
					para.append(String.valueOf(probability) + separator);
					para.append(isConfirm + separator);
					para.append("0" + separator);
					para.append("" + separator);
					para.append("0" + separator);
					para.append(sellchanceid);
					
					rs.executeProc("CS_CustomerSellChance_Insert", para.toString());
					if(rs.next()){
						String chanceId = Util.null2String(rs.getString(1));
						//记录日志
						para = new StringBuffer();
						para.append(chanceId + separator);
						para.append(currentdate + separator);
						para.append(currenttime + separator);
						para.append("" + user.getUID() + separator);
						para.append(user.getLoginip() + separator);
						para.append("1");//新增
				
						rs.executeProc("CS_CustomerSellChanceLog_Insert", para.toString());
						//增加缓存
						SellChanceComInfo.addComInfo(chanceId);
					}
				}
			}
		}
%>
		<script type="text/javascript">
			if(opener != null && opener.onRefresh != null){opener.onRefresh();}
			window.location="SellChanceView.jsp?id=<%=sellchanceid%>";
		</script>
<%
		//response.sendRedirect("SellChanceView.jsp?id="+sellchanceid);
		return;
	}
	//编辑商机字段
	if("edit_sellchance_field".equals(operation)){
		String sellchanceid = Util.fromScreen3(request.getParameter("sellchanceid"),user.getLanguage());
		//权限判断
		if(!checkRight("",sellchanceid,user.getUID()+"",2)) return;
		
		String fieldname = URLDecoder.decode(Util.fromScreen3(request.getParameter("fieldname"),user.getLanguage()),"utf-8");
		String oldvalue = Util.convertInput2DB(URLDecoder.decode(request.getParameter("oldvalue"),"utf-8"));
		String newvalue = Util.convertInput2DB(URLDecoder.decode(request.getParameter("newvalue"),"utf-8"));
		String fieldtype = Util.fromScreen3(request.getParameter("fieldtype"),user.getLanguage());
		String setid = Util.fromScreen3(request.getParameter("setid"),user.getLanguage());
		if(fieldname.equals("agent")) fieldname = "content";
		if(newvalue.endsWith("ids") && newvalue.equals(",")){
			newvalue = "";
		}
		if(fieldname.equals("manager")){
			rs.executeSql("update CRM_SellChance set creater="+newvalue+" where id="+sellchanceid);
			//记录日志
			restr.append(this.writeLog(user,2,sellchanceid,"manager",oldvalue,newvalue,fn));
		}else if(fieldname.equals("fileids") || fieldname.equals("fileids2") || fieldname.equals("fileids3") || !setid.equals("")){//附件
			String oldfileids = "";
			if(setid.equals("")){
				rs.executeSql("select "+fieldname+" from CRM_SellChance where id="+sellchanceid);
			}else{
				rs.executeSql("select remark from CRM_SellChance_Other where type=4 and setid="+setid+" and sellchanceid="+sellchanceid);
			}
			if(rs.next()){
				oldfileids = Util.null2String(rs.getString(1));
			}
			if(fieldtype.equals("del")){
				int docid = Util.getIntValue(newvalue); 
				String delfilename = "";
				
				DocImageManager.resetParameter();
	            DocImageManager.setDocid(docid);
	            DocImageManager.selectDocImageInfo();
	            if(DocImageManager.next()) delfilename = DocImageManager.getImagefilename();
				
				DocManager dm = new DocManager();
				dm.setId(docid);
				dm.setUserid(user.getUID());
				dm.DeleteDocInfo();
				
				int index = oldfileids.indexOf(","+newvalue+",");
				if(index>-1){
					oldfileids = oldfileids.substring(0,index+1)+ oldfileids.substring(index+newvalue.length()+2);
					if(setid.equals("")){
						rs.executeSql("update CRM_SellChance set "+fieldname+"='"+oldfileids+"' where id="+sellchanceid);
					}else{
						rs.executeSql("update CRM_SellChance_Other set remark='"+oldfileids+"' where type=4 and setid="+setid+" and sellchanceid="+sellchanceid);
					}
					//记录日志
					this.writeLog(user,4,sellchanceid,fieldname,"",delfilename,fn);
				}
			}else{
				newvalue = cmutil.cutString(newvalue,",",3);
				if(!"".equals(newvalue)) {
					if("".equals(oldfileids)) oldfileids = ",";
					oldfileids = oldfileids + newvalue + ",";
					rs.executeSql("update CRM_SellChance set "+fieldname+"='"+oldfileids+"' where id="+sellchanceid);
					//记录日志
					this.writeLog(user,9,sellchanceid,fieldname,"",newvalue,fn);
				}
			}
			List fileidList = Util.TokenizerString(oldfileids,",");
			for(int i=0;i<fileidList.size();i++){
				DocImageManager.resetParameter();
	            DocImageManager.setDocid(Integer.parseInt((String)fileidList.get(i)));
	            DocImageManager.selectDocImageInfo();
	            DocImageManager.next();
	            String docImagefileid = DocImageManager.getImagefileid();
	            int docImagefileSize = DocImageManager.getImageFileSize(Util.getIntValue(docImagefileid));
	            String docImagefilename = DocImageManager.getImagefilename();
				restr.append("<div class='txtlink txtlink"+fileidList.get(i)+"' onmouseover='showdel(this)' onmouseout='hidedel(this)'>");
				restr.append("<div style='float: left;'>");
				restr.append("<a href=javaScript:openFullWindowHaveBar('/CRM/manage/util/ViewDoc.jsp?id=" + fileidList.get(i)+"&sellchanceid="+sellchanceid+"')>"+docImagefilename+"</a>");
				restr.append("&nbsp;<a href='/CRM/manage/util/ViewDoc.jsp?id="+fileidList.get(i)+"&sellchanceid="+sellchanceid+"&fileid="+docImagefileid+"'>下载("+docImagefileSize/1000+"K)</a>");
				restr.append("</div>");
				restr.append("<div class='btn_del' onclick=doDelItem('"+fieldname+"','"+fileidList.get(i)+"','"+setid+"')></div>");
				restr.append("<div class='btn_wh'></div>");
				restr.append("</div>");
			}
			
		}else{
			if(fieldname.equals("preyield")||fieldname.equals("probability")||fieldtype.equals("num")){
				if(fieldname.equals("preyield")){
					newvalue = Util.getDoubleValue(newvalue,0)*10000+"";
					oldvalue = Util.getDoubleValue(oldvalue,0)*10000+"";
				}
				if(fieldname.equals("probability")){
					newvalue = Util.getDoubleValue(newvalue,0)/100+"";
					oldvalue = Util.getDoubleValue(oldvalue,0)/100+"";
				}
				
				if(fieldname.equals("endtatusid") && newvalue.equals("2")){
					String opptid = Util.convertInput2DB(URLDecoder.decode(request.getParameter("delvalue"),"utf-8"));
					String opptname = Util.convertInput2DB(URLDecoder.decode(request.getParameter("addvalue"),"utf-8"));
					sql = "update CRM_SellChance set endtatusid=2,opptid="+opptid+",opptname='"+opptname+"' where id="+sellchanceid;
					rs.executeSql(sql);
					this.writeLog(user,2,sellchanceid,fieldname,oldvalue,newvalue,fn);
					return;
				}else{
					sql = "update CRM_SellChance set "+fieldname+"="+newvalue+" where id="+sellchanceid;
				}
			}else if(fieldtype.equals("str")){
				String updatename = fieldname;
				if(fieldname.equals("ploydesc_")){
					updatename = "ploydesc";
				}
				sql = "update CRM_SellChance set "+updatename+"='"+newvalue+"' where id="+sellchanceid;
			}
			rs.executeSql(sql);
			
			String addvalue = Util.convertInput2DB(URLDecoder.decode(request.getParameter("addvalue"),"utf-8"));
			String delvalue = Util.convertInput2DB(URLDecoder.decode(request.getParameter("delvalue"),"utf-8"));
			if(!addvalue.equals("")){
				//记录日志
				this.writeLog(user,3,sellchanceid,fieldname,"",cmutil.cutString(addvalue,",",3),fn);
			}else if(!delvalue.equals("") && !fieldname.equals("ploytype")){
				//记录日志
				this.writeLog(user,4,sellchanceid,fieldname,"",cmutil.cutString(delvalue,",",3),fn);
			}else{
				if(fieldname.equals("ploytype")){
					String ploytypeids = newvalue;
					newvalue = Util.convertInput2DB(URLDecoder.decode(request.getParameter("delvalue"),"utf-8"));
					String ploytypenames = newvalue;
					List ploytypeidList = Util.TokenizerString(ploytypeids,",");
					List ploytypenameList = Util.TokenizerString(ploytypenames,",");
					for(int i=0;i<ploytypeidList.size();i++){
						if(!"".equals(ploytypeidList.get(i))){
%>
				<div class='txtlink txtlink<%=ploytypeidList.get(i) %>' onmouseover='showdel(this)' onmouseout='hidedel(this)'>
					<div style='float: left;'>
						<%=ploytypenameList.get(i) %>
					</div>
					<div class='btn_del' onclick="doDelItem('ploytype','<%=ploytypeidList.get(i) %>')"></div>
					<div class='btn_wh'></div>
				</div>
<%						}
					}
				}
				//记录日志
				this.writeLog(user,2,sellchanceid,fieldname,oldvalue,newvalue,fn);
			}
		}
	}
	
	//编辑其他信息
	if("edit_sellchance_other".equals(operation)){
		String sellchanceid = Util.fromScreen3(request.getParameter("sellchanceid"),user.getLanguage());
		//权限判断
		if(!checkRight("",sellchanceid,user.getUID()+"",2)) return;
		
		String batchid = Util.fromScreen3(request.getParameter("batchid"),user.getLanguage());
		String setid = Util.fromScreen3(request.getParameter("setid"),user.getLanguage());
		String type = Util.fromScreen3(request.getParameter("type"),user.getLanguage());
		String oldvalue = Util.convertInput2DB(URLDecoder.decode(request.getParameter("oldvalue"),"utf-8"));
		String newvalue = Util.convertInput2DB(URLDecoder.decode(request.getParameter("newvalue"),"utf-8"));
		String item = Util.convertInput2DB(URLDecoder.decode(request.getParameter("item"),"utf-8"));
		String index = Util.fromScreen3(request.getParameter("index"),user.getLanguage());
		String fieldname = "remark";
		if(index.equals("4")) fieldname = "remark2";
		
		String _type = type.substring(0,1);
		String sqlwhere = "";
		if(!batchid.equals("")) sqlwhere = " and batchid="+batchid;
		if(type.equals("8")){
			rs.executeSql("update CRM_SellChance_Other set remark2='"+newvalue+"' where convert(varchar,remark)='"+item+"' and sellchanceid="+sellchanceid+" and type=8");
		}else{
			rs.executeSql("update CRM_SellChance_Other set "+fieldname+"='"+newvalue+"' where setid="+setid+" and sellchanceid="+sellchanceid+" and type="+_type+sqlwhere);
		}
			
		this.writeLog(user,2,sellchanceid,item,oldvalue,newvalue,fn);
	}
	//编辑是否有对应商机
	if("edit_sellchance_relchance".equals(operation)){
		String sellchanceid = Util.fromScreen3(request.getParameter("sellchanceid"),user.getLanguage());
		//权限判断
		if(!checkRight("",sellchanceid,user.getUID()+"",2)) return;
		
		String updatetype = Util.fromScreen3(request.getParameter("updatetype"),user.getLanguage());
		String newvalue = Util.convertInput2DB(URLDecoder.decode(request.getParameter("newvalue"),"utf-8"));
		String oldvalue = Util.convertInput2DB(URLDecoder.decode(request.getParameter("oldvalue"),"utf-8"));
		if(updatetype.equals("1")){
			rs.executeSql("update CRM_SellChance_Other set remark2='"+newvalue+"' where convert(varchar,remark)='是否已有OA商机合作' and sellchanceid="+sellchanceid+" and type=8");
			this.writeLog(user,2,sellchanceid,"是否已有OA商机合作",oldvalue,newvalue,fn);
		}else{
			rs.executeSql("update CRM_SellChance_Other set opptid="+newvalue+" where convert(varchar,remark)='是否已有OA商机合作' and sellchanceid="+sellchanceid+" and type=8");
			String newvalue_ = Util.convertInput2DB(URLDecoder.decode(request.getParameter("newvalue_"),"utf-8"));
			this.writeLog(user,2,sellchanceid,"对应商机",oldvalue,newvalue_,fn);
		}
	}
	
	//添加友商信息
	if("add_oppt".equals(operation)){
		String sellchanceid = Util.fromScreen3(request.getParameter("sellchanceid"),user.getLanguage());
		//权限判断
		if(!checkRight("",sellchanceid,user.getUID()+"",2)) return;
		
		String opptid = Util.fromScreen3(request.getParameter("opptid"),user.getLanguage());
		String opptname = URLDecoder.decode(Util.null2String(request.getParameter("opptname")),"utf-8");
		String default1 = URLDecoder.decode(Util.null2String(request.getParameter("default1")),"utf-8");
		String default2 = URLDecoder.decode(Util.null2String(request.getParameter("default2")),"utf-8");
		int batchid = 0;
		rs.executeSql("select max(batchid) from CRM_SellChance_Other");
		if(rs.next()){
			batchid = Util.getIntValue(rs.getString(1)) + 1;
		}
		rs.executeSql("select t1.id as setid,t1.item from CRM_SellChance_Set t1 where t1.infotype=2 order by id");
		while(rs.next()){
			String setid = Util.null2String(rs.getString("setid"));
			rs2.executeSql("insert into CRM_SellChance_Other(sellchanceid,setid,type,remark,remark2,opptid,opptname,batchid)"
					+" values("+sellchanceid+","+setid+",6,'','',"+opptid+",'',"+batchid+")");
			%>
			<tr class="opptitem oppt<%=batchid %>">
				<td class="title2">
					<%=Util.null2String(rs.getString("item")).trim() %><font style="color: #BFBFBF !important;font-size: 10px;">---客户方印象及评价</font>
				</td>
				<td>
					<textarea id="apply_<%=setid %>_<%=opptid %>_<%=batchid %>" name="apply_<%=setid %>_<%=opptid %>_<%=batchid %>" _batchid="<%=batchid %>" _type="6" _setid="<%=setid %>" _index="7" class="other_input input_blur" style="width:95%;overflow: auto;margin-top:2px;margin-bottom:2px;vertical-align: middle"
					><%=default1 %></textarea>
				</td>
				<td class="title2">
					<%=Util.null2String(rs.getString("item")).trim() %><font style="color: #BFBFBF !important;font-size: 10px;">---应对策略</font>
				</td>
				<td>
					<textarea id="apply2_<%=setid %>_<%=opptid %>_<%=batchid %>" name="apply2_<%=setid %>_<%=opptid %>_<%=batchid %>" _batchid="<%=batchid %>" _type="61" _setid="<%=setid %>" _index="8" class="other_input input_blur" style="width:95%;overflow: auto;margin-top:2px;margin-bottom:2px;vertical-align: middle"
					><%=default2 %></textarea>
				</td>
			</tr>
			<%
		}
			
		this.writeLog(user,3,sellchanceid,"友商优劣势分析","",opptname,fn);
		restr.append("$"+batchid);
	}
	
	//编辑友商名称信息
	if("edit_opptname".equals(operation)){
		String sellchanceid = Util.fromScreen3(request.getParameter("sellchanceid"),user.getLanguage());
		//权限判断
		if(!checkRight("",sellchanceid,user.getUID()+"",2)) return;
		
		String batchid = Util.fromScreen3(request.getParameter("batchid"),user.getLanguage());
		String oldvalue = Util.convertInput2DB(URLDecoder.decode(request.getParameter("oldvalue"),"utf-8"));
		String newvalue = Util.convertInput2DB(URLDecoder.decode(request.getParameter("newvalue"),"utf-8"));
		
		rs.executeSql("update CRM_SellChance_Other set opptname='"+newvalue+"' where sellchanceid="+sellchanceid+" and batchid="+batchid);
			
		restr.append(this.writeLog(user,2,sellchanceid,"友商名称",oldvalue,newvalue,fn));
	}
	//删除友商信息
	if("del_oppt".equals(operation)){
		String sellchanceid = Util.fromScreen3(request.getParameter("sellchanceid"),user.getLanguage());
		//权限判断
		if(!checkRight("",sellchanceid,user.getUID()+"",2)) return;
		
		String batchid = Util.fromScreen3(request.getParameter("batchid"),user.getLanguage());
		String opptname = URLDecoder.decode(Util.null2String(request.getParameter("opptname")),"utf-8");
		
		rs.executeSql("delete from CRM_SellChance_Other where sellchanceid="+sellchanceid+" and batchid="+batchid);
			
		restr.append(this.writeLog(user,4,sellchanceid,"友商优劣势分析","",opptname,fn));
	}
	
	//编辑产品明细
	if("edit_product_detail".equals(operation)){
		String sellchanceid = Util.fromScreen3(request.getParameter("sellchanceid"),user.getLanguage());
		//权限判断
		if(!checkRight("",sellchanceid,user.getUID()+"",2)) return;
		
		String redid = Util.fromScreen3(request.getParameter("redid"),user.getLanguage());
		String productid = Util.fromScreen3(request.getParameter("productid"),user.getLanguage());
		String assetunitid = Util.fromScreen3(request.getParameter("assetunitid"),user.getLanguage());
		String currencyid = Util.fromScreen3(request.getParameter("currencyid"),user.getLanguage());
		double salesprice = Util.getDoubleValue(request.getParameter("salesprice"),0);
		double salesnum = Util.getDoubleValue(request.getParameter("salesnum"),0);
		double totelprice = salesprice*salesnum;
		String oldvalue = Util.convertInput2DB(URLDecoder.decode(request.getParameter("oldvalue"),"utf-8"));
		String newvalue = Util.convertInput2DB(URLDecoder.decode(request.getParameter("newvalue"),"utf-8"));
		
		if(redid.equals("")){//新增
			sql = "insert into CRM_ProductTable(sellchanceid,productid,assetunitid,currencyid,salesprice,salesnum,totelprice)"
				+" values("+sellchanceid+","+productid+","+assetunitid+","+currencyid+","+salesprice+","+salesnum+","+totelprice+")";
			rs.executeSql(sql);
			rs.executeSql("select max(id) from CRM_ProductTable where sellchanceid="+sellchanceid);
			if(rs.next()) redid = Util.null2String(rs.getString(1));
			this.writeLog(user,3,sellchanceid,"product",oldvalue,newvalue,fn);
%>
												<tr id="product_<%=redid %>" class="oppttitle">
													<td class="title3" colspan="2">
														<div class="btn_browser3" onclick="onShowProduct('<%=redid%>')"></div>
														<div class="txt_browser" id='productidSpan_<%=redid %>'><a href="/lgc/asset/LgcAsset.jsp?paraid=<%=productid%>" target="_blank">
															<%=Util.toScreen(AssetComInfo.getAssetName(productid),user.getLanguage())%></a>
														</div>
														<input type=hidden id='productid_<%=redid%>' name='productid_<%=redid%>' value='<%=productid%>' />
													</td>
													<td>
														<span id='assetunitidSpan_<%=redid %>'><%=Util.toScreen(AssetUnitComInfo.getAssetUnitname(assetunitid),user.getLanguage())%></span>         			
             											<input type=hidden id='assetunitid_<%=redid%>' name='assetunitid_<%=redid%>' value='<%=assetunitid%>' />
								             		</td>
								             		<td>
								             			<div class="btn_browser3" onclick="onShowCurrency('<%=redid%>'')"></div>
														<div class="txt_browser" id='currencyidSpan_<%=redid %>'>
															<%=Util.toScreen(CurrencyComInfo.getCurrencyname(currencyid),user.getLanguage())%>
														</div>
														<input type=hidden id='currencyid_<%=redid%>' name='currencyid_<%=redid%>' value='<%=currencyid%>' />
								             		</td>
								             		<td>
								             			<input class='pro_input' id='salesprice_<%=redid%>' name='salesprice_<%=redid%>' onkeypress='ItemNum_KeyPress()' onblur="checknumber(this)" _redid="<%=redid %>" _fieldname="salesprice" value='<%=salesprice%>'/>
								             		</td>
								             		<td>
								             			<input class='pro_input' id='salesnum_<%=redid%>' name='salesnum_<%=redid%>' onkeypress='ItemNum_KeyPress()' onblur="checknumber(this)" _redid="<%=redid %>" _fieldname="salesnum" value='<%=salesnum%>'/>
								             		</td>
								             		<td>
								             			<span id='totelprice_<%=redid%>' name='totelprice_<%=redid%>'>
								             				<%=totelprice%>
								             			</span>
								             		</td>
								             		<td align="right">
								             			<div class="opptdel" onclick="delProduct('<%=redid %>',this)" title="删除"></div>	
								             		</td>
								             	</tr>
<%
		}else{//编辑
			sql = "update CRM_ProductTable set productid="+productid+",assetunitid="+assetunitid+",currencyid="+currencyid+",salesprice="+salesprice+",salesnum="+salesnum+",totelprice="+totelprice
				+" where sellchanceid="+sellchanceid+" and id="+redid;
			rs.executeSql(sql);
			this.writeLog(user,2,sellchanceid,"product",oldvalue,newvalue,fn);
		}
	}
	//编辑产品明细字段
	if("edit_product_field".equals(operation)){
		String sellchanceid = Util.fromScreen3(request.getParameter("sellchanceid"),user.getLanguage());
		//权限判断
		if(!checkRight("",sellchanceid,user.getUID()+"",2)) return;
		
		String redid = Util.fromScreen3(request.getParameter("redid"),user.getLanguage());
		String fieldname = Util.fromScreen3(request.getParameter("fieldname"),user.getLanguage());
		String fieldvalue = Util.fromScreen3(request.getParameter("fieldvalue"),user.getLanguage());
		String totalvalue = Util.fromScreen3(request.getParameter("totalvalue"),user.getLanguage());
		String oldvalue = Util.convertInput2DB(URLDecoder.decode(request.getParameter("oldvalue"),"utf-8"));
		String newvalue = Util.convertInput2DB(URLDecoder.decode(request.getParameter("newvalue"),"utf-8"));
		String where = "";
		if(!totalvalue.equals("")){
			where += ",totelprice="+totalvalue;
		}
		rs.executeSql("update CRM_ProductTable set "+fieldname+"="+fieldvalue+where+" where sellchanceid="+sellchanceid+" and id="+redid);
		this.writeLog(user,2,sellchanceid,"product",oldvalue,newvalue,fn);
	}
	//删除产品明细
	if("del_product_detail".equals(operation)){
		String sellchanceid = Util.fromScreen3(request.getParameter("sellchanceid"),user.getLanguage());
		//权限判断
		if(!checkRight("",sellchanceid,user.getUID()+"",2)) return;
		
		String redid = Util.fromScreen3(request.getParameter("redid"),user.getLanguage());
		String newvalue = Util.convertInput2DB(URLDecoder.decode(request.getParameter("newvalue"),"utf-8"));
		rs.executeSql("delete from CRM_ProductTable where sellchanceid="+sellchanceid+" and id="+redid);
		this.writeLog(user,4,sellchanceid,"product","",newvalue,fn);
	}
	//添加查看日志
	if("add_log_view".equals(operation)){
		String sellchanceid = Util.fromScreen3(request.getParameter("sellchanceid"),user.getLanguage());
		//权限判断
		if(!checkRight("",sellchanceid,user.getUID()+"",1)) return;
		this.writeLog(user,0,sellchanceid,"","","",fn);
	}
	//读取日志明细
	if("get_log_count".equals(operation)){
		String sellchanceid = Util.fromScreen3(request.getParameter("sellchanceid"),user.getLanguage());
		//无需权限判断
		rs.executeSql("select count(id) from CRM_SellChanceLog where sellchanceid="+sellchanceid);
		int count = 0;
		if(rs.next()) count = Util.getIntValue(rs.getString(1),0);
		restr.append(count);
	}
	if("get_log_list".equals(operation)){
		String sellchanceid = Util.fromScreen3(request.getParameter("sellchanceid"),user.getLanguage());
		//权限判断
		if(!checkRight("",sellchanceid,user.getUID()+"",1)) return;
		
		String orderby1 = " order by operatedate desc,operatetime desc,id desc";
		String orderby2 = " order by operatedate asc,operatetime asc,id asc";
		String orderby3 = " order by operatedate desc,operatetime desc,id desc";
		int currentpage = Util.getIntValue(request.getParameter("currentpage"),0);
		int pagesize = Util.getIntValue(request.getParameter("pagesize"),0);
		int total = Util.getIntValue(request.getParameter("total"),0);
		String querysql = "id,type,operator,operatedate,operatetime,operatefield,oldvalue,newvalue from CRM_SellChanceLog where sellchanceid="+sellchanceid;
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
		String fieldtxt = "";
		int type = 0;
		while(rs.next()){
			String fieldname = Util.null2String(rs.getString("operatefield"));
			String oldvaltxt = Util.toHtml(Util.convertDbInput(rs.getString("oldvalue")));
			oldvaltxt = getLink(fieldname,oldvaltxt);
			String newvaltxt = Util.toHtml(Util.convertDbInput(rs.getString("newvalue")));
			newvaltxt = getLink(fieldname,newvaltxt);
			fieldtxt = Util.null2String((String)fn.get(fieldname));
			if(fieldtxt.equals("")) fieldtxt = fieldname;
			type = Util.getIntValue(rs.getString("type"));
			switch(type){
				case 0:logtxt="<font class='log_txt'>查看商机</font>";break;
				case 1:logtxt="<font class='log_txt'>新建商机</font>";break;
				case 2:logtxt="<font class='log_txt'>将</font> <font class='log_field'>"+fieldtxt+"</font> <font class='log_txt'>由</font> <font class='log_value'>'"+oldvaltxt+"'</font> <font class='log_txt'>更新为</font> <font class='log_value'>'"+newvaltxt+"'</font>";break;
				case 3:logtxt="<font class='log_txt'>添加</font> <font class='log_field'>"+fieldtxt+"</font> <font class='log_value'>'"+newvaltxt+"'</font>";break;
				case 4:logtxt="<font class='log_txt'>删除</font> <font class='log_field'>"+fieldtxt+"</font> <font class='log_value'>'"+newvaltxt+"'</font>";break;
				case 5:logtxt="<font class='log_txt'>提醒商机</font>";break;
				case 6:logtxt="<font class='log_txt'>标记关注</font>";break;
				case 7:logtxt="<font class='log_txt'>取消关注</font>";break;
				case 8:logtxt="";break;
				case 9:logtxt="<font class='log_txt'>上传</font> <font class='log_field'>"+fieldtxt+"</font> <font class='log_value'>'"+newvaltxt+"'</font>";break;
			}
%>
	<div class='logitem'>
		<%=cmutil.getHrm(rs.getString("operator")) %>&nbsp;&nbsp;<font class='datetxt'><%=Util.null2String(rs.getString("operatedate"))+" "+Util.null2String(rs.getString("operatetime")) %></font>&nbsp;&nbsp;
		<%=logtxt %>
	</div>
<%
			
		} 
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
	/**
	* type  0:查看 1:新建  2:编辑内容  3:新增内容  4:删除内容 5:进行 6:成功  7:失败  8:删除
	*/
	private String writeLog(User user,int type,String sellchanceid,String field,String oldvalue,String newvalue,Map fn){
		RecordSet rs = new RecordSet();
		String currentdate = TimeUtil.getCurrentDateString();
		String currenttime = TimeUtil.getOnlyCurrentTimeString();
		if(type!=0){
			rs.executeSql("update CRM_SellChance set updateuserid="+user.getUID()+",updatedate='"+currentdate+"',updatetime='"+currenttime+"' where id="+sellchanceid);
		}
		rs.executeSql("insert into CRM_SellChanceLog (sellchanceid,type,operator,operatedate,operatetime,operatefield,oldvalue,newvalue)"
				+" values("+sellchanceid+","+type+","+user.getUID()+",'"+currentdate+"','"+currenttime+"','"+field+"','"+oldvalue+"','"+newvalue+"')");
		return getlogtext(user.getUID()+"",currentdate+" "+currenttime,type,field,oldvalue,newvalue,fn);
	}
	private String getlogtext(String userid,String datetime,int type,String field,String oldvalue,String newvalue,Map fn){
		String logtxt = "<div class='logitem'>"+getLink("hrmid",userid+"")+"&nbsp;&nbsp;<font class='datetxt'>"+datetime+"</font>&nbsp;&nbsp;";
		String oldvaltxt = getLink(field,oldvalue);
		String newvaltxt = getLink(field,newvalue);
		switch(type){
			case 0:logtxt+="查看商机";break;
			case 1:logtxt+="新建商机";break;
			case 2:logtxt+="将"+fn.get(field)+"由为'"+oldvaltxt+"'更新为'"+newvaltxt+"'";break;
			case 3:logtxt+="添加"+fn.get(field)+"&nbsp;&nbsp;"+newvaltxt;break;
			case 4:logtxt+="删除"+fn.get(field)+"&nbsp;&nbsp;"+newvaltxt;break;
			case 5:logtxt+="设置为进行中";break;
			case 6:logtxt+="设置为成功";break;
			case 7:logtxt+="设置为失败";break;
			case 8:logtxt+="删除商机";break;
			case 9:logtxt+="上传"+fn.get(field)+"&nbsp;&nbsp;"+newvaltxt;break;
		}
		logtxt += "</div>";
		return logtxt;
	}
	private String getLink(String field,String value){
		String returnstr = "";
		CommonTransUtil cmutil = new CommonTransUtil();
		if("hrmid".equals(field)||"manager".equals(field)){
			return cmutil.getHrm(value);
		}else if("customer".equals(field)||"content".equals(field)){
			return cmutil.getCustomer(value);
		}else if("source".equals(field)){
			ContactWayComInfo contactWayComInfo = null;
			try{
				contactWayComInfo = new ContactWayComInfo();
			}catch(Exception e){
				
			}
			return contactWayComInfo.getContactWayname(value);
		}else if("selltype".equals(field)){
			if("1".equals(value)) returnstr = "终端客户商机";
			if("2".equals(value)) returnstr = "老客户二次商机";
			if("2".equals(value)) returnstr = "代理压货商机";
			return returnstr;
		}else if("endtatusid".equals(field)){
			if("0".equals(value)) returnstr = "紧跟";
			if("1".equals(value)) returnstr = "成功";
			if("2".equals(value)) returnstr = "失败";
			if("3".equals(value)) returnstr = "暂停";
			if("4".equals(value)) returnstr = "培育";
			return returnstr;
		}else if("sellstatusid".equals(field)){
			SellstatusComInfo sellstatusComInfo = null;
			try{
				sellstatusComInfo = new SellstatusComInfo();
			}catch(Exception e){
				
			}
			return sellstatusComInfo.getSellStatusname(value);
		}else if("producttype".equals(field)){
			ProductTypeComInfo productTypeComInfo = null;
			try{
				productTypeComInfo = new ProductTypeComInfo();
			}catch(Exception e){
				
			}
			return productTypeComInfo.getName(value);
		}else{
			return value;
		}
	}
	private boolean checkRight(String customerid,String sellchanceid,String userid,int level) throws Exception{
		CrmShareBase crmShareBase = new CrmShareBase();
		RecordSet rs = new RecordSet();
		if(!"".equals(sellchanceid)){
			rs.executeSql("select t.customerid from CRM_SellChance t where t.id="+sellchanceid);
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
