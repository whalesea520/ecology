<%@page import="org.json.JSONObject"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,java.net.*"%>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="java.util.*,java.sql.Timestamp,weaver.system.code.*" %>
<%@ page import="weaver.formmode.field.FieldComInfo" %>
<%@ page import="weaver.workflow.bean.Track" %>
<%@ page import="weaver.workflow.bean.Trackdetail" %>
<%@ page import="weaver.conn.ConnStatement" %>
<%@ page import="weaver.docs.docs.DocExtUtil" %>
<%@ page import="weaver.workflow.mode.FieldInfo" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.workflow.request.WFPathBrowserUtil" %>
<%@ page import="weaver.docs.share.DocShareUtil" %>
<%@ page import="oracle.sql.CLOB" %>
<%@ page import="java.io.Writer" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="Requestlog" class="weaver.workflow.request.RequestLog" scope="page"/>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rsUploadId" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RequestDoc" class="weaver.workflow.request.RequestDoc" scope="session"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="Doccoder" class="weaver.docs.docs.DocCoder" scope="page"/>
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="page"/>
<jsp:useBean id="DocCheckInOutUtil" class="weaver.docs.docs.DocCheckInOutUtil" scope="page"/>
<jsp:useBean id="sysInfo" class="weaver.system.SystemComInfo" scope="page"/>
<jsp:useBean id="WorkflowBillComInfo" class="weaver.workflow.workflow.WorkflowBillComInfo" scope="page"/>
<jsp:useBean id="Monitor" class="weaver.workflow.monitor.Monitor" scope="page" />
<%
FileUpload fu = new FileUpload(request);
int requestid = Util.getIntValue(fu.getParameter("requestid"),-1);
int isbill = Util.getIntValue(fu.getParameter("isbill"),-1);
int formid = Util.getIntValue(fu.getParameter("formid"),-1);
int billid = Util.getIntValue(fu.getParameter("billid"),-1);
int workflowid = Util.getIntValue(fu.getParameter("workflowid"),-1);
int nodeid = Util.getIntValue(fu.getParameter("nodeid"),-1);


String requestname = Util.null2String(fu.getParameter("requestname"));
int requestlevel =  Util.getIntValue(fu.getParameter("requestlevel"),-1);
int messageType =  Util.getIntValue(fu.getParameter("messageType"),-1);
int chatsType =  Util.getIntValue(fu.getParameter("chatsType"),-1);
rs.execute("update workflow_requestbase set requestname = '"+requestname+"',requestlevel = "+requestlevel+",messageType = "+messageType+",chatsType = "+chatsType+" where requestid = " + requestid);


boolean isRequest = false;
int selectvalue = -1;
boolean executesuccess = false;
String userid = user.getUID() +"";
String iscreate = "0";
String billtablename = "workflow_form";
String hrmids = "";
String crmids = "";
String prjids = "";
String docids = "";
String cptids = "";
char flag = Util.getSeparator();
int usertype = usertype = (user.getLogintype()).equals("1") ? 0 : 1;
int userlanguage = user.getLanguage();
boolean isoracle = rs.getDBType().equals("oracle");

if (isbill == 1) {
	billtablename = WorkflowBillComInfo.getTablename(formid+"");          // 获得单据的主表

}

int docRightByOperator=0;
rs.execute("select docRightByOperator from workflow_base where id="+workflowid);
if(rs.next()){
	docRightByOperator=Util.getIntValue(rs.getString("docRightByOperator"),0);
}

Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
		Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
		Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);

String currenttime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
		Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
		Util.add0(today.get(Calendar.SECOND), 2);

String result = RequestManager.getUpLoadTypeForSelect(workflowid);//当前工作流附件上传类型

String selectedfieldid = result.substring(0,result.indexOf(","));//附件上传目录所选字段id
int uploadType = Integer.valueOf(result.substring(result.indexOf(",")+1)).intValue();//附件上传目录类型

//开始更新请求信息表, 对于表单,为 workflow_form , 对于单据, 为 billtablename 所指定的表
String updateclause = "";
String fieldid = "";
String fieldname = "";
String fielddbtype = "";
String fieldhtmltype = "";
String fieldtype = "";
FieldComInfo fieldComInfo = new FieldComInfo();

boolean isTrack = true;
boolean isStart = true;
Map newMap = new HashMap();
Map oldMap = new HashMap();
Map htmlfieldMap = new HashMap();
Map typemap1 = new HashMap();

String selectvaluesql = "";
//added begin for td4527
if(isbill == 1){
	selectvaluesql = "select * from workflow_billfield where billid="+formid+" order by dsporder";
}else{
	selectvaluesql = "select fieldid,fieldorder,isdetail from workflow_formfield " +
			"where formid="+formid+" and (isdetail<>'1' or isdetail is null) order by fieldid  ";
}
rs.executeSql(selectvaluesql);
while(rs.next()){
	if (isbill == 1) {
		String viewtype = Util.null2String(rs.getString("viewtype"));// 如果是单据的从表字段,不进行操作

		if (viewtype.equals("1")) continue;
		fieldid = Util.null2String(rs.getString("id"));
		fieldhtmltype = Util.null2String(rs.getString("fieldhtmltype"));
	} else {
		fieldid = Util.null2String(rs.getString(1));
		fieldhtmltype = Util.null2String(fieldComInfo.getFieldhtmltype(fieldid));
	}
	if("5".equals(fieldhtmltype)){
		if(selectedfieldid.equals(fieldid)){
			if(isRequest){
				selectvalue = Util.getIntValue(request.getParameter("field" + fieldid), 0);
			}else{
				selectvalue = Util.getIntValue(fu.getParameter("field" + fieldid), 0);
			}
		}
	}
}
//added end.

/*
 * added by cyril on 2008-06-23 for TD:8835
 * 功能:流程修改痕迹
 */
StringBuffer s = new StringBuffer();
String fieldsSql = "";//查询字段名称用的
String billFieldsSql = "";//查询单据字段名称用


		

if(isTrack) {			
	if(!"1".equals(iscreate) && isStart) {
		//取得原有字段
		List fields = Monitor.getFieldsName(isbill,requestid,user.getLanguage(),nodeid,fu);
		if(fields!=null && fields.size()>0){
			//取得原记录

			s = new StringBuffer();
			s.append("select ");
			for(int i=0; i<fields.size(); i++) {
				Track t = (Track) fields.get(i);
				s.append(t.getFieldName());//只取出字段名
				if(i<(fields.size()-1)){
					s.append(",");
				}
			}
			if (isbill == 1) {
				s.append(" from " + billtablename + " where id = " + billid);
			} else {
				s.append(" from workflow_form where requestid="+requestid);
			}
			//System.out.println("sql="+s.toString());
			executesuccess = rs.executeSql(s.toString());
			if (!executesuccess) {
				rs.writeLog(s.toString());
			}
			if(rs.next()) {
				for(int i=0; i<fields.size(); i++) {
					Track t = (Track) fields.get(i);
					t.setFieldOldText(rs.getString(t.getFieldName()));
					oldMap.put(t.getFieldName(), t);
				}
			}
		}
	}
}
/*
 * end by cyril on 2008-06-23 for TD:8835
 */

if (isbill == 1) {
	executesuccess = rs.executeProc("workflow_billfield_Select", formid + "");
} else {
	executesuccess = rs.executeSql("select t2.fieldid,t2.fieldorder,t2.isdetail,t1.fieldlable,t1.langurageid from workflow_fieldlable t1,workflow_formfield t2 where t1.formid=t2.formid and t1.fieldid=t2.fieldid and (t2.isdetail<>'1' or t2.isdetail is null)  and t2.formid="+formid+"  and t1.langurageid="+userlanguage+" order by t2.fieldorder");
}		

