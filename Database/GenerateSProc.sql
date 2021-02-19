USE SharpsenStream

GO
CREATE PROCEDURE GetStream @StreamName varchar(256)
AS
BEGIN
	SELECT StreamId, OwnerId, StreamName, Live, Title, Description, ChatId FROM Stream
		WHERE Stream.StreamName = @StreamName;
END

GO
CREATE PROCEDURE GetChatRooms
AS
BEGIN
	SELECT ChatId FROM Stream;
END


GO
CREATE PROCEDURE AuthenticateStreamInit @StreamName varchar(256), @Token varchar(512)
AS
IF EXISTS (SELECT Token FROM Stream WHERE StreamName = @StreamName AND Token = @Token)
BEGIN
   RETURN 1 
END
ELSE
BEGIN
    RETURN 0
END

GO
CREATE PROCEDURE Login @Username varchar(256), @PasswordHash varchar(256)
AS
declare @Id int = NULL
SELECT @Id = (SELECT TOP 1 USerId FROM Users WHERE Username = @Username AND UserPassword = @PasswordHash)
IF (@Id is null)
BEGIN
	Select null
END
ELSE
BEGIN
   EXEC dbo.GetUser @Id
END

GO
CREATE PROCEDURE GetUser @Id int
AS
BEGIN
   SELECT TOP 1 UserId, Username, Email, AvatarFilePath, Color FROM Users
		WHERE UserId = @Id
END