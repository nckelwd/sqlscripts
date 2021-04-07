--Get existing TDE keys
SELECT
    name
    ,pvt_key_encryption_type_desc
    ,issuer_name
    ,subject
    ,expiry_date
FROM sys.certificates



--Get TDE Cert by Database
USE master
GO
SELECT
          DatabaseName    = DB_NAME(dek.database_id),
          dek.encryption_state,
          CertificateName = cer.name,
          cer.expiry_date
 FROM
          sys.dm_database_encryption_keys AS dek
     JOIN sys.certificates                AS cer
         ON dek.encryptor_thumbprint = cer.thumbprint;
 


--Create TDE Certificate
/**********************************************************
Replace [DATE] with today's date
This will create the new TDE Certificate
**********************************************************/
CREATE CERTIFICATE TDE_Cert_[DATE] WITH SUBJECT = 'Database_Encryption';



--Backup Certificate
/**********************************************************
Replace [DATE] with today's date
Replace [RANDOM PASSWORD] with a randomized pw
This will back up the certificate to a folder on the server
**********************************************************/
BACKUP CERTIFICATE TDE_Cert_[DATE]
TO FILE = 'D:\SQLCert\TDE_Cert_[DATE]'
WITH PRIVATE KEY (file='D:\SQLCert\TDE_Cert_[DATE].pvk',
ENCRYPTION BY PASSWORD='[RANDOM PASSWORD]')



--Update DBs to use New Certificate
/**********************************************************
Do this for each Database that is encrypted with TDE
**********************************************************/
USE [DATABASE]
ALTER DATABASE ENCRYPTION KEY ENCRYPTION BY SERVER CERTIFICATE TDE_Cert_[DATE];



--Import Cert to another DB
/**********************************************************
Copy the certificate from the first server to the same
location on the second server.
Then, run this, replacing the DATEs and RANDOM
PASSWORD with the same as the newly created cert
**********************************************************/
USE master;
GO
CREATE CERTIFICATE TDE_Cert_[DATE]
  FROM FILE = 'D:\SQLCert\TDE_Cert_[DATE]'
  WITH PRIVATE KEY (
    FILE = N'D:\SQLCert\TDE_Cert_[DATE].pvk',
 DECRYPTION BY PASSWORD = '[RANDOM PASSWORD]'
  );
GO



--Update DBs to use New Certificate (on other servers)
/**********************************************************
Do this for each Database that is encrypted with TDE
**********************************************************/
USE [DATABASE]
ALTER DATABASE ENCRYPTION KEY ENCRYPTION BY SERVER CERTIFICATE TDE_Cert_[DATE];
 
/**********************************************************
You may receive a warning to back up your certificate.
While this is not necessary, you can complete this using
the BACKUP command above listed in this wiki
**********************************************************/