while (rs.next()) {
	if (isbill == 1) {
		String viewtype = Util.null2String(rs.getString("viewtype"));   // 如果是单据的从表字段,不进行操作
		if (viewtype.equals("1")) continue;
		fieldid = Util.null2String(rs.getString("id"));
		fieldname = Util.null2String(rs.getString("fieldname"));
		fielddbtype = Util.null2String(rs.getString("fielddbtype"));
		fieldhtmltype = Util.null2String(rs.getString("fieldhtmltype"));
		fieldtype = Util.null2String(rs.getString("type"));
	} else {
		fieldid = Util.null2String(rs.getString(1));
		fieldname = Util.null2String(fieldComInfo.getFieldname(fieldid));
		fielddbtype = Util.null2String(fieldComInfo.getFielddbtype(fieldid));
		fieldhtmltype = Util.null2String(fieldComInfo.getFieldhtmltype(fieldid));
		fieldtype = Util.null2String(fieldComInfo.getFieldType(fieldid));
	}

    if (fieldhtmltype.equals("3") && (fieldtype.equals("1") || fieldtype.equals("17"))) { // 人力资源字段
		String tempvalueid="";
		if(isRequest)
			tempvalueid = Util.null2String(request.getParameter("field" + fieldid));
		else
			tempvalueid = Util.null2String(fu.getParameter("field" + fieldid));
		if (!tempvalueid.equals("")) hrmids += "," + tempvalueid;
		//多人资源特殊处理
		if (fieldtype.equals("17")) {
		    try {
		        WFPathBrowserUtil.updateBrowInfo(fu, requestid, fieldid);
		    } catch (Exception e9) {
		        e9.printStackTrace();
		    }
		}
	} else if (fieldhtmltype.equals("3") && (fieldtype.equals("7") || fieldtype.equals("18"))) {   // 客户字段
		String tempvalueid ="";
		if(isRequest)
			tempvalueid = Util.null2String(request.getParameter("field" + fieldid));
		else
			tempvalueid = Util.null2String(fu.getParameter("field" + fieldid));
		//过滤没有权限的客户
		tempvalueid = resourceAuthorityFilter(fieldhtmltype, fieldtype, tempvalueid,user);
		if (!tempvalueid.equals("")) crmids += "," + tempvalueid;
	} else if (fieldhtmltype.equals("3") && (fieldtype.equals("8")|| fieldtype.equals("135"))) {                             // 项目字段
		String tempvalueid ="";
		if(isRequest)
			tempvalueid = Util.null2String(request.getParameter("field" + fieldid));
		else
			tempvalueid = Util.null2String(fu.getParameter("field" + fieldid));
		//过滤没有权限的项目
		tempvalueid = resourceAuthorityFilter(fieldhtmltype, fieldtype, tempvalueid,user);
		if (!tempvalueid.equals("")) prjids += "," + tempvalueid;
	} else if (fieldhtmltype.equals("3") && (fieldtype.equals("9") || fieldtype.equals("37"))) {  // 文档字段
		String tempvalueid ="";
		if(isRequest)
			tempvalueid = Util.null2String(request.getParameter("field" + fieldid));
		else
			tempvalueid = Util.null2String(fu.getParameter("field" + fieldid));
		//过滤没有权限的文档
		tempvalueid = resourceAuthorityFilter(fieldhtmltype, fieldtype, tempvalueid,user);
		if (!tempvalueid.equals("")) docids += "," + tempvalueid;
		//跟随文档关联人赋权
		if(docRightByOperator==1){
			//在Workflow_DocSource表中删除当前字段被删除的文档
			if (!tempvalueid.equals(""))
			{
			rs1.execute("delete from Workflow_DocSource where requestid =" + requestid + " and fieldid =" + fieldid + " and docid not in (" + tempvalueid + ")");
			}
			else
			{
			rs1.execute("delete from Workflow_DocSource where requestid =" + requestid + " and fieldid =" + fieldid);
			}
			//在Workflow_DocSource表中添加当前字段新增加的文档
			String[] mdocid=Util.TokenizerString2(tempvalueid,",");
			for(int i=0;i<mdocid.length; i++){
				if(mdocid[i]!=null && !mdocid[i].equals("")){
					rs1.executeProc("Workflow_DocSource_Insert",""+requestid + flag + nodeid + flag + fieldid + flag + mdocid[i] + flag + userid + flag + "1");//由于usertype不一致，这里的usertype直接指定为1，只处理内部用户
				}
			}
		}
	} else if (fieldhtmltype.equals("3") && fieldtype.equals("23")) {                           // 资产字段
		String tempvalueid ="";
		if(isRequest)
			tempvalueid = Util.null2String(request.getParameter("field" + fieldid));
		else
			tempvalueid = Util.null2String(fu.getParameter("field" + fieldid));
		//过滤没有权限的资产
		tempvalueid = resourceAuthorityFilter(fieldhtmltype, fieldtype, tempvalueid,user);
		if (!tempvalueid.equals("")) cptids += "," + tempvalueid;
	}
	if (isoracle) {
		if ((fielddbtype.toUpperCase()).indexOf("INT") >= 0&&!"224".equals(fieldtype)&&!"225".equals(fieldtype))
			
		/*------modified by xwj for td3297 20051130 --- begin --*/
			           
						if("5".equals(fieldhtmltype)){
						if(isRequest){
							 if (!(Util.null2String(request.getParameter("field" + fieldid))).equals("")) {
								 if(null == newMap.get(fieldname))
									 updateclause += fieldname + " = " + Util.getIntValue(request.getParameter("field" + fieldid), -1) + ",";
								 newMap.put(fieldname, String.valueOf(Util.getIntValue(request.getParameter("field" + fieldid), -1)));//填入Map中,用于比较 by cyril
							 }
                             else {
                            	 if(null == newMap.get(fieldname))
                            		 updateclause += fieldname + " = NULL,";
                            	 newMap.put(fieldname, null);//填入Map中,用于比较 by cyril
                             }
                        }else{
							 if (!(Util.null2String(fu.getParameter("field" + fieldid))).equals("")) {
								 if(null == newMap.get(fieldname))
									 updateclause += fieldname + " = " + Util.getIntValue(fu.getParameter("field" + fieldid), -1) + ",";
								 newMap.put(fieldname, String.valueOf(Util.getIntValue(fu.getParameter("field" + fieldid), -1)));//填入Map中,用于比较 by cyril
							 }
                             else {
                            	 if(null == newMap.get(fieldname))
                            		 updateclause += fieldname + " = NULL,";
                            	 newMap.put(fieldname, null);//填入Map中,用于比较 by cyril
                             }
                        }
						}
						else{
							if(isRequest){
							  //权限过滤
	                            String tempvalueid = resourceAuthorityFilter(fieldhtmltype, fieldtype, Util.null2String(request.getParameter("field" + fieldid)),user);
								 if (!(Util.null2String(tempvalueid)).equals("")) {
									 if(null == newMap.get(fieldname))
										 updateclause += fieldname + " = " + Util.getIntValue(tempvalueid, 0) + ",";
									 newMap.put(fieldname, String.valueOf(Util.getIntValue(tempvalueid, 0)));//填入Map中,用于比较 by cyril
								 }
                                 else {
                                	 if(null == newMap.get(fieldname))
                                		 updateclause += fieldname + " = NULL,";
                                	 newMap.put(fieldname, null);//填入Map中,用于比较 by cyril
                                 }
                            }else{
                                String tempvalueid = resourceAuthorityFilter(fieldhtmltype, fieldtype, Util.null2String(fu.getParameter("field" + fieldid)),user);
								 if (!(Util.null2String(tempvalueid)).equals("")) {
									 if(null == newMap.get(fieldname))
										 updateclause += fieldname + " = " + Util.getIntValue(tempvalueid, 0) + ",";
									 newMap.put(fieldname, String.valueOf(Util.getIntValue(tempvalueid, 0)));//填入Map中,用于比较 by cyril
								 }
                                 else {
                                	 if(null == newMap.get(fieldname))
                                		 updateclause += fieldname + " = NULL,";
                                	 newMap.put(fieldname, null);//填入Map中,用于比较 by cyril
                                 }
                            }

						}
					/*------modified by xwj for td3297 20051130 --- end  --*/
		else if (((fielddbtype.toUpperCase()).indexOf("NUMBER") >= 0||(fielddbtype.toUpperCase()).indexOf("FLOAT") >= 0)&&!"224".equals(fieldtype)&&!"225".equals(fieldtype)){
			int digitsIndex = fielddbtype.indexOf(",");
			int decimaldigits = 2;
        	if(digitsIndex > -1){
        		decimaldigits = Util.getIntValue(fielddbtype.substring(digitsIndex+1, fielddbtype.length()-1).trim(), 2);
        	}else{
        		decimaldigits = 2;
        	}
			if(isRequest){
				 if (!(Util.null2String(request.getParameter("field" + fieldid))).equals("")) {
					 if(null == newMap.get(fieldname))
						 updateclause += fieldname + " = " + Util.getPointValue2(request.getParameter("field" + fieldid),decimaldigits) + ",";
					 newMap.put(fieldname, Util.getPointValue2(request.getParameter("field" + fieldid),decimaldigits));//填入Map中,用于比较 by cyril
				 }
                 else {
                	 if(null == newMap.get(fieldname))
                		 updateclause += fieldname + " = NULL,";
                	 newMap.put(fieldname, null);//填入Map中,用于比较 by cyril
                 }
            }
				else {
					if (!(Util.null2String(fu.getParameter("field" + fieldid))).equals("")) {
						if(null == newMap.get(fieldname))
							updateclause += fieldname + " = " + Util.getPointValue2(fu.getParameter("field" + fieldid),decimaldigits) + ",";
						newMap.put(fieldname, Util.getPointValue2(fu.getParameter("field" + fieldid),decimaldigits));//填入Map中,用于比较 by cyril
					}
                    else {
                    	if(null == newMap.get(fieldname))
                    		updateclause += fieldname + " = NULL,";
                        newMap.put(fieldname, null);//填入Map中,用于比较 by cyril
                    }
				}
	}else if(fieldhtmltype.equals("3") && "17".equals(fieldtype)){
		if(isRequest){
			if(null == newMap.get(fieldname))
				updateclause += fieldname + " = '' ,";
			//newMap.put(fieldname, "empty_clob()");//填入Map中,用于比较 by cyril
			typemap1.put(fieldname, Util.null2String(request.getParameter("field" + fieldid)));//填入Map中,用于比较 by cyril
       }else {
    	    if(null == newMap.get(fieldname))
    		   updateclause += fieldname + " = '' ,";
			//newMap.put(fieldname, "empty_clob()");//填入Map中,用于比较 by cyril
			typemap1.put(fieldname, Util.null2String(fu.getParameter("field" + fieldid)));//填入Map中,用于比较 by cyril
		}
	}else if(fieldhtmltype.equals("6")){
			//add by xhheng @20050315 for 附件上传
			String tempvalue="";

			//处理附件
			if(isRequest)
				tempvalue=Util.null2String(request.getParameter("field" + fieldid));
			else
				tempvalue=Util.null2String(fu.getParameter("field" + fieldid));

	DocExtUtil docExtUtil = new DocExtUtil();
	String[] oldUploadIdsStrs = null;
	String oldUploadIdsStrs_ = "";
	if (isbill == 1) {
		rsUploadId.executeSql("select "+fieldname+" from "+ billtablename +" where requestid = " + requestid);
	}else{
		rsUploadId.executeSql("select "+fieldname+" from workflow_form where requestid = " + requestid);
	}
	if(rsUploadId.next()){
		oldUploadIdsStrs_ = rsUploadId.getString(fieldname);
	}
	if(oldUploadIdsStrs_ != null && !"".equals(oldUploadIdsStrs_)){
	oldUploadIdsStrs = Util.TokenizerString2(oldUploadIdsStrs_, ",");
	}
	if(!tempvalue.equals("")){
		if(null == newMap.get(fieldname))
			updateclause += fieldname + " = '" + fillFullNull(tempvalue) + "',";
		newMap.put(fieldname, tempvalue);//填入Map中,用于比较 by cyril
	}

	else if(tempvalue.equals("")){
		if(null == newMap.get(fieldname))
			updateclause += fieldname + " = '',";
		newMap.put(fieldname, null);//填入Map中,用于比较 by cyril
	}
	else{
	}
	if(oldUploadIdsStrs != null){
	for( int y =0; y < oldUploadIdsStrs.length; y++){
		if(tempvalue.indexOf(oldUploadIdsStrs[y]) == -1){
			//if( Util.getIntValue(oldUploadIdsStrs[y],0) != 0 )
			//docExtUtil.deleteDoc(Integer.parseInt(oldUploadIdsStrs[y]));
			if( Util.getIntValue(oldUploadIdsStrs[y],0) != 0 ){
				String clientIp = "";
				if(isRequest){
					if (request != null)
						clientIp = Util.null2String(request.getRemoteAddr());
				}else{
					if (fu != null)
						clientIp = Util.null2String(fu.getRemoteAddr());
				}						
				docExtUtil.deleteDoc(Integer.parseInt(oldUploadIdsStrs[y]),user,clientIp);							
			}					
		}
	}
	}
	/* ----- added by xwj for td1949 end ------*/

		}else{
			//modify by xhheng @ 20041229 for TD 1495
			//以"是否是用户输入"作为是否作html转换的标准，故当为系统默认提醒流程时，不做html转换
			boolean ishtml = false;
			String thetempvalue ="";
			if(workflowid==1){
				if(isRequest){
					//thetempvalue = Util.toScreen(request.getParameter("field" + fieldid), userlanguage);
					thetempvalue = Util.toHtml100(request.getParameter("field" + fieldid));							
				}else{
					//thetempvalue = Util.toScreen(fu.getParameter("field" + fieldid), userlanguage);
					thetempvalue = Util.toHtml100(fu.getParameter("field" + fieldid));							
				}
			}else{
				if(fieldhtmltype.equals("3")&&(fieldtype.equals("161") || fieldtype.equals("162"))){
					if (isRequest){
                       thetempvalue = Util.null2String(request.getParameter("field" + fieldid));
                   }else{
                       thetempvalue = Util.null2String(fu.getParameter("field" + fieldid));
				   }
                   thetempvalue = thetempvalue.trim();
				} else if(fieldhtmltype.equals("3")&&(fieldtype.equals("224") || fieldtype.equals("225")|| fieldtype.equals("226")|| fieldtype.equals("227"))){
						//获取流程主表单的数据，并且插入到主表单
					   if (isRequest){
                           thetempvalue = Util.null2String(request.getParameter("field" + fieldid));
                       }else{
                           thetempvalue = Util.null2String(fu.getParameter("field" + fieldid));
					   }
                       thetempvalue = thetempvalue.trim();
                       //System.out.println("总算可以了"+thetempvalue);
				} else{
				if(isRequest) {
					//thetempvalue = Util.StringReplace(Util.toHtml10(request.getParameter("field" + fieldid))," ","&nbsp;");
					//thetempvalue = Util.toHtmlForWorkflow(request.getParameter("field" + fieldid));							
				 if (fieldhtmltype.equals("2")&&fieldtype.equals("2"))
				   {
					thetempvalue = Util.toHtml100(request.getParameter("field" + fieldid));
					ishtml = true;
				   }else if(fieldhtmltype.equals("1")&&fieldtype.equals("1")){
					   thetempvalue = Util.toHtmlForWorkflow(request.getParameter("field" + fieldid));
				   }else{
					   thetempvalue = Util.StringReplace(Util.toHtml10(request.getParameter("field" + fieldid))," ","&nbsp;");
				   }
					}
				else
				{
					//thetempvalue = Util.StringReplace(Util.toHtml10(fu.getParameter("field" + fieldid))," ","&nbsp;");
					//thetempvalue = Util.toHtmlForWorkflow(fu.getParameter("field" + fieldid));							
				 if (fieldhtmltype.equals("2")&&fieldtype.equals("2"))
				   {
					thetempvalue = Util.toHtml100(fu.getParameter("field" + fieldid));
					ishtml = true;
				   }else if(fieldhtmltype.equals("1")&&fieldtype.equals("1")){
					   thetempvalue = Util.toHtmlForWorkflow(Util.htmlFilter4UTF8(fu.getParameter("field" + fieldid)));
				   }else{
					   thetempvalue = Util.StringReplace(Util.toHtml10(Util.htmlFilter4UTF8(fu.getParameter("field" + fieldid)))," ","&nbsp;");
				   }
				}
				}
			}
			//1：文档， 2：客户， 3：项目， 4：资产 权限过滤
            thetempvalue = resourceAuthorityFilter(fieldhtmltype, fieldtype, thetempvalue,user);
			if (thetempvalue.equals("")) thetempvalue = " ";
			//判断如果是HTML类型，单独处理
			if(ishtml) {
				htmlfieldMap.put(fieldname, thetempvalue);
			}
			else
			updateclause += fieldname + " = '" + fillFullNull(thetempvalue) + "',";
			newMap.put(fieldname, thetempvalue);//填入Map中,用于比较 by cyril
		}
	} 
    else
    // 非ORACLE数据库
    {
		if ((fielddbtype.toUpperCase()).indexOf("INT") >= 0&&!"224".equals(fieldtype)&&!"225".equals(fieldtype))//lu_Z_OSAP_INFORECORD_MAINTAIN_MAS
		/*------modified by xwj for td3297 20051130 --- begin --*/
		{
		    if("5".equals(fieldhtmltype))
            {
		        if(isRequest)
                {
                    if (!"".equals(request.getParameter("field" + fieldid)))
                    {
                    	if(null == newMap.get(fieldname))
                    		updateclause += fieldname + " = " + Util.getIntValue(request.getParameter("field" + fieldid), -1) + ",";
                        newMap.put(fieldname, String.valueOf(Util.getIntValue(request.getParameter("field" + fieldid), -1)));//填入Map中,用于比较 by cyril
                
                    }
                    else
                    {
                    	if(null == newMap.get(fieldname))
                    		updateclause += fieldname + " = NULL,";
                        newMap.put(fieldname, null);//填入Map中,用于比较 by cyril
                    }
                }
                else
                {
                    if (!"".equals(fu.getParameter("field" + fieldid)))
                    {
                    	if(null == newMap.get(fieldname))
                    		updateclause += fieldname + " = " + Util.getIntValue(fu.getParameter("field" + fieldid), -1) + ",";
                        newMap.put(fieldname, String.valueOf(Util.getIntValue(fu.getParameter("field" + fieldid), -1)));//填入Map中,用于比较 by cyril
                    }
                    else
                    {
                    	if(null == newMap.get(fieldname))
                    		updateclause += fieldname + " = NULL,";
                        newMap.put(fieldname, null);//填入Map中,用于比较 by cyril
                    }
                }   
            }
		    else
            {
		        
		        if(isRequest)
                {
		            //权限过滤
                    String tempvalueid = resourceAuthorityFilter(fieldhtmltype, fieldtype, Util.null2String(request.getParameter("field" + fieldid)),user);
                    if (!"".equals(tempvalueid))
                    {  
                    	if(null == newMap.get(fieldname))
                    		updateclause += fieldname + " = " + Util.getIntValue(tempvalueid, 0) + ",";
                        newMap.put(fieldname, String.valueOf(Util.getIntValue(tempvalueid, 0)));//填入Map中,用于比较 by cyril
                    }
                    else
                    {
                    	if(null == newMap.get(fieldname))
                    		updateclause += fieldname + " = NULL,";
                        newMap.put(fieldname, null);//填入Map中,用于比较 by cyril
                    }
                }
                else
                {
                  //权限过滤
                    String tempvalueid = resourceAuthorityFilter(fieldhtmltype, fieldtype, Util.null2String(fu.getParameter("field" + fieldid)),user);
                    if (!"".equals(tempvalueid))
                    {
                    	if(null == newMap.get(fieldname))
                    		updateclause += fieldname + " = " + Util.getIntValue(tempvalueid, 0) + ",";
                        newMap.put(fieldname, String.valueOf(Util.getIntValue(tempvalueid, 0)));//填入Map中,用于比较 by cyril
                    }
                    else
                    {
                    	if(null == newMap.get(fieldname))
                    		updateclause += fieldname + " = NULL,";
                        newMap.put(fieldname, null);//填入Map中,用于比较 by cyril
                    }
                }
            }
		}
        
		/*------modified by xwj for td3297 20051130 --- end --*/
		else if (((fielddbtype.toUpperCase()).indexOf("DECIMAL") >= 0||(fielddbtype.toUpperCase()).indexOf("FLOAT") >= 0)&&!"224".equals(fieldtype)&&!"225".equals(fieldtype))
        {
			int digitsIndex = fielddbtype.indexOf(",");
			int decimaldigits = 2;
        	if(digitsIndex > -1){
        		decimaldigits = Util.getIntValue(fielddbtype.substring(digitsIndex+1, fielddbtype.length()-1).trim(), 2);
        	}else{
        		decimaldigits = 2;
        	}
			if(isRequest)
            {
                if (!"".equals(request.getParameter("field" + fieldid)))
                {
                	if(null == newMap.get(fieldname))
                		updateclause += fieldname + " = " + Util.getPointValue2(request.getParameter("field" + fieldid),decimaldigits) + ",";
                    newMap.put(fieldname, Util.getPointValue2(request.getParameter("field" + fieldid),decimaldigits));//填入Map中,用于比较 by cyril
                }
                else
                {
                	if(null == newMap.get(fieldname))
                		updateclause += fieldname + " = NULL,";
                    newMap.put(fieldname, null);//填入Map中,用于比较 by cyril
                }
            }
            else
            {
                if (!"".equals(fu.getParameter("field" + fieldid)))
                {
                	if(null == newMap.get(fieldname))
                		updateclause += fieldname + " = " + Util.getPointValue2(fu.getParameter("field" + fieldid),decimaldigits) + ",";
                    newMap.put(fieldname, Util.getPointValue2(fu.getParameter("field" + fieldid),decimaldigits));//填入Map中,用于比较 by cyril
                }
                else
                {
                	if(null == newMap.get(fieldname))
                		updateclause += fieldname + " = NULL,";
                    newMap.put(fieldname, null);//填入Map中,用于比较 by cyril
                }
            }
        }
        
        else if(fieldhtmltype.equals("6")){
			//add by xhheng @20050315 for 附件上传
			String tempvalue="";

			//处理附件
			if(isRequest)
				tempvalue=Util.null2String(request.getParameter("field" + fieldid));
			else
				tempvalue=Util.null2String(fu.getParameter("field" + fieldid));
			//由RequestAddShareInfo统一处理附件上传字段的共享

            /* ----- added by xwj for td1949 begin ------*/
			String[] oldUploadIdsStrs = null;
			DocExtUtil docExtUtil = new DocExtUtil();
			String oldUploadIdsStrs_ = "";
			if (isbill == 1) {
				rsUploadId.executeSql("select "+fieldname+" from "+ billtablename +" where requestid = " + requestid);
			}else{
				rsUploadId.executeSql("select "+fieldname+" from workflow_form where requestid = " + requestid);
			}
			if(rsUploadId.next()){
				oldUploadIdsStrs_ = rsUploadId.getString(fieldname);
			}
			if(oldUploadIdsStrs_ != null && !"".equals(oldUploadIdsStrs_)){
			oldUploadIdsStrs = Util.TokenizerString2(oldUploadIdsStrs_, ",");
			}
			if(!tempvalue.equals("")){
				if(null == newMap.get(fieldname))
					updateclause += fieldname + " = '" + tempvalue + "',";
				newMap.put(fieldname, tempvalue);//填入Map中,用于比较 by cyril
			}

			else if(tempvalue.equals("")){
				if(null == newMap.get(fieldname))
					updateclause += fieldname + " = '',";
				newMap.put(fieldname, "");//填入Map中,用于比较 by cyril
			}
			else{
			}
			if(oldUploadIdsStrs != null){
			for( int y =0; y < oldUploadIdsStrs.length; y++){
				if(tempvalue.indexOf(oldUploadIdsStrs[y]) == -1){
					//if( Util.getIntValue(oldUploadIdsStrs[y],0) != 0 )
					//docExtUtil.deleteDoc(Integer.parseInt(oldUploadIdsStrs[y]));
					if( Util.getIntValue(oldUploadIdsStrs[y],0) != 0 ){
						String clientIp = "";
						if(isRequest){
							if (request != null)
								clientIp = Util.null2String(request.getRemoteAddr());
						}else{
							if (fu != null)
								clientIp = Util.null2String(fu.getRemoteAddr());
						}								
						docExtUtil.deleteDoc(Integer.parseInt(oldUploadIdsStrs[y]),user,clientIp);								
					}							
				}
			}
			}
			/* ----- added by xwj for td1949 end ------*/

		}else{
			//modify by xhheng @ 20041229 for TD 1495
			boolean ishtml = false;
			String thetempvalue ="";
			if(workflowid==1){
				if(isRequest){
					//thetempvalue = Util.toScreen(request.getParameter("field" + fieldid), userlanguage);
					thetempvalue = Util.toHtml100(request.getParameter("field" + fieldid));							
				}else{
					//thetempvalue = Util.toScreen(fu.getParameter("field" + fieldid), userlanguage);
					thetempvalue = Util.toHtml100(fu.getParameter("field" + fieldid));							
				}
			}else{
				if(isRequest)
				{
					//thetempvalue = Util.StringReplace(Util.fromScreen2(request.getParameter("field" + fieldid), userlanguage)," ","&nbsp;");
					//thetempvalue = Util.toHtmlForWorkflow(request.getParameter("field" + fieldid));
				   if (fieldhtmltype.equals("2")&&fieldtype.equals("2"))
				   {
						thetempvalue = Util.toHtml100(request.getParameter("field" + fieldid));
						ishtml = true;
				   }else if(fieldhtmltype.equals("3")&&(fieldtype.equals("224")||fieldtype.equals("225")||fieldtype.equals("226")||fieldtype.equals("227"))){
					   thetempvalue = Util.null2String(request.getParameter("field" + fieldid));//防止空格转成&nbsp
				   }
				   else if(fieldhtmltype.equals("1")&&fieldtype.equals("1")){
					   thetempvalue = Util.toHtmlForWorkflow(request.getParameter("field" + fieldid));
				   }else{
					   thetempvalue = Util.StringReplace(Util.fromScreen2(request.getParameter("field" + fieldid), userlanguage)," ","&nbsp;");
				   }
				}
				else
				{
					//thetempvalue = Util.StringReplace(Util.fromScreen2(fu.getParameter("field" + fieldid), userlanguage)," ","&nbsp;");
					//thetempvalue = Util.toHtmlForWorkflow(fu.getParameter("field" + fieldid));
				 if (fieldhtmltype.equals("2")&&fieldtype.equals("2"))
				   {
					thetempvalue = Util.toHtml100(fu.getParameter("field" + fieldid));
					ishtml = true;
				   }else if(fieldhtmltype.equals("3")&&(fieldtype.equals("224")||fieldtype.equals("225")||fieldtype.equals("226")||fieldtype.equals("227"))){
					   thetempvalue = Util.null2String(fu.getParameter("field" + fieldid));//防止空格转成&nbsp
				   }
				   else if(fieldhtmltype.equals("1")&&fieldtype.equals("1")){
					   thetempvalue = Util.toHtmlForWorkflow(Util.htmlFilter4UTF8(fu.getParameter("field" + fieldid)));
				   }else{
					   thetempvalue = Util.StringReplace(Util.fromScreen2(Util.htmlFilter4UTF8(fu.getParameter("field" + fieldid)), userlanguage)," ","&nbsp;");
				   }
				}
			}
			
			//1：文档， 2：客户， 3：项目， 4：资产 权限过滤
            thetempvalue = resourceAuthorityFilter(fieldhtmltype, fieldtype, thetempvalue,user);
			if (thetempvalue.equals("")) thetempvalue = " ";
			//判断如果是HTML类型，单独处理
			if(ishtml) {
				htmlfieldMap.put(fieldname, thetempvalue);
			}else{
				if(null == newMap.get(fieldname))
					updateclause += fieldname + " = '" + thetempvalue + "',";
				newMap.put(fieldname, thetempvalue);//填入Map中,用于比较 by cyril
			}
		}
	}
}

