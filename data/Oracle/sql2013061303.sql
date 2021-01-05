update SystemRightDetail set rightid=(select id from SystemRights where rightdesc like '%合同种类维护%') where rightdetailname like '%合同种类查看%'
/