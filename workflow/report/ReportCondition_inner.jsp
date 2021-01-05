
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.net.*" %>
<%@page import="weaver.general.browserData.BrowserManager"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
 <%@ taglib uri="/browserTag" prefix="brow"%>
  <jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rswf" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="UrlComInfo" class="weaver.workflow.field.UrlComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ReportAuthorization" class="weaver.workflow.report.ReportAuthorization" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo"></jsp:useBean>
<link rel=stylesheet type="text/css" href="/css/Weaver_wev8.css">
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />

<table width="100%">
<col width="15">
<col width="">
<tr>
<td></td>
<td>
<table width="100%">
<colgroup>
<col width="10%">
<col width="10%">
<col width="20%">
<col width="60%">
</colgroup>


		<%
		String isbill = Util.null2String(request.getParameter("isbill"));
		int formid = Util.getIntValue(request.getParameter("formid"),0);
		int reportwfid = Util.getIntValue(request.getParameter("reportwfid"),0);
		int sharelevel = Util.getIntValue(request.getParameter("sharelevel"),0);
		String reportid = Util.null2String(request.getParameter("reportid"));
		int mouldId = Util.getIntValue(request.getParameter("mouldId"),0);
		String fna_str = Util.null2String(request.getParameter("fna"));
		boolean fna = false;
		if("true".equals(fna_str))
			fna = true;
		
		HashMap<String, String> fnaFeeWfInfo_fieldId_hm = new HashMap<String, String>();
		HashMap<String, String> fnaFeeWfInfo_fieldName_hm = new HashMap<String, String>();
		HashMap<String, String> fnaFeeWfInfo_fieldIsDtl_hm = new HashMap<String, String>();
		List<String> fnaOrgType_fieldId_list = new ArrayList<String>();
		List<String> fnaOrgId_fieldId_list = new ArrayList<String>();
		StringBuffer fnaOrgType_fieldId_strs = new StringBuffer();//2：承担主体类型；
		StringBuffer fnaOrgId_fieldId_strs = new StringBuffer();//3：承担主体；
		String sqlFna1 = "select b.workflowid, b.formid, b.fieldType, b.fieldId, b.isDtl, b.showAllType, b.dtlNumber, c.fieldname  \n" +
			" from fnaFeeWfInfo a \n" +
			" join fnaFeeWfInfoField b on a.id = b.mainid \n" +
			" join workflow_billfield c on b.fieldId = c.id \n" +
			" where (1=2 "+
			" 	or ((b.fieldType in (2,3) and b.dtlNumber = 1) and a.fnaWfType = 'fnaFeeWf') "+
			" 	or ((b.fieldType in (2,3,11,12) and b.dtlNumber = 1) and a.fnaWfType = 'change') "+
			" 	or ((b.fieldType in (2,3,11,12) and b.dtlNumber = 1) and a.fnaWfType = 'share') "+
			" ) "+
			" and b.workflowid in ("+reportwfid+")";
		RecordSet.executeSql(sqlFna1);
		while(RecordSet.next()){
			String _wfId = Util.null2String(RecordSet.getString("workflowid")).trim();
			String _fmId = Util.null2String(RecordSet.getString("formid")).trim();
			String _fieldType = Util.null2String(RecordSet.getString("fieldType")).trim();
			String _fieldId = Util.null2String(RecordSet.getString("fieldId")).trim();
			String _fieldname = Util.null2String(RecordSet.getString("fieldname")).trim();
			String _isDtl = Util.null2String(RecordSet.getString("isDtl")).trim();
			String _key = _wfId+"_"+_fieldType;
			fnaFeeWfInfo_fieldId_hm.put(_key, _fieldId);
			fnaFeeWfInfo_fieldName_hm.put(_key, _fieldname);
			fnaFeeWfInfo_fieldIsDtl_hm.put(_key, _isDtl);
			if("2".equals(_fieldType) || "11".equals(_fieldType)){
				if(!fnaOrgType_fieldId_list.contains(_fieldId)){
					if(fnaOrgType_fieldId_strs.length() > 0){
						fnaOrgType_fieldId_strs.append(",");
					}
					fnaOrgType_fieldId_strs.append("'"+_fieldId+"'");
					fnaOrgType_fieldId_list.add(_fieldId);
				}
			}else if("3".equals(_fieldType) || "12".equals(_fieldType)){
				if(!fnaOrgId_fieldId_list.contains(_fieldId)){
					if(fnaOrgId_fieldId_strs.length() > 0){
						fnaOrgId_fieldId_strs.append(",");
					}
					fnaOrgId_fieldId_strs.append("'"+_fieldId+"'");
					fnaOrgId_fieldId_list.add(_fieldId);
				}
			}
		}
		
		String organizationtype = "";
		String bclick = "";
		String organizationid = "";
		
		List ids = new ArrayList();
		List isShows = new ArrayList();
		List isCheckConds = new ArrayList();
		List colnames = new ArrayList();
		List opts = new ArrayList();
		List values = new ArrayList();
		List names = new ArrayList();
		List opt1s = new ArrayList();
		List value1s = new ArrayList();
		String strReportDspField=",";//非模版
		String fieldId="";//非模版
		class Node{
			private String fieldid;
			private String valueone;
			private String valuetwo;
			private String valuethree;
			private String valuefour;
			private String type;
			private String httype;
			public String getId(){
				return this.fieldid;
			}
			public void setId(String id){
				this.fieldid=id;
			}
			public String getVal1(){
			   return this.valueone;
			}
			public void setVal1(String val){
				this.valueone=val;
			}
			public String getVal2(){
				return this.valuetwo;
			}
			public void setVal2(String val){
				this.valuetwo=val;
			}
			public String getVal3(){
				return this.valuethree;
			}
			public void setVal3(String val){
				this.valuethree=val;
			}
			public String getVal4(){
				return this.valuefour;
			}
			public void setVal4(String val){
				this.valuefour=val;
			}
			public String getType(){
				return this.type;
			}
			public void setType(String type){
				this.type=type;
			}
			public String getHttype(){
				return this.httype;
			}
			public void setHttype(String type){
				this.httype=type;
			}
			public void reset(){
				this.fieldid="";
				this.httype="";
				this.type="";
				this.valueone="";
				this.valuetwo="";
				this.valuethree="";
				this.valuefour="";
			}
		}
		Map<String,Node> map=new HashMap<String,Node>();
		Node currNode=new Node();
		if(mouldId == 0){
			//获得报表显示项

			RecordSet.execute("select fieldId,httype,htdetailtype,valueone,valuetwo,valuethree,valuefour from Workflow_ReportDspField where reportId="+reportid) ;
			while(RecordSet.next()){
				fieldId=RecordSet.getString(1);
				if(fieldId!=null&&!fieldId.equals("")){
					strReportDspField+=fieldId+",";
					Node node=new Node();
					node.setId(fieldId);
					node.setHttype(RecordSet.getString("httype"));
					node.setVal1(RecordSet.getString("valueone"));
					node.setVal2(RecordSet.getString("valuetwo"));
					node.setType(RecordSet.getString("htdetailtype"));
					node.setVal3(RecordSet.getString("valuethree"));
					node.setVal4(RecordSet.getString("valuefour"));
					map.put(fieldId,node);
				}
			}
		}else{
			RecordSet.execute("select fieldId,isShow,isCheckCond,colName,optionFirst,valueFirst,nameFirst,optionSecond,valueSecond from WorkflowRptCondMouldDetail where mouldId="+mouldId) ;
			while(RecordSet.next()){
				ids.add(Util.null2String(RecordSet.getString("fieldId")));
				isShows.add(Util.null2String(RecordSet.getString("isShow")));
				isCheckConds.add(Util.null2String(RecordSet.getString("isCheckCond")));
				colnames.add(Util.null2String(RecordSet.getString("colName")));
				opts.add(Util.null2String(RecordSet.getString("optionFirst")));
				values.add(Util.null2String(RecordSet.getString("valueFirst")));
				names.add(Util.null2String(RecordSet.getString("nameFirst")));
				opt1s.add(Util.null2String(RecordSet.getString("optionSecond")));
				value1s.add(Util.null2String(RecordSet.getString("valueSecond")));
			}
			RecordSet.execute("select fieldId from Workflow_ReportDspField where reportId="+reportid) ;
			while(RecordSet.next()){
				fieldId=RecordSet.getString(1);
				if(fieldId!=null&&!fieldId.equals("")){
					strReportDspField+=fieldId+",";
				}
			}
		}
		
