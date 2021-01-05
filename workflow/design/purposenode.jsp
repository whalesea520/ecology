<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<jsp:useBean id="WFNodeMainManager" class="weaver.workflow.workflow.WFNodeMainManager" scope="page" />
<%WFNodeMainManager.resetParameter();%>
<jsp:useBean id="WFNodePortalMainManager" class="weaver.workflow.workflow.WFNodePortalMainManager" scope="page" />
<%WFNodePortalMainManager.resetParameter();%>
<%
	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;
	int wfid=0;
	int linkId = 0;
	wfid=Util.getIntValue(Util.null2String(request.getParameter("wfid")),0);
	linkId = Util.getIntValue(Util.null2String(request.getParameter("linkid")),0);
	ArrayList nodeids = new ArrayList();
	ArrayList nodenames = new ArrayList();
	ArrayList nodetypes = new ArrayList();
    ArrayList nodeattrs = new ArrayList();
    nodeids.clear();
	nodenames.clear();
	nodetypes.clear();
    nodeattrs.clear();;
	
    WFNodeMainManager.setWfid(wfid);
	WFNodeMainManager.selectWfNode();
    String nodeidstr="";
    String nodeattrstr="";
    String nodenamestr="";
    String nodeidattr4="";
    while(WFNodeMainManager.next()){
		nodeids.add(""+WFNodeMainManager.getNodeid());
		nodenames.add(WFNodeMainManager.getNodename());
		nodetypes.add(WFNodeMainManager.getNodetype());
        nodeattrs.add(WFNodeMainManager.getNodeattribute());
        if(nodeidstr.equals("")){
            nodeidstr=""+WFNodeMainManager.getNodeid();
            nodeattrstr=WFNodeMainManager.getNodeattribute();
            nodenamestr=WFNodeMainManager.getNodename();
        }else{
            nodeidstr+=","+WFNodeMainManager.getNodeid();
            nodeattrstr+=","+WFNodeMainManager.getNodeattribute();
            nodenamestr+=","+WFNodeMainManager.getNodename();
        }
        if("4".equals(WFNodeMainManager.getNodeattribute())) nodeidattr4+=","+WFNodeMainManager.getNodeid();
    }

	WFNodePortalMainManager.resetParameter();
	WFNodePortalMainManager.setWfid(wfid);
	WFNodePortalMainManager.selectWfNodePortal();
	String jsonString = "{\"options\":[";
	int count= 0;
	while(WFNodePortalMainManager.next()){
		int tmpid = WFNodePortalMainManager.getId();
		
		int curid=WFNodePortalMainManager.getNodeid();
		int desid=WFNodePortalMainManager.getDestnodeid();
		int tmpindex = nodeids.indexOf(""+curid);
		if(tmpindex!=-1){
			String curtype = ""+nodetypes.get(tmpindex);
	        String curattr=""+nodeattrs.get(tmpindex);
	        tmpindex = nodeids.indexOf(""+desid);
	        String desattr="";
	        if(tmpindex!=-1) desattr=""+nodeattrs.get(tmpindex);
	
	  		if(tmpid ==linkId){
				for(int i=0;i<nodeids.size(); i++) {
				    String tempattr=(String)nodeattrs.get(i);
					//if(curid == Util.getIntValue(""+nodeids.get(i))) continue;
					if(curattr.equals("1") && (tempattr.equals("3")||tempattr.equals("4"))) continue;
					if(curattr.equals("2") && (tempattr.equals("0")||tempattr.equals("1"))) continue;
					if((curattr.equals("0")||curattr.equals("3")||curattr.equals("4")) && tempattr.equals("2")) continue;
					jsonString+="{\"name\":\""+Util.stringReplace4DocDspExt((String)nodenames.get(i)).replaceAll("&apos;", "\'") + "\", \"type\":\""+nodeids.get(i)+"\"},";
					count++;
		
				}
	  		}
		}
	}
	if(count>0){
		jsonString=jsonString.substring(0,jsonString.length()-1);
	}
	
	jsonString+="]}";
	out.print(jsonString);
	%>
