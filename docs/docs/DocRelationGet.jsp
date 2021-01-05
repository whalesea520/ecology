
<%@ page language="java" contentType="application/x-json;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.regex.*"%>
<%@ page import="org.json.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SpopForDoc" class="weaver.splitepage.operate.SpopForDoc" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%
	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;
	int docid = Util.getIntValue(request.getParameter("docid"),-1);
	int olddocid=Util.getIntValue(request.getParameter("olddocid"),0);
	int requestid=Util.getIntValue(request.getParameter("requestid"),0);
	String isrequest = Util.null2String(request.getParameter("isrequest"));
	String doccreaterid = Util.null2String(request.getParameter("doccreaterid"));
	String docCreaterType = Util.null2String(request.getParameter("docCreaterType"));
	String townerid = Util.null2String(request.getParameter("ownerid"));
	String ownerType = Util.null2String(request.getParameter("ownerType"));
	
	int userid=user.getUID();
	String logintype = user.getLogintype();
	String username=ResourceComInfo.getResourcename(""+userid);
	String userSeclevel = user.getSeclevel();
	String userType = ""+user.getType();
	String userdepartment = ""+user.getUserDepartment();
	String usersubcomany = ""+user.getUserSubCompany1();
	String userInfo=logintype+"_"+userid+"_"+userSeclevel+"_"+userType+"_"+userdepartment+"_"+usersubcomany;
	ArrayList PdocList = SpopForDoc.getDocOpratePopedom(""+docid,userInfo);
	boolean canReader = false;
	if (((String)PdocList.get(0)).equals("true")) canReader = true ;
	
	
	if(olddocid<1) olddocid=docid;
	if(!canReader&&isrequest.equals("1"))
	{
	    int userTypeForThisIf=0;
	    if("2".equals(""+user.getLogintype()))
	    {
			userTypeForThisIf= 1;
		}
			
		StringBuffer sqlSb=new StringBuffer();
		

		sqlSb.append(" select 1 ")
			 .append(" from workflow_currentoperator t2,DocApproveWf t4 ")
			 .append(" where t2.requestid=t4.requestid ")
			 .append("   and t2.requestid= ").append(requestid)
			 .append("   and t4.docId=").append(olddocid)
			 .append("   and t2.userid= ").append(userid)
			 .append("   and t2.usertype= ").append(userTypeForThisIf)
			 .append(" union all ")
			 .append(" select 1 ")
			 .append(" from workflow_currentoperator t2,bill_Approve t4 ")
			 .append(" where t2.requestid=t4.requestid ")
             .append("   and t2.requestid= ").append(requestid)
		     .append("   and t4.approveid= ").append(olddocid)
		     .append("   and t2.userid= ").append(userid)
		     .append("   and t2.usertype= ").append(userTypeForThisIf);


		rs.executeSql(sqlSb.toString());

	    if(rs.next())
	    {
			canReader=true;
		}	
	  	//另外一种情况,子流程触发的,当前流程创建人可以查看文档
	    if(!canReader) 
	    {
	    	rs.executeSql("SELECT 1 FROM workflow_requestbase WHERE requestid="+requestid+" and creater="+userid);
		    if(rs.next()) 
		    {
		    	canReader=true;
		    }
	    }
	}
	if(!canReader)
	{
		if(((""+userid).equals(""+doccreaterid)&&logintype.equals(docCreaterType))||((""+userid).equals(""+townerid)&&logintype.equals(ownerType)))
		{
			canReader=true;
		}
	}
	//System.out.println("canReader : "+canReader);
	if(canReader)
	{
	    String doccontentstr = "";
	    if("oracle".equals(rs.getDBType())){
	    	rs.executeSql("select doccontent from DocDetailContent where docid="+docid);
	    } else {
	    	rs.executeSql("select doccontent from docdetail where id ="+docid);
	    }
	    if (rs.next()) {
	    	doccontentstr = rs.getString(1);
	    }
	    
	    ArrayList dataList=new ArrayList();
		
		ArrayList contentdate = new ArrayList();
	    
	    String doctitles = "";
	    int resourcedocid = 0;
	    String regex="<a.*?/a>"; 
	    Pattern pt=Pattern.compile(regex);
	    Matcher mt=pt.matcher(doccontentstr);
	    while(mt.find()) {
	         
	         String strtile = Util.null2String(mt.group());
	         if(!"".equals(strtile)) {
	        	 doctitles = strtile.replace("&quot;","'");
	         }             
	         String s2="DocDsp.jsp.*?>";   
	         Pattern pt2=Pattern.compile(s2);
	         Matcher mt2=pt2.matcher(mt.group());
	         while(mt2.find()) {
	            String idstrtemp = mt2.group();
	            idstrtemp = idstrtemp.replace("DocDsp.jsp?id=","").replace("&quot;)\">"," ").trim();
	            if(idstrtemp.indexOf(" ")>-1) idstrtemp = idstrtemp.substring(0,idstrtemp.indexOf(" "));
	            if(idstrtemp.indexOf("\"")>-1) idstrtemp = idstrtemp.substring(0,idstrtemp.indexOf("\""));
	            resourcedocid = Util.getIntValue(idstrtemp.trim(),0);
	            if(resourcedocid<=0) continue;
	            String ownerid = "";
	            rs.executeSql("select ownerid from docdetail where id ="+resourcedocid);
	            if(rs.next()) ownerid = rs.getString(1);
	            Hashtable ht=new Hashtable();
	            ht.put("shareId", ""+resourcedocid);
	        	ht.put("shareName", doctitles);
	        	ht.put("shareRealLevel", "");
	        	ht.put("shareRealName", ResourceComInfo.getResourcename(ownerid));
	        	ht.put("shareRealType", "");
	        	ht.put("type","");
	        	
	        	String orderabletemp = "";
	        	rs.executeSql("select orderable from DocSecCategory where id = (select seccategory from DocDetail where id = "+resourcedocid+")");
	        	if(rs.next()) orderabletemp = rs.getString(1);
	        	if(!"1".equals(orderabletemp)){
	        		ht.put("chk", "disabled");
	        	}
	        	
	        	contentdate.add(ht);
	         }
	    }		
		
		dataList.addAll(contentdate);
		
		JSONArray arrayJson=new JSONArray(dataList) ;
		out.println(arrayJson.toString());
	}
	else
	{
		out.println("");
	}
	
%>