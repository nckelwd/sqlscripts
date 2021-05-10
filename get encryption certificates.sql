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