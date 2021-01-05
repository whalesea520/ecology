
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.file.Prop"%>
<%@page import="weaver.crm.util.CrmFieldComInfo"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rst" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetC" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="cmutil" class="weaver.workrelate.util.CommonTransUtil" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="CustomerDescComInfo" class="weaver.crm.Maint.CustomerDescComInfo" scope="page" />
<jsp:useBean id="CustomerSizeComInfo" class="weaver.crm.Maint.CustomerSizeComInfo" scope="page" />
<jsp:useBean id="ContactWayComInfo" class="weaver.crm.Maint.ContactWayComInfo" scope="page" />
<jsp:useBean id="SectorInfoComInfo" class="weaver.crm.Maint.SectorInfoComInfo" scope="page" />
<jsp:useBean id="CustomerStatusComInfo" class="weaver.crm.Maint.CustomerStatusComInfo" scope="page" />
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page"/>
<jsp:useBean id="CitytwoComInfo" class="weaver.hrm.city.CitytwoComInfo" scope="page"/>
<jsp:useBean id="ProvinceComInfo" class="weaver.hrm.province.ProvinceComInfo" scope="page"/>
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page"/>
<jsp:useBean id="EvaluationLevelComInfo" class="weaver.crm.Maint.EvaluationLevelComInfo" scope="page" />
<jsp:useBean id="CrmUtil" class="weaver.crm.util.CrmUtil" scope="page" />
<jsp:useBean id="CustomerModifyLog" class="weaver.crm.data.CustomerModifyLog" scope="page"/>
<jsp:useBean id="CoworkDAO" class="weaver.cowork.CoworkDAO" scope="page"/>
<jsp:useBean id="WFUrgerManager" class="weaver.workflow.request.WFUrgerManager" scope="page" />
<jsp:useBean id="ContacterTitleComInfo" class="weaver.crm.Maint.ContacterTitleComInfo" scope="page" />
<%@page import="java.net.URLEncoder"%>
<%@ include file="/CRM/data/uploader.jsp" %>
<%
	String customerid = Util.null2String(request.getParameter("CustomerID"));
	if("2".equals(user.getLogintype())){
		response.sendRedirect("/CRM/data/ViewCustomer.jsp?CustomerID="+customerid);
		return;
	}
	rs.executeProc("CRM_CustomerInfo_SelectByID",customerid);
	if(rs.getCounts()<=0)
	{
		response.sendRedirect("/base/error/DBError.jsp?type=FindData");
		return;
	}
	rs.first();

	boolean canview=false;
	boolean canedit=false;
	boolean canunfreeze=false;
	boolean canmailmerge=false;
	//boolean canapprove=false;
	boolean isCustomerSelf=false;
	boolean canApply=false; //是否可以申请级别状态的变化
	boolean canApplyPortal=false; //是否可以申请门户状态的变化
	boolean canApplyPwd=false; //是否可以申请门户密码变化
	boolean canApproveLevel=false; //是否可以批准级别变化
	boolean canApprovePortal=false; //是否可以批准门户状态变化
	boolean canApprovePwd=false; //是否可以批准门户密码变化
	
	String levelMsg = ""; //级别申请中的显示信息
	String portalMsg = ""; //门户申请中的显示信息
	String portalPwdMsg = ""; //门户密码申请中的显示信息
	
	String country = Util.toScreenToEdit(rs.getString("country"),user.getLanguage());
	String province = Util.toScreenToEdit(rs.getString("province"),user.getLanguage());
	String isrequest = Util.null2String(request.getParameter("isrequest")); //客户审批描述
	String requestid = Util.null2String(request.getParameter("requestid")); //客户审批描述
	requestid = requestid.equals("")?requestid="-1":requestid;
	boolean hasApply = false;
	boolean hasApplyPortal = false;
	boolean hasApplyPwd = false;
	boolean isCreater=false;
	
	String levelstatus = "";
	String portalstatus = "";
	String portalstatus2 = "";
	String portalpwdstatus = "";
	String levelMenu = "";
	String portalMenu = "";
	String portalpwdMenu = "";
	
	RecordSetV.executeSql("select approvedesc,status from bill_ApproveCustomer where approvetype=1 and status<>'1' and status<>'0' and approveid="+customerid);
	if(RecordSetV.next()){
	    levelMsg = "（"+RecordSetV.getString("approvedesc")+"）";
	    levelstatus = RecordSetV.getString("status");
	    hasApply = true;
	}
	RecordSetV.executeSql("select approvedesc,status from bill_ApproveCustomer where approvetype=2 and status<>'1' and status<>'0' and approveid="+customerid);
	if(RecordSetV.next()){
	    portalMsg = "（"+RecordSetV.getString("approvedesc")+"）";
	    portalstatus = RecordSetV.getString("status");
	    hasApplyPortal = true;
	}
	RecordSetV.executeSql("select approvedesc,status from bill_ApproveCustomer where approvetype=3 and status<>'1' and status<>'0' and approveid="+customerid);
	if(RecordSetV.next()){
	    portalPwdMsg = "（"+RecordSetV.getString("approvedesc")+"）";
	    portalpwdstatus = RecordSetV.getString("status");
	    hasApplyPwd = true;
	}


	if(isrequest.equals("1")){
		canApproveLevel=hasApply;
	   	canApprovePortal=hasApplyPortal;
	   	canApprovePwd=hasApplyPwd;
	}

	//取得客户审批工作流的信息
	String approveid= "" ;
	String approvetype= "" ;
	String approvevalue = "";
	String sql= "select approveid,approvevalue,approvetype from bill_ApproveCustomer where requestid="+requestid;
	    //System.out.println("sql = " + sql);
	RecordSetV.executeSql(sql);
	if(RecordSetV.next()){
		approveid=RecordSetV.getString("approveid");
	    approvetype=RecordSetV.getString("approvetype");
	    approvevalue = RecordSetV.getString("approvevalue");
	}
	
	
	String userid = user.getUID()+"";
	String logintype = ""+user.getLogintype();
	boolean isattention = false;
	
	String name = Util.toScreenToEdit(rs.getString("name"),user.getLanguage());
	String email = Util.toScreenToEdit(rs.getString("email"),user.getLanguage());
	
	String type = Util.null2String(rs.getString("type"));
	String rating = Util.null2String(rs.getString("rating"));
	String manager = Util.toScreenToEdit(rs.getString("manager"),user.getLanguage());
	
	String evaluation = Util.null2String(rs.getString("evaluation"));
	int deleted = Util.getIntValue(rs.getString("deleted"),0);
	
	int status = rs.getInt("status");
	
	//判断是否为个人用户
	if(type.equals("19")){
		response.sendRedirect("/CRM/data/ViewPerCustomer.jsp?CustomerID="+customerid);
		return;
	}
	boolean isperson = type.equals("26")?true:false;//是否人脉
	
	//判断是否有查看该客户权限
	int sharelevel = CrmShareBase.getRightLevelForCRM(userid,customerid);
	if(sharelevel>0){
        canview=true;
        canmailmerge=true;
        if(sharelevel==2) canedit=true;
        if(sharelevel==3||sharelevel==4){
            canedit=true;
            //canapprove=true;
        }
    }
	if(status==7 || status==8 || status==10){
		if(canedit) canunfreeze=true;
		canedit = false;
	}
    //if(manager.equals(ResourceComInfo.getManagerID(manager))){
    //	canapprove=true;
    //}

    if(manager.equals(userid)){
        if(!hasApply){
            canApply=true; //只有客户的经理才可以申请升级、降级以及冻结和解冻操作
        }
        if(!hasApplyPortal){
            canApplyPortal = true; //只有客户的经理才可以申请开放门户、以及冻结和解冻操作
        }
        if(!hasApplyPwd){
            canApplyPwd = true; //只有客户的经理才可以申请重新生成密码
        }
        
        isCreater=true;
      	
        //客户经理为本人时删除新客户标记
    	CustomerModifyLog.deleteCustomerLog(Util.getIntValue(customerid,-1),user.getUID());
    }

    /*check right end*/

    portalstatus2 =  Util.getIntValue(rs.getString("PortalStatus"),0)+"";
    boolean onlyview=false;
    if(!canview && !isCustomerSelf && !CoworkDAO.haveRightToViewCustomer(userid,customerid)){
        if(!WFUrgerManager.UrgerHaveCrmViewRight(Util.getIntValue(requestid),user.getUID(),Util.getIntValue(logintype),customerid) && !WFUrgerManager.getMonitorViewObjRight(Util.getIntValue(requestid),user.getUID(),customerid,"1")){
            response.sendRedirect("/notice/noright.jsp") ;
            return ;
        }else{
            onlyview=true;
        }
    }
	
	
	int nolog = Util.getIntValue(request.getParameter("nolog"),0);
	
	rs2.executeSql("select 1 from CRM_Common_Attention where objid="+customerid+" and operatetype=1 and operator="+userid);
	if(rs2.next()){
		isattention = true;
	}
	
	String Creater = "";
	String CreateDate = "";
	String CreateTime = "";
	rs2.executeSql("select top 1 submiter,submitdate,submitertype,submittime from CRM_Log where customerid ='" + customerid + "' and logtype = 'n' order by submitdate desc,submittime desc");
	if(rs2.first()){
		Creater = Util.toScreen(rs2.getString("submiter"),user.getLanguage());
		CreateDate = rs2.getString("submitdate");
		CreateTime = rs2.getString("submittime");
	}

	String Modifier = "";
	String ModifyDate = "";
	String ModifyTime = "";
	rs2.executeSql("select top 1 submiter,submitdate,submitertype,submittime from CRM_Log where customerid ='" + customerid + "' and logtype <> 'n' and logtype <> 'v' order by submitdate desc,submittime desc");
	if(rs2.first()){
		Modifier = Util.toScreen(rs2.getString("submiter"),user.getLanguage());
		ModifyDate = rs2.getString("submitdate");
		ModifyTime = rs2.getString("submittime");
	}
	
	//查找客户的正式名称
	String othername = "";
	rs2.executeSql("select customername from CRM_OtherName where nametype=1 and customerid="+customerid);
	if(rs2.next()){
		othername =  Util.toScreenToEdit(rs2.getString("customername"),user.getLanguage());
	}else{
		//没有正式名称则加入默认
		othername = name;
		rs2.executeSql("insert into CRM_OtherName(nametype,customerid,customername) values(1,"+customerid+",'"+othername+"')");
	}
	
	String topage= URLEncoder.encode("/CRM/data/ViewCustomer.jsp?CustomerID="+customerid);
	
	String titlestr = "客户-"+name+" 由 "+ResourceComInfo.getLastname(Creater)+" 于  "+CreateDate+" "+CreateTime+" 创建 ";
	String updatestr = "由 "+ResourceComInfo.getLastname(Modifier)+" 于  "+ModifyDate+" "+ModifyTime+" 最后修改";
	
	//判断客户是否被合并
	String supid = "";
	String supname = "";
	if(deleted==1){
		canedit = false;
		if(!name.equals("")){
			rs2.executeSql("select customerid,logcontent from CRM_Log where logtype = 'u' and logcontent like '%"+name+"%'");
			while(rs2.next()){
				if(supid.equals("")){
					String logcontentname = (rs2.getString("logcontent").substring(rs2.getString("logcontent").indexOf(":")+1)).trim();
					ArrayList crmnameArray=Util.TokenizerString(logcontentname,",");
					for(int k=0;k<crmnameArray.size();k++){
						String tempcrmname=""+crmnameArray.get(k);
						if(name.equals(tempcrmname.trim())){
							supid = rs2.getString("customerid");
							supname = CustomerInfoComInfo.getCustomerInfoname(supid);
							break;
						}
					}
				}
			}	
		}
		
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title><%=titlestr+updatestr %></title>
		<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/> 
		<script language="javascript" src="/js/weaver_wev8.js"></script>
		<script language="javascript" src="../js/jquery.fuzzyquery.min_wev8.js"></script>
		<script language="javascript" src="../js/util_wev8.js"></script>
		<script language="javascript" src="/workrelate/js/relateoperate_wev8.js"></script>
		
		<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
		<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
		<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
		
		<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
		
		<link rel="stylesheet" href="../css/Base_wev8.css" />
		<link rel="stylesheet" href="../css/Contact_wev8.css" />
		
		
		<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
		<!--[if IE]> 
		<style type="text/css">
			input{line-height: 180%;}
			.item_input,.other_input{line-height: 20px;}
		</style>
		<![endif]-->
		
		<script language="javascript">
			<%if(!supid.equals("")){%>
			if(confirm("客户已被合并为：<%=supname%>,是否查看主客户?")){
				window.location = "CustomerBaseView.jsp?CustomerID=<%=supid%>";
			}
			<%}%>
		</script>
	</head>
	<body>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

	<%
		String mailAddress = "";
		if(!onlyview){
			if(canunfreeze){
				RCMenu += "{解冻,javascript:doUnfreeze(),_top} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
			if(canedit){
				RCMenu += "{新建商机,javascript:doAddSellChance(),_top} " ;
				RCMenuHeight += RCMenuHeightStep ;
				
				RCMenu += "{"+SystemEnv.getHtmlLabelName(17416,user.getLanguage())+SystemEnv.getHtmlLabelName(6082,user.getLanguage())+",javascript:exportContact(),_top} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
	
			if(!isCustomerSelf){
				
			//新建邮件
			if(canmailmerge){
				String mailAddressContacter = "";
				rs2.executeSql("SELECT top 20 email FROM CRM_CustomerContacter WHERE customerid="+customerid+"");
				while(rs2.next()){
					mailAddressContacter = Util.toScreenToEdit(rs2.getString("email"),user.getLanguage());
					if(!mailAddressContacter.equals("")){
						mailAddress += mailAddressContacter + ",";
					}
				}
				mailAddress = email +","+ mailAddress;
				if(mailAddress.endsWith(",")) mailAddress=mailAddress.substring(0, mailAddress.length()-1);
				RCMenu += "{"+SystemEnv.getHtmlLabelName(2029,user.getLanguage())+",javascript:doAddEmail(),_top} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
		}
		/**
		if(levelstatus.equals("2")){
	    	levelMenu = SystemEnv.getHtmlLabelName(142,user.getLanguage())+"->"+SystemEnv.getHtmlLabelName(17288,user.getLanguage()); //批准->级别申请
		}else{
	    	levelMenu = SystemEnv.getHtmlLabelName(615,user.getLanguage())+"->"+SystemEnv.getHtmlLabelName(17288,user.getLanguage()); //提交->级别申请
		}*/
		if(portalstatus.equals("2")){
		    portalMenu = SystemEnv.getHtmlLabelName(142,user.getLanguage())+"->"+SystemEnv.getHtmlLabelName(1234,user.getLanguage()); //批准->门户申请
		}else{
		    portalMenu = SystemEnv.getHtmlLabelName(615,user.getLanguage())+"->"+SystemEnv.getHtmlLabelName(1234,user.getLanguage()); //提交->门户申请
		}
		if(portalpwdstatus.equals("2")){
		    portalpwdMenu = SystemEnv.getHtmlLabelName(142,user.getLanguage())+"->"+SystemEnv.getHtmlLabelName(17289,user.getLanguage()); //批准->重设密码
		}else{
		    portalpwdMenu = SystemEnv.getHtmlLabelName(615,user.getLanguage())+"->"+SystemEnv.getHtmlLabelName(17289,user.getLanguage()); //提交->重设密码
		}
	
		
		if(canApproveLevel && status==1&&approvevalue.equals("2")){
			RCMenu += "{"+levelMenu+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+customerid+"&requestid="+requestid+"&method=ApproveLevel&Status=2&Rating=1\\\"),_top} " ;
			RCMenuHeight += RCMenuHeightStep ;
	
		}
		if(canApply && status==1){
			RecordSetC.executeSql("select fullname from CRM_CustomerStatus where id = 2");
			RecordSetC.next();
	    	//申请->基础客户
			RCMenu += "{"+SystemEnv.getHtmlLabelName(129,user.getLanguage())+"->"+RecordSetC.getString(1)+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+customerid+"&approvedesc="+name+":"+SystemEnv.getHtmlLabelName(129,user.getLanguage())+"->"+RecordSetC.getString(1)+"&method=apply&Status=2&Rating=1\\\"),_top} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}
	
		if(canApproveLevel && status==2 && approvevalue.equals("3")){
			RCMenu += "{"+levelMenu+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+customerid+"&requestid="+requestid+"&method=ApproveLevel&Status=3&Rating=1\\\"),_top} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}
		if(canApply && status==2){
			RecordSetC.executeSql("select fullname from CRM_CustomerStatus where id = 3");
			RecordSetC.next();
			    //申请->潜在客户
			RCMenu += "{"+SystemEnv.getHtmlLabelName(129,user.getLanguage())+"->"+RecordSetC.getString(1)+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+customerid+"&approvedesc="+name+":"+SystemEnv.getHtmlLabelName(129,user.getLanguage())+"->"+RecordSetC.getString(1)+"&method=apply&Status=3&Rating=1\\\"),_top} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}
	
	
		if(canApproveLevel && status==3 && approvevalue.equals("4")){
			RCMenu += "{"+levelMenu+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+customerid+"&requestid="+requestid+"&method=ApproveLevel&Status=4&Rating=1\\\"),_top} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}
		if(canApply && status==3){
			RecordSetC.executeSql("select fullname from CRM_CustomerStatus where id = 4");
			RecordSetC.next();
	    	//申请->成功客户
			RCMenu += "{"+SystemEnv.getHtmlLabelName(129,user.getLanguage())+"->"+RecordSetC.getString(1)+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+customerid+"&approvedesc="+name+":"+SystemEnv.getHtmlLabelName(129,user.getLanguage())+"->"+RecordSetC.getString(1)+"&method=apply&Status=4&Rating=1\\\"),_top} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}
	
	
		if(canApproveLevel && status==4 && approvevalue.equals("5")){
			RCMenu += "{"+levelMenu+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+customerid+"&requestid="+requestid+"&method=ApproveLevel&Status=5&Rating="+rating+"\\\"),_top} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}
		if(canApproveLevel && status==4 && approvevalue.equals("6")){
			RCMenu += "{"+levelMenu+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+customerid+"&requestid="+requestid+"&method=ApproveLevel&Status=6&Rating="+rating+"\\\"),_top} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}
		if(canApply && status==4){
			RecordSetC.executeSql("select fullname from CRM_CustomerStatus where id = 5");
			RecordSetC.next();
	    	//申请->试点客户
			RCMenu += "{"+SystemEnv.getHtmlLabelName(129,user.getLanguage())+"->"+RecordSetC.getString(1)+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+customerid+"&approvedesc="+name+":"+SystemEnv.getHtmlLabelName(129,user.getLanguage())+"->"+RecordSetC.getString(1)+"&method=apply&Status=5&Rating="+rating+"\\\"),_top} " ;
			RCMenuHeight += RCMenuHeightStep ;
	
			RecordSetC.executeSql("select fullname from CRM_CustomerStatus where id = 6");
			RecordSetC.next();
	    	//申请->典型客户
			RCMenu += "{"+SystemEnv.getHtmlLabelName(129,user.getLanguage())+"->"+RecordSetC.getString(1)+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+customerid+"&approvedesc="+name+":"+SystemEnv.getHtmlLabelName(129,user.getLanguage())+"->"+RecordSetC.getString(1)+"&method=apply&Status=6&Rating="+rating+"\\\"),_top} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}
	
	
		if(canApproveLevel && status==5 && approvevalue.equals("6")){
			RCMenu += "{"+levelMenu+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+customerid+"&requestid="+requestid+"&method=ApproveLevel&Status=6&Rating="+rating+"\\\"),_top} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}
		if(canApply && status==5){
			RecordSetC.executeSql("select fullname from CRM_CustomerStatus where id = 6");
			RecordSetC.next();
	    	//申请->典型客户
			RCMenu += "{"+SystemEnv.getHtmlLabelName(129,user.getLanguage())+"->"+RecordSetC.getString(1)+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+customerid+"&approvedesc="+name+":"+SystemEnv.getHtmlLabelName(129,user.getLanguage())+"->"+RecordSetC.getString(1)+"&method=apply&Status=6&Rating="+rating+"\\\"),_top} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}
	
	
		if(canApproveLevel && status==3 && approvevalue.equals("7")){
			RCMenu += "{"+levelMenu+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+customerid+"&requestid="+requestid+"&method=ApproveLevel&Status=7&Rating="+rating+"\\\"),_top} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}
		if(canApply && status==3){
	    	//申请->冻结
			RCMenu += "{"+SystemEnv.getHtmlLabelName(129,user.getLanguage())+"->"+SystemEnv.getHtmlLabelName(1232,user.getLanguage())+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+customerid+"&approvedesc="+name+":申请->冻结&method=apply&Status=7&Rating="+rating+"\\\"),_top} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}
	
	
		if(canApproveLevel && ( status==4 || status==5  || status==6) && approvevalue.equals("8")){
			RCMenu += "{"+levelMenu+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+customerid+"&requestid="+requestid+"&method=ApproveLevel&Status=8&Rating="+rating+"\\\"),_top} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}
		if(canApply && ( status==4 || status==5  || status==6)){
		    //申请->冻结
			RCMenu += "{"+SystemEnv.getHtmlLabelName(129,user.getLanguage())+"->"+SystemEnv.getHtmlLabelName(1232,user.getLanguage())+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+customerid+"&approvedesc="+name+":申请->冻结&method=apply&Status=8&Rating="+rating+"\\\"),_top} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}
	
		if(canApproveLevel && status==7 && approvevalue.equals("3")){
			RCMenu += "{"+levelMenu+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+customerid+"&requestid="+requestid+"&method=ApproveLevel&Status=3&Rating="+rating+"\\\"),_top} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}
		if(canApply && status==7){
	    	//申请->解冻
			RCMenu += "{"+SystemEnv.getHtmlLabelName(129,user.getLanguage())+"->"+SystemEnv.getHtmlLabelName(1233,user.getLanguage())+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+customerid+"&approvedesc="+name+":申请->解冻&method=apply&Status=3&Rating="+rating+"\\\"),_top} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}
	
	
		if(canApproveLevel && status==8 && approvevalue.equals("4")){
			RCMenu += "{"+levelMenu+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+customerid+"&requestid="+requestid+"&method=ApproveLevel&Status=4&Rating="+rating+"\\\"),_top} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}
		if(canApply && status==8){
	    	//申请->解冻
			RCMenu += "{"+SystemEnv.getHtmlLabelName(129,user.getLanguage())+"->"+SystemEnv.getHtmlLabelName(1233,user.getLanguage())+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+customerid+"&approvedesc="+name+":申请->解冻&method=apply&Status=4&Rating="+rating+"\\\"),_top} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}
	
	
		//状态倒回
		if(canApproveLevel && status==2 && approvevalue.equals("1")){
			RCMenu += "{"+levelMenu+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+customerid+"&requestid="+requestid+"&method=ApproveLevel&Status=1&Rating=1\\\"),_top} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}
		if(canApply && status==2){
			RecordSetC.executeSql("select fullname from CRM_CustomerStatus where id = 1");
			RecordSetC.next();
	    	//申请->无效客户
			RCMenu += "{"+SystemEnv.getHtmlLabelName(129,user.getLanguage())+"->"+RecordSetC.getString(1)+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+customerid+"&approvedesc="+name+":"+SystemEnv.getHtmlLabelName(129,user.getLanguage())+"->"+RecordSetC.getString(1)+"&method=apply&Status=1&Rating=1\\\"),_top} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}
	
	
		if(canApproveLevel && status==3 && approvevalue.equals("2")){
			RCMenu += "{"+levelMenu+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+customerid+"&requestid="+requestid+"&method=ApproveLevel&Status=2&Rating=1\\\"),_top} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}
		if(canApply && status==3){
			RecordSetC.executeSql("select fullname from CRM_CustomerStatus where id = 2");
			RecordSetC.next();
			//申请->基础客户
			RCMenu += "{"+SystemEnv.getHtmlLabelName(129,user.getLanguage())+"->"+RecordSetC.getString(1)+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+customerid+"&approvedesc="+name+":"+SystemEnv.getHtmlLabelName(129,user.getLanguage())+"->"+RecordSetC.getString(1)+"&method=apply&Status=2&Rating=1\\\"),_top} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}
		
		//退回菜单
		if(canApproveLevel&&levelstatus.equals("2")){
	    //退回->级别申请
			RCMenu += "{"+SystemEnv.getHtmlLabelName(236,user.getLanguage())+"->"+SystemEnv.getHtmlLabelName(17288,user.getLanguage())+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+customerid+"&requestid="+requestid+"&method=RejectLevel\\\"),_top} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}
		//portal begin
		staticobj = StaticObj.getInstance();
		portal = (String)staticobj.getObject("portal") ;
		if(portal == null) portal="n";
		isPortalOK = false;
		if(portal.equals("y")) isPortalOK = true;
		if(isPortalOK){
			if(canApprovePortal && portalstatus2.equals("0") && status>=3){
			    //门户批准
				RCMenu += "{"+portalMenu+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+customerid+"&requestid="+requestid+"&method=ApprovePortal&PortalStatus=2\\\"),_top} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
			if(canApplyPortal && portalstatus2.equals("0") && status>=3){
		   	 	//门户申请
				RCMenu += "{"+SystemEnv.getHtmlLabelName(1234,user.getLanguage())+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+customerid+"&approvedesc="+name+":门户申请&method=portal&PortalStatus=2\\\"),_top} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
	
			if(canApprovePortal && portalstatus2.equals("2") && status>=3){
				RCMenu += "{"+portalMenu+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+customerid+"&requestid="+requestid+"&method=ApprovePortal&PortalStatus=3\\\"),_top} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
			if(canApplyPortal && portalstatus2.equals("2") && status>=3){
			    //申请->门户冻结
				RCMenu += "{"+SystemEnv.getHtmlLabelName(129,user.getLanguage())+"->"+SystemEnv.getHtmlLabelName(1236,user.getLanguage())+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+customerid+"&approvedesc="+name+":申请->门户冻结&method=portal&PortalStatus=3\\\"),_top} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
		
		
			if(canApprovePortal && portalstatus2.equals("3") && status>=3){
				RCMenu += "{"+portalMenu+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+customerid+"&requestid="+requestid+"&method=ApprovePortal&PortalStatus=2\\\"),_top} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
			if(canApplyPortal && portalstatus2.equals("3") && status>=3){
		    	//申请->门户激活
				RCMenu += "{"+SystemEnv.getHtmlLabelName(129,user.getLanguage())+"->"+SystemEnv.getHtmlLabelName(1237,user.getLanguage())+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+customerid+"&approvedesc="+name+":申请->门户激活&method=portal&PortalStatus=2\\\"),_top} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
			//退回菜单
			if(canApprovePortal&&portalstatus.equals("2")){
			    //退回->门户申请
				RCMenu += "{"+SystemEnv.getHtmlLabelName(236,user.getLanguage())+"->"+SystemEnv.getHtmlLabelName(1234,user.getLanguage())+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+customerid+"&requestid="+requestid+"&method=RejectPortal\\\"),_top} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
		
			if(canApprovePwd && portalstatus2.equals("2") && status>=3){
				RCMenu += "{"+portalpwdMenu+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+customerid+"&requestid="+requestid+"&method=ApprovePwd&PortalStatus=2\\\"),_top} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
			if(canApplyPwd && portalstatus2.equals("2") && status>=3){
		   	 	//申请->重设密码
				RCMenu += "{"+SystemEnv.getHtmlLabelName(129,user.getLanguage())+"->"+SystemEnv.getHtmlLabelName(17289,user.getLanguage())+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+customerid+"&approvedesc="+name+":申请->重设密码&method=portalPwd&PortalStatus=2\\\"),_top} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
			//退回菜单
			if(canApprovePwd&&portalpwdstatus.equals("2")){
		    	//退回->重设密码
				RCMenu += "{"+SystemEnv.getHtmlLabelName(236,user.getLanguage())+"->"+SystemEnv.getHtmlLabelName(17289,user.getLanguage())+",javascript:urlSubmit(this,\\\"/CRM/data/CustomerOperation.jsp?isfromtab=true&CustomerID="+customerid+"&requestid="+requestid+"&method=RejectPwd\\\"),_top} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
		}//portal end
	
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1239,user.getLanguage())+",javascript:doAddWorlFlow(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
		if(!isCustomerSelf){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(17859,user.getLanguage())+",javascript:doAddCowork(),_top} " ;
			RCMenuHeight += RCMenuHeightStep;
			
			RCMenu += "{"+SystemEnv.getHtmlLabelName(16426,user.getLanguage())+",javascript:doAddWorkPlan(),_top} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}
		
		//增加新建任务及相关任务列表按钮
		if(Util.null2String(Prop.getPropValue("workrelate", "istask")).equals("1")){
			RCMenu += "{新建任务,javascript:doCreateTask(\\\"crmids="+customerid+"\\\"),_top} " ;
			RCMenuHeight += RCMenuHeightStep;
			
			RCMenu += "{相关任务列表,javascript:openTaskList(\\\"crmids="+customerid+"\\\"),_top} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}
		/*
		RCMenu += "{发起提醒流程,javascript:doContactRemind(),_top} " ;
		RCMenuHeight += RCMenuHeightStep;
		*/
		
		if(isCreater){
			RCMenu += "{客户合并,javascript:UniteCustomer(),_top} " ;
			RCMenuHeight += RCMenuHeightStep;
		}
	}
		
	boolean crmmanager = false;
	rs2.executeSql("select id from HrmRoleMembers where  roleid = 8 and rolelevel = 2 and resourceid = " + user.getUID());
	if(rs2.next()) {
		crmmanager = true;
	}	
		
	%>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

	<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td>
				</td>
				<td class="rightSearchSpan" style="text-align:right;">
				
						<input type=button class="e8_btn_top" style="display:none;" onclick="showRelateWF('');" value="相关流程"></input>
						<span class="e8_advanceSep" style="opacity: 1;line-height:40px;display:none;">|</span>
						<span title="菜单" class="cornerMenu"></span>
				</td>
				<td></td>
			</tr>
		</table>


		<table id="main" style="width: 100%;height: 100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td align="center" valign="top">
					<div style="width:100%;height: 100%;margin: 0px auto;text-align: left;">
						<div id="baseinfo" style="width: 100%;height: auto;overflow: hidden;">
						<table style="width: 100%;" cellpadding="0" cellspacing="0" border="0">
						<tr>
						<td valign="top" width="*">
						<!-- 左侧信息开始 -->
						<%if(!supid.equals("")){ %>
						<div style="width: 100%;height: 20px;line-height: 20px;color: red;font-weight: bold;text-align: center;">
							提示：此客户已被 <a href='CustomerBaseView.jsp?CustomerID=<%=supid %>' target="_self"><%=supname %></a> 合并
						</div>
						<%} %>
						<div id="leftdiv" style="width: 100%;margin-top: 0px;overflow:hidden;position: relative;" class="scroll1 content_2">
							<div id="leftinfo" class="scroll1" style="width:100%;height: 100%;position: relative;overflow:auto;">
							<!-- 基本信息开始 -->
							<table style="width: 100%;height:auto;margin-top: 0px;" cellpadding="0" cellspacing="0" border="0">
								<colgroup><col width="0px"/><col width="0px"/><col width="*"/></colgroup>
								<tr>
									<td valign="top">
										<!-- 一般信息开始 -->
												<wea:layout type="4col" attributes="{'expandAllGroup':'true'}">
												
												<%
												rst.execute("select * from CRM_CustomerDefinFieldGroup where usetable = 'CRM_CustomerInfo' and id !=4 order by dsporder asc");
												while(rst.next()){
													
													String groupid = rst.getString("id");
													CrmFieldComInfo comInfo = new CrmFieldComInfo("CRM_CustomerInfo",groupid) ;
													
													String personField = "";//个人可查看
													if(groupid.equals("1")) personField = ",name,city,address1,zipcode,phone,fax,email,website,";
													if(groupid.equals("2")) personField = ",type,status,rating,source,sector,manager,introductionDocid,";
													if(0 == comInfo.getArraySize() && !groupid.equals("1") && groupid.equals("2")){
														continue;
													}
												%>
													<wea:group context="<%=SystemEnv.getHtmlLabelName(rst.getInt("grouplabel"),user.getLanguage())%>">
														<%
															while(comInfo.next()){ 
																if(isperson && !"".equals(personField) && -1 == personField.indexOf(comInfo.getFieldname())){
																	continue;
																}	
														%>
															
														<wea:item><%=CrmUtil.getHtmlLableName(comInfo , user)%></wea:item>
														<wea:item>
															<%if(canedit){%>
																<%=CrmUtil.getHtmlElementSetting(comInfo ,rs.getString(comInfo.getFieldname()) ,user , "edit")%>
															<%}%>
															<%=CrmUtil.getHmtlElementInfo(comInfo ,rs.getString(comInfo.getFieldname()) ,user , canedit?"edit":"info")%>
														</wea:item>
														<%} %>
														<%if(groupid.equals("1")){ %>
															<wea:item><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%></wea:item>
															<wea:item>
																<%if(canedit){ %>
																	<brow:browser viewType="0" name="country" browserValue="<%=country%>" 
																				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/country/CountryBrowser.jsp"
																				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
																				completeUrl="/data.jsp?type=1111" width="230px" _callback="callBackSelectUpdate" _callbackParams="<%=country%>"
																				browserSpanValue="<%=CountryComInfo.getCountryname(country)%>">
																	</brow:browser>
														  		<%}%>
														  			<div class="e8_txt" id="txtdiv_country">
																		<%if(!country.equals("0") && !country.equals("")){ %>
																			<%=CountryComInfo.getCountryname(country)%>
																		<%} %>
																	</div>
															</wea:item>
															
															<wea:item><%=SystemEnv.getHtmlLabelName(800,user.getLanguage())%></wea:item>
															<wea:item>
																<%if(canedit){ %>
																	<brow:browser viewType="0" name="province" browserValue="<%=province%>" 
																				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/province/ProvinceBrowser.jsp"
																				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
																				completeUrl="/data.jsp?type=2222" width="230px" _callback="callBackSelectUpdate" _callbackParams="<%=province%>"
																				browserSpanValue="<%=ProvinceComInfo.getProvincename(province)%>">
																	</brow:browser>
														  		<%}%>
														  			<div class="e8_txt" id="txtdiv_province">
																		<%if(!province.equals("0") && !province.equals("")){ %>
																			<%=ProvinceComInfo.getProvincename(province)%>
																		<%} %>
																	</div>
															</wea:item>
														<%} %>
														
														
														<%if(groupid.equals("2")){ %>
														
															<wea:item>客户价值</wea:item>
															<wea:item>
																<div class="div_show"><%=EvaluationLevelComInfo.getEvaluationLevelname(evaluation) %></div>
															</wea:item>
																
															<wea:item>级别</wea:item>
															<wea:item>
																<%if(canedit){ %>
																	<select style="width:60px;" onchange="doUpdate(this,1);" name="rating" id="rating">
										                          		<option value="1" <%=rating.equals("1")?"selected":""%>>1</option>
																		<option value="2" <%=rating.equals("2")?"selected":""%>>2</option>
																		<option value="3" <%=rating.equals("3")?"selected":""%>>3</option>
																		<option value="4" <%=rating.equals("4")?"selected":""%>>4</option>
																		<option value="5" <%=rating.equals("5")?"selected":""%>>5</option>
																		<option value="6" <%=rating.equals("6")?"selected":""%>>6</option>
																		<option value="7" <%=rating.equals("7")?"selected":""%>>7</option>
										                          	</select>
																<%}%>
																<div class="e8_select_txt" id="txtdiv_rating">
																	<%=rating.equals("0")?"1":rating %>
																</div>
															</wea:item>
															<%if(!isperson){ %>
																<wea:item>门户状态</wea:item>
																<wea:item>
																	<span style="color:red">
																	  <%if(portalstatus2.equals("0")){%>
																		 <%=SystemEnv.getHtmlLabelName(1241,user.getLanguage())%>
																	  <%}else if(portalstatus2.equals("1")) {%>
																		 <%=SystemEnv.getHtmlLabelName(1242,user.getLanguage())%>
																	  <%}else if(portalstatus2.equals("2")) {%>
																		 <%=SystemEnv.getHtmlLabelName(1280,user.getLanguage())%>
																	  <%}else if(portalstatus2.equals("3")) {%>
																		 <%=SystemEnv.getHtmlLabelName(1232,user.getLanguage())%>
																	  <%}%>
																	</span>
																	<%if(canedit && portalstatus2.equals("2") && status>=3){%>
																		&nbsp;<%=SystemEnv.getHtmlLabelName(2024,user.getLanguage())%>:<%=rs.getString("PortalLoginid")%>&nbsp;<%=SystemEnv.getHtmlLabelName(409,user.getLanguage())%>:<%=rs.getString("PortalPassword")%>
																	<%}%>
														            <%=portalMsg%><%=portalPwdMsg%>
																</wea:item>
																<%} 
															} %>
													</wea:group>
													<%} %>
													
													<wea:group context="<%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%>">
														<%if(canedit){ %>
														<wea:item type="groupHead">
															<input type="button" id="btn_contacter" class="addbtn" onclick="addContacter()" _status="1"/>
														</wea:item>
														<%}%>
														<wea:item attributes="{'colspan':'full'}">
															<!-- 人员关系开始 -->
															<jsp:include page="/CRM/manage/contacter/ContacterRel.jsp">
																<jsp:param value="<%=customerid %>" name="customerid"/>
																<jsp:param value="<%=canedit %>" name="canedit"/>
																<jsp:param value="0" name="contact"/>
															</jsp:include>
															<!-- 人员关系结束 -->
														</wea:item>
													</wea:group>
													
										        </wea:layout>
									</td>
								</tr>
							</table>
							<!-- 基本信息结束 -->
							
							
							<!-- 标签定义开始 -->
							<table id="table_tag" style="width: 100%; margin-top: 20px;display:none;" cellpadding="0" cellspacing="0" border="0">
								<colgroup>
									<col width="0px" />
									<col width="0px" />
									<col width="*" />
								</colgroup>
								<tr>
									<td class="item_icon11"></td>
									<td></td>
									<td style="position: relative;">
										<div class="item_title item_title11">
											<div style="float: left;font-family: '微软雅黑';font-size: 14px;">标签</div>
										</div>
										<div class="item_line item_line11"></div>
										<div id="tagdiv" style="width: 96%;height: auto;margin-top: 6px;margin-left: 2px;overflow: hidden;">
									<%
										rs2.executeSql("select tag,creater,createdate,createtime from CRM_CustomerTag where customerid="+customerid+" order by id");
										String tagstr = "";
										while(rs2.next()){
											tagstr = Util.null2String(rs2.getString("tag"));
									%>
										<div class="tagitem" _val="<%=tagstr %>" title="<%=tagstr %>-<%=ResourceComInfo.getLastname(rs2.getString("creater"))+" "+rs2.getString("createdate")+" "+rs2.getString("createtime") %>"><%=tagstr %>
										<%if(userid.equals(rs2.getString("creater"))){ %><div class="tagdel" onclick="doDelTag('<%=tagstr %>',this)" title="删除"></div><%} %>
										</div>
									<%
										}
									%>
										<div id="tagaddbtn" style="float: left;width: 60px;height: 26px;line-height: 26px;cursor: pointer;text-align: center;background: #F6F6F6;" 
											onclick="doAddTag()" title="添加标签">添加</div>
										<div id="tagpanel" style="width: 208px;height: 26px;background: #B87474;position: relative;float: left;display: none;">
											<div style="position: absolute;left: 2px;top: 2px;width: 120px;height: 22px;background: #fff;float: left;">
												<input type="text" id="addtag" style="width: 100%;border: 0px;height: 22px;line-height: 22px;margin: 0px;padding: 0px;color: #5B5B5B;" maxlength="100"/>
											</div>
											<div id="tagsavebtn" style="position: absolute;right: 44px;top: 2px;width: 40px;height: 22px;line-height: 22px;background: #800040;text-align: center;color: #fff;cursor: pointer;font-weight: bold;float: left;"
												onclick="doSaveTag()">保存</div>
											<div id="tagsavebtn" style="position: absolute;right: 2px;top: 2px;width: 40px;height: 22px;line-height: 22px;background: #A5A5A5;text-align: center;color: #fff;cursor: pointer;font-weight: bold;float: left;"
												onclick="cancelTag()">取消</div>
										</div>
										</div>
									</td>
								</tr>
							</table>
							<!-- 标签定义结束 -->
							
							<!-- 读取进行中的商机开始 -->
							<%
								rs2.executeSql("select id from CRM_SellChance where endtatusid=0 and customerid="+customerid+" order by selltype,id");
								while(rs2.next()){
							%>
							<div id="div_sellchance_<%=rs2.getString("id") %>" style="width: 100%;height: auto;overflow: hidden;margin-top: 15px;position: relative;display:none;">
								<iframe id="sellchance_<%=rs2.getString("id") %>" style="width: 100%;height: 400px;" src="/CRM/manage/sellchance/SellChanceView.jsp?id=<%=rs2.getString("id") %>&contact=0" frameborder="0" scrolling="no"></iframe>
							</div>
							
							<%	} %>
							<!-- 读取进行中的商机结束 -->
							
							<div style="width: 100%;height: 20px;float: left;"></div>
							</div>
							
							<div id="btn_center1" class="btn_center btn_center_left"  _status="1" title="收缩联系记录"></div>
							
						</div>
						<!-- 左侧商机信息结束 -->
						</td>
						<td id="righttd" valign="top" width="0px" style="width:0px;display:none;">
						<!-- 右侧联系记录开始 -->
						<div id="rightdiv" style="width: 100%;">
							<table style="width: 100%;" cellpadding="0" cellspacing="0" border="0">
								<colgroup>
								<col width="*"/>
								</colgroup>
								<tr>
									<td style="position: relative;">
										<div id="crtitle" class="item_title item_title1">客户联系</div>
										<div class="item_line"></div>
										<div id="contactdiv" style="width: 100%;height: auto;">
											<iframe id='contentframe' src='/CRM/data/ViewContactLog.jsp?CustomerID=<%=customerid%>&isfromtab=true&from=base' height=100% width="100%" border=0 frameborder="0" scrolling="auto"></iframe>
										</div>
										<div id="btn_center2" class="btn_center btn_center_right"  _status="1" title="收缩联系记录"></div>
									</td>
								</tr>
							</table>
						</div>
						<!-- 右侧联系记录结束 -->
						</td>
						</tr>
						</table>
						</div>
					</div>
					
				</td>
			</tr>
		</table>
		
		<%if(canedit){ %>
		
			<div id="pr_select" style="min-width: 100px;height: auto;overflow: hidden;position: absolute;display: none;background: #fff;
															border: 1px #CACACA solid;padding-left: 0px;padding-right: 0px;
															border-radius: 3px;
															-moz-border-radius: 3px;
															-webkit-border-radius: 3px;
															box-shadow: 0px 0px 3px #CACACA;
															-moz-box-shadow: 0px 0px 3px #CACACA;
															-webkit-box-shadow: 0px 0px 3px #CACACA;">
				<div id="roleitem_项目决策人" class="roletype">项目决策人</div>
				<div id="roleitem_客户高层" class="roletype">客户高层</div>
				<div id="roleitem_内部向导" class="roletype">内部向导</div>
				<div id="roleitem_技术影响人" class="roletype">技术影响人</div>
				<div id="roleitem_需求影响人" class="roletype">需求影响人</div>
				<div id="roleitem_其他" class="roletype">其他</div>
				<div style="width: 100%;text-align: center;height: 22px;line-height: 22px;">
					<a style="width: 50%;text-align: center;" href="javascript:updateRoleType()">确定</a>&nbsp;
					<a style="width: 50%;text-align: center;" href="javascript:cancelRoleType()">取消</a>
				</div>
			</div>
			<div id="at_select" class="select_div">
				<div class="select_item">支持我方</div>
				<div class="select_item">未表态</div>
				<div class="select_item">未反对</div>
				<div class="select_item">反对</div>
			</div>
			<div id="ct_select" class="select_div">
			<%
				ContacterTitleComInfo.setTofirstRow();
				while(ContacterTitleComInfo.next()){
			%>
				<div class="select_item" _val="<%=ContacterTitleComInfo.getContacterTitleid() %>"><%=ContacterTitleComInfo.getContacterTitlename() %></div>
			<%  } %>
			</div>
		
		<!-- 日志明细开始 -->
		<div id="log_list" style="width: 100%;height: 471px;overflow: hidden;position: absolute;top: 100px;left:0px;display: none;z-index: 200;">
			<div style="background: url('../images/log_bg_wev8.png') no-repeat;width: 590px;height: 100%;margin: 0px auto;overflow: hidden;position: relative;">
				<div style="width: 580px;margin-left: 5px;position: relative;">
					<div style="width: 18px;height: 18px;background: url('../images/log_btn_close_wev8.png');position: absolute;top:15px;right: 10px;cursor: pointer;" onclick="closeLog()" title="关闭"></div>
					<div id="log_title" style="line-height: 45px;padding-left: 10px;color: #fff;font-weight: bold;font-size: 14px;font-family: '微软雅黑'"><span id="scname"></span>操作日志</div>
					<div id="log_detail" class="scroll2" style="height: 410px;width: 98%;margin: 0px auto;position: relative;">
						<div id="logmore" class="datamore" style="display: none;text-align: center;" 
							onclick="getListLog(this)" _datalist="logtable" 
							_currentpage="0" _pagesize="30" _total="" title="显示更多数据">更多</div>
						<div id="log_load" style="width: 100%;height: 100%;position: absolute;top: 0px;left: 0px;background: url('../images/loading2_wev8.gif') center no-repeat;"></div>
					</div>
				</div>
			</div>
		</div>
		<!-- 日志明细结束 -->
		<%} %>
		
		
		<!-- 相关流程开始 -->
		<div id="relatewf_list" style="width: 100%;height: 471px;overflow: hidden;position: absolute;top: 100px;left:0px;display: none;z-index: 200;">
			<div style="background: url('../images/log_bg2_wev8.png') no-repeat;width: 810px;height: 100%;margin: 0px auto;overflow: hidden;position: relative;">
				<div style="width: 800px;margin-left: 5px;position: relative;">
					<div style="width: 18px;height: 18px;background: url('../images/log_btn_close_wev8.png');position: absolute;top:15px;right: 10px;cursor: pointer;" onclick="closeRelateWF()" title="关闭"></div>
					<div id="relatewf_title" style="line-height: 45px;padding-left: 10px;color: #fff;font-weight: bold;font-size: 14px;font-family: '微软雅黑'"><span id="scname"></span>相关流程</div>
					<div id="relatewf_detail" class="scroll2" style="height: 410px;width: 98%;margin: 0px auto;position: relative;">
						<div id="relatewf_load" style="width: 100%;height: 100%;position: absolute;top: 0px;left: 0px;background: url('../images/loading2_wev8.gif') center no-repeat;"></div>
					</div>
				</div>
			</div>
		</div>
		<!-- 相关流程结束 -->
		
		<div id="transbg" style="width: 100%;height: 100%;position: absolute;top: 0px;left: 0px;background: url('../images/transbg_wev8.png') repeat;display: none;z-index: 100"></div>
		
		<!-- 提示信息 -->
		<div id="warn">
			<div class="title"></div>
		</div>
		
		
		<style>
			
			.sbHolder{
				display:none;
			}
			
			.e8_os{
				display:none;
				height:28px;
			}
			.browser{
				display:none;
				height:28px;
			}
			.calendar{
				display: none;
			}
			.e8_txt{
				height:28px;
				line-height:28px;
			}
		</style>
		
		<script type="text/javascript">
			$.ajaxSetup ({
			    cache: false //关闭AJAX相应的缓存
			});
		
			var tempval = "";//用于记录原值
			var foucsobj2 = null;
			
			$(document).ready(function(){
				//绑定附件上传功能
				jQuery("div[name=uploadDiv]").each(function(){
			        bindUploaderDiv($(this),"<%=customerid%>"); 
			        jQuery(this).find("#uploadspan").append($(this).attr("checkinputImage"));
			        if(jQuery(this).attr("ismust")== 1 && jQuery(this).parent("td").find(".txtlink").length != 0){
		    			jQuery("#"+$(this).attr("fieldNameSpan")).html("");
		    		}
		    	});
				
				//绑定checkbox事件
				jQuery(".item_checkbox").bind("click",function(){
					exeUpdate(jQuery(this).attr("name"),jQuery(this).is(":checked")?"1":"0","num");
				});
				
				$("div.tagitem").live("mouseover",function(){
					$(this).find("div.tagdel").show();
				}).live("mouseout",function(){
					$(this).find("div.tagdel").hide();
				});

				$("#tagaddbtn").bind("mouseover",function(){
					$(this).addClass("tagaddbtn_hover");
				}).bind("mouseout",function(){
					$(this).removeClass("tagaddbtn_hover");
				});

				$(document).bind("keydown",function(e){
					e = e ? e : event;   
				    if(e.keyCode == 13){
						var target=$.event.fix(e).target;
						if($(target).attr("id")=="addtag"){
				    		$("#tagsavebtn").click();
				    	}
				    }
				});

				<%if(canedit){%>
				
				$(".item_input").bind("focus",function(){
					$(this).addClass("item_input_focus");
					var _selectid = getVal($(this).attr("_selectid"));
					if(_selectid!=""){
						var _top = $(this).offset().top + 26;
						var _left = $(this).offset().left;
						if((_top+$("#"+_selectid).height())>$(window).height()){
							_top = _top-26-$("#"+_selectid).height();
						}
						$("#"+_selectid).css({"top":_top,"left":_left}).show();
						$(this).width(100);
					}
					if(this.id=="introduction"){
						$(this).height(70);
					}
					tempval = $(this).val();
					foucsobj2 = this;
				}).bind("blur",function(){
					$(this).removeClass("item_input_focus");
					if(this.id=="introduction"){
						setRemarkHeight(this.id);
					}
					if(!$(this).hasClass("input_select")){
						doUpdate(this,1);
					}
				}).hover(function(){
					$(this).addClass("item_input_hover");
				},function(){
					$(this).removeClass("item_input_hover");
				});
				
				
					
				//表格行背景效果及操作按钮控制绑定
				$("table.LayoutTable").find("td.field").bind("click mouseenter",function(){
					$(".btn_add").hide();
					$(".btn_browser").hide();
					$(this).addClass("td_hover").prev("td.title").addClass("td_hover");
					$(this).find(".item_input").addClass("item_input_hover");
					
					$(this).find("div.e8_os").show();
					$(this).find("span.browser").show();
					$(this).find(".calendar").show();
					$(this).find("div.e8_txt").hide();
					
					//对select框进行处理
					$(this).find(".sbHolder").parent().show();
					$(this).find("div.e8_select_txt").hide();
					
					//$(this).find(".item_num").width(100);
					if($(this).find("input.add_input2").css("display")=="none"){
						$(this).find("div.btn_add").show();
						$(this).find("div.btn_browser").show();
					}
					$(this).find("div.btn_add2").show();
					$(this).find("div.btn_browser2").show();
					if($(this).attr("id")=="websitetd") $("#websitelink").show();
					if($(this).attr("id")=="emailtd") $("#emaillink").show();
					//$(this).find("div.upload").show();
				}).bind("mouseleave",function(){
					$(this).removeClass("td_hover").prev("td.title").removeClass("td_hover");
					$(this).find(".item_input").removeClass("item_input_hover");
					
					$(this).find("div.e8_os").hide();
					$(this).find("span.browser").hide();
					$(this).find(".calendar").hide();
					$(this).find("div.e8_txt").show();
					
					//对select框进行处理
					if($(this).find(".sbHolder").length>0){
						var sb=$(this).find("select").attr("sb");
						var e=event?event:window.event;
						if($("#sbOptions_"+sb).parent().is(":hidden")){
							$(this).find(".sbHolder").parent().hide();
							$(this).find("div.e8_select_txt").show();
						}	
					}	
					
					//$(this).find(".item_num").width(40);
					if($(this).find("input.add_input2").css("display")=="none"){
						$(this).find("div.btn_add").hide();
						$(this).find("div.btn_browser").hide();
					}
					$(this).find("div.btn_add2").hide();
					$(this).find("div.btn_browser2").hide();
					if($(this).attr("id")=="websitetd") $("#websitelink").hide();
					if($(this).attr("id")=="emailtd") $("#emaillink").hide();
					//$(this).find("div.upload").hide();
				});
				
				$(".sbHolder").parent().hide();
				
				
				
				$("div.item_option").bind("mouseover",function(){
					$(this).addClass("item_option_hover");
				}).bind("mouseout",function(){
					$(this).removeClass("item_option_hover");
				}).bind("click",function(){
					var _inputid = $(this).parent().attr("_inputid")
					var obj = $("#"+_inputid);
					var _val = $(this).attr("_val");
					<%if(!crmmanager){%>
					if(_inputid=="source" && (_val==2||_val==8||_val==19||_val==20||_val==30||_val==31||_val==32)){
						if(!confirm("修改为此来源后非CRM管理员将无权限再修改此字段,确定修改?")){
							return;
						}
					}
					<%}%>
					if(_inputid=="status" && (_val==7 || _val==8 ||  _val==10)){
						if(!confirm("确定冻结此客户?")){
							return;
						}
					}
					
					tempval = obj.val();
					obj.val(_val);
					$("#"+_inputid+"name").val($(this).html());
					
					doUpdate(obj,1);
				});

				
				//输入添加按钮事件绑定
				$("div.btn_add").bind("click",function(){
					$(this).hide();
					$(this).nextAll("div.btn_browser").hide();
					$(this).prevAll("div.showcon").hide();
					$(this).prevAll("input.add_input").show().focus();
					$(this).prevAll("input.add_input2").show().focus();
					$(this).prevAll("div.btn_select").show();
				});
				//联想输入框事件绑定
				$("input.add_input2").bind("focus",function(){
					if($(this).attr("_init")==1){
						$(this).FuzzyQuery({
							url:"/CRM/manage/util/GetData.jsp",
							record_num:5,
							filed_name:"name",
							searchtype:$(this).attr("_searchtype"),
							divwidth: $(this).attr("_searchwidth"),
							updatename:$(this).attr("id"),
							operate:"select",
							updatetype:"str"
						});
						$(this).attr("_init",0);
					}
					foucsobj2 = this;
				}).bind("blur",function(e){
					$(this).val("");
					$(this).hide();
					$(this).nextAll("div.btn_add").show();
					$(this).nextAll("div.btn_browser").show();
					$(this).prevAll("div.showcon").show();
				});

				$("div.datamore").live("mouseover",function(){
					$(this).addClass("datamore_hover");
				}).live("mouseout",function(){
					$(this).removeClass("datamore_hover");
				});
				
				$("#leftdiv").scroll(function(){
					$("div.item_select").hide();
					$("div.select_div").hide();
				});

				//页面点击及回车事件绑定
				$(document).bind("click",function(e){
					var target=$.event.fix(e).target;
					if(!$(target).hasClass("item_select")){
						$("div.item_select").hide();
						if($(target).hasClass("input_select")){
							var _selectid = $(target).attr("_selectid");
							$("#"+_selectid).show();
						}
					}
				}).bind("keydown",function(e){
					e = e ? e : event;   
				    if(e.keyCode == 13){
						var target=$.event.fix(e).target;
						if($(target).hasClass("item_input") && $(target).attr("id")!="introduction"){
				    		$(foucsobj2).blur();  
				    		$("div.item_select").hide();
				    	}
				    }
				});

				cancelAddContacter();
				<%}%>

				//关注事件绑定
				$("div.btn_att").bind("click",function() {
					var attobj = $(this);
					var _special = attobj.attr("_special");
					var customerid =  attobj.attr("_customerid");
					$.ajax({
						type: "post",
						url: "/CRM/manage/util/Operation.jsp",
					    data:{"operation":"do_attention","operatetype":1,"objid":customerid,"settype":_special}, 
					    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
					    complete: function(data){ 
					    	if(_special==1){
								attobj.attr("title","取消关注").attr("_special","0").html("取消关注");
							}else{
								attobj.attr("title","标记关注").attr("_special","1").html("标记关注");
							}
					    	showMsg();
					    }
				    });
				});

				//收缩展开绑定
				$(".btn_center").bind("mouseover",function(){
					//$(this).addClass("btn_right");
				}).bind("mouseout",function(){
					//$(this).removeClass("btn_right");
				}).bind("click",function(){
					$(this).show();
					var _status = $(this).attr("_status");
					if(_status==0){
						$(".btn_center").attr("_status",1).attr("title","展开客户联系");
						$("#righttd").animate({width:0},200,null,function(){
							$(this).hide();
						});
					}else{
						$(".btn_center").attr("_status",0).attr("title","收缩客户联系");
						$("#righttd").animate({width:'35%'},200,null,function(){
							$(this).show();
						}).show();
					}
					$(".btn_center").show();
					$(this).hide();
					$("#contentframe")[0].contentWindow.initMainHeight();
					setPosition();
				});

				$("div.csmenu").bind("mouseover",function(){
					var _top = $(this).offset().top + 26;
					var _left = $(this).offset().left;
					$("div.menu_select").css({"top":_top,"left":_left}).show();
				}).bind("mouseout",function(){
					$("div.menu_select").hide();
				});
				$("div.menu_select").bind("mouseover",function(){
					$(this).show();
				}).bind("mouseout",function(){
					$(this).hide();
				});
				$("div.menu_option").bind("mouseover",function(){
					$(this).addClass("menu_option_hover");
				}).bind("mouseout",function(){
					$(this).removeClass("menu_option_hover");
				}).bind("click",function(){
					var _frameid = $(this).attr("_frameid");
					var _url = $(this).attr("_url"); 
					if($("#"+_frameid).attr("src")==""){
						$("#"+_frameid).attr("src",_url);
					}
					$("#baseinfo").hide();
					$(".infoframe").hide();
					$("#"+_frameid).show();
					$("div.tabmenu").removeClass("tabmenu_click");
					$("div.menu_select").hide();
				});

				

				setPosition();
				setRemarkHeight("introduction");

				//$("#btn_center2").click();
				
				/**
				var hh = $("#leftdiv").height();
				$("#leftdiv").mCustomScrollbar({
					scrollInertia:500,
					mouseWheelPixels:200,
					scrollEasing:"easeOutQuint",
					scrollButtons:{
						enable:false,
						scrollType:"pixels",
						scrollSpeed:20
					},
					advanced:{
						updateOnBrowserResize:true, 
						updateOnContentResize:true, 
						autoExpandHorizontalScroll:false, 
						autoScrollOnFocus:true 
					}
				});*/
			});

			var resizeTimer = null;  
			$(window).resize(function(){
				if(resizeTimer) clearTimeout(resizeTimer);  
				resizeTimer = setTimeout("setPosition()",100);  
			});
			
			function onShowDate1(spanname,inputname,mand){
			  tempval = $ele4p(inputname).value;
			  var fieldName = jQuery($ele4p(inputname)).parent("td").find("input").attr("name");
			  var oncleaingFun = function(){
				    if(mand == 1){
					 	$ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
					}else{
					  	$ele4p(spanname).innerHTML = '';
					}
					$ele4p(inputname).value = '';
			  }
			  WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
					$dp.$(inputname).value = dp.cal.getDateStr();
					$dp.$(spanname).innerHTML = dp.cal.getDateStr();
				   	if($ele4p(inputname).value!=tempval){
				   		exeUpdate(fieldName,$ele4p(inputname).value,"str");
				   	}
					
			 },oncleared:oncleaingFun});
			   
			   
			   
			   if(mand == 1){
			     var hidename = $ele4p(inputname).value;
				 if(hidename != ""){
					$ele4p(inputname).value = hidename; 
					$ele4p(spanname).innerHTML = hidename;
				 }else{
				   $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
				 }
			   }
			}
			
			function setPosition(){
				var ww = document.body.clientWidth;
				if(ww<1000){
					$("#main").width(1000);
				}else{
					$("#main").width("100%");
				}
				//var wh = document.body.clientHeight;
				var wh = $(window).height();
				//if(wh2<wh){wh=wh2;}
				//alert(wh);
				
				$("#main").height(wh);
				$(".infoframe").height(wh-50);
				
				var _top = $("#contactdiv").offset().top;
				$("#contactdiv").height(wh-_top-5);

				var _top2 = $("#leftdiv").offset().top;
				$("#leftdiv").height(wh-_top2-5+"px");
				
				$("#leftinfo").height(wh-_top2-5+"px");
				
				

				//if(_relid!="") onAddContacter(_relid);
				//$("#maininfo").height($("#main").height()-_top-$("#fbmain").height()-5);
			}
			function setRemarkHeight(remarkid){
				if($("#"+remarkid).length>0){
					$("#"+remarkid).height("auto");
					var h= document.getElementById(remarkid).scrollHeight; 
					if(h>70){
						$("#"+remarkid).height(70);
					}else if(h<20 || ($("#"+remarkid).val().indexOf("\n")<0 && h==34)){
						$("#"+remarkid).height(20);
					}else{
						$("#"+remarkid).height(h);
					}
				}
			}

			//提醒操作
			function doRemind(settype){
				$.ajax({
					type: "post",
					url: "/CRM/manage/util/Operation.jsp",
				    data:{"operation":"do_remind","operatetype":1,"objid":"<%=customerid%>","settype":settype}, 
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    complete: function(data){ 
					    if(settype==1) showMsg();
				    }
			    });
			}
			function setLastUpdate(){
				
				var currentdate = new Date();
				var datestr = currentdate.format("yyyy-MM-dd hh:mm:ss");
				//var timestr = currentdate.format("hh:mm:ss");
				//$("#lastupdate").html("由 <a href='/hrm/resource/HrmResource.jsp?id=<%=user.getUID()%>' target='_blank'><%=ResourceComInfo.getLastname(user.getUID()+"")%></a> 于 <font title='"+timestr+"'>"+datestr+"</font> 最后修改");

				document.title="<%=titlestr%>由 <%=ResourceComInfo.getLastname(user.getUID()+"")%> 于 "+datestr+" 最后修改";
				showMsg();
			}
			
			function moreInfo(obj){
				var _status = $(obj).attr("_status");
				var _hh = $("#moretable").height();
				if(_status==1){
					$("#moreinfo").animate({height:_hh},300,null,function(){});
					$(obj).attr("_status",0).attr("title","点击收缩").css("background","url('../images/btn_up2_wev8.png')");
				}else{
					$("#moreinfo").animate({height:0},300,null,function(){});
					$(obj).attr("_status",1).attr("title","点击展开").css("background","url('../images/btn_down2_wev8.png')");
				}
			}

			function setFrameHeight(sellchanceid,height){
				$("#sellchance_"+sellchanceid).height(height);
			}
			function remveFrame(sellchanceid){
				$("#div_sellchance_"+sellchanceid).remove();
			}
			function addContact(objid,type){
				if(type==1){
					$("#sellchanceid").val(objid);
					$("#contacterid").val("");
				}else{
					$("#contacterid").val(objid);
					$("#sellchanceid").val("");
				}
				var _status = $("#btn_center").attr("_status");
				if(_status==1){
					$("#btn_center").click();
				}
				$("#ContactInfo").focus();
			}

			<%if(canedit){%>
			//商机卡片中调整阶段是调用
			function checkss(_val){
				var msgstr = "";
				//检测向导人是否关联
				if(_val>2){
					var temp=0;
					$("input.rel_pr").each(function(){
						if($(this).val().indexOf("内部向导")>-1){
							temp = 1;
							return;
						}
					});
					if(temp==0){
						msgstr += "未确定内部向导\n";
						//alert("请确定内部向导！");
						//return false;
					}
				}
				//检测决策人是否关联
				if(_val>3){
					var temp=0;
					$("input.rel_pr").each(function(){
						if($(this).val().indexOf("项目决策人")>-1){
							temp = 1;
							return;
						}
					});
					if(temp==0){
						msgstr += "未确定项目决策人\n";
						//alert("请确定项目决策人！");
						//return false;
					}
				}
				//检测高层是否关联
				if(_val>4){
					var temp=0;
					$("input.rel_pr").each(function(){
						if($(this).val().indexOf("客户高层")>-1){
							temp = 1;
							return;
						}
					});
					if(temp==0){
						msgstr += "未确定客户高层\n";
						//alert("请确定客户高层！");
						//return false;
					}
				}
				return msgstr;
			}
			
			var viewscid = "";
			//显示日志
			function showLog(sellchanceid,sellchancename){
				var _url = "/CRM/manage/customer/Operation.jsp";
				if(sellchanceid!="" && sellchanceid!=null){
					viewscid = sellchanceid;
					$("#scname").html(sellchancename);
					_url = "/CRM/manage/sellchance/Operation.jsp";
				}else{
					viewscid = "";
					$("#scname").html("");
				}
				
				$("#transbg").show();
				$("#log_list").show();
				$("#log_load").show();
				alert(_url);
				$.ajax({
					type: "post",
				    url: _url,
				    data:{"operation":"get_log_count","customerid":<%=customerid%>,"sellchanceid":sellchanceid}, 
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    complete: function(data){ 
					    var txt = $.trim(data.responseText);
				    	$("#logmore").attr("_total",txt).attr("_currentpage","0").click();
					}
			    });
			}
			
			function showLog1(sellchanceid,sellchancename){
			
				var _url = "/CRM/manage/customer/Operation.jsp";
				if(sellchanceid!="" && sellchanceid!=null){
					_url = "/CRM/manage/sellchance/Operation.jsp";
				}
			
				dialog = new window.top.Dialog();
				dialog.currentWindow = window;
				var url = _url+"?customerid=<%=customerid%>&operation=get_log_count&sellchanceid="+sellchanceid;
				alert(url);
				dialog.Title = "日志明细";
				
				dialog.ShowButtonRow=false;
				dialog.Width = 550;
				dialog.Height =500;
				dialog.Drag = true;
				dialog.URL = url;
				dialog.show();
				
			}
			
			
			//关闭日志
			function closeLog(){
				$("#transbg").hide();
				$("#log_list").hide();
				$("div.logitem").remove();
			}
			//读取日志更多记录
			function getListLog(obj){
				var _url = "Operation.jsp";
				if(viewscid!=""){
					_url = "/CRM/manage/sellchance/Operation.jsp";
				}
				var _currentpage = parseInt($(obj).attr("_currentpage"))+1;
				var _pagesize = $(obj).attr("_pagesize");
				var _total = $(obj).attr("_total");
				$(obj).html("<img src='../images/loading3_wev8.gif' align='absMiddle'/>");
				$.ajax({
					type: "post",
				    url: _url,
				    data:{"operation":"get_log_list","customerid":<%=customerid%>,"sellchanceid":viewscid,"currentpage":_currentpage,"pagesize":_pagesize,"total":_total}, 
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    complete: function(data){ 
				    	var records = $.trim(data.responseText);
				    	$("#log_load").hide();
				    	$(obj).before(records);
				    	if(_currentpage*_pagesize>=_total){
				    		$(obj).hide();
					    }else{
					    	$(obj).attr("_currentpage",_currentpage).html("更多").show();
						}
					}
			    });
			}
			
			//输入框保存方法
			function doUpdate(obj,type){
				var fieldname = $(obj).attr("id");
				var fieldtype = getVal($(obj).attr("_type"));
				if(fieldtype=="") fieldtype="str";
				var fieldvalue = "";
				if(type==1){
					if($(obj).val()==tempval) return;
					fieldvalue = $(obj).val();
				}
				if(fieldname=="name" || fieldname=="address1" || fieldname=="engname" || fieldname=="phone" || fieldname=="email" || fieldname=="CreditAmount" || fieldname=="CreditTime"){
					if(fieldvalue=="") {
						$(obj).val(tempval);
						return;
					}
				}
				if(fieldname=="email"){
					var emailStr = $(obj).val().replace(" ","");
					if (!checkEmail(emailStr)) {
						$(obj).val(tempval);
						return;
					}
				}
				if(obj.nodeName=="SELECT"){
					$("#txtdiv_"+fieldname).html($(obj).find("option[value="+fieldvalue+"]").text()).show();
					var sb=$(obj).attr("sb");
					$("#sbHolderSpan_"+sb).hide();
				}
				exeUpdate(fieldname,fieldvalue,fieldtype);
			}
			//删除选择性内容
			function doDelItem(fieldname,fieldvalue,setid){
				$("#"+fieldname).prevAll("div.txtlink"+fieldvalue).remove();
				if(fieldname=="exploiterIds" || fieldname=="principalIds"){
					var vals = ","+$("#"+fieldname+"_val").val()+",";
					var _index = vals.indexOf(","+fieldvalue+",")
					if(_index>-1 && $.trim(fieldvalue)!=""){
						vals = vals.substring(0,_index+1)+vals.substring(_index+(fieldvalue+"").length+2);
						if(vals!="" && vals!=","){
							vals = vals.substring(1,vals.length-1);
						}else{
							vals = "";
						}
						$("#"+fieldname+"_val").val(vals);
						exeUpdate(fieldname,vals,'',fieldvalue);
					}
				}else{
					exeUpdate(fieldname,'0','num');
				}
			}
			
			function callBackSelectUpdate(event,data,name,oldid){
				doSelectUpdate(name,data.id,data.name,oldid);
			}
			
			//选择内容后执行更新
			function doSelectUpdate(fieldname,id,name,oldid){
				var addtxt = "";
				var fieldtype = "num";

				if(fieldname=="exploiterIds" || fieldname=="principalIds"){
					var sumids = "";
					var addids = "";
					var ids = id.split(",");
					var names = name.split(",");
					var vals = $("#"+fieldname+"_val").val();
					for(var i=0;i<ids.length;i++){
						if((","+vals+",").indexOf(","+ids[i]+",")<0 && $.trim(ids[i])!=""){
							addids += "," + ids[i];
							addtxt += doTransName(fieldname,ids[i],names[i]);
						}
					}
					if(addids==""){
						return;
					}else{
						addids = addids.substring(1);
						sumids = addids;
						if(vals!="") sumids = vals+","+addids;
						$("#"+fieldname).before(addtxt);
						$("#"+fieldname+"_val").val(sumids);
						exeUpdate(fieldname,sumids,"","",addids);
					}
				}else{
					tempval = oldid;
					if(tempval==id) return;

					if(fieldname=="manager"){
						if(!confirm("提示：修改客户经理后将会失去此客户的默认权限!确定修改?")){
							return;
						}
						$("#minfo").hide();
						$("#mload").show();
					}
					
					$("#txtdiv_"+fieldname).html(name);
					//addtxt = doTransName(fieldname,id,name);
					//$("#"+fieldname).prev("div.txtlink").remove();
					//$("#"+fieldname).before(addtxt);
					exeUpdate(fieldname,id,"num");
				}
			}
			
			
			//显示删除按钮
			function showdel(obj){
				$(obj).find("div.btn_del").show();
				$(obj).find("div.btn_wh").hide();
			}
			//隐藏删除按钮
			function hidedel(obj){
				$(obj).find("div.btn_del").hide();
				$(obj).find("div.btn_wh").show();
			}

			function onShowBrowser(fieldname,url){
				var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
			    if (datas) {
				    if(datas.id!=""){
				    	doSelectUpdate(fieldname,datas.id,datas.name);
					}
			    }
			}
			
			function mailValid() {
				var emailStr = jQuery("#CEmail").val();
				emailStr = emailStr.replace(" ","");
				if (!checkEmail(emailStr)) {
					alert("<%=SystemEnv.getHtmlLabelName(18779,user.getLanguage())%>");
					jQuery("#CEmail").focus();
					return;
				}
			}
					
			function doTransName(fieldname,id,name){
				var delname = fieldname;
				if(startWith(fieldname,"_")) fieldname = fieldname.substring(1);
				var restr = "";
				restr += "<div class='txtlink ";
				if(fieldname=="manager" || fieldname=="agent" || fieldname=="parentid" || fieldname=="documentid" || fieldname=="introductionDocid"){restr += "showcon";}
				restr += " txtlink"+id+"' onmouseover='showdel(this)' onmouseout='hidedel(this)'>";
				restr += "<div style='float: left;'>";
					
				if(fieldname=="manager" || fieldname=="exploiterIds" || fieldname=="principalIds"){
					restr += "<a href='/hrm/resource/HrmResource.jsp?id="+id+"' target='_blank'>"+name+"</a>";
				}else if(fieldname=="agent"){
					restr += "<a href=javaScript:openFullWindowHaveBar('/CRM/data/ViewCustomer.jsp?log=n&CustomerID="+id+"') >"+name+"</a>";
				}else if(fieldname=="documentid" || fieldname=="introductionDocid"){
					restr += "<a href=javaScript:openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id="+id+"') >"+name+"</a>";
				}else{
					restr += name;
				}
				restr +="</div>";
				if(fieldname!="manager" && fieldname!="city" && fieldname!="type" && fieldname!="description" && fieldname!="size_n"
					&& fieldname!="source" && fieldname!="sector"){
					restr += "<div class='btn_del' onclick=\"doDelItem('"+delname+"','"+id+"')\"></div>"
					   		+ "<div class='btn_wh'></div>";
				}
				restr += "</div>";
				return restr;
			}
			<%}%>
			
			
			<%if(canedit || canunfreeze){%>
			//执行编辑
			function exeUpdate(fieldname,fieldvalue,fieldtype,delvalue,addvalue,setid){
				var _tempval = tempval;
				if(typeof(delvalue)=="undefined") delvalue = "";
				if(typeof(addvalue)=="undefined") addvalue = "";
				if(fieldtype == "attachment"){
					var ismust = jQuery("div[fieldName='"+fieldname+"']").attr("ismust");
		    		if(ismust==1 && jQuery("div[fieldName='"+fieldname+"']").parent("td").find(".txtlink").length == 1){
		    			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30702,user.getLanguage())%>");
		    			return;
		    		}
				}
				
				
				$.ajax({
					type: "post",
				    url: "Operation.jsp",
				    data:{"operation":"edit_customer_field","customerid":<%=customerid%>,"setid":setid,"fieldname":filter(encodeURI(fieldname)),"oldvalue":filter(encodeURI(tempval)),"newvalue":filter(encodeURI(fieldvalue)),"fieldtype":fieldtype,"delvalue":encodeURI(delvalue),"addvalue":encodeURI(addvalue)}, 
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    complete: function(data){ 
					    //var txt = $.trim(data.responseText);
					    setLastUpdate();
				    	if(fieldname=="manager"){
				    		$("#minfo").show();
							$("#mload").hide();
							window.location = "CustomerBaseView.jsp?CustomerID=<%=customerid%>&isrequest=<%=isrequest%>&requestid=<%=requestid%>&nolog=1";
				    	}
				    	if(fieldname=="website"){
							$("#websitelink").attr("href",fieldvalue);
					    }
				    	if(fieldname=="email"){
							$("#emaillink").attr("href","mailto:"+fieldvalue);
					    }
				    	if(fieldname=="type" && fieldvalue=="19"){//个人用户
				    		window.location = "ViewPerCustomer.jsp?CustomerID=<%=customerid%>";
					    }
				    	if(fieldname=="type" && (fieldvalue=="26" || _tempval=="26")){//人脉
				    		window.location = "CustomerBaseView.jsp?CustomerID=<%=customerid%>&isrequest=<%=isrequest%>&requestid=<%=requestid%>&nolog=1";
					    }
				    	<%if(!crmmanager){%>
				    	if(fieldname=="source" && (fieldvalue==2||fieldvalue==8||fieldvalue==19||fieldvalue==20||fieldvalue==30||fieldvalue==31||fieldvalue==32)){
							$("#sourcetd").html("<div class='div_show'>"+$("#sourcename").val()+"</div>");
						}
						<%}%>
						if(fieldname=="status" && (_tempval=="4" || _tempval=="5" || _tempval=="6" || _tempval=="7" || _tempval=="8" || _tempval=="10")){
							window.location = "CustomerBaseView.jsp?CustomerID=<%=customerid%>&isrequest=<%=isrequest%>&requestid=<%=requestid%>&nolog=1";
				    	}
						if(fieldname=="status" && (fieldvalue==7||fieldvalue==8||fieldvalue==10)){
							window.location = "CustomerBaseView.jsp?CustomerID=<%=customerid%>&isrequest=<%=isrequest%>&requestid=<%=requestid%>&nolog=1";
				    	}
				    	
				    	if(fieldtype == "attachment"){
				    		jQuery(".txtlink"+delvalue).remove();
				    		var ismust = jQuery("div[fieldName='"+fieldname+"']").attr("ismust");
				    		if(ismust==1 && jQuery("div[fieldName='"+fieldname+"']").parent("td").find(".txtlink").length == 0){
				    			var fieldNameSpan = jQuery("div[fieldName='"+fieldname+"']").attr("fieldNameSpan");
				    			jQuery("#"+fieldNameSpan).html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
				    		}
				    	}
					}
			    });
				tempval = fieldvalue;
			}
			<%}%>

			//显示共享
			var sharetag = 0;
			function showShare(){
				$("#transbg").show();
				$("#share_list").show();
				$("#share_detail").show();
				$("#share_add").hide();
				if(sharetag==0){
					$("#share_load").show();
					$.ajax({
						type: "post",
					    url: "/CRM/manage/customer/ViewShare.jsp",
					    data:{"CustomerID":<%=customerid%>}, 
					    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
					    complete: function(data){
					    	sharetag = 1; 
						    var txt = $.trim(data.responseText);
						    $("#share_load").hide().before(txt);
						}
				    });
				}
			}
			//关闭共享
			function closeShare(){
				$("#transbg").hide();
				$("#share_list").hide();
			}
			<%if(canedit){%>
			//添加共享
			function addShare(){
				$("#share_detail").hide();
				$("#share_add").show();
			}
			function execAddShare(){
				var relatedshareid = $.trim($("#relatedshareid").val());
				var sharetype = $.trim($("#sharetype").val());
				var rolelevel = $.trim($("#rolelevel").val());
				var shareseclevel = $.trim($("#shareseclevel").val());
				var sharelevel = $.trim($("#sharelevel").val());
				if(relatedshareid=="" || sharetype=="" || rolelevel==""
					 || shareseclevel=="" || sharelevel==""){
					alert("必要信息不完整!");
					return;
				}
				$("#shareadd_load").show();
				$.ajax({
					type: "post",
				    url: "/CRM/data/ShareOperation.jsp",
				    data:{"method":"add","CustomerID":<%=customerid%>,"itemtype":2
					,"relatedshareid":relatedshareid,"sharetype":sharetype,"rolelevel":rolelevel,"seclevel":shareseclevel,"sharelevel":sharelevel}, 
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    complete: function(data){
				    	$("#shareadd_load").hide();
					    $("#sharetable").remove();
					    sharetag=0;
					    showShare();
					}
			    });
			}
			function cancelAddShare(){
				$("#share_detail").show();
				$("#share_add").hide();
			}
			//删除共享
			function deleteShare(shareid){
				if(confirm("确定删除共享?")){
					$("#delbtn_"+shareid).show();
					$("#delload_"+shareid).show();
					$.ajax({
						type: "post",
					    url: "/CRM/data/ShareOperation.jsp",
					    data:{"method":"delete","CustomerID":<%=customerid%>,"id":shareid}, 
					    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
					    complete: function(data){
						    $("#sharetr_"+shareid).remove();
						}
				    });
				}
			}
			<%}%>
			function urlSubmit(obj,url){
			    window.open(url);
			}

			//显示相关流程
			var relatewftag = 0;
			function showRelateWF1(){
				$("#transbg").show();
				$("#relatewf_list").show();
				$("#relatewf_detail").show();
				if(relatewftag==0){
					$("#relatewf_load").show();
					$.ajax({
						type: "post",
					    url: "/CRM/manage/customer/ViewRelateWF.jsp",
					    data:{"customerid":<%=customerid%>}, 
					    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
					    complete: function(data){
					    	relatewftag = 1; 
						    var txt = $.trim(data.responseText);
						    $("#relatewf_load").hide().before(txt);
						}
				    });
				}
			}
			
			var dialog=null;
			function showRelateWF(){
			
				dialog = new window.top.Dialog();
				dialog.currentWindow = window;
				var url = "/CRM/manage/customer/ViewRelateWF.jsp?customerid=<%=customerid%>";
				dialog.Title = "相关流程";
				
				dialog.ShowButtonRow=false;
				dialog.Width = 550;
				dialog.Height =500;
				dialog.Drag = true;
				dialog.URL = url;
				dialog.show();
				
			}
			
			//关闭共享
			function closeRelateWF(){
				$("#transbg").hide();
				$("#relatewf_list").hide();
			}

			function doAddWorkPlan() {
				window.open("/workplan/data/WorkPlan.jsp?crmid=<%=customerid%>&add=1");
			}
			function doAddWorlFlow(){
				window.open("/workflow/request/RequestType.jsp?topage=<%=topage%>&crmid=<%=customerid%>");
			}
			var dialog = null;
			function doAddCowork(){
				dialog = new window.top.Dialog();
				dialog.currentWindow = window;
				var url = "/cowork/AddCoWork.jsp?CustomerID=<%=customerid%>";
				dialog.Title = "<%=SystemEnv.getHtmlLabelName(27411,user.getLanguage()) %>";
				dialog.Width = 680;
				dialog.Height = 520;
				dialog.Drag = true;
				dialog.maxiumnable = true;
				dialog.URL = url;
				dialog.show();
				document.body.click();
			}
			function doAddEmail(){
				window.open("/email/MailAdd.jsp?to=<%=Util.convertInput2DB(mailAddress)%>");
			}
			function exportContact(){
				window.open("/docs/docs/DocList.jsp?crmid=<%=customerid%>&isExpDiscussion=y");
			}
			function doAddSellChance(){
				openFullWindowHaveBar('/CRM/manage/sellchance/SellChanceAdd.jsp?CustomerID=<%=customerid%>');
			}
			function doContactRemind(){
				openFullWindowHaveBar('/CRM/manage/util/SendContactRemind.jsp?customerid=<%=customerid%>');
			}
			function doWSearch(){
				openFullWindowHaveBar('/system/QuickSearchOperation.jsp?searchtype=9&searchvalue=<%=name%>');
			}
			function openKS(){
				openFullWindowHaveBar('/knowledgeshare/data/DataFrame.jsp?issearch=1&searchtype=&searchname=<%=name%>');
			}
			<%if(canunfreeze){%>
			function doUnfreeze(){
				if(confirm("确定解冻客户?")){
					tempval = "<%=status%>";
					exeUpdate("status","4","num");
				}
			}
			<%}%>

			function doSaveTag(){
				var tagstr = $.trim($("#addtag").val());
				if(tagstr!=""){
					var hastag = false;
					$("div.tagitem").each(function(){
						if($(this).attr("_val")==tagstr){
							hastag = true;
							return;
						}
					});
					if(hastag){
						$("#addtag").val("");
						alert("已存在此标签！");
						$("#addtag").focus();
						return;
					}
					$.ajax({
						type: "post",
					    url: "Operation.jsp",
					    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
					    data:{"operation":"save_tag","customerid":"<%=customerid%>","tag":filter(encodeURI(tagstr))}, 
					    complete: function(data){ 
						    var txt = $.trim(data.responseText);
						    $.trim($("#addtag").val(""));
						    //$("#tagdiv").append(txt);
						    $("#tagaddbtn").before(txt);
						    cancelTag();
						}
				    });
				}else{
					alert("请输入标签内容！");
					$("#addtag").focus();
					return;
				}
			}
			function doAddTag(){
				$("#tagaddbtn").hide();
				$("#tagpanel").show();
				$("#addtag").focus();
			}
			function cancelTag(){
				$("#addtag").val("");
				$("#tagaddbtn").show();
				$("#tagpanel").hide();
			}
			function doDelTag(tagstr,obj){
				if(tagstr!=""){
					if(confirm("确定删除此标签?")){
						$.ajax({
							type: "post",
						    url: "Operation.jsp",
						    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
						    data:{"operation":"del_tag","customerid":"<%=customerid%>","tag":filter(encodeURI(tagstr))}, 
						    complete: function(data){ 
							    var txt = $.trim(data.responseText);
							    $(obj).parent().remove();
							}
					    });
					}
				}
			}
			
			function markAttention(obj){
				var attobj = $(obj);
				var _special = attobj.attr("_special");
				var customerid =  attobj.attr("_customerid");
				$.ajax({
					type: "post",
					url: "/CRM/manage/util/Operation.jsp",
				    data:{"operation":"do_attention","operatetype":1,"objid":customerid,"settype":_special}, 
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    complete: function(data){ 
				    	if(_special==1){
							attobj.attr("title","取消关注").attr("_special","0").html("取消关注");
						}else{
							attobj.attr("title","标记关注").attr("_special","1").html("标记关注");
						}
				    	showMsg();
				    }
			    });
			}
			
			function getCrmDate(i){
			   WdatePicker({el:'datespan'+i,onpicked:function(dp){
				   $dp.$('dff0'+i).value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('dff0'+i).value = ''}});
			}
			
			function UniteCustomer(){
				dialog = new window.top.Dialog();
				dialog.currentWindow = window;
				var url = "/CRM/data/UniteCustomer.jsp?CustomerID=<%=customerid%>&isfromCrmTab=true";
				dialog.Title = "客户合并";
				
				dialog.OKEvent = function(){
					dialog.innerFrame.contentWindow.doSave();
				};
				
				dialog.ShowButtonRow=true;
				dialog.Width = 420;
				dialog.Height =200;
				dialog.Drag = true;
				dialog.URL = url;
				dialog.show();
			}
			
			function UniteCallback(CustomerID){
				window.top.location.href="/CRM/data/ViewCustomer.jsp?CustomerID="+CustomerID;
			}
			
			function UniteCallback(CustomerID){
				window.top.location.href="/CRM/data/ViewCustomer.jsp?CustomerID="+CustomerID;
			}
			
			//消息提醒
		  function showMsg(msg){
		   
			jQuery("#warn").find(".title").html("操作成功！");
			jQuery("#warn").css("display","block");
			setTimeout(function (){
				jQuery("#warn").css("display","none");
			},1500);
			
		  }
			
		</script>
	</body>
</html>
