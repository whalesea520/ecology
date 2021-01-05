<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page buffer="4kb" autoFlush="true" errorPage="/notice/error.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="oracle.sql.CLOB" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.Writer" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.workflow.workflow.WorkflowVersion" %>
<%@ page import="weaver.workflow.workflow.GroupDetailMatrix,weaver.workflow.workflow.GroupDetailMatrixDetail" %>
<%@page import="weaver.workflow.workflow.WfRightManager"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session"/>
<jsp:useBean id="FormComInfo" class="weaver.workflow.form.FormComInfo" scope="page" />
<jsp:useBean id="WFNodeMainManager" class="weaver.workflow.workflow.WFNodeMainManager" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="FormFieldMainManager" class="weaver.workflow.form.FormFieldMainManager" scope="page" />
<jsp:useBean id="matrixUtil" class="weaver.matrix.MatrixUtil" scope="page" />
<jsp:useBean id="WFFreeFlowManager" class="weaver.workflow.request.WFFreeFlowManager" scope="page"/>
<%
int workflowid = Util.getIntValue(request.getParameter("workflowid"),-1);
int rownum = Util.getIntValue(request.getParameter("rownum"),-1);
int indexnum = Util.getIntValue(request.getParameter("indexnum"),-1);
int startnodeid = Util.getIntValue(request.getParameter("startnodeid"),-1);
//html模板id
int old_inputmode = Util.getIntValue(request.getParameter("old_inputmode"),-1);
int inputmode = Util.getIntValue(request.getParameter("inputmode"),-1);
String deletenode = Util.null2String(request.getParameter("deletenode"));
int needdeletemode = 0;
String sql = "";
if (rownum > 0) { 

	for (int i = 0; i < indexnum; i++) {
		//是否要保存 0不管、1新增、2修改
		int ismodify = Util.getIntValue(request.getParameter("ismodify_" + i), 0);
		int wfnodeid = Util.getIntValue(request.getParameter("wfnodeid_" + i), 0);//节点id
		int floworder = Util.getIntValue(request.getParameter("floworder_" + i), 0);
		//System.out.println("ismodify = "+ismodify);
		if(ismodify == 0){
			//continue;
		}else if(ismodify == 1){
			
			String nodename = Util.null2String(request.getParameter("nodename_" + i));
			int Signtype = Util.getIntValue(request.getParameter("Signtype_" + i), 0);
			String operators = Util.null2String(request.getParameter("operators_" + i));
			int grouptype = Util.getIntValue(request.getParameter("grouptype_" + i), 0);
			int objid = Util.getIntValue(request.getParameter("objid_" + i), 0);
			if(operators.indexOf(",")==0){                        	
				operators=operators.substring(1);
			}
			int nodesign=Util.getIntValue(request.getParameter("nodetype_" + i), 2);//节点类型
			String IsPendingForward="0";//转发权限
			String isreject="0";
			//如果是审批节点
			if(nodesign==1){
				isreject="1";
			}
			if (!nodename.equals("") && grouptype!=0) {
				//创建新节点
				int newnodeid = WFFreeFlowManager.getNodeNewId(nodename);
				if (newnodeid > 0) {
					//更新新节点内容
	        		sql = "update workflow_nodebase set isstart='0',isreject='"+isreject+"',isreopen='0',isend='0',nodeattribute='0' "+
	                ",floworder=" + floworder + ",Signtype=" + Signtype + " where id=" + newnodeid;
	        		//System.out.println("创建新节点sql"+sql);
					rs.executeSql(sql);
				}
				//插入操作组
		        int newgroupid = WFFreeFlowManager.CreateNewGroup(nodename, newnodeid, 1);
		        if (newgroupid > -1) {
		            //插入操作组明细
	                sql = "insert into workflow_groupdetail (groupid,type,objid,level_n,level2_n,signorder,conditions,conditioncn,orders) values(" + newgroupid +
	                        ","+grouptype+"," + objid + ",0,100,'" + Signtype + "','','',0)";
	                //System.out.println("操作组明细sql"+sql);
		            rs.executeSql(sql);
		        }

				//Html模板 start
				WFFreeFlowManager.copyHtmlLayout(startnodeid, newnodeid);
		
				//插入流程流转节点
				sql = "select * from workflow_flownode ,workflow_nodebase  where nodeid=id and id=" + startnodeid;
                //System.out.println("sql = "+sql);
				rs.executeSql(sql);
                if (rs.next()) {
                    String nodeattribute = rs.getString("nodeattribute");
                    workflowid = rs.getInt("workflowid");
                    int drawxpos = rs.getInt("drawxpos");
                    int drawypos = rs.getInt("drawypos");
                    String nodetype = Util.null2String(rs.getString("nodetype"));
                    String IsFreeNode = Util.null2String(rs.getString("IsFreeNode"));
                    String viewnodeids = rs.getString("viewnodeids");
                    String ismode = rs.getString("ismode");
                    String showdes = rs.getString("showdes");
                    String printdes = rs.getString("printdes");
                    String isFormSignature = rs.getString("isFormSignature");
                    IsPendingForward = rs.getString("IsPendingForward");
                    String IsWaitForwardOpinion = rs.getString("IsWaitForwardOpinion");
                    String IsBeForward = rs.getString("IsBeForward");
                    String IsAlreadyForward = rs.getString("IsAlreadyForward");
                    String IsSubmitedOpinion = rs.getString("IsSubmitedOpinion");
                    String IsBeForwardSubmit = rs.getString("IsBeForwardSubmit");
                    String IsBeForwardModify = rs.getString("IsBeForwardModify");
                    String IsBeForwardPending = rs.getString("IsBeForwardPending");
                    String IsBeForwardTodo = rs.getString("IsBeForwardTodo");
                    String isBeForwardSubmitAlready = rs.getString("isBeForwardSubmitAlready");
                    String IsBeForwardSubmitNotaries = rs.getString("IsBeForwardSubmitNotaries");
                    String IsBeForwardAlready = rs.getString("IsBeForwardAlready"); 
                    String IsSubmitForward = rs.getString("IsSubmitForward");
                    String viewtypeall= rs.getString("viewtypeall");
                    String viewdescall= rs.getString("viewdescall");
                    String showtype= rs.getString("showtype");
                    String vtapprove= rs.getString("vtapprove");
                    String vtrealize= rs.getString("vtrealize");
                    String vtforward= rs.getString("vtforward");
                    String vtpostil= rs.getString("vtpostil");
                   	String vtHandleForward = rs.getString("vtHandleForward");  // 转办
					String vtTakingOpinions = rs.getString("vtTakingOpinions");  //征求意见
					String vttpostil=rs.getString("vttpostil");
					String vtrecipient=rs.getString("vtrecipient");
					String vtrpostil=rs.getString("vtrpostil");
                    String vtreject= rs.getString("vtreject");
                    String vtsuperintend= rs.getString("vtsuperintend");
                    String vtover= rs.getString("vtover");
                    String vdcomments= rs.getString("vdcomments");
                    String vddeptname= rs.getString("vddeptname");
                    String vdoperator= rs.getString("vdoperator");
                    String vddate= rs.getString("vddate");
                    String vdtime= rs.getString("vdtime");
                    String stnull= rs.getString("stnull");
                    String formsignaturewidth= rs.getString("formsignaturewidth");
                    String formsignatureheight= rs.getString("formsignatureheight");
                    String drawbackflag= rs.getString("drawbackflag");
                    String rejectbackflag= rs.getString("rejectbackflag");
                    String toexcel= rs.getString("toexcel");
                    String issignmustinput= rs.getString("issignmustinput");
                    String isfeedback= rs.getString("isfeedback");
                    String isnullnotfeedback= rs.getString("isnullnotfeedback");
                    String freewfsetcurnameen = Util.null2String(rs.getString("freewfsetcurnameen")).replaceAll("'", "''");
                    String freewfsetcurnametw = Util.null2String(rs.getString("freewfsetcurnametw")).replaceAll("'", "''");
                    String freewfsetcurnamecn = Util.null2String(rs.getString("freewfsetcurnamecn")).replaceAll("'", "''");
					
					sql = "insert into workflow_flownode(workflowid,nodeid,nodetype,viewnodeids,ismode,showdes,printdes,IsPendingForward,IsWaitForwardOpinion,IsBeForward,IsAlreadyForward,IsSubmitedOpinion,IsSubmitForward,IsFreeWorkflow," +
	                 	"viewtypeall,viewdescall,showtype,vtapprove,vtrealize,vtforward,vtpostil,vtTakingOpinions,vtHandleForward,vttpostil,vtrpostil,vtrecipient,vtreject,vtsuperintend,vtover,vdcomments,vddeptname,vdoperator,vddate,vdtime,stnull,formsignaturewidth,formsignatureheight," +
	                 	"drawbackflag,rejectbackflag,toexcel,issignmustinput,isfeedback,isnullnotfeedback,freewfsetcurnameen,freewfsetcurnametw,freewfsetcurnamecn,"+
	                 	"IsBeForwardSubmit,IsBeForwardModify,IsBeForwardPending,IsBeForwardTodo,isBeForwardSubmitAlready,IsBeForwardSubmitNotaries,IsBeForwardAlready,nodeorder) " +
	                 	" values(" + workflowid + "," + newnodeid + ",'"+nodesign+"','" + viewnodeids + "','2','"+showdes+"','" + printdes + "','" + IsPendingForward + "','" + IsWaitForwardOpinion + "','" + IsBeForward + "','" + IsAlreadyForward + "','" + IsSubmitedOpinion + "','" + IsSubmitForward + "','0'," +
	                 	"'"+viewtypeall+"','"+viewdescall+"','"+showtype+"','"+vtapprove+"','"+vtrealize+"','"+vtforward+"','"+vtpostil+"','"+vtTakingOpinions+"','"+vtHandleForward+"','"+vttpostil+"','"+vtrpostil+"','"+vtrecipient+"','"+vtreject+"','"+vtsuperintend+"','"+vtover+"','"+vdcomments+"','"+vddeptname+"','"+vdoperator+"','"+vddate+"','"+vdtime+"','"+stnull+"','"+
	                 	formsignaturewidth+"','"+formsignatureheight+"','"+drawbackflag+"','"+rejectbackflag+"','"+toexcel+"','"+issignmustinput+"','"+isfeedback+"','"+isnullnotfeedback+"', '"+freewfsetcurnameen+"', '"+freewfsetcurnametw+"','"+freewfsetcurnamecn+"','"+
	                 	IsBeForwardSubmit+"','"+IsBeForwardModify+"','"+IsBeForwardPending+"','"+IsBeForwardTodo+"','"+isBeForwardSubmitAlready+"','"+IsBeForwardSubmitNotaries+"','"+IsBeForwardAlready+"','"+floworder+"')";
					//System.out.println("插入流程流转节点sql"+sql);
					RecordSet.executeSql(sql);
                }
			}
		}else if(ismodify == 2){
			int nodesign=Util.getIntValue(request.getParameter("nodetype_" + i), 2);//节点类型
			if(old_inputmode != inputmode){
		    	ConnStatement statement=new ConnStatement();
		    	ConnStatement statement1=new ConnStatement();
		    	try {
			    	String nodehtmlsql="select datajson,pluginjson,scripts,workflowid,formid,isbill,type,layoutname,syspath,cssfile,htmlparsescheme,version,operuser from workflow_nodehtmllayout where id="+inputmode+" order by id";
			    	statement1.setStatementSql(nodehtmlsql);
			    	statement1.executeQuery();
			    	String layoutname_tmp="",syspath_tmp="",cssfile_tmp="",operuser_tmp="";
			    	String datajson="",pluginjson="",scripts="";
			    	int workflowid_tmp,formid_tmp,isbill_tmp,type_tmp,version_tmp,htmlparsescheme_tmp;
			    	//显示模板及打印模板
			    	while(statement1.next()){
			    		workflowid_tmp = Util.getIntValue(statement1.getString("workflowid"), 0);
			    		formid_tmp = Util.getIntValue(statement1.getString("formid"), 0);
						isbill_tmp = Util.getIntValue(statement1.getString("isbill"), 0);
						type_tmp = Util.getIntValue(statement1.getString("type"), 0);
						layoutname_tmp = Util.null2String(statement1.getString("layoutname"));
						syspath_tmp = Util.null2String(statement1.getString("syspath"));
						cssfile_tmp = Util.null2String(statement1.getString("cssfile"));
						htmlparsescheme_tmp = Util.getIntValue(statement1.getString("htmlparsescheme"), 0);
						version_tmp = Util.getIntValue(statement1.getString("version"),0);
						operuser_tmp = Util.null2String(statement1.getString("operuser"));
						if("oracle".equals(statement1.getDBType())){
		                    CLOB theclob = statement1.getClob(1);
		                    if(null!=theclob){
			                    String readline = "" ;
			                    StringBuffer clobStrBuff = new StringBuffer("") ;
			                    BufferedReader clobin = new BufferedReader(theclob.getCharacterStream());
			                    while ((readline = clobin.readLine()) != null) clobStrBuff = clobStrBuff.append(readline) ;
			                    clobin.close() ;
			                    datajson=clobStrBuff.toString();
		                    }
		                    CLOB theclob1 = statement1.getClob(2);
		                    if(null!=theclob1){
			                    String readline1 = "" ;
			                    StringBuffer clobStrBuff1 = new StringBuffer("") ;
			                    BufferedReader clobin1 = new BufferedReader(theclob1.getCharacterStream());
			                    while ((readline1 = clobin1.readLine()) != null) clobStrBuff1 = clobStrBuff1.append(readline1) ;
			                    clobin1.close() ;
			                    pluginjson=clobStrBuff1.toString();
		                    }
		                    CLOB theclob2 = statement1.getClob(3);
		                    if(null!=theclob2){
			                    String readline2 = "" ;
			                    StringBuffer clobStrBuff2 = new StringBuffer("") ;
			                    BufferedReader clobin2 = new BufferedReader(theclob2.getCharacterStream());
			                    while ((readline2 = clobin2.readLine()) != null) clobStrBuff2 = clobStrBuff2.append(readline2) ;
			                    clobin2.close() ;
			                    scripts=clobStrBuff2.toString();
		                    }
		                }else{
		                	datajson = statement1.getString("datajson");
		                	pluginjson = statement1.getString("pluginjson");
		                	scripts = statement1.getString("scripts");
		                }
						SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
						String currentDate = formatter.format(new Date());
						//插入
						if("oracle".equals(statement.getDBType())){
							sql = "insert into workflow_nodehtmllayout(workflowid,formid,isbill,nodeid,type,layoutname,syspath,cssfile,htmlParseScheme,version,operuser,opertime,datajson,pluginjson,scripts) values (?,?,?,?,?,?,?,?,?,?,?,?,empty_clob(),empty_clob(),empty_clob())";
						}else{
							sql = "insert into workflow_nodehtmllayout(workflowid,formid,isbill,nodeid,type,layoutname,syspath,cssfile,htmlParseScheme,version,operuser,opertime) values (?,?,?,?,?,?,?,?,?,?,?,?)";
						}
						statement.setStatementSql(sql);
						statement.setInt(1, workflowid_tmp);
						statement.setInt(2, formid_tmp);
						statement.setInt(3, isbill_tmp);
						statement.setInt(4, wfnodeid);
						statement.setInt(5, type_tmp);
						statement.setString(6, layoutname_tmp);
						statement.setString(7, syspath_tmp);
						statement.setString(8, cssfile_tmp);
						statement.setInt(9, htmlparsescheme_tmp);
						statement.setInt(10, version_tmp);
						statement.setString(11, operuser_tmp);
						statement.setString(12, currentDate);
						statement.executeUpdate();
						//取刚插入的modeid
						int cur_modeid=0;
						sql = "select max(id) as id from workflow_nodehtmllayout where workflowid="+workflowid_tmp+" and nodeid="+wfnodeid+" and type="+type_tmp;
						statement.setStatementSql(sql);
						statement.executeQuery();
						if(statement.next()){
							cur_modeid = Util.getIntValue(statement.getString("id"), 0);
						} 
						//插入大字段
						if("oracle".equals(statement.getDBType())){
			                sql = "select datajson,pluginjson,scripts from workflow_nodehtmllayout where id="+cur_modeid+" for update";
			                statement.setStatementSql(sql, false);
			                statement.executeQuery();
			                if(statement.next()){
			                    CLOB theclob = statement.getClob(1);
			                    char[] contentchar = datajson.toCharArray();
			                    Writer contentwrite = theclob.getCharacterOutputStream();
			                    contentwrite.write(contentchar);
			                    contentwrite.flush();
			                    contentwrite.close();
			                    
			                    CLOB theclob1 = statement.getClob(2);
			                    char[] contentchar1 = pluginjson.toCharArray();
			                    Writer contentwrite1 = theclob1.getCharacterOutputStream();
			                    contentwrite1.write(contentchar1);
			                    contentwrite1.flush();
			                    contentwrite1.close();
			                    
			                    CLOB theclob2 = statement.getClob(3);
			                    char[] contentchar2 = scripts.toCharArray();
			                    Writer contentwrite2 = theclob2.getCharacterOutputStream();
			                    contentwrite2.write(contentchar2);
			                    contentwrite2.flush();
			                    contentwrite2.close();
			                }
			            }else{
			            	sql="update workflow_nodehtmllayout set datajson=?,pluginjson=?,scripts=? where id="+cur_modeid;
			                statement.setStatementSql(sql);
			                statement.setString(1, datajson);
			                statement.setString(2, pluginjson);
			                statement.setString(3, scripts);
			                statement.executeUpdate();
			            }
			    	}
			    	needdeletemode ++;
		    	}catch(Exception e){
					e.printStackTrace();
		        }finally{
		        	try{
						statement.close();
						statement1.close();
					}catch(Exception e){
						e.printStackTrace();
					}
		        }
			}
			
			int grouptype = Util.getIntValue(request.getParameter("grouptype_" + i), 0);
			int objid = Util.getIntValue(request.getParameter("objid_" + i), 0);
			int Signtype = Util.getIntValue(request.getParameter("Signtype_" + i), 0);
			String nodename = Util.null2String(request.getParameter("nodename_" + i));
			//System.out.println("nodename = "+nodename);
			String groupid = "";
			if((grouptype==3&&objid!=0) || (grouptype!=3&&grouptype!=0)){
				//获取groupid
				sql = "select id from workflow_nodegroup where nodeid = "+wfnodeid;
				rs.executeSql(sql);
				if(rs.next()){
					groupid = Util.null2String(rs.getString("id"));
				}
				if(!"".equals(groupid)){
					//删除节点操作者明细
					sql = "delete from workflow_groupdetail where groupid = " + groupid;
		            rs.executeSql(sql);
		            //添加节点操作者明细
		            sql = "insert into workflow_groupdetail (groupid,type,objid,level_n,level2_n,signorder,conditions,conditioncn,orders) values(" + groupid +
	                        ","+grouptype+"," + objid + ",0,100,'" + Signtype + "','','',0)";
	                //System.out.println("操作组明细sql"+sql);
		            rs.executeSql(sql);
				}
				/*//更新新节点内容
        		sql = "update workflow_nodebase set nodename= '"+nodename+"'  where id=" + wfnodeid;
        		//System.out.println("创建新节点sql"+sql);
				rs.executeSql(sql);*/
			}
		}
		sql = "update workflow_flownode set nodeorder = '"+floworder+"' where workflowid = " + workflowid + " and nodeid = "+wfnodeid;
		rs.executeSql(sql);
		sql = "update workflow_nodebase set floworder = '"+floworder+"' where id = "+wfnodeid;
		//System.out.println("sql" + i + " = " + sql);
		rs.executeSql(sql);
	}

	if(needdeletemode > 0){
		sql = "delete from workflow_nodehtmllayout where workflowid = " + workflowid + " and id = " + inputmode;
		//System.out.println("删除modeid:" + inputmode);
		rs.executeSql(sql);
	}
}
if(!"".equals(deletenode)){//删除对应节点
	//int wfnodeid = Util.getIntValue(request.getParameter("wfnodeid_" + i), 0);//节点id
	String [] arraypara = Util.TokenizerString2(deletenode, ",");
	String wfnodeid = "";
	if(arraypara.length > 0){
		for(int c=0;c<arraypara.length;c++){
			wfnodeid = arraypara[c];
			sql = "delete from workflow_groupdetail where EXISTS(select 1 from workflow_nodegroup where workflow_groupdetail.groupid=workflow_nodegroup.id and workflow_nodegroup.nodeid = " + wfnodeid + ")";
	        rs.executeSql(sql);
	        sql = "delete from workflow_nodegroup where nodeid = " + wfnodeid;
	        rs.executeSql(sql);
	        //Html模式表
	        sql = "delete from workflow_nodehtmllayout where workflowid = " + workflowid + " and nodeid = " + wfnodeid;
	        rs.executeSql(sql);
	        sql = "delete from workflow_flownode where workflowid = " + workflowid + " and nodeid = " + wfnodeid;
	        rs.executeSql(sql);
	        sql = "delete from workflow_nodelink where workflowid = " + workflowid + " and nodeid = " + wfnodeid;
	        rs.executeSql(sql);
	        sql = "delete from workflow_nodebase where id = " + wfnodeid;
	        rs.executeSql(sql);
		}
	}
}

