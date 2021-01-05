
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp"%>

<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsWordCount" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="hpu" class="weaver.homepage.HomepageUtil" scope="page"/>
<jsp:useBean id="hpec" class="weaver.homepage.cominfo.HomepageElementCominfo" scope="page"/>
<jsp:useBean id="esc" class="weaver.page.style.ElementStyleCominfo" scope="page"/>
<jsp:useBean id="pu" class="weaver.page.PageUtil" scope="page" />
<jsp:useBean id="baseBean" class="weaver.general.BaseBean" scope="page"/>
<%	
	boolean isSystemer=false;
	if(HrmUserVarify.checkUserRight("homepage:Maint", user)) isSystemer=true;

	String eid=Util.null2String(request.getParameter("eid"));	
	String ebaseid=Util.null2String(request.getParameter("ebaseid"));
	String method=Util.null2String(request.getParameter("method"));	
	
	String eTitleValue=Util.null2String(request.getParameter("eTitleValue"));	
	String ePerpageValue=Util.null2String(request.getParameter("ePerpageValue"));	
	String eLinkmodeValue=Util.null2String(request.getParameter("eLinkmodeValue"));	
	String eFieldsVale=Util.null2String(request.getParameter("eFieldsVale"));
	String whereKeyStr=Util.null2String(request.getParameter("whereKeyStr"));
	String hpid=Util.null2String(request.getParameter("hpid"));	
	
	String eShowMoulde=Util.null2String(request.getParameter("eShowMoulde"));
	String eBackground=Util.null2String(request.getParameter("eBackground"));	
	
	int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"),-1);
	
	//求用户的ID与分部ID
	int userid=pu.getHpUserId(hpid,""+subCompanyId,user);
	int usertype=pu.getHpUserType(hpid,""+subCompanyId,user);

	baseBean.writeLog(userid+","+usertype);
	if("0".equals(hpid)&&subCompanyId==0){
		userid =1;
		usertype=0;
	}
	//协同模块暂时指定Userid为原始id=========协同插入门户代码1========
	if(Util.getIntValue(hpid)<0)//协同的 userid  和 usertype 为 1  和 0
	{
		userid = 1;
		usertype = 0;
	}

	// 判断元素编辑权限
	String esharelevel ="";
	


	String  strShareSql="select perpage,linkmode,showfield,sharelevel from hpElementSettingDetail where eid="+eid+" and userid="+userid+" and usertype="+usertype;	
	rs.executeSql(strShareSql);
	if(rs.next()){
		esharelevel =Util.null2String(rs.getString("sharelevel"));  //1:为查看 2:为编辑
	}
	if(isSystemer){
		esharelevel = "2";
	}
	//=========协同插入门户代码1=======
	
	if("editSetting".equals(method)){
		

		String strSql="";
		if("2".equals(esharelevel)){
			if(ebaseid.equals("33")&&whereKeyStr.contains("'")){
				whereKeyStr = Util.StringReplace(whereKeyStr,"'","#");
			}
			strSql="update hpElement set title='"+eTitleValue+"',strsqlwhere='"+whereKeyStr+"',isFixationRowHeight='"+eShowMoulde+"',background='"+eBackground+"' where id="+eid;	

			rs.executeSql(strSql);
			hpec.updateHpElementCache(eid);
			
		}
		

		strSql="update hpElementSettingDetail set perpage="+ePerpageValue+" ,linkmode='"+eLinkmodeValue+"', showfield='"+eFieldsVale+"'  where eid="+eid+" and userid="+userid+" and usertype="+usertype;
		rs.executeSql(strSql);	


		String strSql1="select id,islimitlength, fieldColumn from hpFieldElement where elementid="+ebaseid;		
		rs.executeSql(strSql1);	

		rs1.executeSql("delete hpFieldLength where eid="+eid+" and userid="+userid+" and usertype="+usertype);
		while(rs.next()){
			String id=Util.null2String(rs.getString("id"));
			String islimitlength=Util.null2String(rs.getString("islimitlength"));
			String fieldcolumn=Util.null2String(rs.getString("fieldColumn"));
			
			if(fieldcolumn.toLowerCase().equals("img")){
				String imgSize = Util.null2String(request.getParameter("imgSize_"+id));
				rsWordCount.executeSql("insert into hpFieldLength (eid,efieldid,charnum,imgsize,userid,usertype) values ("+eid+","+id+",8,'"+imgSize+"',"+userid+","+usertype+")");
			}
			int wordCount=0;			
			
			if("1".equals(islimitlength)) {
				wordCount=Util.getIntValue(request.getParameter("wordcount_"+id),0);
				rsWordCount.executeSql("insert into hpFieldLength (eid,efieldid,charnum,userid,usertype) values ("+eid+","+id+","+wordCount+","+userid+","+usertype+")");
		
			}

		}	
		
	} else if("delElement".equals(method)){	
		String delFlag=Util.null2String(request.getParameter("delFlag"));
		String delAreaElement=Util.null2String(request.getParameter("delAreaElement"));
		String delType = Util.null2String(request.getParameter("delType"));
	    //如果是删除元素,只是删除相应的人的条件
		//如果是系统管理员也只能删除他自已所能看到的东西,而不能删除别人的，只不过系统管理员删除的时候需要把相应的元素的锁定状态变为不锁定       
		if(usertype==3||usertype==4) {
			String strULocked="update hpelement set islocked=0,isuse=0 where id="+eid;	          
			rs.executeSql(strULocked);
            hpec.updateHpElementCache(eid);
		}
		if("0".equals(hpid)&&subCompanyId==0){
			rs.executeSql("update hpelement set fromModule='NULL',isuse=0 where id="+eid);
		}
	    if(usertype == 3 && !"2".equals(esharelevel)){
	    	return;
	    }
		//删除相关的元素的布局信息
		String strDelLayout ="";
		if("".equals(delType)){
			strDelLayout="update  hplayout set areaElements='"+delAreaElement+"' where hpid="+hpid+" and areaflag='"+delFlag+"' and userid="+userid+" and usertype="+usertype;
		}else{
			strDelLayout="update  pagenewstemplatelayout set areaElements='"+delAreaElement+"' where templateid="+hpid+" and areaFlag='"+delFlag+"'";
		}
		//删除相关的元素详细
		String strDelEdetail="delete hpElementSettingDetail  where hpid="+hpid+" and eid="+eid+" and userid="+userid+" and usertype="+usertype;	
		
		//删除相关的元素字段字数限制
		String strDelEFiledLenght="delete hpFieldLength  where eid="+eid+"  and userid="+userid+" and usertype="+usertype;	
		
		if("2".equals(esharelevel)){
			//外部数据元素特殊处理
			if("OutData".equals(ebaseid)) {
				rs.executeSql("delete from hpOutDataTabSetting where eid="+eid);
				rs.executeSql("delete from hpOutDataSettingAddr where eid="+eid);
				rs.executeSql("delete from hpOutDataSettingDef where eid="+eid);
				rs.executeSql("delete from hpOutDataSettingField where eid="+eid);
			} 
		}
		 
		rs.executeSql(strDelLayout);
		rs.executeSql(strDelEdetail);
		rs.executeSql(strDelEFiledLenght);	
	} else if("locked".equals(method)){
		//如果变为锁定
		//1:把元素本身的状态变化锁定
		if(!"2".equals(esharelevel)){
			return ;
		}
		String strSql="update  hpElement set islocked=1  where id="+eid;		

		rs.executeSql(strSql);	
		hpec.updateHpElementCache(eid);
		

		//2:把所有当前已经使用了首页的用户中 如果没有此元素的就加上此元素
		
		strSql="select userid,usertype from (	select distinct userid,usertype from hplayout where hpid="+hpid+" and not (userid="+userid+" and usertype="+usertype+")	union all	select distinct userid,usertype from hpElementSettingDetail where eid="+eid+" and hpid="+hpid+" and not (userid="+userid+" and usertype="+usertype+")) a group by a.userid,a.usertype having count(*)=1";

		rs.executeSql(strSql);		
		while(rs.next()){
			String tempUserid=Util.null2String(rs.getString("userid"));
			String tempUsertype=Util.null2String(rs.getString("usertype"));

			String tempSql="insert into hpElementSettingDetail (userid,usertype,eid,perpage,linkmode,showfield,sharelevel,hpid) select "+tempUserid+","+tempUsertype+",eid,perpage,linkmode,showfield,'1',hpid from hpElementSettingDetail where  hpid="+hpid+" and userid="+userid+" and usertype="+usertype+" and eid="+eid;

			rs1.executeSql(tempSql);

			//把相应的元素加到到其A区
			String strCon="+";
			if("oracle".equals(rs1.getDBType())) strCon="||";				
			tempSql="update hplayout  set areaElements='"+eid+",' "+strCon+" areaElements where hpid="+hpid+" and  areaflag='A' and userid="+tempUserid+" and usertype="+tempUsertype;
			rs1.executeSql(tempSql);

			//把相应的元素的相应的字数设置也加上

			tempSql="insert into  hpFieldLength (eid,efieldid,charnum,userid,usertype,imgsize) select  eid,efieldid,charnum,"+tempUserid+","+tempUsertype+",imgsize from  hpFieldLength where eid="+eid+" and userid="+userid+" and usertype="+usertype;

			rs1.executeSql(tempSql);
		}
		out.println(esc.getIconLock(hpec.getStyleid(eid)));
	} else if("unlocked".equals(method)){
		if(!"2".equals(esharelevel)){
			return ;
		}
		String strSql="update hpElement set islocked=0  where id="+eid;		
		rs.executeSql(strSql);	
		hpec.updateHpElementCache(eid);
		out.println(esc.getIconUnLock(hpec.getStyleid(eid)));
	}else if("editLayout".equals(method)){
		String targetFlag=Util.null2String(request.getParameter("targetFlag"));
		String targetStr=Util.null2String(request.getParameter("targetStr"));

		String srcFlag=Util.null2String(request.getParameter("srcFlag"));
		String srcStr=Util.null2String(request.getParameter("srcStr"));
		String editType = Util.null2String(request.getParameter("editType"));

		if(usertype == 3 && !"2".equals(esharelevel)){
	    	return;
	    }

		/*String strMoveSql="update hpElementSettingDetail set areaflag='"+targetFlag+"' where  hpid="+hpid+" and  eid="+eid+" and userid="+userid+" and usertype="+usertype;*/
		String strMoveSql1="";
		String strMoveSql2="";
		if("".equals(editType)){
			strMoveSql1="update hplayout set areaelements='"+srcStr+"' where  hpid="+hpid+" and areaflag='"+srcFlag+"' and userid="+userid+" and usertype="+usertype;
			strMoveSql2="update hplayout set areaelements='"+targetStr+"' where  hpid="+hpid+" and areaflag='"+targetFlag+"' and userid="+userid+" and usertype="+usertype;
		}else{
			strMoveSql1="update pagenewstemplatelayout set areaElements='"+srcStr+"' where  templateid="+hpid+" and areaFlag='"+srcFlag+"'";
			strMoveSql2="update pagenewstemplatelayout set areaElements='"+targetStr+"' where  templateid="+hpid+" and areaFlag='"+targetFlag+"'";
		}

		rs.executeSql(strMoveSql1);
		rs.executeSql(strMoveSql2);
	}else if("addtoass".equals(method)){
		String strSql="insert into hpsysremind(eid) values ("+eid+")";	

		rs.executeSql(strSql);	
		return;
	}else if("removefromass".equals(method)){
		String strSql="delete  hpsysremind  where eid="+eid;
		rs.executeSql(strSql);	
		return;
	}else if("synernyisusechange".equals(method)){	// 处理协同 门户 启用 不启用
		String isuse = request.getParameter("isuse");
	    // 兼容历史数据
	    rs.executeSql("select * from synergyconfig where hpid="+hpid);
	    if(!rs.next()){
	    	rs.execute("insert into synergyconfig (hpid,isuse) values('"+hpid+"','"+isuse+"')");
	    }else{
	        rs.execute("update synergyconfig set isuse='"+isuse+"' where hpid="+hpid );
	    }
	    out.print("1");
	    return;
	} 
%>