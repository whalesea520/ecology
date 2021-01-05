<%@page import="weaver.proj.util.SQLUtil"%>
<%@page import="weaver.general.browserData.BrowserManager"%>
<%@page import="weaver.workflow.browserdatadefinition.ConditionField"%>
<%@page import="org.json.JSONObject"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@page import="weaver.proj.util.PropUtil"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page" />
<jsp:useBean id="CapitalStateComInfo" class="weaver.cpt.maintenance.CapitalStateComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="AssetUnitComInfo" class="weaver.lgc.maintenance.AssetUnitComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs_title" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs_condition" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CommonShareManager" class="weaver.cpt.util.CommonShareManager" scope="page" />
<jsp:useBean id="CptWfUtil" class="weaver.cpt.util.CptWfUtil" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<script type="text/javascript">
	var dialog =  parent.parent.dialog;
</script>
</HEAD>
<%
rs.executeSql("select cptdetachable from SystemSet");
int detachable=0;
if(rs.next()){
    detachable=rs.getInt("cptdetachable");
}
int reqid=Util.getIntValue( request.getParameter("reqid"));

int belid = user.getUserSubCompany1();
int userId = user.getUID();
char flag=Util.getSeparator();
String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
String stateid = Util.null2String(request.getParameter("cptstateid"));
String sptcount = Util.null2String(request.getParameter("cptsptcount"));

String sqlwhere = " ";
String tempwhere = sqlwhere1;
String isCapital = Util.null2String(request.getParameter("isCapital"));
String isInit = Util.null2String(request.getParameter("isInit"));
String rightStr = "";
if(HrmUserVarify.checkUserRight("Capital:Maintenance",user)){
	rightStr = "Capital:Maintenance";
}
String blonsubcomid = "";

String capitalgroupid = Util.null2String(request.getParameter("capitalgroupid"));

if(!capitalgroupid.equals("")){
	isInit = "1";//从树点击转到的请求
}
//资产流转情况页面 可以查看数量是0的资产
String inculdeNumZero = Util.null2s(request.getParameter("inculdeNumZero"), "1");

//判断是否有资产组条件
int indexofsql;
if((indexofsql=tempwhere.indexOf("capitalgroupid"))!=-1){
	String tempstr = tempwhere.substring(indexofsql+15);
	tempwhere = tempwhere.substring(0,indexofsql-1);
	tempstr = " (capitalgroupid = "+tempstr.trim()+" or capitalgroupid in(select id from CptCapitalAssortment where supassortmentstr like '%|"+tempstr.trim()+"|%'))";
	tempwhere = tempwhere.concat(tempstr);

}

