
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<jsp:useBean id="rs_common" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsWordCount" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="hpec" class="weaver.homepage.cominfo.HomepageElementCominfo" scope="page"/>
<jsp:useBean id="hpu" class="weaver.homepage.HomepageUtil" scope="page"/>
<jsp:useBean id="ebc" class="weaver.page.element.ElementBaseCominfo" scope="page"/>
<jsp:useBean id="pc" class="weaver.page.PageCominfo" scope="page"/>
<jsp:useBean id="sm" class="weaver.synergy.SynergyManage" scope="page"/>
<jsp:useBean id="pu" class="weaver.page.PageUtil" scope="page" />

<%
	boolean isSystemer=false;
	if(HrmUserVarify.checkUserRight("homepage:Maint", user)) isSystemer=true;

	String eid=Util.null2String(request.getParameter("eid"));	
	String ebaseid=Util.null2String(request.getParameter("ebaseid"));
	

	String eTitleValue=Util.null2String(request.getParameter("eTitleValue"));
	eTitleValue = Util.toHtml(eTitleValue);
	String ePerpageValue=Util.null2String(request.getParameter("ePerpageValue"));	
	String eLinkmodeValue=Util.null2String(request.getParameter("eLinkmodeValue"));	
	String eFieldsVale=Util.null2String(request.getParameter("eFieldsVale"));
	String whereKeyStr=Util.null2String(request.getParameter("whereKeyStr"));
	String hpid=Util.null2String(request.getParameter("hpid"));	
	String eShowMoulde=Util.null2String(request.getParameter("eShowMoulde"));
	String eBackground=Util.null2String(request.getParameter("eBackground"));	
	String scrolltype = Util.null2String(request.getParameter("eScrollType"));
	int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"),-1);

	String esharelevel=Util.null2String(request.getParameter("esharelevel"));
	String eLogo=Util.null2String(request.getParameter("eLogo"));
	String eStyleid=Util.null2String(request.getParameter("eStyleid"));
	int eHeight=Util.getIntValue(request.getParameter("eHeight"),0);
	int eMarginTop=Util.getIntValue(request.getParameter("eMarginTop"),0);
	int eMarginBottom=Util.getIntValue(request.getParameter("eMarginBottom"),0);
	int eMarginLeft=Util.getIntValue(request.getParameter("eMarginLeft"),0);
	int eMarginRight=Util.getIntValue(request.getParameter("eMarginRight"),0);
	String newstemplate = Util.null2String(request.getParameter("newstemplate"));
	int imgType = Util.getIntValue(request.getParameter("imgType"),0);
	String imgSrc = Util.null2String(request.getParameter("imgSrc"));
	String isnew = Util.null2String(request.getParameter("isnew"));
    StringBuffer sb=new StringBuffer("");
    if("FormModeCustomSearch".equals(ebaseid)&&!"2".equals(esharelevel)){
		List<String> list = pu.getUserMaintHpidListPublic(user.getUID());
		if(list.contains(hpid)){
			esharelevel="2";	
		}
	}
    String remindtype="";
	if(!"".equals(isnew)){
	     isnew="0";
		 sb.append(isnew).append("_");
	}
	String isbold = Util.null2String(request.getParameter("isbold"));
	if(!"".equals(isbold)){
	     isbold="1";
		 sb.append(isbold).append("_");
	}
	String islean = Util.null2String(request.getParameter("islean"));
	if(!"".equals(islean)){
	     islean="2";
		 sb.append(islean).append("_");
	}
	String isrgb = Util.null2String(request.getParameter("isrgb"));
	String newcolor = Util.null2String(request.getParameter("newcolor"));
	if(!"".equals(isrgb)){
	     isrgb="3";
		 sb.append(isrgb).append("_").append(newcolor).append("_");
	}
	if(sb.length()>0)
	remindtype=sb.substring(0,sb.length()-1);

	int userid = 1;
	int usertype=0;
	userid=pu.getHpUserId(hpid,""+subCompanyId,user);
	usertype=pu.getHpUserType(hpid,""+subCompanyId,user);

	if(pc.getSubcompanyid(hpid).equals("-1")&&pc.getCreatortype(hpid).equals("0")){
		userid = 1;
		usertype=0;
	}
	//
	if(Util.getIntValue(hpid)<0)//协同的 userid  和 usertype 为 1  和 0
	{
		userid = 1;
		usertype = 0;
	}
	
	//System.out.println("esharelevel: "+esharelevel);
	
	String strSql_Common="";
	if(eLinkmodeValue.equals("")){
		eLinkmodeValue = "3";
	}
	
	strSql_Common="update hpElementSettingDetail set perpage="+ePerpageValue+" ,isremind='"+remindtype+"',linkmode='"+eLinkmodeValue+"', showfield='"+eFieldsVale+"'  where eid="+eid+" and userid="+userid+" and usertype="+usertype  ;

	rs_common.executeSql(strSql_Common);	

	rs_common.executeSql("delete hpFieldLength where eid="+eid+" and userid="+userid+" and usertype="+usertype);

	strSql_Common="select id,islimitlength, fieldColumn from hpFieldElement where elementid='"+ebaseid+"'";		
	rs_common.executeSql(strSql_Common);	
	while(rs_common.next()){
		String id=Util.null2String(rs_common.getString("id"));
		String islimitlength=Util.null2String(rs_common.getString("islimitlength"));
		String fieldcolumn=Util.null2String(rs_common.getString("fieldColumn"));
		
		if(fieldcolumn.toLowerCase().equals("img")){
			String imgSize = Util.null2String(request.getParameter("imgSizeStr"));
			rsWordCount.executeSql("insert into hpFieldLength (eid,efieldid,charnum,imgsize,userid,usertype,imgtype,imgsrc) values ("+eid+","+id+",8,'"+imgSize+"',"+userid+","+usertype+",'"+imgType+"','"+imgSrc+"')");
		}
		
		int wordCount=0;			
		
		if("1".equals(islimitlength)) {
			wordCount=Util.getIntValue(request.getParameter("wordcount_"+id),0);
			rsWordCount.executeSql("insert into hpFieldLength (eid,efieldid,charnum,userid,usertype,imgtype,imgsrc) values ("+eid+","+id+","+wordCount+","+userid+","+usertype+",'"+imgType+"','"+imgSrc+"')");
			//System.out.println("wordcount_"+id +":"+wordCount);			
		}
	}	
	

	if("2".equals(esharelevel)){
//		if(ebaseid.equals("reportForm")&&whereKeyStr.contains("'")){
//			whereKeyStr = Util.toHtml(whereKeyStr);
//		}
		
		if(ebaseid.equals("29")){			
			strSql_Common="update hpElement set title='"+eTitleValue+"',logo='"+eLogo+"',styleid='"+eStyleid+"',height="+eHeight+",marginTop="+eMarginTop+",marginBottom="+eMarginBottom+",marginLeft="+eMarginLeft+",marginRight="+eMarginRight+",scrolltype='"+scrolltype+"',newstemplate='"+newstemplate+"' where id="+eid;
		}else{
			strSql_Common="update hpElement set title='"+eTitleValue+"',strsqlwhere='"+whereKeyStr+"',"
				+"logo='"+eLogo+"',styleid='"+eStyleid+"',height="+eHeight+",marginTop="+eMarginTop+","
				+"marginBottom="+eMarginBottom+",marginLeft="+eMarginLeft+",marginRight="+eMarginRight+","
				+"scrolltype='"+scrolltype+"',newstemplate='"+newstemplate+"',isremind='"+remindtype+"' where id="+eid;
			//System.out.println("operationCommon.jsp::>strSql_Common："+strSql_Common);
		}
		//System.out.println(strSql_Common);
		rs_common.executeSql(strSql_Common);
		
	//	rs_common.execute("select * from hpelement where id = "+eid);
	//	rs_common.next();
	//	System.out.println(rs_common.getString("strsqlwhere"));
	}
	//当hpid大于0时是门户元素id，执行门户代码
	//if(Util.getIntValue(hpid) > 0)
	hpec.updateHpElementCache(eid);
	if(!esharelevel.equals("2") && !ebaseid.equals("DataCenter")){
		return;
	}
%>