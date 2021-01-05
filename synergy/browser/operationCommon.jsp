
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<jsp:useBean id="rs_common" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsWordCount" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="hpec" class="weaver.homepage.cominfo.HomepageElementCominfo" scope="page"/>
<jsp:useBean id="hpu" class="weaver.homepage.HomepageUtil" scope="page"/>
<jsp:useBean id="ebc" class="weaver.page.element.ElementBaseCominfo" scope="page"/>
<jsp:useBean id="pc" class="weaver.page.PageCominfo" scope="page"/>
<jsp:useBean id="sm" class="weaver.synergy.SynergyManage" scope="page"/>
<jsp:useBean id="sc" class="weaver.synergy.SynergyComInfo" scope="page" />

<%
	boolean isSystemer=false;
	if(HrmUserVarify.checkUserRight("homepage:Maint", user)) isSystemer=true;

	String eid=Util.null2String(request.getParameter("eid"));	
	String tabid=Util.null2String(request.getParameter("tabid"));	
	String ebaseid=Util.null2String(request.getParameter("ebaseid"));
	String wfid=Util.null2String(request.getParameter("wfid"));
	
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
	String isbold = Util.null2String(request.getParameter("isbold"));
	String islean = Util.null2String(request.getParameter("islean"));
	String isrgb = Util.null2String(request.getParameter("isrgb"));
	String newcolor = Util.null2String(request.getParameter("newcolor"));
	
	String spagetype = Util.null2String(request.getParameter("spagetype"));
	String stype = Util.null2String(request.getParameter("stype"));
	String originalwfid ="";
	if(stype.equals("wf") && spagetype.equals("operat") && (ebaseid.equals("8") || ebaseid.equals("reportForm"))){
		originalwfid = sc.getWfidByHpid(Math.abs(Util.getIntValue(hpid))+"");
	}
	
	//System.out.println("wfid:"+wfid+";originalwfid:"+originalwfid);
	
	int userid = 1;
	int usertype=0;
	userid=hpu.getHpUserId(hpid,""+subCompanyId,user);
	usertype=hpu.getHpUserType(hpid,""+subCompanyId,user);
	if(pc.getSubcompanyid(hpid).equals("-1")&&pc.getCreatortype(hpid).equals("0")){
		userid = 1;
		usertype=0;
	}
	//
	if(Util.getIntValue(hpid)<0)
	{
		userid = user.getUID();
		usertype = Util.getIntValue(user.getLogintype());
	}
	
	
	String strSql_Common="";
	if(eLinkmodeValue.equals("")){
		eLinkmodeValue = "3";
	}
	
	strSql_Common="update hpElementSettingDetail set perpage="+ePerpageValue+" ,linkmode='"+eLinkmodeValue+"', showfield='"+eFieldsVale+"'  where eid="+eid+" and userid="+userid+" and usertype="+usertype;
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
		if(ebaseid.equals("reportForm")&&whereKeyStr.contains("'")){
			whereKeyStr = Util.toHtml(whereKeyStr);
		}
		
		/* if(ebaseid.equals("29")){			
			strSql_Common="update hpElement set title='"+eTitleValue+"',logo='"+eLogo+"',styleid='"+eStyleid+"',height="+eHeight+",marginTop="+eMarginTop+",marginBottom="+eMarginBottom+",marginLeft="+eMarginLeft+",marginRight="+eMarginRight+",scrolltype='"+scrolltype+"',newstemplate='"+newstemplate+"' where id="+eid;
		}else{
			strSql_Common="update hpElement set title='"+eTitleValue+"',strsqlwhere='"+whereKeyStr+"',"
				+"logo='"+eLogo+"',styleid='"+eStyleid+"',height="+eHeight+",marginTop="+eMarginTop+","
				+"marginBottom="+eMarginBottom+",marginLeft="+eMarginLeft+",marginRight="+eMarginRight+","
				+"scrolltype='"+scrolltype+"',newstemplate='"+newstemplate+"',isremind='"+isnew+isbold+islean+isrgb+newcolor+"' where id="+eid;
			//System.out.println("operationCommon.jsp::>strSql_Common："+strSql_Common);
		} */
		//System.out.println(strSql_Common);
		//rs_common.executeSql(strSql_Common);
		//协同模块的参数设置 保存
		if(Util.getIntValue(hpid) < 0)
		{
			if(ebaseid.equals("7") || ebaseid.equals("8"))
			{
				if(wfid.equalsIgnoreCase("")){
					String synergyparamXML = Util.null2String(request.getParameter("SynergyParamXML"));
					sm.persistenceRule2db(synergyparamXML,Util.getIntValue(eid));
				}else{
					String synergyparamXML = Util.null2String(request.getParameter("SynergyParamXML"));
					sm.persistenceWfRule2db(synergyparamXML,Util.getIntValue(eid),tabid,wfid);
				}
			}
		}
	//	rs_common.execute("select * from hpelement where id = "+eid);
	//	rs_common.next();
	//	System.out.println(rs_common.getString("strsqlwhere"));
	}
	//当hpid大于0时是门户元素id，执行门户代码
	if(Util.getIntValue(hpid) > 0)
		hpec.updateHpElementCache(eid);
	if(!esharelevel.equals("2")){
		return;
	}
%>