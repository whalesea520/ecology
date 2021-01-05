
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.appdetach.AppDetachComInfo"%> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.docs.docs.CustomFieldManager"%>
<%@ page import="weaver.hrm.common.*"%>
<!-- modified by wcd 2014-07-28 [E7 to E8] -->
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>

<%
    String userid =""+user.getUID();
    /*权限判断,人力资产管理员以及其所有上级*/
    boolean canView = false;
    ArrayList allCanView = new ArrayList();
    String tempsql ="select resourceid from HrmRoleMembers where resourceid>1 and roleid in (select roleid from SystemRightRoles where rightid=22)";
    RecordSet.executeSql(tempsql);
    while(RecordSet.next()){
        String tempid = RecordSet.getString("resourceid");
        allCanView.add(tempid);
        AllManagers.getAll(tempid);
        while(AllManagers.next()){
            allCanView.add(AllManagers.getManagerID());
        }
    }// end while
    for (int i=0;i<allCanView.size();i++){
        if(userid.equals((String)allCanView.get(i))){
            canView = true;
        }
    }
    if(!canView) {
        response.sendRedirect("/notice/noright.jsp") ;
        return ;
    }
    /*权限判断结束*/
	int scopeCmd = Util.getIntValue(request.getParameter("scopeCmd"),0);
    int scopeId = Util.getIntValue(request.getParameter("scopeId"),0);
	int templateid = Util.getIntValue(request.getParameter("templateid"),0);
    String[] checkcons = request.getParameterValues("check_con");
    String sqlwhere = "";
    String temOwner = "tCustom";
	String backFields = ""; 
	String sqlFrom  = "";
	String sqlWhere = "";
	String orderby = "";

    if(checkcons!=null){
        for(int i=0;i<checkcons.length;i++){
            String tmpcolname = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_colname"));
            String tmphtmltype = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_htmltype"));
            String tmptype = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_type"));
            String tmpopt = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_opt"));
            String tmpvalue = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_value"));
            String tmpopt1 = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_opt1"));
            String tmpvalue1 = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_value1"));
            //生成where子句
            if((tmphtmltype.equals("1")&& tmptype.equals("1"))||tmphtmltype.equals("2")){
                sqlwhere += "and ("+temOwner+"."+tmpcolname;
                if(tmpopt.equals("1")) {
                if("oracle".equals(RecordSet.getDBType())){
                sqlwhere+=tmpvalue.equals("")?" is null":" ='"+tmpvalue +"' ";
                }else   sqlwhere+=" ='"+tmpvalue +"' ";
                }	
                if(tmpopt.equals("2")){
                if("oracle".equals(RecordSet.getDBType())){
               sqlwhere+=tmpvalue.equals("")?" is not null":"<>'"+tmpvalue +"' ";
                }else    sqlwhere+=" <>'"+tmpvalue +"' ";
                }	
                if(tmpopt.equals("3"))	sqlwhere+=" like '%"+tmpvalue +"%' ";
                if(tmpopt.equals("4"))	sqlwhere+=" not like '%"+tmpvalue +"%' ";
            }else if(tmphtmltype.equals("1")&& !tmptype.equals("1")){
                sqlwhere += "and ("+temOwner+"."+tmpcolname;
                    if(!tmpvalue.equals("")){
                    if(tmpopt.equals("1"))	sqlwhere+=" >"+tmpvalue +" ";
                    if(tmpopt.equals("2"))	sqlwhere+=" >="+tmpvalue +" ";
                    if(tmpopt.equals("3"))	sqlwhere+=" <"+tmpvalue +" ";
                    if(tmpopt.equals("4"))	sqlwhere+=" <="+tmpvalue +" ";
                    if(tmpopt.equals("5"))	sqlwhere+=" ="+tmpvalue +" ";
                    if(tmpopt.equals("6"))	sqlwhere+=" <>"+tmpvalue +" ";

                    if(!tmpvalue1.equals(""))
                        sqlwhere += " and "+temOwner+"."+tmpcolname;
                }else{    //第一个日期为空
                 	if(tmpopt.equals("1"))	sqlwhere+=" >'"+tmpvalue +"' ";
                    if(tmpopt.equals("2"))	sqlwhere+=" >='"+tmpvalue +"' ";
                    if(tmpopt.equals("3"))	sqlwhere+=" <'"+tmpvalue +"' ";
                    if(tmpopt.equals("4"))	sqlwhere+=" <='"+tmpvalue +"' ";
                    if(tmpopt.equals("5")){ 	
  	                    if("oracle".equals(RecordSet.getDBType())){
	                  		sqlwhere+=tmpvalue.equals("")?" is null":" ='"+tmpvalue +"' ";
	                	}else   sqlwhere+=" ='"+tmpvalue +"' ";
	                }	
                    if(tmpopt.equals("6"))	{ 	
	                    if("oracle".equals(RecordSet.getDBType())){
	                  		sqlwhere+=tmpvalue.equals("")?" is not null":" <>'"+tmpvalue +"' ";
	                	}else   sqlwhere+=" ='"+tmpvalue +"' ";
	                }	
                   if(!tmpvalue1.equals(""))
                        sqlwhere += " and "+temOwner+"."+tmpcolname;
                }
                if(!tmpvalue1.equals("")){
                    if(tmpopt1.equals("1"))	sqlwhere+=" >"+tmpvalue1 +" ";
                    if(tmpopt1.equals("2"))	sqlwhere+=" >="+tmpvalue1 +" ";
                    if(tmpopt1.equals("3"))	sqlwhere+=" <"+tmpvalue1 +" ";
                    if(tmpopt1.equals("4"))	sqlwhere+=" <="+tmpvalue1 +" ";
                    if(tmpopt1.equals("5"))	sqlwhere+=" ="+tmpvalue1+" ";
                    if(tmpopt1.equals("6"))	sqlwhere+=" <>"+tmpvalue1 +" ";
                }
            }
            else if(tmphtmltype.equals("4")){
                sqlwhere += "and ("+temOwner+"."+tmpcolname;
                if(!tmpvalue.equals("1")) sqlwhere+="<>'1' ";
                else sqlwhere +="='1' ";
            }
            else if(tmphtmltype.equals("5")){
                sqlwhere += "and ("+temOwner+"."+tmpcolname;
          //      if(tmpopt.equals("1"))	sqlwhere+=" ="+tmpvalue +" ";
          //      if(tmpopt.equals("2"))	sqlwhere+=" <>"+tmpvalue +" ";
              if(tmpopt.equals("1")) {
                if("oracle".equals(RecordSet.getDBType())){
                  sqlwhere+=tmpvalue.equals("")?" is null":" ='"+tmpvalue +"' ";
                }else   sqlwhere+=" ='"+tmpvalue +"' ";
                }	
                if(tmpopt.equals("2")){
                if("oracle".equals(RecordSet.getDBType())){
                  sqlwhere+=tmpvalue.equals("")?" is not null":"<>'"+tmpvalue+"' or "+temOwner+"."+tmpcolname +" is  null ";
                }else    sqlwhere+=" <>'"+tmpvalue +"' ";
                }	
            }
            else if(tmphtmltype.equals("3") && !tmptype.equals("2") && !tmptype.equals("18") && !tmptype.equals("19")&& !tmptype.equals("17") && !tmptype.equals("37")&& !tmptype.equals("65") ){
                sqlwhere += "and ("+temOwner+"."+tmpcolname;
             //   if(tmpopt.equals("1"))	sqlwhere+=" ="+tmpvalue +" ";
             //   if(tmpopt.equals("2"))	sqlwhere+=" <>"+tmpvalue +" ";
                 if(tmpopt.equals("1")) {
                if("oracle".equals(RecordSet.getDBType())){
                  sqlwhere+=tmpvalue.equals("")?" is null":" ='"+tmpvalue +"' ";
                }else   sqlwhere+=" ='"+tmpvalue +"' ";
                }	
                if(tmpopt.equals("2")){
                if("oracle".equals(RecordSet.getDBType())){
                  sqlwhere+=tmpvalue.equals("")?" is not null":"<>'"+tmpvalue+"' or "+temOwner+"."+tmpcolname +" is  null ";
                }else    sqlwhere+=" <>'"+tmpvalue +"' ";
                }	
                
            }
            else if(tmphtmltype.equals("3") && (tmptype.equals("2")||tmptype.equals("19"))){ // 对日期处理
            //对 日期处理 加入了 非空情况下的处理 
                sqlwhere += "and ("+temOwner+"."+tmpcolname;
                if(!tmpvalue.equals("")){   //第一个日期不为空时
                    if(tmpopt.equals("1"))	sqlwhere+=" >'"+tmpvalue +"' ";
                    if(tmpopt.equals("2"))	sqlwhere+=" >='"+tmpvalue +"' ";
                    if(tmpopt.equals("3"))	sqlwhere+=" <'"+tmpvalue +"' ";
                    if(tmpopt.equals("4"))	sqlwhere+=" <='"+tmpvalue +"' ";
                    if(tmpopt.equals("5"))	sqlwhere+=" ='"+tmpvalue +"' ";
                    if(tmpopt.equals("6"))	sqlwhere+=" <>'"+tmpvalue +"' ";
                    if(!tmpvalue1.equals(""))
                        sqlwhere += " and "+temOwner+"."+tmpcolname;
                }else{    //第一个日期为空
                 	if(tmpopt.equals("1"))	sqlwhere+=" >'"+tmpvalue +"' ";
                    if(tmpopt.equals("2"))	sqlwhere+=" >='"+tmpvalue +"' ";
                    if(tmpopt.equals("3"))	sqlwhere+=" <'"+tmpvalue +"' ";
                    if(tmpopt.equals("4"))	sqlwhere+=" <='"+tmpvalue +"' ";
                    if(tmpopt.equals("5")){ 	
  	                    if("oracle".equals(RecordSet.getDBType())){
	                  		sqlwhere+=tmpvalue.equals("")?" is null":" ='"+tmpvalue +"' ";
	                	}else   sqlwhere+=" ='"+tmpvalue +"' ";
	                }	
                    if(tmpopt.equals("6"))	{ 	
	                    if("oracle".equals(RecordSet.getDBType())){
	                  		sqlwhere+=tmpvalue.equals("")?" is not null":" <>'"+tmpvalue +"' ";
	                	}else   sqlwhere+=" ='"+tmpvalue +"' ";
	                }	
                   if(!tmpvalue1.equals(""))
                        sqlwhere += " and "+temOwner+"."+tmpcolname;
                }
                if(!tmpvalue1.equals("")){ //第二个日期不为空
               	    if(tmpopt1.equals("1"))	sqlwhere+=" >'"+tmpvalue1 +"' ";
                    if(tmpopt1.equals("2"))	sqlwhere+=" >='"+tmpvalue1 +"' ";
                    if(tmpopt1.equals("3"))	sqlwhere+=" <'"+tmpvalue1 +"' ";
                    if(tmpopt1.equals("4"))	sqlwhere+=" <='"+tmpvalue1 +"' ";
                    if(tmpopt1.equals("5"))	sqlwhere+=" ='"+tmpvalue1+"' ";
                    if(tmpopt1.equals("6"))	sqlwhere+=" <>'"+tmpvalue1 +"' ";
                }
            }
            else if(tmphtmltype.equals("3") && (tmptype.equals("17") || tmptype.equals("18") || tmptype.equals("37") || tmptype.equals("65") )){       // 对多人力资源，多客户，多文档的处理
                sqlwhere += "and (','+CONVERT(varchar,"+temOwner+"."+tmpcolname+")+',' ";
                if(tmpopt.equals("1"))	sqlwhere+=" like '%,"+tmpvalue +",%' ";
                if(tmpopt.equals("2"))	sqlwhere+=" not like '%,"+tmpvalue +",%' ";
            }else if(tmphtmltype.equals("100")){
            	String thistemOwner = temOwner;
            	if((-10>=scopeId && scopeId>=-16)||(scopeId ==1 && scopeCmd == 814)||(scopeId == 3 && scopeCmd != 15688) ){
            		thistemOwner ="t1";
            	}
            	if(!tmpvalue.equals("9")){
            		if(tmpvalue.equals("8")){
            			sqlwhere += "and ("+thistemOwner+".status = 0 or "+thistemOwner+".status = 1 or "+thistemOwner+".status = 2 or "+thistemOwner+".status = 3 ";
            		}else{
            			sqlwhere += "and ("+thistemOwner+".status = " + tmpvalue+" ";
            		}
            	}else{
            		continue;
            	}
            }

            sqlwhere +=") ";

        }
    }

    String selectSql = "";
    ArrayList allCols= new ArrayList();
	ArrayList headers= new ArrayList();
	Map map = new HashMap();
	if(templateid == 0){
		rs.executeSql("delete from HrmRpSubDefine where scopeid='"+scopeId+"_"+scopeCmd+"' and resourceid="+userid +" and templateid = "+templateid);
		String[] checkshows = request.getParameterValues("check_show");
		if(checkshows != null){
			String insertSql = "insert into HrmRpSubDefine(scopeid,resourceid,colname,showorder,header,templateid) values(";
			for(int i=0;i<(checkshows==null?0:checkshows.length);i++){
				String fieldOrder = Util.null2String(request.getParameter("show"+checkshows[i]+"_sn"));
				String fieldName = ""+Util.null2String(request.getParameter("con"+checkshows[i]+"_colname"));
				String fieldLabel = ""+Util.null2String(request.getParameter("con"+checkshows[i]+"_fieldlabel"));
				rs.executeSql(insertSql + "'"+scopeId+"_"+scopeCmd+"'," + userid + ",'" + fieldName + "'," + (Tools.isNull(fieldOrder)?"0.00":fieldOrder) + ",'" + fieldLabel + "',"+templateid+")");
			}
		}
	}
	String _sql = "";
	boolean isoracle = RecordSet.getDBType().equals("oracle");
	if(isoracle){
		_sql = "select colname,showorder,header from HrmRpSubDefine where scopeid='"+scopeId+"_"+scopeCmd+"' and resourceid="+userid+" and templateid = "+templateid+" order by showorder";
		_sql = "select a.colname,a.showorder,a.header,a.ismand,a.isuse from (select a.colname,a.showorder,a.header,nvl(b.ismand,'1') as ismand,nvl(b.isuse,'1') as isuse ";
		_sql += "from HrmRpSubDefine a left join (select ('field' || cast(fieldid as int)) as fieldid,fieldlable,ismand,isuse from cus_formfield) b on a.colname = b.fieldid ";
		_sql += "where a.scopeid='"+scopeId+"_"+scopeCmd+"' and resourceid="+userid+" and templateid = "+templateid+" ) a where a.isuse = 1 order by a.showorder";
	}else{
		_sql = "select colname,showorder,header from HrmRpSubDefine where scopeid='"+scopeId+"_"+scopeCmd+"' and resourceid="+userid+" and templateid = "+templateid+" order by showorder";
		_sql = "select a.colname,a.showorder,a.header,a.ismand,a.isuse from (select a.colname,a.showorder,a.header,isnull(b.ismand,'1') as ismand,isnull(b.isuse,'1') as isuse ";
		_sql += "from HrmRpSubDefine a left join (select ('field'+cast(fieldid as varchar)) as fieldid,fieldlable,ismand,isuse from cus_formfield) b on a.colname = b.fieldid ";
		_sql += "where a.scopeid='"+scopeId+"_"+scopeCmd+"' and resourceid="+userid+" and templateid = "+templateid+" ) a where a.isuse = 1 order by a.showorder";
	}
	rs.executeSql(_sql);
	while(rs.next()){
		allCols.add(rs.getString("colname"));
		map.put(rs.getString("colname"),rs.getString("header"));
	}
	if(!sqlwhere.equals("")){
		sqlwhere = sqlwhere.substring(3);   //去掉and关键字
	}
	if(scopeId == 1){
		sqlwhere = Util.StringReplace(sqlwhere,temOwner+".field",temOwner+"2.field");
		if(!sqlwhere.equals("")){
			sqlwhere = " where "+sqlwhere;
		}
		if(scopeCmd == 814){
			String sqlHrmFamilyInfo = "id,resourceid,member as HrmFamilyInfo_member,title as HrmFamilyInfo_title,company as HrmFamilyInfo_company,jobtitle as HrmFamilyInfo_jobtitle,address as HrmFamilyInfo_address";
			backFields = temOwner+".*,t1.status";
			sqlFrom = "from (select "+sqlHrmFamilyInfo+" from HrmFamilyInfo) "+temOwner+" left join HrmResource t1 on "+temOwner+".resourceid=t1.id";
			sqlWhere = sqlwhere;
			orderby = "";
		}else {
			backFields = temOwner+".id as resourceid,loginid,password,lastname,sex,birthday,nationality,systemlanguage,maritalstatus,telephone,mobile,mobilecall,email,locationid,workroom,homeaddress,resourcetype,startdate,enddate,jobtitle,jobactivitydesc,joblevel,seclevel,departmentid,subcompanyid1,costcenterid,managerid,assistantid,bankid1,accountid1,resourceimageid,createrid,createdate,lastmodid,lastmoddate,lastlogindate,datefield1,datefield2,datefield3,datefield4,datefield5,numberfield1,numberfield2,numberfield3,numberfield4,numberfield5,textfield1,textfield2,textfield3,textfield4,textfield5,tinyintfield1,tinyintfield2,tinyintfield3,tinyintfield4,tinyintfield5,certificatenum,nativeplace,educationlevel,bememberdate,bepartydate,workcode,regresidentplace,healthinfo,residentplace,policy,degree,height,usekind,jobcall,accumfundaccount,birthplace,folk,residentphone,residentpostcode,extphone,managerstr,status,fax,islabouunion,weight,tempresidentnumber,probationenddate,countryid,passwdchgdate,needusb,serial,account,lloginid,needdynapass,dsporder,passwordstate,accounttype,belongto,dactylogram,assistantdactylogram,passwordlock,sumpasswordwrong,oldpassword1,oldpassword2,msgstyle,messagerurl,pinyinlastname,tokenkey,userusbtype,adsjgs,adgs,adbm,outkey,mobileshowtype,totalspace,occupyspace,"+temOwner+"2"+".*"; 
			sqlFrom  = "from HrmResource "+temOwner+" left join cus_fielddata "+temOwner+"2 " + " on "+temOwner+".id="+temOwner+"2.id and " + temOwner+"2.scope='HrmCustomFieldByInfoType' and "+ temOwner+"2.scopeid="+scopeId;
			sqlWhere = sqlwhere;
			orderby = "";
			//selectSql ="select "+temOwner+".*,"+temOwner+"2"+".* from HrmResource "+temOwner+" left join cus_fielddata "+temOwner+"2 " + " on "+temOwner+".id="+temOwner+"2.id and " + temOwner+"2.scope='HrmCustomFieldByInfoType' and "+ temOwner+"2.scopeid="+scopeId+sqlwhere;
		}
	}else if(scopeId == 3){
		sqlwhere = Util.StringReplace(sqlwhere,temOwner+".field",temOwner+"2.field");
		if(!sqlwhere.equals("")){
			sqlwhere = " where "+sqlwhere;
		}
		if(scopeCmd == 15688){
			backFields = temOwner+".id as resourceid,loginid,password,lastname,sex,birthday,nationality,systemlanguage,maritalstatus,telephone,mobile,mobilecall,email,locationid,workroom,homeaddress,resourcetype,startdate,enddate,jobtitle,jobactivitydesc,joblevel,seclevel,departmentid,subcompanyid1,costcenterid,managerid,assistantid,bankid1,accountid1,resourceimageid,createrid,createdate,lastmodid,lastmoddate,lastlogindate,datefield1,datefield2,datefield3,datefield4,datefield5,numberfield1,numberfield2,numberfield3,numberfield4,numberfield5,textfield1,textfield2,textfield3,textfield4,textfield5,tinyintfield1,tinyintfield2,tinyintfield3,tinyintfield4,tinyintfield5,certificatenum,nativeplace,educationlevel,bememberdate,bepartydate,workcode,regresidentplace,healthinfo,residentplace,policy,degree,height,usekind,jobcall,accumfundaccount,birthplace,folk,residentphone,residentpostcode,extphone,managerstr,status,fax,islabouunion,weight,tempresidentnumber,probationenddate,countryid,passwdchgdate,needusb,serial,account,lloginid,needdynapass,dsporder,passwordstate,accounttype,belongto,dactylogram,assistantdactylogram,passwordlock,sumpasswordwrong,oldpassword1,oldpassword2,msgstyle,messagerurl,pinyinlastname,tokenkey,userusbtype,adsjgs,adgs,adbm,outkey,mobileshowtype,totalspace,occupyspace,"+temOwner+"2"+".*"; 
			sqlFrom  = "from HrmResource "+temOwner+" left join cus_fielddata "+temOwner+"2 " + " on "+temOwner+".id="+temOwner+"2.id and " + temOwner+"2.scope='HrmCustomFieldByInfoType' and "+ temOwner+"2.scopeid="+scopeId;
			sqlWhere = sqlwhere;
			orderby = "";
		}else if(scopeCmd == 815){
			String sqlHrmLanguageAbility = "id,resourceid,language as HrmLanguageAbility_language,level_n as HrmLanguageAbility_level_n,memo as HrmLanguageAbility_memo";
			backFields = temOwner+".*,t1.status";
			sqlFrom = "from (select "+sqlHrmLanguageAbility+" from HrmLanguageAbility ) "+temOwner +" left join HrmResource t1 on "+temOwner+".resourceid=t1.id";
			sqlWhere = sqlwhere;
			orderby = "";
		}else if(scopeCmd == 813){
			String sqlHrmEducationInfo = "id,resourceid,school as HrmEducationInfo_school,speciality as HrmEducationInfo_speciality,startdate as HrmEducationInfo_startdate,enddate as HrmEducationInfo_enddate,educationlevel as HrmEducationInfo_level,studydesc as HrmEducationInfo_studydesc";
			backFields = temOwner+".*,t1.status";
			sqlFrom = "from (select "+sqlHrmEducationInfo+" from HrmEducationInfo) "+temOwner+" left join HrmResource t1 on "+temOwner+".resourceid=t1.id";
			sqlWhere = sqlwhere;
			orderby = "";
		}else if(scopeCmd == 15716){
			String sqlHrmWorkResume = "id,resourceid,company as HrmWorkResume_company,jobtitle as HrmWorkResume_jobtitle,startdate as HrmWorkResume_startdate,enddate as HrmWorkResume_enddate,workdesc as HrmWorkResume_workdesc,leavereason as HrmWorkResume_leavereason";
			backFields = temOwner+".*,t1.status";
			sqlFrom = "from (select "+sqlHrmWorkResume+" from HrmWorkResume) "+temOwner+" left join HrmResource t1 on "+temOwner+".resourceid=t1.id";
			sqlWhere = sqlwhere;
			orderby = "";
		}else if(scopeCmd == 15717){
			String sqlHrmTrainBeforeWork = "id,resourceid,trainname as HrmTrainBeforeWork_trainname,trainstartdate as HrmTrainBeforeWork_startdate,trainenddate as HrmTrainBeforeWork_enddate,trainresource as HrmTrainBeforeWork_resource,trainmemo as HrmTrainBeforeWork_trainmemo";
			backFields = temOwner+".*,t1.status";
			sqlFrom = "from (select "+sqlHrmTrainBeforeWork+" from HrmTrainBeforeWork) "+temOwner+" left join HrmResource t1 on "+temOwner+".resourceid=t1.id";
			sqlWhere = sqlwhere;
			orderby = "";
		}else if(scopeCmd == 1502){
			String sqlHrmCertification = "id,resourceid,certname as HrmCertification_certname,datefrom as HrmCertification_datefrom,dateto as HrmCertification_dateto,awardfrom as HrmCertification_awardfrom";
			backFields = temOwner+".*,t1.status";
			sqlFrom = "from (select "+sqlHrmCertification+" from HrmCertification) "+temOwner+" left join HrmResource t1 on "+temOwner+".resourceid=t1.id";
			sqlWhere = sqlwhere;
			orderby = "";
		}else if(scopeCmd == 15718){
			String sqlHrmRewardBeforeWork = "id,resourceid,rewardname as HrmRewardBeforeWork_rewardname,rewarddate as HrmRewardBeforeWork_rewarddate,rewardmemo as HrmRewardBeforeWork_rewardmemo";
			backFields = temOwner+".*,t1.status ";
			sqlFrom = "from (select "+sqlHrmRewardBeforeWork+" from HrmRewardBeforeWork) "+temOwner+" left join HrmResource t1 on "+temOwner+".resourceid=t1.id";
			sqlWhere = sqlwhere;
			orderby = "";
		}
	}else if(scopeId == -10){
		if(!sqlwhere.equals("")){
			sqlwhere = " where "+temOwner+".resourceid=t1.id and "+sqlwhere;
		}else{
			sqlwhere = " where "+temOwner+".resourceid=t1.id ";
		}
		selectSql ="select "+temOwner+".*,t1.status from HrmFamilyInfo "+temOwner+", HrmResource t1 "+sqlwhere;
		rs.executeSql(selectSql);
	}else if(scopeId == -11){
		if(!sqlwhere.equals("")){
			sqlwhere = " where "+temOwner+".resourceid=t1.id and "+sqlwhere;
		}else{
			sqlwhere = " where "+temOwner+".resourceid=t1.id ";
		}
		selectSql ="select "+temOwner+".*,t1.status from HrmLanguageAbility "+temOwner+", HrmResource t1 "+sqlwhere;
		rs.executeSql(selectSql);
	}else if(scopeId == -12){
		if(!sqlwhere.equals("")){
			sqlwhere = " where "+temOwner+".resourceid=t1.id and "+sqlwhere;
		}else{
			sqlwhere = " where "+temOwner+".resourceid=t1.id ";
		}
		selectSql ="select "+temOwner+".*,t1.status from HrmEducationInfo "+temOwner+", HrmResource t1 "+sqlwhere;
		rs.executeSql(selectSql);
	}else if(scopeId == -13){
		if(!sqlwhere.equals("")){
			sqlwhere = " where "+temOwner+".resourceid=t1.id and "+sqlwhere;
		}else{
			sqlwhere = " where "+temOwner+".resourceid=t1.id ";
		}
		selectSql ="select "+temOwner+".*,t1.status from HrmWorkResume "+temOwner+", HrmResource t1 "+sqlwhere;
		rs.executeSql(selectSql);
	}else if(scopeId == -14){
		if(!sqlwhere.equals("")){
			sqlwhere = " where "+temOwner+".resourceid=t1.id and "+sqlwhere;
		}else{
			sqlwhere = " where "+temOwner+".resourceid=t1.id ";
		}
		selectSql ="select "+temOwner+".*,t1.status from HrmTrainBeforeWork "+temOwner+", HrmResource t1 "+sqlwhere;
		rs.executeSql(selectSql);
	}else if(scopeId == -15){
		if(!sqlwhere.equals("")){
			sqlwhere = " where "+temOwner+".resourceid=t1.id and "+sqlwhere;
		}else{
			sqlwhere = " where "+temOwner+".resourceid=t1.id ";
		}
		selectSql ="select "+temOwner+".*,t1.status from HrmCertification "+temOwner+", HrmResource t1 "+sqlwhere;
		rs.executeSql(selectSql);
	}else if(scopeId == -16){
		if(!sqlwhere.equals("")){
			sqlwhere = " where "+temOwner+".resourceid=t1.id and "+sqlwhere;
		}else{
			sqlwhere = " where "+temOwner+".resourceid=t1.id ";
		}
		selectSql ="select "+temOwner+".*,t1.status from HrmRewardBeforeWork "+temOwner+", HrmResource t1 "+sqlwhere;
		rs.executeSql(selectSql);
	}
