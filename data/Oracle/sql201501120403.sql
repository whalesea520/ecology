update HrmResource set usbstate = passwordstate where (userUsbType in ('4') or needdynapass = 1)
/
update HrmResource set usbstate = 1 where usbstate is null
/