int linecolor=0;
String sql="";
//获取用户语言，默认为7
int userLanguage = user.getLanguage();
userLanguage = (userLanguage == 0) ? 7 : userLanguage;
if(isbill.equals("0")){
	StringBuffer sqlSB = new StringBuffer();
	sqlSB.append("   Select bf.* from                                               \n");
	sqlSB.append("     (select t1.fieldid as id,                                    \n");
	sqlSB.append("             (select distinct fieldname                           \n");
	sqlSB.append("                from workflow_fieldlable t3                       \n");
	sqlSB.append("               where t3.formid = t1.formid                        \n");
	sqlSB.append("                 and t3.langurageid = " + userLanguage + "        \n");
	sqlSB.append("                 and t3.fieldid = t1.fieldid) as name,            \n");
	sqlSB.append("             (select distinct t3.fieldlable as label              \n");
	sqlSB.append("                from workflow_fieldlable t3                       \n");
	sqlSB.append("               where t3.formid = t1.formid                        \n");
	sqlSB.append("                 and t3.langurageid = " + userLanguage + "        \n");
	sqlSB.append("                 and t3.fieldid = t1.fieldid) as label,           \n");
	sqlSB.append("             t2.fieldhtmltype as htmltype,                        \n");
	sqlSB.append("             t2.type as type,                                     \n");
	sqlSB.append("             t2.fielddbtype as dbtype,                            \n");
	sqlSB.append("             1 as ismain,                            				\n");
	sqlSB.append("             NULL as groupid                                      \n");
	sqlSB.append("        from workflow_formfield t1, workflow_formdict t2          \n");
	sqlSB.append("       where t2.id = t1.fieldid                                   \n");
	sqlSB.append("         and t1.formid = " + formid + "                           \n");
	sqlSB.append("         and (t1.isdetail <> '1' or t1.isdetail is null)          \n");
	sqlSB.append("      UNION                                                       \n");
	sqlSB.append("      select t1.fieldid as id,                                    \n");
	sqlSB.append("             (select distinct fieldname                           \n");
	sqlSB.append("                from workflow_fieldlable t3                       \n");
	sqlSB.append("               where t3.formid = t1.formid                        \n");
	sqlSB.append("                 and t3.langurageid = " + userLanguage + "        \n");
	sqlSB.append("                 and t3.fieldid = t1.fieldid) as name,            \n");
	sqlSB.append("             (select distinct t3.fieldlable                       \n");
	sqlSB.append("                from workflow_fieldlable t3                       \n");
	sqlSB.append("               where t3.formid = t1.formid                        \n");
	sqlSB.append("                 and t3.langurageid = " + userLanguage + "        \n");
	sqlSB.append("                 and t3.fieldid = t1.fieldid) as label,           \n");
	sqlSB.append("             t2.fieldhtmltype as htmltype,                        \n");
	sqlSB.append("             t2.type as type,                                     \n");
	sqlSB.append("             t2.fielddbtype as dbtype,                            \n");
	sqlSB.append("             0 as ismain,                            				\n");
	sqlSB.append("             t1.groupid                                           \n");
	sqlSB.append("        from workflow_formfield t1, workflow_formdictdetail t2    \n");
	sqlSB.append("       where t2.id = t1.fieldid                                   \n");
	sqlSB.append("         and t1.formid = " + formid + "                           \n");
	sqlSB.append("         and (t1.isdetail = '1' or t1.isdetail is not null)) bf   \n");
	sqlSB.append("   left join (Select * from Workflow_ReportDspField               \n");
	sqlSB.append("                    where reportid = " + reportid + " ) rf        \n");
	sqlSB.append("   on (bf.id = rf.fieldid )               \n");
	sqlSB.append("   order by rf.dsporder                                           \n");
	sql = sqlSB.toString();
} else if(isbill.equals("1")){
	StringBuffer sqlSB = new StringBuffer();
	sqlSB.append("  select bf.* from (                              \n");
	sqlSB.append("    select wfbf.id            as id,              \n");
	sqlSB.append("           wfbf.fieldname     as name,            \n");
	sqlSB.append("           wfbf.fieldlabel    as label,           \n");
	sqlSB.append("           wfbf.fieldhtmltype as htmltype,        \n");
	sqlSB.append("           wfbf.type          as type,            \n");
	sqlSB.append("           wfbf.fielddbtype   as dbtype,          \n");
	sqlSB.append("           wfbf.viewtype      as viewtype,        \n");
	sqlSB.append("           wfbf.dsporder      as dsporder,        \n");
	sqlSB.append("           wfbf.detailtable   as detailtable      \n");
	sqlSB.append("      from workflow_billfield wfbf                \n");
	sqlSB.append("     where wfbf.billid = " + formid + " AND wfbf.viewtype = 0               \n");
	sqlSB.append("    Union                                         \n");
	sqlSB.append("    select wfbf.id            as id,              \n");
	sqlSB.append("           wfbf.fieldname     as name,            \n");
	sqlSB.append("           wfbf.fieldlabel    as label,           \n");
	sqlSB.append("           wfbf.fieldhtmltype as htmltype,        \n");
	sqlSB.append("           wfbf.type          as type,            \n");
	sqlSB.append("           wfbf.fielddbtype   as dbtype,          \n");
	sqlSB.append("		     wfbf.viewtype      as viewtype,        \n");
	sqlSB.append("		     wfbf.dsporder+100  as dsporder,        \n");
	sqlSB.append("           wfbf.detailtable   as detailtable      \n");
	sqlSB.append("		from workflow_billfield wfbf                \n");
	sqlSB.append("	   where wfbf.billid = " + formid + " AND wfbf.viewtype = 1               \n");
	sqlSB.append("  ) bf left join (Select fieldid,dsporder,fieldidbak                        \n");
	sqlSB.append("      from Workflow_ReportDspField  where reportid = " + reportid + ") rf   \n");
	sqlSB.append("      on (bf.id = rf.fieldid )                      \n");
	sqlSB.append("   order by rf.dsporder, bf.dsporder,   bf.detailtable                      \n");
	sql = sqlSB.toString();
}
//System.out.println("2014sql = "+sql);
RecordSet.executeSql(sql);
int tmpcount = 0;
while(RecordSet.next()){
    //屏蔽集成浏览按钮-zzl
	/* if(RecordSet.getString("type").equals("226")||RecordSet.getString("type").equals("227")||RecordSet.getString("type").equals("224")||RecordSet.getString("type").equals("225")){
		continue;
	} */
tmpcount += 1;
String id = RecordSet.getString("id");
if(ids.indexOf(""+id)==-1 && mouldId != 0){
	continue;
}
String  _type = RecordSet.getString("type");
%><tr>
		<td>
		<%
			if(strReportDspField.indexOf(","+id+",")>-1){
				//currNode = map.get(id);
		%>
		<input type='checkbox' name='isShow' notBeauty="true" value="<%=id%>" 
		<%
			if(ids.indexOf(""+id)>-1){
				if(((String)isShows.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){
		%>
					checked
		<%		
				}
			}else if(mouldId == 0){
				
		%>
					checked
		<%	
			}
		%>
		>
		<%
   		}
		%>
		</td>
		<td>
		<input type='checkbox' name='check_con' notBeauty="true" value="<%=id%>" <%=_type.equals("141")?"style='display:none;'":""%>
		<%
			if(ids.indexOf(""+id)>-1){
				if(((String)isCheckConds.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){
		%>
					checked
		<%
				}
			}
		%>
		>
		</td>
      <%
String name = RecordSet.getString("name");
String label = RecordSet.getString("label");
int ismain=1;
if(isbill.equals("1")){
	label = SystemEnv.getHtmlLabelName(Util.getIntValue(label),user.getLanguage());
    int viewtypeint=Util.getIntValue(RecordSet.getString("viewtype"));
    if(viewtypeint==1){
        label="("+SystemEnv.getHtmlLabelName(17463,user.getLanguage())+")"+label;
        ismain=0;
    }
} else {
	ismain=Util.getIntValue(RecordSet.getString("ismain"), 1);
}
label = label.trim();
String htmltype = RecordSet.getString("htmltype");
String type = RecordSet.getString("type");
String dbtype = RecordSet.getString("dbtype");
%>
		<td>
		<input type=hidden name="con<%=id%>_id" value="<%=id%>">
      <input type=hidden name="con<%=id%>_ismain" value="<%=ismain%>">
      <input type=hidden name="con<%=id%>_colname" value="<%=name%>">
      <%=label%>

    <input type=hidden name="con<%=id%>_htmltype" value="<%=htmltype%>">
    <input type=hidden name="con<%=id%>_type" value="<%=type%>">
		</td>
<%
if(htmltype.equals("1") && type.equals("1")){//单行文本框的文本类型
%>
		<td>
		<%
			boolean copt1 = false;
			boolean copt2 = false;
			boolean copt3 = false;
			boolean copt4 = false;
			String coptvalue = "";
			if(ids.indexOf(""+id)!=-1){
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){
					copt1 = true;
				}
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){
					copt2 = true;
				}
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("3")){
					copt3 = true;
				}
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("4")){
					copt4 = true;
				}
				coptvalue = ((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))));
			}
		%>
			<select class=inputstyle name="con<%=id%>_opt" notBeauty="true" onclick="changelevel('<%=id%>')" >
        		<option value="1" <%if(copt1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        		<option value="2" <%if(copt2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
        		<option value="3" <%if(copt3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        		<option value="4" <%if(copt4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      		</select>
      		<input type=text value="<%=coptvalue%>" class=inputstyle style="width:150px;" name="con<%=id%>_value"  onfocus="changelevel('<%=id%>')"  >
		</td>
		    <%}else if(htmltype.equals("2")){//多行文本框

    	%>
		<td>
		<%
			boolean copt1 = false;
			boolean copt2 = false;
			String coptvalue = "";
			if(ids.indexOf(""+id)!=-1){
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("3")){
					copt1 = true;
				}
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("4")){
					copt2 = true;
				}
				coptvalue = ((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))));
			}
		%>
		
			<select class=inputstyle name="con<%=id%>_opt" notBeauty="true" onclick="changelevel('<%=id%>')" >
            	<option value="3" <%if(copt1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
            	<option value="4" <%if(copt2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
			</select>
			<input type=text value="<%=coptvalue%>" class=inputstyle style="width:150px;" name="con<%=id%>_value"  onfocus="changelevel('<%=id%>')"  >
		</td>
		        <%}
else if(htmltype.equals("1")&& !type.equals("1")){
%>
		<td>
		<%
			boolean copt1 = false;
			boolean copt2 = false;
			boolean copt3 = false;
			boolean copt4 = false;
			boolean copt5 = false;
			boolean copt6 = false;
			boolean copt21 = false;
			boolean copt22 = false;
			boolean copt23 = false;
			boolean copt24 = false;
			boolean copt25 = false;
			boolean copt26 = false;
			String coptvalue = "";
			String coptvalue2 = "";
			if(ids.indexOf(""+id)!=-1){
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){
					copt1 = true;
				}
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){
					copt2 = true;
				}
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("3")){
					copt3 = true;
				}
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("4")){
					copt4 = true;
				}
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("5")){
					copt5 = true;
				}
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("6")){
					copt6 = true;
				}
				if(((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){
					copt21 = true;
				}
				if(((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){
					copt22 = true;
				}
				if(((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("3")){
					copt23 = true;
				}
				if(((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("4")){
					copt24 = true;
				}
				if(((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("5")){
					copt25 = true;
				}
				if(((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("6")){
					copt26 = true;
				}
				coptvalue = ((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))));
				coptvalue2 = ((String)value1s.get(Util.getIntValue(""+ids.indexOf(""+id))));
			}
		%>
			<select class=inputstyle name="con<%=id%>_opt" notBeauty="true" onclick="changelevel('<%=id%>')" >
        		<option value="1" <%if(copt1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
        		<option value="2" <%if(copt2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
        		<option value="3" <%if(copt3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
        		<option value="4" <%if(copt4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
        		<option value="5" <%if(copt5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        		<option value="6" <%if(copt6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
			</select>
			<input type=text value="<%=coptvalue%>" class=inputstyle style="width:150px;" name="con<%=id%>_value"  onfocus="changelevel('<%=id%>')" >
			<select class=inputstyle name="con<%=id%>_opt1" notBeauty="true" onclick="changelevel('<%=id%>')" >
        		<option value="1" <%if(copt21){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
        		<option value="2" <%if(copt22){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
        		<option value="3" <%if(copt23){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
        		<option value="4" <%if(copt24){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
        		<option value="5" <%if(copt25){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        		<option value="6" <%if(copt26){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
			</select>
			<input type=text value="<%=coptvalue2%>" class=inputstyle style="width:150px;" name="con<%=id%>_value1"  onfocus="changelevel('<%=id%>')"  >
		</td>
    <%
}
else if(htmltype.equals("4")){
%>
		<td>
		<%
			boolean ischeckval = false;
			if(ids.indexOf(""+id)!=-1){
				if(((String)values.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){
					ischeckval = true;
				}
			}
		%>
			<input type=checkbox value=1 name="con<%=id%>_value" notBeauty="true" onfocus="changelevel('<%=id%>')" <%if(ischeckval){ %>checked<%} %> >
		</td>
    <%}
else if(htmltype.equals("5")){
%>		
		<td>
		<%
			boolean copt1 = false;
			boolean copt2 = false;
			if(ids.indexOf(""+id)!=-1){
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){
					copt1 = true;
				}
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){
					copt2 = true;
				}
			}
		%>
			<select class=inputstyle name="con<%=id%>_opt" notBeauty="true" onclick="changelevel('<%=id%>')" >
        		<option value="1" <%if(copt1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        		<option value="2" <%if(copt2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
			</select>

			<select class=inputstyle name="con<%=id%>_value" notBeauty="true" onclick="changelevel('<%=id%>')" >
      			<option value='' ></option>
        <%
char flag=2;
boolean selectedopt = false;
rs.executeProc("workflow_SelectItemSelectByid",""+id+flag+isbill);

while(rs.next()){
	int tmpselectvalue = rs.getInt("selectvalue");
	String tmpselectname = rs.getString("selectname");
%>
<%
if(ids.indexOf(""+id)!=-1){
	if(((String)values.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals(""+tmpselectvalue)){
		selectedopt = true;
	}else{
		selectedopt = false;
	}
}
%> 
        <option value="<%=tmpselectvalue%>" <%if(selectedopt){ %>selected<%} %>> <%=Util.toScreen(tmpselectname,user.getLanguage())%></option>
        <%} %>
      </select>
      <%--add by zhaolg for td17048--%>
      <%if(fna && name.equals("organizationtype")) {%>
      <%organizationid = id;%>
      		 <input type=hidden name="organizationtype" id="organizationtype" value="con<%=id%>_value">
      <%}%>
		</td>
    <%}else if(htmltype.equals("3")&& type.equals("1") && !(fna && name.equals("organizationid"))){
    	String browserurl = UrlComInfo.getUrlbrowserurl(type) ;
		organizationtype = type;
    %>
        	<td>
		<% 
			boolean copt1 = false;
			boolean copt2 = false;
			String browserValue = "";
			String browserSpanValue = "";
			if(ids.indexOf(""+id)!=-1){
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){
					copt1 = true;
				}
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){
					copt2 = true;
				}
				browserValue = ((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))));
		        browserSpanValue = ((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))));
			}
		%>        	
				<div style="float:left;">
					<select class=inputstyle name="con<%=id%>_opt" notBeauty="true" onclick="changelevel('<%=id%>')" >
		            	<option value="1" <%if(copt1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
		            	<option value="2" <%if(copt2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
					</select>
				</div>
	          <%
	           bclick = "onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp')";
	          String opchange1 = "changecheckcon('con"+id+"_value','" + tmpcount + "')";
	          %>
	          <div style="float:left;width:150px;">
	          <brow:browser viewType="0" name='<%="con"+id+"_value" %>' browserValue='<%=browserValue%>' 
		          browserSpanValue='<%=browserSpanValue%>'  
		          browserOnClick='<%=bclick%>' 
		          hasInput="true" isSingle='<%=BrowserManager.browIsSingle(type)%>' 
		          hasBrowser = "true" 
		          isMustInput='1' onPropertyChange='<%=opchange1 %>'
		          completeUrl='<%="javascript:getajaxurl(" + type + ")"%>' 
		          needHidden="false" ></brow:browser>
		     </div>
	        <!-- 
			<button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser3('<%=id%>','<%=browserurl%>')"></button>
			 -->
   			<input type=hidden name="neworganizationid" id="neworganizationid" value="<%=id%>">
			<input type=hidden name="con<%=id%>_value" id="con<%=id%>_value" value="<%=browserValue %>"> 
			<input type=hidden name="con<%=id%>_name" id="con<%=id%>_name" value="<%=browserSpanValue%>">
			<!-- 
			<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"></span> 
			 -->
		</td>
    <%} else if(htmltype.equals("3") && (!type.equals("4") || !type.equals("164")) && fna && name.equals("organizationid")){
		String browserurl = UrlComInfo.getUrlbrowserurl(type) ;
		organizationtype = type;
    %>
		<td>
		<% 
			boolean copt1 = false;
			boolean copt2 = false;
			String browserValue = "";
			String browserSpanValue = "";
			if(ids.indexOf(""+id)!=-1){
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){
					copt1 = true;
				}
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){
					copt2 = true;
				}
				browserValue = ((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))));
		        browserSpanValue = ((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))));
			}
		%>
		<div style="float:left;">
			<select class=inputstyle name="con<%=id%>_opt" notBeauty="true" onclick="changelevel('<%=id%>')" >
            	<option value="1" <%if(copt1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
            	<option value="2" <%if(copt2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
			</select>
			</div>
	          <%
	           bclick = "onShowBrowser3('"+id+"','"+browserurl+"')";
	          String opchange = "changecheckcon('con"+id+"_value','" + tmpcount + "')";
	          %>
	          <div style="float:left;width:150px;">
	          <brow:browser viewType="0" id='<%="con"+id+"_value" %>' name='<%="con"+id+"_value" %>' browserValue='<%=browserValue%>' 
		          browserSpanValue='<%=browserSpanValue%>' 
		          browserOnClick='<%=bclick%>' 
		          hasInput="false" isSingle='<%=BrowserManager.browIsSingle(type)%>' 
		          hasBrowser = "true" 
		          isMustInput='1' onPropertyChange='<%=opchange %>'
		          completeUrl='<%="javascript:getajaxurl(" + type + ")"%>' 
		          needHidden="false" ></brow:browser>
		     </div>
	        <!-- 
			<button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser3('<%=id%>','<%=browserurl%>')"></button>
			 -->
   			<input type=hidden name="neworganizationid" id="neworganizationid" value="<%=id%>">
   			<input type=hidden id="organizationid_158" value="<%=id%>">
			<input type=hidden name="con<%=id%>_value" id="con<%=id%>_value" value="<%=browserValue%>"> 
			<input type=hidden name="con<%=id%>_name" id="con<%=id%>_name" value="<%=browserSpanValue%>">
			<!-- 
			<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"></span> 
			 -->
		</td>
<%} else if(htmltype.equals("3")&& !type.equals("224")  && !type.equals("225") && !type.equals("226")&& !type.equals("227") && !type.equals("165") && !type.equals("166")&& !type.equals("167")&& !type.equals("168")&& !type.equals("169")&& !type.equals("170")&& !type.equals("2") && !type.equals("4")&& !type.equals("18")&& !type.equals("19")&& !type.equals("17") && !type.equals("37") && !type.equals("65")&& !type.equals("57")&& !type.equals("162")&& !type.equals("135") && !type.equals("141") && !type.equals("256") && !type.equals("257") && !type.equals("24") && !type.equals("278")){
%>
		<td>
		<% 
			boolean copt1 = false;
			boolean copt2 = false;
			String browserValue = "";
			String browserSpanValue = "";
			if(ids.indexOf(""+id)!=-1){
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){
					copt1 = true;
				}
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){
					copt2 = true;
				}
				browserValue = ((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))));
		        browserSpanValue = ((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))));
			}
		%>
		<div style="float:left;">
			<select class=inputstyle name="con<%=id%>_opt" notBeauty="true"  onclick="changelevel('<%=id%>')" >
				<option value="1" <%if(copt1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
				<option value="2" <%if(copt2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
			</select>
		</div> 
			<%
            String browserurl = UrlComInfo.getUrlbrowserurl(type) ;
            if(type.equals("4") && sharelevel <2) {
                if(sharelevel == 1) browserurl = browserurl.trim() + "?sqlwhere="+xssUtil.put("where subcompanyid1 = " + user.getUserSubCompany1()) ;
                else browserurl = browserurl.trim() + "?sqlwhere="+xssUtil.put("where id = " + user.getUserDepartment());
            }else if("161".equals(type)){
		         browserurl = browserurl.trim() + "?type="+dbtype;
				 browserurl = browserurl+"%26isreport=1";
	    }
         %>
        <%--add by zhaolg for td17048--%>
         <%if((isbill.equals("1")&& formid == 158 && name.equals("organizationid")) || (fnaOrgId_fieldId_list.contains(id+""))){ %>
         
          <%
	           bclick = "onShowBrowser2('"+id+"','"+browserurl+"')";
          	   //browserurl = "/systeminfo/BrowserMain.jsp?url="+browserurl;
          	   String brwname ="con"+id+"_value";
          	   String opchange = "changecheckcon('con"+id+"_value','" + tmpcount + "')";
	          %>
	        <div style="float:left;width:150px;">
	        <%if(fnaOrgId_fieldId_list.contains(id+"")){ %>
	          <brow:browser viewType="0" name='<%="con"+id+"_value" %>' browserValue='<%=browserValue%>' 
		          browserSpanValue='<%=browserSpanValue%>' 
		          browserOnClick='<%=bclick%>' 
		          hasInput="false" isSingle='<%=BrowserManager.browIsSingle(type)%>' 
		          hasBrowser = "true"  onPropertyChange='<%=opchange %>'
		          isMustInput='1' width="150px"
		          needHidden="false" ></brow:browser>
	        <%}else{ %>
	          <brow:browser viewType="0" name='<%=brwname%>' browserValue='<%=browserValue%>' 
		          browserSpanValue='<%=browserSpanValue%>' 
		          browserUrl='<%=browserurl%>' 
		          hasInput="false" isSingle='<%=BrowserManager.browIsSingle(type)%>' 
		          hasBrowser = "true" 
		          isMustInput='1' onPropertyChange='<%=opchange %>'
		          >
		      </brow:browser>
	        <%} %>
		     </div>
          <!-- 
        	<button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" 
        	onclick="onShowBrowser3('<%=id%>','<%=browserurl%>')"></button>
          --> 
	        <%if(fnaOrgId_fieldId_list.contains(id+"")){ %>
	        <%}else{ %>
			<input type=hidden name="neworganizationid" id="neworganizationid" value="<%=id%>">
	        <%} %>
      	<%}else{ %>
      	   <%
	           bclick = "onShowBrowser('"+id+"','"+browserurl+"')";
      		   //browserurl = "/systeminfo/BrowserMain.jsp?url="+browserurl;
      		   String brwname ="con"+id+"_value";
      		   String opchange = "changecheckcon('con"+id+"_value','" + tmpcount + "')";
			   if(type.equals("160")){
				   rswf.execute(" select level_n from WORKFLOW_GROUPDETAIL where groupid in (select id from workflow_nodegroup where nodeid in (select nodeid from workflow_flownode where workflowid in ("+reportwfid+")))") ;
				   String roleids = "";
				   while(rswf.next()){
					   if(!"".equals(roleids)){
						   roleids += ","+rswf.getString("level_n");
					   }else{
						   roleids = rswf.getString("level_n");
					   }
				   }
      			   browserurl += roleids;
      		   }
	          %>
	          <div style="float:left;width:150px;">
	          <brow:browser viewType="0" name='<%=brwname%>'  browserValue='<%=browserValue%>' 
		          browserSpanValue='<%=browserSpanValue%>' 
		          browserUrl='<%=browserurl%>'  
		          hasInput="true" isSingle='<%=BrowserManager.browIsSingle(type)%>' 
		          hasBrowser = "true" onPropertyChange='<%=opchange %>'
		          isMustInput='1' width="150px" 
				  completeUrl='<%="/data.jsp?isreport=1&type="+type+"&fielddbtype="+dbtype%>'
		           ></brow:browser>
		      </div>
		    <!-- 
        	<button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','<%=browserurl%>')"></button>
		     -->       
      	<%} %>
      	<%--end--%>

      <input type=hidden name="con<%=id%>_value" id="con<%=id%>_value" value="<%=browserValue %>">
      <input type=hidden name="con<%=id%>_name" id="con<%=id%>_name" value="<%=browserSpanValue%>">

		</td>
<%} else if(htmltype.equals("3") &&( type.equals("2") || type.equals("19"))){ // 增加日期和时间的处理（之间）
%>		
		<td>
		<% 
			boolean copt1 = false;
			boolean copt2 = false;
			boolean copt3 = false;
			boolean copt4 = false;
			boolean copt5 = false;
			boolean copt6 = false;
			boolean copt21 = false;
			boolean copt22 = false;
			boolean copt23 = false;
			boolean copt24 = false;
			boolean copt25 = false;
			boolean copt26 = false;
			if(ids.indexOf(""+id)!=-1){
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){
					copt1 = true;
				}
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){
					copt2 = true;
				}
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("3")){
					copt3 = true;
				}
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("4")){
					copt4 = true;
				}
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("5")){
					copt5 = true;
				}
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("6")){
					copt6 = true;
				}
				if(((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){
					copt21 = true;
				}
				if(((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){
					copt22 = true;
				}
				if(((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("3")){
					copt23 = true;
				}
				if(((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("4")){
					copt24 = true;
				}
				if(((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("5")){
					copt25 = true;
				}
				if(((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("6")){
					copt26 = true;
				}
			}
		%>  
			<select class=inputstyle name="con<%=id%>_opt" notBeauty="true" onclick="changelevel('<%=id%>')" >
				<option value="1" <%if(copt1){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
				<option value="2" <%if(copt2){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
				<option value="3" <%if(copt3){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
				<option value="4" <%if(copt4){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
				<option value="5" <%if(copt5){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
				<option value="6" <%if(copt6){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
			</select>
			<button type=button  class=Browser  onfocus="changelevel('<%=id%>')"  
<%if(type.equals("2")){%>
   onclick="onSearchWFDate(con<%=id%>_valuespan,con<%=id%>_value)"
<%}else{%>
 onclick ="onSearchWFTime(con<%=id%>_valuespan,con<%=id%>_value)"
<%}%>
 ></button>
      <input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%>" <%}%>>
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      <%if(ids.indexOf(""+id)!=-1){%>
      <%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%>
      <%}%>
      </span> 
			<select class=inputstyle name="con<%=id%>_opt1" notBeauty="true" onclick="changelevel('<%=id%>')" >
				<option value="1" <%if(copt21){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
				<option value="2" <%if(copt22){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
        		<option value="3" <%if(copt23){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
        		<option value="4" <%if(copt24){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
        		<option value="5" <%if(copt25){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        		<option value="6" <%if(copt26){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
			</select>
			<button type=button  class=Browser  onfocus="changelevel('<%=id%>')"  
<%if(type.equals("2")){%>
   onclick="onSearchWFDate(con<%=id%>_value1span,con<%=id%>_value1)"
<%}else{%>
   onclick ="onSearchWFTime(con<%=id%>_value1span,con<%=id%>_value1)"
<%}%>
 ></button>
      <input type=hidden name="con<%=id%>_value1" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)value1s.get(Util.getIntValue(""+ids.indexOf(""+id))))%>" <%}%>>
      <span name="con<%=id%>_value1span" id="con<%=id%>_value1span">
      <%if(ids.indexOf(""+id)!=-1){%>
      <%=((String)value1s.get(Util.getIntValue(""+ids.indexOf(""+id))))%>
      <%}%>
      </span> 
		</td>
<%} else if(htmltype.equals("3") && type.equals("4")){ // 增加部门的处理（可选择多个部门）

%>
		<td>
		<% 
			boolean copt1 = false;
			boolean copt2 = false;
			String browserValue = "";
			String browserSpanValue = "";
			if(ids.indexOf(""+id)!=-1){
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){
					copt1 = true;
				}
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){
					copt2 = true;
				}
				browserValue = ((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))));
		        browserSpanValue = ((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))));
			}
		%>
		<div style="float:left;">
			<select class=inputstyle name="con<%=id%>_opt" notBeauty="true" onclick="changelevel('<%=id%>')" >
        		<option value="1" <%if(copt1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(353,user.getLanguage())%></option>
        		<option value="2" <%if(copt2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21473,user.getLanguage())%></option>
      		</select>
      		</div>
      		  <%
	           bclick = "onShowBrowser2('"+id+"','/systeminfo/BrowserMain.jsp?url=/hrm/company/MultiDepartmentBrowserByOrder.jsp')";
      		  String opchange = "changecheckcon('con"+id+"_value','" + tmpcount + "')";
	          %>
      		 <div style="float:left;width:150px;">
	          <brow:browser viewType="0" name='<%="con"+id+"_value" %>' browserValue='<%=browserValue%>' 
		          browserSpanValue='<%=browserSpanValue%>' 
		          browserOnClick='<%=bclick%>' 
		          hasInput="true" isSingle='<%=BrowserManager.browIsSingle(type)%>' 
		          hasBrowser = "true"  onPropertyChange='<%=opchange %>'
		          isMustInput='1' width="150px"
		          completeUrl='<%="javascript:getajaxurl(" + type + ")"%>' 
		          needHidden="false" ></brow:browser>
		         </div>
      		<!-- <button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser2('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp')"></button>
		          -->
      		<input type=hidden name="con<%=id%>_value" id="con<%=id%>_value" value="<%=browserValue%>">
      		<input type=hidden name="con<%=id%>_name" id="con<%=id%>_name" value="<%=browserSpanValue%>">
     		 <!-- <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"></span> 
		          -->
		</td>
<%} else if(htmltype.equals("3") && ( type.equals("165") || type.equals("167") || type.equals("169"))){ // 增加分权单选字段，人，部门，分部

		String url_tmp = "";
		if(type.equals("165")){
			url_tmp = "/systeminfo/BrowserMain.jsp?url=";
			if(ismain == 1){
				url_tmp += URLEncoder.encode("/hrm/resource/ResourceBrowserByDec.jsp?isbill="+isbill+"&fieldid="+id);
			}else{
				url_tmp += URLEncoder.encode("/hrm/resource/ResourceBrowserByDec.jsp?isdetail=1&isbill="+isbill+"&fieldid="+id);
			}
		}else if(type.equals("167")){
			url_tmp = "/systeminfo/BrowserMain.jsp?url=";
			if(ismain == 1){
				url_tmp += URLEncoder.encode("/hrm/company/DepartmentBrowserByDec.jsp?isbill="+isbill+"&fieldid="+id);
			}else{
				url_tmp += URLEncoder.encode("/hrm/company/DepartmentBrowserByDec.jsp?isdetail=1&isbill="+isbill+"&fieldid="+id);
			}
		}else{
			url_tmp = "/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowserByDec.jsp";
		}
%>		
		<td>
		<% 
			boolean copt1 = false;
			boolean copt2 = false;
			String browserValue = "";
			String browserSpanValue = "";
			if(ids.indexOf(""+id)!=-1){
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){
					copt1 = true;
				}
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){
					copt2 = true;
				}
				browserValue = ((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))));
		        browserSpanValue = ((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))));
			}
		%>
		
		<div style="float:left;">
			<select class=inputstyle name="con<%=id%>_opt" notBeauty="true" onclick="changelevel('<%=id%>')" >
        		<option value="1" <%if(copt1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(353,user.getLanguage())%></option>
        		<option value="2" <%if(copt2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21473,user.getLanguage())%></option>
			</select>
			</div>
			  <%
	           bclick = "onShowBrowser('"+id+"','"+url_tmp+"')";
			  String opchange = "changecheckcon('con"+id+"_value','" + tmpcount + "')";
	          %>
      		 <div style="float:left;width:150px;">
	          <brow:browser viewType="0" name='<%="con"+id+"_value" %>' browserValue='<%=browserValue%>' 
		          browserSpanValue='<%=browserSpanValue%>' 
		          browserOnClick='<%=bclick%>' 
		          hasInput="true" isSingle='<%=BrowserManager.browIsSingle(type)%>' 
		          hasBrowser = "true"  onPropertyChange='<%=opchange %>'
		          isMustInput='1' width="150px"
		          completeUrl='<%="javascript:getajaxurl(" + type + ")"%>' 
		          needHidden="false" ></brow:browser>
		         </div>
			<!-- <button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','<%=url_tmp%>')"></button>
		          -->
      		<input type=hidden name="con<%=id%>_value" id="con<%=id%>_value" value="<%=browserValue%>">
      		<input type=hidden name="con<%=id%>_name" id="con<%=id%>_name" value="<%=browserSpanValue%>">
      		<!-- <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"></span> 
		          -->
		</td>
<%} else if(htmltype.equals("3") && ( type.equals("166") || type.equals("168") || type.equals("170"))){ // 增加分权多选字段，人，部门，分部

		String url_tmp = "";
		if(type.equals("166")){
			url_tmp = "/systeminfo/BrowserMain.jsp?url=";
			if(ismain == 1){
				url_tmp += URLEncoder.encode("/hrm/resource/MultiResourceBrowserByDec.jsp?isbill="+isbill+"&fieldid="+id);
			}else{
				url_tmp += URLEncoder.encode("/hrm/resource/MultiResourceBrowserByDec.jsp?isdetail=1&isbill="+isbill+"&fieldid="+id);
			}
		}else if(type.equals("168")){
			url_tmp = "/systeminfo/BrowserMain.jsp?url=";
			if(ismain == 1){
				url_tmp += URLEncoder.encode("/hrm/company/MultiDepartmentBrowserByDecOrder.jsp?isbill="+isbill+"&fieldid="+id);
			}else{
				url_tmp += URLEncoder.encode("/hrm/company/MultiDepartmentBrowserByDecOrder.jsp?isdetail=1&isbill="+isbill+"&fieldid="+id);
			}
		}else{
			url_tmp = "/systeminfo/BrowserMain.jsp?url=/hrm/company/MultiSubcompanyBrowserByDec.jsp";
		}
%>
		<td>
		
		<% 
			boolean copt1 = false;
			boolean copt2 = false;
			String browserValue = "";
			String browserSpanValue = "";
			if(ids.indexOf(""+id)!=-1){
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){
					copt1 = true;
				}
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){
					copt2 = true;
				}
				browserValue = ((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))));
		        browserSpanValue = ((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))));
			}
		%>
		<div style="float:left;">
			<select class=inputstyle name="con<%=id%>_opt" notBeauty="true" onclick="changelevel('<%=id%>')" >
        		<option value="1" <%if(copt1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        		<option value="2" <%if(copt2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      		</select>
      		</div>
      		         	<%
	           bclick = "onShowBrowser('"+id+"','"+url_tmp+"')";
      		   String opchange = "changecheckcon('con"+id+"_value','" + tmpcount + "')";
	          %>
      		 <div style="float:left;width:150px;">
	          <brow:browser viewType="0" name='<%="con"+id+"_value" %>' browserValue='<%=browserValue%>' 
		          browserSpanValue='<%=browserSpanValue%>' 
		          browserOnClick='<%=bclick%>' 
		          hasInput="true" isSingle='<%=BrowserManager.browIsSingle(type)%>' 
		          hasBrowser = "true" onPropertyChange='<%=opchange %>' 
		          isMustInput='1' width="150px"
		          completeUrl='<%="javascript:getajaxurl(" + type + ")"%>' 
		          needHidden="false" ></brow:browser>
		         </div>
      		<!-- <button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','<%=url_tmp%>')"></button>
      		 -->
      		<input type=hidden name="con<%=id%>_value" id="con<%=id%>_value" value="<%=browserValue%>">
      		<input type=hidden name="con<%=id%>_name" id="con<%=id%>_name" value="<%=browserSpanValue%>">
      		<!-- <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"></span> 
      		 -->
		</td>
	<%} else if(htmltype.equals("3") && type.equals("141") && false){ //
	%>
		<td>
		<% 
			boolean copt1 = false;
			boolean copt2 = false;
			String browserValue = "";
			String browserSpanValue = "";
			if(ids.indexOf(""+id)!=-1){
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){
					copt1 = true;
				}
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){
					copt2 = true;
				}
				browserValue = ((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))));
		        browserSpanValue = ((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))));
			}
		%>
		<div style="float:left;">
			<select class=inputstyle name="con<%=id%>_opt" notBeauty="true" onclick="changelevel('<%=id%>')" >
        		<option value="1" <%if(copt1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        		<option value="2" <%if(copt2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      		</select>
      		</div>
      		<%
            	String browserurl = UrlComInfo.getUrlbrowserurl(type) ;
         	%>
         	<%
	           bclick = "onShowResourceConditionBrowser('"+id+"','"+browserurl+"')";
         	String opchange = "changecheckcon('con"+id+"_value','" + tmpcount + "')";
	          %>
      		 <div style="float:left;width:150px;">
	          <brow:browser viewType="0" name='<%="con"+id+"_value" %>' browserValue='<%=browserValue%>' 
		          browserSpanValue='<%=browserSpanValue%>' 
		          browserOnClick='<%=bclick%>' 
		          hasInput="true" isSingle='<%=BrowserManager.browIsSingle(type)%>' 
		          hasBrowser = "true" onPropertyChange='<%=opchange %>'
		          isMustInput='1' width="150px"
		          completeUrl='<%="javascript:getajaxurl(" + type + ")"%>' 
		          needHidden="false" ></brow:browser>
		         </div>
       		<!-- <button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowResourceConditionBrowser('<%=id%>','<%=browserurl%>')"></button>
         	 -->
      		<input type=hidden name="con<%=id%>_value" id="con<%=id%>_value" value="<%=browserValue%>">
      		<input type=hidden name="con<%=id%>_name" id="con<%=id%>_name" value="<%=browserSpanValue%>">
      		<!-- <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"></span> 
         	 -->
		</td>
<%} else if(htmltype.equals("3") && type.equals("57")){ // 增加多部门的处理（包含，不包含）
%>
		<td>
		<% 
			boolean copt1 = false;
			boolean copt2 = false;
			String browserValue = "";
			String browserSpanValue = "";
			if(ids.indexOf(""+id)!=-1){
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){
					copt1 = true;
				}
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){
					copt2 = true;
				}
				browserValue = ((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))));
		        browserSpanValue = ((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))));
			}
		%>
		<div style="float:left;">
			<select class=inputstyle name="con<%=id%>_opt" notBeauty="true" onclick="changelevel('<%=id%>')" >
        		<option value="1" <%if(copt1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        		<option value="2" <%if(copt2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      		</select>
      		</div>
      		<%
	           bclick = "onShowBrowser2('"+id+"','/systeminfo/BrowserMain.jsp?url=/hrm/company/MultiDepartmentBrowserByOrder.jsp')";
      		String opchange = "changecheckcon('con"+id+"_value','" + tmpcount + "')";
	          %>
      		 <div style="float:left;width:150px;">
	          <brow:browser viewType="0" name='<%="con"+id+"_value" %>' browserValue='<%=browserValue%>' 
		          browserSpanValue='<%=browserSpanValue%>' 
		          browserOnClick='<%=bclick%>' 
		          hasInput="true" isSingle='<%=BrowserManager.browIsSingle(type)%>' 
		          hasBrowser = "true" onPropertyChange='<%=opchange %>' 
		          isMustInput='1' width="150px"
		          completeUrl='<%="javascript:getajaxurl(" + type + ")"%>' 
		          needHidden="false" ></brow:browser>
		         </div>
      		<!-- <button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser2('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp')"></button>
      		 -->
      		<input type=hidden name="con<%=id%>_value" id="con<%=id%>_value" value="<%=browserValue%>">
      		<input type=hidden name="con<%=id%>_name" id="con<%=id%>_name" value="<%=browserSpanValue%>">
      		<!-- <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"></span> 
      		 -->
		</td>
<%} else if(htmltype.equals("3") && type.equals("17")){ // 增加多人力资源的处理（包含，不包含）
%>		
		<td>
		<% 
			boolean copt1 = false;
			boolean copt2 = false;
			String browserValue = "";
			String browserSpanValue = "";
			if(ids.indexOf(""+id)!=-1){
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){
					copt1 = true;
				}
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){
					copt2 = true;
				}
				browserValue = ((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))));
		        browserSpanValue = ((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))));
			}
		%>
		<div style="float:left;">
			<select class=inputstyle name="con<%=id%>_opt" notBeauty="true" onclick="changelevel('<%=id%>')" >
        		<option value="1" <%if(copt1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        		<option value="2" <%if(copt2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
			</select>
			</div>
			  <%
	           bclick = "onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp')";
			  String opchange = "changecheckcon('con"+id+"_value','" + tmpcount + "')";
	          %>
      		 <div style="float:left;width:150px;">
	          <brow:browser viewType="0" name='<%="con"+id+"_value" %>' browserValue='<%=browserValue%>' 
		          browserSpanValue='<%=browserSpanValue%>' 
		          browserOnClick='<%=bclick%>' 
		          hasInput="true" isSingle='<%=BrowserManager.browIsSingle(type)%>' 
		          hasBrowser = "true" onPropertyChange='<%=opchange %>' 
		          isMustInput='1' width="150px"
		          completeUrl='<%="javascript:getajaxurl(" + type + ")"%>' 
		          needHidden="false" ></brow:browser>
		         </div>
			<!-- <button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp')"></button>
			 -->
      		<input type=hidden name="con<%=id%>_value" id="con<%=id%>_value" value="<%=browserValue%>">
      		<input type=hidden name="con<%=id%>_name" id="con<%=id%>_name" value="<%=browserSpanValue%>">
      		<!-- <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"></span> 
      		<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"></span> 
			 -->
		</td>
<%} else if(htmltype.equals("3") && type.equals("65")){ 
        // modify by mackjoe at 2005-11-24 td2862 增加多角色的处理（包含，不包含）
%>
		<td>
		<% 
			boolean copt1 = false;
			boolean copt2 = false;
			String browserValue = "";
			String browserSpanValue = "";
			if(ids.indexOf(""+id)!=-1){
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){
					copt1 = true;
				}
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){
					copt2 = true;
				}
				browserValue = ((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))));
		        browserSpanValue = ((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))));
			}
		%>
		<div style="float:left;">
			<select class=inputstyle name="con<%=id%>_opt" notBeauty="true" onclick="changelevel('<%=id%>')" >
        		<option value="1" <%if(copt1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        		<option value="2" <%if(copt2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      		</select>
      		</div>
      		 <%
	           bclick = "onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/hrm/roles/MutiRolesBrowser.jsp')";
      		 String opchange = "changecheckcon('con"+id+"_value','" + tmpcount + "')";
	          %>
      		 <div style="float:left;width:150px;">
	          <brow:browser viewType="0" name='<%="con"+id+"_value" %>' browserValue='<%=browserValue%>' 
		          browserSpanValue='<%=browserSpanValue%>' 
		          browserOnClick='<%=bclick%>' 
		          hasInput="true" isSingle='<%=BrowserManager.browIsSingle(type)%>' 
		          hasBrowser = "true" onPropertyChange='<%=opchange %>' 
		          isMustInput='1' width="150px"
		          completeUrl='<%="javascript:getajaxurl(" + type + ")"%>' 
		          needHidden="false" ></brow:browser>
		         </div>
      		<!-- <button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp')"></button>
      		 -->
      		<input type=hidden name="con<%=id%>_value" id="con<%=id%>_value" value="<%=browserValue%>">
      		<input type=hidden name="con<%=id%>_name" id="con<%=id%>_name" value="<%=browserSpanValue%>">
      		<!--<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"></span> 
      		 <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"></span> 
      		 -->
		</td>
<%} else if(htmltype.equals("3") && type.equals("18")){ // 增加多客户的处理（包含，不包含）
%>		
		<td>
		<% 
			boolean copt1 = false;
			boolean copt2 = false;
			String browserValue = "";
			String browserSpanValue = "";
			if(ids.indexOf(""+id)!=-1){
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){
					copt1 = true;
				}
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){
					copt2 = true;
				}
				browserValue = ((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))));
		        browserSpanValue = ((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))));
			}
		%>
		<div style="float:left;">
			<select class=inputstyle name="con<%=id%>_opt" notBeauty="true" onclick="changelevel('<%=id%>')" >
        		<option value="1" <%if(copt1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        		<option value="2" <%if(copt2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      		</select>
      		</div>
      		 <%
	           bclick = "onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp')";
      		 String opchange = "changecheckcon('con"+id+"_value','" + tmpcount + "')";
	          %>
      		 <div style="float:left;width:150px;">
	          <brow:browser viewType="0" name='<%="con"+id+"_value" %>' browserValue='<%=browserValue%>' 
		          browserSpanValue='<%=browserSpanValue%>' 
		          browserOnClick='<%=bclick%>' 
		          hasInput="true" isSingle='<%=BrowserManager.browIsSingle(type)%>' 
		          hasBrowser = "true" onPropertyChange='<%=opchange %>' 
		          isMustInput='1' width="150px"
		          completeUrl='<%="javascript:getajaxurl(" + type + ")"%>' 
		          needHidden="false" ></brow:browser>
		         </div>
      		<!-- <button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp')"></button>
      		 -->
      		<input type=hidden name="con<%=id%>_value" id="con<%=id%>_value" value="<%=browserValue%>">
      		<input type=hidden name="con<%=id%>_name" id="con<%=id%>_name" value="<%=browserSpanValue%>">
      		<!--<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"></span> 
      		 <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"></span>
      		 -->
		</td>
<%} else if(htmltype.equals("3") && type.equals("37")){ // 增加多文档的处理（包含，不包含） 
%>
		<td>
		<% 
			boolean copt1 = false;
			boolean copt2 = false;
			String browserValue = "";
			String browserSpanValue = "";
			if(ids.indexOf(""+id)!=-1){
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){
					copt1 = true;
				}
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){
					copt2 = true;
				}
				browserValue = ((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))));
		        browserSpanValue = ((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))));
			}
		%>
		<div style="float:left;">
			<select class=inputstyle name="con<%=id%>_opt" notBeauty="true" onclick="changelevel('<%=id%>')" >
        		<option value="1" <%if(copt1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        		<option value="2" <%if(copt2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      		</select>
      		</div>
      		<%
	           bclick = "onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp')";
      		String opchange = "changecheckcon('con"+id+"_value','" + tmpcount + "')";
	          %>
      		 <div style="float:left;width:150px;">
	          <brow:browser viewType="0" name='<%="con"+id+"_value" %>' browserValue='<%=browserValue%>' 
		          browserSpanValue='<%=browserSpanValue%>' 
		          browserOnClick='<%=bclick%>' 
		          hasInput="true" isSingle='<%=BrowserManager.browIsSingle(type)%>' 
		          hasBrowser = "true" onPropertyChange='<%=opchange %>'
		          isMustInput='1' width="150px"
		          completeUrl='<%="javascript:getajaxurl(" + type + ")"%>' 
		          needHidden="false" ></brow:browser>
		         </div>
      		<!--<button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp')"></button>
		           -->
      		<input type=hidden name="con<%=id%>_value" id="con<%=id%>_value" value="<%=browserValue%>">
      		<input type=hidden name="con<%=id%>_name" id="con<%=id%>_name" value="<%=browserSpanValue%>">
      		<!--<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"></span> 
      		<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"></span> 
		           -->
		</td>
<%} else if(htmltype.equals("3")&&type.equals("162")){ // 增加多自定义浏览框的处理（包含，不包含）
%>
		<td>
		<% 
			boolean copt1 = false;
			boolean copt2 = false;
			String browserValue = "";
			String browserSpanValue = "";
			if(ids.indexOf(""+id)!=-1){
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){
					copt1 = true;
				}
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){
					copt2 = true;
				}
				browserValue = ((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))));
		        browserSpanValue = ((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))));
			}
		%>
		<div style="float:left;">
			<select class=inputstyle name="con<%=id%>_opt" notBeauty="true" onclick="changelevel('<%=id%>')" >
        		<option value="1" <%if(copt1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        		<option value="2" <%if(copt2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      		</select>
      		</div>
      		<%
			String browserurl = UrlComInfo.getUrlbrowserurl(type) ;
			browserurl = browserurl.trim() + "?type="+dbtype;
			if(type.equals("162")){
				browserurl = browserurl+"%26isreport=1";
			}
		    %>
    
         		<%
	           bclick = "onShowBrowser('"+id+"','"+browserurl+"')";
         		String opchange = "changecheckcon('con"+id+"_value','" + tmpcount + "')";
	          %>
      		 <div style="float:left;width:150px;">
	          <brow:browser viewType="0" name='<%="con"+id+"_value" %>' browserValue='<%=browserValue%>'
		          browserSpanValue='<%=browserSpanValue%>' 
		          browserOnClick='<%=bclick%>' 
		          hasInput="true" isSingle='<%=BrowserManager.browIsSingle(type)%>' 
		          hasBrowser = "true" onPropertyChange='<%=opchange %>' 
		          isMustInput='1' width="150px"
		          completeUrl='<%="/data.jsp?isreport=1&type="+type+"&fielddbtype="+dbtype%>'
		          needHidden="false" ></brow:browser>
		         </div>
		          <!-- 
    		<button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','<%=browserurl%>')"></button>
    -->
      		<input type=hidden name="con<%=id%>_value" id="con<%=id%>_value" value="<%=browserValue%>">
      		<input type=hidden name="con<%=id%>_name" id="con<%=id%>_name" value="<%=browserSpanValue%>">
      		<!-- <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"></span> 
      		
      		<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"></span> 
      		 -->
		</td>
<%} else if(htmltype.equals("3")&&type.equals("256")){ // 增加自定义树形浏览框单选的处理（属于，不属于）
	%>
	<td>
	<% 
		boolean copt1 = false;
		boolean copt2 = false;
		String browserValue = "";
		String browserSpanValue = "";
		if(ids.indexOf(""+id)!=-1){
			if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){
				copt1 = true;
			}
			if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){
				copt2 = true;
			}
			browserValue = ((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))));
	        browserSpanValue = ((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))));
		}
	%>
	<div style="float:left;">
		<select class=inputstyle name="con<%=id%>_opt" notBeauty="true" onclick="changelevel('<%=id%>')" >
    		<option value="1" <%if(copt1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(353,user.getLanguage())%></option>
        		<option value="2" <%if(copt2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21473,user.getLanguage())%></option>
  		</select>
  		</div>
  		<%
		String browserurl = UrlComInfo.getUrlbrowserurl(type) ;
		browserurl = browserurl.trim() + "?type="+dbtype+"_257";
	    %>

     		<%
           bclick = "onShowBrowserNew('"+id+"','"+browserurl+"')";
     		String opchange = "changecheckcon('con"+id+"_value','" + tmpcount + "')";
          %>
  		 <div style="float:left;width:150px;">
          <brow:browser viewType="0" name='<%="con"+id+"_value" %>' browserValue='<%=browserValue%>'
	          browserSpanValue='<%=browserSpanValue%>' 
	          browserOnClick='<%=bclick%>' 
	          hasInput="true" isSingle='<%=BrowserManager.browIsSingle(type)%>' 
	          hasBrowser = "true" onPropertyChange='<%=opchange%>' 
	          isMustInput='1' width="150px"
	          completeUrl='<%="javascript:getajaxurl(" + type + ")"%>' 
	          needHidden="false" ></brow:browser>
	         </div>
	          <!-- 
		<button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','<%=browserurl%>')"></button>
-->
  		<input type=hidden name="con<%=id%>_value" id="con<%=id%>_value" value="<%=browserValue%>">
  		<input type=hidden name="con<%=id%>_name" id="con<%=id%>_name" value="<%=browserSpanValue%>">
  		<!-- <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"></span> 
  		
  		<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"></span> 
  		 -->
	</td>
<%} else if(htmltype.equals("3")&&type.equals("257")){ // 增加多自定义树形浏览框多选的处理（包含，不包含）
	%>
	<td>
	<% 
		boolean copt1 = false;
		boolean copt2 = false;
		String browserValue = "";
		String browserSpanValue = "";
		if(ids.indexOf(""+id)!=-1){
			if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){
				copt1 = true;
			}
			if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){
				copt2 = true;
			}
			browserValue = ((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))));
	        browserSpanValue = ((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))));
		}
	%>
	<div style="float:left;">
		<select class=inputstyle name="con<%=id%>_opt" notBeauty="true" onclick="changelevel('<%=id%>')" >
    		<option value="1" <%if(copt1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
    		<option value="2" <%if(copt2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
  		</select>
  		</div>
  		<%
  		
		String browserurl = UrlComInfo.getUrlbrowserurl(type) ;
		browserurl = browserurl.trim() + "?type="+dbtype+"_256";
	    %>

     		<%
           bclick = "onShowBrowserNew('"+id+"','"+browserurl+"')";
     		String opchange = "changecheckcon('con"+id+"_value','" + tmpcount + "')";
          %>
  		 <div style="float:left;width:150px;">
          <brow:browser viewType="0" name='<%="con"+id+"_value" %>' browserValue='<%=browserValue%>'
	          browserSpanValue='<%=browserSpanValue%>' 
	          browserOnClick='<%=bclick%>' 
	          hasInput="true" isSingle='<%=BrowserManager.browIsSingle(type)%>' 
	          hasBrowser = "true" onPropertyChange='<%=opchange %>' 
	          isMustInput='1' width="150px"
	          completeUrl='<%="javascript:getajaxurl(" + type + ")"%>' 
	          needHidden="false" ></brow:browser>
	         </div>
	          <!-- 
		<button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','<%=browserurl%>')"></button>
-->
  		<input type=hidden name="con<%=id%>_value" id="con<%=id%>_value" value="<%=browserValue%>">
  		<input type=hidden name="con<%=id%>_name" id="con<%=id%>_name" value="<%=browserSpanValue%>">
  		<!-- <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"></span> 
  		
  		<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"></span> 
  		 -->
	</td>
<%} else if(htmltype.equals("3") && type.equals("135")){ // 增加多项目处理（包含，不包含）

	%>		
		<td>
		<% 
			boolean copt1 = false;
			boolean copt2 = false;
			String browserValue = "";
			String browserSpanValue = "";
			if(ids.indexOf(""+id)!=-1){
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){
					copt1 = true;
				}
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){
					copt2 = true;
				}
				browserValue = ((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))));
		        browserSpanValue = ((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))));
			}
		%>
		<div style="float:left;">
			<select class=inputstyle name="con<%=id%>_opt" notBeauty="true" onclick="changelevel('<%=id%>')" >
        		<option value="1" <%if(copt1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        		<option value="2" <%if(copt2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      		</select>
      		</div>
      		<%
	           bclick = "onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp')";
      		String opchange = "changecheckcon('con"+id+"_value','" + tmpcount + "')";
	          %>
      		 <div style="float:left;width:150px;">
	          <brow:browser viewType="0" name='<%="con"+id+"_value" %>' browserValue='<%=browserValue%>' 
		          browserSpanValue='<%=browserSpanValue%>' 
		          browserOnClick='<%=bclick%>' 
		          hasInput="true" isSingle='<%=BrowserManager.browIsSingle(type)%>' 
		          hasBrowser = "true" onPropertyChange='<%=opchange %>' 
		          isMustInput='1' width="150px"
		          completeUrl='<%="javascript:getajaxurl(" + type + ")"%>' 
		          needHidden="false" ></brow:browser>
		         </div>
		          <!-- 
      		<button type=button  class=Browser  onfocus="changelevel('<%=id%>')" onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp')"></button>
		         -->
      		<input type=hidden name="con<%=id%>_value" id="con<%=id%>_value" value="<%=browserValue %>">
      		<input type=hidden name="con<%=id%>_name" id="con<%=id%>_name" value="<%=browserSpanValue %>">
      		<!-- <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"></span>  -->
		</td>
<%}else if(htmltype.equals("3") &&(type.equals("224")||type.equals("225")||type.equals("226")||type.equals("227"))){
        %>
        <td>
        <% 
			boolean copt1 = false;
			boolean copt2 = false;
			String browserValue = "";
			String browserSpanValue = "";
			if(ids.indexOf(""+id)!=-1){
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){
					copt1 = true;
				}
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){
					copt2 = true;
				}
				browserValue = ((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))));
		        browserSpanValue = ((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))));
			}
		%>
        <div style="float:left;">
        	<select class=inputstyle name="con<%=id%>_opt" notBeauty="true" onclick="changelevel('<%=id%>')" >
		        <option value="1" <%if(copt1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
		        <option value="2" <%if(copt2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
		     </select>
		     </div>
		     <%
	            String browserurl = UrlComInfo.getUrlbrowserurl(type) ;
	          	if(type.equals("224")||type.equals("225")){
	          		//老版本的sap浏览按钮
	          		browserurl+="?type="+dbtype+"|"+id+"&fromReport=1&fromReportformid="+formid+"&fromReportisbill="+isbill;
	          	}else{
	          		//新版本的sap浏览按钮
	          		//?type=browser.103|17884
	          		browserurl+="?type="+dbtype+"|"+id+"&fromNode=1";
	          	}
	         %>
	         
	        <%
	           bclick = "onShowBrowser('"+id+"','"+browserurl+"','"+type+"')";
	        String opchange = "changecheckcon('con"+id+"_value','" + tmpcount + "')";
	          %>
      		 <div style="float:left;width:150px;">
	          <brow:browser viewType="0" name='<%="con"+id+"_value" %>' browserValue='<%=browserValue%>' 
		          browserSpanValue='<%=browserSpanValue%>' 
		          browserOnClick='<%=bclick%>' 
		          hasInput="true" isSingle='<%=BrowserManager.browIsSingle(type)%>' 
		          hasBrowser = "true" onPropertyChange='<%=opchange %>' 
		          isMustInput='1' width="150px"
		          completeUrl='<%="javascript:getajaxurl(" + type + ")"%>' 
		          needHidden="false" ></brow:browser>
		         </div>
		         <!-- 
		      <button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','<%=browserurl%>','<%=type%>')"></button>
	          -->
			 <input type=hidden name="con<%=id%>_value" id="con<%=id%>_value" value="<%=browserValue%>">
			<input type=hidden name="con<%=id%>_name" id="con<%=id%>_name" value="<%=browserSpanValue%>">
			<!-- <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=currNode.getVal3() %> -->
			</span>
		</td>
<%}else if(htmltype.equals("3")&&type.equals("24")){ // 增加岗位单选的处理（属于，不属于）
	%>
	<td>
	<% 
		boolean copt1 = false;
		boolean copt2 = false;
		String browserValue = "";
		String browserSpanValue = "";
		if(ids.indexOf(""+id)!=-1){
			if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){
				copt1 = true;
			}
			if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){
				copt2 = true;
			}
			browserValue = ((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))));
	        browserSpanValue = ((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))));
		}
	%>
	<div style="float:left;">
		<select class=inputstyle name="con<%=id%>_opt" notBeauty="true" onclick="changelevel('<%=id%>')" >
    		<option value="1" <%if(copt1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(353,user.getLanguage())%></option>
        	<option value="2" <%if(copt2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21473,user.getLanguage())%></option>
  		</select>
  		</div>
     		<%
     		bclick = "onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/MutiJobTitlesBrowser.jsp')";
     		String opchange = "changecheckcon('con"+id+"_value','" + tmpcount + "')";
          %>
  		 <div style="float:left;width:150px;">
          <brow:browser viewType="0" name='<%="con"+id+"_value" %>' browserValue='<%=browserValue%>'
	          browserSpanValue='<%=browserSpanValue%>' 
	          browserOnClick='<%=bclick%>' 
	          hasInput="true" isSingle='false' 
	          hasBrowser = "true" onPropertyChange='<%=opchange%>' 
	          isMustInput='1' width="150px"
	          completeUrl='<%="javascript:getajaxurl(" + type + ")"%>' 
	           ></brow:browser>
	         </div>
  		<input type=hidden name="con<%=id%>_value" id="con<%=id%>_value" value="<%=browserValue%>">
  		<input type=hidden name="con<%=id%>_name" id="con<%=id%>_name" value="<%=browserSpanValue%>">
	</td>
<%}else if(htmltype.equals("3") && type.equals("278")){ // 增加多岗位（包含，不包含）

	%>		
		<td>
		<% 
			boolean copt1 = false;
			boolean copt2 = false;
			String browserValue = "";
			String browserSpanValue = "";
			if(ids.indexOf(""+id)!=-1){
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){
					copt1 = true;
				}
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){
					copt2 = true;
				}
				browserValue = ((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))));
		        browserSpanValue = ((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))));
			}
		%>
		<div style="float:left;">
			<select class=inputstyle name="con<%=id%>_opt" notBeauty="true" onclick="changelevel('<%=id%>')" >
        		<option value="1" <%if(copt1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        		<option value="2" <%if(copt2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      		</select>
      		</div>
      		<%
	           bclick = "onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp')";
      		String opchange = "changecheckcon('con"+id+"_value','" + tmpcount + "')";
	          %>
      		 <div style="float:left;width:150px;">
	          <brow:browser viewType="0" name='<%="con"+id+"_value" %>' browserValue='<%=browserValue%>' 
		          browserSpanValue='<%=browserSpanValue%>' 
		          browserOnClick='<%=bclick%>' 
		          hasInput="true" isSingle='true' 
		          hasBrowser = "true" onPropertyChange='<%=opchange %>' 
		          isMustInput='1' width="150px"
		          completeUrl='<%="javascript:getajaxurl(" + type + ")"%>' 
		          ></brow:browser>
		         </div>
		          <!-- 
      		<button type=button  class=Browser  onfocus="changelevel('<%=id%>')" onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp')"></button>
		         -->
      		<input type=hidden name="con<%=id%>_value" id="con<%=id%>_value" value="<%=browserValue %>">
      		<input type=hidden name="con<%=id%>_name" id="con<%=id%>_name" value="<%=browserSpanValue %>">
      		<!-- <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"></span>  -->
		</td>
<%}else{
        %>
        <td>
        </td>
        <%
        }%>
</tr>
<tr class="Spacing" style="height: 1px !important;">
	<td class="paddingLeft0Table" colSpan="4"><div class="intervalDivClass"></div></td>
</tr>
 <%
 if(linecolor==0) linecolor=1;
          else linecolor=0;}   %>

</table>
</td>
</tr>
</table>