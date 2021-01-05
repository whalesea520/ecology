
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.browserData.BrowserManager"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="java.util.Hashtable"%>
<%@ page import="java.util.StringTokenizer"%>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<%@ page import="weaver.general.StaticObj"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="weaver.formmode.tree.CustomTreeUtil"%>
<%@page import="weaver.formmode.tree.CustomTreeData"%>
<%@page import="weaver.workflow.field.HtmlElement"%>
<%@page import="weaver.workflow.field.FileElement"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="weaver.workflow.datainput.DynamicDataInput"%>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.workflow.request.WFFreeFlowManager"%>
<jsp:useBean id="requestPreAddM" class="weaver.workflow.request.RequestPreAddinoperateManager" scope="page" />
<jsp:useBean id="ResourceComInfo2" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo2" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo2" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rscount" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rscount02" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjectInfoComInfo2" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo2" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="deptVirComInfo2" class="weaver.hrm.companyvirtual.DepartmentVirtualComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo2" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="subCompVirComInfo2" class="weaver.hrm.companyvirtual.SubCompanyVirtualComInfo" scope="page"/>
<jsp:useBean id="DocComInfo2" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="rs_item" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CapitalComInfo2" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="WorkflowRequestComInfo2" class="weaver.workflow.workflow.WorkflowRequestComInfo" scope="page"/>
<jsp:useBean id="rs_count" class="weaver.conn.RecordSet" scope="page"/> <!--xwj for @td2977 20051111-->
<jsp:useBean id="WfLinkageInfo" class="weaver.workflow.workflow.WfLinkageInfo" scope="page"/>
<jsp:useBean id="WFNodeDtlFieldManager" class="weaver.workflow.workflow.WFNodeDtlFieldManager" scope="page" />
<jsp:useBean id="docReceiveUnitComInfo_mdbb" class="weaver.docs.senddoc.DocReceiveUnitComInfo" scope="page"/>
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean" %>

<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<!-- 明细样式 -->
<link href="/css/ecology8/workflowdetail_wev8.css" type="text/css" rel="stylesheet">

 <iframe id="datainputformdetail" frameborder=0 scrolling=no src=""  style="display:none" ></iframe>
<iframe id="selectChangeDetail" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<%

String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");//需要增加的代码
session.setAttribute("f_weaver_belongto_userid",f_weaver_belongto_userid);
session.setAttribute("f_weaver_belongto_usertype",f_weaver_belongto_usertype);
User user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
int userid=user.getUID();                   //当前用户id
int usertype = 0;


