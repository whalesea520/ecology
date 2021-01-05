<%@page import="weaver.cpcompanyinfo.ProManageUtil"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="java.net.URLDecoder"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>


<%@page import="weaver.general.TimeUtil"%>
<%@page import="weaver.cpcompanyinfo.CpConstitution"%>
<%@ page import="net.sf.json.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs02" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="pro" class="weaver.cpcompanyinfo.ProManageUtil" scope="page" />
<%
	String method = Util.null2String(request.getParameter("method"));

	String companyid = Util.null2String(request
			.getParameter("companyid"));
			


						
	StringBuffer strSql = new StringBuffer();

	String now = Util.date(2);

	String createdatetime = now;
	//zzl用来统一判断修改那个版本信息
	String oneMoudel=Util.null2String(request
			.getParameter("oneMoudel"));
			
	String aggregateinvest =Util.null2String(request
			.getParameter("aggregateinvest"))+"";
	String currencyid = Util.null2String(request
			.getParameter("currencyid"));
				//System.out.println(currencyid+"章程"+method);
	String isvisitors = Util.null2String(request
			.getParameter("isvisitors"));
	String boardvisitors = Util.null2String(request
			.getParameter("boardvisitors"));
	String visitbegindate = Util.null2String(request
			.getParameter("visitbegindate"));
	String visitenddate = Util.null2String(request
			.getParameter("visitenddate"));
	String theboard = Util
			.null2String(request.getParameter("theboard"));
	String stitubegindate = Util.null2String(request
			.getParameter("stitubegindate"));
	String stituenddate = Util.null2String(request
			.getParameter("stituenddate"));
	String appointduetime = Util.getIntValue(Util.null2String(request.getParameter("appointduetime")),0)+"";
	String isreappoint = Util.null2String(request
			.getParameter("isreappoint"));
	String generalmanager = Util.null2String(request
			.getParameter("generalmanager"));
	String effectbegindate = Util.null2String(request
			.getParameter("effectbegindate"));
	String effectenddate = Util.null2String(request
			.getParameter("effectenddate"));
	String affixdoc = Util.null2String(request
			.getParameter("affixdoc"));
	
	String versionnum = Util.null2String(request.getParameter("versionnum"));
	String versionname = Util.null2String(request.getParameter("versionname"));
	String versionmemo = Util.null2String(request.getParameter("versionmemo"));
	String versionaffix = Util.null2String(request.getParameter("versionaffix"));
	
	String isaddversion =  Util.null2String(request.getParameter("isaddversion"));
	String date2Version = Util.null2String(request.getParameter("date2Version")); 
	//-------------编码转换-----------------

	aggregateinvest = URLDecoder.decode(aggregateinvest, "utf-8");
	currencyid = URLDecoder.decode(currencyid, "utf-8");
	isvisitors = URLDecoder.decode(isvisitors, "utf-8");
	boardvisitors = URLDecoder.decode(boardvisitors, "utf-8");
	visitbegindate = URLDecoder.decode(visitbegindate, "utf-8");
	visitenddate = URLDecoder.decode(visitenddate, "utf-8");
	theboard = URLDecoder.decode(theboard, "utf-8");
	stitubegindate = URLDecoder.decode(stitubegindate, "utf-8");
	stituenddate = URLDecoder.decode(stituenddate, "utf-8");
	appointduetime = URLDecoder.decode(appointduetime, "utf-8");
	isreappoint = URLDecoder.decode(isreappoint, "utf-8");
	generalmanager = URLDecoder.decode(generalmanager, "utf-8");
	effectbegindate = URLDecoder.decode(effectbegindate, "utf-8");
	effectenddate = URLDecoder.decode(effectenddate, "utf-8");
	affixdoc = URLDecoder.decode(affixdoc, "utf-8");
	
	versionnum = ProManageUtil.fetchString(URLDecoder.decode(versionnum,"utf-8"));
	versionname = URLDecoder.decode(versionname,"utf-8");
	versionmemo = URLDecoder.decode(versionmemo,"utf-8");
	versionaffix = URLDecoder.decode(versionaffix,"utf-8");
	isaddversion = URLDecoder.decode(isaddversion,"utf-8");
	date2Version = URLDecoder.decode(date2Version,"utf-8");
	
	String lastupdatetime = now;
	if ("add".equals(method)) {
		//------------得到 request 值--------------

		strSql.setLength(0);
		strSql.append(" insert into CPCONSTITUTION ");
		strSql
				.append(" (companyid,aggregateinvest,currencyid,isvisitors,boardvisitors,visitbegindate,");
		strSql
				.append(" visitenddate,theboard,stitubegindate,stituenddate,appointduetime,isreappoint,");
		strSql
				.append(" generalmanager,effectbegindate,effectenddate,createdatetime,lastupdatetime,isdel,constituaffix)");
		strSql.append(" values(" + companyid + ",'" + aggregateinvest
				+ "','" + currencyid + "','" + isvisitors + "',");
		strSql.append(" '" + boardvisitors + "','" + visitbegindate
				+ "','" + visitenddate + "','" + theboard + "',");
		strSql.append(" '" + stitubegindate + "','" + stituenddate
				+ "','" + appointduetime + "','" + isreappoint + "',");
		strSql
				.append(" '" + generalmanager + "','" + effectbegindate
						+ "','" + effectenddate + "','"
						+ createdatetime + "',");
		strSql.append(" '" + lastupdatetime + "','T','"+affixdoc+"')");
		//System.out.println(strSql.toString());
		rs.execute(strSql.toString());
		
		if(isaddversion.equals("add")){
			rs.execute(" select * from CPCONSTITUTION where companyid="+companyid);
			String constitutionid = "";
			if(rs.next()){
				constitutionid = rs.getString("constitutionid");
				strSql.setLength(0);
				strSql.append("insert into CPCONSTITUTIONVERSION (constitutionid,versionnum,versionname,versionmemo,versionaffix,Createdatetime,");
				strSql.append(" companyid,aggregateinvest,currencyid,isvisitors,boardvisitors,visitbegindate,");
				strSql.append(" visitenddate,theboard,stitubegindate,stituenddate,appointduetime,isreappoint,");
				strSql.append(" generalmanager,effectbegindate,effectenddate,constituaffix)");
				strSql.append(" values ("+constitutionid+",'"+versionnum+"','"+versionname+"','"+versionmemo+"','"+versionaffix+"','"+date2Version+"',");
				strSql.append(" " + companyid + ",'" + aggregateinvest
						+ "','" + currencyid + "','" + isvisitors + "',");
				strSql.append(" '" + boardvisitors + "','" + visitbegindate
						+ "','" + visitenddate + "','" + theboard + "',");
				strSql.append(" '" + stitubegindate + "','" + stituenddate
						+ "','" + appointduetime + "','" + isreappoint + "',");
				strSql
						.append(" '" + generalmanager + "','" + effectbegindate
								+ "','" + effectenddate + "','"
								+ affixdoc + "')");
				//System.out.println(strSql.toString());
				rs.execute(strSql.toString());
			}
			//更新通知-添加
			String upsql = "insert into CPCOMPANYUPGRADE (UPTYPE,UPVERSION,CREATEDATETIME,discription,companyid) values ('constitution','"+versionnum+"','"+now+"','"+SystemEnv.getHtmlLabelName(1421,user.getLanguage())+"："+SystemEnv.getHtmlLabelName(30940,user.getLanguage())+"-["+versionnum+"]',"+companyid+")";
			rs.execute(upsql);
			String offersql = "insert into CPSHAREOFFICERSVERSION(versiontype,shareid,Officername,Isstop,Aggregateinvest,Aggregatedate,Investment,Companyid,Currencyid,Versionnum)"+
				"select 'zc',t2.shareid,t2.officername,t2.isstop,t2.aggregateinvest,t2.aggregatedate,t2.investment,t2.companyid,t2.currencyid,'"+versionnum+"' from CPSHAREHOLDER t1,CPSHAREOFFICERS t2 where t1.shareid = t2.shareid and t1.companyid ="+companyid;
			
			rs.execute(offersql);
		}
		
		pro.writeCompanylog("3",companyid,"1",user.getUID()+"",SystemEnv.getHtmlLabelName(30941,user.getLanguage()));
		out.clear();
		out.print("0");
	} else if ("edit".equals(method)) {
		if(!ProManageUtil.checkEdition("constitution", "", companyid, versionnum)){
		String constitutionid = Util.null2String(request
				.getParameter("constitutionid"));
		
		if(isaddversion.equals("add")){
			String sqlmax = "select max(versionnum) as versionnum from CPCONSTITUTIONVERSION where constitutionid="+constitutionid;
			rs.execute(sqlmax);
			String maxnum = "";
			if(rs.next())maxnum = Util.null2String(rs.getString("versionnum"));
			if(maxnum.equals("") || maxnum.compareTo(versionnum)<0){
				strSql.setLength(0);
				strSql.append(" update CPCONSTITUTION set aggregateinvest='"
						+ aggregateinvest + "',currencyid='" + currencyid
						+ "',");
				strSql.append(" isvisitors='" + isvisitors
						+ "',boardvisitors='" + boardvisitors + "',");
				strSql.append(" visitbegindate='" + visitbegindate
						+ "',visitenddate='" + visitenddate + "',");
				strSql.append(" theboard='" + theboard + "',stitubegindate='"
						+ stitubegindate + "',");
				strSql.append(" stituenddate='" + stituenddate
						+ "',appointduetime='" + appointduetime + "',");
				strSql.append(" isreappoint='" + isreappoint
						+ "',generalmanager='" + generalmanager + "',");
				strSql.append(" effectbegindate='" + effectbegindate
						+ "',effectenddate='" + effectenddate + "',");
				strSql.append(" constituaffix='"+affixdoc+"',");
				strSql.append(" lastupdatetime='" + lastupdatetime
						+ "' where constitutionid=" + constitutionid);
				//System.out.println("修改语句"+strSql.toString());
				rs.execute(strSql.toString());
			}
			strSql.setLength(0);
			strSql.append("insert into CPCONSTITUTIONVERSION (constitutionid,versionnum,versionname,versionmemo,versionaffix,Createdatetime,");
			strSql.append(" companyid,aggregateinvest,currencyid,isvisitors,boardvisitors,visitbegindate,");
			strSql.append(" visitenddate,theboard,stitubegindate,stituenddate,appointduetime,isreappoint,");
			strSql.append(" generalmanager,effectbegindate,effectenddate,constituaffix)");
			strSql.append(" values ("+constitutionid+",'"+versionnum+"','"+versionname+"','"+versionmemo+"','"+versionaffix+"','"+date2Version+"',");
			strSql.append(" " + companyid + ",'" + aggregateinvest
					+ "','" + currencyid + "','" + isvisitors + "',");
			strSql.append(" '" + boardvisitors + "','" + visitbegindate
					+ "','" + visitenddate + "','" + theboard + "',");
			strSql.append(" '" + stitubegindate + "','" + stituenddate
					+ "','" + appointduetime + "','" + isreappoint + "',");
			strSql
					.append(" '" + generalmanager + "','" + effectbegindate
							+ "','" + effectenddate + "','"
							+ affixdoc + "')");
			//System.out.println("插入版本"+strSql.toString());
			rs.execute(strSql.toString());
			//更新通知
			String upsql = "insert into CPCOMPANYUPGRADE (UPTYPE,UPVERSION,CREATEDATETIME,discription,companyid) values ('constitution','"+versionnum+"','"+now+"','"+SystemEnv.getHtmlLabelName(1421,user.getLanguage())+"："+SystemEnv.getHtmlLabelName(30940,user.getLanguage())+"-["+versionnum+"]',"+companyid+")";
			rs.execute(upsql);
			String offersql = "insert into CPSHAREOFFICERSVERSION(versiontype,shareid,Officername,Isstop,Aggregateinvest,Aggregatedate,Investment,Companyid,Currencyid,Versionnum)"+
			"select 'zc',t2.shareid,t2.officername,t2.isstop,t2.aggregateinvest,t2.aggregatedate,t2.investment,t2.companyid,t2.currencyid,'"+versionnum+"' from CPSHAREHOLDER t1,CPSHAREOFFICERS t2 where t1.shareid = t2.shareid and t1.companyid ="+companyid;
			rs.execute(offersql);
		}else{
			strSql.setLength(0);
			strSql.append(" update CPCONSTITUTION set aggregateinvest='"
					+ aggregateinvest + "',currencyid='" + currencyid
					+ "',");
			strSql.append(" isvisitors='" + isvisitors
					+ "',boardvisitors='" + boardvisitors + "',");
			strSql.append(" visitbegindate='" + visitbegindate
					+ "',visitenddate='" + visitenddate + "',");
			strSql.append(" theboard='" + theboard + "',stitubegindate='"
					+ stitubegindate + "',");
			strSql.append(" stituenddate='" + stituenddate
					+ "',appointduetime='" + appointduetime + "',");
			strSql.append(" isreappoint='" + isreappoint
					+ "',generalmanager='" + generalmanager + "',");
			strSql.append(" effectbegindate='" + effectbegindate
					+ "',effectenddate='" + effectenddate + "',");
			strSql.append(" constituaffix='"+affixdoc+"',");
			strSql.append(" lastupdatetime='" + lastupdatetime
					+ "' where constitutionid=" + constitutionid);
			//System.out.println("修改章程"+strSql);
			rs.execute(strSql.toString());
		}
		pro.writeCompanylog("3",companyid,"2",user.getUID()+"",SystemEnv.getHtmlLabelName(30941,user.getLanguage()));
		out.clear();
		out.print("0");
	}else{
		//版本号重复
		out.clear();
		out.print(SystemEnv.getHtmlLabelNames("22186",user.getLanguage())+versionnum+SystemEnv.getHtmlLabelNames("84063",user.getLanguage()));
	}
	}else if("get".equals(method)){
		/*章程*/
		String zc_isadd = "";
		JSONArray jsa = new JSONArray();
		CpConstitution cpconstitution = new CpConstitution();
		String strzc = " select * from CPCONSTITUTION where isdel='T' and companyid= " + companyid;
		rs.execute(strzc);
		if(rs.next()){
			cpconstitution.setConstitutionid(rs.getInt("constitutionid"));
			cpconstitution.setAggregateinvest(rs.getString("aggregateinvest"));
			cpconstitution.setCurrencyid(rs.getString("currencyid"));
			cpconstitution.setIsvisitors(rs.getString("isvisitors"));
			cpconstitution.setBoardvisitors(rs.getString("boardvisitors"));
			cpconstitution.setVisitbegindate(rs.getString("visitbegindate"));
			cpconstitution.setVisitenddate(rs.getString("visitenddate"));
			cpconstitution.setTheboard(rs.getString("theboard"));
			cpconstitution.setStitubegindate(rs.getString("stitubegindate"));
			cpconstitution.setStituenddate(rs.getString("stituenddate"));
			cpconstitution.setAppointduetime(rs.getString("appointduetime"));
			cpconstitution.setIsreappoint(rs.getString("isreappoint"));
			cpconstitution.setGeneralmanager(rs.getString("generalmanager"));
			cpconstitution.setEffectbegindate(rs.getString("effectbegindate"));
			cpconstitution.setEffectenddate(rs.getString("effectenddate"));
			cpconstitution.setConstituaffix(rs.getString("constituaffix"));
			rs02.execute("select id,currencyname,currencydesc from FnaCurrency  where id = '"+rs.getString("currencyid")+"'");
			if(rs02.next()){
				cpconstitution.setCurrencyname(rs02.getString("currencyname"));
			}
			zc_isadd = "edit";
			jsa.add(zc_isadd);
			jsa.add(cpconstitution);
			pro.writeCompanylog("3",companyid,"4",user.getUID()+"",SystemEnv.getHtmlLabelName(30941,user.getLanguage()));
		}else{
			zc_isadd = "add";
			jsa.add(zc_isadd);
		}
		out.clear();
		out.print(jsa);
	}else if("delVersion".equals(method)){
		strSql.setLength(0);
		String _versionids =Util.TrimComma(Util.null2String(request.getParameter("versionids")));//要被删除的版本id
		String _versionnum=Util.TrimComma(Util.null2String(request.getParameter("_versionnum")));//要被删除的版本号
		rs02.execute("select companyid  from CPCONSTITUTIONVERSION where  versionid in ("+_versionids+")");
		if(rs02.next()){
			String temp_companyid=rs02.getString("companyid");
			//更新通知-添加
			String upsql = "insert into CPCOMPANYUPGRADE (UPTYPE,UPVERSION,CREATEDATETIME,discription,companyid) values ('constitution','"+_versionnum+"','"+now+"','"+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"："+SystemEnv.getHtmlLabelName(30940,user.getLanguage())+"-["+_versionnum+"]',"+temp_companyid+")";
			rs.execute(upsql);
			upsql=" delete from CPCONSTITUTIONVERSION where versionid in ( "+_versionids+" )";
			rs.execute(upsql);
		}
		//删除版本之后，还要删除版本下的 监事会成员版本和董事会成员版本
		//rs.execute(" delete  CPCONSTITUTIONVERSION where  versionnum in ( "+_versionnum+" ) ");
		
		
	}else if("viewVersion".equals(method)){
		String versionids = Util.null2String(request.getParameter("versionids"));
		String _versionids = versionids.substring(0,versionids.lastIndexOf(","));
		JSONArray jsa = new JSONArray();
		CpConstitution cpconstitution = new CpConstitution();
		String sql = "select * from CPCONSTITUTIONVERSION t1 where t1.versionid="+_versionids;
		//System.out.println(sql);
		String temp_versionnum="";
		rs.execute(sql);
		if(rs.next()){
			cpconstitution.setConstitutionid(rs.getInt("constitutionid"));
			cpconstitution.setAggregateinvest(rs.getString("aggregateinvest"));
			cpconstitution.setCurrencyid(rs.getString("currencyid"));
			cpconstitution.setIsvisitors(rs.getString("isvisitors"));
			cpconstitution.setBoardvisitors(rs.getString("boardvisitors"));
			cpconstitution.setVisitbegindate(rs.getString("visitbegindate"));
			cpconstitution.setVisitenddate(rs.getString("visitenddate"));
			cpconstitution.setTheboard(rs.getString("theboard"));
			cpconstitution.setStitubegindate(rs.getString("stitubegindate"));
			cpconstitution.setStituenddate(rs.getString("stituenddate"));
			cpconstitution.setAppointduetime(rs.getString("appointduetime"));
			cpconstitution.setIsreappoint(rs.getString("isreappoint"));
			cpconstitution.setGeneralmanager(rs.getString("generalmanager"));
			cpconstitution.setEffectbegindate(rs.getString("effectbegindate"));
			cpconstitution.setEffectenddate(rs.getString("effectenddate"));
			rs02.execute("select id,currencyname,currencydesc from FnaCurrency  where id = '"+rs.getString("currencyid")+"'");
			if(rs02.next()){
				cpconstitution.setCurrencyname(rs02.getString("currencyname"));
			}
			//附件处理
			cpconstitution.setConstituaffix(rs.getString("constituaffix"));
			String[] affixdocs = cpconstitution.getConstituaffix().split(",");
			//System.out.println(cplicense.getAffixdoc());
			String imgid2db = "";
			String imgname2db = "";
			temp_versionnum=rs.getString("versionnum");
			for(int i=0;i<affixdocs.length;i++){
			rs.execute("select imagefileid,imagefilename from imagefile where imagefileid='"+affixdocs[i]+"'");
				if(rs.next()){
					imgid2db += rs.getString("imagefileid")+"|";
					imgname2db += rs.getString("imagefilename")+"|";
				}
			}
			cpconstitution.setImgid(imgid2db);
			cpconstitution.setImgname(imgname2db);
			
		}
		jsa.add(cpconstitution);
		jsa.add(temp_versionnum);
		strSql.setLength(0);
		strSql.append("select companyid,versionnum from CPCONSTITUTIONVERSION where versionid in ( "+_versionids+" )");
		rs.execute(strSql.toString());
		//System.out.println(strSql.toString());
		if(rs.next()){
			//System.out.println("1");
			pro.writeCompanylog("3",rs.getString("companyid"),"4",user.getUID()+"",""+SystemEnv.getHtmlLabelName(30941,user.getLanguage())+"["+SystemEnv.getHtmlLabelName(567,user.getLanguage())+":"+rs.getString("versionnum")+"]");
		}
		out.clear();
		out.print(jsa);
	}else if ("editversion".equals(method)){
		String upversionsql="";
		String versionid = Util.null2String(request.getParameter("versionid"));
		rs02.execute("select  versionnum,companyid  from CPCONSTITUTIONVERSION where  versionid in ("+versionid+")");
		if(rs02.next()){
			String temp_versionnum=rs02.getString("versionnum");
			String temp_companyid=rs02.getString("companyid");
			//更新通知-修改
			if(!versionnum.equals(temp_versionnum)){
				String upsql = "insert into CPCOMPANYUPGRADE (UPTYPE,UPVERSION,CREATEDATETIME,discription,companyid) values ('license','"+versionnum+"','"+now+"','"+SystemEnv.getHtmlLabelName(103,user.getLanguage())+"："+SystemEnv.getHtmlLabelName(30940,user.getLanguage())+"-["+temp_versionnum+"->"+versionnum+"]',"+temp_companyid+")";
				rs.execute(upsql);
			}
			upversionsql = "update CPCONSTITUTIONVERSION set versionnum = '"+versionnum+"', versionname = '"+versionname+"' ,versionmemo='"+versionmemo+"',versionaffix='"+versionaffix+"',createdatetime='"+date2Version+"' where versionid="+versionid;
			rs.execute(upversionsql);
		}
	}
%>