int ishead = 0;
int isdata = 0;
if(!sqlwhere1.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += tempwhere;
	}
	if(sqlwhere1.indexOf("isdata")!=-1){
		String sqlwhere_tmp = sqlwhere1.substring(sqlwhere1.indexOf("isdata")+1);
		int index1 = sqlwhere_tmp.indexOf("'1'");
		int index2 = sqlwhere_tmp.indexOf("'2'");
		int index11 = sqlwhere_tmp.indexOf("1");
		int index22 = sqlwhere_tmp.indexOf("2");
		if(index1==-1 && index2>-1){
			isdata = 2;
		}else if(index1>-1 && index2==-1){
			isdata = 1;
		}else if(index11==-1 && index22>-1){
			isdata = 2;
		}else if(index11>-1 && index22==-1){
			isdata = 1;
		}
	}
	else{
		if(ishead==0){
			ishead = 1;
			sqlwhere += " where isdata = '2' ";
		}
		else{
			sqlwhere += " and isdata = '2' ";
		}
	}
}else{
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where isdata = '"+("0".equals(isCapital)?"1":"2")+"' ";
	}
	else{
		sqlwhere += " and isdata = '"+("0".equals(isCapital)?"1":"2")+"' ";
	}
}
if(isdata==0){
	isdata=2;
}
if(!stateid.equals("")){
		sqlwhere += " and stateid in (";
		sqlwhere += Util.fromScreen2(stateid,user.getLanguage());
		sqlwhere += ") ";
}
if(!sptcount.equals("")){
		sqlwhere += " and sptcount = '";
		sqlwhere += Util.fromScreen2(sptcount,user.getLanguage());
		sqlwhere += "'";
}
if(!capitalgroupid.equals("")&&!capitalgroupid.equals("0")){
    if("sqlserver".equalsIgnoreCase( rs.getDBType())){

        String mysql = "WITH cptgroupinfo AS ( ";
        mysql += "SELECT id,"+
                "        supassortmentid"+
                " FROM   cptcapitalassortment"+
                " WHERE  id = "+capitalgroupid+
                " UNION ALL"+
                " SELECT a.id,"+
                "        a.supassortmentid"+
                " FROM   cptcapitalassortment AS a,"+
                "        cptgroupinfo AS b"+
                " WHERE  a.supassortmentid = b.id";
        mysql += ") SELECT id FROM cptgroupinfo ";
        rs.executeSql(mysql);
        String mycptgroupid="";
        while(rs.next()){
            mycptgroupid+=rs.getString("id")+",";
        }
        if(mycptgroupid.endsWith(",")){
            mycptgroupid=mycptgroupid.substring(0,mycptgroupid.length()-1);
        }
        if(!"".equals(mycptgroupid)){
            sqlwhere+=" and capitalgroupid in("+mycptgroupid+")";
        }


    }else if("oracle".equalsIgnoreCase( rs.getDBType())){
        sqlwhere += " and exists(select 1 from (select ts1.id from CPTCAPITALASSORTMENT ts1 start with ts1.ID = '"+capitalgroupid+"' connect by prior ts1.id = ts1.SUPASSORTMENTID) ts2 where ts2.id=T1.CAPITALGROUPID ) ";
    }
    else{
        sqlwhere += " and (capitalgroupid = "+capitalgroupid+" or capitalgroupid in(select id from CptCapitalAssortment where supassortmentstr like '%|"+capitalgroupid+"|%')) ";
    }

}

//权限条件 modify by ds Td:9699
if(detachable == 1 && userId!=1){
	String sqltmp = "";
	rs2.executeProc("HrmRoleSR_SeByURId", ""+userId+flag+rightStr);
	while(rs2.next()){
		blonsubcomid=rs2.getString("subcompanyid");
		sqltmp += (", "+blonsubcomid);
	}
	if(!"".equals(sqltmp)){//角色设置的权限
		sqltmp = sqltmp.substring(1);
			sqlwhere += " and blongsubcompany in ("+sqltmp+") ";
	}else{
			sqlwhere += " and blongsubcompany in ("+belid+") ";
	}
}

//流程浏览定义条件
if("1".equals( isCapital)){
	int bdf_wfid=Util.getIntValue(request.getParameter("bdf_wfid"),-1);
	int bdf_fieldid=Util.getIntValue(request.getParameter("bdf_fieldid"),-1);
	int bdf_viewtype=Util.getIntValue(request.getParameter("bdf_viewtype"),-1);
	List<ConditionField> lst=null;
	if(request.getParameter("bdf_wfid")!=null && (lst=ConditionField.readAll(bdf_wfid, bdf_fieldid, bdf_viewtype)).size()>0){
		for(int i=0;i<lst.size();i++){
			ConditionField f=lst.get(i);
			String fname=f.getFieldName();
			String fvalue= f.getValue();
			boolean isHide=f.isHide();
			boolean isReadOnly= f.isReadonly();
			if(isHide||isReadOnly){
				if(!"".equals(fvalue) && "mark".equalsIgnoreCase(fname)){
					sqlwhere+=" and t1.mark like '%"+fvalue+"%' ";
				}else if(!"".equals(fvalue) && "fnamark".equalsIgnoreCase(fname)){
					sqlwhere+=" and t1.fnamark like '%"+fvalue+"%' ";
				}else if(!"".equals(fvalue) && "name".equalsIgnoreCase(fname)){
					sqlwhere+=" and t1.name like '%"+fvalue+"%' ";
				}else if(!"".equals(fvalue) && "capitalSpec".equalsIgnoreCase(fname)){
					sqlwhere+=" and t1.capitalSpec like '%"+fvalue+"%' ";
				}else if("departmentid".equalsIgnoreCase(fname)){
					String vtype= f.getValueType();
					if("1".equals(vtype)){//当前操作者的值
						fvalue=resourceComInfo.getDepartmentID( ""+user.getUID());
					}else if("3".equals(vtype)){//取表单字段值
						fvalue="";
						if(f.isGetValueFromFormField()){
							fvalue=Util.null2String( f.getDepartmentIds( Util.null2String(request.getParameter("bdf_"+fname)).split(",")[0]));
						}
					}
					if(!"".equals(fvalue)){
						sqlwhere+=" and t1.departmentid='"+fvalue+"' ";
					}
				}
			}
			
		}
	}
}

