
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@page import="weaver.hrm.appdetach.AppDetachComInfo"%> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.docs.docs.CustomFieldManager"%>
<%@ page import="weaver.hrm.common.*"%>
<!-- modified by wcd 2014-07-30 [E7 to E8] -->
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
    String tempsql = tempsql ="select resourceid from HrmRoleMembers where resourceid>1 and roleid in (select roleid from SystemRightRoles where rightid=22)";
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
                if(tmpopt.equals("1"))	sqlwhere+=" ='"+tmpvalue +"' ";
                if(tmpopt.equals("2"))	sqlwhere+=" <>'"+tmpvalue +"' ";
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
                if(tmpopt.equals("1"))	sqlwhere+=" ="+tmpvalue +" ";
                if(tmpopt.equals("2"))	sqlwhere+=" <>"+tmpvalue +" ";
            }
            else if(tmphtmltype.equals("3") && !tmptype.equals("2") && !tmptype.equals("18") && !tmptype.equals("19")&& !tmptype.equals("17") && !tmptype.equals("37")&& !tmptype.equals("65") ){
                sqlwhere += "and ("+temOwner+"."+tmpcolname;
                if(tmpopt.equals("1"))	sqlwhere+=" ="+tmpvalue +" ";
                if(tmpopt.equals("2"))	sqlwhere+=" <>"+tmpvalue +" ";
            }
            else if(tmphtmltype.equals("3") && (tmptype.equals("2")||tmptype.equals("19"))){ // 对日期处理
                sqlwhere += "and ("+temOwner+"."+tmpcolname;
                if(!tmpvalue.equals("")){
                    if(tmpopt.equals("1"))	sqlwhere+=" >'"+tmpvalue +"' ";
                    if(tmpopt.equals("2"))	sqlwhere+=" >='"+tmpvalue +"' ";
                    if(tmpopt.equals("3"))	sqlwhere+=" <'"+tmpvalue +"' ";
                    if(tmpopt.equals("4"))	sqlwhere+=" <='"+tmpvalue +"' ";
                    if(tmpopt.equals("5"))	sqlwhere+=" ='"+tmpvalue +"' ";
                    if(tmpopt.equals("6"))	sqlwhere+=" <>'"+tmpvalue +"' ";

                    if(!tmpvalue1.equals(""))
                        sqlwhere += " and "+temOwner+"."+tmpcolname;
                }
                if(!tmpvalue1.equals("")){
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
            	String thistemOwner = " t1 ";
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

    CustomFieldManager cfm = new CustomFieldManager("HrmCustomFieldByInfoType",scopeId);
    cfm.getCustomFields();
    String selectSql = "select id ";
    String temSql = "";
    while(cfm.next()){
        temSql += ",field"+cfm.getId();
    }

    ArrayList allCols= new ArrayList();
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
	rs.executeSql("select colname,showorder,header from HrmRpSubDefine where scopeid='"+scopeId+"_"+scopeCmd+"' and resourceid="+userid+" and templateid = "+templateid+" order by showorder");
	while(rs.next()){
		allCols.add(rs.getString("colname"));
		map.put(rs.getString("colname"),rs.getString("header"));
	}
	String backFields = temOwner+".id as resourceid ,t1.status"+temSql; 
	String sqlFrom  = "from cus_fielddata "+temOwner +" left join HrmResource t1 on "+temOwner+".id = t1.id ";
	String sqlWhere = "where "+temOwner+".scope='HrmCustomFieldByInfoType' and "+temOwner+".scopeid="+scopeId+" "+sqlwhere;
	String orderby = "";
    //selectSql += temSql + " from cus_fielddata "+temOwner+" where scope='HrmCustomFieldByInfoType' and scopeid="+scopeId+" "+sqlwhere;
    //RecordSet.executeSql(selectSql);
%>
<HTML>
	<head>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<script language="javascript" src="/js/weaver_wev8.js"></script>
		<script language="javascript">
			function reSearch(){
				parent.location = '/hrm/HrmTab.jsp?_fromURL=hrmReport&cmd=hrmConst&method=HrmRpSubSearch&scopeid=<%=scopeId%>&scopeCmd=<%=scopeCmd%>&templateid=<%=templateid%>';
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
			sqlWhere += " and "+innerResourceSql;
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
					tableString +="		<col width=\""+colwidth1+"%\" text=\""+String.valueOf(map.get(colsname))+"\" column=\""+colsname+"\" orderkey=\""+colsname+"\" transmethod=\"weaver.hrm.report.manager.HrmConstRpSubSearchManager.getCustomerResult\" otherpara=\""+colsname+";"+user.getLanguage()+";"+scopeId+"\"/>";
				}
			}
			tableString +="	</head></table>";
		%>
		<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" />
	<BODY>
</html>
