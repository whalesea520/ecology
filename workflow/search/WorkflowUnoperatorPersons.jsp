
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.io.Writer"%>
<jsp:useBean id="rc" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="cci" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
String requestid=Util.null2String(request.getParameter("requestid"));
String returntdid=Util.null2String(request.getParameter("returntdid"));
String returnStr="";
if(requestid.indexOf("-")==-1) {
//增加isremark字段，用来判断是否归档节点
//rs.executeSql("select distinct userid,usertype,agenttype,agentorbyagentid from workflow_currentoperator where (isremark in ('0','1','5','7','8','9') or (isremark='4' and viewtype=0))  and requestid = " + requestid);
rs.executeSql("select distinct userid,usertype,agenttype,agentorbyagentid,isremark from workflow_currentoperator where (isremark in ('0','1','5','7','8','9') or (isremark='4' and viewtype=0))  and requestid = " + requestid);
     
        while(rs.next()){
        	if(returnStr.equals("")){
        		if(rs.getInt("usertype")==0){
	        		//if(rs.getInt("agenttype")==2)
	        		//	returnStr +=  rc.getResourcename(rs.getString("agentorbyagentid"))+"->"+rc.getResourcename(rs.getString("userid"));
	        		//else
	        		//	returnStr +=  rc.getResourcename(rs.getString("userid"));
                    if(rs.getInt("agenttype")==2){
                        returnStr +=  rc.getResourcename(rs.getString("agentorbyagentid"))+"->"+rc.getResourcename(rs.getString("userid"));
                    //判断是否被代理者,如果是，则不显示该记录
                    }else if(rs.getInt("agenttype")==1 && rs.getInt("isremark") == 4){
                        continue;
                    }else{
                        returnStr +=  rc.getResourcename(rs.getString("userid"));
                    }
        		}else{
        			returnStr +=  cci.getCustomerInfoname(rs.getString("userid"));
        		}
        	}
        	else{
        		if(rs.getInt("usertype")==0){        		
	        		//if(rs.getInt("agenttype")==2)
	        		//	returnStr +=  ","+rc.getResourcename(rs.getString("agentorbyagentid"))+"->"+rc.getResourcename(rs.getString("userid"));
	        		//else
	        		//	returnStr +=  ","+rc.getResourcename(rs.getString("userid"));
	        		if(rs.getInt("agenttype")==2){
                        returnStr +=  ","+rc.getResourcename(rs.getString("agentorbyagentid"))+"->"+rc.getResourcename(rs.getString("userid"));
                    //判断是否被代理者,如果是，则不显示该记录
                    }else if(rs.getInt("agenttype")==1 && rs.getInt("isremark") == 4){
                        continue;
	        		}else{
                        returnStr +=  ","+rc.getResourcename(rs.getString("userid"));
	        		}
	    		}else{
	    			//TD11591(人力资源与客户同时存在时、加','处理)
	    			returnStr +=  ","+cci.getCustomerInfoname(rs.getString("userid"));
	    		}
        	}
        }
		out.print(returnStr);
		return;
}else{
    rs.executeSql("select distinct userid from ofs_todo_data where requestid="+requestid+" and isremark='0' and islasttimes=1");
    while(rs.next()){
        returnStr += rc.getResourcename(rs.getString("userid"))+",";
    }
	if(returnStr.endsWith(",")){
		returnStr = returnStr.substring(0,returnStr.length()-1);
	}
    out.print(returnStr);
    return;
}
		%>