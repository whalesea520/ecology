alter table FullSearch_FixedInst add defaultImgSrc varchar2(800)
/
update FullSearch_FixedInst set defaultImgSrc = '/fullsearch/img/phone_wev8.jpg' where id = 1
/
update FullSearch_FixedInst set defaultImgSrc = '/fullsearch/img/shortMessage_wev8.jpg' where id =2
/
update FullSearch_FixedInst set defaultImgSrc = '/fullsearch/img/insideInfomation_wev8.jpg' where id =3
/
update FullSearch_FixedInst set defaultImgSrc = '/fullsearch/img/flow_wev8.jpg' where id =4
/
update FullSearch_FixedInst set defaultImgSrc = '/fullsearch/img/remind_wev8.jpg' where id =5
/
update FullSearch_FixedInst set defaultImgSrc = '/fullsearch/img/checkingIn_wev8.jpg' where id =6
/
update  FullSearch_FixedInstShow  set instructionId = 6 where instructionId = 5 and showValue = 'ÎÒÒªÇ©µ½'
/
