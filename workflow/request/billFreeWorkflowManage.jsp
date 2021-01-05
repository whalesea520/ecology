
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<%@ page import="java.util.regex.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<link rel="stylesheet" type="text/css" href="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.css" />
<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.js"></script>
<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/jquery.mousewheel_wev8.js"></script>


<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="requestNodeFlow" class="weaver.workflow.request.RequestNodeFlow" scope="page"/>


<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="FieldFormSelect" class="weaver.workflow.field.FieldFormSelect" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />

<link rel="stylesheet" type="text/css" href="/kindeditor/skins/default_wev8.css" />
<script type="text/javascript" language="javascript" src="/kindeditor/kindeditor_wev8.js"></script>
<script type="text/javascript" language="javascript" src="/kindeditor/kindeditor-Lang_wev8.js"></script>

<script type="text/javascript" src="/js/ecology8/jquery.fix.clone_wev8.js"></script>

<script type="text/javascript" src="/js/swfupload/swfupload_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/swfupload.queue_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/fileprogress_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/handlers_wev8.js"></script>




<script>

    var pdocument=jQuery(parent.document);


	

   //隐藏父菜单


    pdocument.find("#mainRequestFrame").show();

    pdocument.find(".highslide-container").next().css("right","-175px");

    pdocument.find(".highslide-container").next().css("left","inherit");


    

</script>



<!--自由流程样式-->
<link rel="stylesheet" type="text/css" href="/css/ecology8/freeworkflow_wev8.css" />

<style>
.switch {
position: absolute;
right: -9px;
top: 205px;
cursor: pointer;
z-index: 10;
width: 20px;
height: 20px;
}

.connectusers {
border: 1px solid #cccccc;
width: 200px;
margin-top: 10px;
margin-left: 8;
height: 432px;
}

table.ke-container {
    border-top: none !important;
	border-left: none !important;
	border-right: none !important;
}

.tableformcontent{

  padding-right:15px;
}

