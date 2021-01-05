
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/docs/DocDetailLog.jsp"%>
 <form name="frmDocSubscribe" method="post">
  
         <TEXTAREA name="subscribeDocId" style="display='none'"></TEXTAREA>    
 </form>
 <SCRIPT LANGUAGE="JavaScript">
        <!--          
          function onSubscribe(obj){
          		var frmDocSubscribe = document.getElementById("frmDocSubscribe");
                document.getElementById("subscribeDocId").value=_table._xtable_CheckedCheckboxId();             
                frmDocSubscribe.action="/docs/docsubscribe/DocSubscribeAdd.jsp"
                obj.disabled = true ;
                frmDocSubscribe.submit();               
          }

          function onResearch(){
              window.location="/docs/search/DocSearch.jsp?from=docsubscribe";
          }

           function onBack(){
               window.history.go(-1);
          }

          function onShowSubscribeHistory(){
              window.location="/docs/docsubscribe/DocSubscribeHistory.jsp";
          }
          function onApprove() {
            window.location="/docs/docsubscribe/DocSubscribeApprove.jsp";
          }
          
          function onBackSubscrible() {
            window.location="/docs/docsubscribe/DocSubscribeBack.jsp";
          }        
        //-->
        </SCRIPT>
