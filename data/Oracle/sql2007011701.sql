DELETE FROM HtmlNoteIndex WHERE id = 91
/

DELETE FROM HtmlNoteInfo WHERE indexId = 91
/

INSERT INTO HtmlNoteIndex(id, indexdesc)
VALUES(91, '你已经代理其他用户的流程无法再做流程代理')
/

INSERT INTO HtmlNoteInfo(indexId, noteName, languageId)
VALUES(91, '你已经代理了其他用户的流程，无法再做流程代理！', 7)
/

INSERT INTO HtmlNoteInfo(indexId, noteName, languageId)
VALUES(91, 'You cannot use this function because you have substituted some work flows of other user.', 8)
/