
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.docs.category.CategoryUtil" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>

<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DocReceiveUnitManage" class="weaver.docs.senddoc.DocReceiveUnitManager" scope="page"/>
<jsp:useBean id="DocSearchComInfo" class="weaver.docs.search.DocSearchComInfo" scope="session"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="dm" class="weaver.docs.docs.DocManager" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocReceiveUnitComInfo" class="weaver.docs.senddoc.DocReceiveUnitComInfo" scope="page"/>
<%
User user = HrmUserVarify.getUser (request , response) ;
String src = Util.null2String(request.getParameter("src"));
String documentids = Util.null2String(request.getParameter("systemIds"));
if(documentids.trim().startsWith(",")){
	documentids = documentids.substring(1);
}
if(src.equalsIgnoreCase("dest")){
	JSONArray jsonArr = new JSONArray();
	JSONArray jsonArr_tmp = new JSONArray();
	JSONObject json = new JSONObject();
	if(!documentids.equals("")){
		String sql = "select * from DocReceiveUnit where id in ("+documentids+")";
		rs.executeSql(sql);
		while(rs.next()){
			JSONObject tmp = new JSONObject();
			tmp.put("id",rs.getString("id"));
			tmp.put("receiveUnitName",rs.getString("receiveunitname"));
			tmp.put("subcompanyid",SubCompanyComInfo.getSubCompanyname(rs.getString("subcompanyid")));
			jsonArr_tmp.add(tmp);
		}
		String[] documentidArr = Util.TokenizerString2(documentids,",");
		for(int i=0;i<documentidArr.length;i++){
			for(int j=0;j<jsonArr_tmp.size();j++){
				JSONObject tmp = (JSONObject)jsonArr_tmp.get(j);
				if(tmp.get("id").equals(documentidArr[i])){
					jsonArr.add(tmp);
				}
			}
		} 
		
	}
	json.put("currentPage", 1);
	json.put("totalPage", 1);
	json.put("mapList",jsonArr.toString());
	out.println(json.toString());
	return;
}
String nodeid = Util.null2String(request.getParameter("nodeid"));

String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
String receiveUnitId = Util.null2String(request.getParameter("receiveUnitId"));
int showsubdept=Util.getIntValue(request.getParameter("showsubdept"),0);
boolean isoracle = rs.getDBType().equalsIgnoreCase("oracle");
String isWorkflowDoc = Util.null2String(request.getParameter("isWorkflowDoc"));
String requestid = Util.null2String(request.getParameter("requestid"));
int uid=user.getUID();
    String rem = null;
    Cookie[] cks = request.getCookies();

    for (int i = 0; i < cks.length; i++) {
        //System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
        if (cks[i].getName().equals("receiveUnitIdsmulti" + uid)) {
            rem = cks[i].getValue();
            break;
        }
    }

    if (!nodeid.equals("")){
    	if(nodeid.indexOf("unit") > -1){
    		int receiveid_tmp = Util.getIntValue(nodeid.substring(nodeid.indexOf("_")+1), 0);
    		nodeid = "com_"+DocReceiveUnitComInfo.getSubcompanyid(""+receiveid_tmp);
    	}
        rem = nodeid;
    }else if(rem==null || "".equals(rem)){
   		int optSubcompanyid = Util.getIntValue(ResourceComInfo.getSubCompanyID(""+user.getUID()), 0);
    	if(optSubcompanyid > 0){
    		nodeid = "com_"+optSubcompanyid;
    	}
    	rem = nodeid;
    }

Cookie ck = new Cookie("receiveUnitIdsmulti"+uid,rem);  
ck.setMaxAge(30*24*60*60);
response.addCookie(ck);

if(!"".equals(rem)){
	nodeid=rem;
	if(nodeid.indexOf("com")>-1){
	subcompanyid=nodeid.substring(nodeid.indexOf("_")+1);
    //System.out.println("subcompanyid"+subcompanyid);
	}else{
		receiveUnitId=nodeid.substring(nodeid.lastIndexOf("_")+1);
		//System.out.println("departmentid"+departmentid);
	}
}


String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
if(receiveUnitId.equals("0")){
	receiveUnitId = "";
}

