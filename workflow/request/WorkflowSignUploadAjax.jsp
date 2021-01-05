<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.general.AttachFileUtil" %>
<jsp:useBean id="rssign" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rssign1" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="docinf" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page"/>
<%
    int requestid = Util.getIntValue(request.getParameter("requestid"), 0);
    int workflowid = Util.getIntValue(request.getParameter("workflowid"), 0);
    int userid = Util.getIntValue(request.getParameter("userid"), 0);
    int languageid = Util.getIntValue(request.getParameter("languageid"), 0);
    boolean isprint = Util.null2String(request.getParameter("isprint")).equalsIgnoreCase("true") ;
    String isurger=Util.null2String(request.getParameter("isurger"));
    String wfmonitor=Util.null2String(request.getParameter("wfmonitor"));
    int intervenorright=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"intervenorright"),0);

    String returnstr = "<table class=liststyle cellspacing=1>";
    returnstr += "<tr class=HeaderForXtalbe><th>"+SystemEnv.getHtmlLabelName(22969, languageid)+"</th>" +
            "<th>" + SystemEnv.getHtmlLabelName(23752, languageid) + "</th>" +
            "<th>"+SystemEnv.getHtmlLabelName(19998, languageid)+"</th>" +
            "<th>"+SystemEnv.getHtmlLabelName(156, languageid)+SystemEnv.getHtmlLabelName(104, languageid)+"</th></tr>";

    int mainrequestid = 0;
    int mainworkflowid = 0;
    String canviewworkflowid = "-1";
    ArrayList allrequestid = new ArrayList();
    rssign.executeSql("select requestname,mainrequestid from workflow_requestbase where requestid = " + requestid);
    if (rssign.next()) {
        if (rssign.getInt("mainrequestid") > -1) {
            mainrequestid = rssign.getInt("mainrequestid");
            rssign.executeSql("select * from workflow_requestbase where requestid = " + mainrequestid);
            if (rssign.next()) {
                allrequestid.add(mainrequestid + ".main");
            }
        }
    }

    rssign.executeSql("select * from workflow_requestbase where requestid = " + mainrequestid);
    if (rssign.next()) {
        mainworkflowid = rssign.getInt("workflowid");
    }

    rssign.executeSql("select distinct subworkflowid from Workflow_SubwfSet where mainworkflowid in (" + mainworkflowid + "," + workflowid + ") and isread = 1 ");
    while (rssign.next()) {
        canviewworkflowid += "," + rssign.getString("subworkflowid");
    }

    rssign.executeSql("select distinct b.subworkflowid from Workflow_TriDiffWfDiffField a, Workflow_TriDiffWfSubWf b where a.id=b.triDiffWfDiffFieldId and b.isRead=1 and a.mainworkflowid in (" + mainworkflowid + "," + workflowid + ")");
    while (rssign.next()) {
        canviewworkflowid += "," + rssign.getString("subworkflowid");
    }