/*
 * added by cyril on 2008-06-23 for TD:8835
 * 功能:修改痕迹功能
 */
//获取当前修改时间 
String nowtime = currentdate+" "+currenttime;
//System.out.println("iscreate="+iscreate+" isStart="+isStart+" isTrack="+isTrack);
if(!"1".equals(iscreate) && isStart && isTrack) {
	List cprList = new ArrayList();
	Iterator it;
	
	
	//遍历新的map
	it = newMap.entrySet().iterator();
	while(it.hasNext()) {
		Map.Entry entry = (Map.Entry) it.next();
		String key = entry.getKey().toString();
		String value = "";
		if(entry.getValue()!=null) {
			if(String.valueOf(entry.getValue()).equals(" ")) value = "";
			else value = String.valueOf(entry.getValue());
		}
		Track t = (Track) oldMap.get(key);
		if((t==null && value!=null)
				|| (t!=null && !t.getFieldOldText().equals(value))
				) {
			if(t==null) {
				//新增字段的处理

				s = new StringBuffer();
				t = new Track();
				if (isbill == 1) {
					s.append("select t2.id, t2.fieldname, t2.fielddbtype, t2.fieldhtmltype, t2.type, t2.fieldlabel ");
					s.append("from  workflow_bill t1, workflow_billfield t2, workflow_form t3 ");
					s.append("where t1.id=t3.billformid and t2.billid = t1.id ");
					s.append("and t2.viewtype=0 and t3.requestid ="+requestid);
					s.append(" and t2.fieldname='"+key+"'");
				} else {
					s.append("select t1.id, t1.fieldname, t1.fielddbtype, t1.fieldhtmltype, t1.type,");
					s.append("(select fieldlable from workflow_fieldlable t where t.langurageid = 7 and t.fieldid = t2.fieldid and t.formid = t2.formid) fieldNameCn,");
					s.append("(select fieldlable from workflow_fieldlable t where t.langurageid = 8 and t.fieldid = t2.fieldid and t.formid = t2.formid) fieldNameEn, ");
					s.append("(select fieldlable from workflow_fieldlable t where t.langurageid = 9 and t.fieldid = t2.fieldid and t.formid = t2.formid) fieldNameTw ");
					s.append("from workflow_formdict t1, workflow_formfield t2, workflow_form t3,workflow_fieldlable t4 ");
					s.append("where t1.id=t2.fieldid and t2.formid=t3.billformid and t4.langurageid = "+userlanguage+" and t4.fieldid = t2.fieldid and t4.formid = t2.formid and t3.requestid =" + requestid);
					s.append(" and t1.fieldname='"+key+"'");
				}
				//System.out.println(isbill+"===="+s.toString());
				executesuccess = rs.executeSql(s.toString());
				if (!executesuccess) {
					rs.writeLog(s.toString());
				}
				t.setFieldName(rs.getString("fieldname"));		/*存字段名称*/
				t.setFieldType(rs.getString("type"));		/*存浏览按钮对应位置*/
				t.setFieldHtmlType(rs.getString("fieldhtmltype"));	/*存浏览按钮类型*/
				t.setFieldId(rs.getInt("id"));				/*将ID也取得*/
				//如果是表单则填以下二项

				if(isbill!=1) {
					t.setFieldNameCn(rs.getString("fieldNameCn"));	/*取字段名称*/
					t.setFieldNameEn(rs.getString("fieldNameEn"));	/*取字段名称*/
					t.setFieldNameTw(rs.getString("fieldNameTw"));	/*取字段名称*/
				}
				t.setNodeId(nodeid);	/*节点ID*/
				t.setRequestId(requestid);	/*请求ID*/
				t.setIsBill(isbill);	/*是否为表单*/
				//如果是单据则填LEABLE
				if(isbill==1)
					t.setFieldLableId(rs.getInt("fieldlabel"));/*单据对应的LEABLE*/
				t.setModifierIP(Monitor.getIp(fu));	/*IP地址*/
				t.setOptKind("monitor");	/*日志操作类型*/
			}
			t.setFieldNewText(String.valueOf(value));
			cprList.add(t);
		}
	}
	//记录修改日志
	for(int i=0; i<cprList.size(); i++) {
		Track t = (Track) cprList.get(i);
		//System.out.println(t.getFieldName()+":\""+t.getFieldOldText()+"\"<==>\""+t.getFieldNewText()+"\"");
		if(t!=null) {
			//如果是浮点数，只是后面小数位数发生了变化，那么在这里不记录到数据库中
			String tempfiledtype = Util.null2String(t.getFieldType());
			String tempfieldhtmltype = Util.null2String(t.getFieldHtmlType());
			String FieldOldText = Util.null2String(t.getFieldOldText());
			String FieldNewText = Util.null2String(t.getFieldNewText());
			if(!FieldOldText.equals("")&&!FieldNewText.equals("")&&tempfieldhtmltype.equals("1")&&(tempfiledtype.equals("3")||tempfiledtype.equals("4")||tempfiledtype.equals("5"))){
				if(Util.getDoubleValue(FieldOldText)==Util.getDoubleValue(FieldNewText)){
					continue;
				}
			}
			s = new StringBuffer();
			 //src.equals("save") 保存的痕迹,其他为流程修改的痕迹
			s.append("insert into workflow_track (");
			s.append("optKind,requestId,nodeId,isBill,fieldLableId,");
			s.append("fieldId,fieldHtmlType,fieldType,fieldNameCn,fieldNameEn,fieldNameTw,fieldOldText,fieldNewText,");
			s.append("modifierType,agentId,modifierId,modifierIP,modifyTime");
			s.append(") values (");
			s.append(RequestManager.disposeSqlNull(t.getOptKind())+",");
			s.append(t.getRequestId()+",");
			s.append(t.getNodeId()+",");
			s.append(t.getIsBill()+",");
			s.append(t.getFieldLableId()+",");
			s.append(t.getFieldId()+",");
			s.append(RequestManager.disposeSqlNull(t.getFieldHtmlType())+",");
			s.append(RequestManager.disposeSqlNull(t.getFieldType())+",");
			s.append(RequestManager.disposeSqlNull(t.getFieldNameCn())+",");
			s.append(RequestManager.disposeSqlNull(t.getFieldNameEn())+",");
			s.append(RequestManager.disposeSqlNull(t.getFieldNameTw())+",");
			s.append(RequestManager.disposeSqlNull(Util.null2String(t.getFieldOldText()))+",");
			s.append(RequestManager.disposeSqlNull(Util.null2String(t.getFieldNewText()))+",");
			s.append(usertype+",");
			s.append("-1,");
			s.append(userid+",");
			s.append(RequestManager.disposeSqlNull(t.getModifierIP())+",");
			s.append(RequestManager.disposeSqlNull(nowtime));
			s.append(")");
			//System.out.println("insert master sql="+s.toString());
			executesuccess = rs.executeSql(s.toString());
			if (!executesuccess) {
				rs.writeLog(s.toString());
			}
		}
	}
}
/*
 * end by cyril on 2008-06-23 for TD:8835
 */

