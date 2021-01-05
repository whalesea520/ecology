<%@page import="weaver.cpcompanyinfo.ProManageUtil"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="weaver.conn.RecordSet"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@page import="weaver.general.BaseBean"%>
<%@page import="weaver.cpcompanyinfo.CpLicense"%>
<%@ page import="net.sf.json.*" %>
<%@page import="weaver.general.TimeUtil"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs02" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="pro" class="weaver.cpcompanyinfo.ProManageUtil" scope="page" />
<%

	
	String method = Util.null2String(request.getParameter("method"));
	//System.out.println("证照================="+method);
	String companyid = Util.null2String(request.getParameter("companyid"));
	//System.out.println("companyid================="+companyid);
	StringBuffer strSql = new StringBuffer();
	
	String now = Util.date(2);
	
	String createdatetime = now;
	
	//------------得到 request 值--------------
	String licensename = Util.null2String(request.getParameter("licensename")).trim();
	//System.out.println("licensename================="+licensename);
	//证照类型的id
	String licenseaffixid = Util.null2String(request.getParameter("licenseaffixid"));
	//System.out.println("licenseaffixid================="+licenseaffixid);
	String registeraddress = Util.null2String(request.getParameter("registeraddress"));
	String corporation = Util.null2String(request.getParameter("corporation"));
	String recordnum = Util.null2String(request.getParameter("recordnum"));
	String usefulbegindate = Util.null2String(request.getParameter("usefulbegindate"));
	String usefulenddate = Util.null2String(request.getParameter("usefulenddate"));
	String usefulyear =Util.getIntValue(Util.null2String(request.getParameter("usefulyear"))+"",0)+"";
	String dateinssue = Util.null2String(request.getParameter("dateinssue"));
	String annualinspection = Util.null2String(request.getParameter("annualinspection"));
	String scopebusiness = Util.null2String(request.getParameter("scopebusiness"));
	String departinssue = Util.null2String(request.getParameter("departinssue"));
	String registercapital = Util.null2String(request.getParameter("registercapital"))+"";
	String paiclupcapital = Util.null2String(request.getParameter("paiclupcapital"))+"";
	
	String currencyid = Util.null2String(request.getParameter("currencyid"));
	//System.out.println("currencyid================="+currencyid);
	String corporatdelegate = Util.null2String(request.getParameter("corporatdelegate"));
	String companytype = Util.null2String(request.getParameter("companytype"));
	String licenseregistnum = Util.null2String(request.getParameter("licenseregistnum"));
	String memo = Util.null2String(request.getParameter("memo"));
	String affixdoc = Util.null2String(request.getParameter("affixdoc"));
	
	String versionnum = Util.null2String(request.getParameter("versionnum"));

	String versionname = Util.null2String(request.getParameter("versionname"));
	String versionmemo = Util.null2String(request.getParameter("versionmemo"));
	String versionaffix = Util.null2String(request.getParameter("versionaffix"));
	
	String isaddversion =  Util.null2String(request.getParameter("isaddversion"));
	String date2Version = Util.null2String(request.getParameter("date2Version")); 
	
	String requestname = Util.null2String(request.getParameter("requestname1"));  
	String requestid = Util.null2String(Util.getIntValue(request.getParameter("requestid1")+"", 0)+"")+""; 
	String affixids = Util.null2String(request.getParameter("affixids1")); 
	//-------------编码转换-----------------
	licensename = URLDecoder.decode(licensename,"utf-8");
	licenseaffixid = URLDecoder.decode(licenseaffixid,"utf-8");
	registeraddress = URLDecoder.decode(registeraddress,"utf-8");
	corporation = URLDecoder.decode(corporation,"utf-8");
	recordnum = URLDecoder.decode(recordnum,"utf-8");
	usefulbegindate = URLDecoder.decode(usefulbegindate,"utf-8");
	usefulenddate = URLDecoder.decode(usefulenddate,"utf-8");
	usefulyear = URLDecoder.decode(usefulyear,"utf-8");
	dateinssue = URLDecoder.decode(dateinssue,"utf-8");
	annualinspection = URLDecoder.decode(annualinspection,"utf-8");
	scopebusiness = URLDecoder.decode(scopebusiness,"utf-8");
	departinssue = URLDecoder.decode(departinssue,"utf-8");
	registercapital = URLDecoder.decode(registercapital,"utf-8");
	paiclupcapital = URLDecoder.decode(paiclupcapital,"utf-8");
	currencyid = URLDecoder.decode(currencyid,"utf-8");
	corporatdelegate = URLDecoder.decode(corporatdelegate,"utf-8");
	companytype = URLDecoder.decode(companytype,"utf-8");
	licenseregistnum = URLDecoder.decode(licenseregistnum,"utf-8");
	memo = URLDecoder.decode(memo,"utf-8");
	affixdoc = URLDecoder.decode(affixdoc,"utf-8");
	versionnum = ProManageUtil.fetchString(URLDecoder.decode(versionnum,"utf-8"));
	versionname = URLDecoder.decode(versionname,"utf-8");
	versionmemo = URLDecoder.decode(versionmemo,"utf-8");
	versionaffix = URLDecoder.decode(versionaffix,"utf-8");
	isaddversion = URLDecoder.decode(isaddversion,"utf-8");
	date2Version = URLDecoder.decode(date2Version,"utf-8");
	
	requestname = URLDecoder.decode(requestname,"utf-8");
	requestid = URLDecoder.decode(requestid,"utf-8");
	affixids = URLDecoder.decode(affixids,"utf-8");
	//版本查看时无需查询附件id
	/* if("edit".equals(method) || "add".equals(method) )
	{
		if(affixids.equals("") && !requestid.equals(""))
		{
			affixids=getAffixids(requestid);
		}
	} */
	
	String lastupdatetime = now;
	if("add".equals(method)){
		//判断证照名称是否存在，如果不存在，则新加入
		strSql.setLength(0);
		strSql.append(" select count(*) s  from CPLMLICENSEAFFIX where  licensename='"+licensename+"'");
		if(	rs.execute(strSql.toString())&&rs.next()&&rs.getInt("s")<=0){
				
				if(rs.execute("select max(affixindex)+1 m from CPLMLICENSEAFFIX")&&rs.next()){
						strSql.setLength(0);
						int max_affindex=rs.getInt("m");
						strSql.append("insert into CPLMLICENSEAFFIX (affixindex,licensename,licensetype,uploaddatetime,ismulti) values ("+max_affindex+",'"+licensename+"',0,'"+now+"','0')");
						rs.execute(strSql.toString());
						strSql.setLength(0);
						strSql.append("select max(licenseaffixid) m from  CPLMLICENSEAFFIX ");
						if(rs.execute(strSql.toString())&&rs.next()){
							licenseaffixid=rs.getString("m");
						}
				}
				
		}
		
		strSql.setLength(0);
		/*新增证照主表*/
		strSql.append(" insert into CPBUSINESSLICENSE");
		strSql.append(" (companyid,licenseaffixid,registeraddress,corporation,recordnum,usefulbegindate,usefulenddate,usefulyear,");
		strSql.append(" dateinssue,annualinspection,scopebusiness,departinssue,registercapital,paiclupcapital,");
		strSql.append(" currencyid,corporatdelegate,companytype,licenseregistnum,memo,affixdoc,createdatetime,lastupdatetime,isdel,versionid,mainlicenseid,requestid,requestname,requestaffixid");
		strSql.append(" ) values ");
		strSql.append(" ("+companyid+","+licenseaffixid+",'"+registeraddress+"','"+corporation+"','"+recordnum+"',");
		strSql.append(" '"+usefulbegindate+"','"+usefulenddate+"','"+usefulyear+"','"+dateinssue+"','"+annualinspection+"',");
		strSql.append(" '"+scopebusiness+"','"+departinssue+"','"+registercapital+"','"+paiclupcapital+"','"+currencyid+"',");
		strSql.append(" '"+corporatdelegate+"','"+companytype+"','"+licenseregistnum+"','"+memo+"','"+affixdoc+"','"+createdatetime+"',");
		strSql.append(" '"+lastupdatetime+"','T',0,0,'"+requestid+"','"+requestname+"','"+affixids+"')");
		rs.execute(strSql.toString());
		if(isaddversion.equals("add")){
			
			String sql = "select max(licenseid) as licenseid from CPBUSINESSLICENSE where companyid="+companyid+" and licenseaffixid="+licenseaffixid+"";
			rs.execute(sql);
			String licenseid = "";
			if(rs.next())
				licenseid = rs.getString("licenseid");
		//	System.out.println("licenseid==============="+licenseid);
			strSql.setLength(0);
			strSql.append("insert into CPBUSINESSLICENSEVERSION (licenseid,versionnum,versionname,versionmemo,versionaffix,Createdatetime,addway,");
			strSql.append(" companyid,licenseaffixid,registeraddress,corporation,recordnum,usefulbegindate,usefulenddate,usefulyear,");
			strSql.append(" dateinssue,annualinspection,scopebusiness,departinssue,registercapital,paiclupcapital,");
			strSql.append(" currencyid,corporatdelegate,companytype,licenseregistnum,memo,affixdoc,requestid,requestname,requestaffixid)");
			
			strSql.append(" values ("+licenseid+",'"+versionnum+"','"+versionname+"','"+versionmemo+"','"+versionaffix+"','"+date2Version+"','useradd',");
			strSql.append(" "+companyid+","+licenseaffixid+",'"+registeraddress+"','"+corporation+"','"+recordnum+"',");
			strSql.append(" '"+usefulbegindate+"','"+usefulenddate+"','"+usefulyear+"','"+dateinssue+"','"+annualinspection+"',");
			strSql.append(" '"+scopebusiness+"','"+departinssue+"','"+registercapital+"','"+paiclupcapital+"','"+currencyid+"',");
			strSql.append(" '"+corporatdelegate+"','"+companytype+"','"+licenseregistnum+"','"+memo+"','"+affixdoc+"','"+requestid+"','"+requestname+"','"+affixids+"')");
			//更新通知-添加
			rs.execute(strSql.toString());
			String upsql = "insert into CPCOMPANYUPGRADE (UPTYPE,UPVERSION,CREATEDATETIME,discription,companyid) values ('license','"+versionnum+"','"+now+"','"+SystemEnv.getHtmlLabelName(1421,user.getLanguage())+"："+licensename+"-["+versionnum+"]',"+companyid+")";
			rs.execute(upsql);
		}
		pro.writeCompanylog("3",companyid,"1",user.getUID()+"",""+SystemEnv.getHtmlLabelNames("31021",user.getLanguage()) );
		out.clear();
		out.print("0");
		
	}else if("edit".equals(method)){
	
	String licenseid = Util.null2String(request.getParameter("licenseid"));
	/**
	if(isaddversion.equals("add")){
			String sql = "select max(licenseid) as licenseid from CPBUSINESSLICENSE where companyid="+companyid+" and licenseaffixid='"+licenseaffixid+"'";
			rs.execute(sql);
			if(rs.next()){
				licenseid = rs.getString("licenseid");
			}
	}
	**/
	if(!ProManageUtil.checkEdition("license", licenseid, companyid, versionnum)){
		
		String _corporation="";
		rs02.execute("select corporation from CPBUSINESSLICENSE where licenseid="+licenseid);
		if(rs02.next()){
			_corporation=rs02.getString("corporation");//得到原来的法人
		}
		//System.out.println("文档的id="+affixdoc);
		if(isaddversion.equals("add")){
		/* 	String sql = "select max(licenseid) as licenseid from CPBUSINESSLICENSE where companyid="+companyid+" and licenseaffixid='"+licenseaffixid+"'";
			rs.execute(sql);
			if(rs.next()){
				licenseid = rs.getString("licenseid");
			} */
			String sqlmax = "select max(versionnum) as versionnum from CPBUSINESSLICENSEVERSION where licenseid = "+licenseid;
			//System.out.println(sqlmax);
			rs.execute(sqlmax);
			String maxnum = "";
			if(rs.next())maxnum = Util.null2String(rs.getString("versionnum"));
			if(maxnum.equals("") || maxnum.compareTo(versionnum)<0){
				strSql.setLength(0);
				strSql.append(" update CPBUSINESSLICENSE set licenseaffixid ="+licenseaffixid+",registeraddress='"+registeraddress+"',");
				strSql.append(" corporation='"+corporation+"',recordnum='"+recordnum+"',"); 
				strSql.append(" usefulbegindate='"+usefulbegindate+"',usefulenddate='"+usefulenddate+"',"); 
				strSql.append(" usefulyear='"+usefulyear+"',dateinssue='"+dateinssue+"',"); 
				strSql.append(" annualinspection='"+annualinspection+"',scopebusiness='"+scopebusiness+"',"); 
				strSql.append(" departinssue='"+departinssue+"',registercapital='"+registercapital+"',"); 
				strSql.append(" paiclupcapital='"+paiclupcapital+"',currencyid='"+currencyid+"',"); 
				strSql.append(" corporatdelegate='"+corporatdelegate+"',companytype='"+companytype+"',"); 
				strSql.append(" licenseregistnum='"+licenseregistnum+"',"); 
				strSql.append(" memo='"+memo+"',affixdoc='"+affixdoc+"',lastupdatetime='"+lastupdatetime+"',"); 
				strSql.append(" requestid='"+requestid+"',requestname='"+requestname+"',requestaffixid='"+affixids+"'");
				strSql.append(" where licenseid="+licenseid);
				//System.out.println(strSql.toString());
				rs.execute(strSql.toString());				
			}
			strSql.setLength(0);
			strSql.append("insert into CPBUSINESSLICENSEVERSION (licenseid,versionnum,versionname,versionmemo,versionaffix,Createdatetime,addway,");
			strSql.append(" companyid,licenseaffixid,registeraddress,corporation,recordnum,usefulbegindate,usefulenddate,usefulyear,");
			strSql.append(" dateinssue,annualinspection,scopebusiness,departinssue,registercapital,paiclupcapital,");
			strSql.append(" currencyid,corporatdelegate,companytype,licenseregistnum,memo,affixdoc,requestid,requestname,requestaffixid)");
			
			strSql.append(" values ("+licenseid+",'"+versionnum+"','"+versionname+"','"+versionmemo+"','"+versionaffix+"','"+date2Version+"','useradd',");
			strSql.append(" "+companyid+","+licenseaffixid+",'"+registeraddress+"','"+corporation+"','"+recordnum+"',");
			strSql.append(" '"+usefulbegindate+"','"+usefulenddate+"','"+usefulyear+"','"+dateinssue+"','"+annualinspection+"',");
			strSql.append(" '"+scopebusiness+"','"+departinssue+"','"+registercapital+"','"+paiclupcapital+"','"+currencyid+"',");
			strSql.append(" '"+corporatdelegate+"','"+companytype+"','"+licenseregistnum+"','"+memo+"','"+affixdoc+"','"+requestid+"','"+requestname+"','"+affixids+"')");
			
			//更新通知-添加
			rs.execute(strSql.toString());
			String upsql = "insert into CPCOMPANYUPGRADE (UPTYPE,UPVERSION,CREATEDATETIME,discription,companyid) values ('license','"+versionnum+"','"+now+"','"+SystemEnv.getHtmlLabelName(1421,user.getLanguage())+"："+licensename+"-["+versionnum+"]',"+companyid+")";
			rs.execute(upsql);
			
			//更新变更记录cpcchangenotice
			if(!_corporation.equals(corporation)&&"1".equals(licenseaffixid)){//并且必须是企业法人营业执照
							String year=TimeUtil.getCurrentDateString().substring(0,4);
							String month=TimeUtil.getCurrentDateString().substring(5,7);
							rs02.execute(" insert into cpcchangenotice (c_type,c_companyid,c_year,c_month,c_time,c_desc) values(1,'"+companyid+"','"+year+"','"+month+"','"+TimeUtil.getCurrentTimeString()+"','"+_corporation+"->"+corporation+"') ");	
			}
		
		}else{
			strSql.setLength(0);
			strSql.append(" update CPBUSINESSLICENSE set licenseaffixid ="+licenseaffixid+",registeraddress='"+registeraddress+"',");
			strSql.append(" corporation='"+corporation+"',recordnum='"+recordnum+"',"); 
			strSql.append(" usefulbegindate='"+usefulbegindate+"',usefulenddate='"+usefulenddate+"',"); 
			strSql.append(" usefulyear='"+usefulyear+"',dateinssue='"+dateinssue+"',"); 
			strSql.append(" annualinspection='"+annualinspection+"',scopebusiness='"+scopebusiness+"',"); 
			strSql.append(" departinssue='"+departinssue+"',registercapital='"+registercapital+"',"); 
			strSql.append(" paiclupcapital='"+paiclupcapital+"',currencyid='"+currencyid+"',"); 
			strSql.append(" corporatdelegate='"+corporatdelegate+"',companytype='"+companytype+"',"); 
			strSql.append(" licenseregistnum='"+licenseregistnum+"',"); 
			strSql.append(" memo='"+memo+"',affixdoc='"+affixdoc+"',lastupdatetime='"+lastupdatetime+"',"); 
			strSql.append(" requestid='"+requestid+"',requestname='"+requestname+"',requestaffixid='"+affixids+"'");
			strSql.append(" where licenseid="+licenseid);
			//System.out.println(strSql.toString());
			rs.execute(strSql.toString());
			
		}
		pro.writeCompanylog("3",companyid,"2",user.getUID()+"",""+SystemEnv.getHtmlLabelNames("31023",user.getLanguage()) );
		out.clear();
		out.print("0");
	}else{
		//版本号重复
		out.clear();
		out.print(SystemEnv.getHtmlLabelNames("22186",user.getLanguage())+versionnum+SystemEnv.getHtmlLabelNames("84063",user.getLanguage()));
	}
	}else if ("del".equals(method)){
		String licenseids = Util.null2String(request.getParameter("licenseids"));
		strSql.setLength(0);
		if(licenseids.endsWith(",")){
			licenseids = licenseids.substring(0,licenseids.length()-1);
		}
		strSql.append(" update CPBUSINESSLICENSE set isdel='F' where licenseid in("+licenseids+")");
		rs.execute(strSql.toString());
		pro.writeCompanylog("3",companyid,"3",user.getUID()+"",""+SystemEnv.getHtmlLabelNames("84064",user.getLanguage()) );
	}else if ("haved".equals(method)){
		String judgetype = Util.null2String(request.getParameter("judgetype"));
		String temp_licenseaffixid="";
		if("1".equals(judgetype)){
				//说明是在新建的时候，用户手动录入证照的名字
				strSql.setLength(0);
				//执行此sql语句的前提是证照类型的名称是不可重复的				
				 strSql.append("select licenseid from CPBUSINESSLICENSE ");
				 strSql.append("where companyid='"+companyid+"' and licenseaffixid in(select licenseaffixid from CPLMLICENSEAFFIX where licensename='"+licensename+"')  and isdel='T' ");
				strSql.append(" and (select ismulti from CPLMLICENSEAFFIX where licenseaffixid in (select licenseaffixid from CPLMLICENSEAFFIX where licensename='"+licensename+"') )=0");
				rs.execute(strSql.toString());
				rs02.execute("select licenseaffixid from CPLMLICENSEAFFIX where licensename='"+licensename+"'");
				if(rs02.next()){
					temp_licenseaffixid=rs02.getString("licenseaffixid");
				}
				out.clear();
				if(rs.next()){
					//select licenseaffixid from CPLMLICENSEAFFIX where licensename='ss'
					out.print("haved_"+temp_licenseaffixid);
				}else{
					out.print("nohave_"+temp_licenseaffixid);
				}
		}else{
			String licenseid = Util.null2String(request.getParameter("licenseid"));
			String btnid=Util.null2String(request.getParameter("btnid"));
			strSql.setLength(0);
			strSql.append(" select licenseid from CPBUSINESSLICENSE where companyid="+companyid+" and licenseaffixid="+licenseaffixid+"   and isdel='T' ");
			if(!"newBtn".equals(btnid)){
				strSql.append(" and licenseid !="+licenseid);
			}
			strSql.append(" and (select ismulti from CPLMLICENSEAFFIX where licenseaffixid='"+licenseaffixid+"')=0");
			rs.execute(strSql.toString());
			out.clear();
			if(rs.next()){
				out.print("haved");
			}else{
				out.print("nohave");
			}
		}
	}else if("delVersion".equals(method)){
		strSql.setLength(0);
		String _versionids =Util.TrimComma(Util.null2String(request.getParameter("versionids")));//要被删除的版本id
		String _versionnum=Util.TrimComma(Util.null2String(request.getParameter("_versionnum")));//要被删除的版本号
		//System.out.println("_versionnum="+_versionids);
		rs02.execute("select companyid,licenseid from CPBUSINESSLICENSEVERSION where  versionid in ("+_versionids+")");
		if(rs02.next()){
			String temp_companyid=rs02.getString("companyid");
			String temp_licenseid=rs02.getString("licenseid");
			rs.execute("select licensename  from CPBUSINESSLICENSE t1,CPLMLICENSEAFFIX t2 where t1.licenseaffixid = t2.licenseaffixid and t1.licenseid in("+temp_licenseid+")");
			if(rs.next()){
					String temp_licensename=rs.getString("licensename");
					//更新通知-添加
					String upsql = "insert into CPCOMPANYUPGRADE (UPTYPE,UPVERSION,CREATEDATETIME,discription,companyid) values ('license','"+_versionnum+"','"+now+"','"+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"："+temp_licensename+"-["+_versionnum+"]',"+temp_companyid+")";
					rs.execute(upsql);
					upsql=" delete from CPBUSINESSLICENSEVERSION where versionid in ( "+_versionids+" )";
					rs.execute(upsql);
			}
		}
	}else if("viewVersion".equals(method)){
		String versionids = Util.null2String(request.getParameter("versionids"));
		String _versionids = versionids.substring(0,versionids.lastIndexOf(","));
		JSONArray jsa = new JSONArray();
		CpLicense cplicense = new CpLicense();
		String sql = "select * from CPBUSINESSLICENSEVERSION t1,CPLMLICENSEAFFIX t2 where t1.licenseaffixid = t2.licenseaffixid and t1.versionid="+_versionids;
		
		//System.out.println("查看证照版本"+sql);
		String temp_versionnum="";
		rs.execute(sql);
		if(rs.next()){
			cplicense.setRegisteraddress(Util.null2String(rs
					.getString("registeraddress")));
			cplicense.setCorporation(Util.null2String(rs.getString("corporation")));
			cplicense.setRecordnum(Util.null2String(rs.getString("recordnum")));
			cplicense.setUsefulbegindate(Util.null2String(rs
					.getString("usefulbegindate")));
			cplicense.setUsefulenddate(Util.null2String(rs
					.getString("usefulenddate")));
			cplicense.setUsefulyear(Util.null2String(rs.getString("usefulyear")));
			cplicense.setDateinssue(Util.null2String(rs.getString("dateinssue")));
			cplicense.setLicensestatu(Util.null2String(rs
					.getString("licensestatu")));
			cplicense.setAnnualinspection(Util.null2String(rs
					.getString("annualinspection")));
			cplicense.setDepartinssue(Util.null2String(rs
					.getString("departinssue")));
			cplicense.setScopebusiness(Util.null2String(rs
					.getString("scopebusiness")));
			cplicense.setRegistercapital(Util.null2String(rs
					.getString("registercapital")));
			cplicense.setPaiclupcapital(Util.null2String(rs
					.getString("paiclupcapital")));
			cplicense.setCurrencyid(rs.getString("currencyid"));
			rs02.execute("select id,currencyname,currencydesc from FnaCurrency  where id = '"+rs.getString("currencyid")+"'");
			if(rs02.next()){
				cplicense.setCurrencyname(rs02.getString("currencyname"));
			}
			
			cplicense.setCorporatdelegate(Util.null2String(rs
					.getString("corporatdelegate")));
			cplicense.setLicenseregistnum(Util.null2String(rs
					.getString("licenseregistnum")));
			cplicense.setMemo(Util.null2String(rs.getString("memo")));
			cplicense.setCompanytype(Util.null2String(rs.getString("companytype")));
			cplicense.setLicensename(Util.null2String(rs.getString("licensename")));
			cplicense.setLicensetype(Util.null2String(rs.getString("licensetype")));
			cplicense.setLicenseaffixid(rs.getInt("licenseaffixid"));
			cplicense.setAffixdoc(Util.null2String(rs.getString("affixdoc")));
			cplicense.setRequestid(Util.null2String(rs.getString("requestid")));
			cplicense.setRequestname(Util.null2String(rs.getString("requestname")));
			cplicense.setRequestaffixid(Util.null2String(rs.getString("requestaffixid")));
			String[] affixdocs = cplicense.getAffixdoc().split(",");
			//System.out.println(cplicense.getAffixdoc());
			String imgid2db = "";
			String imgname2db = "";
			String affixdoconly2db = "";
			temp_versionnum=rs.getString("versionnum");
			for(int i=0;i<affixdocs.length;i++){
			rs.execute("select imagefileid,imagefilename from imagefile where imagefileid='"+cplicense.getAffixdoc().split(",")[i]+"' ");
				if(rs.next()){
					imgid2db += rs.getString("imagefileid")+"|";
					imgname2db += rs.getString("imagefilename")+"|";
				}
			}
			cplicense.setImgid(imgid2db);
			cplicense.setImgname(imgname2db);
		}
		jsa.add(cplicense);
		jsa.add(temp_versionnum);
		out.clear();
		out.print(jsa);
		pro.writeCompanylog("3",companyid,"4",user.getUID()+"",""+SystemEnv.getHtmlLabelNames("31022",user.getLanguage()) );
	}else if ("editversion".equals(method)){
		String versionid = Util.null2String(request.getParameter("versionid"));
		rs.execute(" select versionnum,companyid,licenseid from CPBUSINESSLICENSEVERSION  where versionid="+versionid+"");
		if(rs.next()){
			String temp_versionnum=rs.getString("versionnum");
			String temp_licenseid=rs.getString("licenseid");
			companyid=rs.getString("companyid");
			rs.execute("select licensename  from CPBUSINESSLICENSE t1,CPLMLICENSEAFFIX t2 where t1.licenseaffixid = t2.licenseaffixid and t1.licenseid in("+temp_licenseid+")");
			if(rs.next()){
					String temp_licensename=rs.getString("licensename");
					//更新通知-添加
					if(!versionnum.equals(temp_versionnum)){
						String upsql = "insert into CPCOMPANYUPGRADE (UPTYPE,UPVERSION,CREATEDATETIME,discription,companyid) values ('license','"+versionnum+"','"+now+"','"+SystemEnv.getHtmlLabelName(103,user.getLanguage())+"："+temp_licensename+"-["+temp_versionnum+"->"+versionnum+"]','"+companyid+"')";
						rs.execute(upsql);
					}
					String upversionsql = "update CPBUSINESSLICENSEVERSION set versionnum = '"+versionnum+"', versionname = '"+versionname+"' ,versionmemo='"+versionmemo+"',versionaffix='"+versionaffix+"',createdatetime='"+date2Version+"' where versionid="+versionid;
					//System.out.println(upversionsql);
					rs.execute(upversionsql);
			}
		}
	}

%>

