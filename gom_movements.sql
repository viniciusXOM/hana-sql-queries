-- GOM movements
SELECT ts.vsart, ts.tsyst, ts.tsnam, 
       mat.glob_prod_lvl1_no, mat.glob_prod_lvl1, mat.glob_prod_lvl2_no, mat.glob_prod_lvl2, mat.glob_prod_lvl3_no, mat.glob_prod_lvl3, 
       mat.glob_prod_lvl4_no, REPLACE(GLOB_PROD_LVL4,';','') AS "GLOB_PROD_LVL4", mat.material_desc,    
       I.IDATE, SUBSTR(i.idate,1,6) as "SCHED_MONTH", 
       H.NOMNR, H.NOMTYP, H.NOMTK, I.NOMIT, I.YY_WHOLESALER, I.SITYP, I.DOCIND, I.YY_PARCEL, I.YY_TRD_PARCEL, I.YY_INCO1, 
       I.LOCID, L.LOCNAM,        
       I.YY_PLANT, I.YY_STORAGE, P.NAME1 AS "YY_PLANT_NAME",  I.YY_PLANT_I, I.YY_STORAGE_I, 
       PL_I.PLANT_NAME AS "YY_PLANT_NAME_I", PL_I.PLANT_TYPE,
       P.REGIO, P.YYVLOCTYPE, PT.YYVLOCTYPT, PL."PLANT_LATITUDE", PL."PLANT_LONGITUDE", PL."PLANT_IBT",
       I.MENGE, I.UNIT_I, I.ACTUALQTY, I.ACTUALUOM, 
       -- CM_FACTOR ---------------------------------------------------------------------------------------              
          ( case when i.actualuom in ('UG6','UGL') then 1/42 else 0 end ) +
         ( case when i.actualuom in ('KBL','MBL','KB6','MB6') then 1000 else 0 end ) + 
          ( case when i.actualuom in ('M3','M15') then 6.289811 else 0 end ) + 
          ( case when i.actualuom in ('L','L15') then 6.289811/1000 else 0 end ) +                            
          ( case when i.actualuom in ('BB6','BBL') then 1 else 0 end ) AS "CM_FACTOR",
       -- CM_ACTUALQTY_BB6 ---------------------------------------------------------------------------------------       
          ( ( case when i.actualuom in ('UG6','UGL') then 1/42 else 0 end ) +
         ( case when i.actualuom in ('KBL','MBL','KB6','MB6') then 1000 else 0 end ) + 
          ( case when i.actualuom in ('M3','M15') then 6.289811 else 0 end ) +        
          ( case when i.actualuom in ('L','L15') then 6.289811/1000 else 0 end ) +                    
          ( case when i.actualuom in ('BB6','BBL') then 1 else 0 end ) ) * i.actualqty AS "CM_ACTUALQTY_BB6",             
       H.NMCARRIER, VE.NAME1 AS "CARRIER_NAME",       
       H.NMVEHICLE,  VT.VEH_TEXT, --V.VEH_TYPE, V.CLASS_GRP, V.REG_CNTRY, V.YY_VEH_OPER, V.YY_YR_BUILT,    
       H.ERNAM, H.ERDAT, H.NOMST,
       H.CYCLE, H.YY_CREYEAR,           
       I.ISTAT, I.DOCNR, I.DOCITM, I.YY_POSNR,       
       TORA.TRADE_NUM, TORA.TERM, TORA.TRADE_TYPE, TORA.TRADING_NAME, TORA.NAME1 AS "COUNTERPARTY",    TORA.AGREE_DATE, TORA.RESP_ENTITY, TORA.ROOT_CAUSE,
       case when tora_i.prod_short != ''       then tora_i.prod_short       else tora_ip.prod_short       end as "PROD_SHORT",
       case when tora_i.transport_system != '' then tora_i.transport_system else tora_ip.transport_system end as "TRANSPORT_SYSTEM",
       case when tora_i.strategy != ''         then tora_i.strategy         else tora_ip.strategy         end as "STRATEGY",
       case when tora_i.strategy != ''         then stra_i.yprogram         else stra_ip.yprogram         end as "STR_PROGRAM",
       case when tora_i.strategy != ''         then strd_i.description      else strd_ip.description      end as "STR_DESCRIPTION",
       case when tora_i.resp_entity != ''      then tora_i.resp_entity      else tora_ip.resp_entity      end as "I_RESP_ENTITY",
       case when tora_i.root_cause  != ''      then tora_i.root_cause       else tora_ip.root_cause       end as "I_ROOT_CAUSE",
       fpw_h.formnr, fpw_h.formdesc, pmr.pricing_date, pmr.fpw_price, pmr.fixed_price, pmr.diff_price, pmr.total_price, pmr.total_curr, pmr.total_per, pmr.total_unit,
       CASE WHEN SUBSTR(FPW_E.LINE,1,1) = '=' THEN SUBSTR(FPW_E.LINE,2,50) ELSE FPW_E.LINE END AS "FPW_LINE",             
          FPW_FP.FARULE, FP.FARULE_DESC, fp.datfrm AS "FA_DATFRM", fp.datto AS "FA_DATTO", 
          fp.event_date, fp.rdoffset, fp.num_days, fp.days_date, 
          fp.timuom, fp.perbef, fp.peraft, fp.excex, 
          fp.sat_rule, fp.sun_rule, fp.hol_rule, fp.mhol_rule,
          FPW1.QUOSRC||'/'||FPW1.QUOTYP||'/'||FPW1.QUOTNO AS "ZT00",      
          FPW1.SURCHARGE||'-'||FPW1.SURCURR||'/'||FPW1.SURPRUN||' '||FPW1.SURUOM AS "ZT00_S",      
          FPW2.QUOSRC||'/'||FPW2.QUOTYP||'/'||FPW2.QUOTNO AS "ZT01",      
          FPW2.SURCHARGE||'-'||FPW2.SURCURR||'/'||FPW2.SURPRUN||' '||FPW2.SURUOM AS "ZT01_S",         
          FPW3.QUOSRC||'/'||FPW3.QUOTYP||'/'||FPW3.QUOTNO AS "ZT02",      
          FPW3.SURCHARGE||'-'||FPW3.SURCURR||'/'||FPW3.SURPRUN||' '||FPW3.SURUOM AS "ZT02_S",         
          FPW4.QUOSRC||'/'||FPW4.QUOTYP||'/'||FPW4.QUOTNO AS "ZT03",      
          FPW4.SURCHARGE||'-'||FPW4.SURCURR||'/'||FPW4.SURPRUN||' '||FPW4.SURUOM AS "ZT03_S",         
          FPW5.QUOSRC||'/'||FPW5.QUOTYP||'/'||FPW5.QUOTNO AS "ZT04",      
          FPW5.SURCHARGE||'-'||FPW5.SURCURR||'/'||FPW5.SURPRUN||' '||FPW5.SURUOM AS "ZT04_S",         
          FPW6.QUOSRC||'/'||FPW6.QUOTYP||'/'||FPW6.QUOTNO AS "ZT05",      
          FPW6.SURCHARGE||'-'||FPW6.SURCURR||'/'||FPW6.SURPRUN||' '||FPW6.SURUOM AS "ZT05_S",      
       I.S_MATNR_I, M.MATKL, M.MTART, MT.MAKTG,                          
       I.YY_ERP, I.YY_MATNR, I.YY_REBR_MATNR, YY_SPW_MATNR,        
       I.YY_BATCH,         
       I.YY_DMD_LOCID, I.YY_DMD_REGION, I.YY_SPW_LOCID, I.YY_LD_LOCID, LL.LOCNAM AS "LD_LOCNAM", I.YY_DC_LOCID, LD.LOCNAM AS "DC_LOCNAM", I.YY_XF_LOCID,             
       I.YY_SCENARIO, CONCAT(LTRIM(H.NOMTK,0),('/'||LTRIM(I.NOMIT,0))) AS GOM_OIC_PTRIP       
  FROM "HS_GOM_SLT"."OIJNOMH" H         
  INNER JOIN "HS_GOM_SLT"."OIJNOMI" I          
    ON H.NOMTK  = I.NOMTK  
   AND I.DELIND = ''       
  INNER JOIN "_SYS_BIC"."xom.projects.DATAHUB.DIM.MATERIAL.CONSUMPTION/CA_DIM_DH_MATERIAL" MAT
      ON MAT."MATERIAL_KEY"  = I.YY_MATNR
     AND MAT."MATERIAL_SOURCE_SYSTEM"   = 'NA'