//System.out.println(updateclause);
if (!updateclause.equals("")) {
	updateclause = updateclause.substring(0, updateclause.length() - 1);
	if (isbill == 1) {
		updateclause = " update " + billtablename + " set " + updateclause + " where id = " + billid;
	} else {
		updateclause = "update workflow_form set " + updateclause + " where requestid=" + requestid;
	}
	
	executesuccess = rs.executeSql(updateclause);
	
	if(isoracle){
		try {
			String hrmsql = "";
			if (isbill == 1) {
				hrmsql = " update "+billtablename+" set";
			} else {
				hrmsql = "update workflow_form set ";
			}
			int hrmindex = 0;
			String hrmsp = " ";
			Iterator fdit = typemap1.entrySet().iterator();
			while(fdit.hasNext()) {
				hrmindex++;
				Map.Entry entry = (Map.Entry) fdit.next();
				String key = entry.getKey().toString();
				String value = "";
				if(entry.getValue()!=null) {
					if(String.valueOf(entry.getValue()).equals(" ")) value = "";
					else value = String.valueOf(entry.getValue());
				}
				if(hrmindex >1){
					hrmsql += hrmsp+" , "+key + "=? ";
				}else{
					hrmsql += hrmsp+" "+key + "=? ";
				}
			}
			if (isbill == 1) {
				hrmsql += " where id = " + billid ;
			} else {
				hrmsql += " where requestid=" + requestid;
			}
			
			//System.out.println("hrmsql = "+hrmsql);
			if(hrmindex>0) {
				ConnStatement hrmstatement = null;
				try {
					hrmstatement = new ConnStatement();
					hrmstatement.setStatementSql(hrmsql);
					fdit = typemap1.entrySet().iterator();
					hrmindex = 0;
					while(fdit.hasNext()) {
						hrmindex++;
						Map.Entry entry = (Map.Entry) fdit.next();
						String key = entry.getKey().toString();
						String value = "";
						if(entry.getValue()!=null) {
							if(String.valueOf(entry.getValue()).equals(" ")) value = "";
							else value = String.valueOf(entry.getValue());
						}
						hrmstatement.setString(hrmindex, value);
					}
					hrmstatement.executeUpdate();
				} catch (Exception e) {
				} finally {
					if(hrmstatement!=null) hrmstatement.close();
				}
			}
		}catch(Exception e){
		}
	//
	/******/
	}
}