String needHideField=",";//用来隐藏字段
if(!"1".equals(isCapital)){//资产资料
	needHideField+="isinner,barcode,fnamark,stateid,blongdepartment,departmentid,capitalnum,startdate,enddate,manudate,stockindate,location,selectdate,contractno,invoice,deprestartdate,usedyear,currentprice,";
}
//组合查询条件
String queryformjson=Util.null2String(request.getParameter("queryformjsoninfo"));
//System.out.println("queryformjson:"+queryformjson);
if(!"".equals(queryformjson)){
	StringBuffer cusSql=new StringBuffer();//自定义字段条件
	net.sf.json.JSONObject jsonObject= net.sf.json.JSONObject.fromObject(queryformjson);
	String sql_condition="select t1.*,t2.fieldname,t2.fieldlabel,t2.fieldhtmltype,t2.type,t2.issystem from cpt_browdef t1,cptDefineField t2 where t1.iscondition=1 and t1.fieldid=t2.id  order by t1.displayorder";
	rs_condition.executeSql(sql_condition);
	while(rs_condition.next()){
		String fieldname=Util.null2String(rs_condition.getString("fieldname"));
	    int fieldhtmltype=Util.getIntValue(rs_condition.getString("fieldhtmltype"),0);
		if(needHideField.contains(","+fieldname+",")) continue;
		if(fieldhtmltype==2||fieldhtmltype==6||fieldhtmltype==7){
			continue;
		}
		String fieldid=Util.null2String(rs_condition.getString("fieldid"));
	    String fielddbtype=Util.null2String(rs_condition.getString("fielddbtype"));
	    String type=Util.null2String(rs_condition.getString("type"));
		String val=Util.null2String( jsonObject.get(fieldname));
		int issystem=Util.getIntValue(rs_condition.getString("issystem"),0);
	    if(issystem!=1){
	    	val=Util.null2String( jsonObject.get("field"+fieldid));
	    }
		//System.out.println("key:"+fieldname+"\tval:"+val+"\tfieldhtmltype:"+fieldhtmltype+"\ttype:"+type);
		if(!"".equals(val)){
			if (fieldhtmltype == 1&&("2".equals(type)||"3".equals(type))) {
				if ("capitalnum".equalsIgnoreCase(fieldname)) {
					if("oracle".equalsIgnoreCase(rs.getDBType())){
						cusSql.append( " and (nvl(capitalnum,0)-nvl(frozennum,0)) = "+val);
					}else{
						cusSql.append( " and (isnull(capitalnum,0)-isnull(frozennum,0))="+val);
					}
				}else{
					cusSql.append(" and t1." + fieldname + " = "+ val);
				}
			}else if(fieldhtmltype==3){
	 			boolean isSingle="true".equalsIgnoreCase( BrowserManager.browIsSingle(""+type));
	 			if(isSingle){
	 				cusSql.append( " and t1."+fieldname+" ='"+val+"'  ");
	 			}else {
	 				String dbtype= rs_condition.getDBType();
	 				if("oracle".equalsIgnoreCase(dbtype)){
	 					cusSql.append(SQLUtil.filteSql(RecordSet .getDBType(),  " and ','+t1."+fieldname+"+',' like '%,"+val+",%'  "));
	 				}else{
	 					cusSql.append(" and ','+convert(varchar(2000),t1."+fieldname+")+',' like '%,"+val+",%'  ");
	 				}
				}
	 		}else if(fieldhtmltype==4){
	 			if("1".equals(val)){
	 				cusSql.append(" and t1."+fieldname+" ='"+val+"'  ");
	 			}
	 		}else if(fieldhtmltype==5){
	 			cusSql.append(" and exists(select 1 from cpt_SelectItem ttt2 where ttt2.fieldid="+fieldid+" and ttt2.selectvalue='"+val+"' and ttt2.selectvalue=t1."+fieldname+" ) ");
	 		}else{
	 			cusSql.append(" and t1."+fieldname+" like'%"+val+"%'  ");
	 		}
		}
	}
	if(cusSql.length()>5){
		sqlwhere+=cusSql.toString();
	}
}
//System.out.println("sqlwhere:"+sqlwhere);
	