if(subcompanyid.equals("0")){
	subcompanyid = "";
}

int ishead = 0;
if(!sqlwhere.equals("")) ishead = 1;
if(!receiveUnitId.equals("")){
	if(showsubdept == 0){
		if(ishead==0){
			ishead = 1;
			sqlwhere += " where (superiorunitid =" + receiveUnitId +" or id="+receiveUnitId+") " ;
		}else{
			sqlwhere += " and (superiorunitid =" + receiveUnitId +" or id="+receiveUnitId+") " ;
		}
	}else{
		if(isoracle == false){
			if(ishead==0){
				ishead = 1;
				sqlwhere += " where (','+allsuperiorunitid+',' like '%," + receiveUnitId +",%'  or id="+receiveUnitId+") " ;
			}else{
				sqlwhere += " and (','+allsuperiorunitid+',' like '%," + receiveUnitId +",%'  or id="+receiveUnitId+") " ;
			}
		}else{
			if(ishead==0){
				ishead = 1;
				sqlwhere += " where (','||allsuperiorunitid||',' like '%," + receiveUnitId +",%'  or id="+receiveUnitId+") " ;
			}else{
				sqlwhere += " and (','||allsuperiorunitid||',' like '%," + receiveUnitId +",%'  or id="+receiveUnitId+") " ;
			}
		}
	}
}
if(!subcompanyid.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where subcompanyid =" + subcompanyid +" " ;
	}else{
		sqlwhere += " and subcompanyid =" + subcompanyid +" " ;
	}
	if(receiveUnitId.equals("") && showsubdept==0){
		sqlwhere += " and superiorunitid=0 ";
	}
}
if(ishead==0){
	ishead = 1;
	sqlwhere += " where (canceled is null or canceled<>'1') " ;
}else{
	sqlwhere += " and (canceled is null or canceled<>'1') " ;
}


int perpage = Util.getIntValue(request.getParameter("pageSize"),10) ;
int pagenum = Util.getIntValue(request.getParameter("currentPage") , 1) ;
if(documentids.equals("")){
	documentids = Util.null2String(request.getParameter("excludeId"));
}
if(!documentids.equals("")){
	sqlwhere += " and id not in ("+documentids+")";
}
if(isWorkflowDoc.equals("1")){
	sqlwhere += " and id not in (select receiver from DocChangeSendDetail where status=0 and requestid="+requestid+")";
}
//过滤分部被删除和被封存的收发文单位
sqlwhere += " and exists(select 1 from hrmsubcompany where hrmsubcompany.id = docreceiveunit.subcompanyid and (hrmsubcompany.canceled is null or hrmsubcompany.canceled <> 1)) " ;
DocReceiveUnitManage.getSelectResultCount(sqlwhere,user);
int RecordSetCounts = DocReceiveUnitManage.getRecordersize();
int totalPage = RecordSetCounts/perpage;
if(totalPage%perpage>0||totalPage==0){
	totalPage++;
}


			//if(!check_per.equals(""))  
			//		check_per = "," + check_per + "," ;
			String id=null;
			String receiveUnitName=null;
			String subcompany=null;

			int i=0;
			DocReceiveUnitManage.setPagenum(pagenum) ;
			DocReceiveUnitManage.setPerpage(perpage) ;
			DocReceiveUnitManage.getSelectResult(sqlwhere,"showOrder","",user) ;
			JSONArray jsonArr = new JSONArray();
			JSONObject json = new JSONObject();
			while(DocReceiveUnitManage.next()) {
				id = ""+DocReceiveUnitManage.getId();
				receiveUnitName = ""+DocReceiveUnitManage.getReceiveunitname();
				subcompany = SubCompanyComInfo.getSubCompanyname(""+DocReceiveUnitManage.getSubcompanyid());
				JSONObject tmp = new JSONObject();
				tmp.put("id",id);
				tmp.put("receiveUnitName",receiveUnitName);
				tmp.put("subcompanyid",subcompany);
				jsonArr.add(tmp);
			}
			json.put("currentPage", pagenum);
			json.put("totalPage", totalPage);
			json.put("mapList",jsonArr.toString());
			out.println(json.toString());
			
%>
				