//add by alan for 15769
try {
	String fdsql = "";
	if (isbill == 1) {
		fdsql = " update " + billtablename + " set ";
	} else {
		fdsql = "update workflow_form set ";;
	}
	int fdcn = 0;
	String fdsp = "";
	Iterator fdit = htmlfieldMap.entrySet().iterator();
	while(fdit.hasNext()) {
		fdcn++;
		Map.Entry entry = (Map.Entry) fdit.next();
		String key = entry.getKey().toString();
		String value = "";
		if(entry.getValue()!=null) {
			if(String.valueOf(entry.getValue()).equals(" ")) value = "";
			else value = String.valueOf(entry.getValue());
		}
		fdsql += fdsp+" "+key+"=? ";
		fdsp = ",";
	}
	if (isbill == 1) {
		fdsql += " where id = " + billid;
	} else {
		fdsql += " where requestid=" + requestid;
	}
	if(fdcn>0) {
		ConnStatement fdst = null;
		try {
			fdst = new ConnStatement();
			fdst.setStatementSql(fdsql);
			fdit = htmlfieldMap.entrySet().iterator();
			fdcn = 0;
			while(fdit.hasNext()) {
				fdcn++;
				Map.Entry entry = (Map.Entry) fdit.next();
				String key = entry.getKey().toString();
				String value = "";
				if(entry.getValue()!=null) {
					if(String.valueOf(entry.getValue()).equals(" ")) value = "";
					else value = String.valueOf(entry.getValue());
				}
				fdst.setString(fdcn, value);
			}
			fdst.executeUpdate();
		} catch (Exception e) {
			rs.writeLog(e);
		} finally {
			if(fdst!=null) fdst.close();
		}
	}
}catch(Exception e){
	rs.writeLog(e);
}


			//处理明细表

			//重新定义二个MAP
			newMap = new HashMap();
			oldMap = new HashMap();
			Map dtMap = new HashMap();
			List fields = new ArrayList();
			String docrowindex = "";
			FieldInfo fieldinfo = new FieldInfo();
			int temprowindex = 0;
			String isMultiDoc = "";
			int sn = 0;
			try {
				//System.out.println(isbill);
				if(isbill==1){	//单据
                    fieldinfo.setRequestid(requestid);
                    fieldinfo.GetDetailTableField(formid,isbill,userlanguage);
                    ArrayList detailfieldids=fieldinfo.getDetailTableFields();
                    ArrayList detailfieldnames=fieldinfo.getDetailDBFieldNames();
                    ArrayList detaildbtypes=fieldinfo.getDetailFieldDBTypes();
                    ArrayList detailtables=fieldinfo.getDetailTableNames();
                    ArrayList detailkeys=fieldinfo.getDetailTableKeys();
                    boolean isexpbill = false; //特定图形化单据

                    for(int i=0;i<detailfieldids.size();i++){
                        ArrayList fieldids=(ArrayList)detailfieldids.get(i);
                        ArrayList fieldnames=(ArrayList)detailfieldnames.get(i);
                        ArrayList fielddbtypes=(ArrayList)detaildbtypes.get(i);
                        String detailtable=(String)detailtables.get(i);
                        String detailkey=(String)detailkeys.get(i);

                        /**
                         * added by cyril on 2008-06-25
                         * 功能:取得明细字段
                         */
                        if (isStart && isTrack) {
                            for (int l = 0; l < fieldids.size(); l++) {
                                ArrayList dtlfieldids = Util.TokenizerString((String) fieldids.get(l), "_");
                                Trackdetail td = new Trackdetail();
                                td.setFieldName((String) fieldnames.get(l));        /*存字段名称*/
                                td.setFieldType((String) dtlfieldids.get(2));        /*存浏览按钮对应位置*/
                                td.setFieldHtmlType((String) dtlfieldids.get(3));    /*存浏览按钮类型*/
                                td.setFieldId(Util.getIntValue(((String) dtlfieldids.get(0)).substring(5)));                /*将ID也取得*/
                                td.setFieldGroupId(i);    /*明细组*/
                                td.setNodeId(nodeid);    /*节点ID*/
                                td.setRequestId(requestid);    /*请求ID*/
                                td.setIsBill(isbill);    /*是否为表单*/
                                td.setModifierIP(Monitor.getIp(fu));    /*IP地址*/
                                td.setOptKind("monitor");    /*日志操作类型*/
                                td.setModifyTime(nowtime);//修改时间
                                fields.add(td);
                            }
                        }
                        /**
                         * end by cyril on 2008-06-05
                         */
                        if(detailkey==null || detailkey.trim().equals("")){
                            detailkey="mainid";
                        }
                        //是否为自定义表单
                        if(!isexpbill&&detailtable.indexOf("formtable_main_")!=-1) isexpbill=true;
                        RecordSet detailrs=new RecordSet();
                        int rowsum =-1;
//                        boolean caninsert = false;
                        String fieldid1 = "";
						String fieldname1 = "";
						String fieldvalue1 = "";
						String fieldhtmltype1 = "";
						String fielddbtype1 = "";
						String type1 = "";
                        if(iscreate.equals("1")) isexpbill=false;//排除新建流程时

                        if (isexpbill) {
                            //获取当前组的提交明细行序号串
                            String submitids = "";
                            if (isRequest)
                                submitids = Util.null2String(request.getParameter("submitdtlid" + i));
                            else
                                submitids = Util.null2String(fu.getParameter("submitdtlid" + i));
                            //String[] submitidAy=submitids.split(",");
                            String[] submitidAy = Util.TokenizerString2(submitids, ",");

                            /**
                             * modified by cyril on 2008-06-25
                             * 此段程序应该提前,判断删除的数据就不需要做修改动作了
                             * 删除的时候将记录保存到日志表后再物理删除记录
                             */
                            //拼装被删除的原有明细id串

                            String deldtlids = "";
                            if (deldtlids.equals("")) {
                                if (isRequest)
                                    deldtlids = Util.null2String(request.getParameter("deldtlid" + i));
                                else
                                    deldtlids = Util.null2String(fu.getParameter("deldtlid" + i));
                            } else {
                                String tempdeldtlids = "";
                                if (isRequest)
                                    tempdeldtlids = Util.null2String(request.getParameter("deldtlid" + i));
                                else
                                    tempdeldtlids = Util.null2String(fu.getParameter("deldtlid" + i));
                                if (!tempdeldtlids.equals(""))
                                    deldtlids += "," + tempdeldtlids;
                            }
							if(!deldtlids.equals("")){
								deldtlids = deldtlids.replaceAll(",{2,}",",");
								if(deldtlids.indexOf(",")==0)deldtlids = deldtlids.substring(1,deldtlids.length());
								if(deldtlids.lastIndexOf(",")==deldtlids.length()-1)deldtlids = deldtlids.substring(0,deldtlids.length()-1);
							}
                            //明细行循环

                            for (int k = 0; k < submitidAy.length; k++) {
                                //判断明细属性：新增、修改
                                String Dtlid = "";
                                if (isRequest)
                                    Dtlid = Util.null2String(request.getParameter("dtl_id_" + i + "_" + submitidAy[k]));
                                else
                                    Dtlid = Util.null2String(fu.getParameter("dtl_id_" + i + "_" + submitidAy[k]));

                                //新增明细
                                if (Dtlid.equals("")) {
                                    boolean hasMultiDoc = false;
                                    String sql1 = "insert into " + detailtable + " ( " + detailkey + ",";
                                    String sql2 = " values (" + billid + ",";
                                    if (formid == 156 || formid == 157 || formid == 158 || formid == 159) {
                                        int dsporder=0;
                                        rs.executeSql("select max(dsporder) from "+detailtable+" where "+detailkey+"="+billid);
                                        if(rs.next()){
                                            dsporder=rs.getInt(1)+1;
                                        }
                                        sql1 += "dsporder,";
                                        sql2 += dsporder+ ",";
                                    }else if(formid==7){
                                        int rowno=0;
                                        rs.executeSql("select max(rowno) from "+detailtable+" where "+detailkey+"="+billid);
                                        if(rs.next()){
                                            rowno=rs.getInt(1)+1;
                                        }
                                        sql1 += "rowno,";
                                        sql2 += rowno+ ",";
                                    }

                                    int nullLength = 0;
                                    List newList = new ArrayList();
                                    for (int j = 0; j < fieldids.size(); j++) {
                                        fieldname1 = (String) fieldnames.get(j);
                                        fieldid1 = (String) fieldids.get(j);
                                        fielddbtype1 = (String) fielddbtypes.get(j);
                                        int indxno = fieldid1.lastIndexOf("_");
                                        if (indxno > -1) {
                                            fieldhtmltype1 = fieldid1.substring(indxno + 1);
                                            fieldid1 = fieldid1.substring(0, indxno);
                                            indxno = fieldid1.lastIndexOf("_");
                                            if (indxno > -1) {
                                                type1 = fieldid1.substring(indxno + 1);
                                                fieldid1 = fieldid1.substring(0, indxno);
                                                indxno = fieldid1.lastIndexOf("_");
                                                if (indxno > -1) {
                                                    fieldid1 = fieldid1.substring(0, indxno);
                                                }
                                            }
                                        }
                                        if (workflowid == 1) {
                                            if (isRequest) {
                                                //fieldvalue1 = Util.toScreen(request.getParameter(fieldid1+"_"+k),userlanguage);
                                                fieldvalue1 = Util.toHtml100(request.getParameter(fieldid1 + "_" + submitidAy[k]));
                                            } else {
                                                //fieldvalue1 = Util.toScreen(fu.getParameter(fieldid1+"_"+k),userlanguage);
                                                fieldvalue1 = Util.toHtml100(fu.getParameter(fieldid1 + "_" + submitidAy[k]));
                                            }
                                        } else {
                                            if (isRequest)
                                                fieldvalue1 = Util.fromScreen2(request.getParameter(fieldid1 + "_" + submitidAy[k]), userlanguage);
                                            else
                                                fieldvalue1 = Util.fromScreen2(fu.getParameter(fieldid1 + "_" + submitidAy[k]), userlanguage);
                                        }
                                        
                                        //1：文档， 2：客户， 3：项目， 4：资产 权限过滤
                                        fieldvalue1 = resourceAuthorityFilter(fieldhtmltype1, type1, fieldvalue1,user);
                                        //空值处理
                                        if (fieldvalue1.trim().equals("")) {
                                            nullLength++;
                                            if (!(fieldhtmltype1.equals("2") || (fieldhtmltype1.equals("1") && (type1.equals("1") || type1.equals("5")))) && !(fieldhtmltype1.equals("3") && (type1.equals("2") || type1.equals("19") || type1.equals("161") || type1.equals("162")))) {//非文本的时候(去掉日期，自定义浏览框)
                                                fieldvalue1 = "NULL";
                                            }
                                            if (fieldhtmltype1.equals("5")) {
                                                fieldvalue1 = "NULL";
                                            } else if (fieldhtmltype1.equals("4")) { /*--- mackjoe for td5197 20061031 begin---*/
                                                fieldvalue1 = "0";
                                                nullLength--;
                                            }
                                            /*--- mackjoe for td5197 20061031 end---*/
                                        }else if((fielddbtype1.toUpperCase()).indexOf("NUMBER")>=0 || (fielddbtype1.toUpperCase()).indexOf("FLOAT")>=0 || (fielddbtype1.toUpperCase()).indexOf("DECIMAL")>=0){
                                        	int digitsIndex = fielddbtype1.indexOf(",");
                        					int decimaldigits = 2;
                        		        	if(digitsIndex > -1){
                        		        		decimaldigits = Util.getIntValue(fielddbtype1.substring(digitsIndex+1, fielddbtype1.length()-1).trim(), 2);
                        		        	}else{
                        		        		decimaldigits = 2;
                        		        	}
                        		        	fieldvalue1 = Util.getPointValue2(fieldvalue1, decimaldigits);
                                        }

                                        if (j == fieldids.size() - 1) {//the last
                                            if ((fielddbtype1.toLowerCase().startsWith("text") || fielddbtype1.toLowerCase().startsWith("char") || fielddbtype1.toLowerCase().startsWith("varchar") || fielddbtype1.toLowerCase().startsWith("browser"))&&!"NULL".equals(fieldvalue1)) {
                                                sql1 += fieldname1 + ")";
                                                sql2 += "'" + Util.htmlFilter4UTF8(Util.null2String(fieldvalue1)) + "')";
                                            }else if(fieldhtmltype1.equals("3")&&(type1.equals("256")||type1.equals("257"))){
	                                           	 sql1 += fieldname1 + ")";
	                                             sql2 += "'" + Util.htmlFilter4UTF8(Util.null2String(fieldvalue1)) + "')";
	                                        }else if(fieldhtmltype1.equals("3")&&type1.equals("17")&&isoracle){
                                            	sql1 += fieldname1 + " )";
                                            	sql2 += " empty_clob() )";
                                            	if(!fieldvalue1.equals("NULL")) {
                                            	    dtMap.put(fieldname1, fieldvalue1);
                                            	}
                                            } else {
                                                sql1 += fieldname1 + ")";
                                                sql2 += fieldvalue1 + ")";
                                            }

                                        } else {
                                            if ((fielddbtype1.toLowerCase().startsWith("text") || fielddbtype1.toLowerCase().startsWith("char") || fielddbtype1.toLowerCase().startsWith("varchar") || fielddbtype1.toLowerCase().startsWith("browser"))&&!"NULL".equals(fieldvalue1)) {
                                                sql1 += fieldname1 + ",";
                                                sql2 += "'" + Util.htmlFilter4UTF8(Util.null2String(fieldvalue1)) + "',";
                                            }else if(fieldhtmltype1.equals("3")&&(type1.equals("256")||type1.equals("257"))){
                                            	sql1 += fieldname1 + ",";
                                                sql2 += "'" + Util.htmlFilter4UTF8(Util.null2String(fieldvalue1)) + "',";
                                            }else if(fieldhtmltype1.equals("3")&&type1.equals("17")&&isoracle){
                                            	sql1 += fieldname1 + " ,";
                                            	sql2 += " empty_clob() ,";
                                            	if(!fieldvalue1.equals("NULL")) {
                                            	    dtMap.put(fieldname1, fieldvalue1);
                                            	}
                                            } else {
                                                sql1 += fieldname1 + ",";
                                                sql2 += fieldvalue1 + ",";
                                            }
                                        }

                                        String tempvalueid = Util.null2String(fieldvalue1);
                                        if (fieldhtmltype1.equals("3") && (type1.equals("1") || type1.equals("17"))) { // 人力资源字段
                                            if (!tempvalueid.equals("") && !tempvalueid.equals("NULL")){
                                            	hrmids += "," + tempvalueid;
                                            	//hrmids += ", empty_clob() ";
                                            	//dtMap.put("hrmids", tempvalueid);
                                            }
                                        } else if (fieldhtmltype1.equals("3") && (type1.equals("7") || type1.equals("18"))) {   // 客户字段
                                            if (!tempvalueid.equals("") && !tempvalueid.equals("NULL"))
                                                crmids += "," + tempvalueid;
                                        } else if (fieldhtmltype1.equals("3") && (type1.equals("8") || type1.equals("135"))) {   // 项目字段
                                            if (!tempvalueid.equals("") && !tempvalueid.equals("NULL"))
                                                prjids += "," + tempvalueid;
                                        } else if (fieldhtmltype1.equals("3") && (type1.equals("9") || type1.equals("37"))) {  // 文档字段
                                            if (!tempvalueid.equals("") && !tempvalueid.equals("NULL"))
                                                docids += "," + tempvalueid;
                                        } else if (fieldhtmltype1.equals("3") && type1.equals("23")) {                           // 资产字段
                                            if (!tempvalueid.equals("") && !tempvalueid.equals("NULL"))
                                                cptids += "," + tempvalueid;
                                        }
                                        if (("field"+isMultiDoc).equals(fieldid1 + "_" + submitidAy[k]))
                                        {
                                        	hasMultiDoc = true;
                                        	docrowindex = ""+temprowindex;
                                        }
                                        /**
                                         * added by cyril on 2008-06-26
                                         * 将匹配的值放入相应字段中
                                         */
                                        if (isStart && isTrack) {
                                            for (int m = 0; m < fields.size(); m++) {
                                                Trackdetail td = (Trackdetail) fields.get(m);
                                                if (td.getFieldName().equals(fieldname1)) {
                                                    String tmpstr = Util.StringReplaceOnce(fieldvalue1, " ", "");
                                                    if (tmpstr.equals("NULL")) {
                                                        tmpstr = "";
                                                    }
                                                    td.setFieldNewText(tmpstr);
                                                    newList.add(td);
                                                }
                                            }
                                        }
                                        /**
                                         * end add by cyril on 2008-06-26
                                         */
                                    }

                                    if (nullLength != fieldids.size() || hasMultiDoc) {
                                        //System.out.println(sql1 + sql2);
                                    	temprowindex ++;
                                        executesuccess = detailrs.executeSql(sql1 + sql2);
                                        /////////////////////////
                                        /***明细多人力clob***/
                                        
                            			if(isoracle){
                            				try {
                            					String maxidsql = "select max(id) dtid from " + detailtable + " where "+detailkey+" =" + billid;
                            					detailrs.executeSql(maxidsql);
                            					if(detailrs.next()){
                            						String dtid = Util.null2String(detailrs.getString("dtid"));
                            						if(!"".equals(dtid)){
		                            					String hrmsql = "";
		                            					hrmsql = " select ";
		                            					int hrmindex = 0;
		                            					String hrmsp = " ";
		                            					Iterator fdit = dtMap.entrySet().iterator();
		                            					while(fdit.hasNext()) {
		                            						hrmindex++;
		                            						Map.Entry entry = (Map.Entry) fdit.next();
		                            						String key = entry.getKey().toString();
		                            						String value = "";
		                            						if(entry.getValue()!=null) {
		                            							if(String.valueOf(entry.getValue()).equals(" ")) value = "";
		                            							else value = String.valueOf(entry.getValue());
		                            						}
		                            						if(hrmindex >1){
		                            							hrmsql += hrmsp+" , "+key;
		                            						}else{
		                            							hrmsql += hrmsp+" "+key;
		                            						}
		                            					}
		                            					
		                            					hrmsql += " from "+detailtable+" where id = " + dtid + " and "+detailkey+" = " + billid + " for update";
		                            					
		                            					//System.out.println("hrmsql = "+hrmsql);
		                            					if(hrmindex>0) {
		                            						ConnStatement hrmstatement = null;
		                            						try {
		                            							hrmstatement = new ConnStatement();
		                            							hrmstatement.setStatementSql(hrmsql, false);
		                            							hrmstatement.executeQuery();
		                            			                if(hrmstatement.next()){
		                            								fdit = dtMap.entrySet().iterator();
		                            								hrmindex = 0;
		                            								while(fdit.hasNext()) {
		                            									hrmindex++;
		                            									Map.Entry entry = (Map.Entry) fdit.next();
		                            									String key = entry.getKey().toString();
		                            									String value = "";
		                            									if(entry.getValue()!=null) {
		                            										if(String.valueOf(entry.getValue()).equals(" ")) value = "";
		                            										else value = String.valueOf(entry.getValue());
		                            									}
		                            									CLOB theclob = hrmstatement.getClob(hrmindex);
		                            					                char[] contentchar = value.toCharArray();
		                            					                Writer contentwrite = theclob.getCharacterOutputStream();
		                            					                contentwrite.write(contentchar);
		                            					                contentwrite.flush();
		                            					                contentwrite.close();
		                            								}
		                            			                }
		                            						} catch (Exception e) {
		                            						} finally {
		                            							if(hrmstatement!=null) hrmstatement.close();
		                            						}
		                            					}
                            						}
                            					}
                            				}catch(Exception e){
                            				}
                            			//
                            			}
                                    /******/
                                        /////////////////////////
                                        /**
									 * added by cyril on 2008-06-26
									 * 新增时为每个字段都存下明细
									 */
									if(isStart && isTrack) {
										sn++;
										//System.out.println("A----SN="+sn);
										for(int j=0; j<fields.size(); j++) {
											Trackdetail td = (Trackdetail) fields.get(j);
											td.setOptType(1);//类型为新增
											for(int m=0; m<newList.size(); m++) {
												Trackdetail tmptd = (Trackdetail) newList.get(m);
												//System.out.println("tmp="+tmptd.getFieldNewText());
												if(td.getFieldName().equals(tmptd.getFieldName())) {
													td.setFieldNewText(tmptd.getFieldNewText());
												}
											}
										}
									}
									/**
									 * end add by cyril on 2008-06-26
									 */
                                    }
                                } else if (checkIdDel(deldtlids, Dtlid)) { //检查是否删除的ID
                                    //修改明细
                                    String sql1 = "";
                                    Map modifyMap = new HashMap();
                                    for (int j = 0; j < fieldids.size(); j++) {
                                        fieldname1 = (String) fieldnames.get(j);
                                        fieldid1 = (String) fieldids.get(j);
                                        fielddbtype1 = (String) fielddbtypes.get(j);
                                        int indxno = fieldid1.lastIndexOf("_");
                                        if (indxno > -1) {
                                            fieldhtmltype1 = fieldid1.substring(indxno + 1);
                                            fieldid1 = fieldid1.substring(0, indxno);
                                            indxno = fieldid1.lastIndexOf("_");
                                            if (indxno > -1) {
                                                type1 = fieldid1.substring(indxno + 1);
                                                fieldid1 = fieldid1.substring(0, indxno);
                                                indxno = fieldid1.lastIndexOf("_");
                                                if (indxno > -1) {
                                                    fieldid1 = fieldid1.substring(0, indxno);
                                                }
                                            }
                                        }
                                        if (workflowid == 1) {
                                            if (isRequest) {
                                                //fieldvalue1 = Util.toScreen(request.getParameter(fieldid1+"_"+k),userlanguage);
                                                fieldvalue1 = Util.null2String(request.getParameter(fieldid1 + "_" + submitidAy[k]));
                                            } else {
                                                //fieldvalue1 = Util.toScreen(fu.getParameter(fieldid1+"_"+k),userlanguage);
                                                fieldvalue1 = Util.null2String(fu.getParameter(fieldid1 + "_" + submitidAy[k]));
                                            }
                                        } else {
                                            if (isRequest)
                                                fieldvalue1 = Util.null2String(request.getParameter(fieldid1 + "_" + submitidAy[k]));
                                            else
                                                fieldvalue1 = Util.null2String(fu.getParameter(fieldid1 + "_" + submitidAy[k]));
                                        }
                                        
                                        //1：文档， 2：客户， 3：项目， 4：资产 权限过滤
                                        fieldvalue1 = resourceAuthorityFilter(fieldhtmltype1, type1, fieldvalue1,user);
                                        String tempvalueid = Util.null2String(fieldvalue1);
                                        if (fieldhtmltype1.equals("3") && (type1.equals("1") || type1.equals("17"))) { // 人力资源字段
                                            if (!tempvalueid.equals("") && !tempvalueid.equals("NULL")){
                                                hrmids += "," + tempvalueid;
                                                //hrmids += ", empty_clob() ";
                                                //dtMap.put(fieldname1, tempvalueid);
                                            }
                                        } else if (fieldhtmltype1.equals("3") && (type1.equals("7") || type1.equals("18"))) {   // 客户字段
                                            if (!tempvalueid.equals("") && !tempvalueid.equals("NULL"))
                                                crmids += "," + tempvalueid;
                                        } else if (fieldhtmltype1.equals("3") && (type1.equals("8") || type1.equals("135"))) {   // 项目字段
                                            if (!tempvalueid.equals("") && !tempvalueid.equals("NULL"))
                                                prjids += "," + tempvalueid;
                                        } else if (fieldhtmltype1.equals("3") && (type1.equals("9") || type1.equals("37"))) {  // 文档字段
                                            if (!tempvalueid.equals("") && !tempvalueid.equals("NULL"))
                                                docids += "," + tempvalueid;
                                        } else if (fieldhtmltype1.equals("3") && type1.equals("23")) {                           // 资产字段
                                            if (!tempvalueid.equals("") && !tempvalueid.equals("NULL"))
                                                cptids += "," + tempvalueid;
                                        }
                                        
                                        if (("field"+isMultiDoc).equals(fieldid1 + "_" + submitidAy[k]))
    									{
                                        	docrowindex = ""+temprowindex;
    									}
                                        //空值处理
                                        if (fieldvalue1.trim().equals("")) {
                                            if (!(fieldhtmltype1.equals("2") || (fieldhtmltype1.equals("1") && (type1.equals("1") || type1.equals("5")))) && !(fieldhtmltype1.equals("3") && (type1.equals("2") || type1.equals("19")||type1.equals("161")||type1.equals("162")))) {//非文本的时候(去掉日期，自定义浏览框)
                                                fieldvalue1 = "NULL";
                                            }
                                            if (fieldhtmltype1.equals("5")) {
                                                fieldvalue1 = "NULL";
                                            } else if (fieldhtmltype1.equals("4")) { /*--- mackjoe for td5197 20061031 begin---*/
                                                fieldvalue1 = "0";
                                            }
                                            /*--- mackjoe for td5197 20061031 end---*/
                                        }else if((fielddbtype1.toUpperCase()).indexOf("NUMBER")>=0 || (fielddbtype1.toUpperCase()).indexOf("FLOAT")>=0 || (fielddbtype1.toUpperCase()).indexOf("DECIMAL")>=0){
                                        	int digitsIndex = fielddbtype1.indexOf(",");
                        					int decimaldigits = 2;
                        		        	if(digitsIndex > -1){
                        		        		decimaldigits = Util.getIntValue(fielddbtype1.substring(digitsIndex+1, fielddbtype1.length()-1).trim(), 2);
                        		        	}else{
                        		        		decimaldigits = 2;
                        		        	}
                        		        	fieldvalue1 = Util.getPointValue2(fieldvalue1, decimaldigits);
                                        }
                                        //更新串拼装
                                        
                                        if (sql1.equals("")) {
                                            if ((fielddbtype1.startsWith("text") || fielddbtype1.startsWith("char") || fielddbtype1.startsWith("varchar") || fielddbtype1.startsWith("browser"))&&!"NULL".equals(fieldvalue1)) {
                                                sql1 += fieldname1 + "=" + "'" + Util.toHtml10(Util.htmlFilter4UTF8(fieldvalue1)) + "' ";
                                            }else if(fieldhtmltype1.equals("3")&&(type1.equals("256")||type1.equals("257"))){
                                            	sql1 += fieldname1 + "=" + "'" + Util.toHtml10(fieldvalue1) + "' ";
                                            }else if(fieldhtmltype1.equals("3")&&type1.equals("17")&&isoracle){
                                            	sql1 += fieldname1 + " = empty_clob() ";
                                            	if(!fieldvalue1.equals("NULL")) {
                                            	    dtMap.put(fieldname1, fieldvalue1);
                                            	}
                                            } else {
                                                sql1 += fieldname1 + "=" + fieldvalue1 + " ";
                                            }

                                        } else {
                                            if ((fielddbtype1.startsWith("text") || fielddbtype1.startsWith("char") || fielddbtype1.startsWith("varchar") || fielddbtype1.startsWith("browser"))&&!"NULL".equals(fieldvalue1)) {
                                                sql1 += "," + fieldname1 + "=" + "'" + Util.toHtml10(Util.htmlFilter4UTF8(fieldvalue1)) + "' ";
                                            }else if(fieldhtmltype1.equals("3")&&(type1.equals("256")||type1.equals("257"))){
                                            	 sql1 += "," + fieldname1 + "=" + "'" + Util.toHtml10(Util.htmlFilter4UTF8(fieldvalue1)) + "' ";
                                            }else if(fieldhtmltype1.equals("3")&&type1.equals("17")&&isoracle){
                                            	sql1 += "," + fieldname1 + " = empty_clob() ";
                                            	if(!fieldvalue1.equals("NULL")) {
                                            	    dtMap.put(fieldname1, fieldvalue1);
                                            	}
                                            } else {
                                                sql1 += "," + fieldname1 + "=" + fieldvalue1 + " ";
                                            }
                                        }
                                        String tmpStr = Util.StringReplaceOnce(fieldvalue1, " ", "");
                                        if(tmpStr.equals("NULL"))
                                            tmpStr = "";
                                        modifyMap.put(fieldname1, tmpStr);//用来对比是否做过改动 by cyril on 2008-06-26 for TD:8835
                                    }

                                    if (!sql1.equals("")) {
                                        if(formid==156||formid==157||formid==158||formid==159){
                                            sql1="update " + detailtable + " set " + sql1 + " where dsporder=" + Dtlid+" and "+detailkey+" =" + billid;
                                            if(isStart && isTrack) sn = updateOrDeleteDetailLog(fields, 2, i, ""+billid, modifyMap, detailtable,formid, sn,isbill,userid, usertype);
                                        }else {
                                        	if(formid<0){
                                        		sql1="update " + detailtable + " set " + sql1 + " where id=" + Dtlid+" and "+detailkey+" =" + billid;
                                        	}else{
                                        		sql1="update " + detailtable + " set " + sql1 + " where id=" + Dtlid;
                                        	}
                                            if(isStart && isTrack) sn = updateOrDeleteDetailLog(fields, 2, i, Dtlid, modifyMap, detailtable,formid, sn,isbill,userid, usertype);
                                        }
                                        temprowindex ++;
                                        executesuccess = rs.executeSql( sql1);
                                        //////////////
                                        /***明细多人力clob***/
                                        
                            			if(isoracle){
                            				try {
                            					String hrmsql = "";
                            					if(formid<0){
                            						hrmsql = " select ";
                            					} else {
                            						hrmsql = "select ";
                            					}
                            					int hrmindex = 0;
                            					String hrmsp = " ";
                            					Iterator fdit = dtMap.entrySet().iterator();
                            					while(fdit.hasNext()) {
                            						hrmindex++;
                            						Map.Entry entry = (Map.Entry) fdit.next();
                            						String key = entry.getKey().toString();
                            						String value = "";
                            						if(entry.getValue()!=null) {
                            							if(String.valueOf(entry.getValue()).equals(" ")) value = "";
                            							else value = String.valueOf(entry.getValue());
                            						}
                            						if(hrmindex >1){
                            							hrmsql += hrmsp+" , "+key;
                            						}else{
                            							hrmsql += hrmsp+" "+key;
                            						}
                            					}
                            					if(formid<0){
                            						hrmsql += " from "+detailtable+" where id = " + Dtlid + " and "+detailkey+" =" + billid + " for update";
                            					} else {
                            						hrmsql += " from "+detailtable+" where id = " + Dtlid + " for update";
                            					}
                            					//System.out.println("hrmsql = "+hrmsql);
                            					if(hrmindex>0) {
                            						ConnStatement hrmstatement = null;
                            						try {
                            							hrmstatement = new ConnStatement();
                            							hrmstatement.setStatementSql(hrmsql, false);
                            							hrmstatement.executeQuery();
                            			                if(hrmstatement.next()){
                            								fdit = dtMap.entrySet().iterator();
                            								hrmindex = 0;
                            								while(fdit.hasNext()) {
                            									hrmindex++;
                            									Map.Entry entry = (Map.Entry) fdit.next();
                            									String key = entry.getKey().toString();
                            									String value = "";
                            									if(entry.getValue()!=null) {
                            										if(String.valueOf(entry.getValue()).equals(" ")) value = "";
                            										else value = String.valueOf(entry.getValue());
                            									}
                            									CLOB theclob = hrmstatement.getClob(hrmindex);
                            					                char[] contentchar = value.toCharArray();
                            					                Writer contentwrite = theclob.getCharacterOutputStream();
                            					                contentwrite.write(contentchar);
                            					                contentwrite.flush();
                            					                contentwrite.close();
                            								}
                            			                }
                            						} catch (Exception e) {
                            						} finally {
                            							if(hrmstatement!=null) hrmstatement.close();
                            						}
                            					}
                            				}catch(Exception e){
                            				}
                            			//
                            			}
                                    /******/
                                        //////////////
                                    }
                                }
                            }
                            if (!deldtlids.equals("")) {
                                if (isStart && isTrack) {
                                    //存删除的日志
                                    List tmpList = Util.TokenizerString(deldtlids, ",");
                                    for (int j = 0; j < tmpList.size(); j++) {
                                        sn = updateOrDeleteDetailLog(fields, 3, i, tmpList.get(j).toString(), null, detailtable,formid,sn,isbill,userid,usertype);
                                        //System.out.println("存删除的ID="+tmpList.get(j).toString());
                                    }
                                }
                                String sql1="";
                                if(formid == 156 || formid == 157 || formid == 158 || formid == 159) {
                                    sql1 = "delete from  " + detailtable + " where dsporder in(" + deldtlids + ") and " + detailkey + " =" + billid;
                                } else {
                                    sql1 = "delete from " + detailtable + " where id in(" + deldtlids + ")";
                                }
                                //System.out.println(sql1);
                                detailrs.executeSql(sql1);
                            }
                        } else {
                            String dtldelete = "1";
                            if(dtldelete.equals("1")||iscreate.equals("1")){
                        if(fieldids.size()>0) detailrs.executeSql("delete from "+detailtable+" where "+detailkey+" =" + billid);
						//System.out.println("det sql="+"delete from "+detailtable+" where "+detailkey+" =" + billid);
                        if(isRequest)
                            rowsum = Util.getIntValue(Util.null2String(request.getParameter("indexnum"+i)));
                        else
                            rowsum = Util.getIntValue(Util.null2String(fu.getParameter("indexnum"+i)));
                        String submitids = "";
                        if (isRequest)
                            submitids = Util.null2String(request.getParameter("submitdtlid" + i));
                        else
                            submitids = Util.null2String(fu.getParameter("submitdtlid" + i));
                        //String[] submitidAy=submitids.split(",");
                        //writeLog("submitids = " + submitids);
                        String[] submitidAy = Util.TokenizerString2(submitids, ",");
                        for(int k=0;k<submitidAy.length;k++){
                        	boolean hasMultiDoc = false;
                        	int rowcx = Util.getIntValue(submitidAy[k]);
                            String sql1 = "insert into "+detailtable+" ( "+detailkey+",";
                            String sql2 = " values (" + billid + ",";
                            if(formid==156||formid==157||formid==158||formid==159){
                                sql1+="dsporder,";
                                sql2+=rowcx+",";
                            } else if (formid == 7) {
                                sql1 += "rowno,";
                                sql2 += rowcx + ",";
                            }
                            int nullLength = 0;
							for(int j=0;j<fieldids.size();j++){
                                fieldname1 = (String)fieldnames.get(j);
								fieldid1 = (String)fieldids.get(j);
								fielddbtype1=(String)fielddbtypes.get(j);
                                int indxno=fieldid1.lastIndexOf("_");
                                if(indxno>-1){
                                    fieldhtmltype1=fieldid1.substring(indxno+1);
                                    fieldid1=fieldid1.substring(0,indxno);
                                    indxno=fieldid1.lastIndexOf("_");
                                    if(indxno>-1){
                                        type1=fieldid1.substring(indxno+1);
                                        fieldid1=fieldid1.substring(0,indxno);
                                        indxno=fieldid1.lastIndexOf("_");
                                        if(indxno>-1){
                                            fieldid1=fieldid1.substring(0,indxno);
                                        }
                                    }
                                }
								if(workflowid==1){
									if(isRequest){
										//fieldvalue1 = Util.toScreen(request.getParameter(fieldid1+"_"+k),userlanguage);
										fieldvalue1 = Util.toHtml100(request.getParameter(fieldid1+"_"+rowcx));										
									}else{
										//fieldvalue1 = Util.toScreen(fu.getParameter(fieldid1+"_"+k),userlanguage);
										fieldvalue1 = Util.toHtml100(fu.getParameter(fieldid1+"_"+rowcx));										
									}
								}else{
									if(isRequest)
										fieldvalue1 = Util.fromScreen2(request.getParameter(fieldid1+"_"+rowcx),userlanguage);
									else
										fieldvalue1 = Util.fromScreen2(fu.getParameter(fieldid1+"_"+rowcx),userlanguage);
								}
                                //空值处理

                                if(fieldvalue1.trim().equals("")){
									nullLength++;
									if (!(fieldhtmltype1.equals("2") || (fieldhtmltype1.equals("1") && (type1.equals("1")||type1.equals("5"))))&&!(fieldhtmltype1.equals("3")&&(type1.equals("2")||type1.equals("19")||type1.equals("161")||type1.equals("162")))) {//非文本的时候(去掉日期)
										fieldvalue1 = "NULL";
									}
                                    if(fieldhtmltype1.equals("5")){
                                        fieldvalue1 = "NULL";
									}else if(fieldhtmltype1.equals("4")){ /*--- mackjoe for td5197 20061031 begin---*/
                                        fieldvalue1 = "0";
                                        nullLength--;
                                    }
                                    /*--- mackjoe for td5197 20061031 end---*/
                                }else if((fielddbtype1.toUpperCase()).indexOf("NUMBER")>=0 || (fielddbtype1.toUpperCase()).indexOf("FLOAT")>=0 || (fielddbtype1.toUpperCase()).indexOf("DECIMAL")>=0){
                                	int digitsIndex = fielddbtype1.indexOf(",");
                					int decimaldigits = 2;
                		        	if(digitsIndex > -1){
                		        		decimaldigits = Util.getIntValue(fielddbtype1.substring(digitsIndex+1, fielddbtype1.length()-1).trim(), 2);
                		        	}else{
                		        		decimaldigits = 2;
                		        	}
                		        	fieldvalue1 = Util.getPointValue2(fieldvalue1, decimaldigits);
                                }

								if (j == fieldids.size() - 1) {//the last
									if ((fielddbtype1.toLowerCase().startsWith("text") || fielddbtype1.toLowerCase().startsWith("char") || fielddbtype1.toLowerCase().startsWith("varchar") || fielddbtype1.toLowerCase().startsWith("browser"))&&!"NULL".equals(fieldvalue1)) {
										sql1 += fieldname1 + ")";
										sql2 += "'" + Util.htmlFilter4UTF8(Util.null2String(fieldvalue1)) + "')";
									}else if(fieldhtmltype1.equals("3")&&(type1.equals("256")||type1.equals("257"))){
										sql1 += fieldname1 + ")";
										sql2 += "'" + Util.htmlFilter4UTF8(Util.null2String(fieldvalue1)) + "')";
                                    }else if(fieldhtmltype1.equals("3")&&type1.equals("17")&&isoracle){
                                    	sql1 += fieldname1 + ")";
										sql2 += " empty_clob() )";
										if(!fieldvalue1.equals("NULL")) {
										    dtMap.put(fieldname1, fieldvalue1);
										}
                                    } else {
										sql1 += fieldname1 + ")";
										sql2 += fieldvalue1 + ")";
									}

								} else {
									if ((fielddbtype1.toLowerCase().startsWith("text") || fielddbtype1.toLowerCase().startsWith("char") || fielddbtype1.toLowerCase().startsWith("varchar") || fielddbtype1.toLowerCase().startsWith("browser"))&&!"NULL".equals(fieldvalue1)) {
										sql1 += fieldname1 + ",";
										sql2 += "'" + Util.htmlFilter4UTF8(Util.null2String(fieldvalue1)) + "',";
									}else if(fieldhtmltype1.equals("3")&&(type1.equals("256")||type1.equals("257"))){
										sql1 += fieldname1 + ",";
										sql2 += "'" + Util.htmlFilter4UTF8(Util.null2String(fieldvalue1)) + "',";
                                    }else if(fieldhtmltype1.equals("3")&&type1.equals("17")&&isoracle){
                                    	sql1 += fieldname1 + ",";
										sql2 += " empty_clob() ,";
										if(!fieldvalue1.equals("NULL")) {
										    dtMap.put(fieldname1, fieldvalue1);
										}
                                    } else {
										sql1 += fieldname1 + ",";
										sql2 += fieldvalue1 + ",";
									}
								}

								String tempvalueid = Util.null2String(fieldvalue1);								
								if (fieldhtmltype1.equals("3") && (type1.equals("1") || type1.equals("17"))) { // 人力资源字段
									if (!tempvalueid.equals("")&&!tempvalueid.equals("NULL")) hrmids += "," + tempvalueid;
								} else if (fieldhtmltype1.equals("3") && (type1.equals("7") || type1.equals("18"))) {   // 客户字段
									if (!tempvalueid.equals("")&&!tempvalueid.equals("NULL")) crmids += "," + tempvalueid;
								} else if (fieldhtmltype1.equals("3") && (type1.equals("8")|| type1.equals("135"))) {   // 项目字段
									if (!tempvalueid.equals("")&&!tempvalueid.equals("NULL")) prjids += "," + tempvalueid;
								} else if (fieldhtmltype1.equals("3") && (type1.equals("9") || type1.equals("37"))) {  // 文档字段
									if (!tempvalueid.equals("")&&!tempvalueid.equals("NULL")) docids += "," + tempvalueid;
								} else if (fieldhtmltype1.equals("3") && type1.equals("23")) {                           // 资产字段
									if (!tempvalueid.equals("")&&!tempvalueid.equals("NULL")) cptids += "," + tempvalueid;
								}
								if(("field"+isMultiDoc).equals(fieldid1 + "_" + rowcx))
								{
									hasMultiDoc = true;
									docrowindex = ""+temprowindex;
								}
								
                            }

							if (nullLength != fieldids.size() || hasMultiDoc) 
							{
								temprowindex ++;
								executesuccess = detailrs.executeSql(sql1 + sql2);
							}
							
							if(isoracle){
                				try {
                					String maxidsql = "select max(id) dtid from " + detailtable + " where "+detailkey+" =" + billid;
                					detailrs.executeSql(maxidsql);
                					if(detailrs.next()){
                						String dtid = Util.null2String(detailrs.getString("dtid"));
                						if(!"".equals(dtid)){
		                					String hrmsql = "";
		                					if(formid<0){
		                						hrmsql = " select ";
		                					} else {
		                						hrmsql = "select ";
		                					}
		                					int hrmindex = 0;
		                					String hrmsp = " ";
		                					Iterator fdit = dtMap.entrySet().iterator();
		                					while(fdit.hasNext()) {
		                						hrmindex++;
		                						Map.Entry entry = (Map.Entry) fdit.next();
		                						String key = entry.getKey().toString();
		                						String value = "";
		                						if(entry.getValue()!=null) {
		                							if(String.valueOf(entry.getValue()).equals(" ")) value = "";
		                							else value = String.valueOf(entry.getValue());
		                						}
		                						if(hrmindex >1){
		                							hrmsql += hrmsp+" , "+key;
		                						}else{
		                							hrmsql += hrmsp+" "+key;
		                						}
		                					}
		                					
		                					hrmsql += " from "+detailtable+" where id = "+dtid+" and "+detailkey+" =" + billid + " for update";
		                					
		                					//System.out.println("hrmsql = "+hrmsql);
		                					if(hrmindex>0) {
		                						ConnStatement hrmstatement = null;
		                						try {
		                							hrmstatement = new ConnStatement();
		                							hrmstatement.setStatementSql(hrmsql, false);
		                							hrmstatement.executeQuery();
		                			                if(hrmstatement.next()){
		                								fdit = dtMap.entrySet().iterator();
		                								hrmindex = 0;
		                								while(fdit.hasNext()) {
		                									hrmindex++;
		                									Map.Entry entry = (Map.Entry) fdit.next();
		                									String key = entry.getKey().toString();
		                									String value = "";
		                									if(entry.getValue()!=null) {
		                										if(String.valueOf(entry.getValue()).equals(" ")) value = "";
		                										else value = String.valueOf(entry.getValue());
		                									}
		                									CLOB theclob = hrmstatement.getClob(hrmindex);
		                					                char[] contentchar = value.toCharArray();
		                					                Writer contentwrite = theclob.getCharacterOutputStream();
		                					                contentwrite.write(contentchar);
		                					                contentwrite.flush();
		                					                contentwrite.close();
		                								}
		                			                }
		                						} catch (Exception e) {
		                						} finally {
		                							if(hrmstatement!=null) hrmstatement.close();
		                						}
		                					}
                						}
                					}
                				}catch(Exception e){
                				}
                			//
                			}

                        }
                    }
                    }
                    }
				}else{	//表单 增加多明细by ben 2006-04-26
					ArrayList fieldids1 = new ArrayList();				//字段队列
					ArrayList fieldnames1 = new ArrayList();			//单据的字段的表字段名队列
					ArrayList fieldhtmltypes1 = new ArrayList();		//html类型
					ArrayList fielddbtypes = new ArrayList();
					ArrayList types1 = new ArrayList();					//类型
	                int detailGroupId=0;
	                String deldtlids="";
	                int bflength = 0;//多明细时判断上次明细时的长度
	                int rows=0;
					String  sql="select distinct groupId from workflow_formfield where formid="+formid+" and isdetail='1' order by groupId";
	                RecordSet rs2 = new RecordSet();
	                rs2.execute(sql);
	                //明细组循环

	                while (rs2.next()){
	                	fields = new ArrayList();//by cyril 每次明细都重取字段

		                detailGroupId=rs2.getInt(1);

		                //获取当前明细组的字段信息
						sql = " select distinct a.fieldid, b.fieldname, b.fieldhtmltype, b.type, b.fielddbtype,a.groupId, "+
							  "(select fieldlable from workflow_fieldlable t where t.langurageid = 7 and t.fieldid = a.fieldid and t.formid = a.formid) fieldNameCn,"+
							  "(select fieldlable from workflow_fieldlable t where t.langurageid = 8 and t.fieldid = a.fieldid and t.formid = a.formid) fieldNameEn, "+
							  "(select fieldlable from workflow_fieldlable t where t.langurageid = 9 and t.fieldid = a.fieldid and t.formid = a.formid) fieldNameTw "+
							  " from workflow_formfield a, workflow_formdictdetail b,workflow_fieldlable c "+
							  " where a.isdetail='1' and a.fieldid=b.id and c.fieldid = a.fieldid and c.formid = a.formid and c.langurageid = "+userlanguage+" and a.formid=" + formid+" and a.groupId=" + detailGroupId;
						//System.out.println("===============>"+sql);
                        rs.executeSql(sql);
						while (rs.next()) {
							fieldids1.add(Util.null2String(rs.getString("fieldid")));
							fieldnames1.add(Util.null2String(rs.getString("fieldname")));
							fieldhtmltypes1.add(Util.null2String(rs.getString("fieldhtmltype")));
							fielddbtypes.add(Util.null2String(rs.getString("fielddbtype")));
							types1.add(Util.null2String(rs.getString("type")));
							/**
							 * added by cyril on 2008-06-25
							 * 功能:取得明细字段
							 */
							if(isStart && isTrack) {
								Trackdetail td = new Trackdetail();
								td.setFieldName(rs.getString("fieldname"));		/*存字段名称*/
								td.setFieldType(rs.getString("type"));		/*存浏览按钮对应位置*/
								td.setFieldHtmlType(rs.getString("fieldhtmltype"));	/*存浏览按钮类型*/
								td.setFieldId(rs.getInt("fieldid"));				/*将ID也取得*/
								td.setFieldGroupId(rs.getInt("groupId"));	/*明细组*/
								//如果是表单则填以下二项

								if(isbill!=1) {
									td.setFieldNameCn(rs.getString("fieldNameCn"));	/*取字段名称*/
									td.setFieldNameEn(rs.getString("fieldNameEn"));	/*取字段名称*/
									td.setFieldNameTw(rs.getString("fieldNameTw"));	/*取字段名称*/
								}
								td.setNodeId(nodeid);	/*节点ID*/
								td.setRequestId(requestid);	/*请求ID*/
								td.setIsBill(isbill);	/*是否为表单*/
								td.setModifierIP(Monitor.getIp(fu));	/*IP地址*/
								td.setOptKind("monitor");	/*日志操作类型*/
								td.setModifyTime(nowtime);//修改时间
								fields.add(td);
							}
							/**
							 * end by cyril on 2008-06-05
							 */
						}
							    
					    //获取当前组的提交明细行序号串
					    String submitids="";
					    if(isRequest)
					    	submitids = Util.null2String(request.getParameter("submitdtlid"+rows));
						else
							submitids = Util.null2String(fu.getParameter("submitdtlid"+rows));
					    //String[] submitidAy=submitids.split(",");
					    String[] submitidAy=Util.TokenizerString2(submitids,",");
						
					    /**
						 * modified by cyril on 2008-06-25
						 * 此段程序应该提前,判断删除的数据就不需要做修改动作了

						 * 删除的时候将记录保存到日志表后再物理删除记录
						 */
						//拼装被删除的原有明细id串

						if(deldtlids.equals("")){
							if(isRequest)
								deldtlids = Util.null2String(request.getParameter("deldtlid" + detailGroupId));
							else
								deldtlids = Util.null2String(fu.getParameter("deldtlid" + detailGroupId));
						}else{
							String tempdeldtlids="";
							if(isRequest)
								tempdeldtlids = Util.null2String(request.getParameter("deldtlid" + detailGroupId));
							else
								tempdeldtlids = Util.null2String(fu.getParameter("deldtlid" + detailGroupId));
							if(!tempdeldtlids.equals(""))
								deldtlids += "," + tempdeldtlids;
						}
						if(!deldtlids.equals("")){
							deldtlids = deldtlids.replaceAll(",{2,}",",");
							if(deldtlids.indexOf(",")==0)deldtlids = deldtlids.substring(1,deldtlids.length());
							if(deldtlids.lastIndexOf(",")==deldtlids.length()-1)deldtlids = deldtlids.substring(0,deldtlids.length()-1);
						}
						if(bflength<deldtlids.length() && isStart && isTrack) {
							if(bflength>0)
								bflength++;
							//存删除的日志
							if(!deldtlids.equals("")) {
								List tmpList = Util.TokenizerString(deldtlids.substring(bflength), ",");
								for(int j=0; j<tmpList.size(); j++) {
									sn = updateOrDeleteDetailLog(fields, 3, detailGroupId, tmpList.get(j).toString(), null, "Workflow_formdetail",formid,sn,isbill,userid,usertype);
									//System.out.println("存删除的ID="+tmpList.get(j).toString());
								}
							}
						}
						bflength = deldtlids.length();
						/**
						 * end modified by cyril on 2008-06-25 
						 */
					    //明细行循环

						for (int i = 0; i < submitidAy.length; i++) {
							//判断明细属性：新增、修改

							String Dtlid ="";
							if(isRequest)
								Dtlid = Util.null2String(request.getParameter("dtl_id_" + detailGroupId +"_"+ submitidAy[i]));
							else
								Dtlid = Util.null2String(fu.getParameter("dtl_id_" + detailGroupId +"_"+ submitidAy[i]));
							
							//新增明细
							if(Dtlid.equals("")){
								boolean hasMultiDoc = false;
								Object fieldid1 = null;
								String fieldname1 = "";
								String fieldvalue1 = "";
								String fieldhtmltype1 = "";
								String fielddbtype1 = "";
								String type1 = "";
								String sql1 = "insert into Workflow_formdetail ( requestid,groupId,";
								String sql2 = " values (" + requestid + ","+detailGroupId+" ,";
			
								int nullLength = 0;
								List newList = new ArrayList();
								for (int j = 0; j < fieldnames1.size(); j++) {
									fieldname1 = fieldnames1.get(j) + "";
									fieldid1 = fieldids1.get(j);
									fieldhtmltype1 = fieldhtmltypes1.get(j) + "";
									type1 = types1.get(j) + "";
									fielddbtype1 = fielddbtypes.get(j) + "";
									if(isRequest)
										fieldvalue1 = Util.null2String(request.getParameter("field" + fieldid1 + "_" + submitidAy[i]));
									else
										fieldvalue1 = Util.null2String(fu.getParameter("field" + fieldid1 + "_" + submitidAy[i]));

									if (fieldvalue1.equals("")) {
			
										nullLength++;
										if (!(fieldhtmltype1.equals("2") || (fieldhtmltype1.equals("1") && (type1.equals("1")||type1.equals("5"))))&&!(fieldhtmltype1.equals("3")&&(type1.equals("2")||type1.equals("19")||type1.equals("161")||type1.equals("162")))) {//非文本的时候(去掉日期)
											fieldvalue1 = "NULL";
										}
										/*--- xwj for td3297 20051130 begin---*/
										if(fieldhtmltype1.equals("5")){
                                            fieldvalue1 = "NULL";
										}else if(fieldhtmltype1.equals("4")){   /*--- mackjoe for td5197 20061031 begin---*/
                                            fieldvalue1 = "0";
                                            nullLength--;
										}
										/*--- mackjoe for td5197 20061031 end---*/
										/*--- xwj for td3297 20051130 begin---*/
                                    }else if((fielddbtype1.toUpperCase()).indexOf("NUMBER")>=0 || (fielddbtype1.toUpperCase()).indexOf("FLOAT")>=0 || (fielddbtype1.toUpperCase()).indexOf("DECIMAL")>=0){
                                    	int digitsIndex = fielddbtype1.indexOf(",");
                    					int decimaldigits = 2;
                    		        	if(digitsIndex > -1){
                    		        		decimaldigits = Util.getIntValue(fielddbtype1.substring(digitsIndex+1, fielddbtype1.length()-1).trim(), 2);
                    		        	}else{
                    		        		decimaldigits = 2;
                    		        	}
                    		        	fieldvalue1 = Util.getPointValue2(fieldvalue1, decimaldigits);
                                    }
									if (j == fieldnames1.size() - 1) {//the last
										if ((fielddbtype1.startsWith("text") || fielddbtype1.startsWith("char") || fielddbtype1.startsWith("varchar")||fielddbtype1.indexOf(".")>-1)&&!"NULL".equals(fieldvalue1)) {
											sql1 += fieldname1 + ")";
											sql2 += "'" + Util.toHtml10(fieldvalue1) + "')";
										} else {
											sql1 += fieldname1 + ")";
											sql2 += fieldvalue1 + ")";
										}
			
									} else {
										if ((fielddbtype1.startsWith("text") || fielddbtype1.startsWith("char") || fielddbtype1.startsWith("varchar")||fielddbtype1.indexOf(".")>-1)&&!"NULL".equals(fieldvalue1)) {
											sql1 += fieldname1 + ",";
											sql2 += "'" + Util.toHtml10(fieldvalue1) + "',";
										} else {
											sql1 += fieldname1 + ",";
											sql2 += fieldvalue1 + ",";
										}
									}
									
									String tempvalueid = Util.null2String(fieldvalue1);								
									if (fieldhtmltype1.equals("3") && (type1.equals("1") || type1.equals("17"))) { // 人力资源字段
										if (!tempvalueid.equals("")&&!tempvalueid.equals("NULL")) hrmids += "," + tempvalueid;
									} else if (fieldhtmltype1.equals("3") && (type1.equals("7") || type1.equals("18"))) {   // 客户字段
										if (!tempvalueid.equals("")&&!tempvalueid.equals("NULL")) crmids += "," + tempvalueid;
									} else if (fieldhtmltype1.equals("3") && (type1.equals("8")|| type1.equals("135"))) {   // 项目字段
										if (!tempvalueid.equals("")&&!tempvalueid.equals("NULL")) prjids += "," + tempvalueid;
									} else if (fieldhtmltype1.equals("3") && (type1.equals("9") || type1.equals("37"))) {  // 文档字段
										if (!tempvalueid.equals("")&&!tempvalueid.equals("NULL")) docids += "," + tempvalueid;
									} else if (fieldhtmltype1.equals("3") && type1.equals("23")) {                           // 资产字段
										if (!tempvalueid.equals("")&&!tempvalueid.equals("NULL")) cptids += "," + tempvalueid;
									}									
									if ((isMultiDoc).equals(fieldid1 + "_" + submitidAy[i]))
									{
										hasMultiDoc = true;
										docrowindex = ""+temprowindex;
									}
									/**
									 * added by cyril on 2008-06-26
									 * 将匹配的值放入相应字段中
									 */
									if(isStart && isTrack) {
										for(int k=0; k<fields.size(); k++) {
											Trackdetail td = (Trackdetail) fields.get(k);
											if(td.getFieldName().equals(fieldname1)) {
												String tmpstr = Util.StringReplaceOnce(fieldvalue1, " ", "");
												if(tmpstr.equals("NULL")) {
													tmpstr = "";
												}
												td.setFieldNewText(tmpstr);
												newList.add(td);
											}
										}
									}
									/**
									 * end add by cyril on 2008-06-26
									 */
								}
								
								

								if (nullLength != fieldnames1.size() || hasMultiDoc) {
									/**
									 * added by cyril on 2008-06-26
									 * 新增时为每个字段都存下明细

									 */
									if(isStart && isTrack) {
										sn++;
										//System.out.println("A----SN="+sn);
										for(int j=0; j<fields.size(); j++) {
											Trackdetail td = (Trackdetail) fields.get(j);
											td.setOptType(1);//类型为新增

											for(int k=0; k<newList.size(); k++) {
												Trackdetail tmptd = (Trackdetail) newList.get(k);
												//System.out.println("tmp="+tmptd.getFieldNewText());
												if(td.getFieldName().equals(tmptd.getFieldName())) {
													td.setFieldNewText(tmptd.getFieldNewText());
												}
											}
											insertDetail(td,sn,isbill,usertype,userid); //每个字段都要存明细

										}
									}
									/**
									 * end add by cyril on 2008-06-26
									 */
									temprowindex ++;
									executesuccess = rs.executeSql(sql1 + sql2);
								}
			
							}else if(checkIdDel(deldtlids,Dtlid)){ //检查是否删除的ID
								//修改明细
								Object fieldid1 = null;
								String fieldname1 = "";
								String fieldvalue1 = "";
								String fieldhtmltype1 = "";
								String fielddbtype1 = "";
								String type1 = "";
								String sql1 = "";
								Map modifyMap = new HashMap();
			
								for (int j = 0; j < fieldnames1.size(); j++) {
									fieldname1 = fieldnames1.get(j) + "";
									fieldid1 = fieldids1.get(j);
									fieldhtmltype1 = fieldhtmltypes1.get(j) + "";
									type1 = types1.get(j) + "";
									fielddbtype1 = fielddbtypes.get(j) + "";
			
									if(isRequest)
										fieldvalue1 = Util.null2String(request.getParameter("field" + fieldid1 + "_" + submitidAy[i]));
									else
										fieldvalue1 = Util.null2String(fu.getParameter("field" + fieldid1 + "_" + submitidAy[i]));
                                    String tempvalueid = Util.null2String(fieldvalue1);
									if (fieldhtmltype1.equals("3") && (type1.equals("1") || type1.equals("17"))) { // 人力资源字段
										if (!tempvalueid.equals("")&&!tempvalueid.equals("NULL")) hrmids += "," + tempvalueid;
									} else if (fieldhtmltype1.equals("3") && (type1.equals("7") || type1.equals("18"))) {   // 客户字段
										if (!tempvalueid.equals("")&&!tempvalueid.equals("NULL")) crmids += "," + tempvalueid;
									} else if (fieldhtmltype1.equals("3") && (type1.equals("8")|| type1.equals("135"))) {   // 项目字段
										if (!tempvalueid.equals("")&&!tempvalueid.equals("NULL")) prjids += "," + tempvalueid;
									} else if (fieldhtmltype1.equals("3") && (type1.equals("9") || type1.equals("37"))) {  // 文档字段
										if (!tempvalueid.equals("")&&!tempvalueid.equals("NULL")) docids += "," + tempvalueid;
									} else if (fieldhtmltype1.equals("3") && type1.equals("23")) {                           // 资产字段
										if (!tempvalueid.equals("")&&!tempvalueid.equals("NULL")) cptids += "," + tempvalueid;
									}
									if ((isMultiDoc).equals(fieldid1 + "_" + submitidAy[i]))
									{
										docrowindex = ""+temprowindex;
									}
									//空值处理

									if (fieldvalue1.equals("")) {
										if (!(fieldhtmltype1.equals("2") || (fieldhtmltype1.equals("1") && (type1.equals("1")||type1.equals("5"))))&&!(fieldhtmltype1.equals("3")&&(type1.equals("2")||type1.equals("19")||type1.equals("161")||type1.equals("162")))) {//非文本的时候(去掉日期)
											fieldvalue1 = "NULL";
										}
										if(fieldhtmltype1.equals("5")){
											fieldvalue1 = "NULL";
										}
                                        /*--- mackjoe for td5197 20061031 begin---*/
                                        if(fieldhtmltype1.equals("4")){
                                            fieldvalue1 = "0";
                                        }
                                        /*--- mackjoe for td5197 20061031 end---*/
                                     }else if((fielddbtype1.toUpperCase()).indexOf("NUMBER")>=0 || (fielddbtype1.toUpperCase()).indexOf("FLOAT")>=0 || (fielddbtype1.toUpperCase()).indexOf("DECIMAL")>=0){
                                        	int digitsIndex = fielddbtype1.indexOf(",");
                        					int decimaldigits = 2;
                        		        	if(digitsIndex > -1){
                        		        		decimaldigits = Util.getIntValue(fielddbtype1.substring(digitsIndex+1, fielddbtype1.length()-1).trim(), 2);
                        		        	}else{
                        		        		decimaldigits = 2;
                        		        	}
                        		        	fieldvalue1 = Util.getPointValue2(fieldvalue1, decimaldigits);
                                     }
									//更新串拼装

									if (sql1.equals("")) {
										if ((fielddbtype1.startsWith("text") || fielddbtype1.startsWith("char") || fielddbtype1.startsWith("varchar") || fielddbtype1.startsWith("browser"))&&!"NULL".equals(fieldvalue1)) {
											sql1 += fieldname1 + "=" + "'" + Util.toHtml10(fieldvalue1) + "' ";
										} else {
											sql1 += fieldname1 + "=" + fieldvalue1 + " ";
										}
			
									} else {
										if ((fielddbtype1.startsWith("text") || fielddbtype1.startsWith("char") || fielddbtype1.startsWith("varchar") || fielddbtype1.startsWith("browser"))&&!"NULL".equals(fieldvalue1)) {
											sql1 += "," + fieldname1 + "=" + "'" + Util.toHtml10(fieldvalue1) + "' ";
										} else {
											sql1 += "," + fieldname1 + "=" + fieldvalue1 + " ";
										}
									}
									
									String tmpStr = Util.StringReplaceOnce(fieldvalue1, " ", "");
									if(tmpStr.equals("NULL"))
										tmpStr = "";
									modifyMap.put(fieldname1, tmpStr);//用来对比是否做过改动 by cyril on 2008-06-26 for TD:8835
								}
			
								if (!sql1.equals("")) {
									if(isStart && isTrack) {
										sn = updateOrDeleteDetailLog(fields, 2, detailGroupId, Dtlid, modifyMap, "Workflow_formdetail",formid,sn,isbill,userid,usertype);//先要将修改的原记录存入LOG by cyril for TD:8835
									}
									temprowindex ++;
									executesuccess = rs.executeSql("update Workflow_formdetail set "+sql1+" where id="+Dtlid);

								}
							}
						}
						fieldids1.clear();
						fieldnames1.clear();
						fieldhtmltypes1.clear();
						fielddbtypes.clear();
						types1.clear();
						rows++;
					}
	                
					//删除被删除的原有明细
					if (!deldtlids.equals("")) {
						rs.executeSql("delete from Workflow_formdetail where id in(" +deldtlids+")" );
					}
				}
			}
		    catch (Exception e) {
				e.printStackTrace();
			}
		