--     AND MAT."GLOB_PROD_LVL1_NO" = '010'     
--     AND MAT."GLOB_PROD_LVL2_NO" = '010'
--     AND MAT."GLOB_PROD_LVL2_NO" = '016'     
--     AND MAT."GLOB_PROD_LVL1_NO" = '030'
--     AND MAT."GLOB_PROD_LVL2_NO" IN ('020','031')
--     AND MAT."GLOB_PROD_LVL3_NO" != '057'
--     AND MAT."GLOB_PROD_LVL4_NO" != '505'
  INNER JOIN "HS_GOM_SLT"."OIJTS" TS                 
    ON H.TSYST = TS.TSYST        
  LEFT JOIN "HS_GOM_SLT"."OIGV"  V             
    ON H.NMVEHICLE = V.VEHICLE                 
  LEFT JOIN "HS_GOM_SLT"."OIGVT" VT            
    ON H.NMVEHICLE = VT.VEHICLE         
   AND VT."LANGUAGE" = 'E'       
  LEFT JOIN "HS_DS"."CT_GOM_MARA" M            
    ON I.S_MATNR_I = M.MATNR            
  LEFT JOIN "HS_DS"."CT_GOM_MAKT" MT           
    ON I.S_MATNR_I = MT.MATNR           
   AND MT.SPRAS = 'E'
  LEFT JOIN "HS_GOM_SLT"."LFA1" VE
    ON VE.LIFNR = H.NMCARRIER
  LEFT JOIN "HS_GOM_SLT"."OIJLOC" L            
    ON I.LOCID = L.LOCID         
  LEFT JOIN "HS_GOM_SLT"."OIJLOC" LL           
    ON I.YY_LD_LOCID = LL.LOCID         
  LEFT JOIN "HS_GOM_SLT"."OIJLOC" LD           
    ON I.YY_DC_LOCID = LD.LOCID         
  INNER JOIN ( SELECT DISTINCT A.NOMTK FROM "HS_GOM_SLT"."OIJNOMI" A            
--                INNER JOIN "HS_NASTRIPES_SLT"."T001W" B         
--                  ON A.YY_PLANT = B.WERKS   
 --                 AND B.LAND1 <> 'US'
--                 AND B.LAND1 in ( 'US' , 'CA' )                       
                 WHERE A.YY_ERP = 'AMP'
                   AND A.YY_WHOLESALER = 'EMOC'
                   AND A.IDATE  BETWEEN '20191201' AND '20201231'
                   AND A.DELIND = '' ) K1                                 
    ON H.NOMTK = K1.NOMTK  