String pageId=Util.null2String(PropUtil.getPageId("cpt_capitalbrowserlist"));
%>
<BODY style="overflow:auto"> <!--style="overflow:scroll"-->
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>



<%


if("1".equals(isCapital)){
	CommonShareManager.setAliasTableName("t2");
	sqlwhere+= " and exists(select 1 from CptCapitalShareInfo t2 where t2.relateditemid=t1.id and ("+CommonShareManager.getShareWhereByUser("cpt", user)+") ) ";
}
if(isInit.equals("0")) {
	sqlwhere += " and 1=2"; 
}
if(request.getParameter("currpage")!=null) {
	String pageSqlKey = Util.null2String( request.getParameter("pagesql"));
	sqlwhere ="";
	if(session.getAttribute(pageSqlKey)!=null){
		sqlwhere = (String)session.getAttribute(pageSqlKey);
	}
}

String orderby =" t1.id ";
String tableString = "";
int perpage=7;                                 
String backfields = " t1.*,"+("oracle".equalsIgnoreCase( rs.getDBType())?"(nvl(capitalnum,0)-nvl(frozennum,0))":"(isnull(capitalnum,0)-isnull(frozennum,0))")+" cptnum ";
String fromSql  = " CptCapital t1 ";


//剔除掉在途的请求自身的数量
String includeNumZeroSqlwhere="";
if(!"1".equals(inculdeNumZero)&& (2==isdata) ){
		includeNumZeroSqlwhere = " and  ";
	if("oracle".equalsIgnoreCase(rs.getDBType())){
		includeNumZeroSqlwhere += "  (nvl(capitalnum,0)-nvl(frozennum,0))>0 ";
	}else{
		includeNumZeroSqlwhere += "  (isnull(capitalnum,0)-isnull(frozennum,0))>0 ";
	}
}
if(reqid>0&&"1".equals(isCapital)){
	String sql2="select t1.currentnodetype,t1.workflowid,t2.formid from workflow_requestbase t1,workflow_base t2 where t1.workflowid=t2.id and t1.requestid="+reqid;
	int formid=0;
	int wfid=0;
	int currentnodetype=0;
	
	RecordSet.executeSql(sql2);
	while(RecordSet.next()){
		formid=RecordSet.getInt("formid");
		wfid=RecordSet.getInt("workflowid");
		currentnodetype=RecordSet.getInt("currentnodetype");
	}
        RecordSet.executeSql("select wftype  from cpt_cptwfconf where wfid="+wfid);
	String wftype="";
	if(RecordSet.next()){
		wftype=Util.null2String(RecordSet.getString("wftype"));
	}
	if(!"apply".equals(wftype)){
	
		if(currentnodetype>0&&currentnodetype<3 ){
			JSONObject jsonObject= CptWfUtil.getCptwfInfo(""+wfid);
			if(jsonObject.length()>0){
				String cptmaintablename="formtable_main_"+(-formid);
				rs3.execute("select tablename from workflow_bill where id="+formid);
				while(rs3.next()){
					cptmaintablename=rs3.getString("tablename");
				}
				String cptdetailtablename=cptmaintablename;
				String zcname=jsonObject.getString("zcname");
				String zcsl=jsonObject.getString("slname");
				int zcViewtype=Util.getIntValue( ""+jsonObject.getInt("zctype"),0);
				if(zcViewtype==1){
					cptdetailtablename+="_dt1";
				}else if(zcViewtype==2){
					cptdetailtablename+="_dt2";
				}else if(zcViewtype==3){
					cptdetailtablename+="_dt3";
				}else if(zcViewtype==4){
					cptdetailtablename+="_dt4";
				}
				String cptsearchsql="";
				if(!cptdetailtablename.equals(cptmaintablename)){
					cptsearchsql=" select d."+zcname+" as currentzcid,sum(d."+zcsl+") as currentreqnum from "+cptmaintablename+" m ,"+cptdetailtablename+" d where d.mainid=m.id and m.requestid="+reqid+" group by d."+zcname+" ";
				}else{
					cptsearchsql="select m."+zcname+" as currentzcid,sum(m."+zcsl+") as currentreqnum from "+cptmaintablename+" m  where  m.requestid="+reqid+" group by m."+zcname+" ";
				}
				
				backfields = " t2.currentreqnum,t1.*,"+("oracle".equalsIgnoreCase( rs.getDBType())?"(nvl(capitalnum,0)-nvl(frozennum,0)+nvl(currentreqnum,0))":"(isnull(capitalnum,0)-isnull(frozennum,0)+isnull(currentreqnum,0))")+" cptnum ";
				fromSql  = " CptCapital t1 left outer join ("+cptsearchsql+") t2 on t2.currentzcid=t1.id ";
				
				if(ishead==0){
					ishead = 1;
					includeNumZeroSqlwhere=" where ";
				}else{
					includeNumZeroSqlwhere = " and  ";
				}
				if("oracle".equalsIgnoreCase(rs.getDBType())){
					includeNumZeroSqlwhere += "  (nvl(capitalnum,0)-nvl(frozennum,0)+nvl(currentreqnum,0))>0 ";
				}else{
					includeNumZeroSqlwhere += "  (isnull(capitalnum,0)-isnull(frozennum,0)+isnull(currentreqnum,0))>0 ";
				}
			}
		}
	}
}