%>

<%!
private boolean checkIdDel(String delIds, String id) {
		if(delIds!=null && !delIds.equals("")) {
			List list = Util.TokenizerString(delIds, ",");
			for(int i=0; i<list.size(); i++) {
				if(list.get(i).toString().equals(id)) {
					return false;
				}
			}
		}
		return true;
	}
%>

<%!
private int updateOrDeleteDetailLog(List fields, int optType, int detailGroupId, String id, Map modifyMap, String detailTableName,int formid,int sn,int isbill,String userid,int usertype) {
	if(detailTableName==null || "".equals(detailTableName)){
		return sn;
	}
	StringBuffer s = new StringBuffer();
	StringBuffer fieldNameStr = new StringBuffer();
	RecordSet rs = new RecordSet();
	s.append("select ");
	for(int k=0; k<fields.size(); k++) {
		Trackdetail td = (Trackdetail) fields.get(k);
		fieldNameStr.append(td.getFieldName());
		if(k<(fields.size()-1)) fieldNameStr.append(",");
		else fieldNameStr.append(" ");
	}
	if(fieldNameStr.toString().trim().equals("")){
		return sn;
	}
	s.append(" "+fieldNameStr+" ");
	s.append("from "+detailTableName+" ");
	s.append("where id="+id);
	boolean executesuccess = rs.executeSql(s.toString());
	boolean isModify = false;
	if(optType!=2) isModify = true;
	//取得原记录

	List oldList = new ArrayList();
	if(rs.next()) {
		for(int i=0; i<fields.size(); i++) {
			Trackdetail td = (Trackdetail) fields.get(i);
			td.setFieldOldText(rs.getString(td.getFieldName()));
			//System.out.println("字段名称:"+td.getFieldName()+" 值="+rs.getString(td.getFieldName()));
			oldList.add(td);
		}
	}
	
	//判断记录是否被修改

	if(optType==2) {
		//取得节点显示的字d段,不显示的不判断

		Map verifyMap = new HashMap();
		String sql = " select distinct b.fieldname "+
		  " from workflow_formfield a, workflow_formdictdetail b "+
		  " where a.isdetail='1' and a.fieldid=b.id and a.formid=" + formid+" and a.groupId=" + detailGroupId;
		  
        if(!detailTableName.equals("Workflow_formdetail")){
            sql = " select fieldname "+
		  " from workflow_billfield "+
		  " where viewtype='1' and billid=" + formid;
        }
		//System.out.println("SQL="+sql);
		rs.executeSql(sql);
		while(rs.next()) {
			verifyMap.put(rs.getString("fieldname"), "C");
		}
		for(int i=0; i<oldList.size(); i++) {
			Trackdetail td = (Trackdetail) oldList.get(i);
			if(verifyMap.get(td.getFieldName())!=null && modifyMap.get(td.getFieldName())!=null && !modifyMap.get(td.getFieldName()).toString().equals(td.getFieldOldText())) {
				isModify = true;
				break;
			}
		}
	}
	if(isModify) {
		sn++;
		//System.out.println("MorD----SN="+sn);
		//将删除或修改过的明细记录放入日志表

		for(int k=0; k<oldList.size(); k++) {
			Trackdetail td = (Trackdetail) oldList.get(k);
			td.setFieldGroupId(detailGroupId);
			td.setOptType(optType);//类型
			if(optType==2 && modifyMap.get(td.getFieldName())!=null) {
				td.setFieldNewText(modifyMap.get(td.getFieldName()).toString());
			}
			
			insertDetail(td,sn,isbill,usertype,userid);
		}
	}
	return sn;
}
%>

