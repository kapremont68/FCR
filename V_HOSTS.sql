--------------------------------------------------------
--  DDL for View V#HOSTS
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V#HOSTS" ("C#ID", "C#HOSTNAME", "C#KPP", "C#INN", "C#BOSS_SHORT_NAME", "C#BOSS_DOLGN", "C#BOSS_FIO_DP", "C#BOSS_FIO", "C#NOTE", "C#ADDRESS", "C#INDEX", "C#BOSS_DOLGN_DP", "C#MAIL", "C#PHONE", "C#OBR", "C#BANK_ACC") AS 
  select T.C#ID
       ,T.C#HOSTNAME
			 ,C#KPP
			 ,C#INN
			 ,C#BOSS_SHORT_NAME
			 ,C#BOSS_DOLGN
			 ,C#BOSS_FIO_DP
			 ,C#BOSS_FIO
			 ,C#NOTE
			 ,C#ADDRESS
			 ,C#INDEX
			 ,C#BOSS_DOLGN_DP
			 ,C#MAIL
			 ,C#PHONE
			 ,C#OBR
             ,C#BANK_ACC
  from HOSTS T, HOSTS_VD T_VD
 where T_VD.C#ID = T.C#ID
   and T_VD.C#VN = (select max(C#VN) from HOSTS_VD where C#ID = T_VD.C#ID)
;