/*******位置计算start***********/
ConnStatement statement = null;
ConnStatement statement1 = null;
try{
	 statement = new ConnStatement();
     statement1 = new ConnStatement();
     int drawxpos = -1;
     int drawypos = -1;
	
	int destdrawxpos = 70;
	int destdrawypos = 0;
	sql = "delete FROM workflow_nodelink WHERE workflowid = "+workflowid;
	rs.executeSql(sql);
	//计算节点位置
	sql = "select max(drawypos) from workflow_nodebase where (IsFreeNode is null or IsFreeNode!='1') and EXISTS(select 1 from workflow_flownode b where workflow_nodebase.id=b.nodeid and b.workflowid=" + workflowid + ")";
	rs.executeSql(sql);
	if (rs.next()) {
	    destdrawypos = Util.getIntValue(rs.getString(1));
	}

	destdrawypos = 70;
	if (destdrawypos <= 0) {
	    destdrawypos = 70;
	} else {
	    //destdrawypos += 120;
	}
	//获得自由流程定义的步骤
	ArrayList newnodeids = new ArrayList();
	ArrayList newnodenames=new ArrayList();
	ArrayList newnodetypes = new ArrayList();
	sql = "select base.id,node.workflowid,base.nodename,node.nodetype,node.isFormSignature, "+
			 " node.IsPendingForward,base.operators,base.Signtype,base.floworder   "+
			 " from workflow_flownode node,workflow_nodebase base  "+
			 " where (base.IsFreeNode is null or base.IsFreeNode!='1') "+
			 " AND node.nodeid=base.id and node.workflowid = "+workflowid +
			 " order by node.nodetype, base.floworder  ";
	rs.executeSql(sql);
	while (rs.next()) {
	    newnodeids.add(Util.null2String(rs.getString(1)));
	    newnodenames.add(Util.null2String(rs.getString(3)));
	    newnodetypes.add(Util.null2String(rs.getString(4)));
	}
	boolean isnewrow = false;
	int predrawxpos = 0;
	int predrawypos = 0;
	String usednodetype = "";
	for (int i = 0; i < newnodeids.size(); i++) {
		usednodetype = Util.null2String(newnodetypes.get(i));
		if (i > 0 && i % 5 == 0) {     //一行最多显示5个节点
	        destdrawypos += 170;
	        destdrawxpos = 70;
	        isnewrow = true;
	    } else {
	        isnewrow = false;
	    }
	    //设置节点位置
	    sql = "update workflow_nodebase set drawxpos=" + destdrawxpos + ",drawypos=" + destdrawypos + " where id=" + newnodeids.get(i);
	    rs.executeSql(sql);
	    //流程出口
	    if (i == 0 || isnewrow) { //第一个节点或新行第一个节点
	        if (i != 0) {
	            sql = "insert into workflow_nodelink(workflowid,nodeid,destnodeid,linkname,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,ismustpass,isreject,nodepasstime) " +
	                    "values(" + workflowid + "," + newnodeids.get(i - 1) + "," + newnodeids.get(i) + ",'" + newnodenames.get(i) +
	                    "',4,12," + predrawxpos + "," + (predrawypos + 65) + "," + destdrawxpos + "," + (predrawypos + 65) + ",-1,-1,-1,-1,-1,-1,'','',-100)";
	        }
	        rs.executeSql(sql);
	    } else if (i == (newnodeids.size() - 1)) { //流程定义的最后一步
	        sql = "insert into workflow_nodelink(workflowid,nodeid,destnodeid,linkname,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,ismustpass,isreject,nodepasstime) " +
	                "values(" + workflowid + "," + newnodeids.get(i - 1) + "," + newnodeids.get(i) + ",'" + newnodenames.get(i) +
	                "',0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,'','',-100)";
	        rs.executeSql(sql);
	        //sql = "select * from workflow_nodelink where (isreject is null or isreject!='1') and workflowid=" + workflowid + " and nodeid=" + startnodeid + " and not EXISTS(select 1 from workflow_nodebase b where workflow_nodelink.destnodeid=b.id and b.IsFreeNode='1' and b.startnodeid=" + startnodeid + ") AND wfrequestid is null";
	        //rs.executeSql(sql);
	        //while (rs.next()) {}
	    } else {
	        sql = "insert into workflow_nodelink(workflowid,nodeid,destnodeid,linkname,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,ismustpass,isreject,nodepasstime) " +
	                "values(" + workflowid + "," + newnodeids.get(i - 1) + "," + newnodeids.get(i) + ",'" + newnodenames.get(i) +
	                "',0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,'','',-100)";
	        rs.executeSql(sql);
	    }
	    
	    if(usednodetype.equals("1")){
	    	if(isnewrow){
	    		sql = "insert into workflow_nodelink(workflowid,nodeid,destnodeid,linkname,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,ismustpass,isreject,nodepasstime) " +
	                    "values(" + workflowid + "," + newnodeids.get(i) + "," + newnodeids.get(i - 1) + ",'" + newnodenames.get(i) +
	                    "',12,4," + predrawxpos + "," + (predrawypos + 75) + "," + destdrawxpos + "," + (predrawypos + 75) + ",-1,-1,-1,-1,-1,-1,'','1',-100)";
	    		rs.executeSql(sql);
	    	}else{
		    	sql = "insert into workflow_nodelink(workflowid,nodeid,destnodeid,linkname,directionfrom,directionto,x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,ismustpass,isreject,nodepasstime) " +
		                "values(" + workflowid + "," + newnodeids.get(i) + "," + newnodeids.get(i - 1) + ",'" + newnodenames.get(i) +
		                "',0,8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,'','1',-100)";
		        rs.executeSql(sql);
	    	}
	    }
	    
	    predrawxpos = destdrawxpos;
	    predrawypos = destdrawypos;
	    destdrawxpos += 170;
	}
	
	//更新出口方向
	/*WFManager wfManager = new WFManager();
	wfManager.setWfid(workflowid);
	wfManager.getWfInfo();
	String isFree = wfManager.getIsFree();
	if(isFree != null && isFree.equals("1")){
		FreeWorkflowNode.updateNodeLinkDirection(""+workflowid, ""+requestid);
	}*/
} catch (Exception e) {
	e.printStackTrace();
	//清除垃圾数据
}finally{
	if(statement!=null)
		statement.close();
	if(statement1!=null)
		statement1.close();
}
/*******位置计算end***********/


////////////////////////
response.sendRedirect("/rdeploy/wf/request/wfEditInterface.jsp?isclose=1");
return;
///////////////////////
%>