<%!
private boolean insertDetail(Trackdetail td,int sn,int isbill,int usertype,String userid) {
	StringBuffer s = new StringBuffer();
	RecordSet rs = new RecordSet();
	s.append("insert into workflow_trackdetail (");
	s.append("sn, optKind,optType,requestId,nodeId,isBill,");
	s.append("fieldLableId,fieldGroupId,fieldId,fieldHtmlType,fieldType,fieldNameCn,fieldNameEn,fieldNameTw,");
	s.append("fieldOldText,fieldNewText,modifierType,agentId,modifierId,modifierIP,modifyTime) ");
	s.append("values (");
	s.append(sn+",");
	s.append(disposeSqlNull(td.getOptKind())+",");
	s.append(td.getOptType()+",");
	s.append(td.getRequestId()+",");
	s.append(td.getNodeId()+",");
	s.append(isbill+",");
	s.append(td.getFieldLableId()+",");
	s.append(td.getFieldGroupId()+",");
	s.append(td.getFieldId()+",");
	s.append(disposeSqlNull(td.getFieldHtmlType())+",");
	s.append(disposeSqlNull(td.getFieldType())+",");
	s.append(disposeSqlNull(td.getFieldNameCn())+",");
	s.append(disposeSqlNull(td.getFieldNameEn())+",");
	s.append(disposeSqlNull(td.getFieldNameTw())+",");
	s.append(disposeSqlNull(Util.toHtml(Util.null2String(td.getFieldOldText())))+",");
	s.append(disposeSqlNull(Util.toHtml(Util.null2String(td.getFieldNewText())))+",");
	s.append(usertype+",");
	s.append("-1,");
	s.append(userid+",");
	s.append(disposeSqlNull(td.getModifierIP())+",");
	s.append(disposeSqlNull(td.getModifyTime()));
	s.append(")");
	rs.executeSql(s.toString());//插入明细日志);
	//System.out.println("detail insert sql="+s.toString());
	return true;
}
%>