//out.println("sql:\n select "+backfields+" from "+fromSql+" "+sqlwhere+includeNumZeroSqlwhere+" order by "+orderby);
String sql_title="select t1.*,t2.fieldname,t2.fieldlabel,t2.fieldhtmltype,t2.type from cpt_browdef t1,cptDefineField t2 where t1.istitle=1 and t1.fieldid=t2.id and t2.isopen='1' order by t1.displayorder";
rs_title.executeSql(sql_title);

tableString =   " <table  pagesize=\""+perpage+"\" instanceid=\"BrowseTable\" id=\"BrowseTable\" tabletype=\"none\"  >"+
                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere+includeNumZeroSqlwhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.id\" sqlsortway=\"asc\" sqlisdistinct=\"false\" />"+
                "       <head>"+
                "           <col width=\"0%\" hide=\"true\" text=\""+"ID"+"\" column=\"id\"  transmethod='weaver.cpt.util.CapitalTransUtil.getBrowserRetInfo' otherpara='"+isCapital+"' />";
                while(rs_title.next()){
                	String fieldname=rs_title.getString("fieldname");
                	if(needHideField.contains(","+fieldname+",")) continue;
                	int fieldid=rs_title.getInt("fieldid");
                	int fieldlabel=rs_title.getInt("fieldlabel");
                	int fieldhtmltype=rs_title.getInt("fieldhtmltype");
                	int type=rs_title.getInt("type");
                	if("resourceid".equalsIgnoreCase(fieldname)&&!"1".equals(isCapital) ){
                		fieldlabel=1507;
                	}
                	if("capitalnum".equalsIgnoreCase(fieldname)){
                		fieldname="cptnum";
                	}
                	
                	tableString+="<col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(fieldlabel ,user.getLanguage()) +"\" column=\""+fieldname+"\" orderkey=\""+fieldname+"\" otherpara=\""+user.getUID()+"+"+fieldid+"+"+fieldhtmltype+"+"+type+"\" transmethod='weaver.cpt.util.CptFieldManager.getBrowserFieldvalue' />";
                }
                tableString+="       </head>"+
                " </table>";
%>
<wea:SplitPageTag  tableString='<%=tableString %>'  mode="run" />
<%
	String currentdata=Util.getEncrypt(Util.getRandom()); 
    session.setAttribute(currentdata,sqlwhere);	
