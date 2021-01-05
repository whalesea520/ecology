
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="weaver.common.util.taglib.TreeNode"%>
<%@ page import="weaver.hrm.company.CompanyComInfo"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.hrm.company.SubCompanyComInfo"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<HTML>
<HEAD>
    <script src="/js/tree_wev8.js"></script>
    <LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
</HEAD>


<%
    String rightStr = Util.null2String(request.getParameter("rightStr"));
    CompanyComInfo cc = new CompanyComInfo();
    SubCompanyComInfo scc = new SubCompanyComInfo();
    List compayTreeList=new ArrayList();
    cc.setTofirstRow();
    if(cc.next()){
        //总公司
        int companyId = Util.getIntValue(cc.getCompanyid());

        TreeNode companyNode=new TreeNode();
        companyNode.setTitle("<font color= '#330000'>"+cc.getCompanyname()+"</font>");
        companyNode.setLevel(new Integer(0));
        companyNode.setIcon("companyIcon");
        companyNode.setLinktype("js");
        companyNode.setExpand("true");
        companyNode.setLink("onSelectNode(0)");
        compayTreeList.add(companyNode);

        compayTreeList = scc.getSubCompanyTreeList(compayTreeList,"0",0,999,false,"subSignle",null,null);

        int subCompanyIds[] = CheckSubCompanyRight.getSubComByUserRightId(user.getUID() ,rightStr) ;
        HashMap hm = new HashMap();
        for(int i=0; i<subCompanyIds.length ; i++){
            hm.put(String.valueOf(subCompanyIds[i]),"true");
        }

        int maxLevel = 0;
        for(int i=0; i<compayTreeList.size() ; i++){
            TreeNode node = (TreeNode)compayTreeList.get(i);
            if(node.getLevel().intValue() > maxLevel){
                maxLevel = node.getLevel().intValue() ;
            }
            //System.out.println("Position:" + node.getPosition()+"\tLevel:"+node.getLevel()+"\t"+node.getTitle());
        }
        String str1;
        String str2;
        int pos1;
        int pos2;
        for(int i=maxLevel; i>=0;i--){
            for(int j=compayTreeList.size()-1; j>0 ; j--){
                TreeNode node = (TreeNode)compayTreeList.get(j);
                if(node.getLevel().intValue() == i){
                    str1 = node.getTitle();
                    if(j==compayTreeList.size()-1||((TreeNode)compayTreeList.get(j)).getLevel().compareTo(((TreeNode)compayTreeList.get(j+1)).getLevel())>=0){
                        pos1 = str1.indexOf("value=");
                        if(pos1 != -1){
                            pos2 = str1.indexOf(">",pos1+1);
                            str2 = str1.substring(pos1+6,pos2);
                            //System.out.println("str2 = " + str2);
                            if(hm.get(str2)==null){
                                compayTreeList.remove(j);
                            }

                        }else{
                            compayTreeList.remove(j);
                        }
                    }else{
                        pos1 = str1.indexOf("value=");
                        if(pos1 != -1){
                            pos2 = str1.indexOf(">",pos1+1);
                            str2 = str1.substring(pos1+6,pos2);
                            //System.out.println("str2 = " + str2);
                            if(hm.get(str2)==null){
                                node.setTitle(str1.substring(0,str1.indexOf("<input")+6)+" style='display:none' "+ str1.substring(str1.indexOf("<input")+6));
                            }
                        }
                    }
                }
                //System.out.println("Position:" + node.getPosition()+"\tLevel:"+node.getLevel()+"\t"+node.getTitle());
            }
        }


        for(int i=compayTreeList.size()-1; i>0 ; i--){
            TreeNode node = (TreeNode)compayTreeList.get(i);
            str1 = node.getNodeName() ;
            node.setNodeName(str1.substring(0,str1.indexOf("_")+1 )+i );
            str1 = node.getTitle() ;
            pos1 = str1.indexOf("onRdioChick(");
            if(pos1 != -1){
                node.setTitle(str1.substring(0,pos1+12 )+i+str1.substring(str1.indexOf(")",pos1+12) ) );
            }
            pos1 = str1.indexOf("id=idIndex_");
            if(pos1 != -1){
                node.setTitle(str1.substring(0,pos1+11 )+i+str1.substring(str1.indexOf(" ",pos1+11) ) );
            }

        }



    }
    request.setAttribute("compayTreeList",compayTreeList);