String selectDetailInitJsStr = "";
String initDetailIframeStr = "";
String selectDetailInitJsStrAdd = "";
String initDetailIframeStrAdd = "";
    String isaffirmance=Util.null2String(request.getParameter("isaffirmance"));//是否需要提交确认






    String reEdit=Util.null2String(request.getParameter("reEdit"));//是否为编辑






    String requestid=Util.null2String(request.getParameter("requestid"));

    int creater = Util.getIntValue(request.getParameter("creater"),0);              //请求的创建人
    int creatertype = Util.getIntValue(request.getParameter("creatertype"),0);        //创建人类型 0: 内部用户 1: 外部用户

    String needcheck="";
    String dlbodychangattrstr="";
    String formid=Util.null2String(request.getParameter("formid"));
    String nodeid=Util.null2String(request.getParameter("nodeid"));
	String workflowid=Util.null2String(request.getParameter("workflowid"));
	int beagenter_dt = 0;
	String beagenter=""+creater;//获得被代理人
	rs.executeSql("select agentorbyagentid from workflow_currentoperator where usertype=0 and isremark='0' and agenttype=2 and requestid=" + requestid  + " and nodeid=" + nodeid + " order by id desc");
	if(rs.next()){
	 int tembeagenter = rs.getInt(1);
        if (tembeagenter > 0) {
		beagenter_dt = tembeagenter;
        beagenter =""+tembeagenter;
        }
	}
		int body_isagent = 0;
	RecordSet.executeSql("select agenttype from workflow_agentConditionSet where  isCreateAgenter=1 and workflowid ="+ workflowid + "and bagentuid="+ beagenter_dt +" order by agenttype desc");
	if(RecordSet.next()){
	int body_isagent_dt = RecordSet.getInt(1);
	body_isagent = body_isagent_dt;
	}
    //String isbill=Util.null2String(request.getParameter("isbill"));
	String isbill="1";
    String currentdate=Util.null2String(request.getParameter("currentdate"));
	String currenttime=Util.null2String(request.getParameter("currenttime"));
	String currentyear="";
	if(currentdate!=null&&currentdate.indexOf("-")>=0){
		currentyear=currentdate.substring(0,currentdate.indexOf("-"));
	}
    int isremark=Util.getIntValue(request.getParameter("isremark"),0);
    String nodetype=Util.null2String(request.getParameter("nodetype"));
    String docfileid=Util.null2String(request.getParameter("docfileid"));
    String newdocid=Util.null2String(request.getParameter("newdocid"));
    ArrayList seldefieldsdemanage=WfLinkageInfo.getSelectField(Util.getIntValue(workflowid),Util.getIntValue(nodeid),1);
    ArrayList changedefieldsdemanage=WfLinkageInfo.getChangeField(Util.getIntValue(workflowid),Util.getIntValue(nodeid),1);
    boolean IsCanModify="true".equals(session.getAttribute(user.getUID()+"_"+requestid+"IsCanModify"))?true:false;
    boolean editdetailbodyflag=false;
    if((isremark==0||IsCanModify) && (!isaffirmance.equals("1") || !nodetype.equals("0") || reEdit.equals("1"))) editdetailbodyflag=true;
    //当自由流程设置当前节点的表单不可以编辑时，则全部表单字段都禁止编辑






    if( !WFFreeFlowManager.allowFormEdit(requestid, nodeid) ){
        editdetailbodyflag = false;
    }
    
    
    ArrayList deuploadfieldids = new ArrayList();
    
    Hashtable otherPara_hs = new Hashtable();
	
    
    //当前登录用户所用语言id
    otherPara_hs.put("languageId", "" + user.getLanguage());
    
    boolean isurger = Util.null2String(request.getParameter("isurger")).equalsIgnoreCase("true");
    boolean wfmonitor = Util.null2String(request.getParameter("wfmonitor")).equalsIgnoreCase("true");
        
      String canDelAcc = "";
      String smsAlertsType = "";
      //微信提醒(QC:98106)
      String chatsAlertType = "";
      rs.executeSql("select candelacc,smsAlertsType,chatsAlertType from workflow_base where id=" + workflowid);
      if (rs.next()) {
        canDelAcc = Util.null2String(rs.getString("candelacc"));
        smsAlertsType = Util.null2String(rs.getString("smsAlertsType"));
        chatsAlertType = Util.null2String(rs.getString("chatsAlertType"));
      }
    
      
      //otherPara_hs.put("iscreate", "" + iscreate);
      //otherPara_hs.put("version", "" + version);
      otherPara_hs.put("beagenter", "" + beagenter);
	  otherPara_hs.put("httprequest", request);
	  otherPara_hs.put("requestid", ""+requestid);
	  otherPara_hs.put("userid", ""+user.getUID());
	  otherPara_hs.put("workflowid", "" + workflowid);
      otherPara_hs.put("isremark", "" + isremark);
      otherPara_hs.put("nodeid", "" + nodeid);
      otherPara_hs.put("isbill", "" + isbill);
      otherPara_hs.put("nodetype", "" + nodetype);
      otherPara_hs.put("canDelAcc", canDelAcc);
    
      otherPara_hs.put("isprint", "0");
      otherPara_hs.put("wfmonitor", "" + wfmonitor);
      otherPara_hs.put("isurger", "" + isurger);
      
      otherPara_hs.put("changedefieldsadd", changedefieldsdemanage);
      
      
      String docCategory = "";
	  String sqlWfMessage = "select a.messagetype,a.chatstype,b.chatstype as wfChatsType,b.docCategory,b.messagetype as wfMessageType from workflow_requestbase a,workflow_base b where a.workflowid=b.id and a.requestid="
			              + requestid;
	  RecordSet.executeSql(sqlWfMessage);
	  if (RecordSet.next()) {
		   docCategory = RecordSet.getString("docCategory");
	  }
	  Map secCategorys = new HashMap();
	  secCategorys.put("", docCategory);
	  Map secMaxUploads = new HashMap();//封装选择目录的信息




      int secid = -1;
      if(docCategory.indexOf(',') == -1){
          secid = Util.getIntValue(docCategory, -1);;
      }else{
          secid = Util.getIntValue(docCategory.substring(docCategory
			.lastIndexOf(",") + 1), -1);
      }
	  int maxUploadImageSize = Util.getIntValue(SecCategoryComInfo1
			.getMaxUploadFileSize("" + secid), 5); //从缓存中取




	  if (maxUploadImageSize <= 0) {
		  maxUploadImageSize = 5;
	  }
	  secMaxUploads.put("", maxUploadImageSize + "");
	  int uploadType = 0;
	  String selectedfieldid = "";
	  String result = RequestManager.getUpLoadTypeForSelect(Util.getIntValue(workflowid));
	  if (!result.equals("")) {
		selectedfieldid = result.substring(0, result.indexOf(","));
		uploadType = Integer.valueOf(result.substring(result.indexOf(",") + 1)).intValue();
	  }
	  boolean isCanuse = RequestManager.hasUsedType(Util.getIntValue(workflowid));
	  if (selectedfieldid.equals("") || selectedfieldid.equals("0")) {
		isCanuse = false;
	  }
	  //如果附件存放方式为选择目录，则重置默认值



	  if (uploadType == 1) {
		maxUploadImageSize = 5;
	  }
	  String sql_upload = "";
 	  if(isCanuse&&uploadType==1){
			String fieldName="";//字段名称
			String fieldValue="";//字段的值



			String tableName="workflow_form";
			if(isbill.equals("0")){//如果不为单据，即为表单



				sql_upload=" select fieldName,fieldHtmlType,type from workflow_formdict where id="+selectedfieldid;
			}else{//否则为单据



				rs.executeSql(" select tableName from workflow_bill where id="+formid);
				if(rs.next()){
					tableName=rs.getString(1);
				}
				sql_upload=" select fieldName,fieldHtmlType,type from workflow_billfield where (viewtype is null or viewtype<>1) and id= "+selectedfieldid;
			}
			rs.executeSql(sql_upload);
			if(rs.next()){
				fieldName=rs.getString(1);
			}
				
			if(fieldName!=null&&!(fieldName.trim().equals(""))
			 &&tableName!=null&&!(tableName.trim().equals(""))){			
				rs.executeSql(" select "+fieldName+" from "+tableName+" where requestid= "+requestid);			
				if(rs.next()){
					fieldValue=Util.null2String(rs.getString(1));
				}
			}			
			char flag = Util.getSeparator();
			rs.executeProc("workflow_SelectItemSelectByid", ""+selectedfieldid+flag+isbill);
			while(rs.next()){
				String tmpselectvalue = Util.null2String(rs.getString("selectvalue"));
				String isdefault = Util.null2String(rs.getString("isdefault"));
				String tdocCategory = Util.null2String(rs.getString("docCategory"));
				
				int tsecid = Util.getIntValue(tdocCategory.substring(tdocCategory.lastIndexOf(",")+1),-1);
				String tMaxUploadFileSize = ""+Util.getIntValue(SecCategoryComInfo1.getMaxUploadFileSize(""+tsecid),-1);
                   
				if(!"".equals(tdocCategory)&&(("y".equals(isdefault)&&fieldValue.trim().equals(""))||tmpselectvalue.equals(fieldValue))){
					maxUploadImageSize = Util.getIntValue(tMaxUploadFileSize,5);
					docCategory = tdocCategory;
				}
			}
     }
     otherPara_hs.put("docCategory", docCategory+"");
     otherPara_hs.put("maxUploadImageSize", maxUploadImageSize+"");
      
      							

    ArrayList defieldids=new ArrayList();             //字段队列
    ArrayList defieldorders = new ArrayList();        //字段显示顺序队列 (单据文件不需要)
    ArrayList delanguageids=new ArrayList();          //字段显示的语言(单据文件不需要)
    ArrayList defieldlabels=new ArrayList();          //单据的字段的label队列
    ArrayList defieldhtmltypes=new ArrayList();       //单据的字段的html type队列
    ArrayList defieldtypes=new ArrayList();           //单据的字段的type队列
    ArrayList defieldnames=new ArrayList();           //单据的字段的表字段名队列
    ArrayList defieldviewtypes=new ArrayList();       //单据是否是detail表的字段1:是 0:否(如果是,将不显示)
    ArrayList defieldqfws=new ArrayList(); 
    
     ArrayList deimgwidths=new ArrayList(); 
     ArrayList deimgheights=new ArrayList(); 
    
    
    
    
    // 确定字段是否显示，是否可以编辑，是否必须输入
    ArrayList isdefieldids=new ArrayList();              //字段队列
    ArrayList isdeviews=new ArrayList();              //字段是否显示队列
    ArrayList isdeedits=new ArrayList();              //字段是否可以编辑队列
    ArrayList isdemands=new ArrayList();              //字段是否必须输入队列
	ArrayList colCalAry = new ArrayList();
	boolean defshowsum=false;
	ArrayList childfieldids = new ArrayList();			//子字段id队列
    int qfws=0;
	ArrayList inoperatefields = new ArrayList();
    ArrayList inoperatevalues = new ArrayList();
    int fieldop1id=0;
    requestPreAddM.setCreater(user.getUID());
    requestPreAddM.setOptor(user.getUID());
    requestPreAddM.setWorkflowid(Util.getIntValue(workflowid));
    requestPreAddM.setNodeid(Util.getIntValue(nodeid));
    requestPreAddM.setRequestid(Util.getIntValue(requestid));
    Hashtable getPreAddRule_hs = requestPreAddM.getPreAddRule();
    inoperatefields = (ArrayList)getPreAddRule_hs.get("inoperatefields");
    inoperatevalues = (ArrayList)getPreAddRule_hs.get("inoperatevalues");

	ArrayList fieldrealtype=new ArrayList(); 
	int fieldlen=0;  //字段类型长度
	String fielddbtype="";                              //字段数据类型
    String isdeview="0" ;    //字段是否显示
    String isdeedit="0" ;    //字段是否可以编辑
    String isdemand="0" ;    //字段是否必须输入
    String defieldid="";
    String defieldname = "" ;                         //字段数据库表中的字段名






    String defieldhtmltype = "" ;                     //字段的页面类型






    String defieldtype = "" ;                         //字段的类型






    String defieldlable = "" ;                        //字段显示名




    
    String deimgwidth = "50";
    String deimgheight = "50";


    String defieldvalue="";
    String textheight1 = "4";//xwj for @td2977 20051111
    int delanguageid = 0 ;
    int colcount1 = 0;
    int colwidth1 = 0;
    String rowCalItemStr1,colCalItemStr1,mainCalStr1;
	rowCalItemStr1 = new String("");
	colCalItemStr1 = new String("");
    mainCalStr1 = new String("");
   
    int detailno=0;
    int detailsum=0;
    String sql = "" ;
    char flag = Util.getSeparator() ;
    int derecorderindex = 0 ;
	 //获得触发字段名






	DynamicDataInput ddidetail=new DynamicDataInput(workflowid+"");
	String trrigerdetailfield=ddidetail.GetEntryTriggerDetailFieldName();
	
    String bclick = "";
    String isbrowisMust = "";
    //对不同的模块来说,可以定义自己相关的内容，作为请求默认值，比如将 docid 赋值，作为该请求的默认文档
    //默认的值可以赋多个，中间用逗号格开
    
    String prjid = Util.null2String(request.getParameter("prjid"));
    String docid = Util.null2String(request.getParameter("docid"));
    String crmid = Util.null2String(request.getParameter("crmid"));
    String hrmid = Util.null2String(request.getParameter("hrmid"));
    if(hrmid.equals("") && user.getLogintype().equals("1")) hrmid = "" + user.getUID() ;
    if(crmid.equals("") && user.getLogintype().equals("2")) crmid = "" + user.getUID() ;
    RecordSet billrs=new RecordSet();


              RecordSet.execute("select * from workflow_formdetailinfo where formid="+formid);
				while(RecordSet.next()){
					rowCalItemStr1 = Util.null2String(RecordSet.getString("rowCalStr"));
					colCalItemStr1 = Util.null2String(RecordSet.getString("colCalStr"));
					mainCalStr1 = Util.null2String(RecordSet.getString("mainCalStr"));
                    //System.out.println("colCalItemStr1 = " + colCalItemStr1);
				}
              StringTokenizer stk = new StringTokenizer(colCalItemStr1,";");
              while(stk.hasMoreTokens()){
                colCalAry.add(stk.nextToken());
              }
			  billrs.execute("select tablename,title,orderid from Workflow_billdetailtable where billid="+formid+" order by orderid");
              //System.out.println("select tablename,title from Workflow_billdetailtable where billid="+formid+" order by orderid");
              while(billrs.next()){
                String tablename=billrs.getString("tablename");
                String tabletitle=billrs.getString("title");
                int orderid = billrs.getInt("orderid");
                boolean deshowaddbutton=false;
                defieldids.clear() ;
                defieldlabels.clear() ;
                defieldhtmltypes.clear() ;
                defieldtypes.clear() ;
                defieldnames.clear() ;
                defieldviewtypes.clear() ;
				fieldrealtype.clear() ;
				childfieldids.clear();
				defieldqfws.clear();
				
				deimgwidths.clear();
                deimgheights.clear();
				
				defshowsum=false;
				colcount1 = 0;

                rs.execute("select * from workflow_billfield where viewtype='1' and billid="+formid+" and detailtable='"+tablename+"' ORDER BY dsporder");
                //System.out.println("select * from workflow_billfield where viewtype='1' and billid="+formid+" and detailtable='"+tablename+"'");
                while(rs.next()){
                    //String theviewtype = Util.null2String(rs.getString("viewtype")) ;
                    //if( !theviewtype.equals("1") ) continue ;   // 如果是单据的主表字段,不显示






                    defieldids.add(Util.null2String(rs.getString("id")));
                    defieldlabels.add(SystemEnv.getHtmlLabelName(Util.getIntValue(rs.getString("fieldlabel")),user.getLanguage()));
                    defieldhtmltypes.add(Util.null2String(rs.getString("fieldhtmltype")));
                    defieldtypes.add(Util.null2String(rs.getString("type")));
                    defieldnames.add(Util.null2String(rs.getString("fieldname")));
					fieldrealtype.add(Util.null2String(rs.getString("fielddbtype")));
					childfieldids.add(""+Util.getIntValue(rs.getString("childfieldid"), 0));
					 
					
					 defieldqfws.add(""+Util.getIntValue(rs.getString("qfws"), 0));
                    //defieldviewtypes.add(theviewtype);
                    
                    deimgwidths.add(""+Util.getIntValue(rs.getString("imgwidth"), 50));
                    deimgheights.add(""+Util.getIntValue(rs.getString("imgheight"), 50));
                }

                // 确定字段是否显示，是否可以编辑，是否必须输入
                isdefieldids.clear() ;              //字段队列
                isdeviews.clear() ;              //字段是否显示队列
                isdeedits.clear() ;              //字段是否可以编辑队列
                isdemands.clear() ;              //字段是否必须输入队列

                //RecordSet.executeProc("workflow_FieldForm_Select",nodeid+"");
                rs.execute("SELECT DISTINCT a.*, b.dsporder FROM workflow_nodeform a ,workflow_billfield b where a.fieldid = b.id and b.viewtype='1' and b.billid ="+formid+" and a.nodeid="+nodeid+" and b.detailtable='"+tablename+"' ORDER BY b.dsporder");
                //System.out.println("SELECT DISTINCT a.*, b.dsporder FROM workflow_nodeform a ,workflow_billfield b where a.fieldid = b.id and b.viewtype='1' and b.billid ="+formid+" and a.nodeid="+nodeid+" and b.detailtable='"+tablename+"' ORDER BY b.dsporder");
                
                while(rs.next())
                {
                    String thedefieldid = Util.null2String(rs.getString("fieldid")) ;
                    //System.out.println("thedefieldid:"+thedefieldid);
                    int thefieldidindex = defieldids.indexOf( thedefieldid ) ;
                    if( thefieldidindex == -1 )
                    {
                        continue ;
                    }
                    String theisdeview = Util.null2String(rs.getString("isview")) ;
                    if( theisdeview.equals("1") ) 
                    {
						colcount1 ++ ;
						if(!defshowsum)
						{
	                        if(colCalAry.indexOf("detailfield_"+thedefieldid)>-1)
	                        {
	                            defshowsum=true;
	                        }
                        }
					}
                    String theisedit = Util.null2String(rs.getString("isedit")) ;
                    if(theisedit.equals("1"))
                    {
                    	if(!deshowaddbutton) deshowaddbutton=true;
                    }
                    isdefieldids.add(thedefieldid);
                    isdeviews.add(theisdeview);
                    isdeedits.add(theisedit);
                    isdemands.add(Util.null2String(rs.getString("ismandatory")));
                }                                

								//获取明细表设置


				detailno = orderid-1;
                WFNodeDtlFieldManager.setNodeid(Integer.parseInt(nodeid));
                WFNodeDtlFieldManager.setGroupid(detailno);
                WFNodeDtlFieldManager.selectWfNodeDtlField();
                String dtladd = WFNodeDtlFieldManager.getIsadd();
                String dtledit = WFNodeDtlFieldManager.getIsedit();
                String dtldelete = WFNodeDtlFieldManager.getIsdelete();
                String dtldefault = WFNodeDtlFieldManager.getIsdefault();
                String dtlneed = WFNodeDtlFieldManager.getIsneed();
				 //zzl
                String dtlmul=WFNodeDtlFieldManager.getIsopensapmul();
                
                if(colcount1 <= 0){ //if start
                    continue;
                }
				 
             //   if(colcount1>0){    //if start
                    colwidth1=97/colcount1;
					detailsum++;
					
					ArrayList viewfieldnames = new ArrayList();

                    // 得到每个字段的信息并在页面显示






					int isfieldidindex = -1;
                    
					String submitdtlid="";
%>

<wea:layout>
		     <wea:group context='<%=SystemEnv.getHtmlLabelName(84496,user.getLanguage()) + (detailno + 1) %>'>
			     <wea:item type="groupHead">
						<%if(!editdetailbodyflag||isremark==5||isremark==9||nodetype.equals("3")){%>
			            &nbsp;
			            <%}else{ %>
							<%
                            if(dtlmul.equals("1")){%>
                            <input type=button class="sapbtn" accessKey=P onclick="addSapRow<%=detailno%>(<%=detailno%>)"  title="SAP"></input>
                            <%}%>
                            
                            <%if(dtladd.equals("1")){%>
                            <input type=button class="addbtn" accessKey=A onclick="addRow<%=detailno%>(<%=detailno%>)"  title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input>
                            <%}%>
                            <%if(dtladd.equals("1")||dtldelete.equals("1")){%>
                            <input type=button class="delbtn" accessKey=E onclick="deleteRow1(<%=detailno%>);"  title="<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>"></input>
                            <%}%>
                        <%
                        } %>
						</wea:item>
						
						<wea:item attributes="{\"isTableList\":\"true\", 'id':'detailblockTD'}">
<div style="width:100%!important;height:100%;overflow-x:auto;overflow-y:hidden;">
							<!-- <div id="workflowDetailArea"> -->
                            <table Class="ListStyle ViewForm" id="oTable<%=detailno%>" >
                              <COLGROUP>
                              <TBODY>
                              <tr class=header>
                                <th width="3%">　</th>
								<th width="4%" style="white-space:nowrap;"><%=SystemEnv.getHtmlLabelName(15486,user.getLanguage())%></th>
								
                   <%     
                       for (int i = 0; i < defieldids.size(); i++) {         // header循环开始







                           defieldid=(String)defieldids.get(i);  //字段id
                           isfieldidindex = isdefieldids.indexOf(defieldid) ;
                           if( isfieldidindex != -1 ) {
                        	   isdeview=(String)isdeviews.get(isfieldidindex);    //字段是否显示
                        	   isdeedit=(String)isdeedits.get(isfieldidindex);    //字段是否可以编辑
                        	   isdemand=(String)isdemands.get(isfieldidindex);    //字段是否必须输入
                           }
                           
                           if ("1".equals(isdeedit)) {
                 		      isbrowisMust = "1";
                 		  }
                 		  
                 		  if ("1".equals(isdemand)) {
                 		      isbrowisMust = "2";
                 		  }
                           
                		   defieldlable =(String)defieldlabels.get(i);
                		   defieldname = (String)defieldnames.get(i);
                		   defieldhtmltype = (String) defieldhtmltypes.get(i);
                		   
                		   
                		  if( ! isdeview.equals("1") ) continue;  //不显示即进行下一步循环






                           viewfieldnames.add(defieldname);
                           if(colcount1!=0){
                   %>
                                <th width="<%=colwidth1%>%" style="white-space:nowrap;" align="center"><%=defieldlable%></th>
                           <%   }
                       }     //header 循环结束
                               if(colcount1!=0){
                    %>
                              </tr>
                        <%      }
                        boolean isttLight = false;
                        String maintable="";
                        derecorderindex = 0 ;
                        rs.executeSql(" select tablename from Workflow_bill where id="+formid);
                        if(rs.next()){
                            maintable=rs.getString("tablename");
                            RecordSet rs3=new RecordSet();
                            //System.out.println("select b.* from "+maintable+" a,"+tablename+" b where a.id=b.mainid and a.requestid ="+requestid);
                            if((maintable.indexOf("formtable_main_")==0 || maintable.indexOf("uf_")==0)
                            		&& (tablename.indexOf("formtable_main_")==0 || tablename.indexOf("uf_")==0)){//新表单






                                rs3.executeSql("select b.* from "+maintable+" a,"+tablename+" b where a.id=b.mainid and a.requestid ="+requestid+" order by b.id");
                            }else if(Util.getIntValue(formid)<0){     //数据中心模块创建的明细报表






                                rs3.executeSql("select b.* from "+maintable+" a,"+tablename+" b where a.id=b.mainid and a.requestid ="+requestid+" order by b.inputid");
                            }else{
                                rs3.executeSql("select b.* from "+maintable+" a,"+tablename+" b where a.id=b.mainid and a.requestid ="+requestid);
                            }
                            while(rs3.next()){
                                String maincolvalue=rs3.getString(1);
                                String[] colnames = rs3.getColumnName();
                                if (colnames != null) {
                                    for (int m = 0; m < colnames.length; m++) {
                                        if (colnames[m].toUpperCase().equals("ID")) {
                                            maincolvalue = rs3.getString("id");
                                            break;
                                        } else if (colnames[m].toUpperCase().equals("INPUTID")) {
                                            maincolvalue = rs3.getString("inputid");
                                            break;
                                        }
                                    }
                                }
                                isttLight = !isttLight ;
                                if(colcount1!=0){
                        %>
                        <TR class="wfdetailrowblock">
                        <td width="4%">
                        <input type='checkbox' name='check_node<%=detailno%>' value="<%=derecorderindex%>" <%if(!dtldelete.equals("1")||!editdetailbodyflag||isremark==5||nodetype.equals("3")){%>disabled<%}%>>
                        <input type='hidden' name='dtl_id_<%=detailno%>_<%=derecorderindex%>' value="<%=maincolvalue%>">
                        </td>
                        <td><%=derecorderindex+1%></td>
                        <%         }
                                for(int i=0;i<defieldids.size();i++){         // 明细记录循环开始






                                    defieldid=(String)defieldids.get(i);  //字段id
                                    defieldname = (String)defieldnames.get(i);  //字段名






                                    //System.out.println("defieldname:"+defieldname);
                                    defieldtype = (String)defieldtypes.get(i);
                                    String trrigerdetailStr = "";
									if (trrigerdetailfield.indexOf("field"+defieldid)>=0){
										trrigerdetailStr = "datainputd(field" + defieldid + "_"+derecorderindex+")";
									}

                                    isfieldidindex = isdefieldids.indexOf(defieldid) ;
                                    if( isfieldidindex != -1 ) {
                                 	   isdeview=(String)isdeviews.get(isfieldidindex);    //字段是否显示
                                 	   isdeedit=(String)isdeedits.get(isfieldidindex);    //字段是否可以编辑
                                 	   isdemand=(String)isdemands.get(isfieldidindex);    //字段是否必须输入
                                    }
                                    defieldhtmltype = (String) defieldhtmltypes.get(i);
									defieldlable =(String)defieldlabels.get(i);
									 fielddbtype=(String)fieldrealtype.get(i);
									 qfws=Util.getIntValue(""+defieldqfws.get(i));
									 
									 
									 deimgwidth = (String) deimgwidths.get(i);
                		             deimgheight = (String) deimgheights.get(i);
									 
									
									 fieldlen=0;
									if ((fielddbtype.toLowerCase()).indexOf("varchar")>-1)
									{
									   fieldlen=Util.getIntValue(fielddbtype.substring(fielddbtype.indexOf("(")+1,fielddbtype.length()-1));
									
									}
									if(!"1".equals(dtledit)){
										isdeedit="0";
										isdemand="0";
									}
                                    if(isremark==5 || isremark==9){
                                        isdeedit = "0";//抄送(需提交)不可编辑
                                        isdemand="0";
                                    }
                                    //if( ! isdeview.equals("1") ) continue;  //不显示即进行下一步循环






                                    defieldvalue=Util.null2String(rs3.getString(defieldname)) ;
                                    //System.out.println("defieldvalue:"+defieldvalue);
                                    if (isdemand.equals("1"))   //如果必须输入,加入必须输入的检查中
                                      needcheck += ",field" + defieldid + "_"+derecorderindex;
                                    if(colcount1!=0){
                        
                       if(  isdeview.equals("1") ) {%> <td <%if(defieldhtmltype.equals("1") && !isdeedit.equals("1") && (defieldtype.equals("2") || defieldtype.equals("3"))){%> align="right" style="TEXT-VALIGN: right" <%}else{%> style="LEFT: 0px; WIDTH: <%=colwidth1%>%; word-wrap:break-word;word-break:break-all;TEXT-VALIGN: center"<%}%>>
                        <%    }        }
                                     if(defieldhtmltype.equals("1")){                          // 单行文本框






                                        if(defieldtype.equals("1")){                          // 单行文本框中的文本






                                            if(isdeedit.equals("1") && colcount1!=0 && editdetailbodyflag){
                                                if(isdemand.equals("1")) {
                                          %>
                                          <input datatype="text" viewtype='<%=isdemand%>' temptitle='<%=defieldlable%>' type=text class=inputstyle id="field<%=defieldid%>_<%=derecorderindex%>"  name="field<%=defieldid%>_<%=derecorderindex%>" size=15 value="<%=Util.toScreenToEdit(defieldvalue,user.getLanguage())%>" onChange="checkinput2('field<%=defieldid%>_<%=derecorderindex%>','field<%=defieldid%>_<%=derecorderindex%>span',this.getAttribute('viewtype'));checkLength('field<%=defieldid%>_<%=derecorderindex%>','<%=fieldlen%>','<%=defieldlable%>','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>');<%=trrigerdetailStr%>">
                                          <span id="field<%=defieldid%>_<%=derecorderindex%>span"><% if(defieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
                                          <%

                                                }else{%>
                                                <input datatype="text" viewtype='<%=isdemand%>' temptitle='<%=defieldlable%>' type=text class=inputstyle  onchange="checkinput2('field<%=defieldid%>_<%=derecorderindex%>','field<%=defieldid%>_<%=derecorderindex%>span',this.getAttribute('viewtype'));checkLength('field<%=defieldid%>_<%=derecorderindex%>','<%=fieldlen%>','<%=defieldlable%>','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>');<%=trrigerdetailStr%>" id="field<%=defieldid%>_<%=derecorderindex%>" name="field<%=defieldid%>_<%=derecorderindex%>" value="<%=Util.toScreenToEdit(defieldvalue,user.getLanguage())%>" size=15>
                                                <span id="field<%=defieldid%>_<%=derecorderindex%>span"></span>
                                          <%            }
                                          if(changedefieldsdemanage.indexOf(defieldid)>=0){
                                        %>
                                            <input type=hidden name="oldfieldview<%=defieldid%>_<%=derecorderindex%>" value="<%=Util.getIntValue(isdeview,0)+Util.getIntValue(isdeedit,0)+Util.getIntValue(isdemand,0)%>" />
                                        <%
                                            }
                                            }
                                            else {if(isdeview.equals("1") && colcount1!=0){
                                          %>
                                            <span id="field<%=defieldid%>_<%=derecorderindex%>span"><%=Util.toScreen(defieldvalue,user.getLanguage())%></span>
                                          <%
                                          }
                                          %>
                                            <input type=hidden class=Inputstyle id="field<%=defieldid%>_<%=derecorderindex%>" name="field<%=defieldid%>_<%=derecorderindex%>" value="<%=Util.toScreenToEdit(defieldvalue,user.getLanguage())%>">
                                          <%
                                            }
                                        }
                                        else if(defieldtype.equals("2")){                     // 单行文本框中的整型






                                            if(isdeedit.equals("1") && colcount1!=0 && editdetailbodyflag){
                                                if(isdemand.equals("1")) {
                                          %>
                                          <input datalength="0" datetype="int" datatype="int" viewtype='<%=isdemand%>' temptitle='<%=defieldlable%>' type=text class=inputstyle id="field<%=defieldid%>_<%=derecorderindex%>"  name="field<%=defieldid%>_<%=derecorderindex%>" size=15 value="<%=defieldvalue%>"
                                          onKeyPress="ItemCount_KeyPress()" onChange="checkcount1(this);checkItemScale(this,'<%=SystemEnv.getHtmlLabelName(31181,user.getLanguage()).replace("12","9")%>',-999999999,999999999);checkinput2('field<%=defieldid%>_<%=derecorderindex%>','field<%=defieldid%>_<%=derecorderindex%>span',this.getAttribute('viewtype'));calSum(<%=detailno%>);<%=trrigerdetailStr%>">
                                          <span id="field<%=defieldid%>_<%=derecorderindex%>span"><% if(defieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
                                           <%

                                                }else{%>
                                                <input datalength="0" datetype="int" datatype="int"  viewtype='<%=isdemand%>' temptitle='<%=defieldlable%>' type=text class=inputstyle id="field<%=defieldid%>_<%=derecorderindex%>"  name="field<%=defieldid%>_<%=derecorderindex%>" size=15 value="<%=defieldvalue%>" onKeyPress="ItemCount_KeyPress()" onblur="checkcount1(this);checkItemScale(this,'<%=SystemEnv.getHtmlLabelName(31181,user.getLanguage()).replace("12","9")%>',-999999999,999999999);checkinput2('field<%=defieldid%>_<%=derecorderindex%>','field<%=defieldid%>_<%=derecorderindex%>span',this.getAttribute('viewtype'));calSum(<%=detailno%>);<%=trrigerdetailStr%>">
                                                <span id="field<%=defieldid%>_<%=derecorderindex%>span"></span>
                                           <%           }
                                           if(changedefieldsdemanage.indexOf(defieldid)>=0){
                                        %>
                                            <input type=hidden name="oldfieldview<%=defieldid%>_<%=derecorderindex%>" value="<%=Util.getIntValue(isdeview,0)+Util.getIntValue(isdeedit,0)+Util.getIntValue(isdemand,0)%>" />
                                        <%
                                            }
                                            }
                                            else {if(isdeview.equals("1") && colcount1!=0){
                                           %>
                                            <span id="field<%=defieldid%>_<%=derecorderindex%>span"><%=defieldvalue%></span>
                                           <%
                                          }
                                          %>
                                            <input datalength="0" datetype="int" datatype="int"  type=hidden class=Inputstyle id="field<%=defieldid%>_<%=derecorderindex%>" name="field<%=defieldid%>_<%=derecorderindex%>" value="<%=defieldvalue%>">
                                          <%
                                            }
                                        }
                                        else if(defieldtype.equals("3")||defieldtype.equals("5")){                     // 单行文本框中的浮点型
                                        	int decimaldigits_t = 2;
                            		    	if(defieldtype.equals("3")){
                            		    		int digitsIndex = fielddbtype.indexOf(",");
                            		        	if(digitsIndex > -1){
                            		        		decimaldigits_t = Util.getIntValue(fielddbtype.substring(digitsIndex+1, fielddbtype.length()-1), 2);
													 //update by liaodong for qc75759 in 2013年10月23日 start
                            		        	    defieldvalue = Util.toDecimalDigits(defieldvalue,decimaldigits_t);
                            		        	    //end 
                            		        	}else{
                            		        		decimaldigits_t = 2;
													 //update by liaodong for qc75759 in 2013年10月23日 start
                            		        	    defieldvalue = Util.toDecimalDigits(defieldvalue,2);
                            		        	    //end 
                            		        	}
                            		    	}
                            		    	if(defieldtype.equals("5")){
                            		    		  if(isbill.equals("0")){
                          				        	rs.executeSql("select * from workflow_formdict where id = " + defieldid);
                          							 if(rs.next()){
                          							   qfws = Util.getIntValue(rs.getString("qfws"),2);
                          							 }
                          							 decimaldigits_t=qfws; 
                          						}else{
                          							if(qfws == -1 || qfws == 0){
   													 decimaldigits_t=2;
	   												}else{
	   													 decimaldigits_t=qfws;
	   												}
                          						}
                            		    		  defieldvalue = Util.toDecimalDigits(""+defieldvalue,decimaldigits_t);	
                            		    		 // defieldvalue = Util.milfloatFormat(defieldvalue+"");	
                            		    	 
                            		    	}
                            		    	String datavaluetype = "";
									    	if(defieldtype.equals("5")){
									    		datavaluetype += " datavaluetype='5'";
									    	}
									    	//update by liaodong for qc75759 in 2013年10月23日 start
									    		datavaluetype += " datalength="+decimaldigits_t;
									    	//end
                                            if(isdeedit.equals("1") && colcount1!=0 && editdetailbodyflag){
                                                if(isdemand.equals("1")) {
                                                	
                                                	
                                          %> 
                                          <input datetype="float" datatype="float" <%=datavaluetype%> viewtype='<%=isdemand%>' temptitle='<%=defieldlable%>' type=text class=inputstyle id="field<%=defieldid%>_<%=derecorderindex%>"  name="field<%=defieldid%>_<%=derecorderindex%>" size=20 value="<%=defieldvalue%>"
                                          onKeyPress="ItemDecimal_KeyPress(this.name,15,<%=decimaldigits_t%>)" <%if(defieldtype.equals("5")){%>onfocus="changeToNormalFormat(this.name)" onblur="changeToThousands2(this.name,'<%=decimaldigits_t %>')"<%}%> onChange="checkFloat(this);checkinput2('field<%=defieldid%>_<%=derecorderindex%>','field<%=defieldid%>_<%=derecorderindex%>span',this.getAttribute('viewtype'));calSum(<%=detailno%>);<%=trrigerdetailStr%>">
                                          <span id="field<%=defieldid%>_<%=derecorderindex%>span"><% if(defieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
                                           <%
                                                }else{%>
                                                 <input  datetype="float" datatype="float" <%=datavaluetype%> viewtype='<%=isdemand%>' temptitle='<%=defieldlable%>' type=text class=inputstyle id="field<%=defieldid%>_<%=derecorderindex%>"  name="field<%=defieldid%>_<%=derecorderindex%>" size=20 value="<%=defieldvalue%>" onKeyPress="ItemDecimal_KeyPress(this.name,15,<%=decimaldigits_t%>)" <%if(defieldtype.equals("5")){%>onfocus="changeToNormalFormat(this.name)" onblur="changeToThousands2(this.name,'<%=decimaldigits_t %>')"<%}%> onChange="checkFloat(this);checkinput2('field<%=defieldid%>_<%=derecorderindex%>','field<%=defieldid%>_<%=derecorderindex%>span',this.getAttribute('viewtype'));calSum(<%=detailno%>);<%=trrigerdetailStr%>">
                                                <span id="field<%=defieldid%>_<%=derecorderindex%>span"></span>
                                           <%           }
                                           if(changedefieldsdemanage.indexOf(defieldid)>=0){
                                        %>
                                            <input type=hidden name="oldfieldview<%=defieldid%>_<%=derecorderindex%>" value="<%=Util.getIntValue(isdeview,0)+Util.getIntValue(isdeedit,0)+Util.getIntValue(isdemand,0)%>" />
                                        <%
                                            }
                                            }
                                            else {if(isdeview.equals("1") && colcount1!=0){
                                           %>
                                            <span id="field<%=defieldid%>_<%=derecorderindex%>span"><%=defieldvalue%></span>
                                           <%
                                          }
                                          %>
                                            <input  datetype="float" datatype="float" <%=datavaluetype%> type=hidden class=Inputstyle id="field<%=defieldid%>_<%=derecorderindex%>" name="field<%=defieldid%>_<%=derecorderindex%>" value="<%=defieldvalue%>">
                                          <%
                                            }
                                        }else if(defieldtype.equals("4")){                     //  单行文本框中的金额转换






											//add by liaodong for qc75759 in 2013-11-20 start 
                                         	int decimaldigits_t = 2;
                             		    	if(defieldtype.equals("4")){
                             		    		int digitsIndex = fielddbtype.indexOf(",");
                             		        	if(digitsIndex > -1){
                             		        		decimaldigits_t = Util.getIntValue(fielddbtype.substring(digitsIndex+1, fielddbtype.length()-1), 2);
                             		        	}else{
                             		        		decimaldigits_t = 2;
                             		        	}
                             		    	}
                             		    	//end 
                                            if(isdeedit.equals("1") &&  colcount1!=0 && editdetailbodyflag){
                                                if(isdemand.equals("1")) {
                                          %>
                                          
                                          <input class=inputstyle datetype="float" datatype="float" temptitle="<%=defieldlable%>" type=text id="field_lable<%=defieldid%>_<%=derecorderindex%>" name="field_lable<%=defieldid%>_<%=derecorderindex%>" size=30  onfocus="getNumber('<%=defieldid%>_<%=derecorderindex%>')"
                                          onKeyPress="ItemDecimal_KeyPress('field_lable<%=defieldid%>_<%=derecorderindex%>',15,<%=decimaldigits_t%>)" onBlur="checkFloat(this);numberToChinese('<%=defieldid%>_<%=derecorderindex%>');checkinput2('field_lable<%=defieldid%>_<%=derecorderindex%>','field<%=defieldid%>_<%=derecorderindex%>span',field<%=defieldid%>_<%=derecorderindex%>.getAttribute('viewtype'));calSum('<%=detailno%>');<%=trrigerdetailStr%>">
                                           <%
                                                }else{%>
                                                <input class=inputstyle datetype="float" datatype="float" type=text id="field_lable<%=defieldid%>_<%=derecorderindex%>" name="field_lable<%=defieldid%>_<%=derecorderindex%>" size=30  onKeyPress="ItemDecimal_KeyPress('field_lable<%=defieldid%>_<%=derecorderindex%>',15,<%=decimaldigits_t%>)" onfocus="getNumber('<%=defieldid%>_<%=derecorderindex%>')" onBlur="checkFloat(this);numberToChinese('<%=defieldid%>_<%=derecorderindex%>');checkinput2('field_lable<%=defieldid%>_<%=derecorderindex%>','field<%=defieldid%>_<%=derecorderindex%>span',field<%=defieldid%>_<%=derecorderindex%>.getAttribute('viewtype'));calSum('<%=detailno%>');<%=trrigerdetailStr%>" >
                                           <%           }
                                           
                                                %>
                                                  <span id="field<%=defieldid%>_<%=derecorderindex%>span">
                                                  <% if(isdemand.equals("1")&&defieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%>
                                                  </span>
												  <!-- add by liaodong for qc75759 in 2013-11-20 start -->
                                                  <input datetype="float" datatype="float" viewtype='<%=isdemand%>' fieldtype='4' datalength='<%=decimaldigits_t %>' type=hidden class=Inputstyle temptitle="<%=defieldlable%>" id="field<%=defieldid%>_<%=derecorderindex%>" name="field<%=defieldid%>_<%=derecorderindex%>" value="<%=defieldvalue%>">
                                                <%
                                            if(changedefieldsdemanage.indexOf(defieldid)>=0){
                                            %>
                                                <input type=hidden name="oldfieldview<%=defieldid%>_<%=derecorderindex%>" value="<%=Util.getIntValue(isdeview,0)+Util.getIntValue(isdeedit,0)+Util.getIntValue(isdemand,0)%>" />
                                            <%
                                                }
                                            }
                                            else {if(isdeview.equals("1") && colcount1!=0){
                                           %>
                                             <input datatype="float" type=text class=Inputstyle id="field_lable<%=defieldid%>_<%=derecorderindex%>" name="field_lable<%=defieldid%>_<%=derecorderindex%>"  disabled="true" size=30>
                                            <span id="field<%=defieldid%>_<%=derecorderindex%>span"><%=defieldvalue%></span>
                                           <%
                                          }
                                          %>
										  <!-- add by liaodong for qc75759 in 2013-11-20 start -->
                                            <input datatype="float" fieldtype='4' datalength='<%=decimaldigits_t %>' type=hidden class=Inputstyle id="field<%=defieldid%>_<%=derecorderindex%>" name="field<%=defieldid%>_<%=derecorderindex%>" value="<%=defieldvalue%>">
                                          <%
                                            }
                                            %>
                                              <script language="javascript">
                                              	try{
                                                    window.$GetEle("field_lable"+<%=defieldid%>+"_"+<%=derecorderindex%>).value  = numberChangeToChinese(floatFormat(<%=defieldvalue%>));
                                                  }catch(e){}
                                              </script>
                                              
                                              
                                              
                                            <%
                                        }
                                    }                                                       // 单行文本框条件结束






                                    else if(defieldhtmltype.equals("2")){                     // 多行文本框






                                    	if(isbill.equals("0")){
			                                rs_count.executeSql("select * from workflow_formdictdetail where id = " + defieldid);
			                                if(rs_count.next()){
			                                 textheight1 = rs_count.getString("textheight");//td3421 xwj 2005-12-31
			                                }
			                                }else{
			                                	rs_count.executeSql("select * from workflow_billfield where viewtype=1 and id = " + defieldid+" and billid="+formid);
			                        			if(rs_count.next()){
			                        				textheight1 = ""+Util.getIntValue(rs_count.getString("textheight"), 4);
			                        			}
			                        		}
                                        if(isdeedit.equals("1") && colcount1!=0 && editdetailbodyflag){
                                            if(isdemand.equals("1")) {
                                          %>
                                          <textarea class=inputstyle  viewtype='<%=isdemand%>' temptitle='<%=defieldlable%>' name="field<%=defieldid%>_<%=derecorderindex%>"  onChange="checkinput2('field<%=defieldid%>_<%=derecorderindex%>','field<%=defieldid%>_<%=derecorderindex%>span',this.getAttribute('viewtype'));checkLengthfortext('field<%=defieldid%>_<%=derecorderindex%>','<%=fieldlen%>','<%=defieldlable%>','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')"
                                          rows="<%=textheight1%>" cols="40" style="width:80%" ><%=Util.toScreenToEdit(defieldvalue,user.getLanguage())%></textarea>
                                          <span id="field<%=defieldid%>_<%=derecorderindex%>span"><% if(defieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
                                           <%
                                            }else{
                                           %>
                                           <textarea class=inputstyle viewtype='<%=isdemand%>' temptitle='<%=defieldlable%>' onchange="checkinput2('field<%=defieldid%>_<%=derecorderindex%>','field<%=defieldid%>_<%=derecorderindex%>span',this.getAttribute('viewtype'));checkLengthfortext('field<%=defieldid%>_<%=derecorderindex%>','<%=fieldlen%>','<%=defieldlable%>','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')" name="field<%=defieldid%>_<%=derecorderindex%>" rows="<%=textheight1%>" cols="40" style="width:80%"><%=Util.toScreenToEdit(defieldvalue,user.getLanguage())%></textarea>
                                           <span id="field<%=defieldid%>_<%=derecorderindex%>span"></span>
                                           <%       }
                                           if(changedefieldsdemanage.indexOf(defieldid)>=0){
                                        %>
                                            <input type=hidden name="oldfieldview<%=defieldid%>_<%=derecorderindex%>" value="<%=Util.getIntValue(isdeview,0)+Util.getIntValue(isdeedit,0)+Util.getIntValue(isdemand,0)%>" />
                                        <%
                                            }
                                        }
                                        else {if(isdeview.equals("1") && colcount1!=0){
                                           %>
                                            <span id="field<%=defieldid%>_<%=derecorderindex%>span"><%=Util.toScreen(defieldvalue,user.getLanguage())%></span>
                                         <%
                                          }
                                          %>
                                            <input type=hidden class=Inputstyle id="field<%=defieldid%>_<%=derecorderindex%>" name="field<%=defieldid%>_<%=derecorderindex%>" value="<%=Util.toScreenToEdit(defieldvalue,user.getLanguage())%>">
                                          <%
                                        }
                                    }                                                           // 多行文本框条件结束






                                    else if(defieldhtmltype.equals("3")){                         // 浏览按钮 (涉及workflow_broswerurl表)
                                    	isbrowisMust = "0";
                                        if ("1".equals(isdeedit)) {
   	                           		        isbrowisMust = "1";
	   	                           		}
	   	                           		if ("1".equals(isdemand)) {
	   	                           		    isbrowisMust = "2";
	   	                           		}

                                        String url=BrowserComInfo2.getBrowserurl(defieldtype);     // 浏览按钮弹出页面的url
                                        String linkurl =BrowserComInfo2.getLinkurl(defieldtype);   // 浏览值点击的时候链接的url
                                        String showname = "";                                   // 新建时候默认值显示的名称
                                        String showid = "";                                     // 新建时候默认值






                                        String hiddenlinkvalue="";

                                        // 如果是多文档, 需要判定是否有新加入的文档,如果有,需要加在原来的后面
                                        if( defieldtype.equals("37") && ((defieldid+"_"+derecorderindex).equals(docfileid)) && !newdocid.equals("")) {

                                            if( ! defieldvalue.equals("") ) defieldvalue += "," ;
                                            defieldvalue += newdocid ;

                                        }
                                        if(defieldtype.equals("161") || defieldtype.equals("162")){
											url+="?type="+fielddbtype;
                                        }
                                        if(defieldtype.equals("256") || defieldtype.equals("257")){
											url+="?type="+fielddbtype+"_"+defieldtype;
                                        }

                                        if(defieldtype.equals("2") ||defieldtype.equals("19")  )	showname=defieldvalue; // 日期时间
                                        else if(!defieldvalue.equals("")) {
                                            ArrayList tempshowidlist=Util.TokenizerString(defieldvalue,",");
                                            if(defieldtype.equals("8") || defieldtype.equals("135")){
                                                //项目，多项目
                                                for(int k=0;k<tempshowidlist.size();k++){
                                                    if(!linkurl.equals("")){
                                                        showname+="<a href='"+linkurl+tempshowidlist.get(k)+"&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"' target='_new'>"+ProjectInfoComInfo2.getProjectInfoname((String)tempshowidlist.get(k))+"</a>&nbsp";
                                                    }else{
                                                    showname+=ProjectInfoComInfo2.getProjectInfoname((String)tempshowidlist.get(k))+" ";
                                                    }
                                                }
                                            }else if(defieldtype.equals("1") ||defieldtype.equals("17")||defieldtype.equals("165")||defieldtype.equals("166")){
                                                //人员，多人员
                                                for(int k=0;k<tempshowidlist.size();k++){
                                                    if(!linkurl.equals("")){
                                                    	if("/hrm/resource/HrmResource.jsp?id=".equals(linkurl))
                                                      	{
                                                    		showname+="<a href='javaScript:openhrm("+tempshowidlist.get(k)+");' onclick='pointerXY(event);'>"+ResourceComInfo2.getResourcename((String)tempshowidlist.get(k))+"</a>&nbsp";
                                                      	}
                                                    	else
                                                        showname+="<a href='"+linkurl+tempshowidlist.get(k)+"&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"' target='_new'>"+ResourceComInfo2.getResourcename((String)tempshowidlist.get(k))+"</a>&nbsp";
                                                    }else{
                                                    showname+=ResourceComInfo2.getResourcename((String)tempshowidlist.get(k))+" ";
                                                    }
                                                }
                                            }else if(defieldtype.equals("142")){
												//收发文单位






												for(int k=0;k<tempshowidlist.size();k++){
													if(!linkurl.equals("")){
														showname+="<a href='"+linkurl+tempshowidlist.get(k)+"&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"' target='_new'>"+docReceiveUnitComInfo_mdbb.getReceiveUnitName((String)tempshowidlist.get(k))+"</a>&nbsp";
													}else{
													showname+=docReceiveUnitComInfo_mdbb.getReceiveUnitName((String)tempshowidlist.get(k))+" ";
													}
												}
                                            }else if(defieldtype.equals("7") || defieldtype.equals("18")){
                                                //客户，多客户
                                                for(int k=0;k<tempshowidlist.size();k++){
                                                    if(!linkurl.equals("")){
                                                        showname+="<a href='"+linkurl+tempshowidlist.get(k)+"&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"' target='_new'>"+CustomerInfoComInfo2.getCustomerInfoname((String)tempshowidlist.get(k))+"</a>&nbsp";
                                                    }else{
                                                    showname+=CustomerInfoComInfo2.getCustomerInfoname((String)tempshowidlist.get(k))+" ";
                                                    }
                                                }
                                            }else if(defieldtype.equals("4") || defieldtype.equals("57")){
                                                //部门，多部门
                                                for(int k=0;k<tempshowidlist.size();k++){
                                                	 String showdeptname = "";
	                           						 String showdeptid = (String) tempshowidlist.get(k);
	                           						 if(!"".equals(showdeptid)){
	                           							if(Integer.parseInt(showdeptid) < -1){
	                           								showdeptname = deptVirComInfo2.getDepartmentname(showdeptid);
	                           								
	                           							}else{
	                           								showdeptname = DepartmentComInfo2.getDepartmentname(showdeptid);
	                           							}
	                           						 }
                                                     if(!linkurl.equals("")){
                                                        showname+="<a href='"+linkurl+tempshowidlist.get(k)+"&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"' target='_new'>"+showdeptname+"</a>&nbsp";
                                                     }else{
                                                    	showname+=showdeptname+" ";
                                                     }
                                                }
                                            }else if(defieldtype.equals("164") || defieldtype.equals("194")){
							                    //多分部





							                    for(int k=0;k<tempshowidlist.size();k++){
							                    	String showsubcompname = "";
						    						String showsubcompid = (String) tempshowidlist.get(k);
						    						if(!"".equals(showsubcompid)){
						    							if(Integer.parseInt(showsubcompid) < -1){
						    								showsubcompname = subCompVirComInfo2.getSubCompanyname(showsubcompid);
						    							}else{
						    								showsubcompname = SubCompanyComInfo2.getSubCompanyname(showsubcompid);
						    							}
						    						}
							                        if(!linkurl.equals("")){
							                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"'>"+showsubcompname+"</a>&nbsp";
							                        }else{
							                        	showname+=showsubcompname+" ";
							                        }
							                    }
							                }else if(defieldtype.equals("9") || defieldtype.equals("37")){
                                                //文档，多文档
                                                for(int k=0;k<tempshowidlist.size();k++){
                                                    if(!linkurl.equals("")){
                                                        showname+="<a href='"+linkurl+tempshowidlist.get(k)+"&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"' target='_blank'>"+DocComInfo2.getDocname((String)tempshowidlist.get(k))+"</a>&nbsp";
                                                    }else{
                                                    showname+=DocComInfo2.getDocname((String)tempshowidlist.get(k))+" ";
                                                    }
                                                }
                                            }else if(defieldtype.equals("23")){
                                                //资产
                                                for(int k=0;k<tempshowidlist.size();k++){
                                                    if(!linkurl.equals("")){
                                                        showname+="<a href='"+linkurl+tempshowidlist.get(k)+"&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"' target='_new'>"+CapitalComInfo2.getCapitalname((String)tempshowidlist.get(k))+"</a>&nbsp";
                                                    }else{
                                                    showname+=CapitalComInfo2.getCapitalname((String)tempshowidlist.get(k))+" ";
                                                    }
                                                }
                                            }else if(defieldtype.equals("16") || defieldtype.equals("152") || defieldtype.equals("171")){
                                                //相关请求
                                                for(int k=0;k<tempshowidlist.size();k++){
                                                    if(!linkurl.equals("")){
                                                        int tempnum=Util.getIntValue(String.valueOf(session.getAttribute("slinkwfnum")));
                                                        tempnum++;
                                                        session.setAttribute("resrequestid"+tempnum,""+tempshowidlist.get(k));
                                                        session.setAttribute("slinkwfnum",""+tempnum);
                                                        session.setAttribute("haslinkworkflow","1");
                                                        hiddenlinkvalue+="<input type=hidden name='slink"+defieldid+"_"+derecorderindex+"_rq"+tempshowidlist.get(k)+"' value="+tempnum+">";
                                                        showname+="<a href='"+linkurl+tempshowidlist.get(k)+"&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&wflinkno="+tempnum+"' target='_new'>"+WorkflowRequestComInfo2.getRequestName((String)tempshowidlist.get(k))+"</a>&nbsp";
                                                    }else{
                                                    showname+=WorkflowRequestComInfo2.getRequestName((String)tempshowidlist.get(k))+" ";
                                                    }
                                                }
                                            }else if(defieldtype.equals("161")){//自定义单选






							                    showname = "";                                   // 新建时候默认值显示的名称
												try{
													defieldvalue = defieldvalue.replace("&#039;","'").replace("&quot;", "\"");
										            Browser browser=(Browser)StaticObj.getServiceByFullname(fielddbtype, Browser.class);
										            BrowserBean bb=browser.searchById(requestid+"^~^"+defieldvalue+"^~^"+derecorderindex);
													String desc=Util.null2String(bb.getDescription());
													String name=Util.null2String(bb.getName());
						                            String href=Util.null2String(bb.getHref());
						                            if(href.equals("")){
						                            	showname+="<a title='"+desc+"'>"+name+"</a>&nbsp";
						                            }else{
						                            	showname+="<a title='"+desc+"' href='"+href+"' target='_blank'>"+name+"</a>&nbsp";
						                            }
												}catch(Exception e){
												}
												defieldvalue = defieldvalue.replace("\"", "&quot;");
                                            }else if(defieldtype.equals("162")){//自定义多选






									            showname = "";                                   // 新建时候默认值显示的名称
												try{
										            Browser browser=(Browser)StaticObj.getServiceByFullname(fielddbtype, Browser.class);
													List l=Util.TokenizerString(defieldvalue,",");
										            for(int j=0;j<l.size();j++){
													    String curid=(String)l.get(j);
														curid = curid.replace("&#039;","'").replace("&quot;", "\"");
											            BrowserBean bb=browser.searchById(requestid+"^~^"+curid+"^~^"+derecorderindex);
														String name=Util.null2String(bb.getName());
														String desc=Util.null2String(bb.getDescription());
							                            String href=Util.null2String(bb.getHref());
							                            if(href.equals("")){
							                            	showname+="<a title='"+desc+"'>"+name+"</a>&nbsp";
							                            }else{
							                            	showname+="<a title='"+desc+"' href='"+href+"' target='_blank'>"+name+"</a>&nbsp";
							                            }
													}
												}catch(Exception e){
												}    
                                            }else if(defieldtype.equals("256")||defieldtype.equals("257")){//自定义多选






                                            	CustomTreeUtil customTreeUtil = new CustomTreeUtil();
												showid = defieldvalue;
												showname = customTreeUtil.getTreeFieldShowName(defieldvalue,fielddbtype);
                                            }else if(defieldtype.equals("224") || defieldtype.equals("225")||defieldtype.equals("226") || defieldtype.equals("227")){
												//System.out.println("来到了修改页面的明细");
												//集成浏览按钮
												//zzl,新表单的普通模式，浏览按钮不经过ButtonElement.java
												if("NULL".equals(defieldvalue)){
														defieldvalue="";
												}
												showname+="<a title='"+defieldvalue+"'>"+defieldvalue+"</a>&nbsp";
												url+="?type="+fielddbtype+"|"+defieldid;	
											}else if(defieldtype.equals("263")){

                                                String tablename1=BrowserComInfo2.getBrowsertablename(defieldtype); //浏览框对应的表,比如人力资源表
                                                String columname=BrowserComInfo2.getBrowsercolumname(defieldtype); //浏览框对应的表名称字段
                                                String keycolumname=BrowserComInfo2.getBrowserkeycolumname(defieldtype);   //浏览框对应的表值字段

                                                //add by wang jinyong
                                                HashMap temRes = new HashMap();

                                                if(defieldvalue.indexOf(",")!=-1){
                                                    sql= "select "+keycolumname+","+columname+" from "+tablename1+" where "+keycolumname+" in( "+defieldvalue+")";
                                                }
                                                else {
                                                    sql= "select "+keycolumname+","+columname+" from "+tablename1+" where "+keycolumname+"="+defieldvalue;
                                                }

                                                RecordSet.executeSql(sql);
                                                while(RecordSet.next()){
                                                    showid = Util.null2String(RecordSet.getString(1)) ;
                                                    String tempshowname= Util.toScreen(RecordSet.getString(2),user.getLanguage()) ;
                                                    showname = tempshowname;
                                                }
                                            
											}
											else{
                                                String tablename1=BrowserComInfo2.getBrowsertablename(defieldtype); //浏览框对应的表,比如人力资源表






                                                String columname=BrowserComInfo2.getBrowsercolumname(defieldtype); //浏览框对应的表名称字段






                                                String keycolumname=BrowserComInfo2.getBrowserkeycolumname(defieldtype);   //浏览框对应的表值字段








                                                //add by wang jinyong
                                                HashMap temRes = new HashMap();

                                                if(defieldvalue.indexOf(",")!=-1){
                                                    sql= "select "+keycolumname+","+columname+" from "+tablename1+" where "+keycolumname+" in( "+defieldvalue+")";
                                                }
                                                else {
                                                    sql= "select "+keycolumname+","+columname+" from "+tablename1+" where "+keycolumname+"="+defieldvalue;
                                                }

                                                RecordSet.executeSql(sql);
                                                while(RecordSet.next()){
                                                    showid = Util.null2String(RecordSet.getString(1)) ;
                                                    String tempshowname= Util.toScreen(RecordSet.getString(2),user.getLanguage()) ;
                                                    if(!linkurl.equals("")){
                                                    	if("/hrm/resource/HrmResource.jsp?id=".equals(linkurl))
                                                      	{
                                                    		showname+="<a href='javaScript:openhrm("+showid+");' onclick='pointerXY(event);'>"+tempshowname+"</a>&nbsp";
                                                      	}
                                                    	else  
                                                             showname += "<a href='"+linkurl+showid+"&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"' target='_new'>"+tempshowname+"</a>&nbsp";
                                                    }else{
                                                        showname +=tempshowname+" ";
                                                    }
                                                }
                                            }
                                        }else if(defieldvalue.equals("")){
                                        				 if(defieldtype.equals("224") || defieldtype.equals("225")||defieldtype.equals("226") || defieldtype.equals("227")){
															//System.out.println("来到了修改页面的明细");
															//集成浏览按钮
															//zzl,新表单的普通模式，浏览按钮不经过ButtonElement.java
															if("NULL".equals(defieldvalue)){
																	defieldvalue="";
															}
															showname+="<a title='"+defieldvalue+"'>"+defieldvalue+"</a>&nbsp";
															url+="?type="+fielddbtype+"|"+defieldid;	

														}
                                        }
                                        //add by dongping
                                        //永乐要求在审批会议的流程中增加会议室报表链接，点击后在新窗口显示会议室报表






                                        if (defieldtype.equals("118")) {
                                            showname ="<a href=/meeting/report/MeetingRoomPlan.jsp target=blank>"+SystemEnv.getHtmlLabelName(2165,user.getLanguage())+"</a>" ;
                                            //showid = "<a href=/meeting/report/MeetingRoomPlan.jsp target=blank>查看会议室使用情况</a>";
                                         }
                                        if(isdeedit.equals("1") && colcount1!=0 && editdetailbodyflag){
                                            
                                            try {
					      				    	 if(defieldtype.equals("161") || defieldtype.equals("162")){
					      				               showname = showname.replaceAll("</a>&nbsp", "</a>~~WEAVERSplitFlag~~");   
					      				    	 }else{
					      				               showname = showname.replaceAll("</a>&nbsp", "</a>,"); 
					      				    	 }  				        
                         				    } catch (Exception e) {
                         				        e.printStackTrace();
                         				    }


											
if("16".equals(defieldtype)){   //请求
			if(url.indexOf("RequestBrowser.jsp?")>-1){
		    		url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}
				/*if(linkurl.indexOf("ViewRequest.jsp?")>-1){
		    		linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}*/
		}

	/*if("152".equals(defieldtype) || "171".equals(defieldtype)){   //多请求






			if(url.indexOf("MultiRequestBrowser.jsp?")>-1){
		    		url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}
				/*if(linkurl.indexOf("ViewRequest.jsp?")>-1){
		    		linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}
		}	*/

		if("7".equals(defieldtype)){   //客户
			if(url.indexOf("CustomerBrowser.jsp?")>-1){
		    		url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}
				/*if(linkurl.indexOf("ViewCustomer.jsp?")>-1){
		    		linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}*/
		}

			if("9".equals(defieldtype)){   //文档
			if(url.indexOf("DocBrowser.jsp?")>-1){
		    		url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}
				/*if(linkurl.indexOf("DocDsp.jsp?")>-1){
		    		linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}*/
		}

			if("37".equals(defieldtype)){   //多文档






			if(url.indexOf("MutiDocBrowser.jsp?")>-1){
		    		url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}
				/*if(linkurl.indexOf("DocDsp.jsp?")>-1){
		    		linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}*/
		}

									if("1".equals( defieldtype)){   //单人力






			if(url.indexOf("ResourceBrowser.jsp?")>-1){
		    		url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}
				/*if(linkurl.indexOf("HrmResource.jsp?")>-1){
		    		linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}*/

		}

		/*if("17".equals( defieldtype)){   ////分权多人力






			if(url.indexOf("MultiResourceBrowser.jsp?")>-1){
		    		url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}
				/*if(linkurl.indexOf("hrmTab.jsp?")>-1){
		    		linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}

		}*/

										
									if("165".equals( defieldtype)){   //分权单人力






			if(url.indexOf("ResourceBrowserByDec.jsp?")>-1){
		    		url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}
				/*if(linkurl.indexOf("HrmResource.jsp?")>-1){
		    		linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}*/

		}

		if("166".equals( defieldtype)){   ////分权多人力






			if(url.indexOf("MultiResourceBrowserByDec.jsp?")>-1){
		    		url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}
				/*if(linkurl.indexOf("hrmTab.jsp?")>-1){
		    		linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}*/

		}

			if("167".equals( defieldtype)){   ////分权单部门






			if(url.indexOf("DepartmentBrowserByDec.jsp?")>-1){
		    		url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}
				/*if(linkurl.indexOf("HrmDepartmentDsp.jsp?")>-1){
		    		linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}*/

		}

		if("168".equals( defieldtype)){   ////分权多部门






			if(url.indexOf("MultiDepartmentBrowserByDecOrder.jsp?")>-1){
		    		url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}
				/*if(linkurl.indexOf("HrmDepartmentDsp.jsp?")>-1){
		    		linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}*/

		}

		if("169".equals( defieldtype)){   ////分权单分部






			if(url.indexOf("SubcompanyBrowserByDec.jsp?")>-1){
		    		url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}
				/*if(linkurl.indexOf("HrmSubCompanyDsp.jsp?")>-1){
		    		linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}*/

		}

		if("170".equals( defieldtype)){   ////分权多分部






			if(url.indexOf("MultiSubcompanyBrowserByDec.jsp?")>-1){
		    		url+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		url+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}
				/*if(linkurl.indexOf("HrmSubCompanyDsp.jsp?")>-1){
		    		linkurl+="&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}else{
		    		linkurl+="?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype;
		    	}*/

		}
                                            if( !defieldtype.equals("37") ) {    //  多文档特殊处理






                                                if (trrigerdetailfield.indexOf("field"+defieldid)>=0){
                                                    bclick="onShowBrowser2('"+defieldid+"_"+derecorderindex+"','"+url+"','"+linkurl+"','"+defieldtype+"',field"+defieldid+"_"+derecorderindex+".getAttribute('viewtype'));";
                                                } else {
                                                    bclick="onShowBrowser2('"+defieldid+"_"+derecorderindex+"','"+url+"','"+linkurl+"','"+defieldtype+"',field"+defieldid+"_"+derecorderindex+".getAttribute('viewtype'))";
                                                }
                                                if(defieldtype.equals("2") || defieldtype.equals("19")){
                                   %>
                                    
                                   <BUTTON id="field<%=defieldid%>_<%=derecorderindex%>browser" name="field<%=defieldid%>_<%=derecorderindex%>browser" type=button  class=Browser <%if (trrigerdetailfield.indexOf("field"+defieldid)>=0){%>onclick="onShowBrowser2('<%=defieldid%>_<%=derecorderindex%>','<%=url%>','<%=linkurl%>','<%=defieldtype%>',field<%=defieldid%>_<%=derecorderindex%>.getAttribute('viewtype'));datainputd('field<%=defieldid%>_<%=derecorderindex%>')" <%} else {%> onclick="onShowBrowser2('<%=defieldid%>_<%=derecorderindex%>','<%=url%>','<%=linkurl%>','<%=defieldtype%>',field<%=defieldid%>_<%=derecorderindex%>.getAttribute('viewtype'))" <%}%> title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>"></button>
                                    
                                    <%}else  if(defieldtype.equals("58")){   //城市
                                                    %>
                                                    <div areaType="city" areaName='<%="field" + defieldid + "_" + derecorderindex %>' areaValue="<%=defieldvalue%>" 
                                                    areaSpanValue="<%=Util.formatMultiLang(showname) %>"  areaMustInput="<%=isbrowisMust %>"  areaCallback=""  class="_areaselect" id='_areaselect_<%="field" + defieldid + "_" + derecorderindex %>'></div>
                                                    <script type="text/javascript">
                                                     areromancedivbyid('_areaselect_<%="field" + defieldid + "_" + derecorderindex %>',-1);
                                                    </script>
                                                    <% 
                                                }else if(defieldtype.equals("263")){  //区县
                                                    %>
                                                    <div areaType="citytwo" areaName='<%="field" + defieldid + "_" + derecorderindex %>' areaValue="<%=defieldvalue%>" 
                                                    areaSpanValue="<%=Util.formatMultiLang(showname) %>"  areaMustInput="<%=isbrowisMust %>"  areaCallback=""  class="_areaselect" id='_areaselect_<%="field" + defieldid + "_" + derecorderindex %>'></div>
                                                    <script type="text/javascript">
                                                     areromancedivbyid('_areaselect_<%="field" + defieldid + "_" + derecorderindex %>',-1);
                                                    </script>
                                                    <% 
                                                    }      
                                                else {
                                    String completeUrlStr = "javascript:getajaxurl(" + defieldtype + ")";
									if(defieldtype.equals("161")||defieldtype.equals("162")){
										completeUrlStr = "javascript:getajaxurl(" + defieldtype + ",'"+fielddbtype+"')";
                                     %>
                                    <span id="field<%=defieldid%>_<%=derecorderindex%>wrapspan">
                                     <brow:browser viewType="1" name='<%="field" + defieldid + "_" + derecorderindex %>' browserValue='<%=defieldvalue %>' browserSpanValue='<%=showname %>' browserOnClick='<%=bclick%>' nameSplitFlag="~~WEAVERSplitFlag~~" hasInput='true' isSingle='<%=BrowserManager.browIsSingle(defieldtype)%>' hasBrowser = "true" isMustInput='<%=isbrowisMust %>' completeUrl='<%=completeUrlStr%>' width="100%" needHidden="false" onPropertyChange='<%="wfbrowvaluechange(this," + defieldid + ", " + derecorderindex + ")" %>' linkUrl='<%=linkurl%>' type='<%=defieldtype%>'> </brow:browser>
                                     </span>
                                   
                                   <%      
									}else{
									String hasinputStr = "true";
									//if(defieldtype.equals("256")||defieldtype.equals("257")){
									//	hasinputStr = "false";
									//}
                                     %>
                                    <span id="field<%=defieldid%>_<%=derecorderindex%>wrapspan">
                                     <brow:browser viewType="1" name='<%="field" + defieldid + "_" + derecorderindex %>' browserValue='<%=defieldvalue %>' browserSpanValue='<%=showname %>' browserOnClick='<%=bclick%>' hasInput='<%=hasinputStr%>' isSingle='<%=BrowserManager.browIsSingle(defieldtype)%>' hasBrowser = "true" isMustInput='<%=isbrowisMust %>' completeUrl='<%=completeUrlStr%>' width="100%" needHidden="false" onPropertyChange='<%="wfbrowvaluechange(this," + defieldid + ", " + derecorderindex + ")" %>' linkUrl='<%=linkurl%>' type='<%=defieldtype%>'> </brow:browser>
                                     </span>
                                   
                                   <%       
                               }}
                                   } else {                         // 如果是多文档字段,加入新建文档按钮
		                                       bclick = "onShowBrowser2('"+defieldid+"_"+derecorderindex+"','"+url+"','"+linkurl+"','"+defieldtype+"',field"+defieldid+"_"+derecorderindex+".getAttribute('viewtype'))";
                                   String oclick = "onNewDoc('" + defieldid + "_" + derecorderindex + "')";
                                   %>
                                   <span id="field<%=defieldid%>_<%=derecorderindex%>wrapspan">
                                   <brow:browser viewType="1" name='<%="field" + defieldid  + "_" +  derecorderindex %>' browserValue='<%=defieldvalue %>' browserSpanValue='<%=showname %>' browserOnClick='<%=bclick%>' hasInput="true" isSingle='<%=BrowserManager.browIsSingle(defieldtype)%>' hasBrowser = "true" isMustInput='<%=isbrowisMust %>' completeUrl='<%="javascript:getajaxurl(" + defieldtype + ")"%>' width="100%" needHidden="false" onPropertyChange='<%="wfbrowvaluechange(this," + defieldid + ", " + derecorderindex + ")" %>'
                                   hasAdd="true" addOnClick='<%=oclick%>' linkUrl='<%=linkurl%>' type='<%=defieldtype%>'
                                   > </brow:browser>
                                   </span>
                                   <!-- 
                                   <BUTTON id="field<%=defieldid%>_<%=derecorderindex%>browser" name="field<%=defieldid%>_<%=derecorderindex%>browser" type=button  class=AddDoc  onclick="onShowBrowser2('<%=defieldid%>_<%=derecorderindex%>','<%=url%>','<%=linkurl%>','<%=defieldtype%>',field<%=defieldid%>_<%=derecorderindex%>.getAttribute('viewtype'))" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"> <%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></button>
                                   &nbsp;&nbsp;<BUTTON type=button  class=AddDocFlow onclick="onNewDoc('<%=defieldid%>_<%=derecorderindex%>')" title="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></button>
                                    -->
                                   
                                     
                                   <%       }
                                        }
                                        //日期控件不使用brow
                                        if( (defieldtype.equals("2") || defieldtype.equals("19")) || (isdeview.equals("1") && colcount1!=0  && (isdeedit.equals("0") || !editdetailbodyflag))){
                                   %>
                                   
                                    <span id="field<%=defieldid%>_<%=derecorderindex%>span"><%=showname%>
                                   
                                   <%
                                        if( isdemand.equals("1") && defieldvalue.equals("")){
                                   %>
                                    
                                    <img src="/images/BacoError_wev8.gif" align=absmiddle>
                                   
                                   <%
                                        }

                                   %>
                                    </span>
                                    <%if(defieldtype.equals("87")||defieldtype.equals("184")){%>
                                    <A href="/meeting/report/MeetingRoomPlan.jsp" target="blank"><%=SystemEnv.getHtmlLabelName(2193,user.getLanguage())%></A>
                                    <%}%>
                                    <%}%>
                                    <input type=hidden viewtype='<%=isdemand%>' temptitle='<%=defieldlable%>' name="field<%=defieldid%>_<%=derecorderindex%>" id="field<%=defieldid%>_<%=derecorderindex%>" value="<%=defieldvalue%>" <%if(trrigerdetailfield.indexOf("field"+defieldid)>=0){%>onpropertychange="datainputd('field<%=defieldid%>_<%=derecorderindex%>');"<%}%>>
                                    <%=hiddenlinkvalue%>
                                   <%
                                        if(changedefieldsdemanage.indexOf(defieldid)>=0){
                                        %>
                                            <input type=hidden name="oldfieldview<%=defieldid%>_<%=derecorderindex%>" value="<%=Util.getIntValue(isdeview,0)+Util.getIntValue(isdeedit,0)+Util.getIntValue(isdemand,0)%>" />
                                        <%
                                            }
                                    }                                                        // 浏览按钮条件结束
                                    else if(defieldhtmltype.equals("4")) {                    // check框






                                        if(isdeview.equals("1") && colcount1!=0){
                                           %>
                                           <input type=checkbox class=inputstyle viewtype='<%=isdemand%>' temptitle='<%=defieldlable%>' value=1 <%if(isdeedit.equals("0") || !editdetailbodyflag){%> DISABLED <%}else{%>  name="field<%=defieldid%>_<%=derecorderindex%>" <%}if(defieldvalue.equals("1")){%> checked <%}%> >
                                           <%
                                               if(changedefieldsdemanage.indexOf(defieldid)>=0){
                                        %>
                                            <input type=hidden name="oldfieldview<%=defieldid%>_<%=derecorderindex%>" value="<%=Util.getIntValue(isdeview,0)+Util.getIntValue(isdeedit,0)+Util.getIntValue(isdemand,0)%>" />
                                        <%
                                            }
                                               }
                                        if( isdeedit.equals("0") || !editdetailbodyflag || !isdeview.equals("1") || colcount1==0){
                                           %>
                                           <input type= hidden id="field<%=defieldid%>_<%=derecorderindex%>" name="field<%=defieldid%>_<%=derecorderindex%>" value="<%=defieldvalue%>">
                                           <%
                                        }
                                    }                                                       // check框条件结束






                                    else if(defieldhtmltype.equals("5")){                     // 选择框   select
                                     	String onchangeAddStr = "";
                                    	int childfieldid_tmp = Util.getIntValue((String)childfieldids.get(i), 0);
                                    	if(childfieldid_tmp != 0){
                                    		onchangeAddStr = "changeChildFieldDetail(this,"+defieldid+","+childfieldid_tmp+","+derecorderindex+")";
                                    	}
                                    	boolean hasPfield = false;
                                    	int firstPfieldid_tmp = 0;
                                    	if(childfieldids.contains(defieldid)){
                                    		firstPfieldid_tmp = Util.getIntValue((String)defieldids.get(childfieldids.indexOf(defieldid)), 0);
                                    		hasPfield = true;
                                    	}
                                            if(isdeview.equals("1") && colcount1!=0){
                                           %>
                                           <script>
                                               function funcField<%=defieldid%>(){
                                                    changeshowattr('<%=defieldid%>_1',$G('field<%=defieldid%>_<%=derecorderindex%>').value,'<%=derecorderindex%>','<%=workflowid%>','<%=nodeid%>')
                                               }
                                               //window.attachEvent("onload", funcField<%=defieldid%>);
                                                if (window.addEventListener){
	                                           	    window.addEventListener("load", funcField<%=defieldid%>, false);
	                                           	}else if (window.attachEvent){
	                                           	    window.attachEvent("onload", funcField<%=defieldid%>);
	                                           	}else{
	                                           	    window.onload=funcField<%=defieldid%>;
	                                           	}	
                                           </script>
                                           <select  notBeauty=true class=inputstyle viewtype='<%=isdemand%>' temptitle='<%=defieldlable%>' onBlur="checkinput2('field<%=defieldid%>_<%=derecorderindex%>','field<%=defieldid%>_<%=derecorderindex%>span',this.getAttribute('viewtype'));" <%if(seldefieldsdemanage.indexOf(defieldid)>=0){%>onchange="changeshowattr('<%=defieldid%>_1',this.value,<%=derecorderindex%>,<%=workflowid%>,<%=nodeid%>);<%if (trrigerdetailStr.indexOf("field" + defieldid +"_"+derecorderindex) >= 0) {%>datainputd('field<%=defieldid%>_<%=derecorderindex%>');<%}%><%=onchangeAddStr%>"<%}else{%>onchange="<%if (trrigerdetailStr.indexOf("field" + defieldid +"_"+derecorderindex) >= 0) {%>datainputd('field<%=defieldid%>_<%=derecorderindex%>');<%}%><%=onchangeAddStr%>"<%}%> <%if(isdeedit.equals("0") || !editdetailbodyflag){%> name="disfield<%=defieldid%>_<%=derecorderindex%>" id="disfield<%=defieldid%>_<%=derecorderindex%>" DISABLED <%}else{%> name="field<%=defieldid%>_<%=derecorderindex%>" id="field<%=defieldid%>_<%=derecorderindex%>"<%}%>>
                                           <option value=""></option>
                                           <%
                                        // 查询选择框的所有可以选择的值






                                        RecordSet selrs=new RecordSet();
										selrs.executeProc("workflow_SelectItemSelectByid",""+defieldid+flag+isbill);
                                        if(hasPfield==false || isdeedit.equals("0") || (isaffirmance.equals("1") && !reEdit.equals("1")) || isremark!=0 || nodetype.equals("3")){
                                          while(selrs.next()){
											  if(!isdeedit.equals("0")){
							                    int sltitemCancel = Util.getIntValue(selrs.getString("cancel"), 0);
							                    if (sltitemCancel == 1) {
						                           continue;
						                         }
							                }
                                            String tmpselectvalue = Util.null2String(selrs.getString("selectvalue"));
                                            String tmpselectname = Util.toScreen(selrs.getString("selectname"),user.getLanguage());
                                           %>
                                           <option value="<%=tmpselectvalue%>" <%if(defieldvalue.equals(tmpselectvalue)){%> selected <%}%>><%=tmpselectname%></option>
                                           <%
                                          }
                                        }else{
											while(selrs.next()){
												int sltitemCancel = Util.getIntValue(selrs.getString("cancel"), 0);
							                    if (sltitemCancel == 1) {
						                            continue;
												}
												String tmpselectvalue = Util.null2String(selrs.getString("selectvalue"));
												String tmpselectname = Util.toScreen(selrs.getString("selectname"),user.getLanguage());
                                           %>
                                           <!--<option value="<%=tmpselectvalue%>" <%if(defieldvalue.equals(tmpselectvalue)){%> selected <%}%>><%=tmpselectname%></option>--><%
											}
			                	        	selectDetailInitJsStr += "doInitDetailchildSelect("+defieldid+","+firstPfieldid_tmp+","+derecorderindex+",\""+defieldvalue+"\");\n";
			                	        	initDetailIframeStr += "<iframe id=\"iframe_"+firstPfieldid_tmp+"_"+defieldid+"_"+derecorderindex+"\" frameborder=0 scrolling=no src=\"\"  style=\"display:none\"></iframe>";
                                        }
                                               if(seldefieldsdemanage.indexOf(defieldid)>=0) dlbodychangattrstr+="changeshowattr('"+defieldid+"_1','"+defieldvalue+"',"+derecorderindex+","+workflowid+","+nodeid+");";
                                           %>
                                           </select>
                                           <span id="field<%=defieldid%>_<%=derecorderindex%>span">
                                           <%
                                                if( isdemand.equals("1") && defieldvalue.equals("") ){
                                           %>
                                            <img src="/images/BacoError_wev8.gif" align=absmiddle>
                                           <%
                                                }

                                           %>
                                            </span>
                                           <%
                                           if(changedefieldsdemanage.indexOf(defieldid)>=0){
                                        %>
                                            <input type=hidden name="oldfieldview<%=defieldid%>_<%=derecorderindex%>" value="<%=Util.getIntValue(isdeview,0)+Util.getIntValue(isdeedit,0)+Util.getIntValue(isdemand,0)%>" />
                                        <%
                                            }    
                                               }
                                        if( isdeedit.equals("0") || !isdeview.equals("1") || colcount1==0 || !editdetailbodyflag) {
                                           %>
                                           <input type= hidden id="field<%=defieldid%>_<%=derecorderindex%>" name="field<%=defieldid%>_<%=derecorderindex%>" value=<%=defieldvalue%>>
                                           <%
                                        }
                                    }                                          // 选择框条件结束 所有条件判定结束




                                    
                                    
                                    
                                    //*********************************************************************************begin
						           else if (defieldhtmltype.equals("6")) {
						           
										if(isdeview.equals("1")){
											//System.out.println("===============defieldid:"+defieldid+"  defieldname:"+defieldname+"  defieldtype:"+defieldtype+"  defieldlable:"+defieldlable+"  defieldvalue:"+defieldvalue+"  isdeedit:"+isdeedit+"  isdemand:"+isdemand);
											otherPara_hs.put("fieldimgwidth" + defieldid, "" + deimgwidth);
											otherPara_hs.put("fieldimgheight" + defieldid, "" + deimgheight);
											//otherPara_hs.put("derecorderindex", "\"+rowindex+\"");
											otherPara_hs.put("derecorderindex", ""+derecorderindex);
											otherPara_hs.put("trrigerdetailfield", trrigerdetailfield);
											
											if(deuploadfieldids!=null){
												otherPara_hs.put("uploadfieldids", deuploadfieldids);
											}
											
											int defieldlength = 0;
											int degroupid = 0;
											HtmlElement htmlelement = new FileElement();
											Hashtable ret_hs = htmlelement.getHtmlElementString(Util.getIntValue(defieldid,0), defieldname, Util.getIntValue(defieldtype,0), defieldlable, defieldlength, 1, degroupid, defieldvalue, 0, 1, Util.getIntValue(isdeedit,0), Util.getIntValue(isdemand,0), user, otherPara_hs);
											String deinputStr= Util.null2String((String) ret_hs.get("inputStr"));
										  
											String dejsStr = Util.null2String((String) ret_hs.get("jsStr"));
											String deaddRowjsStr = Util.null2String((String) ret_hs.get("addRowjsStr"))+"\n";
										    deuploadfieldids = (ArrayList) otherPara_hs.get("uploadfieldids");
											//System.out.println(deinputStr);
											
											out.println("<div>"+deinputStr+"</div>");
											out.println(" <script> \n "+dejsStr+" \n </script>");
											out.println(" <script> \n "+deaddRowjsStr+" \n </script>");
										}
						           }
		
		
		
		
		
		//*********************************************************************************end
%>
                                    
                                    
                                    
                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    


<%

                            if(colcount1!=0){
                        %>
                        <%if(  isdeview.equals("1") ) {%> </td>
                        <%}
                                }
                                }   // 明细记录循环结束
                            if(colcount1!=0){
                        %>
                        </tr>
                        <%       if(submitdtlid.equals("")){
                                    submitdtlid=""+derecorderindex;
                                }else{
                                    submitdtlid+=","+derecorderindex;
                                }
                                    }
                                derecorderindex++;
                            }       //while明细记录结束
                        }       //if结束
                        %>
                              </TBODY>
							  <%if(defshowsum){%>
                              <TFOOT>
                              <TR class=header>
                                <td></td>
								<TD ><%=SystemEnv.getHtmlLabelName(358,user.getLanguage())%></TD>
                <%
                    for (int i = 0; i < defieldids.size(); i++) {
                        if (!isdeviews.get(i).equals("1")) {
                %>
                                <td width="<%=colwidth1%>%" id="sum<%=defieldids.get(i)%>" style="display:none"></td>
                                <input type="hidden" name="sumvalue<%=defieldids.get(i)%>" >
                            <%
                        } else {
                            %>
                                <td align="right" width="<%=colwidth1%>%" id="sum<%=defieldids.get(i)%>"  style="color:red"></td>
                                <input type="hidden" name="sumvalue<%=defieldids.get(i)%>" >
                                    <%
                        }
                    }
                                    %>
                              </TR>
                              </TFOOT>
							  <%}%>
                            </table>
                            
</div>

				</wea:item>
            </wea:group>
        </wea:layout>
                       
            
                <input type='hidden' id="nodesnum<%=detailno%>" name="nodesnum<%=detailno%>" value="<%=derecorderindex%>">
                <input type='hidden' id="indexnum<%=detailno%>" name="indexnum<%=detailno%>" value="<%=derecorderindex%>">
                <input type='hidden' id='rowneed<%=detailno%>' name='rowneed<%=detailno%>' value="<%=dtlneed %>">
                <input type=hidden name ="detailsum" value="<%=detailsum%>">
                <input type='hidden' id="deldtlid<%=detailno%>" name="deldtlid<%=detailno%>" value="">
                <input type='hidden' id="submitdtlid<%=detailno%>" name="submitdtlid<%=detailno%>" value="<%=submitdtlid%>">
                <input type='hidden' name=colcalnames value="<%=colCalItemStr1%>">
                <input type=hidden name ="detailsum" value="<%=detailsum%>">
                <script language=javascript>
                
                 //zzl
                function addSapRow<%=detailno%>(groupid){
					<%	
					rscount02.execute("select browsermark  from sap_multiBrowser where mxformid='"+formid+"' and mxformname='"+tablename+"'");
	        			if(rscount02.next()){
		        			String browsermark=rscount02.getString("browsermark");
		        			%>
		        			var browsermark ="<%=browsermark%>"
		        			
		        			var urls="/systeminfo/BrowserMain.jsp?url=/integration/sapSingleBrowser.jsp?type=<%=browsermark%>|"+groupid;
		        			
							//var temp=window.showModalDialog(urls,"",tempstatus);
							var dialog = new window.top.Dialog();
							dialog.currentWindow = window;
							dialog.URL = urls;
							
							dialog.Title = "SAP";
							dialog.Width = 550 ;
							dialog.Height = 600;
							
							dialog.show();
	        			<%
	        			}else{
							out.println("alert(\""+SystemEnv.getHtmlLabelName(84117,user.getLanguage())+"\")");
						}
					%>
				}
                function addRow<%=detailno%>(obj)
                {
                        var oTable=$GetEle('oTable'+obj);
                        var initDetailfields="";
                        curindex=parseInt($GetEle('nodesnum'+obj).value);
                        rowindex=parseInt($GetEle('indexnum'+obj).value);
                        if($GetEle('submitdtlid'+obj).value==''){
                            $GetEle('submitdtlid'+obj).value=rowindex;
                        }else{
                            $GetEle('submitdtlid'+obj).value+=","+rowindex;
                        }
                        //alert(curindex+"|"+rowindex);
                        oRow = oTable.insertRow(curindex+1);
                        
                        oRow.className = "wfdetailrowblock";
                        jQuery(oRow).hover(function () {
                        	jQuery(this).addClass("Selected");
                        }, function () {
                        	jQuery(this).removeClass("Selected");
                        });
                        
                        
                        oCell = oRow.insertCell(-1);
                        oCell.style.height=24;
                        //oCell.style.background= "#E7E7E7";
                        //oCell.style.word-wrap= "normal";
						oCell.style.wordWrap= "break-word";
						oCell.style.wordBreak= "break-all";

                        var oDiv = document.createElement("div");
                        var sHtml = "<input type='checkbox' name='check_node"+obj+"' value='"+rowindex+"'>";
                        sHtml += "<input type='hidden' name='dtl_id_"+obj+"_" + rowindex + "' value=''>";
                        oDiv.innerHTML = sHtml;
                        
                        oCell.appendChild(oDiv);

						oCell = oRow.insertCell(-1);
						oCell.style.height=24;
						//oCell.style.background= "#E7E7E7";
										//oCell.style.word-wrap= "normal";
						oCell.style.wordWrap= "break-word";
						oCell.style.wordBreak= "break-all";

						var oDivxh = document.createElement("div");
									 
										//var sHtmlxh = curindex+1;
									   

						oDivxh.innerHTML = curindex+1;
						oCell.appendChild(oDivxh);
                        

                <%
                    String deaddRowFilejsStr = "";
                try{
                    for (int i = 0; i < defieldids.size(); i++) {         // 循环开始





							deaddRowFilejsStr = "";
                    		
							 String preAdditionalValue = "";
							 boolean isSetFlag = false;

                        String fieldhtml = "";
                         defieldid = (String) defieldids.get(i);  //字段id
                         //System.out.println("fieldid:"+defieldid);

                         isfieldidindex = isdefieldids.indexOf(defieldid) ;
                         if( isfieldidindex != -1 ) {
                      	   isdeview=(String)isdeviews.get(isfieldidindex);    //字段是否显示
                      	   isdeedit=(String)isdeedits.get(isfieldidindex);    //字段是否可以编辑
                      	   isdemand=(String)isdemands.get(isfieldidindex);    //字段是否必须输入
                         }

 						String trrigerdetailStr = "";
						if (trrigerdetailfield.indexOf("field"+defieldid)>=0){
							trrigerdetailStr = "datainputd(field" + defieldid + "_\"+rowindex+\")";
						}

                        if (!isdeview.equals("1")) continue;           //不显示即进行下一步循环






                        
								        //明细字段如果有节点前附加操作，取初始值 myq 2008.12.9 start
												int inoperateindex=inoperatefields.indexOf(defieldid);
												if(inoperateindex>-1){
													isSetFlag = true;
													preAdditionalValue = (String)inoperatevalues.get(inoperateindex);
												}
												//明细字段如果有节点前附加操作，取初始值 myq 2008.12.9 end

                         defieldname = "";                         //字段数据库表中的字段名






                         defieldhtmltype = "";                     //字段的页面类型






                        defieldtype = "";                         //字段的类型






                         defieldlable = "";                        //字段显示名






                        delanguageid = user.getLanguage();
                        defieldname = (String) defieldnames.get(i);
                        defieldhtmltype = (String) defieldhtmltypes.get(i);
                        defieldtype = (String) defieldtypes.get(i);
						defieldlable =(String)defieldlabels.get(i);
						fielddbtype=(String)fieldrealtype.get(i);
						
						qfws =Util.getIntValue((String)defieldqfws.get(i));
						
						deimgwidth = (String) deimgwidths.get(i);
                		deimgheight = (String) deimgheights.get(i);
                		             
						fieldlen=0;
						if ((fielddbtype.toLowerCase()).indexOf("varchar")>-1)
						{
						fieldlen=Util.getIntValue(fielddbtype.substring(fielddbtype.indexOf("(")+1,fielddbtype.length()-1));
									
						}
                        if (isdemand.equals("1"))
                          needcheck += ",field" + defieldid + "_\"+rowindex+\"";   //如果必须输入,加入必须输入的检查中
					
                        // 下面开始逐行显示字段

                        if (defieldhtmltype.equals("1")) {                          // 单行文本框






                            if (defieldtype.equals("1")) {                          // 单行文本框中的文本






                                if (isdeedit.equals("1")) {
                                    if (isdemand.equals("1")) {
                                        fieldhtml = "<input datatype='text' class=inputstyle value='"+preAdditionalValue+"' viewtype='"+isdemand+"' temptitle='"+defieldlable+"' type=text name='field" + defieldid + "_\"+rowindex+\"' size=15 onChange=\\\"checkinput3(field" + defieldid + "_\"+rowindex+\",field" + defieldid + "_\"+rowindex+\"span,this.viewtype);checkLength('field" + defieldid + "_\"+rowindex+\"','"+fieldlen+"','"+defieldlable+"','"+SystemEnv.getHtmlLabelName(20246,user.getLanguage())+"','"+SystemEnv.getHtmlLabelName(20247,user.getLanguage())+"');"+trrigerdetailStr+"\\\"><span id='field" + defieldid + "_\"+rowindex+\"span'>";
                                        if("".equals(preAdditionalValue)) fieldhtml += "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
                                        fieldhtml += "</span>";
                                    } else {
                                        fieldhtml = "<input datatype='text' class=inputstyle value='"+preAdditionalValue+"' viewtype='"+isdemand+"' temptitle='"+defieldlable+"' onchange=\\\"checkinput3(field" + defieldid + "_\"+rowindex+\",field" + defieldid + "_\"+rowindex+\"span,this.viewtype);checkLength('field" + defieldid + "_\"+rowindex+\"','"+fieldlen+"','"+defieldlable+"','"+SystemEnv.getHtmlLabelName(20246,user.getLanguage())+"','"+SystemEnv.getHtmlLabelName(20247,user.getLanguage())+"');"+trrigerdetailStr+"\\\" type=text name='field" + defieldid + "_\"+rowindex+\"' value='' size=15><span id='field" + defieldid + "_\"+rowindex+\"span'></span>";
                                    }
                                    if(changedefieldsdemanage.indexOf(defieldid)>=0){
                                        fieldhtml += "<input type=hidden name=oldfieldview" + defieldid + "_\"+rowindex+\" value="+(Util.getIntValue(isdeview,0)+Util.getIntValue(isdeedit,0)+Util.getIntValue(isdemand,0))+" />";
                                    }
                                } else {
                                    fieldhtml += "<span id='field" + defieldid + "_\"+rowindex+\"span'>"+preAdditionalValue+"</span><input class=inputstyle datatype='text' type=hidden value='"+preAdditionalValue+"' name='field" + defieldid + "_\"+rowindex+\"'>";
                                }
                            } else if (defieldtype.equals("2")) {              // 单行文本框中的整型






                                if (isdeedit.equals("1")) {
                                    if (isdemand.equals("1")) {
                                        fieldhtml = "<input datalength='0' datetype='int' datatype='int' value='"+preAdditionalValue+"' class=inputstyle viewtype='"+isdemand+"' temptitle='"+defieldlable+"' type=text name='field" + defieldid + "_\"+rowindex+\"' size=15 onKeyPress='ItemCount_KeyPress()' onChange=\\\"checkcount1(this);checkItemScale(this,'" + SystemEnv.getHtmlLabelName(31181,user.getLanguage()).replace("12","9") + "',-999999999,999999999);checkinput3(field" + defieldid + "_\"+rowindex+\",field" + defieldid + "_\"+rowindex+\"span,this.viewtype);calSum("+detailno+");"+trrigerdetailStr+"\\\"><span id='field" + defieldid + "_\"+rowindex+\"span'>";
                                        if("".equals(preAdditionalValue)) fieldhtml += "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
                                        fieldhtml += "</span>";
                                    } else {
                                        fieldhtml = "<input datalength='0' datetype='int' datatype='int' class=inputstyle value='"+preAdditionalValue+"' viewtype='"+isdemand+"' temptitle='"+defieldlable+"' type=text name='field" + defieldid + "_\"+rowindex+\"' size=15 onKeyPress='ItemCount_KeyPress()' onChange=\\\"checkcount1(this);checkItemScale(this,'" + SystemEnv.getHtmlLabelName(31181,user.getLanguage()).replace("12","9") + "',-999999999,999999999);checkinput3(field" + defieldid + "_\"+rowindex+\",field" + defieldid + "_\"+rowindex+\"span,this.viewtype);calSum("+detailno+");"+trrigerdetailStr+"\\\"><span id='field" + defieldid + "_\"+rowindex+\"span'></span>";
                                    }
                                    if(changedefieldsdemanage.indexOf(defieldid)>=0){
                                        fieldhtml += "<input type=hidden name=oldfieldview" + defieldid + "_\"+rowindex+\" value="+(Util.getIntValue(isdeview,0)+Util.getIntValue(isdeedit,0)+Util.getIntValue(isdemand,0))+" />";
                                    }
                                } else {
                                    fieldhtml += "<span id='field" + defieldid + "_\"+rowindex+\"span'>"+preAdditionalValue+"</span><input class=inputstyle   datalength='0' datetype='int' datatype='int' type=hidden value='"+preAdditionalValue+"' name='field" + defieldid + "_\"+rowindex+\"'>";
                                }
                            } else if (defieldtype.equals("3")||defieldtype.equals("5")) {                     // 单行文本框中的浮点型
                            	int decimaldigits_t = 2;
                		    	if(defieldtype.equals("3")){
                		    		int digitsIndex = fielddbtype.indexOf(",");
                		        	if(digitsIndex > -1){
                		        		decimaldigits_t = Util.getIntValue(fielddbtype.substring(digitsIndex+1, fielddbtype.length()-1), 2);
                		        	}else{
                		        		decimaldigits_t = 2;
                		        	}
                		    	}
                		    	if(defieldtype.equals("5")){
									if(qfws == -1||qfws==0){
										 decimaldigits_t=2;
									}else{
										 decimaldigits_t=qfws;
									}
									     //QC178262 规避掉如果没有输入数据的时候报错的问题
								   		 if(qfws==1 && defieldvalue.indexOf(".") > 0 && defieldvalue.length() >= (defieldvalue.indexOf(".") + qfws + 1)){
	                			    		 defieldvalue=defieldvalue.substring(0, (defieldvalue.indexOf(".")+qfws+1));
	         							}
							    	}
                		    	
                		    	preAdditionalValue = Util.toDecimalDigits(preAdditionalValue+"",decimaldigits_t);
                		    	//preAdditionalValue=Util.milfloatFormat(preAdditionalValue+"");
                		    	
                		    	String datavaluetype = "";
						    	if(defieldtype.equals("5")){
						    		datavaluetype += " datavaluetype='5'";
						    		
						    	}
						    	if(defieldtype.equals("3")||defieldtype.equals("5")){
						    		datavaluetype +="datalength='"+decimaldigits_t+"'";
						    	}
                                if (isdeedit.equals("1")) {
                                    if (isdemand.equals("1")) {
                                        fieldhtml = "<input class=inputstyle "+datavaluetype+" datetype='float' datatype='float' value='"+preAdditionalValue+"' viewtype='"+isdemand+"' temptitle='"+defieldlable+"' type=text name='field" + defieldid + "_\"+rowindex+\"' size=20 onKeyPress='ItemDecimal_KeyPress(this.name,15,"+decimaldigits_t+")' ";
                                        if(defieldtype.equals("5")) fieldhtml += " onfocus='changeToNormalFormat(this.name)' onblur='changeToThousands2(this.name,"+decimaldigits_t+")' ";
                                        fieldhtml += " onChange=\\\"checkFloat(this);checkinput3(field" + defieldid + "_\"+rowindex+\",field" + defieldid + "_\"+rowindex+\"span,this.viewtype);calSum("+detailno+");"+trrigerdetailStr+"\\\"><span id='field" + defieldid + "_\"+rowindex+\"span'>";
                                        if("".equals(preAdditionalValue)) fieldhtml += "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
                                        fieldhtml += "</span>";
                                    } else {
                                        fieldhtml = "<input class=inputstyle "+datavaluetype+" datetype='float' datatype='float' value='"+preAdditionalValue+"' viewtype='"+isdemand+"' temptitle='"+defieldlable+"' type=text name='field" + defieldid + "_\"+rowindex+\"' size=20 onKeyPress='ItemDecimal_KeyPress(this.name,15,"+decimaldigits_t+")' ";
                                        if(defieldtype.equals("5")) fieldhtml += "  onblur='changeToThousands2(this.name,"+decimaldigits_t+")'  onfocus='changeToNormalFormat(this.name)'  ";
                                        fieldhtml += " onChange=\\\"checkFloat(this);checkinput3(field" + defieldid + "_\"+rowindex+\",field" + defieldid + "_\"+rowindex+\"span,this.viewtype);calSum("+detailno+");"+trrigerdetailStr+"\\\"><span id='field" + defieldid + "_\"+rowindex+\"span'></span>";
                                    }
                                    if(changedefieldsdemanage.indexOf(defieldid)>=0){
                                        fieldhtml += "<input type=hidden name=oldfieldview" + defieldid + "_\"+rowindex+\" value="+(Util.getIntValue(isdeview,0)+Util.getIntValue(isdeedit,0)+Util.getIntValue(isdemand,0))+" />";
                                    }
                                } else {
                                    fieldhtml += "<span id='field" + defieldid + "_\"+rowindex+\"span'>"+preAdditionalValue+"</span><input class=inputstyle datatype='float' datetype='float' "+datavaluetype+"  type=hidden value='"+preAdditionalValue+"' name='field" + defieldid + "_\"+rowindex+\"'>";
                                }
                            }else if (defieldtype.equals("4")) {                     // 单行文本框中的金额转换






								//add by liaodong for qc75759 in 2013-11-20 start 
								int decimaldigits_t = 2;
								if(defieldtype.equals("4")){
									int digitsIndex = fielddbtype.indexOf(",");
									if(digitsIndex > -1){
										decimaldigits_t = Util.getIntValue(fielddbtype.substring(digitsIndex+1, fielddbtype.length()-1), 2);
									}else{
										decimaldigits_t = 2;
									}
								}
		    	              //end
                                if (isdeedit.equals("1")) {
                                    if (isdemand.equals("1")) {//xwj for td3313 20051207 必须输入时value清空以配合感叹号的显示






                                        fieldhtml = "<input id='field_lable" + defieldid + "_\"+rowindex+\"' class=inputstyle temptitle='"+defieldlable+"' value='"+preAdditionalValue+"' datetype='float' datatype='float' type=text name='field_lable" + defieldid + "_\"+rowindex+\"' size=30 onKeyPress=\\\"ItemDecimal_KeyPress('field_lable" + defieldid + "_\"+rowindex+\"',15,"+decimaldigits_t+")\\\"  onfocus=\\\"getNumber('" + defieldid + "_\"+rowindex+\"')\\\" onBlur=\\\"checkFloat(this);numberToChinese('"+defieldid+"_\"+rowindex+\"');checkinput3(field_lable" + defieldid + "_\"+rowindex+\",field" + defieldid + "_\"+rowindex+\"span,field" + defieldid + "_\"+rowindex+\".getAttribute('viewtype'));calSum("+detailno+");"+trrigerdetailStr+"\\\">";
                                    } else {
                                        fieldhtml = "<input id='field_lable" + defieldid + "_\"+rowindex+\"' class=inputstyle value='"+preAdditionalValue+"' datetype='float' datatype='float' type=text name='field_lable" + defieldid + "_\"+rowindex+\"' size=30 onKeyPress=\\\"ItemDecimal_KeyPress('field_lable" + defieldid + "_\"+rowindex+\"',15,"+decimaldigits_t+")\\\"  onBlur=\\\"checkFloat(this);numberToChinese('"+defieldid+"_\"+rowindex+\"');checkinput3(field_lable" + defieldid + "_\"+rowindex+\",field" + defieldid + "_\"+rowindex+\"span,field" + defieldid + "_\"+rowindex+\".getAttribute('viewtype'));calSum("+detailno+");"+trrigerdetailStr+"\\\" onfocus=\\\"getNumber('" + defieldid + "_\"+rowindex+\"')\\\" >";
                                    }
									//add by liaodong for qc75759 in 2013-11-20 start  fieldtype='4' datalength='"+decimaldigits_t+"'
                                    fieldhtml += "<span id='field" + defieldid + "_\"+rowindex+\"span'>";
                                    if(isdemand.equals("1")&&"".equals(preAdditionalValue)) fieldhtml += "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
                                    fieldhtml += "</span><input class=inputstyle datetype='float' datatype='float' fieldtype='4' datalength='"+decimaldigits_t+"' type=hidden viewtype='"+isdemand+"' temptitle='"+defieldlable+"' value='"+preAdditionalValue+"' name='field" + defieldid + "_\"+rowindex+\"'>";
                                    if(changedefieldsdemanage.indexOf(defieldid)>=0){
                                        fieldhtml += "<input type=hidden name=oldfieldview" + defieldid + "_\"+rowindex+\" value="+(Util.getIntValue(isdeview,0)+Util.getIntValue(isdeedit,0)+Util.getIntValue(isdemand,0))+" />";
                                    }
                                } else {
									//add by liaodong for qc75759 in 2013-11-20 start  fieldtype='4' datalength='"+decimaldigits_t+"'
                                    fieldhtml += "<input id='field_lable" + defieldid + "_\"+rowindex+\"' class=inputstyle size=30 value='"+preAdditionalValue+"'  datetype='float' datatype='float' type=text  disabled='true' name='field_lable" + defieldid + "_\"+rowindex+\"'>";
                                    fieldhtml += "&nbsp;<span id='field" + defieldid + "_\"+rowindex+\"span'></span><input class=inputstyle datetype='float' datatype='float' type=hidden value='"+preAdditionalValue+"' fieldtype='4' datalength='"+decimaldigits_t+"' name='field" + defieldid + "_\"+rowindex+\"'>";
                                }
                            }
                        }                                                       // 单行文本框条件结束






                        else if (defieldhtmltype.equals("2")) {                     // 多行文本框






                        	if(isbill.equals("0")){
                                rs_count.executeSql("select * from workflow_formdictdetail where id = " + defieldid);
                                if(rs_count.next()){
                                 textheight1 = rs_count.getString("textheight");//td3421 xwj 2005-12-31
                                }
                                }else{
                                	rs_count.executeSql("select * from workflow_billfield where viewtype=1 and id = " + defieldid+" and billid="+formid);
                        			if(rs_count.next()){
                        				textheight1 = ""+Util.getIntValue(rs_count.getString("textheight"), 4);
                        			}
                        		}
                            if (isdeedit.equals("1")) {
                                if (isdemand.equals("1")) {
                                    fieldhtml = "<textarea class=inputstyle value='"+preAdditionalValue+"' viewtype='"+isdemand+"' temptitle='"+defieldlable+"' name='field" + defieldid + "_\"+rowindex+\"' onChange=\\\"checkinput3(field" +defieldid + "_\"+rowindex+\",field" + defieldid + "_\"+rowindex+\"span,this.viewtype);checkLengthfortext('field" + defieldid + "_\"+rowindex+\"','"+fieldlen+"','"+defieldlable+"','"+SystemEnv.getHtmlLabelName(20246,user.getLanguage())+"','"+SystemEnv.getHtmlLabelName(20247,user.getLanguage())+"')\\\" rows='"+textheight1+"' cols='150' style='width:80%'></textarea><span id='field" + defieldid + "_\"+rowindex+\"span'>";
                                    if("".equals(preAdditionalValue)) fieldhtml += "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
                                    fieldhtml += "</span>";
                                } else {
                                    fieldhtml = "<textarea class=inputstyle value='"+preAdditionalValue+"' viewtype='"+isdemand+"' temptitle='"+defieldlable+"' onchange=\\\"checkinput3(field" + defieldid + "_\"+rowindex+\",field" + defieldid + "_\"+rowindex+\"span,this.viewtype);checkLengthfortext('field" + defieldid + "_\"+rowindex+\"','"+fieldlen+"','"+defieldlable+"','"+SystemEnv.getHtmlLabelName(20246,user.getLanguage())+"','"+SystemEnv.getHtmlLabelName(20247,user.getLanguage())+"')\\\" name='field" + defieldid + "_\"+rowindex+\"' rows='"+textheight1+"' cols='150' style='width:80%'></textarea><span id='field" + defieldid + "_\"+rowindex+\"span'></span>";
                                }
                                if(changedefieldsdemanage.indexOf(defieldid)>=0){
                                        fieldhtml += "<input type=hidden name=oldfieldview" + defieldid + "_\"+rowindex+\" value="+(Util.getIntValue(isdeview,0)+Util.getIntValue(isdeedit,0)+Util.getIntValue(isdemand,0))+" />";
                                    }
                            } else {
                                fieldhtml += "<span id='field" + defieldid + "_\"+rowindex+\"span'>"+preAdditionalValue+"</span><input class=inputstyle type=hidden value='"+preAdditionalValue+"' name='field" + defieldid + "_\"+rowindex+\"'>";
                            }
                        }                                                           // 多行文本框条件结束






                        else if (defieldhtmltype.equals("3")) {                         // 浏览按钮 (涉及workflow_broswerurl表)
                            String url = BrowserComInfo2.getBrowserurl(defieldtype);     // 浏览按钮弹出页面的url
                            String linkurl = BrowserComInfo2.getLinkurl(defieldtype);    //
                            String showname = "";                                   // 新建时候默认值显示的名称
                            String showid = "";                                     // 新建时候默认值








							if ((defieldtype.equals("8") || defieldtype.equals("135")) && !prjid.equals("")) {       //浏览按钮为项目,从前面的参数中获得项目默认值






									showid = "" + Util.getIntValue(prjid, 0);
								} else if ((defieldtype.equals("9") || defieldtype.equals("37")) && !docid.equals("")) { //浏览按钮为文档,从前面的参数中获得文档默认值






									showid = "" + Util.getIntValue(docid, 0);
								} else if ((defieldtype.equals("1") || defieldtype.equals("17") || defieldtype.equals("165") || defieldtype.equals("166")) && !hrmid.equals("") && body_isagent !=1) { //浏览按钮为人,从前面的参数中获得人默认值






									showid = "" + Util.getIntValue(hrmid, 0);
								}else if ((defieldtype.equals("1") || defieldtype.equals("17") || defieldtype.equals("165") || defieldtype.equals("166")) && !hrmid.equals("") && body_isagent ==1) { //代理，浏览按钮为人,从前面的参数中获得人默认值






									showid = "" + Util.getIntValue(beagenter, 0);
								} else if ((defieldtype.equals("7") || defieldtype.equals("18")) && !crmid.equals("")) { //浏览按钮为CRM,从前面的参数中获得CRM默认值






									showid = "" + Util.getIntValue(crmid, 0);
								} else if ((defieldtype.equals("4") || defieldtype.equals("57") || defieldtype.equals("167") || defieldtype.equals("168")) && !hrmid.equals("") && body_isagent !=1) { //浏览按钮为部门,从前面的参数中获得人默认值(由人力资源的部门得到部门默认值)
									showid = "" + Util.getIntValue(ResourceComInfo2.getDepartmentID(hrmid), 0);
								} else if ((defieldtype.equals("4") || defieldtype.equals("57") || defieldtype.equals("167") || defieldtype.equals("168")) && !hrmid.equals("") && body_isagent ==1) { //代理，浏览按钮为部门,从前面的参数中获得人默认值(由人力资源的部门得到部门默认值)
									showid = "" + Util.getIntValue(ResourceComInfo2.getDepartmentID(beagenter), 0);
								}else if ((defieldtype.equals("24")||defieldtype.equals("278")) && !hrmid.equals("")&& body_isagent !=1) { //浏览按钮为职务,从前面的参数中获得人默认值(由人力资源的职务得到职务默认值)
									showid = "" + Util.getIntValue(ResourceComInfo2.getJobTitle(hrmid), 0);
                                }else if ((defieldtype.equals("24")||defieldtype.equals("278")) && !hrmid.equals("")&& body_isagent ==1) { //代理，浏览按钮为职务,从前面的参数中获得人默认值(由人力资源的职务得到职务默认值)
                                    showid = "" + Util.getIntValue(ResourceComInfo2.getJobTitle(beagenter), 0);
								} else if (defieldtype.equals("32") && !hrmid.equals("")) { //浏览按钮为职务,从前面的参数中获得人默认值(由人力资源的职务得到职务默认值)
									showid = "" + Util.getIntValue(request.getParameter("TrainPlanId"), 0);
								} else if((defieldtype.equals("164") || defieldtype.equals("169") || defieldtype.equals("170") || defieldtype.equals("194")) && !hrmid.equals("") && body_isagent!=1){ //浏览按钮为分部,从前面的参数中获得人默认值(由人力资源的分部得到分部默认值)
									showid = "" + Util.getIntValue(ResourceComInfo2.getSubCompanyID(hrmid),0);
								}else if((defieldtype.equals("164") || defieldtype.equals("169") || defieldtype.equals("170") || defieldtype.equals("194")) && !hrmid.equals("") && body_isagent==1){ //代理，浏览按钮为分部,从前面的参数中获得人默认值(由人力资源的分部得到分部默认值)
									showid = "" + Util.getIntValue(ResourceComInfo2.getSubCompanyID(beagenter),0);
								}

								if (showid.equals("0")) showid = "";
					            if(isSetFlag){
	                          showid = preAdditionalValue;
	                      }
			            if(defieldtype.equals("178")){ 
			                 if(!isSetFlag){
			                    showname = currentyear;
			                    showid = currentyear;
			                }else{
			                    showname=preAdditionalValue;
			                    showid=preAdditionalValue;
			                }
			            }
							if (!showid.equals("")) {       // 获得默认值对应的默认显示值,比如从部门id获得部门名称
							    ArrayList tempshowidlist=Util.TokenizerString(showid,",");
                                 if(defieldtype.equals("1") ||defieldtype.equals("17")||defieldtype.equals("165")||defieldtype.equals("166")){
                                     //人员，多人员
                                     for(int k=0;k<tempshowidlist.size();k++){
                                         if(!linkurl.equals("")){
                                         	if("/hrm/resource/HrmResource.jsp?id=".equals(linkurl))
                                           	{
                                         		showname+="<a href='javaScript:openhrm("+tempshowidlist.get(k)+");' onclick='pointerXY(event);'>"+ResourceComInfo2.getResourcename((String)tempshowidlist.get(k))+"</a>&nbsp";
                                           	}
                                         	else
                                             showname+="<a href='"+linkurl+tempshowidlist.get(k)+"&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"'>"+ResourceComInfo2.getResourcename((String)tempshowidlist.get(k))+"</a>&nbsp";
                                         }else{
                                         showname+=ResourceComInfo2.getResourcename((String)tempshowidlist.get(k))+" ";
                                         }
                                     }
                                 }else if(defieldtype.equals("7") || defieldtype.equals("18")){
                                     //客户，多客户
                                     for(int k=0;k<tempshowidlist.size();k++){
                                         if(!linkurl.equals("")){
                                             showname+="<a href='"+linkurl+tempshowidlist.get(k)+"&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"'>"+CustomerInfoComInfo2.getCustomerInfoname((String)tempshowidlist.get(k))+"</a>&nbsp";
                                         }else{
                                         showname+=CustomerInfoComInfo2.getCustomerInfoname((String)tempshowidlist.get(k))+" ";
                                         }
                                     }
                                 }else if(defieldtype.equals("4") || defieldtype.equals("57")){
                                     //部门，多部门
                                     for(int k=0;k<tempshowidlist.size();k++){
                                    	 String showdeptname = "";
                 						 String showdeptid = (String) tempshowidlist.get(k);
                 						 if(!"".equals(showdeptid)){
                 							if(Integer.parseInt(showdeptid) < -1){
                 								showdeptname = deptVirComInfo2.getDepartmentname(showdeptid);
                 								
                 							}else{
                 								showdeptname = DepartmentComInfo2.getDepartmentname(showdeptid);
                 							}
                 						 }
                                         if(!linkurl.equals("")){
                                             showname+="<a href='"+linkurl+tempshowidlist.get(k)+"&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"'>"+showdeptname+"</a>&nbsp";
                                         }else{
                                         	showname+=showdeptname+" ";
                                         }
                                     }
                                 }else if(defieldtype.equals("164") || defieldtype.equals("194")){
	                  			  //分部、多分部
			                   		for(int k=0;k<tempshowidlist.size();k++){
			                   			String showsubcompname = "";
			    						String showsubcompid = (String) tempshowidlist.get(k);
			    						if(!"".equals(showsubcompid)){
			    							if(Integer.parseInt(showsubcompid) < -1){
			    								showsubcompname = subCompVirComInfo2.getSubCompanyname(showsubcompid);
			    							}else{
			    								showsubcompname = SubCompanyComInfo2.getSubCompanyname(showsubcompid);
			    							}
			    						}
				                        if(!linkurl.equals("")){
				                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"'>"+showsubcompname+"</a>&nbsp";
				                        }else{
				                        	showname+=showsubcompname+" ";
				                        }
		                   		 	}
	              		  		}else if(defieldtype.equals("224") || defieldtype.equals("225")||defieldtype.equals("226") || defieldtype.equals("227")){
                                               //zzl赋予默认值






                                        	showname=preAdditionalValue;
                                      }
                                      else{
                                          String tablename2 =  Util.null2String(BrowserComInfo2.getBrowsertablename(defieldtype));
                                          String columname =  Util.null2String(BrowserComInfo2.getBrowsercolumname(defieldtype));
                                          String keycolumname =  Util.null2String(BrowserComInfo2.getBrowserkeycolumname(defieldtype));
                                           //sql = "select " + columname + " from " + tablename2 + " where " + keycolumname + "=" + showid;
                                          if(!tablename2.equals("")&&!columname.equals("")&&!keycolumname.equals("")){
                                              sql = "select " + columname + " from " + tablename2 + " where " + keycolumname + "=" + showid;

                                          RecordSet.executeSql(sql);
                                          if (RecordSet.next()) {
                                               if(defieldtype.equals("263")){
												    showname = RecordSet.getString(1);
											  }else{
												    if (!linkurl.equals(""))
                                                  showname = "<a href='" + linkurl + showid + "'>" + RecordSet.getString(1) + "</a>&nbsp";
                                                else
                                                  showname = RecordSet.getString(1);
											  }
                                          }
                                          }
                                       }
									}
								if (defieldtype.equals("2")) {                              // 浏览按钮为日期






										//showname = currentdate;
										//showid = currentdate;
					                if(!isSetFlag){
					                    showname = currentdate;
					                    showid = currentdate;
					                }else{
					                    showname=preAdditionalValue;
					                    showid=preAdditionalValue;
					                }
									}
								if (defieldtype.equals("19")) {                              // 浏览按钮为时间






									if(!isSetFlag){
										showname = currenttime.substring(0,5);
										showid = currenttime.substring(0,5);
									}else{
										showname=preAdditionalValue;
										showid=preAdditionalValue;
									}
									}
			            	if (defieldtype.equals("161")||defieldtype.equals("162")) {                              //自定义浏览框
                                url+="?type="+fielddbtype;
                                showname = "";                                   // 新建时候默认值显示的名称
								try{
						            Browser browser=(Browser)StaticObj.getServiceByFullname(fielddbtype, Browser.class);
									List l=Util.TokenizerString(preAdditionalValue,",");
						            for(int j=0;j<l.size();j++){
									    String curid=(String)l.get(j);
									    curid = curid.replace("&#039;","'").replace("&quot;", "\"");
							            BrowserBean bb=browser.searchById(curid);
										String name=Util.null2String(bb.getName());
										String desc=Util.null2String(bb.getDescription());
			                            String href=Util.null2String(bb.getHref());
			                            if(href.equals("")){
			                            	showname+="<a title='"+desc+"'>"+name+"</a>&nbsp";
			                            }else{
			                            	showname+="<a title='"+desc+"' href='"+href+"' target='_blank'>"+name+"</a>&nbsp";
			                            }
									}
								}catch(Exception e){
								}
								
								showid = preAdditionalValue;
			                }
			            	if (defieldtype.equals("256")||defieldtype.equals("257")) {                              //自定义浏览框
                                url+="?type="+fielddbtype+"_"+defieldtype;
								CustomTreeUtil customTreeUtil = new CustomTreeUtil();
								showid = preAdditionalValue;
								showname = customTreeUtil.getTreeFieldShowName(preAdditionalValue,fielddbtype);
                			}
							
							if (defieldtype.equals("224")||defieldtype.equals("225")||defieldtype.equals("226")||defieldtype.equals("227")) {                            
									  //zzl
		                              url+="?type="+fielddbtype+"|"+defieldid;	
								
			                }
							
							
                            if (isdeedit.equals("1")) {
                            	try {
		      				         showname = showname.replaceAll("</a>&nbsp", "</a>,");      				        
		      				         if (showname.lastIndexOf("</a>,") != -1 && showname.lastIndexOf("</a>,") == showname.length() - 5) {
		      				           	 showname = showname.substring(0, showname.length()-1);
		      				         }
		      				    } catch (Exception e) {
		      				        e.printStackTrace();
		      				    }
                                %>
				                var detaibrowshowid = "<%=showid %>";
				                var detaibrowshowname = "<%=Util.toScreen(showname, user.getLanguage()) %>";
				                var hasAdd = "false";
                                var addOnClick;
				                <%
                                if (!defieldtype.equals("37")) {    //  多文档特殊处理






                                     if (trrigerdetailfield.indexOf("field"+defieldid)>=0){
					                     //fieldhtml = "<BUTTON id='field" + defieldid + "_\"+rowindex+\"browser' name='field" + defieldid + "_\"+rowindex+\"browser' type=button  class=Browser onclick=\\\"onShowBrowser2('" + defieldid + "_\"+rowindex+\"','" + url + "','" + linkurl + "','" +defieldtype + "',field" + defieldid + "_\"+rowindex+\".getAttribute('viewtype'));datainputd('field" + defieldid + "_\"+rowindex+\"')\\\" title='" + SystemEnv.getHtmlLabelName(172, user.getLanguage()) + "'></button>";
					                     %>
					                     detailbrowclick = "onShowBrowser2('<%=defieldid  %>_"+rowindex+"','<%=url%>','<%=linkurl%>','<%=defieldtype%>',field<%=defieldid  %>_"+rowindex+".getAttribute('viewtype'));datainputd('field<%=defieldid  %>_"+rowindex+"')";
					                     <%
									 }else{
									     if(defieldtype.equals("2") || defieldtype.equals("19")){
									  		 fieldhtml = "<BUTTON  id='field" + defieldid + "_\"+rowindex+\"browser' name='field" + defieldid + "_\"+rowindex+\"browser' type=button  class=Browser onclick=\\\"onShowBrowser2('" + defieldid + "_\"+rowindex+\"','" + url + "','" + linkurl + "','" +defieldtype + "',field" + defieldid + "_\"+rowindex+\".getAttribute('viewtype'))\\\" title='" + SystemEnv.getHtmlLabelName(172, user.getLanguage()) + "'></button>";
									     } else {
										%>
				                        detailbrowclick = "onShowBrowser2('<%=defieldid  %>_"+rowindex+"','<%=url %>','<%=linkurl %>','<%=defieldtype%>',field<%=defieldid  %>_"+rowindex+".getAttribute('viewtype'))";
				                        <%
									     }
									 }
                                } else {                         // 如果是多文档字段,加入新建文档按钮
                                	//fieldhtml = "<BUTTON id='field" + defieldid + "_\"+rowindex+\"browser' name='field" + defieldid + "_\"+rowindex+\"browser' type=button  class=AddDocFlow onclick=\\\"onShowBrowser2('" + defieldid + "_\"+rowindex+\"','" + url + "','" + linkurl + "','" + defieldtype + "',field" + defieldid + "_\"+rowindex+\".getAttribute('viewtype'))\\\">" + SystemEnv.getHtmlLabelName(611, user.getLanguage()) + "</button>&nbsp;&nbsp<BUTTON type=button  class=AddDocFlow onclick=\\\"onNewDoc('" + defieldid + "_\"+rowindex+\"')\\\" title='" + SystemEnv.getHtmlLabelName(82, user.getLanguage()) + "'>" + SystemEnv.getHtmlLabelName(82, user.getLanguage()) + "</button>";
                                	//fieldhtml = "<button type=button  class=AddDocFlow onclick=\\\"onNewDoc('" + defieldid + "_\"+rowindex+\"')\\\" title='" + SystemEnv.getHtmlLabelName(82, user.getLanguage()) + "'>" + SystemEnv.getHtmlLabelName(82, user.getLanguage()) + "</button>";
                                	%>
                                	hasAdd = "true";
                                	addOnClick = "onNewDoc('<%=defieldid %>_" + rowindex + "')";
	                               	 detailbrowclick = "onShowBrowser2('<%=defieldid  %>_"+rowindex+"','<%=url%>','<%=linkurl%>','<%=defieldtype%>',field<%=defieldid  %>_"+rowindex+".getAttribute('viewtype'))";
	                               	<%
                                }
				                if(!defieldtype.equals("2") && !defieldtype.equals("19")){
				                	fieldhtml = "<span id=\\\"field" + defieldid + "_\"+rowindex+\"wrapspan\\\"></span>";
									if(defieldtype.equals("58")){    //城市
										String areaMustInput = isdemand.equals("1") ? "2" : "1";
										String areaselectName = "field" + defieldid + "_\"+rowindex+\"";
										fieldhtml =  " <div areaType=city areaName='"+areaselectName+"' areaValue='" + showid + "'   areaSpanValue='" + Util.formatMultiLang(showname) + "'  areaMustInput='" + areaMustInput + "'  areaCallback='browAreaSelectCallback'  class='_areaselect' id='_areaselect_field" + defieldid + "_\"+rowindex+\"'></div>";
								   }
								   if(defieldtype.equals("263")){   //区县
										 String areaMustInput = isdemand.equals("1") ? "2" : "1";
										 String areaselectName = "field" + defieldid + "_\"+rowindex+\"";
										 fieldhtml =  " <div areaType=citytwo areaName='"+areaselectName+"' areaValue='" + showid + "'   areaSpanValue='" + Util.formatMultiLang(showname) + "'  areaMustInput='" + areaMustInput + "'  areaCallback='browAreaSelectCallback'  class='_areaselect' id='_areaselect_field" + defieldid + "_\"+rowindex+\"'></div>";
								   }
				                }
                            } else if(!defieldtype.equals("2") && !defieldtype.equals("19")){
                            	fieldhtml = "<span id=\\\"field" + defieldid + "_\"+rowindex+\"span\\\">"+showname+"</span>";
                            }
                            fieldhtml += "<input type=hidden viewtype='"+isdemand+"' temptitle='"+defieldlable+"' name='field" + defieldid + "_\"+rowindex+\"' id='field" + defieldid + "_\"+rowindex+\"' value='" + showid + "'";
                            if(trrigerdetailfield.indexOf("field"+defieldid)>=0){
                            	fieldhtml += " onpropertychange=\\\"datainputd('field" + defieldid + "_\"+rowindex+\"');\\\" ";
                            }
                            fieldhtml += ">";
                            if(defieldtype.equals("2") || defieldtype.equals("19")){
	                            fieldhtml += "<span id='field" + defieldid + "_\"+rowindex+\"span'>" + Util.toScreen(showname, user.getLanguage());
	                            if (isdemand.equals("1") && showname.equals("")) {
	                                fieldhtml += "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
	                            }
	                            fieldhtml += "</span>";
                            }
                            if(defieldtype.equals("87")||defieldtype.equals("184")){
                                fieldhtml += "&nbsp;&nbsp;<A href='/meeting/report/MeetingRoomPlan.jsp' target='blank'>"+SystemEnv.getHtmlLabelName(2193,user.getLanguage())+"</A>";
                            }
                            if(changedefieldsdemanage.indexOf(defieldid)>=0){
                                        fieldhtml += "<input type=hidden name=oldfieldview" + defieldid + "_\"+rowindex+\" id=oldfieldview" + defieldid + "_\"+rowindex+\" value="+(Util.getIntValue(isdeview,0)+Util.getIntValue(isdeedit,0)+Util.getIntValue(isdemand,0))+" />";
                                    }
                        }                                                       // 浏览按钮条件结束
                        else if (defieldhtmltype.equals("4")) {                    // check框






                            fieldhtml += "<input class=inputstyle viewtype='"+isdemand+"' type=checkbox value=1 ";
							if("1".equals(preAdditionalValue)) fieldhtml += " checked ";
                            if(isdeedit.equals("0"))	fieldhtml += " DISABLED ";
                            fieldhtml += " name='field" + defieldid + "_\"+rowindex+\"'>";
                            if(changedefieldsdemanage.indexOf(defieldid)>=0){
                                fieldhtml += "<input type=hidden name=oldfieldview" + defieldid + "_\"+rowindex+\" value="+(Util.getIntValue(isdeview,0)+Util.getIntValue(isdeedit,0)+Util.getIntValue(isdemand,0))+" />";
                            }
                        }                                                       // check框条件结束






                        else if (defieldhtmltype.equals("5")) {                     // 选择框   select
                        	//处理select字段联动
                         	String onchangeAddStr = "";
                        	int childfieldid_tmp = Util.getIntValue((String)childfieldids.get(i), 0);
                        	if(childfieldid_tmp != 0){
                        		onchangeAddStr = ";changeChildFieldDetail(this,"+defieldid+","+childfieldid_tmp+",\"+rowindex+\")";
                        	}
                        	boolean hasPfield = false;
                        	int firstPfieldid_tmp = 0;
                        	if(childfieldids.contains(defieldid)){
                        		firstPfieldid_tmp = Util.getIntValue((String)defieldids.get(childfieldids.indexOf(defieldid)), 0);
                        		hasPfield = true;
                        	}
                            fieldhtml = "<select  notBeauty=true class=inputstyle viewtype='"+isdemand+"' temptitle='"+defieldlable+"' ";
                            if(seldefieldsdemanage.indexOf(defieldid)>=0){
                             fieldhtml += " onChange=checkinput3(field" + defieldid + "_\"+rowindex+\",field" + defieldid + "_\"+rowindex+\"span,this.viewtype);changeshowattr('"+defieldid+"_1',this.value,\"+rowindex+\","+workflowid+","+nodeid+");" + trrigerdetailStr+onchangeAddStr+" ";
                            }else{
                            fieldhtml += " onChange=checkinput3(field" + defieldid + "_\"+rowindex+\",field" + defieldid + "_\"+rowindex+\"span,this.viewtype);" + trrigerdetailStr+onchangeAddStr+" ";
                            }
                            if (isdeedit.equals("0")){
                                fieldhtml += " name='disfield" + defieldid + "_\"+rowindex+\"' id='disfield" + defieldid + "_\"+rowindex+\"' DISABLED " ;
                            }else{
                                fieldhtml += " name='field" + defieldid + "_\"+rowindex+\"' id='field" + defieldid + "_\"+rowindex+\"'" ;
                            }
                            fieldhtml += ">";
                            fieldhtml += "<option value=''></option>";
                            // 查询选择框的所有可以选择的值






                            RecordSet selrs=new RecordSet();
                            boolean checkemptydetail1 = true;
                            if(hasPfield==false || isdeedit.equals("0")){
                            	selrs.executeProc("workflow_SelectItemSelectByid", "" + defieldid + flag + isbill);
                            	while (selrs.next()) {
                            	    
                            	    if(!isdeedit.equals("0")){
                                        int sltitemCancel = Util.getIntValue(selrs.getString("cancel"), 0);
                                        if (sltitemCancel == 1) {
                                           continue;
                                         }
                                    }
                            	    
								                String tmpselectvalue = Util.null2String(selrs.getString("selectvalue"));
								                String tmpselectname = Util.toScreen(selrs.getString("selectname"), user.getLanguage());
								                 /* -------- xwj for td2977 20051107 begin ----*/
								                String isdefault = Util.toScreen(selrs.getString("isdefault"),user.getLanguage());
								                if("".equals(preAdditionalValue)){
									                if("y".equals(isdefault)){
										                checkemptydetail1 = false;
										                fieldhtml += "<option value='" + tmpselectvalue + "' selected>" + tmpselectname + "</option>";
										              }else{
										              	 fieldhtml += "<option value='" + tmpselectvalue + "'>" + tmpselectname + "</option>";
										              }
								                }
								                else{
								                	checkemptydetail1 = false;
										              fieldhtml += "<option value='" + tmpselectvalue + "'";
								                	if(tmpselectvalue.equals(preAdditionalValue)) fieldhtml += "selected";
								                	fieldhtml += ">" + tmpselectname + "</option>";
								                }
								                /* -------- xwj for td2977 20051107 end ----*/
								            }
                            }else{
                            	selectDetailInitJsStrAdd += "doInitDetailchildSelectAdd("+defieldid+","+firstPfieldid_tmp+",rowindex,\"\");";
                            	initDetailIframeStrAdd += "<iframe id=\"iframe_"+firstPfieldid_tmp+"_"+defieldid+"\" frameborder=0 scrolling=no src=\"\"  style=\"display:none\"></iframe>";
                            }
                            fieldhtml += "</select><span id='field" + defieldid + "_\"+rowindex+\"span'>";
								            if("1".equals(isdemand) && checkemptydetail1){
								            fieldhtml +="<img src='/images/BacoError_wev8.gif' align=absmiddle>";
								            }
								            fieldhtml += "</span>";
								            if (isdeedit.equals("0")){
								            fieldhtml += "<input type=hidden name='field" + defieldid + "_\"+rowindex+\"' value='" + preAdditionalValue + "'>";
								            }
                            if(changedefieldsdemanage.indexOf(defieldid)>=0){
                                        fieldhtml += "<input type=hidden name=oldfieldview" + defieldid + "_\"+rowindex+\" value="+(Util.getIntValue(isdeview,0)+Util.getIntValue(isdeedit,0)+Util.getIntValue(isdemand,0))+" />";
                                    }
                        }                                          // 选择框条件结束 所有条件判定结束




                        
                         //*********************************************************************************begin
						           else if (defieldhtmltype.equals("6")) {
										if(isdeview.equals("1")){
											//System.out.println("===============defieldid:"+defieldid+"  defieldname:"+defieldname+"  defieldtype:"+defieldtype+"  defieldlable:"+defieldlable+"  defieldvalue:"+defieldvalue+"  isdeedit:"+isdeedit+"  isdemand:"+isdemand);
											otherPara_hs.put("fieldimgwidth" + defieldid, "" + deimgwidth);
											otherPara_hs.put("fieldimgheight" + defieldid, "" + deimgheight);
											otherPara_hs.put("derecorderindex", "\"+rowindex+\"");
											//otherPara_hs.put("derecorderindex", ""+derecorderindex);
											otherPara_hs.put("trrigerdetailfield", trrigerdetailfield);
			  
											
											int defieldlength = 0;
											int degroupid = 0;
											HtmlElement htmlelement = new FileElement();
											Hashtable ret_hs = htmlelement.getHtmlElementString(Util.getIntValue(defieldid,0), defieldname, Util.getIntValue(defieldtype,0), defieldlable, defieldlength, 1, degroupid, "", 0, 1, Util.getIntValue(isdeedit,0), Util.getIntValue(isdemand,0), user, otherPara_hs);
											String deinputStr= Util.null2String((String) ret_hs.get("inputStr"));
										  
											String dejsStr = Util.null2String((String) ret_hs.get("jsStr"));
											deaddRowFilejsStr = Util.null2String((String) ret_hs.get("addRowjsStr"))+"\n";
										   
										   
											fieldhtml += deinputStr+"  ";
										}
						           }
		
		
		
		
		
		//*********************************************************************************end


                %>


                        oCell = oRow.insertCell(-1);
                        oCell.style.height=24;
                        //oCell.style.background= "#E7E7E7";
						oCell.style.wordWrap= "break-word";
						oCell.style.wordBreak= "break-all";

                        var oDiv = document.createElement("div");
                        var sHtml = "<%=fieldhtml%>" ;
                       
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        
                        <%=deaddRowFilejsStr%>
				       	<%
				         if (defieldhtmltype.equals("3") && isdeedit.equals("1")) {  
				             if(!defieldtype.equals("2") && !defieldtype.equals("19")){
				             String hasInputStr = "true";
            				 //if(defieldtype.equals("256")||defieldtype.equals("257")){
            				//	 hasInputStr = "false";
            				 //}
							 if(defieldtype.equals("58")||defieldtype.equals("263")){
								 %>
								   areromancedivbyid("_areaselect_field<%=defieldid %>_"+ rowindex,-1);
								<%	   
							 }
				         %>
					        jQuery("#field<%=defieldid %>_" + rowindex + "wrapspan").e8Browser({
							   name:"field<%=defieldid %>_" + rowindex,
							   viewType:"1",
							   browserValue: detaibrowshowid,
							   browserSpanValue: detaibrowshowname,
							   browserOnClick : detailbrowclick,
							   hasInput:<%=hasInputStr%>,
							   type:<%=defieldtype%>,
							   linkUrl:'<%=BrowserComInfo2.getLinkurl(defieldtype)%>',
							   isSingle:<%=BrowserManager.browIsSingle(defieldtype) %>,
							   hasBrowser:true, 
							   <%if(defieldtype.equals("161")||defieldtype.equals("162")){%>
							   nameSplitFlag:'~~WEAVERSplitFlag~~',
							   <%}%>
							   isMustInput:"<%=isdemand.equals("1") ? "2" : "1" %>",
							   <%if(defieldtype.equals("161")||defieldtype.equals("162")){%>
								   completeUrl:"<%="javascript:getajaxurl(" + defieldtype + ",'"+fielddbtype+"')"%>",
							   <%}else{%>
								   completeUrl:"<%="javascript:getajaxurl(" + defieldtype + ")"%>",
							   <%}%>
							   width:"100%",
							   needHidden:false,
							   onPropertyChange:"<%="wfbrowvaluechange(this," + defieldid + ",  \" + rowindex + \")" %>",
							   hasAdd: hasAdd,
							   addOnClick: addOnClick
						  });
                       <%
				             }
                       }
                        if (trrigerdetailfield.indexOf("field"+defieldid)>=0){
                        %>
                        //datainputd("field<%=defieldid%>_"+rowindex);
                        initDetailfields += "field<%=defieldid%>_"+rowindex+",";
                        <%
                        }
                        if(seldefieldsdemanage.indexOf(defieldid)>=0){
                        %>
                        changeshowattr('<%=defieldid%>_1',$G('field<%=defieldid%>_'+rowindex).value,rowindex,'<%=workflowid%>','<%=nodeid%>');
                        <%
                        }
                			//System.out.println("field type:"+defieldtype);
                    }       // 循环结束
                    }catch(Exception e){
						}
                %>
                	try
                	{
	                    if ("<%=needcheck%>" != ""){
	                        $GetEle("needcheck").value += ",<%=needcheck%>";
	                    }
	                    datainputd(initDetailfields);
						<%=selectDetailInitJsStrAdd%>
					}
					catch(e)
					{
					}
					
					
                    rowindex = rowindex*1 +1;
                    curindex = curindex*1 +1;
                    $GetEle("nodesnum"+obj).value = curindex ;
                    $GetEle('indexnum'+obj).value = rowindex;
                    calSum(obj);
                    
                    
                    try {
                    	//美化checkbox
                    	jQuery(oTable).jNice();
                    	//beautySelect();
                    } catch (e) {}
                }
              
                <%
				//提交确认页面不需要 默认添加行






				if(dtldefault.equals("1")&&derecorderindex<1 && !(isaffirmance.equals("1") && nodetype.equals("0") && !reEdit.equals("1")))
				{
				%>
				jQuery(document).ready(function () {
				    
					addRow<%=detailno%>(<%=detailno%>);
					
					<%
					RecordSet.executeSql(" select defaultrows from workflow_NodeFormGroup where nodeid=" + nodeid + " and groupid=" + detailno);
					RecordSet.next();
					int defaultrows = Util.getIntValue(RecordSet.getString("defaultrows"),0);
					%>
					
					defaultrows = <%=defaultrows %>;
			
					for(var k = 0; k < parseInt(defaultrows)-1; k++) {
						addRow<%=detailno%>(<%=detailno%>);
					}
					
				});
				<%	
				}
				%>
              </script>
<%
                  detailno++;
                //}//if end
              }     //多明细循环结束







 
%>
<script language=javascript>
function deleteRow1(obj)
{
    var flag = false;
	var ids = document.getElementsByName('check_node'+obj);
	for(i=0; i<ids.length; i++) {
		if(ids[i].checked==true) {
			flag = true;
			break;
		}
	}
    if(flag) {
    	top.Dialog.confirm('<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>', function() {
    		var oTable=$G('oTable'+obj);
            curindex=parseInt($G("nodesnum"+obj).value);
            len = document.forms[0].elements.length;
            var i=0;
            var rowsum1 = 0;
            for(i=len-1; i >= 0;i--) {
                if (document.forms[0].elements[i].name=='check_node'+obj)
                    rowsum1 += 1;
            }
            for(i=len-1; i >= 0;i--) {
                if (document.forms[0].elements[i].name=='check_node'+obj){
                    if(document.forms[0].elements[i].checked==true) {
                         //记录被删除的旧记录 id串






                        if(jQuery(oTable.rows[rowsum1].cells[0]).children().length > 1){
                            if($G("deldtlid"+obj).value!=''){
                                //老明细






                                $G("deldtlid"+obj).value+="," + jQuery(oTable.rows[rowsum1].cells[0]).children()[1].value;
                            }else{
                                //新明细






                                $G("deldtlid"+obj).value = jQuery(oTable.rows[rowsum1].cells[0]).children()[1].value;
                            }
                        }

                        //删除行






                        oTable.deleteRow(rowsum1);
                        curindex--;
                    }
                    rowsum1 -=1;

                }
            }
            
            var submitDtlIds = "";
            var chkObj = document.getElementsByName('check_node'+obj);
            for(var m = 0; m<chkObj.length; m++){
            	if(chkObj[m] != null && chkObj[m] != undefined){
            		submitDtlIds += "," + chkObj[m].value;
            	}
            }
            $GetEle("submitdtlid"+obj).value = submitDtlIds.substring(1);

            var rows = oTable.rows.length ;
            for(k=1; k < rows;k++){
                if(oTable.rows[k].cells[1].innerText!="<%=SystemEnv.getHtmlLabelName(358,user.getLanguage())%>"){
                    oTable.rows[k].cells[1].innerText=k;
                }
            }
            $GetEle("nodesnum"+obj).value=curindex;
            calSum(obj);
    	});
    }else{
        top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>');
		return;
    }
}

</script>

<%
    ArrayList rowCalAry = new ArrayList();
    ArrayList rowCalSignAry = new ArrayList();
	ArrayList mainCalAry = new ArrayList();
    ArrayList tmpAry = null;

	StringTokenizer stk2 = new StringTokenizer(rowCalItemStr1,";");
	//out.println(rowCalItemStr1);

	ArrayList newRowCalArray = new ArrayList();

	while(stk2.hasMoreTokens()){
		//out.println(stk2.nextToken(";"));
		rowCalAry.add(stk2.nextToken(";"));
	}
	stk2 = new StringTokenizer(mainCalStr1,";");
	while(stk2.hasMoreTokens()){
		//out.println(stk2.nextToken(";"));
		mainCalAry.add(stk2.nextToken(";"));
	}
	//out.println(mainCalStr1);

%>
<%=initDetailIframeStrAdd%>
<%=initDetailIframeStr%>
<script language="javascript">
rowindex = <%=derecorderindex%>;
curindex = <%=derecorderindex%> ;

<%--added by Charoes Huang FOR Bug 625--%>
function parse_Float(i){
	try{
	    i =parseFloat(i);
		if(i+""=="NaN")
			return 0;
		else
			return i;
	}catch(e){
		return 0;
	}
}
function calSumPrice(){
    var temv1;
    var datalength = 2;
    var evt = getEvent();
    var tempi = arguments[0] ;
<%
    String temStr = "";
    for(int i=0; i<rowCalAry.size(); i++){
        temStr = "";
		String calExp = (String)rowCalAry.get(i);
        ArrayList calExpList=DynamicDataInput.FormatString(calExp);
        //System.out.println("calExp:"+calExp);
%>
    //for( i=0; i<rowindex; i++){
        try{
            //var nowobj=(evt.srcElement ? evt.srcElement : evt.target).name.toString();
            var i;
            try{
	            var nowobj=window.event.srcElement.name.toString();
	            if(nowobj.indexOf('_')>-1){
	                i=nowobj.substring(nowobj.indexOf('_')+1);
	                if(i.indexOf('_')>-1)
	                    i=i.substring(i.indexOf('_')+1);
	            }
            }catch(e){
            	i = tempi ;
            }
			//var i = window.event.srcElement.parentElement.parentElement.parentElement.rowIndex - 1;//只计算当前行的值







        <%
            for(int j=0;j<calExpList.size();j++){
                calExp=(String)calExpList.get(j);
                String targetStr="";
                %>
                try {
                <%
                if(calExp.indexOf("innerHTML")>0){
                targetStr=calExp.substring(0,calExp.indexOf("innerHTML")-1);
                //System.out.println("targetStr:"+targetStr);
                //targetStr = targetStr.substring(0,targetStr.indexOf("_"));
                //out.println("var tempObjName = getObjectName("+targetStr+",\"_\")");
                out.println("if("+targetStr+"){");
                if (calExp.indexOf("=") != calExp.length()-1) {
            		   //update by liao dong for qc71259 in 20130906 start
            	 //如果除数为零的时候需要将Infinity去掉光标移至错误字段
            	 out.println("try{");  
            	 out.println(calExp+"; ");
            	 try{
             		 if(calExp.indexOf("=")>=0){
             			 String[] calSplitSign=calExp.split("=");
             			 String rightequalsmark = calSplitSign[0].replace(".innerHTML","");
             			 String leftequalsmark = calSplitSign[1].replace(".replace(/,/g,\"\"))", "").replace("parse_Float(", "").replace(".value", ""); 
             			 if(leftequalsmark.indexOf("/")>=0){
             				  String leftdivide  =leftequalsmark.split("/")[0];
             				  String rightdivide =leftequalsmark.split("/")[1];
             				  String inputObj = rightequalsmark.replace("+\"span\")",")");
             				  out.println(" if("+rightequalsmark+".innerHTML == \"Infinity\" ||"+rightequalsmark+".innerHTML == \"-Infinity\" || "+rightequalsmark+".innerHTML == \"NaN\" ){");
             				  out.println("if("+inputObj+".viewtype == 1){"); //必填
             				  out.println(rightequalsmark+".innerHTML=\"<img src='/images/BacoError_wev8.gif' align=absmiddle>\";");
             				  out.println("}else{");
             				  out.println(rightequalsmark+".innerHTML='';");
             				  out.println("}");
             				  out.println(inputObj+".value='';");
             				  //out.println("return;");
             				  out.println("}");
             			 }
             		 } 
             	  }catch(Exception e){}
             	  out.println("}catch(e){");
             	  out.println("}");
            	  //end
            	}
                 out.println("if("+calExp.substring(0,calExp.indexOf("innerHTML")-9)+").datatype=='int' && "+calExp.substring(0,calExp.indexOf("innerHTML")-9)+").getAttribute('datavaluetype')!='5'){ "
                 +calExp.substring(0,calExp.indexOf("="))+"=toPrecision("+calExp.substring(0,calExp.indexOf("innerHTML")-9)+").value,0);}else if("+calExp.substring(0,calExp.indexOf("innerHTML")-9)+").getAttribute('datetype')!='int' && "+calExp.substring(0,calExp.indexOf("innerHTML")-9)+").getAttribute('datavaluetype')=='5'){"
                 +targetStr+".innerHTML=changeToThousandsVal("+calExp.substring(0,calExp.indexOf("innerHTML")-9)+").value);"
                 +"}else{ "+calExp.substring(0,calExp.indexOf("="))+"=toPrecision("+calExp.substring(0,calExp.indexOf("innerHTML")-9)+").value,datalength);");
               //add by liaodong for qc75759 in 2013-11-20 start 
                String  resultNum = calExp.substring(0,calExp.indexOf("innerHTML")-9).substring(calExp.indexOf("field")+5)+"+\"";
                   out.println("try{");
                      out.println("if("+calExp.substring(0,calExp.indexOf("innerHTML")-9)+")){");
                        out.println(" var fieldtype="+calExp.substring(0,calExp.indexOf("innerHTML")-9)+").getAttribute('fieldtype');");
                        out.println("  if(fieldtype == 4){");
                        out.println(" document.getElementById(\"field_lable"+resultNum+"\").value = toPrecision("+calExp.substring(0,calExp.indexOf("innerHTML")-9)+").value,datalength);");
                        out.println(" numberToChinese(\""+resultNum+"\");");
                        out.println("}");
                      out.println("}");
                   out.println("}catch(e){}");
                //end 
                out.println("}}");
				//add by liaodong for qc43068 in 2013-11-22 start
				String str =calExp.substring(0, calExp.indexOf("="));
				String resultNumInnerHTML=str.substring(0,str.indexOf("innerHTML"));
				String resultNumStr = resultNumInnerHTML.substring(0, resultNumInnerHTML.indexOf("span"))+"\")";
				//如果是金额千分位与金额转换的需要去掉_lable
				resultNumStr=resultNumStr.replace("_lable", "");
				out.println("try{");
				 out.println(" if("+resultNumStr+"){");
				  out.println(" var numType="+resultNumStr+".getAttribute(\"datatype\"); ");
				 out.println(" if(numType=='float'||numType=='int'){");
				  //经验证viewtype0未编辑1为必填 只读并没有此属性






					 out.println(" var numviewtype="+resultNumStr+".getAttribute(\"viewtype\"); ");
					  out.println(" if(numviewtype==1||numviewtype==0){");
						out.println(" var fielddbtype="+resultNumStr+".getAttribute(\"fieldtype\");");
					  out.println("if(fielddbtype != 4){"); //金额转换的不去掉重复的






						out.println(""+calExp.substring(0, calExp.indexOf("=")) +"='';");
					out.println(" }");
					   out.println(" }");
					   out.println("if("+resultNumStr+".value==''&&numviewtype==1){");
					   out.println(""+resultNumInnerHTML+"innerHTML=\"<img src='/images/BacoError_wev8.gif' align=absmiddle>\";");
					   out.println("}");
				  out.println(" }");
				 out.println(" } ");
				out.println("}catch(e){}");            
            //end
                }else{
                if(calExp.indexOf("value")>0){  
                targetStr =calExp.substring(0,calExp.indexOf("value")-1);
                //System.out.println("targetStr:"+targetStr);
                //targetStr = targetStr.substring(0,targetStr.indexOf("_"));
                //out.println("var tempObjName = getObjectName("+targetStr+",\"_\")");
                //out.println("if(window.event.srcElement.name.toString().indexOf(tempObjName)==-1){");
                out.println("if("+targetStr+"){");
                out.println(" datalength = "+targetStr+".getAttribute('datalength');");
                out.println("if(datalength == null) datalength =2;");
                if (calExp.indexOf("=") != calExp.length()-1) {
            		out.println(calExp+"; ") ;
            	}
               out.println("if("+calExp.substring(0,calExp.indexOf("value")-1)+".datatype=='int') "+calExp.substring(0,calExp.indexOf("="))+"=toPrecision("+calExp.substring(0,calExp.indexOf("="))+",0);else{ ");
                out.println("if("+targetStr+".getAttribute('datavaluetype') == 5){");
                out.println(calExp.substring(0,calExp.indexOf("="))+"=changeToThousandsVal(toPrecision("+calExp.substring(0,calExp.indexOf("="))+",datalength));");
                out.println("}else{");
                out.println(calExp.substring(0,calExp.indexOf("="))+"=toPrecision("+calExp.substring(0,calExp.indexOf("="))+",datalength);}}}");
                }
                }
                %>
	            }catch(e){}
	            <%
            }
	        %>

       }catch(e){}
   //}
<%
    }
%>
}
    

    
function calMainField(obj){
    var rows=0;
    var datalength = 2;
    <%for(int i=0;i<detailno;i++){%>
    var temprow=0;
    if($GetEle('indexnum<%=i%>')) temprow=parseInt($GetEle('indexnum<%=i%>').value);
    if(temprow>rows) rows=temprow;
    <%}%>
    if(rowindex<rows)
        rowindex=rows;
	<%
		for(int i=0;i<mainCalAry.size();i++){
			String str2 =  mainCalAry.get(i).toString();
		    int idx = str2.indexOf("=");
			String str3 = str2.substring(0,idx);
			str3 = str3.substring(str3.indexOf("_")+1);
			String str4 = str2.substring(idx);
			str4 = str4.substring(str4.indexOf("_")+1);
	%>
               var sum=0;
               var temStr;
                for(i=0; i<rowindex; i++){

                    try{
                        temStr=$GetEle("field<%=str4%>_"+i).value;
                        temStr = temStr.replace(/,/g,"");
                        if(temStr+""!=""){
                            sum+=temStr*1;
                        }
                    }catch(e){;}
                }
                if($GetEle("field<%=str3%>")){
                	datalength = $GetEle("field<%=str3%>").getAttribute("datalength");
                	if(datalength == null) datalength =2;
                  if($GetEle("field<%=str3%>").getAttribute("datatype")=="int")
                     $GetEle("field<%=str3%>").value=toPrecision(sum,0);
                   else{
                     if($GetEle("field<%=str3%>").getAttribute("datavaluetype") == '5'){
                        $GetEle("field<%=str3%>").value=changeToThousandsVal(toPrecision(sum,datalength));   
                     }else{
                        $GetEle("field<%=str3%>").value=toPrecision(sum,datalength);
                     }
                   }
                }
                if($GetEle("field<%=str3%>span")){
					if($GetEle("field<%=str3%>")&&$GetEle("field<%=str3%>").type=="text"){
						if($GetEle("field<%=str3%>").value != "") {
							$GetEle("field<%=str3%>span").innerHTML="";
						}
					}else{
						if($GetEle("field<%=str3%>")&&$GetEle("field<%=str3%>").type=="text"){
							$GetEle("field<%=str3%>span").innerHTML="";
						}else{
							if($GetEle("field<%=str3%>").getAttribute("datatype") == "int"){
								$GetEle("field<%=str3%>span").innerHTML=toPrecision(sum,0);
							}else if($GetEle("field<%=str3%>").getAttribute("datatype")=="float" && $GetEle("field<%=str3%>").getAttribute("datavaluetype")== "5"){
								$GetEle("field<%=str3%>span").innerHTML=changeToThousandsVal(toPrecision(sum,datalength));
							}else{
								$GetEle("field<%=str3%>span").innerHTML=toPrecision(sum,datalength);
								try{
								    if(document.getElementById("field<%=str3%>").getAttribute("filedtype")){
								         var filedtype=document.getElementById("field<%=str3%>").getAttribute("filedtype");
								          if(filedtype == 4){
								               document.getElementById("field<%=str3%>span").innerHTML="";
								               if(document.getElementById("field_lable<%=str3%>span")) {
								            	if(document.getElementById("field<%=str3%>").value != "") {
								            	   document.getElementById("field_lable<%=str3%>span").innerHTML="";
								            	}
								          	   }
								               document.getElementById("field_lable<%=str3%>").value=toPrecision(sum,datalength);
								               try{
								                   numberToFormat(<%=str3%>);
								                 	//jQuery("#field_lable<%=str3%>").trigger("blur");
												   //jQuery("#field_lable<%=str3%>").trigger("change");
								                }catch(e){
								                }
								          }
								    }
								 }catch(e){}
				               //end
							}
						}
					}
                }
				if($GetEle("field<%=str3%>")){
                var filedtype=$GetEle("field<%=str3%>").getAttribute("filedtype");
				if($GetEle("field<%=str3%>").value==''){
					if(filedtype == 4){
						jQuery("#field_lable<%=str3%>").trigger("blur");
						jQuery("#field_lable<%=str3%>").trigger("change");
					}else{
						jQuery("#field<%=str3%>").trigger("blur");
						jQuery("#field<%=str3%>").trigger("change");
					}
				}
				}

	<%
	}
	%>

}


function changeToThousandsVal(sourcevalue){
	sourcevalue = sourcevalue +"";
	if(null != sourcevalue && 0 != sourcevalue){
     if(sourcevalue.indexOf(".")<0)
        re = /(\d{1,3})(?=(\d{3})+($))/g;
    else
        re = /(\d{1,3})(?=(\d{3})+(\.))/g;
		return sourcevalue.replace(re,"$1,");
	}else{
		return sourcevalue;
	}
}

function calSum(obj, isload){
	calSumPrice(arguments[2]);
    var rows=0;
    <%for(int i=0;i<detailno;i++){%>
    var temprow=0;
    if($GetEle('indexnum<%=i%>')) temprow=parseInt($GetEle('indexnum<%=i%>').value);
    if(temprow>rows) rows=temprow;
    <%}%>
    if(rowindex<rows)
        rowindex=rows;
    var sum=0;
    var temStr;
	var datavaluetype = "";
<%
    for(int i=0; i<colCalAry.size(); i++){
		String str = colCalAry.get(i).toString();
		str = str.substring(str.indexOf("_")+1);
	 if ("0".equals(isbill)) {
        	  rs.executeSql("select  qfws,fielddbtype from workflow_formdictdetail where id=" + str);
        } else {
        	  rs.executeSql("select  qfws,fielddbtype from workflow_billfield where id=" + str);
        }
		 int decimaldigits_t =2;
		 int qfwsdetilsum =2;
    	if("oracle".equals(rs.getDBType())){
    		 if(rs.next()){
    	        	String fielddbtypeStr=rs.getString("fielddbtype");
						qfwsdetilsum=Util.getIntValue(rs.getString("qfws"),2);
    	        	if(fielddbtypeStr.indexOf("number")>=0){
    	        		int digitsIndex = fielddbtypeStr.indexOf(",");
        				if(digitsIndex > -1){
        					decimaldigits_t = Util.getIntValue(fielddbtypeStr.substring(digitsIndex+1, fielddbtypeStr.length()-1), 2);
        				}else{
        					decimaldigits_t = 2;
        				}
    	        	}else{
    	        		if(fielddbtypeStr.equals("integer")){
    	        			decimaldigits_t = 0;
    	        		}
    	        	}
    	        }
    	}else{
    		 if(rs.next()){
 	        	String fielddbtypeStr=rs.getString("fielddbtype");
					qfwsdetilsum=Util.getIntValue(rs.getString("qfws"),2);
 	        	if(fielddbtypeStr.indexOf("decimal")>=0){
 	        		int digitsIndex = fielddbtypeStr.indexOf(",");
     				if(digitsIndex > -1){
     					decimaldigits_t = Util.getIntValue(fielddbtypeStr.substring(digitsIndex+1, fielddbtypeStr.length()-1), 2);
     				}else{
     					decimaldigits_t = 2;
     				}
 	        	}else{
 	        		if("int".equals(fielddbtypeStr)){
 	        			decimaldigits_t = 0;
 	        		}
 	        	}
 	        }
    	}
%>
            sum=0;
            datavaluetype = "";
            for(i=0; i<rowindex; i++){

                try{
                    temStr=$GetEle("field<%=str%>_"+i).value;
                    temStr = temStr.replace(/,/g,"");
                    if(temStr+""!=""){
                        sum+=temStr*1;
                    }
					if($GetEle("field<%=str%>_"+i).getAttribute("datavaluetype")){
                         datavaluetype = $GetEle("field<%=str%>_"+i).getAttribute("datavaluetype");
                    }
                }catch(e){;}
            }

          var decimalNumber = <%=decimaldigits_t%>;
  var qfwsdetilsumNumber = <%=qfwsdetilsum%>;
          if($GetEle("sum<%=str%>")!=null){
                if(datavaluetype == '5'||datavaluetype == 5){
                   $GetEle("sum<%=str%>").innerHTML=changeToThousandsVal(toPrecision(sum,qfwsdetilsumNumber))+"&nbsp;";
                }else{
            	  $GetEle("sum<%=str%>").innerHTML=toPrecision(sum,decimalNumber)+"&nbsp;";
            	}
            }
            if($GetEle("sumvalue<%=str%>")!=null){       
               if(datavaluetype == '5'||datavaluetype == 5){
                  $GetEle("sumvalue<%=str%>").value=changeToThousandsVal(toPrecision(sum,qfwsdetilsumNumber));
               }else{
                  $GetEle("sumvalue<%=str%>").value=toPrecision(sum,decimalNumber);
               }
             }
<%
    }
%>
	if(!isload) calMainField(obj);
}

/**
return a number with a specified precision.
*/
function toPrecision(aNumber,precision){
	var temp1 = Math.pow(10,precision);
	var temp2 = new Number(aNumber);

	
	 //add by liaodong  for qc75759 in 2013年10月30日 start
	var returnVal = isNaN(Math.round(temp1*temp2) /temp1)?0:Math.round(temp1*temp2) /temp1;
	try{
		if(String(returnVal).indexOf("e")>=0)return returnVal;
	}catch(e){}
	var valInt = (returnVal.toString().split(".")[1]+"").length;
	if(aNumber == null){
		return  "";
	}
	if(valInt != precision){
	    var lengInt = precision-valInt;
		//判断添加小数位0的个数






		if(lengInt == 1){
			returnVal += "0";
		}else if(lengInt == 2){
			returnVal += "00";
		}else if(lengInt == 3){
			returnVal += "000";
		}else if(lengInt < 0){
			if(precision == 1){
				returnVal += ".0";
			}else if(precision == 2){
				returnVal += ".00";
			}else if(precision == 3){
				returnVal += ".000";
			}else if(precision == 4){
				returnVal += ".0000";
			}		
		}		
	}
	return  returnVal;
	//end
}
/**

从"field142_0" 得到，field142
*/

function getObjectName(obj,indexChar){
	var tempStr = obj.name.toString();
	return tempStr.substring(0,tempStr.indexOf(indexChar)>=0?tempStr.indexOf(indexChar):tempStr.length);
}
<%
for(int i=0;i<detailno;i++){
%>
jQuery(document).ready(function(){
	jQuery("TD[name='detailblockTD']").closest("table").css("table-layout", "fixed"); 
	calSum(<%=i%>, true);
});
<%
}%>
if ("<%=needcheck%>" != ""){
   $GetEle("needcheck").value += "<%=needcheck%>";
}
<%
needcheck="";
%>
<%=dlbodychangattrstr%>


var defaultrows = 0;
var iframenameid = 0;
var temptime = 1;
var existArray = new Array();

function datainputdCreateIframe(iframenameid,StrData){
	  var iframe_datainputd = document.createElement("iframe");
      iframe_datainputd.id = "iframe_"+iframenameid;
	  iframe_datainputd.src = "";
	  iframe_datainputd.frameborder = "0";
	  iframe_datainputd.height = "0";
	  iframe_datainputd.scrolling = "no";
	  iframe_datainputd.style.display = "none";
	  document.body.appendChild(iframe_datainputd);
	  $GetEle("iframe_"+iframenameid).src="DataInputFromDetail.jsp?"+StrData;
}

Array.prototype.contains = function(obj){
  	var i = this.length;
  	while(i--){
  		if(this[i]===obj){
  			return true;
  		}
  	}
  	return false;
}
function datainputd(parfield){                <!--数据导入-->
     
	 try{
		if(event.propertyName && event.propertyName.toLowerCase() != "value"){
			return;
		}
	}catch(e){}  
      //var xmlhttp=XmlHttp.create();
	  
      var tempParfieldArr;
	  var StrData;
	  try{
		  try{
			tempParfieldArr = parfield.split(",");
			StrData="id=<%=workflowid%>&formid=<%=formid%>&bill=<%=isbill%>&node=<%=nodeid%>&detailsum=<%=detailsum%>&trg="+parfield;
			}catch(e){
			tempParfieldArr = parfield.getAttribute("name").split(",")
			StrData="id=<%=workflowid%>&formid=<%=formid%>&bill=<%=isbill%>&node=<%=nodeid%>&detailsum=<%=detailsum%>&trg="+parfield.getAttribute("name");
		}
		}catch(e){	
		  tempParfieldArr = $(parfield).attr("id").toString().split(",");
		  StrData="id=<%=workflowid%>&formid=<%=formid%>&bill=<%=isbill%>&node=<%=nodeid%>&detailsum=<%=detailsum%>&trg="+$(parfield).attr("id");
		}
	  
      for(var i=0;i<tempParfieldArr.length;i++){
      	var tempParfield = tempParfieldArr[i];
      	var indexid=tempParfield.substr(tempParfield.indexOf("_")+1);
	  
      <%
      if(!trrigerdetailfield.trim().equals("")){
          ArrayList Linfieldname=ddidetail.GetInFieldName();
          ArrayList Lcondetionfieldname=ddidetail.GetConditionFieldName();
          for(int i=0;i<Linfieldname.size();i++){
              String temp=(String)Linfieldname.get(i);
			
      %>
          if($GetEle("<%=temp.substring(temp.indexOf("|")+1)%>_"+indexid)) StrData+="&<%=temp%>="+escape($GetEle("<%=temp.substring(temp.indexOf("|")+1)%>_"+indexid).value);
	      
      <%
          }
          for(int i=0;i<Lcondetionfieldname.size();i++){
              String temp=(String)Lcondetionfieldname.get(i);
      %>
          if($GetEle("<%=temp.substring(temp.indexOf("|")+1)%>_"+indexid)) StrData+="&<%=temp%>="+escape($GetEle("<%=temp.substring(temp.indexOf("|")+1)%>_"+indexid).value);
      <%
          }
          }
      %>
      }
    
      iframenameid++;
      StrData = StrData.replace(/\+/g,"%2B");
      //$GetEle("datainputformdetail").src="DataInputFromDetail.jsp?"+StrData;
	  if(existArray.contains(parfield)){ //延时执行
	        if(temptime>defaultrows){
	        	temptime = 1;
	        }else{
	        	//temptime++;
	        }  
	    	window.setTimeout(function(){ 
			    datainputdCreateIframe(iframenameid,StrData); 
			},100*temptime); 
			
	  }else{
	  	existArray.push(parfield);
	  	datainputdCreateIframe(iframenameid,StrData)
	  } 
      //xmlhttp.open("POST", "DataInputFrom.jsp", false); 
      //xmlhttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
      //xmlhttp.send(StrData);
  }
function changeChildFieldDetail(obj, fieldid, childfieldid, rownum){
    var paraStr = "fieldid="+fieldid+"&childfieldid="+childfieldid+"&isbill=<%=isbill%>&selectvalue="+obj.value+"&isdetail=1&&rowindex="+rownum;
    $GetEle("selectChangeDetail").src = "SelectChange.jsp?"+paraStr;
    //alert($GetEle("selectChange").src);
}
function doInitDetailchildSelect(fieldid,pFieldid,rownum,childvalue, cnt){
	try{
		var pField = $GetEle("field"+pFieldid+"_"+rownum);
		if(pField != null){
			var pFieldValue = pField.value;
			if(pFieldValue==null || pFieldValue==""){
				if (cnt == null || cnt == "") {
					cnt = 0;
				}
				var _callbackfc = function() {
			        doInitDetailchildSelect(fieldid,pFieldid,rownum,childvalue, cnt + 1);
			    };
			    if (cnt < 10) {
					window.setTimeout(_callbackfc , 500);
				}
				return;
			}
			if(pFieldValue!=null && pFieldValue!=""){
				var field = $GetEle("field"+fieldid+"_"+rownum);
			    var paraStr = "fieldid="+pFieldid+"&childfieldid="+fieldid+"&isbill=<%=isbill%>&selectvalue="+pFieldValue+"&isdetail=1&&rowindex="+rownum+"&childvalue="+childvalue;
				$GetEle("iframe_"+pFieldid+"_"+fieldid+"_"+rownum).src = "SelectChange.jsp?"+paraStr;
			}
		}
	}catch(e){}
}
<%=selectDetailInitJsStr%>
function doInitDetailchildSelectAdd(fieldid,pFieldid,rownum,childvalue){
	try{
		var pField = $GetEle("field"+pFieldid+"_"+rownum);
		if(pField != null){
			var pFieldValue = pField.value;
			if(pFieldValue==null || pFieldValue==""){
				return;
			}
			if(pFieldValue!=null && pFieldValue!=""){
				var field = $GetEle("field"+fieldid+"_"+rownum);
			    var paraStr = "fieldid="+pFieldid+"&childfieldid="+fieldid+"&isbill=<%=isbill%>&selectvalue="+pFieldValue+"&isdetail=1&&rowindex="+rownum+"&childvalue="+childvalue;
				//$GetEle("iframe_"+pFieldid+"_"+fieldid).src = "SelectChange.jsp?"+paraStr;
			
				var frm = document.createElement("iframe");
				frm.id = "iframe_"+pFieldid+"_"+fieldid+"_"+rownum;
				frm.style.display = "none";
				frm.src = "SelectChange.jsp?"+paraStr;
			    document.body.appendChild(frm);
			}
		}
	}catch(e){}
}
function getNumber(index){
	var elm = $GetEle("field_lable"+index);
	var n = getLocation(elm);
  	//update by liaodong for qc80701 in 20131008 start
	  if($GetEle("field"+index).value != ""){ // add by liaodong for qc84090 in 2013-11-20 start
  	     $GetEle("field_lable"+index).value =floatFormat($GetEle("field"+index).value);
	  }
  	//end
	setLocation(elm,n);
  }
  
function reAccesoryChanageDetail()
{
  <%
  if(deuploadfieldids!=null){
  for (int ii = 0; ii < deuploadfieldids.size(); ii++) {%>
     checkfilesize(oUpload<%=deuploadfieldids.get(ii)+""%>,uploadImageMaxSize,uploaddocCategory);
     showmustinput(oUpload<%=deuploadfieldids.get(ii)+""%>);
  <%}
  }
  %>
}
var key =  "<%=userid%>"+"_"+"<%=requestid%>"+"requestimport"
	var requestimport = getCookie(key);
	var tempS = "<%=trrigerdetailfield%>";
	if(requestimport=="1") {
		<%
			if(trrigerdetailfield!=null && !trrigerdetailfield.trim().equals("")) {
       %>	
	   if(window.confirm('是否触发字段联动? ')) {
			jQuery('input[id^="'+tempS+'_"').each(function () {
			   datainputd(this.id);
			});
	   }
		<%
			}
       %>	
	}
	setCookie(key,"0",1);
	
function setCookie(cname,cvalue,exdays)
{
  var d = new Date();
  d.setTime(d.getTime()+(exdays*24*60*60*1000));
  var expires = "expires="+d.toGMTString();
  document.cookie = cname + "=" + cvalue + "; " + expires;
}
 
function getCookie(cname)
{
  var name = cname + "=";
  var ca = document.cookie.split(';');
  for(var i=0; i<ca.length; i++) 
  {
    var c = ca[i].trim();
    if (c.indexOf(name)==0) return c.substring(name.length,c.length);
  }
  return "";
}
</script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
