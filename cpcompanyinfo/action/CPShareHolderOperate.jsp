<%@page import="weaver.cpcompanyinfo.ProManageUtil"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="java.net.URLDecoder"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>

<jsp:useBean id="jspUtil" class="weaver.cpcompanyinfo.JspUtil" scope="page" />
<jsp:useBean id="pro" class="weaver.cpcompanyinfo.ProManageUtil" scope="page" />
<%@page import="weaver.general.TimeUtil"%>
<%@page import="weaver.cpcompanyinfo.CpShareHolder"%>
<%@page import="weaver.cpcompanyinfo.CpShareOfficers"%>
<%@page import="weaver.conn.RecordSet"%>

<%@page import="org.dom4j.Element" %>
<%@page import="org.dom4j.Document" %>
<%@page import="org.dom4j.DocumentHelper" %>
<%@page import="org.dom4j.DocumentException" %>
<%@page import="java.io.IOException" %>
<%@page import="java.io.StringWriter" %>
<%@page import="org.dom4j.io.XMLWriter" %>
<%@page import="org.dom4j.io.OutputFormat" %>


<%@ page import="net.sf.json.*"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs02" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs03" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs04" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="companyMagager" class="weaver.company.CompanyManager" scope="page" />
<%
	String method = Util.null2String(request.getParameter("method"));
	//System.out.println("股东会"+method);
	String companyid = Util.null2String(request
			.getParameter("companyid"));
	//System.out.println("companyid"+companyid);
	StringBuffer strSql = new StringBuffer();

	String now = Util.date(2);

	String createdatetime = now;

	String boardshareholder = Util.null2String(request
			.getParameter("boardshareholder"));
	String established = Util.null2String(request
			.getParameter("established"));
	String affixdoc = Util.null2String(request
			.getParameter("affixdoc"));
	
	String versionnum =Util.null2String(request.getParameter("versionnum"));
	String versionname = Util.null2String(request.getParameter("versionname"));
	String versionmemo = Util.null2String(request.getParameter("versionmemo"));
	String versionaffix = Util.null2String(request.getParameter("versionaffix"));
	
	String isaddversion =  Util.null2String(request.getParameter("isaddversion"));
	String date2Version = Util.null2String(request.getParameter("date2Version")); 
	
	//-------------编码转换-----------------
	boardshareholder = URLDecoder.decode(boardshareholder, "utf-8");
	established = URLDecoder.decode(established, "utf-8");
	affixdoc = URLDecoder.decode(affixdoc, "utf-8");
	
	versionnum = ProManageUtil.fetchString(URLDecoder.decode(versionnum,"utf-8"));
	versionname = URLDecoder.decode(versionname,"utf-8");
	versionmemo = URLDecoder.decode(versionmemo,"utf-8");
	versionaffix = URLDecoder.decode(versionaffix,"utf-8");
	isaddversion = URLDecoder.decode(isaddversion,"utf-8");
	date2Version = URLDecoder.decode(date2Version,"utf-8");
	
	String lastupdatetime = now;
	//List tempids = new ArrayList();
	//companyMagager.tempids
	
	if ("add".equals(method)) {
		//------------得到 request 值--------------
		//插入股东的基本信息-----------------------------------start
		strSql.setLength(0);
		strSql.append(" insert into CPSHAREHOLDER ");
		strSql
				.append(" (companyid,boardshareholder,established,createdatetime,lastupdatetime,isdel,shareaffix)");
		strSql.append(" values ('" + companyid + "','" + boardshareholder
				+ "','" + established + "',");
		strSql.append(" '" + createdatetime + "','" + lastupdatetime
				+ "','T','"+affixdoc+"')");
		
		rs.execute(strSql.toString());
		//插入股东的基本信息-----------------------------------end
		
		String listgdcy = Util
				.null2String(request.getParameter("data"));
		int shareid =0;
		//String cpparentid = "";
		//得到刚插入的股东的id
		strSql.setLength(0);
		strSql.append(" select shareid from CPSHAREHOLDER where companyid="+ companyid);

			rs.execute(strSql.toString());
			if (rs.next()) {
				
				shareid = rs.getInt("shareid");
					org.json.JSONObject o4JsonArr2gd=null;
					
					//判断股东关系A-B公司关系是否发生变化--start
					String oldcompanyid="";
					String newcompanyid="";
					if (!"".equals(listgdcy)) {
							listgdcy = URLDecoder.decode(listgdcy, "utf-8");
							o4JsonArr2gd = new org.json.JSONObject(listgdcy);
							for (int i = 0; i < o4JsonArr2gd.length(); i++) {
										String companyid2share = o4JsonArr2gd.getJSONObject("tr" + i).getString("companyid2share");
										if(!"".equals(companyid2share)){
											newcompanyid+=companyid2share+",";
										}
							}
					}
					rs.execute("select companyid from CPSHAREOFFICERS where shareid in("+shareid+")");
					while(rs.next()){
							if(!"".equals(rs.getString("companyid"))){
								oldcompanyid+=rs.getString("companyid")+",";
							}
					}
					if(!jspUtil.CheckStr(oldcompanyid, newcompanyid)){
						//说明股东关系发生了变化，需要更新A-B公司的关系
						rs.execute("update CPCOMPANYINFOAB set status='u' ");
						//更改标志位，用于线程扫描更新数据
					}
					//判断股东关系A-B公司关系是否发生变化--end
				
				if (!"".equals(listgdcy)) {
				String cpparentid = "";
				//绑定股东公司到当前公司
				for (int i = 1; i < o4JsonArr2gd.length(); i++) {
					String officername = o4JsonArr2gd.getJSONObject(
							"tr" + i).getString("officername");
					//System.out.println(officername);
					String isstop = o4JsonArr2gd
							.getJSONObject("tr" + i)
							.getString("isstop");
					String aggregateinvest = o4JsonArr2gd
							.getJSONObject("tr" + i).getString(
									"aggregateinvest");
					String aggregatedate = o4JsonArr2gd.getJSONObject(
							"tr" + i).getString("aggregatedate");
					String investment =Util.getFloatValue(o4JsonArr2gd.getJSONObject(
							"tr" + i).getString("investment"),0)+"";
					String companyid2share = o4JsonArr2gd.getJSONObject(
							"tr" + i).getString("companyid2share");
					String currencyid = o4JsonArr2gd.getJSONObject(
							"tr" + i).getString("currencyid");
					String ishow = o4JsonArr2gd.getJSONObject(
							"tr" + i).getString("ishow");
					strSql.setLength(0);
					strSql
							.append(" insert into CPSHAREOFFICERS (shareid,officername,isstop,aggregateinvest,aggregatedate,investment,companyid,currencyid,ishow) values");
					strSql.append(" ('" + shareid + "','" + officername
							+ "','" + isstop + "','" + aggregateinvest
							+ "','" + aggregatedate + "','"
							+ investment + "','"+companyid2share+"','"+currencyid+"','"+ishow+"')");
					rs.execute(strSql.toString());
					String spsql = "select cpparentid from cpcompanyinfo where companyid='"+companyid2share+"'";
					rs.execute(spsql);
					if(rs.next()){
						cpparentid=cpparentid+companyid2share+",";
						
					}
				}
				strSql.setLength(0);
				strSql.append("update cpcompanyinfo set cpparentid='"+cpparentid+"' where companyid='"+companyid+"'");
				//System.out.println(strSql.toString());
				rs.execute(strSql.toString());
			}
		}
		//如果是保存版本
		if(isaddversion.equals("add")){
			strSql.setLength(0);
			strSql.append("insert into CPSHAREHOLDERVERSION (shareid,versionnum,versionname,versionmemo,versionaffix,Createdatetime,");
			strSql.append("companyid,boardshareholder,established,shareaffix)");
			strSql.append(" values ('"+shareid+"','"+versionnum+"','"+versionname+"','"+versionmemo+"','"+versionaffix+"','"+date2Version+"',");
			strSql.append(" '" + companyid + "','" + boardshareholder
					+ "','" + established + "','"+affixdoc+"')");
			rs.execute(strSql.toString());	
			//更新通知-添加
			String upsql = "insert into CPCOMPANYUPGRADE (UPTYPE,UPVERSION,CREATEDATETIME,discription,companyid) values ('director','"+versionnum+"','"+now+"','"+SystemEnv.getHtmlLabelName(1421,user.getLanguage())+"："+SystemEnv.getHtmlLabelName(30944,user.getLanguage())+"-["+versionnum+"]',"+companyid+")";
			rs.execute(upsql);
			if (!"".equals(listgdcy)) {
				listgdcy = URLDecoder.decode(listgdcy, "utf-8");
				org.json.JSONObject o4JsonArr2gd = new org.json.JSONObject(
						listgdcy);
				for (int i = 1; i < o4JsonArr2gd.length(); i++) {
					String officername = o4JsonArr2gd.getJSONObject(
							"tr" + i).getString("officername");
					//System.out.println(officername);
					String isstop = o4JsonArr2gd
							.getJSONObject("tr" + i)
							.getString("isstop");
					String aggregateinvest = o4JsonArr2gd
							.getJSONObject("tr" + i).getString(
									"aggregateinvest");
					String aggregatedate = o4JsonArr2gd.getJSONObject(
							"tr" + i).getString("aggregatedate");
					String investment = Util.getFloatValue(o4JsonArr2gd.getJSONObject(
							"tr" + i).getString("investment"),0)+"";
					String companyid2share = o4JsonArr2gd.getJSONObject(
							"tr" + i).getString("companyid2share");
					String currencyid = o4JsonArr2gd.getJSONObject(
							"tr" + i).getString("currencyid");
					String ishow = o4JsonArr2gd.getJSONObject(
							"tr" + i).getString("ishow");
					strSql.setLength(0);
					strSql
							.append(" insert into CPSHAREOFFICERSVERSION (shareid,officername,isstop,aggregateinvest,aggregatedate,investment,companyid,currencyid,versionnum,VERSIONTYPE,ishow) values");
					strSql.append(" ('" + shareid + "','" + officername
							+ "','" + isstop + "','" + aggregateinvest
							+ "','" + aggregatedate + "','"
							+ investment + "','"+companyid2share+"','"+currencyid+"','"+versionnum+"','gd','"+ishow+"')");
					rs.execute(strSql.toString());
				}
			}
		}
		//companyMagager.froWheelTree(companyid);
		//out.print(this.getSumInvestment(companyid));
		pro.writeCompanylog("3",companyid,"1",user.getUID()+"",""+SystemEnv.getHtmlLabelNames("30944",user.getLanguage()));
		out.clear();
		out.print("0");
} else if ("edit".equals(method)) {
		if(!ProManageUtil.checkEdition("share", "", companyid, versionnum)){
				String shareid = Util.null2String(request.getParameter("shareid"));
				String listgdcy = Util.null2String(request.getParameter("data"));		
			
				
				org.json.JSONObject o4JsonArr2gd=null;
				//判断股东关系A-B公司关系是否发生变化--start
				String oldcompanyid="";
				String newcompanyid="";
				if (!"".equals(listgdcy)) {
						listgdcy = URLDecoder.decode(listgdcy, "utf-8");
						o4JsonArr2gd = new org.json.JSONObject(listgdcy);
						for (int i = 1; i < o4JsonArr2gd.length(); i++) {
									String companyid2share = o4JsonArr2gd.getJSONObject("tr" + i).getString("companyid2share");
									if(!"".equals(companyid2share)){
										newcompanyid+=companyid2share+",";
									}
						}
				}
				rs.execute("select companyid from CPSHAREOFFICERS where shareid in("+shareid+")");
				//System.out.println("newcompanyid=="+newcompanyid);
				while(rs.next()){
						if(!"".equals(rs.getString("companyid"))){
							oldcompanyid+=rs.getString("companyid")+",";
						}
				}
				boolean ched=false;
				if(!jspUtil.CheckStr(oldcompanyid, newcompanyid)){
					//说明股东关系发生了变化，需要更新A-B公司的关系
					rs.execute("update CPCOMPANYINFOAB set status='u' ");
					//更改标志位，用于线程扫描更新数据
					ched=true;
				}
				//判断股东关系A-B公司关系是否发生变化--end
		
				if(isaddversion.equals("add")){
					String sqlmax = "select max(versionnum) as versionnum from CPSHAREHOLDERVERSION where SHAREID="+shareid;
					rs.execute(sqlmax);
					//System.out.println("第一次"+sqlmax);
					String maxnum = "";
					if(rs.next())maxnum = Util.null2String(rs.getString("versionnum"));
				
					//System.out.println("maxnum="+maxnum);
					//System.out.println("versionnum="+versionnum);
					//System.out.println("maxnum="+maxnum.compareTo(versionnum));
					if(maxnum.equals("") || maxnum.compareTo(versionnum)<0){
						strSql.setLength(0);
						strSql.append(" update CPSHAREHOLDER set boardshareholder='"
								+ boardshareholder + "',established='" + established
								+ "',shareaffix='"+affixdoc+"',");
						strSql.append(" lastupdatetime='" + lastupdatetime
								+ "' where shareid=" + shareid);
						//System.out.println(strSql.toString());
						rs.execute(strSql.toString());
						//System.out.println("第二次"+strSql);
						strSql.setLength(0);
						strSql.append(" delete from CPSHAREOFFICERS where shareid="
								+ shareid);
						//System.out.println("第三次"+strSql);
						rs.execute(strSql.toString());
						if (!"".equals(listgdcy)) {
							String cpparentid = "";
							//listgdcy = URLDecoder.decode(listgdcy, "utf-8");
							//org.json.JSONObject o4JsonArr2gd = new org.json.JSONObject(listgdcy);
							for (int i = 1; i < o4JsonArr2gd.length(); i++) {
								String officername = o4JsonArr2gd.getJSONObject(
										"tr" + i).getString("officername");
								//System.out.println(officername);
								String isstop = o4JsonArr2gd.getJSONObject("tr" + i)
										.getString("isstop");
								String aggregateinvest = o4JsonArr2gd.getJSONObject(
										"tr" + i).getString("aggregateinvest");
								String aggregatedate = o4JsonArr2gd.getJSONObject(
										"tr" + i).getString("aggregatedate");
								String investment =Util.getFloatValue( o4JsonArr2gd
										.getJSONObject("tr" + i)
										.getString("investment"),0)+"";
								String companyid2share = o4JsonArr2gd.getJSONObject(
										"tr" + i).getString("companyid2share");
							//	System.out.println("companyid2share======"+companyid2share);
								String currencyid = o4JsonArr2gd.getJSONObject(
										"tr" + i).getString("currencyid");
								String ishow = o4JsonArr2gd.getJSONObject(
										"tr" + i).getString("ishow");
								strSql.setLength(0);
								strSql
										.append(" insert into CPSHAREOFFICERS (shareid,officername,isstop,aggregateinvest,aggregatedate,investment,companyid,currencyid,ishow) values");
								strSql.append(" (" + shareid + ",'" + officername
										+ "','" + isstop + "','" + aggregateinvest
										+ "','" + aggregatedate + "','" + investment +"','"+companyid2share+"','"+currencyid
										+ "','"+ishow+"')");
							//System.out.println("第四次"+strSql);
								rs.execute(strSql.toString());
								String spsql = "select cpparentid from cpcompanyinfo where companyid="+companyid2share;
								//System.out.println(spsql);
								rs.execute(spsql);
								if(rs.next()){
									cpparentid=cpparentid+companyid2share+",";
								}
							}
							strSql.setLength(0);
							strSql.append("update cpcompanyinfo set cpparentid='"+cpparentid+"' where companyid="+companyid);
							//System.out.println(strSql.toString());
							rs.execute(strSql.toString());
							
						}else{
								//表示已经没有股东关系了，需要修正改公司为集团总部
								rs.execute("update cpcompanyinfo set cpparentid='' where companyid="+companyid);
						}
					}
					strSql.setLength(0);
					strSql.append("insert into CPSHAREHOLDERVERSION (shareid,versionnum,versionname,versionmemo,versionaffix,Createdatetime,");
					strSql.append("companyid,boardshareholder,established,shareaffix)");
					strSql.append(" values ("+shareid+",'"+versionnum+"','"+versionname+"','"+versionmemo+"','"+versionaffix+"','"+date2Version+"',");
					strSql.append(" " + companyid + ",'" + boardshareholder
							+ "','" + established + "','"+affixdoc+"')");
					//System.out.println("第五次"+strSql);
					rs.execute(strSql.toString());	
					//更新通知-添加
					String upsql = "insert into CPCOMPANYUPGRADE (UPTYPE,UPVERSION,CREATEDATETIME,discription,companyid) values ('director','"+versionnum+"','"+now+"','"+SystemEnv.getHtmlLabelName(1421,user.getLanguage())+"："+SystemEnv.getHtmlLabelName(30944,user.getLanguage())+"-["+versionnum+"]',"+companyid+")";
					//System.out.println(strSql);
					rs.execute(upsql);
					if(ched){//说明股东关系发生变化，并且产生了新的版本
						//更新变更记录cpcchangenotice
						String year=TimeUtil.getCurrentDateString().substring(0,4);
						String month=TimeUtil.getCurrentDateString().substring(5,7);
						rs02.execute(" insert into cpcchangenotice (c_type,c_companyid,c_year,c_month,c_time,c_desc) values(3,'"+companyid+"','"+year+"','"+month+"','"+TimeUtil.getCurrentTimeString()+"','"+SystemEnv.getHtmlLabelName(128190,user.getLanguage())+"["+versionnum+"]') ");	
					}
					if (!"".equals(listgdcy)) {
					/* 	listgdcy = URLDecoder.decode(listgdcy, "utf-8");
						org.json.JSONObject o4JsonArr2gd = new org.json.JSONObject(
								listgdcy); */
						
						for (int i = 1; i < o4JsonArr2gd.length(); i++) {
							String officername = o4JsonArr2gd.getJSONObject(
									"tr" + i).getString("officername");
							//System.out.println(officername);
							String isstop = o4JsonArr2gd
									.getJSONObject("tr" + i)
									.getString("isstop");
							String aggregateinvest =o4JsonArr2gd
									.getJSONObject("tr" + i).getString(
											"aggregateinvest");
							String aggregatedate = o4JsonArr2gd.getJSONObject(
									"tr" + i).getString("aggregatedate");
							String investment = Util.getFloatValue(o4JsonArr2gd.getJSONObject(
									"tr" + i).getString("investment"),0)+"";
							String companyid2share = o4JsonArr2gd.getJSONObject(
									"tr" + i).getString("companyid2share");
							String currencyid = o4JsonArr2gd.getJSONObject(
									"tr" + i).getString("currencyid");
							String ishow = o4JsonArr2gd.getJSONObject(
									"tr" + i).getString("ishow");
							strSql.setLength(0);
							strSql
									.append(" insert into CPSHAREOFFICERSVERSION (shareid,officername,isstop,aggregateinvest,aggregatedate,investment,companyid,currencyid,versionnum,VERSIONTYPE,ishow) values");
							strSql.append(" (" + shareid + ",'" + officername
									+ "','" + isstop + "','" + aggregateinvest
									+ "','" + aggregatedate + "','"
									+ investment + "','"+companyid2share+"','"+currencyid+"','"+versionnum+"','gd','"+ishow+"')");
							//System.out.println("第六次"+strSql);
							rs.execute(strSql.toString());
							String spsql = "select cpparentid from cpcompanyinfo where companyid="+companyid2share;
							rs.execute(spsql);
						}
					}
				}else{
					
					strSql.setLength(0);
					strSql.append(" update CPSHAREHOLDER set boardshareholder='"
							+ boardshareholder + "',established='" + established
							+ "',shareaffix='"+affixdoc+"',");
					strSql.append(" lastupdatetime='" + lastupdatetime
							+ "' where shareid=" + shareid);
					//System.out.println(strSql.toString());
					rs.execute(strSql.toString());
					//String listgdcy = Util.null2String(request.getParameter("data"));
					strSql.setLength(0);
					strSql.append(" delete from CPSHAREOFFICERS where shareid="
							+ shareid);
					//System.out.println(strSql);
					rs.execute(strSql.toString());
					if (!"".equals(listgdcy)) {
						/* listgdcy = URLDecoder.decode(listgdcy, "utf-8");
						org.json.JSONObject o4JsonArr2gd = new org.json.JSONObject(
								listgdcy); */
						String cpparentid = "";
						for (int i = 1; i < o4JsonArr2gd.length(); i++) {
							String officername = o4JsonArr2gd.getJSONObject(
									"tr" + i).getString("officername");
							//System.out.println(officername);
							String isstop = o4JsonArr2gd.getJSONObject("tr" + i)
									.getString("isstop");
							String aggregateinvest =o4JsonArr2gd.getJSONObject(
									"tr" + i).getString("aggregateinvest");
							String aggregatedate = o4JsonArr2gd.getJSONObject(
									"tr" + i).getString("aggregatedate");
							String investment = Util.getFloatValue(o4JsonArr2gd
									.getJSONObject("tr" + i)
									.getString("investment"),0)+"";
							String companyid2share = o4JsonArr2gd.getJSONObject(
									"tr" + i).getString("companyid2share");
							String currencyid = o4JsonArr2gd.getJSONObject(
									"tr" + i).getString("currencyid");
							String ishow = o4JsonArr2gd.getJSONObject(
									"tr" + i).getString("ishow");
							strSql.setLength(0);
							strSql
									.append(" insert into CPSHAREOFFICERS (shareid,officername,isstop,aggregateinvest,aggregatedate,investment,companyid,currencyid,ishow) values");
							strSql.append(" (" + shareid + ",'" + officername
									+ "','" + isstop + "','" + aggregateinvest
									+ "','" + aggregatedate + "','" + investment +"','"+companyid2share+"','"+currencyid
									+ "','"+ishow+"')");
							//System.out.println(strSql);
							rs.execute(strSql.toString());
							String spsql = "select cpparentid from cpcompanyinfo where companyid="+companyid2share;
							rs.execute(spsql);
							if(rs.next()){
								cpparentid=cpparentid+companyid2share+",";
								//System.out.println(cpparentid);
								
							}
						}
						strSql.setLength(0);
						strSql.append("update cpcompanyinfo set cpparentid='"+cpparentid+"' where companyid="+companyid);
						//System.out.println(strSql.toString());
						rs.execute(strSql.toString());
					}else{
								//表示已经没有股东关系了，需要修正改公司为集团总部
								rs.execute("update cpcompanyinfo set cpparentid='' where companyid="+companyid);
					}
				}
				
				
				//System.out.println(companyid);
				//companyMagager.froWheelTree(companyid);
				//out.print(this.getSumInvestment(companyid));
				pro.writeCompanylog("3",companyid,"2",user.getUID()+"",SystemEnv.getHtmlLabelName(30944,user.getLanguage()));
				out.clear();
				out.print("0");
		}else{
			//版本号重复
			out.clear();
			out.print(SystemEnv.getHtmlLabelNames("22186",user.getLanguage())+versionnum+SystemEnv.getHtmlLabelNames("84063",user.getLanguage()));
		}
		
	} else if ("get".equals(method)) {
		//获得 XX股东会会信息
		String gdh_isadd = "";
		JSONArray jsa = new JSONArray();
		CpShareHolder cpshareholder = new CpShareHolder();
		String strgdh = " select * from CPSHAREHOLDER where isdel='T' and companyid= "
				+ companyid;
		//System.out.println(strgdh);
		rs.execute(strgdh);
		if (rs.next()) {
			cpshareholder.setShareid(rs.getInt("shareid"));
			cpshareholder.setEstablished(rs.getString("established"));
			cpshareholder.setBoardshareholder(rs
					.getString("boardshareholder"));
			cpshareholder.setShareaffix(rs.getString("shareaffix"));

			gdh_isadd = "edit";
			jsa.add(gdh_isadd);
			jsa.add(cpshareholder);
			pro.writeCompanylog("3",companyid,"4",user.getUID()+"",SystemEnv.getHtmlLabelName(30944,user.getLanguage()));
		} else {
			gdh_isadd = "add";
			jsa.add(gdh_isadd);
		}
		out.clear();
		out.print(jsa);
	}else if("delVersion".equals(method)){
		strSql.setLength(0);
		int shareid=0;
		String _versionids =Util.TrimComma(Util.null2String(request.getParameter("versionids")));//要被删除的版本id
		String _versionnum=Util.TrimComma(Util.null2String(request.getParameter("_versionnum")));//要被删除的版本号
		rs02.execute("select companyid  from CPSHAREHOLDERVERSION where  versionid in ("+_versionids+")");
		if(rs02.next()){
			String temp_companyid=rs02.getString("companyid");
			rs02.execute(" select shareid from CPSHAREHOLDER where companyid="+ companyid);
			if(rs02.next()){
				shareid=rs02.getInt("shareid");//这个是CPSHAREOFFICERSVERSION表的外键呀
			}
			//更新通知-删除
			String upsql = "insert into CPCOMPANYUPGRADE (UPTYPE,UPVERSION,CREATEDATETIME,discription,companyid) values ('director','"+_versionnum+"','"+now+"','"+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"："+SystemEnv.getHtmlLabelName(30944,user.getLanguage())+"-["+_versionnum+"]',"+temp_companyid+")";
			rs.execute(upsql);
			
			//删除版本查看中的股东信息
			String[] vids = _versionids.split(",");
			if(vids.length>0){
				for(int i = 0;i<vids.length;i++){
					String vidsql = "select shareid,versionnum from CPSHAREHOLDERVERSION where versionid = "+vids[i];
					rs03.execute(vidsql);
					if(rs03.next()){
						int sid = rs03.getInt("shareid");
						String vnum = rs03.getString("versionnum");
						rs04.execute("delete from CPSHAREOFFICERSVERSION where shareid = "+sid+" and versionnum= '"+vnum+"'");
					}
				}
			}
			
			//删除版本
			upsql=" delete from CPSHAREHOLDERVERSION where versionid in ( "+_versionids+" )";
			rs.execute(upsql);
			//删除版本之后，还要删除版本下的 监事会成员版本和董事会成员版本
			rs.execute(" delete  CPSHAREOFFICERSVERSION where  versionnum in ( "+_versionnum+" )  and  shareid='"+shareid+"'");
		}
	}else if("viewVersion".equals(method)){
		String versionids = Util.null2String(request.getParameter("versionids"));
		String _versionids = versionids.substring(0,versionids.lastIndexOf(","));
		//System.out.println("======================="+versionids);
		JSONArray jsa = new JSONArray();
		CpShareHolder cpshareholder = new CpShareHolder();
		String sql = "select * from CPSHAREHOLDERVERSION t1 where t1.versionid="+_versionids;
		//System.out.println("查看股东版本"+sql);
		rs.execute(sql);
		if(rs.next()){
			cpshareholder.setShareid(rs.getInt("shareid"));
			cpshareholder.setEstablished(rs.getString("established"));
			cpshareholder.setBoardshareholder(rs
					.getString("boardshareholder"));
			//附件处理
			cpshareholder.setShareaffix(rs.getString("shareaffix"));
			String[] affixdocs = cpshareholder.getShareaffix().split(",");
			//System.out.println(cplicense.getAffixdoc());
			String imgid2db = "";
			String imgname2db = "";
			for(int i=0;i<affixdocs.length;i++){
			rs1.execute("select imagefileid,imagefilename from imagefile where imagefileid='"+affixdocs[i]+"'");
				if(rs1.next()){
					imgid2db += rs1.getString("imagefileid")+"|";
					imgname2db += rs1.getString("imagefilename")+"|";
				}
			}
			cpshareholder.setImgid(imgid2db);
			cpshareholder.setImgname(imgname2db);
		}
		jsa.add(cpshareholder);
		jsa.add(rs.getString("versionnum"));
		strSql.setLength(0);
		strSql.append("select companyid,versionnum from CPSHAREHOLDERVERSION where versionid in ( "+_versionids+" )");
		rs.execute(strSql.toString());
		//System.out.println(strSql.toString());
		if(rs.next()){
			//System.out.println("1");
			pro.writeCompanylog("3",rs.getString("companyid"),"4",user.getUID()+"",""+SystemEnv.getHtmlLabelName(30944,user.getLanguage())+"["+SystemEnv.getHtmlLabelName(567,user.getLanguage())+":"+rs.getString("versionnum")+"]");
		}
		out.clear();
		out.print(jsa);
		//System.out.println("==================="+jsa);
	}else if("viewOffersVersion".equals(method)){
		String shareid = Util.null2String(request.getParameter("shareid"));
		String sql = " select * from CPSHAREOFFICERSVERSION where shareid ="+shareid+" and versionnum = '"+versionnum+"' and versiontype='gd' order by investment desc";
		//System.out.println("查询股东会数据"+sql);
		rs.execute(sql);
		out.clear();
		while (rs.next()){
			String valuedate = "";
			if(!Util.null2String(rs.getString("aggregatedate")).equals(""))
			valuedate = rs.getString("aggregatedate").substring(0,4);
			out.print("<tr dbvalue='"+valuedate +"' class='DataDark'>");
			//out.print("<td width='27' align='center'>");
			//out.print("<input type='checkbox' name='checkbox' inWhichPage='gd'/>");
			//out.print("</td>");
			out.print("<td width='200' >");
			out.print("<span>&nbsp;&nbsp;"+rs.getString("officername")+"<span>");
			out.print("</td>");
			out.print("<td width='52' >");
			if("1".equals(rs.getString("isstop"))){
				out.println("&nbsp;&nbsp;"+SystemEnv.getHtmlLabelNames("82677",user.getLanguage()));
			}else{
				out.println("&nbsp;&nbsp;"+SystemEnv.getHtmlLabelNames("82676",user.getLanguage()));
			}
			out.print("</td>");
			out.print("<td width='99' >");
			out.print("&nbsp;&nbsp"+rs.getString("aggregateinvest")+"");
			out.print("</td>");
			out.print("<td width='70' >&nbsp;&nbsp;");
			rs02.execute("select id,currencyname,currencydesc from FnaCurrency  where id = '"+rs.getString("currencyid")+"'");
			if(rs02.next()){
				out.print(rs02.getString("currencyname"));
			}
			out.print("</td>");
			out.print("<td width='120' >");
			out.print("<span>&nbsp;&nbsp;"+rs.getString("aggregatedate") +"</span>");
			out.print("</td>");
			out.print("<td width='120'>");
			out.print("&nbsp;&nbsp;"+rs.getString("investment") +"");
			out.print("</td>");
			//out.print("<td width='0' >&nbsp;&nbsp;");
			//out.print("<select style=' width:0px; height:26px;border:0px;'>");
			//out.print(jspUtil.getOption("1,0",""+SystemEnv.getHtmlLabelName(26523,user.getLanguage())+","+SystemEnv.getHtmlLabelName(23857,user.getLanguage())+"",rs.getString("ishow")));
			//out.print("</select>");
			//out.print("</td>");
			out.print("</tr>");
		}
	}else if ("editversion".equals(method)){
		String versionid = Util.null2String(request.getParameter("versionid"));
		String upversionsql="";
		rs02.execute("select  versionnum,companyid  from CPSHAREHOLDERVERSION where  versionid in ("+versionid+")");
		if(rs02.next()){
			String temp_versionnum=rs02.getString("versionnum");
			String temp_companyid=rs02.getString("companyid");
			//更新通知-修改
			if(!versionnum.equals(temp_versionnum)){
				String upsql = "insert into CPCOMPANYUPGRADE (UPTYPE,UPVERSION,CREATEDATETIME,discription,companyid) values ('director','"+versionnum+"','"+now+"','"+SystemEnv.getHtmlLabelName(103,user.getLanguage())+"："+SystemEnv.getHtmlLabelName(30944,user.getLanguage())+"-["+temp_versionnum+"->"+versionnum+"]',"+temp_companyid+")";
				rs.execute(upsql);
			}
			 upversionsql = "update CPSHAREHOLDERVERSION set versionnum = '"+versionnum+"', versionname = '"+versionname+"' ,versionmemo='"+versionmemo+"',versionaffix='"+versionaffix+"',createdatetime='"+date2Version+"' where versionid="+versionid;
			//System.out.println(upversionsql);
			rs.execute(upversionsql);
		}
	}
	else if ("shareholding".equals(method)){
		String cpid= "166";
		//companyMagager.getGroupInfo(cpid,"businesstype","1");
		//getGroupVersionList(cpid);
		companyMagager.getGroupInfo(cpid,"");
		//String xml = companyMagager.getABCompanyIDs(cpid);
		//System.out.println(xml);
		/*StringWriter sw = new StringWriter();
		XMLWriter writer = null;
		OutputFormat format = OutputFormat.createPrettyPrint();
		format.setEncoding(weaver.general.GCONST.XML_UTF8);
		try {
			writer = new XMLWriter(format);
		   	writer.setWriter(sw);
		   	writer.write(getXMLData(cpid));
		   	writer.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
		//System.out.println(sw.toString());*/
	}
	
%>

