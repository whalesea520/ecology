
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.text.*"%>
<%@ page import="weaver.hrm.*,weaver.conn.ConnStatement,weaver.conn.ConnectionPool"%>
<%@ page import="java.sql.Connection,java.sql.SQLException,java.sql.Statement"%>
<%@ page import="weaver.general.*,weaver.conn.RecordSet"%>
<%@ page import="java.io.StringReader"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="net.sf.jsqlparser.parser.CCJSqlParserManager"%>
<%@ page import="net.sf.jsqlparser.statement.select.PlainSelect"%>
<%@ page import="net.sf.jsqlparser.statement.select.Select"%>
<%@ page import="net.sf.jsqlparser.statement.select.SelectItem"%>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="baseBean" class="weaver.general.BaseBean" scope="page"/>
<%
	
	request.setCharacterEncoding("UTF-8");

//281771,lv,[80]集成中心-解决SQL注入安全问题：管理员才能配置外部数据元素，需要具有系统设置权限。
User user = HrmUserVarify.getUser (request , response) ;
if(!HrmUserVarify.checkUserRight("SystemSetEdit:Edit", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

	String eid = Util.null2String(request.getParameter("eid"));
	String tabTitle = Util.null2String(request.getParameter("tabTitle"));
	String type = Util.null2String(request.getParameter("type"));
	String tabId = Util.null2String(request.getParameter("tabId"));
	String method = Util.null2String(request.getParameter("method"));
	//如果选择的是外部数据源的方式
	String addrUrl = Util.null2String(request.getParameter("addrUrl"));
	String addrId = Util.null2String(request.getParameter("addrId"));
	//如果选择的是自定义的方式
	String pattern = Util.null2String(request.getParameter("pattern"));
	String source = Util.null2String(request.getParameter("source"));
	String sysAddr = Util.null2String(request.getParameter("sysAddr"));//集成登录地址
	String area = Util.null2String(request.getParameter("area"));
	//QC231176  支持sql中存在单引号
	if(area.indexOf("'")>-1) {
		area = area.replaceAll("'","''");
	}
	String dataKey = Util.null2String(request.getParameter("dataKey"));
	String fieldname = Util.null2String(request.getParameter("fieldname"));
	String searchname = Util.null2String(request.getParameter("searchname"));
	String tempisshowname = Util.null2String(request.getParameter("isshowname"));
	String transql = Util.null2String(request.getParameter("transql"));
	transql=transql.replace("\n"," ");
	//选择webservice
	String wsaddress  = Util.null2String(request.getParameter("wsAddr"));
	String wsmethod  = Util.null2String(request.getParameter("wsMethod"));
	String wspara = Util.null2String(request.getParameter("wsPara"));
	
	String href = Util.null2String(request.getParameter("href"));
	
	Connection conn = null;
	Statement stmt = null;
	ConnectionPool pool = ConnectionPool.getInstance();
	conn = pool.getConnection();
	conn.setAutoCommit(false);
	stmt = conn.createStatement();
	try {
		if("checkSQL".equals(method)) {
			String msg = "0";
			String sqltext = Util.null2String(request.getParameter("sqltext"));
			String[] searchnames = searchname.split("#");
			try {
				CCJSqlParserManager parserManager = new CCJSqlParserManager();
		    	Select select = (Select) parserManager.parse(new StringReader(sqltext));
		    	PlainSelect plain = (PlainSelect) select.getSelectBody();
		        List<SelectItem> selectItems = plain.getSelectItems();
		        List<String> itemList = new ArrayList<String>();
				
		        if (selectItems != null) {
		            for(int i = 0; i < selectItems.size(); i++) {
		            	String tempItem = selectItems.get(i).toString();
		            	if(tempItem.indexOf("*") > -1) {
		            		out.print(msg);
		        			return;
		            	}
		            	itemList.add(tempItem.toLowerCase());
		            }
		            itemList.add(dataKey);
		            //System.err.println(itemList.toString());
		            for(int j = 0; j < searchnames.length; j++) {
		            	String tempName = searchnames[j].toLowerCase();
		            	boolean flag = false;
		            	for(int k = 0; k < itemList.size(); k++) {
		            		String tempItem = itemList.get(k);
		            		//System.err.println("tempItem="+tempItem+",searchnames["+j+"]="+tempName);
		            		if(tempItem.indexOf(tempName) > -1) {
		            			flag = true;
		            			break;
		            		}
		            	}
		            	if(!flag) {
		            		msg = "2";// SQL语句没有包含全部显示字段！
		            		out.print(msg);
		        			return;
		            	}
		            }
		        }
			} catch(Exception e) {
				msg = "1";// SQL语句不合法，请检查！
			}
			out.print(msg);
			return;
			
		} else if("delete".equals(method)) {
			String selectStr = "select * from hpOutDataTabSetting where eid="+eid + " and tabId="+tabId;
			rs.executeSql(selectStr);
			if(rs.next()) {
				type = rs.getString("type");
			}
			type = rs.getString("type");
			if ("1".equals(type)) {
				String delAddr = "delete from hpOutDataSettingAddr where eid="+eid +" and tabid="+tabId;
				stmt.addBatch(delAddr);
				String delTab = "delete from hpOutDataTabSetting where eid="+eid +" and tabid="+tabId;
				stmt.addBatch(delTab);
				//baseBean.writeLog(delTab);
			} else if("2".equals(type)) {//如果选择自定义的方式
				String delField = "delete from hpOutDataSettingField where eid="+eid +" and tabid="+tabId;
				stmt.addBatch(delField);
				String delPara = "delete from hpOutDataSettingDef where eid="+eid +" and tabid="+tabId;
				stmt.addBatch(delPara);
				String delTab = "delete from hpOutDataTabSetting where eid="+eid +" and tabid="+tabId;
				stmt.addBatch(delTab);
				//baseBean.writeLog(delTab);
			}
			session.setAttribute("outdataCurrentTab","1");
			
		} else {
			//判断tab页标题是否已经存在
			boolean isduplicate = false;
			if("add".equals(method) || "edit".equals(method)) {
					String titleStr = "select * from hpOutDataTabSetting where eid="+eid;
					rs.executeSql(titleStr);
				
				while(rs.next()) {
					if(tabTitle.equals(rs.getString("title"))) {
						isduplicate = true;
						break;
					}
				}
			}
			if("edit".equals(method)){	//编辑 标识不改的情况下不需要判断
				String titleStr = "select * from hpOutDataTabSetting where eid="+eid+" and tabid="+tabId;
				rs.executeSql(titleStr);
				if(rs.next()){
					if(tabTitle.equals(rs.getString("title"))) {
						isduplicate = false;
					}
				}
			}
		
			
			if ("1".equals(type) && !isduplicate) {
				
				String[] addrUrls = addrUrl.split("#");
				String[] addrIds = addrId.split("#"); 
				//每次设置 都更新一次外部数据源的登录地址
				String delAddr = "delete from hpOutDataSettingAddr where eid="+eid +" and tabid="+tabId;
				baseBean.writeLog(delAddr);
				stmt.addBatch(delAddr);
				for(int j = 0; j < addrIds.length; j++) {
					String insertAddr= "";
					if(j >addrUrls.length-1) {
						insertAddr = "insert into hpOutDataSettingAddr(eid,tabid,sourceid,pos) values"+
					 "(" + eid +","+tabId+",'"+addrIds[j]+"',"+j+")" ;
					} else {
						insertAddr = "insert into hpOutDataSettingAddr(eid,tabid,sourceid,address,pos) values"+
					 "(" + eid +","+tabId+","+addrIds[j]+",'"+addrUrls[j]+"',"+j+")" ;
					}
					
					stmt.addBatch(insertAddr);
					baseBean.writeLog(insertAddr);
				}
				String selectStr1 = "select * from hpOutDataTabSetting where eid="+eid +" and tabid="+tabId;
				rs.executeSql(selectStr1);
				baseBean.writeLog(selectStr1);
				if(rs.next()) {
					/* */
					if("2".equals(rs.getString("type"))) {
						String delField = "delete from hpOutDataSettingField where eid="+eid +" and tabid="+tabId;
						stmt.addBatch(delField);
						String delPara = "delete from hpOutDataSettingDef where eid="+eid +" and tabid="+tabId;
						stmt.addBatch(delPara);
						
					}
					String updateStr = "update hpOutDataTabSetting set title='"
					+tabTitle+"', type = '"+type+"' where eid="+eid +" and tabid="+tabId;
					stmt.addBatch(updateStr);
					//baseBean.writeLog(updateStr);
				} else {
					String insertsql = "insert into hpOutDataTabSetting(eid,tabid,title,type) values "+
					 "(" + eid +","+tabId+",'"+tabTitle+"',"+type+")" ;
					stmt.addBatch(insertsql);
					//baseBean.writeLog(insertsql);
				}
			} else if("2".equals(type) && !isduplicate) {
				//如果选择自定义的方式
				String[] fieldnames = fieldname.split("#");
				String[] searchnames = searchname.split("#");
				String[] tempisshownames = tempisshowname.split("#");
				String[] transqls = transql.split("#");
				
				//每次设置都更新一次字段设置
				String delPara = "delete from hpOutDataSettingField where eid="+eid +" and tabid="+tabId;
				stmt.addBatch(delPara);
				//baseBean.writeLog(delPara);
				for(int j = 0; j < searchnames.length; j++) {
					if(null == searchnames[j] || "".equals(searchnames[j])) {//如果字段为空，那么不保存该条记录
						continue;
					}
					String showfieldname2 = (j > (fieldnames.length-1) ? "":fieldnames[j]);
					String tempisshowname2 = (j > (tempisshownames.length-1) ? "":tempisshownames[j]);
					String transql2 = (j > (transqls.length-1) ? "":transqls[j]);
					//处理转换方法中含有单引号 进行转义处理
					if(transql2.indexOf("'")>-1){
						transql2=transql2.replaceAll("'","''");
					}
					String insertField = "insert into hpOutDataSettingField(eid,tabid,showfield,showfieldname,isshowname,transql) values "
						+"("+eid+","+tabId+",'"+searchnames[j]+"','"+showfieldname2+"','"+tempisshowname2+"','"+transql2+"')";
					stmt.addBatch(insertField);
					//baseBean.writeLog(insertField);
				}
				
				String selectStr1 = "select * from hpOutDataTabSetting where eid="+eid +" and tabid="+tabId;
				rs.executeSql(selectStr1);
				//baseBean.writeLog(selectStr1);
				if(rs.next()) {
					if("1".equals(rs.getString("type"))) {
						String delAddr = "delete from hpOutDataSettingAddr where eid="+eid +" and tabid="+tabId;
						stmt.addBatch(delAddr);
						String insertSql2 = "";
						
						insertSql2 = "insert into hpOutDataSettingDef(eid,tabid,pattern,source,area,dataKey,wsaddress,wsmethod,wspara,href,sysaddr) values ("
						+eid+","+tabId+",'"+pattern+"','"+source+"','"+area+"','"+dataKey+"','"+wsaddress+"','"+wsmethod+"','"+wspara+"','"+href+"','"+sysAddr+"')";
						stmt.addBatch(insertSql2);
						//baseBean.writeLog(insertSql2);
					} else {
						String updateStr2 ="";
						
						updateStr2 = "update hpOutDataSettingDef set pattern='"+pattern+"',source='"+source
						+"',area='"+area+"',dataKey='"+dataKey+"',wsaddress='"+wsaddress+"',wsmethod='"
						+wsmethod+"',wspara='"+wspara+"',href='"+href+"',sysaddr='"+sysAddr 
						+"' where eid="+eid+" and tabid="+tabId;
							
					//baseBean.writeLog(updateStr2);
						stmt.addBatch(updateStr2);
					}
					
					String updateStr = "update hpOutDataTabSetting set title='"
						+tabTitle+"', type = '"+type+"' where eid="+eid +" and tabid="+tabId;
					stmt.addBatch(updateStr);
					
					//baseBean.writeLog(updateStr2);
				} else {
					String insertsql = "insert into hpOutDataTabSetting(eid,tabid,title,type) values "+
					 "(" + eid +","+tabId+",'"+tabTitle+"',"+type+")" ;
					stmt.addBatch(insertsql);
					//baseBean.writeLog(insertsql);
					String insertSql2 ="insert into hpOutDataSettingDef(eid,tabid,pattern,source,area,dataKey,wsaddress,wsmethod,wspara,href,sysaddr) values ("
							+eid+","+tabId+",'"+pattern+"','"+source+"','"+area+"','"+dataKey+"','"+wsaddress+"','"+wsmethod+"','"+wspara+"','"+href+"','"+sysAddr+"')";
					stmt.addBatch(insertSql2);
					//baseBean.writeLog(insertSql2);
				}
			}
			
			if(isduplicate) {
				out.print("no");
			} else {
				out.print("ok");
			}
		}
		
		stmt.executeBatch();
		stmt.clearBatch();
		conn.commit();
		RecordSet rs_temp = new RecordSet();
		rs_temp.executeSql("select tabId from hpOutDataTabSetting where eid="+eid+" order by id");
		if(rs_temp.next()){
			String tabid_temp = Util.null2String(rs_temp.getString(1));
			session.setAttribute("outdataCurrentTab",tabid_temp);
		}
	}catch (SQLException e)
		{
			e.printStackTrace();
			out.print("no");
		}
		finally
		{
			if (null != stmt)
			{
				try
				{
					stmt.close();
				}
				catch (SQLException e)
				{
					// do nothing
				}
			}
			if (null != conn)
			{
				try
				{
					conn.close();
				}
				catch (SQLException e)
				{
					// do nothing
				}
			}
		}
%>
