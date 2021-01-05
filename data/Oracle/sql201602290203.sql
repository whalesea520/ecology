update exchange_info set requestids=relatedwf where type_n='WP' and (requestids is null or requestids='') and relatedwf is not null and relatedwf<>''
/
update exchange_info set crmids=relatedcus where type_n='WP' and (crmids is null or crmids='') and relatedcus is not null and relatedcus<>''
/