.formtable {
margin-right: 220px;
padding: 10px 10px;
position: relative;
padding-bottom: 0;
background: #ffffff;
}
</style>


	<%

     int requestid = Util.getIntValue(request.getParameter("requestid"),-1);
	 int workflowid = Util.getIntValue(request.getParameter("workflowid"),-1);
	 int isremark = Util.getIntValue(request.getParameter("isremark"),-1);
	 int billid = Util.getIntValue(request.getParameter("billid"),-1);
	 int formid = Util.getIntValue(request.getParameter("formid"),-1);
	 int nodeid = Util.getIntValue(request.getParameter("nodeid"),-1);
	 int creater = Util.getIntValue(request.getParameter("creater"),-1);
	 int creatertype = Util.getIntValue(request.getParameter("creatertype"),-1);
	 int isreject = Util.getIntValue(request.getParameter("isreject"),-1);
	 int isreopen = Util.getIntValue(request.getParameter("isreopen"),-1);

    String requestlevel=Util.null2String(request.getParameter("requestlevel"));

	String deleted=Util.null2String(request.getParameter("deleted"));

	String workflowtype=Util.null2String(request.getParameter("workflowtype"));
	String fromFlowDoc=Util.null2String(request.getParameter("fromFlowDoc"));

    String nodetype=Util.null2String(request.getParameter("nodetype"));

	String currentdate=Util.null2String(request.getParameter("currentdate"));
	String docfileid=Util.null2String(request.getParameter("docfileid"));
	String newdocid=Util.null2String(request.getParameter("newdocid"));


	//对不同的模块来说,可以定义自己相关的工作流
	String prjid = Util.null2String(request.getParameter("prjid"));
	String docid = Util.null2String(request.getParameter("docid"));
	String crmid = Util.null2String(request.getParameter("crmid"));
	String hrmid = Util.null2String(request.getParameter("hrmid"));
	//......
	String topage = Util.null2String(request.getParameter("topage"));
	
	String username = "";
    String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");//需要增加的代码
	String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");//需要增加的代码
	user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
	int userid=user.getUID();                   //当前用户id
	int usertype = Util.getIntValue(user.getLogintype(),-1);

	String requestlevaltitle="";
   //对应的流程紧急程度

   if("0".equals(requestlevel))
   {
     requestlevaltitle=SystemEnv.getHtmlLabelName(1984,user.getLanguage());
   }else  if("1".equals(requestlevel))
   {
     requestlevaltitle=SystemEnv.getHtmlLabelName(25397,user.getLanguage());
   }else  if("2".equals(requestlevel))
   {
     requestlevaltitle=SystemEnv.getHtmlLabelName(2087,user.getLanguage());
   }



	requestNodeFlow.setRequestid(requestid);
	requestNodeFlow.setNodeid(nodeid);
	requestNodeFlow.setNodetype(nodetype);
	requestNodeFlow.setWorkflowid(workflowid);
	requestNodeFlow.setUserid(userid);
	requestNodeFlow.setUsertype(usertype);
	requestNodeFlow.setCreaterid(creater);
	requestNodeFlow.setCreatertype(creatertype);

	requestNodeFlow.setFormid(formid);
	requestNodeFlow.setIsbill(1);
	requestNodeFlow.setBillid(billid);

	requestNodeFlow.setBilltablename("bill_FreeWorkflow");
	requestNodeFlow.setIsreject(isreject);
	requestNodeFlow.setIsreopen(isreopen);


	username = Util.toScreen(ResourceComInfo.getResourcename(""+creater),user.getLanguage()) ;


    boolean  isNextNodeFreeNode=false;

    
    
	
	String operators="";
	String destnodeid="";

    String sql="select  *  from workflow_nodelink  a where a.nodeid="+nodeid+"  and a.destnodeid in(select  id  from workflow_nodebase a where a.requestid="+requestid+")";

    RecordSet.executeSql(sql);

    if(RecordSet.next())
	{
	
	  destnodeid=RecordSet.getString("destnodeid");
      
      sql="select  *  from workflow_nodebase a where a.requestid="+requestid+"  and   id="+destnodeid+"  and  IsFreeNode='1'";

      RecordSet.executeSql(sql);

	  if(RecordSet.next())
	  {
	   //自由节点
       isNextNodeFreeNode=true;

	  }

	
	  
	  sql="select  operators  from  workflow_nodebase a where a.id="+destnodeid;
      RecordSet.executeSql(sql);
       if(RecordSet.next())
		{
		   //获取下个节点操作人

		    operators=RecordSet.getString("operators");
		}
     
	}

    sql="select  a.requestname,a.requestlevel  from workflow_requestbase a where a.requestid="+requestid;
    RecordSet.executeSql(sql);
	String rname="";
	String rlevel="";
    while(RecordSet.next())
	{
	  rname=RecordSet.getString("requestname");
      rlevel=RecordSet.getString("requestlevel");
	}
 
    String  remarkinfodata="";
    //获取正文内容
    sql="select  *  from bill_FreeWorkflow  where  requestid="+requestid;

    //关联的表单信息

    //模板数据id
    int fc_billid=0;
    //模板id
	int fc_formmodeid=0;
    //表单id 
	int fc_formid=0;

    RecordSet.executeSql(sql);
    if(RecordSet.next())
	{
	  //正文
	  remarkinfodata=RecordSet.getString("remarkinfo");
	  
	  String dest = "";

      if (remarkinfodata!=null  &&  !remarkinfodata.equals("")) {
 
            //去除回车，换行符，制表位
            Pattern p = Pattern.compile("\\t|\r|\n");

            Matcher m = p.matcher(remarkinfodata);

            dest = m.replaceAll("");
      }
  
      remarkinfodata=dest;

      fc_formid=Util.getIntValue(RecordSet.getInt("tableformid")+"",0);
	  fc_billid=Util.getIntValue(RecordSet.getInt("tablebillid")+"",0);
      fc_formmodeid=Util.getIntValue(RecordSet.getInt("tablemodeid")+"",0);
     

	  //System.out.println("fc_billid===>"+fc_billid+"====="+fc_formmodeid+"========"+fc_formid);

    }

   
   //获取常用联系人,如果为空，则默认为同部门的10人,如果常用联系人少于10人，则用同部门人替补
	sql="select top 10 operator,COUNT(*) as times  from bill_FreeWorkflowConnector where  creater ="+userid+" group by  operator order by times  desc";
	RecordSet.execute(sql);
	int operator=-1;
	List<Integer>  commonusers=new ArrayList<Integer>();
	while(RecordSet.next())
	{
	   operator=RecordSet.getInt("operator");
	   if(operator!=userid)
	   {
		  commonusers.add(operator);
	   }   
	}
	String  excludeitem="";

	for(Integer i:commonusers)
	{
	  excludeitem=excludeitem+"'"+i+"',";
	}

	if(commonusers.size()>0)
	 excludeitem="("+excludeitem.substring(0,excludeitem.length()-1)+")";
	

	if(commonusers.size()<10)
	{
	   int  needadd=10-commonusers.size();
	   if(!excludeitem.equals(""))
	   sql="select top "+needadd+" id from  HrmResource a  where  departmentid in(select  b.departmentid  from HrmResource b ) and a.id!="+userid +"  and a.id not in "+excludeitem;
	   else
       sql="select top "+needadd+" id from  HrmResource a  where  departmentid in(select  b.departmentid  from HrmResource b ) and a.id!="+userid ;

	   RecordSet.execute(sql);
	   while(RecordSet.next())
	   {
		   operator=RecordSet.getInt("id");
		   commonusers.add(operator);
	   } 

	}

  int annexmainId=0;
  int annexsubId=0;
  int annexsecId=0;
  boolean haveattachment=false;
  
  //查找附件上传路径
  sql="select  a.docCategory,a.docPath  from workflow_base a where a.id="+workflowid;
  RecordSet.execute(sql);
  
  if(RecordSet.next())
  {
    
	 String  docinfo=RecordSet.getString("docCategory");
     String[] docitems=docinfo.split(",");
     
     if (docitems.length > 2) {
	     annexmainId=Integer.valueOf(docitems[0]);
		 annexsubId=Integer.valueOf(docitems[1]);
		 annexsecId=Integer.valueOf(docitems[2]);
     }
     haveattachment=true;
  }

	%>

    <%
		//当前节点的权限信息，也是添加自由节点的权限默认值

		int init_road=-1;//当前节点的路径编辑权限

		String init_nodename=SystemEnv.getHtmlLabelName(15070, user.getLanguage());
		int init_frms=-1;
		int currtype=-1;//当前节点的类型

		String init_nodeDo="";
		
		//System.out.println("workflowid:"+workflowid+"||nodeid:"+nodeid);

		RecordSet.executeSql("select * from("+
				"select base.id,node.workflowid,base.nodename,node.nodetype,node.isFormSignature,node.IsPendingForward,"+
				"base.operators,base.Signtype,base.floworder from workflow_flownode node,workflow_nodebase base where node.nodeid=base.id ) a "+
				"left join ("+
				"select rights.nodeid,manage.retract,manage.pigeonhole,rights.isroutedit,rights.istableedit from "+
				"workflow_function_manage manage full join bill_FreeWorkflowRights rights on manage.operatortype=rights.nodeid"+
				") b on a.id=b.nodeid where a.workflowid="+workflowid+" and a.id="+nodeid);

        

		if(RecordSet.next()){
			currtype=Util.getIntValue(RecordSet.getString("nodetype"),0);
			if(currtype==0){//创建节点
				init_road=2;
				init_frms=1;
			}else{
				init_road=Util.getIntValue(RecordSet.getString("isroutedit"),0);
				init_frms=Util.getIntValue(RecordSet.getString("istableedit"),0);
			}
		}
	%>


   <form name="frmmain" id='frmmain' method="post" action="BillFreeWorkflowOperation.jsp">
      
      <input type=hidden name="isfreeworkflowbindform" value=0>
   
      <!--表单相关--> 
      <input type=hidden name="fc_formid"   value='<%=fc_formid%>'>
      <input type=hidden name="formmodeid"  value='<%=fc_formmodeid%>'>
	  <input type=hidden name="fc_billid"  value='<%=fc_billid%>'>

      <div class="freeNode" style="display:none;">
			<%
				int freeNum=0;
				String cheStr="";
				//System.out.println("init_road:"+init_road);
				if(init_road==1||currtype==0){
					//当前节点只有加签权限
					RecordSet.execute("select * from ("+
					"select base.id,base.requestid,base.nodename,node.nodetype,node.isFormSignature,node.IsPendingForward,"+
					"base.operators,base.Signtype,base.floworder from workflow_flownode node,workflow_nodebase base where "+
					"node.nodeid=base.id and base.startnodeid="+nodeid+" and base.requestid="+requestid+
					") a "+
					"left join ("+
					"select rights.nodeid,manage.retract,manage.pigeonhole,rights.isroutedit,rights.istableedit from "+
					"workflow_function_manage manage full join bill_FreeWorkflowRights rights on manage.operatortype=rights.nodeid"+
					") b on a.id=b.nodeid ");		
					
                   

					while (RecordSet.next()) {
						
							String operids=Util.null2String(RecordSet.getString("operators"));
							String opernames="";
							ArrayList operatorlist=Util.TokenizerString(operids,",");
							for(int j=0;j<operatorlist.size();j++){
								if(opernames.equals("")){
									opernames=ResourceComInfo.getLastname((String)operatorlist.get(j));
								}else{
									opernames+=","+ResourceComInfo.getLastname((String)operatorlist.get(j));
								}
							}
							String nodeDo="";
							int pforward=Util.getIntValue(RecordSet.getString("IsPendingForward"),0);
							if(pforward==1){
								nodeDo=nodeDo+"1,";
							}							
							int pigeonhole=Util.getIntValue(RecordSet.getString("pigeonhole"),0);
							if(pigeonhole==1){
								nodeDo=nodeDo+"2,";
							}
							int retract=Util.getIntValue(RecordSet.getString("retract"),0);
							if(retract==1){
								nodeDo=nodeDo+"3,";
							}
							if(nodeDo.lastIndexOf(",")>-1){
								nodeDo = nodeDo.substring(0,nodeDo.lastIndexOf(","));
							}
				%>		
						<input type='hidden' name='floworder_<%=freeNum%>' value='<%=Util.getIntValue(RecordSet.getString("floworder"),0)%>'/>
						<input type='hidden' name='nodename_<%=freeNum%>' value='<%=Util.null2String(RecordSet.getString("nodename"))%>'/>
						<input type='hidden' name='nodetype_<%=freeNum%>' value='<%=Util.getIntValue(RecordSet.getString("nodetype"),0)%>'/>
						<input type='hidden' name='Signtype_<%=freeNum%>' value='<%=Util.getIntValue(RecordSet.getString("Signtype"),0)%>'/>
						<input type='hidden' name='operators_<%=freeNum%>' value='<%=operids%>'/>
						<input type='hidden' name='operatornames_<%=freeNum%>' value='<%=opernames%>'/>
						
						<input type='hidden' name='road_<%=freeNum%>' value='<%=Util.getIntValue(RecordSet.getString("isroutedit"),0)%>' />
						<input type='hidden' name='frms_<%=freeNum%>' value='<%=Util.getIntValue(RecordSet.getString("istableedit"),0)%>'/>
						<input type='hidden' name='trust_<%=freeNum%>' value='<%=Util.getIntValue(RecordSet.getString("isFormSignature"),0)%>'/>
						<input type='hidden' name='nodeDo_<%=freeNum%>' value='<%=nodeDo%>'/>
				<%
						cheStr=cheStr+"nodename_"+freeNum+",operators_"+freeNum+",";
						freeNum++;	
						
					}
                      





				}else if(init_road==2){
					//当前节点有后续权限

					//从当前节点进行遍历

					int nextnode=nodeid;
					while(nextnode!=-1){
						if(nextnode!=nodeid){	//当前节点除外
							RecordSet.executeSql("select * from("+
							"select base.id,node.workflowid,base.nodename,node.nodetype,node.isFormSignature,node.IsPendingForward,"+
							"base.operators,base.Signtype,base.floworder from workflow_flownode node,workflow_nodebase base where node.nodeid=base.id ) a "+
							"left join ("+
							"select rights.nodeid,manage.retract,manage.pigeonhole,rights.isroutedit,rights.istableedit from "+
							"workflow_function_manage manage full join bill_FreeWorkflowRights rights on manage.operatortype=rights.nodeid"+
							") b on a.id=b.nodeid where a.workflowid="+workflowid+" and a.id="+nextnode);
							if (RecordSet.next()) {
								
								int nextnodetype=Util.getIntValue(RecordSet.getString("nodetype"),0);
								if(nextnodetype==3){
									//已经是归档节点了
									nextnode=-1;
									break;
								}
								String operids=Util.null2String(RecordSet.getString("operators"));
								String opernames="";
								ArrayList operatorlist=Util.TokenizerString(operids,",");
								for(int j=0;j<operatorlist.size();j++){
									if(opernames.equals("")){
										opernames=ResourceComInfo.getLastname((String)operatorlist.get(j));
									}else{
										opernames+=","+ResourceComInfo.getLastname((String)operatorlist.get(j));
									}
								}
								String nodeDo="";
								int pforward=Util.getIntValue(RecordSet.getString("IsPendingForward"),0);
								if(pforward==1){
									nodeDo=nodeDo+"1,";
								}							
								int pigeonhole=Util.getIntValue(RecordSet.getString("pigeonhole"),0);
								if(pigeonhole==1){
									nodeDo=nodeDo+"2,";
								}
								int retract=Util.getIntValue(RecordSet.getString("retract"),0);
								if(retract==1){
									nodeDo=nodeDo+"3,";
								}
								if(nodeDo.lastIndexOf(",")>-1){
									nodeDo = nodeDo.substring(0,nodeDo.lastIndexOf(","));
								}
							%>
								<input type='hidden' name='floworder_<%=freeNum%>' value='<%=Util.getIntValue(RecordSet.getString("floworder"),0)%>'/>
								<input type='hidden' name='nodename_<%=freeNum%>' value='<%=Util.null2String(RecordSet.getString("nodename"))%>'/>
								<input type='hidden' name='nodetype_<%=freeNum%>' value='<%=nextnodetype%>'/>
								<input type='hidden' name='Signtype_<%=freeNum%>' value='<%=Util.getIntValue(RecordSet.getString("Signtype"),0)%>'/>
								<input type='hidden' name='operators_<%=freeNum%>' value='<%=operids%>'/>
								<input type='hidden' name='operatornames_<%=freeNum%>' value='<%=opernames%>'/>
								
								<input type='hidden' name='road_<%=freeNum%>' value='<%=Util.getIntValue(RecordSet.getString("isroutedit"),0)%>' />
								<input type='hidden' name='frms_<%=freeNum%>' value='<%=Util.getIntValue(RecordSet.getString("istableedit"),0)%>'/>
								<input type='hidden' name='trust_<%=freeNum%>' value='<%=Util.getIntValue(RecordSet.getString("isFormSignature"),0)%>'/>
								<input type='hidden' name='nodeDo_<%=freeNum%>' value='<%=nodeDo%>'/>									
							<%
								cheStr=cheStr+"nodename_"+freeNum+",operators_"+freeNum+",";
								freeNum++;
							}
						}
						//获取下一个节点

						RecordSet.executeSql("select destnodeid from workflow_nodelink where  nodeid="+nextnode+" and wfrequestid is null and workflowid = "+workflowid+" and (((select COUNT(1) from workflow_nodebase b where workflow_nodelink.nodeid=b.id and (IsFreeNode is null or IsFreeNode !='1'))>0 and (select COUNT(1) from workflow_nodebase b where workflow_nodelink.destnodeid=b.id and (IsFreeNode is null or IsFreeNode !='1'))>0 ) or ((select COUNT(1) from workflow_nodebase b where workflow_nodelink.nodeid=b.id and IsFreeNode ='1' and requestid="+requestid+")>0  or (select COUNT(1) from workflow_nodebase b where workflow_nodelink.destnodeid=b.id and IsFreeNode ='1' and requestid="+requestid+")>0 ))");
						String nextnodeid="";
						while (RecordSet.next()) {
							nextnodeid=nextnodeid+Util.null2String(RecordSet.getString("destnodeid"))+",";
						}
						if(!nextnodeid.equals("")){
							nextnodeid=nextnodeid.substring(0,nextnodeid.lastIndexOf(","));
							String[] nnode=nextnodeid.split(",");
							if(nnode.length>1){
								for(String nid:nnode){
									RecordSet.executeSql("select COUNT(id) as id from workflow_nodelink where destnodeid="+nid);
									if(RecordSet.next()) {
										if(Util.getIntValue(RecordSet.getString("id"),0)==1){
											nextnode=Util.getIntValue(nid,0);
										}
									}else{//可能数据查询报错了

										nextnode=-1;
									}
								}
							}else{
								nextnode=Util.getIntValue(nextnodeid,0);
							}
						}else{//没有下一节点，可能已是归档节点了
							nextnode=-1;
						}
					}
				}
				if(freeNum>0){
			%>
					<input type='hidden' id='rownum' name='rownum' value='<%=freeNum%>'/>
					<input type='hidden' id='indexnum' name='indexnum' value='<%=freeNum%>'/>
					<input type='hidden' id='checkfield' name='checkfield' value='<%=cheStr%>'/>
					<input type='hidden' name="freeNode" value="1"/>
					<input type='hidden' name="freeDuty" value="<%=init_road%>"/>
			<%
				}else{
			%>	
					<input type='hidden' name="freeNode" value="0"/>
			<%
				}
			%>
	  </div>

   
       <div  class='freewfformtablefields' style='display:none'></div>

	   <div  id="contaienr" style='padding-top:20px;background:#fff;'>

       <div class='requesttitle' style='font-size:16px;color:#000;text-align:center;font-weight: bold;'><%=rname%></div>
                 
     
       <div class="formarea">
	        
			  
          <div class="formtable">

                <div class='switch'><img src='/images/ecology8/wf_freehide_wev8.png'></div>
                
				
               <table  style='width:100%;'>
                   <col style="width: 20%">
                   <col style="width: 90%">
 
                   <tr>

                        <td class='tdfirst tditem'><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></td><td class='tditem'><span class="titleinfo"><a  class='acceptperson'   href='javaScript:openhrm(<%=userid%>);' onclick='pointerXY(event);'><%=username%></a></span><span class="titleinfo"><%=requestlevaltitle%></span></td>

                   </tr>

                      <%

						//获取下一个节点接收人
						String rsdata="";
						
						//System.out.println("operators:"+operators+"|init_road:"+init_road+"|freeNum:"+freeNum);
						if(operators.equals("")){							
							//下一个节点为归档节点

							isNextNodeFreeNode=false;

							requestNodeFlow.setRecordSet(RecordSet);
                            requestNodeFlow.getNextNodeOperator();
							Hashtable<String,String> operas=requestNodeFlow.getOperators();

							StringBuffer  sb=new StringBuffer("");
							
							String[] splitvalues;

							String tempstr="";
                             
							String[] ops=null;

							for(Map.Entry entry:operas.entrySet())
							{
								tempstr=entry.getValue()+"";

								ops=tempstr.split(",");

								for(String  itemstr:ops)
								{
									tempstr=itemstr.substring(1,itemstr.length()-1);
									splitvalues=tempstr.split("_");
									sb.append("<a  class='acceptperson'   href='javaScript:openhrm("+splitvalues[0]+");' onclick='pointerXY(event);'>"+Util.toScreen(ResourceComInfo.getResourcename(splitvalues[0]),user.getLanguage())+"</a>").append(",");
								}
								
							}
							if(sb.length()>0)
								rsdata=sb.substring(0,sb.length()-1);
						}else{
							//下一个节点不为归档节点

							//路径权限
							if(init_road==2||(init_road==1&&freeNum>0) ||  isNextNodeFreeNode){
								//有后续权限或有加签权限且下一节点是它的自由子节点
								isNextNodeFreeNode=true;

								String[] ops=operators.split(",");
								StringBuffer sb=new StringBuffer("");
								for(String op:ops){
									if(!op.equals("")){
										sb.append(Util.toScreen(ResourceComInfo.getResourcename(""+op),user.getLanguage())).append(",");
									 }
								}
								if(sb.length()>0)
									rsdata=sb.substring(0,sb.length()-1);
							}else{
								isNextNodeFreeNode=false;
								String[] ops=operators.split(",");
								StringBuffer sb=new StringBuffer("");
								for(String op:ops){
									if(!op.equals("")){
										sb.append("<a  class='acceptperson'   href='javaScript:openhrm("+op+");' onclick='pointerXY(event);'>"+Util.toScreen(ResourceComInfo.getResourcename(op),user.getLanguage())+"</a>").append(",");
									 }
								}
								if(sb.length()>0)
									rsdata=sb.substring(0,sb.length()-1);
							}
						}
						%>
						<tr id='freeNodeSpan'
							<%

							    
								if(!isNextNodeFreeNode){
							%>
									style="display:none"
							<%
								}
							%>
						>
							 <td class='tdfirst tditem'>

						   <a class='mutiselect'><%=SystemEnv.getHtmlLabelName(15525,user.getLanguage())%><a></td><td  class='tditem' >						  
						   <span>
								<brow:browser  viewType="0" name="operator_0" browserValue='<%=operators%>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp" hasInput="true"  width="85%" isSingle="false" hasBrowser = "true" isMustInput='2' completeUrl="/data.jsp"  browserSpanValue='<%=rsdata%>'> 
								</brow:browser>
						   </span>
						   <script>
								  //隐藏浏览框

								  jQuery(".e8_spanFloat").hide();

								  jQuery(".mutiselect").click(function(){
									
									  var r=jQuery("#freeNodeSpan .e8_spanFloat").find(".Browser").trigger("click");
									  if(jQuery(".freeNode").find("input[name='freeNode']").val()==1){
											addFreeNode();
									  }
									 
								  });
						   </script>
						  <div class='definewf' title="<%=SystemEnv.getHtmlLabelName(84460,user.getLanguage())%>" style="float:right;margin-right:15px;" onmouseover="jQuery('#wf_freeset_img001').attr('src','/images/ecology8/wf_freeset_over_wev8.png')" onmouseout="jQuery('#wf_freeset_img001').attr('src','/images/ecology8/wf_freeset_wev8.png')">
					      <span><img id="wf_freeset_img001" src='/images/ecology8/wf_freeset_wev8.png' style='margin-top:2px;margin-bottom:2px;margin-left: 8px;margin-right: 8px;'></span>
					   </div></td>
						</tr>
						<tr id='overNodeSpan'
							<%
								if(isNextNodeFreeNode){
							%>
									style="display:none"
							<%
								}
							%>
						>
						   <td class='tdfirst tditem'><%=SystemEnv.getHtmlLabelName(15525,user.getLanguage())%></td><td class='tditem'><div style='float:left;margin-top:4px' class='endNodeSpan'>	
							 <%=rsdata%>
						   </div>
						   <div class='definewf' title="<%=SystemEnv.getHtmlLabelName(84460,user.getLanguage())%>" style="float:right;margin-right:15px;" onmouseover="jQuery('#wf_freeset_img002').attr('src','/images/ecology8/wf_freeset_over_wev8.png')" onmouseout="jQuery('#wf_freeset_img002').attr('src','/images/ecology8/wf_freeset_wev8.png')">
					      <span><img id="wf_freeset_img002" src='/images/ecology8/wf_freeset_wev8.png' style='margin-top:2px;margin-bottom:2px;margin-left: 8px;margin-right: 8px;'></span>
					   </div></td>
						</tr>
                   <tr>

                       <td class='tdfirst tditem'><%=SystemEnv.getHtmlLabelName(24986,user.getLanguage())%></td><td class='tditem' style='padding-top: 5px;'><%=rname%></td>

                   </tr>
                   <tr class=''  <%  if(fc_billid ==-1) {%> style='display:none;' <%}%>>
				   
				      <td colspan='2'  style="height:20px" >
					           
					  </td>

				    </tr>
                  
				   <tr class='formtrarea'  style='display:none;'>
				   
				      <td colspan='2'  class='formtdarea'  >
					           
					  </td>

				    </tr>


                     <tr class='contentareaonly'  <%  if(fc_billid!=0 &&  fc_billid!=-1) {%> style='display:none;' <%}%>>

                       <td  class='tdfirst tditem'><%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%></td>
                       <td  class='tditem' style='position:relative;padding-top: 0px;padding-left:0px;'>
						
						<!--没有表单编辑权限 edit by lrj 2014 4 8-->
						<%if(init_frms==0){%>
							<div style="height: 325px;position: absolute;width: 100%;z-index: 10;"></div>
						<%}%>
                                <!--上传进度区域(非签章)-->
    <div class="fieldset flash" id="fsUploadProgressannexuploadSimple"  style='position: absolute;left:10px;width:300px;opacity: 1;'></div>
					             <textarea id='content' ></textarea>  
							  <input type='hidden' name='remarkinfo' id='remarkinfo'>
						      <!--附加操作-->
							  <div class='appendtool'>                               
                                    <ol class='appendtools'>

                                         <%  
											//根据用户流程配置设置用户附件操作
											if(haveattachment  &&  (fc_billid==0 ||  fc_billid==-1)) {%>
									     <li>
                                         <input  class=InputStyle  type=hidden size=60 id="field-annexupload" name="field-annexupload" >
										 <img src='/images/ecology8/top_icons/2-1_wev8.png'/>
										 <div class='swfup'>
                                            <div class='swfwrapper'>
                                            <span id='attachmentPlaceHolderannexupload' style='cursor: pointer;'></span>
										     </div>
										 </div>
										   <script>
											  var oUploadannexupload;
											  function fileuploadannexupload() {
											  var settings = {
													flash_url : "/js/swfupload/swfupload.swf",
													post_params: {
														"mainId":"<%=annexmainId%>",
														"subId":"<%=annexsubId%>",
														"secId":"<%=annexsecId%>",
														"userid":"<%=user.getUID()%>",
														"logintype":"<%=user.getLogintype()%>"
													},        
													upload_url: "/docs/docupload/MultiDocUploadByWorkflow.jsp",
													file_size_limit :"5MB",
													file_types : "*.*",
													file_types_description : "All Files",
													file_upload_limit : "50",
													file_queue_limit : "0",
													custom_settings : {
																progressTarget : "fsUploadProgressannexuploadSimple",
																uploadfiedid:"field-annexupload"
																		},
													debug: false,
													
													//button_image_url : "/cowork/images/add_wev8.png",	// Relative to the SWF file
													button_placeholder_id : "attachmentPlaceHolderannexupload",
											
													button_width: 55,
													button_height: 18,
													button_text : '<span class="button"><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%></span>',
													button_text_style : '.button { font-family: "微软雅黑",Helvetica, Arial, sans-serif; font-size: 12pt;color:#929393 } .buttonSmall { font-size: 10pt; }',
													button_text_top_padding: 0,
													button_text_left_padding: 0,
														
													button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
													button_cursor: SWFUpload.CURSOR.HAND,
													
													file_queued_handler : fileQueued,
													file_queue_error_handler : fileQueueError,				
													file_dialog_complete_handler : function(numFilesSelected, numFilesQueued){		
														  if (numFilesSelected > 0) {		
																	
																	   jQuery("#fsUploadProgressannexuploadSimple").show();
																	   this.startUpload();				
																}

													},
													upload_start_handler : uploadStart,
													upload_progress_handler : uploadProgress,			
													upload_error_handler : uploadError,
													queue_complete_handler : queueComplete,
											
													upload_success_handler : function (file, server_data) {	
														  //文件名称
														  var filename=file.name;
														  //文件名称
														  var htmlstr="&nbsp;<a contentEditable=false style='cursor:pointer;text-decoration:none !important;margin-right:8px;color:#000000'  onclick='try{parent.opendoc1("+jQuery.trim(server_data)+",this);return false;}catch(e){}' ><img src='/images/ecology8/top_icons/4-1_wev8.png'/>"+filename+"</a>&nbsp;&nbsp;<a contentEditable=false href='javascript:void(0)' unselectable='off' contenteditable='false' linkid='1535541' onclick='try{parent.downloads("+jQuery.trim(server_data)+",this);return false;}catch(e){}' style='cursor:pointer;text-decoration:none !important;margin-right:8px;color:#000000''>下载("+file.size/1024+"K)</a><br />"
														  
														  KE.insertHtml('content',htmlstr);

														  var  itemval=jQuery("#field-annexupload").val();
														  if(itemval)
														  {
														  itemval=itemval+","+jQuery.trim(server_data);
														  }
														  else
														  itemval=jQuery.trim(server_data);

														  jQuery("#field-annexupload").val(itemval);

													},				
													upload_complete_handler : function(file){
													   if(this.getStats().files_queued==0){
																//清空上传进度条 
														jQuery("#fsUploadProgressannexuploadSimple").html("");
													   }  
													}
												};


											try {
												oUploadannexupload=new SWFUpload(settings);
											} catch(e) {
												alert(e)
											}
											}
											
										   fileuploadannexupload();
										  </script>
										 </li>
                                         <% }%>
 

 
										 <li>
										 <!--相关流程-->
										 <input type="hidden" id="signworkflowids" name="signworkflowids" >
										 <img src='/images/ecology8/top_icons/3-1_wev8.png'/><a class='appenditem' onclick="onShowSignBrowserForFreeWf('/workflow/request/MultiRequestBrowser.jsp','/workflow/request/ViewRequest.jsp?isrequest=1&requestid=','signworkflowids','signworkflowspan',152)"><%=SystemEnv.getHtmlLabelName(22105,user.getLanguage())%></a></li>
										 
										 <li>
										 <!--相关文档-->
                                         <input type="hidden" id="signdocids" name="signdocids">
										 <img src='/images/ecology8/top_icons/1-1_wev8.png'/><a class='appenditem' onclick="onShowSignBrowserForFreeWf('/docs/docs/MutiDocBrowser.jsp','/docs/docs/DocDsp.jsp?isrequest=1&id=','signdocids','signdocspan',37)"><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></a></li> 
									</ol>
							  
							  </div>
						  </td>
                   </tr>
               </table>
               <script>
                     
					   var  items=[
						'source','justifyleft', 'justifycenter', 'justifyright', 'insertorderedlist', 'insertunorderedlist',
						'title', 'fontname', 'fontsize',  'textcolor', 'bold','italic',  'strikethrough', 'image', 'advtable'
					    ];

						KE.init({
							id : 'content',
							height :292+'px',
							width:'100%',
							resizeMode:1,
							imageUploadJson : '/kindeditor/jsp/upload_json.jsp',
							allowFileManager : false,
							newlineTag:'br',
							items : items,
							afterCreate : function(id) {
								//KE.util.focus(id);
								//插入数据
								KE.insertHtml('content','<%=remarkinfodata%>');

								KE.event.add(KE.g['content'].iframeWin, 'blur', function(e) {

                                    var data=KE.util.getData('content');
       
	                                jQuery("#remarkinfo").val(data);

                                });
							}
						});

                       KE.create('content');


			   </script>
          </div>

      </div>

      <div class="connectlist">
      
	    <div  class='connectusers'>
           <ol class='nav'>
              <li class='itemselected  commonusers'>常用联系人</li>
			  <li style='border-left:1px solid #cccccc; display:none' class='itemunselected  selfdefine'>自定义组</li>
		   </ol>
           <div  class='commonusersitem' >

		           <ol >
                   <%
				   int count=0;
				   for(Integer uid:commonusers)
				      {
                        count++;
						if(count==1)
						  {
				         %>
				             <li class='userselected'><%=Util.toScreen(ResourceComInfo.getResourcename(""+uid),user.getLanguage())%><input type='hidden' name='uid' value='<%=uid%>'><input  type='hidden'  name='uname' value='<%=Util.toScreen(ResourceComInfo.getResourcename(""+uid),user.getLanguage())%>'></li>
                     	 <%
						  }
					     else
						  {
                          %>
				            <li><%=Util.toScreen(ResourceComInfo.getResourcename(""+uid),user.getLanguage())%><input type='hidden' name='uid' value='<%=uid%>'><input  type='hidden'  name='uname' value='<%=Util.toScreen(ResourceComInfo.getResourcename(""+uid),user.getLanguage())%>'></li>
                         <%
				          }	
				    }
					%>
				</ol>
		   
		   </div>
		   <div  class='selfdefineitem' style='display:none'>

		        所有自定义    
		   
		   </div>
		</div>

         <script>



         function doAffirmance(obj){     
			 
			 <!-- 提交确认 -->
    	var nodenum = checkNodesNum();
    	if(nodenum>0)
    	{
    		alert("<%=SystemEnv.getHtmlLabelName(84486,user.getLanguage())%>"+nodenum+"<%=SystemEnv.getHtmlLabelName(84487,user.getLanguage())%>");
    		return false;
    	}
		
        try{
            //为了对《工作安排》流程作特殊的处理，请参考MR1010
            $GetEle("planDoSave").click();
            obj.disabled=true;
        }catch(e){
            var ischeckok="";
            try{
             if(check_form($GetEle("frmmain"),$GetEle("needcheck").value+$GetEle("inputcheck").value))
              ischeckok="true";
            }catch(e){
              ischeckok="false";
            }
            if(ischeckok=="false"){
                if(check_form($GetEle("frmmain"),'requestname'))
                    ischeckok="true";
            }
            if(ischeckok=="true"){
            	CkeditorExt.updateContent();
                if(checktimeok()) {
                	$GetEle("src").value='save';
                        jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3425 20051231
                        obj.disabled=true;
                        $GetEle("topage").value="ViewRequest.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&isaffirmance=1&reEdit=0&fromFlowDoc=";
                       //保存签章数据
                        //附件上传
                        StartUploadAll();
                        checkuploadcomplet();


                    }
             }
        }
	}




           function onShowSignBrowserForFreeWf(url, linkurl, inputname, spanname, type1) {

				//var tmpids = $GetEle(inputname).value;
				var tmpids="";
				if (type1 === 37) {
					id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=" + url
							+ "?documentids=" + tmpids);
				} else {
					id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=" + url
							+ "?resourceids=" + tmpids);
				}
				if (id1) {
					if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0") {
						var resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
						var resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
						
						var sHtml = "";
						resourceids = resourceids.substr(1);
						resourcename = resourcename.substr(1);

                    	
						var resourceidArray = resourceids.split(",");
						
						var resourcenameArray = resourcename.split(",");
						
						var inputResourceidArray = resourceids.split(",");
						
                        var tempval="";
						 var items=[];

                         var editorel=jQuery(".ke-iframe").contents();

                        //确认并生成该签字意见所关联的文档或流程 
                        if (type1 === 37)
						{
					        items=editorel.find(".relatedoc"); 
                       
					    }else
						{
                            items=editorel.find(".relatewf"); 

						}

						 for(var i=0,length=items.length;i<length;i++)
						  {
						     tempval=jQuery(items[i]).attr("relateid");
						     if((","+resourceids).indexOf(","+tempval)<0)
							  {
							    inputResourceidArray.push(tempval);
							  }
						  }


                       	$GetEle(inputname).value = inputResourceidArray.join(",");

						for (var _i=0; _i<resourceidArray.length; _i++) {
							var curid = resourceidArray[_i];
							var curname = resourcenameArray[_i];
							
							if (type1 === 37) 
							sHtml = sHtml+"&nbsp<a contentEditable=false onclick='try{parent.openfreewin(this);return false;}catch(e){}' class='relatedoc' relateid="+curid+" unselectable='off'  style='cursor:pointer;text-decoration:none !important;margin-right:8px;color:#000000' href=" + linkurl + curid
									+ " target='_blank'><img src='/images/ecology8/top_icons/1-1_wev8.png'/>" + curname + "</a>&nbsp";
                             else
                             sHtml = sHtml+"&nbsp<a contentEditable=false onclick='try{parent.openfreewin(this);return false;}catch(e){}' class='relatewf' relateid="+curid+" unselectable='off'  style='cursor:pointer;text-decoration:none !important;margin-right:8px;color:#000000' href=" + linkurl + curid
									+ " target='_blank'><img src='/images/ecology8/top_icons/3-1_wev8.png'/>" + curname + "</a>&nbsp";

						}

					     KE.insertHtml('content',sHtml);

					} else {
						//$GetEle(spanname).innerHTML = "";
						//$GetEle(inputname).value = "";
					}
				}
			}


		
		 //更新#freeNode中的数据
		 function addFreeNode(){
			var ids=jQuery("#operator_0").val();

			if(ids.indexOf(",")==0){
				ids=ids.substr(1);
			}
			var names="";
			if(ids.length>0){
				jQuery("#operator_0").parent().find("a").each(function (){
					names=names+","+jQuery(this).text();
				})
				
				if(names.indexOf(",")==0){
					names=names.substr(1);
				}
			}
				
			if(jQuery(".freeNode").find("input[name='indexnum']").length>0){
				//存在自由节点
				//获取下一个自由节点

				var id=jQuery(".freeNode").find("#indexnum").val();
				var floworder=id;
				var minfloworder;
				var index=0;
				for(var i=0;i<id;i++){
					if(jQuery(".freeNode").find("input[name='floworder_"+i+"']").length>0){
						minfloworder=jQuery(".freeNode").find("input[name='floworder_"+i+"']").val();
						if(floworder>minfloworder){
							floworder=minfloworder;
							index=i;
						}
					}
				}
				jQuery(".freeNode").find("input[name='operatornames_"+index+"']").val(names);
				jQuery(".freeNode").find("input[name='operators_"+index+"']").val(ids);
			}else{
				//不存在自由节点

				jQuery(".freeNode").append("<input type='hidden' name='floworder_0' value='1'/>");//顺序
				jQuery(".freeNode").append("<input type='hidden' name='nodename_0' value='<%=init_nodename%>'/>");//名称
				jQuery(".freeNode").append("<input type='hidden' name='nodetype_0' value='1'/>");
				jQuery(".freeNode").append("<input type='hidden' name='Signtype_0' value='1'/>");//会签类型
				jQuery(".freeNode").append("<input type='hidden' name='operators_0' value='"+ids+"'/>");//操作者id
				jQuery(".freeNode").append("<input type='hidden' name='operatornames_0' value='"+names+"'/>");//操作者name
				
				/**其他设置信息，填写的均是测试值**/
				jQuery(".freeNode").append("<input type='hidden' name='road_0' value='1' />");//路径编辑
				jQuery(".freeNode").append("<input type='hidden' name='frms_0' value='0'/>");//表单编辑
				jQuery(".freeNode").append("<input type='hidden' name='trust_0' value='0'/>");//节点签章
				jQuery(".freeNode").append("<input type='hidden' name='nodeDo_0' value='1'/>");//节点操作
					
				jQuery(".freeNode").append("<input type='hidden' id='rownum' name='rownum' value='1'/>");
				jQuery(".freeNode").append("<input type='hidden' id='indexnum' name='indexnum' value='1'/>");
				jQuery(".freeNode").append("<input type='hidden' id='checkfield' name='checkfield' value='nodename_0,operators_0'/>");
				jQuery(".freeNode").append("<input type='hidden' name='freeDuty' value='<%=init_road%>'/>");
			}
		 }
				
		//定义流程
		jQuery(".definewf").click(function(){
			
			if(jQuery("#operator_0").length>0){
			    	if(jQuery(".freeNode").find("input[name='freeNode']").val()==1){
					addFreeNode();
				}				
			}

			openDialog("<%=SystemEnv.getHtmlLabelName(83284,user.getLanguage())%>","/workflow/request/FreeNodeShow.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&workflowid=<%=workflowid%>&requestid=<%=requestid%>&isroutedit=<%=init_road%>&istableedit=<%=init_frms%>");

			//打开转发对话框

			function openDialog(title,url) {
			　　var dlg=new window.top.Dialog();//定义Dialog对象
				// dialog.currentWindow = window;
			　　dlg.Model=false;
			　　dlg.Width=1000;//定义长度
			　　dlg.Height=550;
			　　dlg.URL=url;
			　　dlg.Title=title;
				dlg.maxiumnable=false;
			　　dlg.show();
				// 保留对话框对象

				window.top.freewindow=window;
				window.top.freedialog=dlg;
		　	}

		})


               <%
				   //如果非自由节点

				   if(!isNextNodeFreeNode){
				   
				   %>
                     jQuery(".formtable").css("margin-right","15px");
				     jQuery(".connectlist").hide();
                     jQuery(".switch").hide();

              <%
			      }
			  %>



              jQuery(".connectlist .nav  li").click(function(){

                   var oppsite;
				   var lis= jQuery(".connectlist .nav  li");
                  if(jQuery(this).hasClass("commonusers"))
				  {
					oppsite=jQuery(".connectlist .nav  li.selfdefine");					
				    oppsite.css("border-left",'1px solid #cccccc');
                    jQuery(this).css("border-right","none");
					jQuery(".commonusersitem").show();
                    jQuery(".selfdefineitem").hide();

				  }else  if(jQuery(this).hasClass("itemunselected"))
				  {
					 oppsite=jQuery(".connectlist .nav  li.commonusers");
				     oppsite.css("border-right",'1px solid #cccccc');
                     jQuery(this).css("border-left","none"); 
					 jQuery(".commonusersitem").hide();
                     jQuery(".selfdefineitem").show();
		
				  }

                    lis.removeClass("itemselected");
					lis.removeClass("itemunselected");
                    jQuery(this).addClass("itemselected");
                    oppsite.addClass("itemunselected");
   		  });

         jQuery(".commonusersitem li").mouseover(function(){
		  
		      jQuery(".commonusersitem li").removeClass("userselected");     
		      jQuery(this).addClass("userselected");
		 
		 });
          //添加常用联系人

		  jQuery(".commonusersitem li").click(function(){
		  
                var  uid=jQuery(this).find("input[name='uid']").val(); 
				var  uname=jQuery(this).find("input[name='uname']").val(); 
			    var data={id:uid,name:"<a href='#"+uid+"'>"+uname+"</a>"};
                var  ids=jQuery("input[name='operator_0']").val();
                ids=","+ids+",";
				if(ids.indexOf(","+uid)<0)
			    {
				     
                     _writeBackData('operator_0',1,data,{isSingle:false,hasInput:true}); 
               
				}

		       // alert('checkitem');
		 
		 });

          	//打开附件
		function opendoc1(showid,obj){
		   openFullWindowHaveBar("/docs/docs/DocDsp.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&id="+showid+"&isOpenFirstAss=0");
		}

		//下载附件
		function downloads(files,obj){
		   //jQuery("#downloadFrame").attr("src","/weaver/weaver.file.FileDownload?fileid="+files+"&download=1");
		   openFullWindowHaveBar("/weaver/weaver.file.FileDownload?fileid="+files+"&download=1")
		}

		function openfreewin(arg)
		{
		  var a=jQuery(arg);
		  var href=a.attr("href");
		  openFullWindowHaveBar(href);
		
		}

		//xwj for td3665 20060227
		function doDrawBack(obj){
			if("0"=="1"&&!confirm("<%=SystemEnv.getHtmlLabelName(24703,user.getLanguage())%>")){
				return false;
			}else{
			    var ischeckok="true";

				if(ischeckok=="true"){	
					jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
					obj.disabled=true;
					$GetEle("frmmain").action="/workflow/workflow/wfFunctionManageLink.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&flag=ov&fromflow=1";
					//附件上传
					StartUploadAll();
					checkuploadcomplet();
			   }
		}
		}
		function doRetract(obj){
			jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
			obj.disabled=true;
			document.location.href="/workflow/workflow/wfFunctionManageLink.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&flag=rb&requestid=88016" //xwj for td3665 20060224
		}

          //开启隐藏常用联系人
      jQuery(".switch").click(function(){
       
	    var connectlist=jQuery(".connectlist");
		if(connectlist.is(":visible"))
		{
			connectlist.hide();
		    //jQuery(".formtable").css("margin-right","0px");
			jQuery(".formtable").animate({"margin-right": '-=210'});
            jQuery(this).find("img").attr("src","/images/ecology8/wf_freeshow_wev8.png");

		}else
		{
            //jQuery(".formtable").css("margin-right","250px");
			jQuery(".formtable").animate({"margin-right": '+=210'});
            connectlist.show().animate({duration: 10000});
			jQuery(this).find("img").attr("src","/images/ecology8/wf_freehide_wev8.png");
		
		}
	
	
	  });


	   <%if(isNextNodeFreeNode){%>
            jQuery(".switch").trigger("click");
       <%}%>
		 </script>
      </div>
      
	  <input type=hidden name="workflowid" value=<%=workflowid%>>
		<input type=hidden name="nodeid" value=<%=nodeid%>>
		<input type=hidden name="nodetype" value="0">
		<input type=hidden name="src">
		<input type=hidden name="formid" value=<%=formid%>>
		<input type="hidden" value="0" name="nodesnum">
		<input type=hidden name ="topage" value="<%=topage%>">
	    
		<input type=hidden name ="requestid" value="<%=requestid%>">
		<input type=hidden name ="requestlevel" value="<%=requestlevel%>">
	    
		<input name='needwfback' type='hidden'>
	    <input name='needcheck' type='hidden' value='0'>
	    <input name='inputcheck' type='hidden' value='0'>
	    <input name='src' type='hidden' >

		<input type=hidden name="requestlevel" value=<%=requestlevel%>>
		<input type=hidden name="creater" value=<%=creater%>>
		<input type=hidden name="creatertype" value=<%=creatertype%>>
		<input type=hidden name="deleted" value=<%=deleted%>>
		<input type=hidden name="billid" value=<%=billid%>>

		<input type=hidden name="workflowtype" value=<%=workflowtype%>>
		<input type=hidden name="isreject" value=<%=isreject%>>
	    <input type=hidden name="docfileid" value=<%=docfileid%>>
	    <input type=hidden name="newdocid" value=<%=newdocid%>>
  </div>
  <div  class='tableformcontent'>
  

  </div>


	  <%
	   if(fc_billid!=0 &&  fc_billid!=-1)
	   {
		   int viewtype=0;

		   if(init_frms==1)
		       viewtype=2;

	  %>
          <script>

		    
             var url="/formmode/worklfowinterface/addformForFreeWorkflow.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&modeId=<%=fc_formmodeid%>&formId=<%=fc_formid%>&type=<%=viewtype%>&billid=<%=fc_billid%>"; 
			 
			 var viewtypeinfo=<%=viewtype%>;
               //表单添加页面
	         var iframeadd=jQuery("<iframe width='100%'  align='center'   id='freeformwin' name='freeformwin'  frameborder='0' scrolling='no' src='"+url+"'></iframe>");
             
			 jQuery(".formtdarea").html("");

             jQuery(".formtdarea").append(iframeadd);

			 jQuery(".formtdarea").parent().show();

			 jQuery(".contentareaonly").html("");
             
			 if(viewtypeinfo===0)
			 jQuery("input[name='isfreeworkflowbindform']").val(0);
			 else
		     jQuery("input[name='isfreeworkflowbindform']").val(1);

		  </script>
	  <%
	   }	 
	  %>


      <%@ include file="/workflow/request/WorkflowManageSign.jsp" %>

    



   </form>


   	<script>
        //复制表单数据到表单隐藏域
        function  cloneValuesToHiddenArea()
        {
		 
		   var hiddencontainer=jQuery(".freewfformtablefields");
		   var container=jQuery(".formtdarea").find("#freeformwin");
		   if(container.length>0)
			{
			   hiddencontainer.html("");
			   var doc=container.contents();
		       var maintable=doc.find(".maintable").clone();
			   var detailtable=doc.find(".detailtable").clone();
               var hiddenarea=doc.find(".formtablehiddenarea").clone();

		       hiddencontainer.append(maintable);
			   hiddencontainer.append(detailtable);
			   hiddencontainer.append(hiddenarea);
			}
		
		}
		
		
		function doSubmit(obj){        <!-- 点击提交 -->

        
      
        cloneValuesToHiddenArea();
	   // alert("check=============>");
		//return;
		
		$G('RejectToNodeid').value = '';
    	try{
      //modify by xhheng @20050328 for TD 1703
      //明细部必填check，通过try $GetEle("needcheck")来检查,避免对原有无明细单据的修改

        var ischeckok="";
        try{
        var checkstr=$GetEle("needcheck").value+$GetEle("inputcheck").value;
        if(0==5){
            checkstr="";
        }
        if(check_form($GetEle("frmmain"),checkstr))
          ischeckok="true";
        }catch(e){
          ischeckok="false";
        }
        if(ischeckok=="false"){
          if(check_form($GetEle("frmmain"),'requestname'))
            ischeckok="true";
        }
        if(ischeckok=="true"){

				if (("1"=="1")&&("1"!="0"))
				   {
				   if (!confirm("<%=SystemEnv.getHtmlLabelName(19990,user.getLanguage())%>"))
					 return false; 
				   }
			     CkeditorExt.updateContent();
				 
				 showtipsinfo(88079,264,2107,1,0,199,obj,"submit");

             }

          }catch(e){
		  
		  }

     	}
  

	</script>