%>
<script language="javaScript">
    function doRightFrame(){
        retStr = onSaveJavaScript();
        subid = retStr.substring(0,retStr.indexOf("_"));
        loc = parent.contentUrl+"";
        //alert(loc);
        if(loc.indexOf("subCompanyId=")!=-1){
            n1 = loc.indexOf("subCompanyId=");
            loc1 = loc.substring(0,n1+13);
            n2 = loc.indexOf("&",n1+13)
            if(n2 == -1){
                //alert(loc1+subid);
                parent.contentframe.location=loc1+subid;
            }else{
                loc2 = loc.substring(n2);
                //alert(loc1+subid+loc2);
                parent.contentframe.location=loc1+subid+loc2;
            }
        }else if(loc.indexOf("?")!=-1){
            //alert(loc+"&subCompanyId="+subid);
            parent.contentframe.location=loc+"&subCompanyId="+subid;
        }else{
            //alert(loc+"?subCompanyId="+subid);
            parent.contentframe.location=loc+"?subCompanyId="+subid;
        }
    }

    var oldIndex=-1;
    function onSelectNode(nodeindex){
        if (tree1.nodes[nodeindex].expanded) {
            tree1.nodes[nodeindex].expand(false);
        } else {
            tree1.nodes[nodeindex].expand(true);
        }


    }

    function onRdioChick(nodeindex){
           //selectNodeAndChild(nodeindex,true)
           oldIndex= nodeindex;
           doRightFrame();
    }

    function selectNodeAndChild(nodeindex,state){
        try {
            if (state){
                tree1.nodes[nodeindex].label.innerHTML= tree1.nodes[nodeindex].label.innerHTML.replace("#330000","#ff0000");
                tree1.nodes[nodeindex].expand(true);
                document.all("idIndex_"+nodeindex).checked=true;
            } else {
                tree1.nodes[nodeindex].label.innerHTML= tree1.nodes[nodeindex].label.innerHTML.replace("#ff0000","#330000");
                tree1.nodes[nodeindex].expand(true);
                document.all("idIndex_"+nodeindex).checked=true;
            }
        } catch(e){
        }

    }

    function onSaveJavaScript(){
        var returnStr="";

        var len = document.forms[0].elements.length;
	    for (i = 0; i <len; i++){
            if (document.forms[0].elements[i].name == 'subid' && document.forms[0].elements[i].checked ){
                returnStr  = document.forms[0].elements[i].value
                returnId = document.forms[0].elements[i].id
                nodeId = returnId.substring(returnId.indexOf("_")+1,returnId.length )
                labelVale =  tree1.nodes[nodeId].label.innerHTML;
                returnName = labelVale.substring(labelVale.indexOf(">")+1,labelVale.indexOf("</FONT>"))
                break   ;
            }
        }
        return returnStr +"_" + returnName;
    }



</script>

<BODY>
    <DIV align=right>

    <script>
     document.body.oncontextmenu=""
    </script>
    </DIV>

    <table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
        <colgroup>
        <col width="10">
        <col width="">
        <col width="10">
        <tr>
            <td height="10" colspan="3"></td>
        </tr>
        <tr>
            <td ></td>
            <td valign="top">
                <TABLE class=Shadow>
                    <tr>
                        <td valign="top">
                            <FORM NAME=SearchForm STYLE="margin-bottom:0" action="SubcompanyBrowser1.jsp" method=post>


                                <TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0">
                                     <TR class=Line1><TH colspan="4" ></TH></TR>
                                      <TR>
                                          <TD colspan="4" >
                                            <%if(compayTreeList.size()==0){%>
                                                 no content
                                             <%}else{%>
                                                <wea:tree nodes="compayTreeList" expandall="3" titleproperty="title" style="cursor: hand"  />
                                             <%}%>
                                          </TD>
                                      </TR>
                                </TABLE>
                            </FORM>
                         </td>
                    </tr>
                </TABLE>
            </td>
            <td></td>
        </tr>
        <tr> <td height="10" colspan="3"></td></tr>
    </table>
</BODY>
</HTML>

