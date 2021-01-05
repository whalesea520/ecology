﻿/*
 * JQuery zTree exedit 3.5.12
 * http://zTree.me/
 *
 * Copyright (c) 2010 Hunter.z
 *
 * Licensed same as jquery - MIT License
 * http://www.opensource.org/licenses/mit-license.php
 *
 * email: hunter.z@263.net
 * Date: 2013-03-11
 */
(function(k){var F={event:{DRAG:"ztree_drag",DROP:"ztree_drop",REMOVE:"ztree_remove",RENAME:"ztree_rename"},id:{EDIT:"_edit",INPUT:"_input",REMOVE:"_remove"},move:{TYPE_INNER:"inner",TYPE_PREV:"prev",TYPE_NEXT:"next"},node:{CURSELECTED_EDIT:"curSelectedNode_Edit",TMPTARGET_TREE:"tmpTargetzTree",TMPTARGET_NODE:"tmpTargetNode"}},D={onHoverOverNode:function(b,a){var c=p.getSetting(b.data.treeId),d=p.getRoot(c);if(d.curHoverNode!=a)D.onHoverOutNode(b);d.curHoverNode=a;e.addHoverDom(c,a)},onHoverOutNode:function(b){var b=
p.getSetting(b.data.treeId),a=p.getRoot(b);if(a.curHoverNode&&!p.isSelectedNode(b,a.curHoverNode))e.removeTreeDom(b,a.curHoverNode),a.curHoverNode=null},onMousedownNode:function(b,a){function c(b){if(z.dragFlag==0&&Math.abs(K-b.clientX)<g.edit.drag.minMoveSize&&Math.abs(L-b.clientY)<g.edit.drag.minMoveSize)return!0;var a,c,f,j,l;l=g.data.key.children;k("body").css("cursor","pointer");if(z.dragFlag==0){if(h.apply(g.callback.beforeDrag,[g.treeId,m],!0)==!1)return q(b),!0;for(a=0,c=m.length;a<c;a++){if(a==
0)z.dragNodeShowBefore=[];f=m[a];f.isParent&&f.open?(e.expandCollapseNode(g,f,!f.open),z.dragNodeShowBefore[f.tId]=!0):z.dragNodeShowBefore[f.tId]=!1}z.dragFlag=1;z.showHoverDom=!1;h.showIfameMask(g,!0);f=!0;j=-1;if(m.length>1){var s=m[0].parentTId?m[0].getParentNode()[l]:p.getNodes(g);l=[];for(a=0,c=s.length;a<c;a++)if(z.dragNodeShowBefore[s[a].tId]!==void 0&&(f&&j>-1&&j+1!==a&&(f=!1),l.push(s[a]),j=a),m.length===l.length){m=l;break}}f&&(D=m[0].getPreNode(),E=m[m.length-1].getNextNode());y=k("<ul class='zTreeDragUL'></ul>");
for(a=0,c=m.length;a<c;a++)if(f=m[a],f.editNameFlag=!1,e.selectNode(g,f,a>0),e.removeTreeDom(g,f),j=k("<li id='"+f.tId+"_tmp'></li>"),j.append(k("#"+f.tId+d.id.A).clone()),j.css("padding","0"),j.children("#"+f.tId+d.id.A).removeClass(d.node.CURSELECTED),y.append(j),a==g.edit.drag.maxShowNodeNum-1){j=k("<li id='"+f.tId+"_moretmp'><a>  ...  </a></li>");y.append(j);break}y.attr("id",m[0].tId+d.id.UL+"_tmp");y.addClass(g.treeObj.attr("class"));y.appendTo("body");t=k("<span class='tmpzTreeMove_arrow'></span>");
t.attr("id","zTreeMove_arrow_tmp");t.appendTo("body");g.treeObj.trigger(d.event.DRAG,[b,g.treeId,m])}if(z.dragFlag==1){r&&t.attr("id")==b.target.id&&u&&b.clientX+x.scrollLeft()+2>k("#"+u+d.id.A,r).offset().left?(f=k("#"+u+d.id.A,r),b.target=f.length>0?f.get(0):b.target):r&&(r.removeClass(d.node.TMPTARGET_TREE),u&&k("#"+u+d.id.A,r).removeClass(d.node.TMPTARGET_NODE+"_"+d.move.TYPE_PREV).removeClass(d.node.TMPTARGET_NODE+"_"+F.move.TYPE_NEXT).removeClass(d.node.TMPTARGET_NODE+"_"+F.move.TYPE_INNER));
u=r=null;G=!1;i=g;f=p.getSettings();for(var B in f)if(f[B].treeId&&f[B].edit.enable&&f[B].treeId!=g.treeId&&(b.target.id==f[B].treeId||k(b.target).parents("#"+f[B].treeId).length>0))G=!0,i=f[B];B=x.scrollTop();j=x.scrollLeft();l=i.treeObj.offset();a=i.treeObj.get(0).scrollHeight;f=i.treeObj.get(0).scrollWidth;c=b.clientY+B-l.top;var o=i.treeObj.height()+l.top-b.clientY-B,n=b.clientX+j-l.left,H=i.treeObj.width()+l.left-b.clientX-j;l=c<g.edit.drag.borderMax&&c>g.edit.drag.borderMin;var s=o<g.edit.drag.borderMax&&
o>g.edit.drag.borderMin,I=n<g.edit.drag.borderMax&&n>g.edit.drag.borderMin,C=H<g.edit.drag.borderMax&&H>g.edit.drag.borderMin,o=c>g.edit.drag.borderMin&&o>g.edit.drag.borderMin&&n>g.edit.drag.borderMin&&H>g.edit.drag.borderMin,n=l&&i.treeObj.scrollTop()<=0,H=s&&i.treeObj.scrollTop()+i.treeObj.height()+10>=a,M=I&&i.treeObj.scrollLeft()<=0,N=C&&i.treeObj.scrollLeft()+i.treeObj.width()+10>=f;if(b.target.id&&i.treeObj.find("#"+b.target.id).length>0){for(var A=b.target;A&&A.tagName&&!h.eqs(A.tagName,"li")&&
A.id!=i.treeId;)A=A.parentNode;var O=!0;for(a=0,c=m.length;a<c;a++)if(f=m[a],A.id===f.tId){O=!1;break}else if(k("#"+f.tId).find("#"+A.id).length>0){O=!1;break}if(O&&b.target.id&&(b.target.id==A.id+d.id.A||k(b.target).parents("#"+A.id+d.id.A).length>0))r=k(A),u=A.id}f=m[0];if(o&&(b.target.id==i.treeId||k(b.target).parents("#"+i.treeId).length>0)){if(!r&&(b.target.id==i.treeId||n||H||M||N)&&(G||!G&&f.parentTId))r=i.treeObj;l?i.treeObj.scrollTop(i.treeObj.scrollTop()-10):s&&i.treeObj.scrollTop(i.treeObj.scrollTop()+
10);I?i.treeObj.scrollLeft(i.treeObj.scrollLeft()-10):C&&i.treeObj.scrollLeft(i.treeObj.scrollLeft()+10);r&&r!=i.treeObj&&r.offset().left<i.treeObj.offset().left&&i.treeObj.scrollLeft(i.treeObj.scrollLeft()+r.offset().left-i.treeObj.offset().left)}y.css({top:b.clientY+B+3+"px",left:b.clientX+j+3+"px"});l=a=0;if(r&&r.attr("id")!=i.treeId){var w=u==null?null:p.getNodeCache(i,u);c=b.ctrlKey&&g.edit.drag.isMove&&g.edit.drag.isCopy||!g.edit.drag.isMove&&g.edit.drag.isCopy;a=!!(D&&u===D.tId);l=!!(E&&u===
E.tId);j=f.parentTId&&f.parentTId==u;f=(c||!l)&&h.apply(i.edit.drag.prev,[i.treeId,m,w],!!i.edit.drag.prev);a=(c||!a)&&h.apply(i.edit.drag.next,[i.treeId,m,w],!!i.edit.drag.next);C=(c||!j)&&!(i.data.keep.leaf&&!w.isParent)&&h.apply(i.edit.drag.inner,[i.treeId,m,w],!!i.edit.drag.inner);if(!f&&!a&&!C){if(r=null,u="",v=d.move.TYPE_INNER,t.css({display:"none"}),window.zTreeMoveTimer)clearTimeout(window.zTreeMoveTimer),window.zTreeMoveTargetNodeTId=null}else{c=k("#"+u+d.id.A,r);l=w.isLastNode?null:k("#"+
w.getNextNode().tId+d.id.A,r.next());s=c.offset().top;j=c.offset().left;I=f?C?0.25:a?0.5:1:-1;C=a?C?0.75:f?0.5:0:-1;b=(b.clientY+B-s)/c.height();(I==1||b<=I&&b>=-0.2)&&f?(a=1-t.width(),l=s-t.height()/2,v=d.move.TYPE_PREV):(C==0||b>=C&&b<=1.2)&&a?(a=1-t.width(),l=l==null||w.isParent&&w.open?s+c.height()-t.height()/2:l.offset().top-t.height()/2,v=d.move.TYPE_NEXT):(a=5-t.width(),l=s,v=d.move.TYPE_INNER);t.css({display:"block",top:l+"px",left:j+a+"px"});c.addClass(d.node.TMPTARGET_NODE+"_"+v);if(P!=
u||Q!=v)J=(new Date).getTime();if(w&&w.isParent&&v==d.move.TYPE_INNER&&(b=!0,window.zTreeMoveTimer&&window.zTreeMoveTargetNodeTId!==w.tId?(clearTimeout(window.zTreeMoveTimer),window.zTreeMoveTargetNodeTId=null):window.zTreeMoveTimer&&window.zTreeMoveTargetNodeTId===w.tId&&(b=!1),b))window.zTreeMoveTimer=setTimeout(function(){v==d.move.TYPE_INNER&&w&&w.isParent&&!w.open&&(new Date).getTime()-J>i.edit.drag.autoOpenTime&&h.apply(i.callback.beforeDragOpen,[i.treeId,w],!0)&&(e.switchNode(i,w),i.edit.drag.autoExpandTrigger&&
i.treeObj.trigger(d.event.EXPAND,[i.treeId,w]))},i.edit.drag.autoOpenTime+50),window.zTreeMoveTargetNodeTId=w.tId}}else if(v=d.move.TYPE_INNER,r&&h.apply(i.edit.drag.inner,[i.treeId,m,null],!!i.edit.drag.inner)?r.addClass(d.node.TMPTARGET_TREE):r=null,t.css({display:"none"}),window.zTreeMoveTimer)clearTimeout(window.zTreeMoveTimer),window.zTreeMoveTargetNodeTId=null;P=u;Q=v}return!1}function q(b){if(window.zTreeMoveTimer)clearTimeout(window.zTreeMoveTimer),window.zTreeMoveTargetNodeTId=null;Q=P=null;
x.unbind("mousemove",c);x.unbind("mouseup",q);x.unbind("selectstart",f);k("body").css("cursor","auto");r&&(r.removeClass(d.node.TMPTARGET_TREE),u&&k("#"+u+d.id.A,r).removeClass(d.node.TMPTARGET_NODE+"_"+d.move.TYPE_PREV).removeClass(d.node.TMPTARGET_NODE+"_"+F.move.TYPE_NEXT).removeClass(d.node.TMPTARGET_NODE+"_"+F.move.TYPE_INNER));h.showIfameMask(g,!1);z.showHoverDom=!0;if(z.dragFlag!=0){z.dragFlag=0;var a,l,j;for(a=0,l=m.length;a<l;a++)j=m[a],j.isParent&&z.dragNodeShowBefore[j.tId]&&!j.open&&(e.expandCollapseNode(g,
j,!j.open),delete z.dragNodeShowBefore[j.tId]);y&&y.remove();t&&t.remove();var o=b.ctrlKey&&g.edit.drag.isMove&&g.edit.drag.isCopy||!g.edit.drag.isMove&&g.edit.drag.isCopy;!o&&r&&u&&m[0].parentTId&&u==m[0].parentTId&&v==d.move.TYPE_INNER&&(r=null);if(r){var n=u==null?null:p.getNodeCache(i,u);if(h.apply(g.callback.beforeDrop,[i.treeId,m,n,v,o],!0)!=!1){var s=o?h.clone(m):m;a=function(){if(G){if(!o)for(var a=0,c=m.length;a<c;a++)e.removeNode(g,m[a]);if(v==d.move.TYPE_INNER)e.addNodes(i,n,s);else if(e.addNodes(i,
n.getParentNode(),s),v==d.move.TYPE_PREV)for(a=0,c=s.length;a<c;a++)e.moveNode(i,n,s[a],v,!1);else for(a=-1,c=s.length-1;a<c;c--)e.moveNode(i,n,s[c],v,!1)}else if(o&&v==d.move.TYPE_INNER)e.addNodes(i,n,s);else if(o&&e.addNodes(i,n.getParentNode(),s),v!=d.move.TYPE_NEXT)for(a=0,c=s.length;a<c;a++)e.moveNode(i,n,s[a],v,!1);else for(a=-1,c=s.length-1;a<c;c--)e.moveNode(i,n,s[c],v,!1);for(a=0,c=s.length;a<c;a++)e.selectNode(i,s[a],a>0);k("#"+s[0].tId).focus().blur();g.treeObj.trigger(d.event.DROP,[b,
i.treeId,s,n,v,o])};v==d.move.TYPE_INNER&&h.canAsync(i,n)?e.asyncNode(i,n,!1,a):a()}}else{for(a=0,l=m.length;a<l;a++)e.selectNode(i,m[a],a>0);g.treeObj.trigger(d.event.DROP,[b,g.treeId,m,null,null,null])}}}function f(){return!1}var l,j,g=p.getSetting(b.data.treeId),z=p.getRoot(g);if(b.button==2||!g.edit.enable||!g.edit.drag.isCopy&&!g.edit.drag.isMove)return!0;var o=b.target,n=p.getRoot(g).curSelectedList,m=[];if(p.isSelectedNode(g,a))for(l=0,j=n.length;l<j;l++){if(n[l].editNameFlag&&h.eqs(o.tagName,
"input")&&o.getAttribute("treeNode"+d.id.INPUT)!==null)return!0;m.push(n[l]);if(m[0].parentTId!==n[l].parentTId){m=[a];break}}else m=[a];e.editNodeBlur=!0;e.cancelCurEditNode(g,null,!0);var x=k(document),y,t,r,G=!1,i=g,D,E,P=null,Q=null,u=null,v=d.move.TYPE_INNER,K=b.clientX,L=b.clientY,J=(new Date).getTime();h.uCanDo(g)&&x.bind("mousemove",c);x.bind("mouseup",q);x.bind("selectstart",f);b.preventDefault&&b.preventDefault();return!0}};k.extend(!0,k.fn.zTree.consts,F);k.extend(!0,k.fn.zTree._z,{tools:{getAbs:function(b){b=
b.getBoundingClientRect();return[b.left,b.top]},inputFocus:function(b){b.get(0)&&(b.focus(),h.setCursorPosition(b.get(0),b.val().length))},inputSelect:function(b){b.get(0)&&(b.focus(),b.select())},setCursorPosition:function(b,a){if(b.setSelectionRange)b.focus(),b.setSelectionRange(a,a);else if(b.createTextRange){var c=b.createTextRange();c.collapse(!0);c.moveEnd("character",a);c.moveStart("character",a);c.select()}},showIfameMask:function(b,a){for(var c=p.getRoot(b);c.dragMaskList.length>0;)c.dragMaskList[0].remove(),
c.dragMaskList.shift();if(a)for(var d=k("iframe"),f=0,e=d.length;f<e;f++){var j=d.get(f),g=h.getAbs(j),j=k("<div id='zTreeMask_"+f+"' class='zTreeMask' style='top:"+g[1]+"px; left:"+g[0]+"px; width:"+j.offsetWidth+"px; height:"+j.offsetHeight+"px;'></div>");j.appendTo("body");c.dragMaskList.push(j)}}},view:{addEditBtn:function(b,a){if(!(a.editNameFlag||k("#"+a.tId+d.id.EDIT).length>0)&&h.apply(b.edit.showRenameBtn,[b.treeId,a],b.edit.showRenameBtn)){var c=k("#"+a.tId+d.id.A),q="<span class='"+d.className.BUTTON+
" edit' id='"+a.tId+d.id.EDIT+"' title='"+h.apply(b.edit.renameTitle,[b.treeId,a],b.edit.renameTitle)+"' treeNode"+d.id.EDIT+" style='display:none;'></span>";c.append(q);k("#"+a.tId+d.id.EDIT).bind("click",function(){if(!h.uCanDo(b)||h.apply(b.callback.beforeEditName,[b.treeId,a],!0)==!1)return!1;e.editNode(b,a);return!1}).show()}},addRemoveBtn:function(b,a){if(!(a.editNameFlag||k("#"+a.tId+d.id.REMOVE).length>0)&&h.apply(b.edit.showRemoveBtn,[b.treeId,a],b.edit.showRemoveBtn)){var c=k("#"+a.tId+
d.id.A),q="<span class='"+d.className.BUTTON+" remove' id='"+a.tId+d.id.REMOVE+"' title='"+h.apply(b.edit.removeTitle,[b.treeId,a],b.edit.removeTitle)+"' treeNode"+d.id.REMOVE+" style='display:none;'></span>";c.append(q);k("#"+a.tId+d.id.REMOVE).bind("click",function(){if(!h.uCanDo(b)||h.apply(b.callback.beforeRemove,[b.treeId,a],!0)==!1)return!1;e.removeNode(b,a);b.treeObj.trigger(d.event.REMOVE,[b.treeId,a]);return!1}).bind("mousedown",function(){return!0}).show()}},addHoverDom:function(b,a){if(p.getRoot(b).showHoverDom)a.isHover=
!0,b.edit.enable&&(e.addEditBtn(b,a),e.addRemoveBtn(b,a)),h.apply(b.view.addHoverDom,[b.treeId,a])},cancelCurEditNode:function(b,a){var c=p.getRoot(b),q=b.data.key.name,f=c.curEditNode;if(f){var l=c.curEditInput,j=a?a:l.val();if(!a&&h.apply(b.callback.beforeRename,[b.treeId,f,j],!0)===!1)return!1;else f[q]=j?j:l.val(),a||b.treeObj.trigger(d.event.RENAME,[b.treeId,f]);k("#"+f.tId+d.id.A).removeClass(d.node.CURSELECTED_EDIT);l.unbind();e.setNodeName(b,f);f.editNameFlag=!1;c.curEditNode=null;c.curEditInput=
null;e.selectNode(b,f,!1)}return c.noSelection=!0},editNode:function(b,a){var c=p.getRoot(b);e.editNodeBlur=!1;if(p.isSelectedNode(b,a)&&c.curEditNode==a&&a.editNameFlag)setTimeout(function(){h.inputFocus(c.curEditInput)},0);else{var q=b.data.key.name;a.editNameFlag=!0;e.removeTreeDom(b,a);e.cancelCurEditNode(b);e.selectNode(b,a,!1);k("#"+a.tId+d.id.SPAN).html("<input type=text class='rename' id='"+a.tId+d.id.INPUT+"' treeNode"+d.id.INPUT+" >");var f=k("#"+a.tId+d.id.INPUT);f.attr("value",a[q]);b.edit.editNameSelectAll?
h.inputSelect(f):h.inputFocus(f);f.bind("blur",function(){e.editNodeBlur||e.cancelCurEditNode(b)}).bind("keydown",function(c){c.keyCode=="13"?(e.editNodeBlur=!0,e.cancelCurEditNode(b,null,!0)):c.keyCode=="27"&&e.cancelCurEditNode(b,a[q])}).bind("click",function(){return!1}).bind("dblclick",function(){return!1});k("#"+a.tId+d.id.A).addClass(d.node.CURSELECTED_EDIT);c.curEditInput=f;c.noSelection=!1;c.curEditNode=a}},moveNode:function(b,a,c,q,f,l){var j=p.getRoot(b),g=b.data.key.children;if(a!=c&&(!b.data.keep.leaf||
!a||a.isParent||q!=d.move.TYPE_INNER)){var h=c.parentTId?c.getParentNode():j,o=a===null||a==j;o&&a===null&&(a=j);if(o)q=d.move.TYPE_INNER;j=a.parentTId?a.getParentNode():j;if(q!=d.move.TYPE_PREV&&q!=d.move.TYPE_NEXT)q=d.move.TYPE_INNER;if(q==d.move.TYPE_INNER)if(o)c.parentTId=null;else{if(!a.isParent)a.isParent=!0,a.open=!!a.open,e.setNodeLineIcos(b,a);c.parentTId=a.tId}var n;o?n=o=b.treeObj:(!l&&q==d.move.TYPE_INNER?e.expandCollapseNode(b,a,!0,!1):l||e.expandCollapseNode(b,a.getParentNode(),!0,!1),
o=k("#"+a.tId),n=k("#"+a.tId+d.id.UL),o.get(0)&&!n.get(0)&&(n=[],e.makeUlHtml(b,a,n,""),o.append(n.join(""))),n=k("#"+a.tId+d.id.UL));var m=k("#"+c.tId);m.get(0)?o.get(0)||m.remove():m=e.appendNodes(b,c.level,[c],null,!1,!0).join("");n.get(0)&&q==d.move.TYPE_INNER?n.append(m):o.get(0)&&q==d.move.TYPE_PREV?o.before(m):o.get(0)&&q==d.move.TYPE_NEXT&&o.after(m);var x=-1,y=0,t=null,o=null,r=c.level;if(c.isFirstNode){if(x=0,h[g].length>1)t=h[g][1],t.isFirstNode=!0}else if(c.isLastNode)x=h[g].length-1,
t=h[g][x-1],t.isLastNode=!0;else for(n=0,m=h[g].length;n<m;n++)if(h[g][n].tId==c.tId){x=n;break}x>=0&&h[g].splice(x,1);if(q!=d.move.TYPE_INNER)for(n=0,m=j[g].length;n<m;n++)j[g][n].tId==a.tId&&(y=n);if(q==d.move.TYPE_INNER){a[g]||(a[g]=[]);if(a[g].length>0)o=a[g][a[g].length-1],o.isLastNode=!1;a[g].splice(a[g].length,0,c);c.isLastNode=!0;c.isFirstNode=a[g].length==1}else a.isFirstNode&&q==d.move.TYPE_PREV?(j[g].splice(y,0,c),o=a,o.isFirstNode=!1,c.parentTId=a.parentTId,c.isFirstNode=!0,c.isLastNode=
!1):a.isLastNode&&q==d.move.TYPE_NEXT?(j[g].splice(y+1,0,c),o=a,o.isLastNode=!1,c.parentTId=a.parentTId,c.isFirstNode=!1,c.isLastNode=!0):(q==d.move.TYPE_PREV?j[g].splice(y,0,c):j[g].splice(y+1,0,c),c.parentTId=a.parentTId,c.isFirstNode=!1,c.isLastNode=!1);p.fixPIdKeyValue(b,c);p.setSonNodeLevel(b,c.getParentNode(),c);e.setNodeLineIcos(b,c);e.repairNodeLevelClass(b,c,r);!b.data.keep.parent&&h[g].length<1?(h.isParent=!1,h.open=!1,a=k("#"+h.tId+d.id.UL),q=k("#"+h.tId+d.id.SWITCH),g=k("#"+h.tId+d.id.ICON),
e.replaceSwitchClass(h,q,d.folder.DOCU),e.replaceIcoClass(h,g,d.folder.DOCU),a.css("display","none")):t&&e.setNodeLineIcos(b,t);o&&e.setNodeLineIcos(b,o);b.check&&b.check.enable&&e.repairChkClass&&(e.repairChkClass(b,h),e.repairParentChkClassWithSelf(b,h),h!=c.parent&&e.repairParentChkClassWithSelf(b,c));l||e.expandCollapseParentNode(b,c.getParentNode(),!0,f)}},removeEditBtn:function(b){k("#"+b.tId+d.id.EDIT).unbind().remove()},removeRemoveBtn:function(b){k("#"+b.tId+d.id.REMOVE).unbind().remove()},
removeTreeDom:function(b,a){a.isHover=!1;e.removeEditBtn(a);e.removeRemoveBtn(a);h.apply(b.view.removeHoverDom,[b.treeId,a])},repairNodeLevelClass:function(b,a,c){if(c!==a.level){var b=k("#"+a.tId),e=k("#"+a.tId+d.id.A),f=k("#"+a.tId+d.id.UL),c=d.className.LEVEL+c,a=d.className.LEVEL+a.level;b.removeClass(c);b.addClass(a);e.removeClass(c);e.addClass(a);f.removeClass(c);f.addClass(a)}}},event:{},data:{setSonNodeLevel:function(b,a,c){if(c){var d=b.data.key.children;c.level=a?a.level+1:0;if(c[d])for(var a=
0,f=c[d].length;a<f;a++)c[d][a]&&p.setSonNodeLevel(b,c,c[d][a])}}}});var E=k.fn.zTree,h=E._z.tools,d=E.consts,e=E._z.view,p=E._z.data;p.exSetting({edit:{enable:!1,editNameSelectAll:!1,showRemoveBtn:!0,showRenameBtn:!0,removeTitle:"remove",renameTitle:"rename",drag:{autoExpandTrigger:!1,isCopy:!0,isMove:!0,prev:!0,next:!0,inner:!0,minMoveSize:5,borderMax:10,borderMin:-5,maxShowNodeNum:5,autoOpenTime:500}},view:{addHoverDom:null,removeHoverDom:null},callback:{beforeDrag:null,beforeDragOpen:null,beforeDrop:null,
beforeEditName:null,beforeRename:null,onDrag:null,onDrop:null,onRename:null}});p.addInitBind(function(b){var a=b.treeObj,c=d.event;a.bind(c.RENAME,function(a,c,d){h.apply(b.callback.onRename,[a,c,d])});a.bind(c.REMOVE,function(a,c,d){h.apply(b.callback.onRemove,[a,c,d])});a.bind(c.DRAG,function(a,c,d,e){h.apply(b.callback.onDrag,[c,d,e])});a.bind(c.DROP,function(a,c,d,e,g,k,o){h.apply(b.callback.onDrop,[c,d,e,g,k,o])})});p.addInitUnBind(function(b){var b=b.treeObj,a=d.event;b.unbind(a.RENAME);b.unbind(a.REMOVE);
b.unbind(a.DRAG);b.unbind(a.DROP)});p.addInitCache(function(){});p.addInitNode(function(b,a,c){if(c)c.isHover=!1,c.editNameFlag=!1});p.addInitProxy(function(b){var a=b.target,c=p.getSetting(b.data.treeId),e=b.relatedTarget,f="",l=null,j="",g=null,k=null;if(h.eqs(b.type,"mouseover")){if(k=h.getMDom(c,a,[{tagName:"a",attrName:"treeNode"+d.id.A}]))f=k.parentNode.id,j="hoverOverNode"}else if(h.eqs(b.type,"mouseout"))k=h.getMDom(c,e,[{tagName:"a",attrName:"treeNode"+d.id.A}]),k||(f="remove",j="hoverOutNode");
else if(h.eqs(b.type,"mousedown")&&(k=h.getMDom(c,a,[{tagName:"a",attrName:"treeNode"+d.id.A}])))f=k.parentNode.id,j="mousedownNode";if(f.length>0)switch(l=p.getNodeCache(c,f),j){case "mousedownNode":g=D.onMousedownNode;break;case "hoverOverNode":g=D.onHoverOverNode;break;case "hoverOutNode":g=D.onHoverOutNode}return{stop:!1,node:l,nodeEventType:j,nodeEventCallback:g,treeEventType:"",treeEventCallback:null}});p.addInitRoot(function(b){b=p.getRoot(b);b.curEditNode=null;b.curEditInput=null;b.curHoverNode=
null;b.dragFlag=0;b.dragNodeShowBefore=[];b.dragMaskList=[];b.showHoverDom=!0});p.addZTreeTools(function(b,a){a.cancelEditName=function(a){var d=p.getRoot(b),f=b.data.key.name,h=d.curEditNode;d.curEditNode&&e.cancelCurEditNode(b,a?a:h[f])};a.copyNode=function(a,k,f,l){if(!k)return null;if(a&&!a.isParent&&b.data.keep.leaf&&f===d.move.TYPE_INNER)return null;var j=h.clone(k);if(!a)a=null,f=d.move.TYPE_INNER;f==d.move.TYPE_INNER?(k=function(){e.addNodes(b,a,[j],l)},h.canAsync(b,a)?e.asyncNode(b,a,l,k):
k()):(e.addNodes(b,a.parentNode,[j],l),e.moveNode(b,a,j,f,!1,l));return j};a.editName=function(a){a&&a.tId&&a===p.getNodeCache(b,a.tId)&&(a.parentTId&&e.expandCollapseParentNode(b,a.getParentNode(),!0),e.editNode(b,a))};a.moveNode=function(a,q,f,l){function j(){e.moveNode(b,a,q,f,!1,l)}if(!q)return q;if(a&&!a.isParent&&b.data.keep.leaf&&f===d.move.TYPE_INNER)return null;else if(a&&(q.parentTId==a.tId&&f==d.move.TYPE_INNER||k("#"+q.tId).find("#"+a.tId).length>0))return null;else a||(a=null);h.canAsync(b,
a)&&f===d.move.TYPE_INNER?e.asyncNode(b,a,l,j):j();return q};a.setEditable=function(a){b.edit.enable=a;return this.refresh()}});var K=e.cancelPreSelectedNode;e.cancelPreSelectedNode=function(b,a){for(var c=p.getRoot(b).curSelectedList,d=0,f=c.length;d<f;d++)if(!a||a===c[d])if(e.removeTreeDom(b,c[d]),a)break;K&&K.apply(e,arguments)};var L=e.createNodes;e.createNodes=function(b,a,c,d){L&&L.apply(e,arguments);c&&e.repairParentChkClassWithSelf&&e.repairParentChkClassWithSelf(b,d)};var R=e.makeNodeUrl;
e.makeNodeUrl=function(b,a){return b.edit.enable?null:R.apply(e,arguments)};var J=e.removeNode;e.removeNode=function(b,a){var c=p.getRoot(b);if(c.curEditNode===a)c.curEditNode=null;J&&J.apply(e,arguments)};var M=e.selectNode;e.selectNode=function(b,a,c){var d=p.getRoot(b);if(p.isSelectedNode(b,a)&&d.curEditNode==a&&a.editNameFlag)return!1;M&&M.apply(e,arguments);e.addHoverDom(b,a);return!0};var N=h.uCanDo;h.uCanDo=function(b,a){var c=p.getRoot(b);return a&&(h.eqs(a.type,"mouseover")||h.eqs(a.type,
"mouseout")||h.eqs(a.type,"mousedown")||h.eqs(a.type,"mouseup"))?!0:!c.curEditNode&&(N?N.apply(e,arguments):!0)}})(jQuery);