--  INNER JOIN ( SELECT DISTINCT A.NOMTK FROM "HS_GOM_SLT"."OIJNOMH" A
                -- WHERE A.NOMNR = 'INTV005CRU-1911-0035'
              --   WHERE A.NOMNR = 'INTV005CRU-2001-0010'
               --  WHERE A.NOMNR = 'INTV005CRU-2002-0018'
               --  WHERE A.NOMNR = 'INTV005CRU-1911-0024'
            --     WHERE A.NOMNR = 'INTV004CRU-2002-7899' -- LIZA
--                   WHERE A.NOMNR IN ('INTV005CRU-2001-0010','INTV005CRU-2002-0018','INTV005CRU-2004-0005','INTV005CRU-1912-0002','INTV002CRU-2003-0014','INTV004CRU-2002-7899')
                 
--                 ) K1
--    ON H.NOMTK = K1.NOMTK
  LEFT JOIN (       
    SELECT DISTINCT I.TRADE_NUM, I.DOCNR, CONCAT('N',SUBSTR(I.DOCNR,2,9)) AS GOM_DOCNR, H."TEMPLATE", H.TRADE_TYPE, H.TRADING_NAME, H.COUNTERPARTY, V.NAME1, H.TERM, H.RESP_ENTITY, H.ROOT_CAUSE, H.AGREE_DATE         
    FROM "HS_NASTRIPES_SLT"."YMTRADEITM" I           
    INNER JOIN "HS_NASTRIPES_SLT"."YMTRADEHDR" H            
      ON I.TRADE_NUM = H.TRADE_NUM             
    INNER JOIN "HS_NASTRIPES_SLT"."LFA1" V           
      ON H.COUNTERPARTY = V.LIFNR ) TORA             
    ON I.DOCNR = TORA.GOM_DOCNR
  LEFT JOIN "HS_NASTRIPES_SLT"."YMTRADEITM" TORA_I
    ON TORA.TRADE_NUM         = TORA_I.TRADE_NUM
   AND I.YY_POSNR             = TORA_I.TRADE_NUM_ITEM    
  LEFT JOIN "HS_NASTRIPES_SLT"."YMTRADEITM" TORA_IP
    ON TORA_I.TRADE_NUM       = TORA_IP.TRADE_NUM
   AND TORA_I.PARENT_NUM_ITEM = TORA_IP.TRADE_NUM_ITEM
  LEFT JOIN "HS_NASTRIPES_SLT"."YMTRTBSTRA" STRA_I
    ON STRA_I.STRATEGY     = TORA_I.STRATEGY 
  LEFT JOIN "HS_NASTRIPES_SLT"."YMTRTBSTRA" STRA_IP
    ON STRA_IP.STRATEGY    = TORA_IP.STRATEGY   
  LEFT JOIN "HS_NASTRIPES_SLT"."YMTRTBSTRD" STRD_I
    ON STRD_I.STRATEGY     = TORA_I.STRATEGY 
  LEFT JOIN "HS_NASTRIPES_SLT"."YMTRTBSTRD" STRD_IP
    ON STRD_IP.STRATEGY    = TORA_IP.STRATEGY       
  LEFT JOIN "HS_NASTRIPES_SLT"."T001W" P             
    ON I.YY_PLANT = P.WERKS  
  LEFT JOIN "HS_NASTRIPES_SLT"."YVLOCTYPET" PT
    ON P.YYVLOCTYPE = PT.YYVLOCTYPE    
   AND PT.SPRAS     = 'E'               
  LEFT JOIN "_SYS_BIC"."xom.projects.DATAHUB.DIM.PLANT.CONSUMPTION/CA_DIM_DH_PLANT" PL
    ON PL.PLANT_KEY = I.YY_PLANT
   AND PL."PLANT_SOURCE_SYSTEM" = 'NA'
  LEFT JOIN "_SYS_BIC"."xom.projects.DATAHUB.DIM.PLANT.CONSUMPTION/CA_DIM_DH_PLANT" PL_I
    ON PL_I.PLANT_KEY = I.YY_PLANT_I
   AND PL_I."PLANT_SOURCE_SYSTEM" = 'NA'   
   LEFT JOIN "HS_NASTRIPES_SLT"."YMRMPMRDOC" PMR
    ON PMR.VALID_TO    = '29991231235959'
   AND PMR.FORMULA_USE = 'FIN'
   AND PMR.RMDOCTYP    = 'NOM'
   AND PMR.RMDOCNR     = i.nomtk
   AND ltrim(PMR.RMDOCITM,0)    = ltrim(i.nomit,0)  
  LEFT JOIN "HS_NASTRIPES_SLT"."YMFPWHEADER" FPW_H
    ON LTRIM(PMR.FORMNR,0)    = LTRIM(FPW_H.FORMNR,0)       
  LEFT JOIN "HS_NASTRIPES_SLT"."YMFPWEDITOR" FPW_E          
    ON LTRIM(FPW_H.FORMNR,0)    = LTRIM(FPW_E.FORMNR,0)            
   AND FPW_E.PFIND            = '1'            
   AND FPW_E.ITEM             = '000001' 
  LEFT JOIN "HS_NASTRIPES_SLT"."YMFPWFPRULE" FPW_FP
    ON LTRIM(FPW_H.FORMNR,0)    = LTRIM(FPW_FP.FORMNR,0)           
   AND FPW_FP.PFIND         = '1'       
   AND FPW_FP.KNUMH         = ''
  LEFT JOIN "HS_NASTRIPES_SLT"."YMFPWPRICEOUT" FP
    ON FP.FARULE = FPW_FP.FARULE
  LEFT JOIN ( SELECT *           
              FROM "HS_NASTRIPES_SLT"."A942" A              
              INNER JOIN "HS_NASTRIPES_SLT"."OICQ6" B       
                ON A.KNUMH = B.KNUMH           
              WHERE A.KAPPL = 'V'       
                AND A.DATBI = '99991231'             
                AND B.KOPOS    = '01'          
                AND FORTRMTYP  = '1'           
                AND FORTRMITM  = '00010'             
                AND PFIND      = '1' ) FPW1          
    ON LTRIM(FPW_H.FORMNR,0) = LTRIM(FPW1.ZZFORMNR,0)       
   AND  FPW1.KSCHL = 'ZT00'                          
             
  LEFT JOIN ( SELECT *           
              FROM "HS_NASTRIPES_SLT"."A942" A              
              INNER JOIN "HS_NASTRIPES_SLT"."OICQ6" B       
                ON A.KNUMH = B.KNUMH           
              WHERE A.KAPPL = 'V'       
                AND A.DATBI = '99991231'             
                AND B.KOPOS    = '01'          
                AND FORTRMTYP  = '1'           
                AND FORTRMITM  = '00010'             
                AND PFIND      = '1' ) FPW2          
    ON LTRIM(FPW_H.FORMNR,0) = LTRIM(FPW2.ZZFORMNR,0)       
   AND  FPW2.KSCHL = 'ZT01'             
             
  LEFT JOIN ( SELECT *           
              FROM "HS_NASTRIPES_SLT"."A942" A              
              INNER JOIN "HS_NASTRIPES_SLT"."OICQ6" B       
                ON A.KNUMH = B.KNUMH           
              WHERE A.KAPPL = 'V'       
                AND A.DATBI = '99991231'             
                AND B.KOPOS    = '01'          
                AND FORTRMTYP  = '1'           
                AND FORTRMITM  = '00010'             
                AND PFIND      = '1' ) FPW3          
    ON LTRIM(FPW_H.FORMNR,0) = LTRIM(FPW3.ZZFORMNR,0)       
   AND  FPW3.KSCHL = 'ZT02'                          
             
  LEFT JOIN ( SELECT *           
              FROM "HS_NASTRIPES_SLT"."A942" A              
              INNER JOIN "HS_NASTRIPES_SLT"."OICQ6" B       
                ON A.KNUMH = B.KNUMH           
              WHERE A.KAPPL = 'V'       
                AND A.DATBI = '99991231'             
                AND B.KOPOS    = '01'          
                AND FORTRMTYP  = '1'           
                AND FORTRMITM  = '00010'             
                AND PFIND      = '1' ) FPW4          
    ON LTRIM(FPW_H.FORMNR,0) = LTRIM(FPW4.ZZFORMNR,0)       
   AND  FPW4.KSCHL = 'ZT03'             
             
  LEFT JOIN ( SELECT *           
              FROM "HS_NASTRIPES_SLT"."A942" A              
              INNER JOIN "HS_NASTRIPES_SLT"."OICQ6" B       
                ON A.KNUMH = B.KNUMH           
              WHERE A.KAPPL = 'V'       
                AND A.DATBI = '99991231'             
                AND B.KOPOS    = '01'          
                AND FORTRMTYP  = '1'           
                AND FORTRMITM  = '00010'             
                AND PFIND      = '1' ) FPW5          
    ON LTRIM(FPW_H.FORMNR,0) = LTRIM(FPW5.ZZFORMNR,0)       
   AND  FPW5.KSCHL = 'ZT04'             
             
   LEFT JOIN ( SELECT *          
              FROM "HS_NASTRIPES_SLT"."A942" A              
              INNER JOIN "HS_NASTRIPES_SLT"."OICQ6" B       
                ON A.KNUMH = B.KNUMH           
              WHERE A.KAPPL = 'V'       
                AND A.DATBI = '99991231'             
                AND B.KOPOS    = '01'          
                AND FORTRMTYP  = '1'           
                AND FORTRMITM  = '00010'             
                AND PFIND      = '1' ) FPW6          
    ON LTRIM(FPW_H.FORMNR,0) = LTRIM(FPW6.ZZFORMNR,0)       
   AND  FPW6.KSCHL = 'ZT05'  
      
  WHERE H.DELIND = ''            
    AND I.DELIND = ''  
 --   AND H.NOMTYP IN ('ZGOM','YGOM')
--   AND TS.VSART NOT IN ('20') -- Take Rail out for now (FOR Crude)
--   AND TS.VSART = '91'
  ORDER BY H.NOMTK, I.NOMIT