/**161014 zzw 添加判断 **/
if(mainrequestid>0&&!"-1".equals(canviewworkflowid)){
    rssign.executeSql("select * from workflow_requestbase where mainrequestid = " + mainrequestid + " and workflowid in (" + canviewworkflowid + ")");
    while (rssign.next()) {
        allrequestid.add(rssign.getString("requestid") + ".parallel");
    }
}
if(requestid>0&&!"-1".equals(canviewworkflowid)){
    rssign.executeSql("select * from workflow_requestbase where mainrequestid = " + requestid + " and workflowid in (" + canviewworkflowid + ")");
    while (rssign.next()) {
        allrequestid.add(rssign.getString("requestid") + ".sub");
    }
}

    int index = allrequestid.indexOf(requestid + ".parallel");
    if (index > -1) {
        allrequestid.remove(index);
    }

    if (mainrequestid > 0) {
        rssign.executeSql("select 1 from Workflow_SubwfSet where mainworkflowid = " + mainworkflowid + " and subworkflowid =" + workflowid + " and isread = 1 union select 1 from Workflow_TriDiffWfDiffField a, Workflow_TriDiffWfSubWf b where a.id=b.triDiffWfDiffFieldId and b.isRead=1 and a.mainworkflowid=" + mainworkflowid + " and b.subWorkflowId=" + workflowid);
        if (rssign.getCounts() == 0 && allrequestid.size() > 0) {
            allrequestid.remove(0);
        }
    }

    String viewLogIds = "-1";
    ArrayList canViewIds = new ArrayList();
    rssign.executeSql("select distinct nodeid from workflow_currentoperator where requestid=" + requestid + " and userid=" + userid);

    while (rssign.next()) {
        String singleViewLogIds = "-1";
        rssign1.executeSql("select viewnodeids from workflow_flownode where workflowid=" + workflowid + " and nodeid=" + Util.getIntValue(rssign.getString("nodeid")));
        if (rssign1.next()) {
            singleViewLogIds = rssign1.getString("viewnodeids");
        }

        if ("-1".equals(singleViewLogIds)) {//全部查看
            rssign1.executeSql("select nodeid from workflow_flownode where workflowid= " + workflowid+" and exists(select 1 from workflow_nodebase where id=workflow_flownode.nodeid and (requestid is null or requestid="+requestid+"))");
            while (rssign1.next()) {
                String tempNodeId = rssign1.getString("nodeid");
                if (!canViewIds.contains(tempNodeId)) {
                    canViewIds.add(tempNodeId);
                }
            }
        } else if (singleViewLogIds == null || "".equals(singleViewLogIds)) {//全部不能查看

        } else {//查看部分
            String tempidstrs[] = Util.TokenizerString2(singleViewLogIds, ",");
            for (int i = 0; i < tempidstrs.length; i++) {
                if (!canViewIds.contains(tempidstrs[i])) {
                    canViewIds.add(tempidstrs[i]);
                }
            }
        }
    }
    
    if(isurger.trim().equals("true")||wfmonitor.trim().equals("true")||intervenorright>0){
		rssign1.executeSql("select nodeid from workflow_flownode where workflowid= " + workflowid);
		while(rssign1.next()){
			String tempNodeId = rssign1.getString("nodeid");
			if(!canViewIds.contains(tempNodeId)){
				canViewIds.add(tempNodeId);
			}
		}    
    }

	if (canViewIds.size() > 0) {
        for (int a = 0; a < canViewIds.size(); a++) {
            if (a == 0) {
                viewLogIds = (String) canViewIds.get(a);
            } else {
                viewLogIds += "," + (String) canViewIds.get(a);
            }
        }
    }
    String orderby = "desc";
    ArrayList signdocidlist = new ArrayList();
    String forbidAttDownload="";
    rssign.executeSql("select orderbytype,forbidAttDownload from workflow_base where id = " + workflowid);
    if (rssign.next()) {
        if ("2".equals(rssign.getString(1))) orderby = "asc";
        forbidAttDownload=rssign.getString(2);
    }
    String sql = "select   t1.annexdocids, t2.nodename from workflow_requestlog t1,workflow_nodebase t2 " +
            " where t1.requestid=" + requestid + " and t1.nodeid=t2.id and t1.logtype != '1' " +
            " and t1.nodeid in (" + viewLogIds + ") and annexdocids is not null and annexdocids>' ' order by t1.operatedate " + orderby + ",t1.operatetime " + orderby + ",t1.logtype " + orderby;
    rssign.executeSql(sql);
    while (rssign.next()) {
        String annexdocids = Util.null2String(rssign.getString("annexdocids"));
        ArrayList signlist = Util.TokenizerString(annexdocids, ",");
        for (int i = 0; i < signlist.size(); i++) {
            String tempdoc = (String) signlist.get(i);
            if (tempdoc != null && !"".equals(tempdoc.trim()) && signdocidlist.indexOf(tempdoc) < 0)
                signdocidlist.add(tempdoc);
        }
    }
    for (int j = 0; j < allrequestid.size(); j++) {
        String temp = allrequestid.get(j).toString();
        int tempindex = temp.indexOf(".");
        requestid = Util.getIntValue(temp.substring(0,tempindex),0);
        sql = "select   t1.annexdocids, t2.nodename from workflow_requestlog t1,workflow_nodebase t2 " +
                " where t1.requestid=" + requestid + " and t1.nodeid=t2.id and t1.logtype != '1' " +
                " and annexdocids is not null and annexdocids>' ' order by t1.operatedate " + orderby + ",t1.operatetime " + orderby + ",t1.logtype " + orderby;
        rssign.executeSql(sql);
        while (rssign.next()) {
            String annexdocids = Util.null2String(rssign.getString("annexdocids"));
            ArrayList signlist = Util.TokenizerString(annexdocids, ",");
            for (int i = 0; i < signlist.size(); i++) {
                String tempdoc = (String) signlist.get(i);
                if (tempdoc != null && !"".equals(tempdoc.trim()) && signdocidlist.indexOf(tempdoc) < 0)
                    signdocidlist.add(tempdoc);
            }
        }
    }
    int linknum = -1;
    
    //拼接docids:用‘,’隔开 Start
    String docids="";
    ArrayList nodownloadList = new ArrayList();
    int indexFlag=0;
    for (int k = 0; k < signdocidlist.size(); k++) {
        indexFlag++;
        String docidTemp=(String) signdocidlist.get(k);
        int SecCategoryTemp = docinf.getDocSecCategory(docidTemp);
        String nodownloadFlag = SecCategoryComInfo1.getNoDownload(""+SecCategoryTemp);
        nodownloadList.add(nodownloadFlag);
        if(indexFlag==signdocidlist.size()){
          docids=docids+(String) signdocidlist.get(k);
        }else{
          docids=docids+(String) signdocidlist.get(k)+",";
        }
    }
    //System.out.println("--------signdocidlist.size():"+signdocidlist.size()+"----docids:"+docids);
    //拼接docids:用‘,’隔开 end
    
    for (int k = 0; k < signdocidlist.size(); k++) {
        linknum++;
        String docid = (String) signdocidlist.get(k);
        String docsubject = docinf.getDocname(docid);
        int accessoryCount = Util.getIntValue(docinf.getAccessoryCount(docid), 0);
        int SecCategory = docinf.getDocSecCategory(docid);
        DocImageManager.resetParameter();
        DocImageManager.setDocid(Util.getIntValue(docid));
        DocImageManager.selectDocImageInfo();

        String docImagefileid = "";
        long docImagefileSize = 0;
        String docImagefilename = "";
        String fileExtendName = "";
        int versionId = 0;

        int AttachmentCounts=signdocidlist.size();

        if (DocImageManager.next()) {
            //DocImageManager会得到doc第一个附件的最新版本
            docImagefileid = DocImageManager.getImagefileid();
            docImagefileSize = DocImageManager.getImageFileSize(Util.getIntValue(docImagefileid));
            docImagefilename = DocImageManager.getImagefilename();
            fileExtendName = docImagefilename.substring(docImagefilename.lastIndexOf(".") + 1).toLowerCase();
            versionId = DocImageManager.getVersionId();
        }
        if (accessoryCount > 1) {
            fileExtendName = "htm";
        }
        String imgSrc = AttachFileUtil.getImgStrbyExtendName(fileExtendName, 16);
        boolean nodownload = SecCategoryComInfo1.getNoDownload("" + SecCategory).equals("1") ? true : false;
        if(k%2==0){
            returnstr += "<tr class=datalight>";
        }else{
            returnstr += "<tr class=datadark>";
        }
        returnstr += "<td>" + imgSrc+"</td><td>";
        if(accessoryCount==1 && (Util.isExt(fileExtendName)||fileExtendName.equalsIgnoreCase("pdf"))){     
            returnstr += "<a style=\"cursor:hand\" onclick=\"addDocReadTag('" + docid + "');openFullWindowHaveBar('/docs/docs/DocDspExt.jsp?id=" + docid + "&imagefileId=" + docImagefileid + "&isFromAccessory=true&isrequest=1&requestid=" + requestid + "')\">" + docImagefilename + "</a></td>";
        } else {
            returnstr += "<a style=\"cursor:hand\" onclick=\"addDocReadTag('" + docid + "');openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id=" + docid + "&isrequest=1&requestid=" + requestid + "')\">" + docsubject + "</a></td>";
        }
        returnstr+="<td>"+docImagefileSize / 1000+"K</td><td>";
        if(!isprint&&((!fileExtendName.equalsIgnoreCase("xls")&&!fileExtendName.equalsIgnoreCase("doc"))||!nodownload)){
            returnstr += "<a style=\"cursor:hand\" onclick=\"addDocReadTag('" + docid + "');top.location='/weaver/weaver.file.FileDownload?fileid=" + docImagefileid + "&download=1&requestid=" + requestid + "&fromrequest=1'\">"
            + SystemEnv.getHtmlLabelName(258, languageid) + "</a>";
            //System.out.println("--------signdocidlist.size():"+signdocidlist.size()+"---------AttachmentCounts:"+AttachmentCounts+"-------linknum:"+linknum+"-----SecCategory:"+SecCategory);
            if(!"1".equals(forbidAttDownload)&&AttachmentCounts>1 && !nodownload && linknum==0){
              returnstr += "&nbsp;&nbsp;<a style=\"cursor:hand\" onclick=\"addDocReadTag('" + docid + "');top.location='/weaver/weaver.file.FileDownload?fieldvalue=" + docids + "&download=1&downloadBatch=1&requestid=" + requestid + "&fromrequest=1'\">"
              +SystemEnv.getHtmlLabelName(332,languageid)+ SystemEnv.getHtmlLabelName(258, languageid) + "</a>";            
            }
        }
        returnstr += "</td>";
        returnstr += "</tr>";
    }
    if(signdocidlist.size()<1){
        returnstr+="<tr><td colspan=4>&nbsp;</td></tr>";
    }
    returnstr += "</tbody></table>";
    //System.out.print("returnstrup:"+returnstr);
    response.setContentType("text/text;charset=UTF-8");//返回的是txt文本文件
    out.print(returnstr);
%>