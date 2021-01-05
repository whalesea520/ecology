<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util, com.weaver.integration.datesource.*,com.weaver.integration.log.*" %>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ page import="net.sf.json.*,com.sap.mw.jco.JCO" %>
<%@ page import="weaver.conn.RecordSet" %>


<%
    /**
     * add by wshen
     */

    JSONObject jsa = new JSONObject();
    String wFid = Util.null2String(request.getParameter("wFid"));
    String poolid = Util.null2String(request.getParameter("poolid"));
    LogInfo li = new LogInfo();
    SAPInterationOutUtil sou = new SAPInterationOutUtil();
    String message ="";
    boolean flag = true;
    List<String> funlist = new ArrayList<String>();


    if(!"0".equals(poolid)){
        //check the connection
        RecordSet recordSet = new RecordSet();
        recordSet.executeSql("select hostname,systemNum,sapRouter,client,language,username,password from sap_datasource where id ="+poolid);
        if(recordSet.next()){
            SAPInterationBean sb =new SAPInterationBean();
            sb.setHostname(Util.null2String(recordSet.getString("hostname")));//主机IP地址
            sb.setSystemNum(Util.null2String(recordSet.getString("systemNum")));//系统编号
            sb.setSapRouter(Util.null2String(recordSet.getString("sapRouter")));//系统SAP router字符串
            sb.setClient(Util.null2String(recordSet.getString("client")));// 客户端
            sb.setLanguage(Util.null2String(recordSet.getString("language")));//语言
            sb.setUsername(Util.null2String(recordSet.getString("username")));//用户
            sb.setPassword(Util.null2String(recordSet.getString("password")));//密码
            String returnVal = sou.getTestConnection(li,sb);
            if(!"1".equals(returnVal)){
                flag = false;
                message = SystemEnv.getHtmlLabelName(126636,user.getLanguage());//连接SAP异常！
            }
        }else{
            flag = false;
            message = SystemEnv.getHtmlLabelName(126635,user.getLanguage());//该数据源不存在！
        }
        if(flag){//数据源能连接
            //节点附加操作的检查
            String sql ="select distinct b.funname " +
                    " from int_BrowserbaseInfo a left join sap_service b on a.regservice = b.id " +
                    " where a.w_fid= " + wFid;
            RecordSet rs = new RecordSet();
            rs.executeSql(sql);
            while(rs.next()){
                String funName  = Util.null2String(rs.getString("funname"));
                if(!funlist.contains(funName)){
                    funlist.add(funName);
                }
            }

            //系统集成单选按钮的检查
            sql ="select distinct b.funname " +
                    " from int_BrowserbaseInfo a left join sap_service b on a.regservice = b.id " +
                    " where a.mark in (select fielddbtype from workflow_billfield where billid = (select formid from workflow_base where id="+wFid+") and  type =226) ";
            rs.executeSql(sql);
            while(rs.next()){//仅适用于节点附加操作
                String funName  = Util.null2String(rs.getString("funname"));
                if(!funlist.contains(funName)){
                    funlist.add(funName);
                }
            }

            //系统集成多选按钮的检查
            sql ="select distinct b.funname " +
                    " from int_BrowserbaseInfo a left join sap_service b on a.regservice = b.id " +
                    " where a.mark in (select browsermark from sap_multiBrowser where mxformid= (select formid from workflow_base where id="+wFid+")) ";
            rs.executeSql(sql);
            while(rs.next()){//仅适用于节点附加操作
                String funName  = Util.null2String(rs.getString("funname"));
                if(!funlist.contains(funName)){
                    funlist.add(funName);
                }
            }
            for(String funName:funlist){
                JCO.Function fun = sou.getSAPFunction(poolid, funName, li);
                if(fun==null){
                    message = SystemEnv.getHtmlLabelName(126563,user.getLanguage())+funName;//"该数据源中不存在该流程使用的RFC函数，请检查后重新选择。不存在的函数名：";
                    flag = false;
                    break;
                }else{
                    flag = true;
                }
            }
        }
    }
    jsa.accumulate("flag", flag);
    jsa.accumulate("message", message);
    out.clear();
    out.println(jsa);
%>