<%!public String disposeSqlNull(String s) {
	if(s==null) 
		s = "NULL";
	else
		s = "'"+s+"'";
	return s;
} %>

<%!private String resourceAuthorityFilter(String fieldhtmltype, String fieldtype, String resstr,User user) {
    String result = resstr;
    
    if ("".equals(resstr)) {
        return result;
    }
    
    if ("3".equals(fieldhtmltype)) {
        if (fieldtype.equals("9") || fieldtype.equals("37")) {  // 文档字段
            result = new DocShareUtil().docRightFilter(user, resstr);
        } else if (fieldtype.equals("8")|| fieldtype.equals("135")) { //项目
            result = new weaver.cpt.util.CommonShareManager().getPrjFilterids(resstr, user);
        } else if (fieldtype.equals("23")) { //资产
            result = new weaver.cpt.util.CommonShareManager().getCptFilterids(resstr, user);
        } else if (fieldtype.equals("7") || fieldtype.equals("18")) { //客户
            result = weaver.crm.customer.CustomerShareUtil.customerRightFilter(String.valueOf(user.getUID()), resstr);
        }
    }
    return result;
} %>

<%! public String fillFullNull(String obj){
	   if("".equals(obj.trim())){
		   return "";
	   }else{
		   return obj; 
	   }
	  
  } %>
<script>
alert('<%=SystemEnv.getHtmlLabelName(26713,user.getLanguage())%>');
//location.href = '/workflow/request/EditFormIframe.jsp?requestid=<%=requestid%>';
window.opener=null;
window.open('', '_self', ''); 
window.close();
</script>