%>
<%@ include file="HrmConstRpDataDefine.jsp" %>
<html>
	<head>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<script language="javascript" src="/js/weaver_wev8.js"></script>
		<script language="javascript">
			function reSearch(){
				parent.location = '/hrm/HrmTab.jsp?_fromURL=hrmReport&cmd=hrmConst&method=HrmConstRpSubSearch&scopeid=<%=scopeId%>&scopeCmd=<%=scopeCmd%>&templateid=<%=templateid%>';
			}
		</script>
	</head>
<%
    String imagefilename = "/images/hdMaintenance_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(15101,user.getLanguage()) ;
    String needfav ="1";
    String needhelp ="";
%>
	<BODY>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

		<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(364,user.getLanguage())+",javascript:reSearch();,_self} " ;
			RCMenuHeight += RCMenuHeightStep;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<FORM id=frmMain name=frmMain action="HrmConstRpSubSearchResult.jsp" method=post >
			<input type="hidden" name="scopeid" value="<%=scopeId%>">
			<input type="hidden" name="scopeCmd" value="<%=scopeCmd%>">
			<input type="hidden" name="templateid" value="<%=templateid%>">
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<input type=button class="e8_btn_top" onclick="reSearch();" value="<%=SystemEnv.getHtmlLabelName(364,user.getLanguage())%>"></input>
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<%
		String innerResourceSql = AppDetachComInfo.getInnerResourceSql(temOwner);
		//只查询行政纬度人员
		if(!sqlwhere.equals("")){
			sqlWhere += " and "+innerResourceSql;
		}else{
			sqlWhere += " where "+innerResourceSql;
		}
			//pageId=\""+Constants.HRM_Q_013+"\" pagesize=\""+PageIdConst.getPageSize(Constants.HRM_Q_013,user.getUID(),Constants.HRM)+"\"
			String tableString =" <table pagesize=\"10\" tabletype=\"none\">"+
				" <sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"tCustom.id\" sqlsortway=\"Asc\" sqlisdistinct=\"false\"/>"+
			"	<head>"+
			"		<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(179,user.getLanguage())+"\" column=\"resourceid\" orderkey=\"resourceid\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getLastname\"/>";
			
			int colcount1 = allCols.size() ;
			int colwidth1 = 0 ;
			if( colcount1 != 0 ) {
				colwidth1 = 90/colcount1 ;
			}
			for(int i=0; i<colcount1; i++){
				String colsname = String.valueOf(allCols.get(i));
				if(map.containsKey(colsname)){
					if(colsname.equals("HrmTrainBeforeWork_trainstartdate")){
						colsname="HrmTrainBeforeWork_startdate";
						tableString +="		<col width=\""+colwidth1+"%\" text=\""+String.valueOf(map.get("HrmTrainBeforeWork_trainstartdate"))+"\" column=\""+colsname+"\" orderkey=\""+colsname+"\" transmethod=\"weaver.hrm.report.manager.HrmConstRpSubSearchManager.getResult\" otherpara=\""+colsname+";"+user.getLanguage()+";"+scopeId+"\"/>";
					}else if(colsname.equals("HrmTrainBeforeWork_trainenddate")){
						colsname="HrmTrainBeforeWork_enddate";
						tableString +="		<col width=\""+colwidth1+"%\" text=\""+String.valueOf(map.get("HrmTrainBeforeWork_trainenddate"))+"\" column=\""+colsname+"\" orderkey=\""+colsname+"\" transmethod=\"weaver.hrm.report.manager.HrmConstRpSubSearchManager.getResult\" otherpara=\""+colsname+";"+user.getLanguage()+";"+scopeId+"\"/>";
					}else if(colsname.equals("HrmTrainBeforeWork_trainresource")){
						colsname="HrmTrainBeforeWork_resource";
						tableString +="		<col width=\""+colwidth1+"%\" text=\""+String.valueOf(map.get("HrmTrainBeforeWork_trainresource"))+"\" column=\""+colsname+"\" orderkey=\""+colsname+"\" transmethod=\"weaver.hrm.report.manager.HrmConstRpSubSearchManager.getResult\" otherpara=\""+colsname+";"+user.getLanguage()+";"+scopeId+"\"/>";
					}else{
						tableString +="		<col width=\""+colwidth1+"%\" text=\""+String.valueOf(map.get(colsname))+"\" column=\""+colsname+"\" orderkey=\""+colsname+"\" transmethod=\"weaver.hrm.report.manager.HrmConstRpSubSearchManager.getResult\" otherpara=\""+colsname+";"+user.getLanguage()+";"+scopeId+"\"/>";
					}
				}
			}
			tableString +="	</head></table>";
		%>
		<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" />
		</FORM>
	</body>
</html>