%>
    <FORM ID=SearchForm NAME=SearchForm STYLE="margin-bottom:0" action="/cpt/capital/CapitalBrowserList.jsp" method=post>
	    <input type=hidden name=sqlwhere value="<%=xssUtil.put(sqlwhere1)%>">
		<input type=hidden id=stateid name=stateid value="<%=stateid%>">
		<input type=hidden id=sptcount name=sptcount value="<%=sptcount%>">
		<input type=hidden id=isCapital name=isCapital value="<%=isCapital%>">
		<input type=hidden id=inculdeNumZero name=inculdeNumZero value="<%=inculdeNumZero%>">
		<input type=hidden id=capitalgroupid name=capitalgroupid value="<%=capitalgroupid%>"> <!--Only for CapitalBrowserTree-->
		<input type=hidden id=rightStr name=rightStr value="<%=rightStr%>">
		<input type=hidden id=isInit name=isInit value="1">
		<input type=hidden id=currpage name=currpage value="1">
		<input type=hidden id=reqid name=reqid value="<%=reqid %>" />
		<textarea name="pagesql" style="display:none"><%=currentdata%></textarea>
	</form>
</BODY>
</HTML>
<%
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<script type="text/javascript">
function prepage(obj) {
	var topage = SearchForm.currpage.value*1-1;
	if(topage==0) topage = 1;
	SearchForm.currpage.value = topage;
	SearchForm.submit();
	obj.disabled=true;
}
function nextpage(obj) {
	var topage = SearchForm.currpage.value*1+1;
	SearchForm.currpage.value = topage;
	SearchForm.submit();
	obj.disabled=true;
}

function btnclear_onclick(){
	if(dialog){
		var returnjson={id:"",name:""};
		try{
            dialog.callback(returnjson);
       }catch(e){}
	  	try{
	       dialog.close(returnjson);
	   }catch(e){}
	}else{
		window.parent.parent.returnValue = {id:"",name:""};
		window.parent.parent.close();
	}
	
	
}
function BrowseTable_onclick(e){
 var target = e.srcElement||e.target;
if( target.tagName == "TD" ){
	 v = $($(target).parent().children("TD").children("A")[0]).text().split("_#_");
	 if(dialog){
	    	var returnjson = {id:v[0],name:v[1],other1:v[2],other2:v[3],other3:v[4],other4:v[5],other5:v[6],other6:v[7],other7:v[8],other8:v[9],other9:v[10],other10:v[11],other11:v[12]};
	    	try{
	            dialog.callback(returnjson);
	       }catch(e){}
		  	try{
		       dialog.close(returnjson);
		   }catch(e){}
    }else{
    	window.parent.parent.parent.returnValue = {id:v[0],name:v[1],other1:v[2],other2:v[3],other3:v[4],other4:v[5],other5:v[6],other6:v[7],other7:v[8],other8:v[9],other9:v[10],other10:v[11],other11:v[12]};
    	window.parent.parent.parent.close();
	} 
	 
   
}
else if( e.tagName == "A" ){
	 v = $($(target).parent().children("TD").children("A")[0]).text().split("_#_");
	 if(dialog){
		 
	    	var returnjson = {id:v[0],name:v[1],other1:v[2],other2:v[3],other3:v[4],other4:v[5],other5:v[6],other6:v[7],other7:v[8],other8:v[9],other9:v[10],other10:v[11],other11:v[12]};
	    	try{
	            dialog.callback(returnjson);
	       }catch(e){}
		  	try{
		       dialog.close(returnjson);
		   }catch(e){}
	 }else{
		 window.parent.parent.parent.returnValue = {id:v[0],name:v[1],other1:v[2],other2:v[3],other3:v[4],other4:v[5],other5:v[6],other6:v[7],other7:v[8],other8:v[9],other9:v[10],other10:v[11],other11:v[12]};
		 window.parent.parent.parent.close();
	}  
}
}

//列表数据刷新后触发
function afterDoWhenLoaded(){
	//$("#_xTable").find("table.ListStyle").bind('click',BrowseTable_onclick);
}
jQuery(document).ready(function(){
	//jQuery("#BrowseTable").bind("click",BrowseTable_onclick);
	$("#_xTable").find("table.ListStyle").live('click',BrowseTable_onclick);
})
</script>
