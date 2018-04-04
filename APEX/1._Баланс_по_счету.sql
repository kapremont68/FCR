prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_050100 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2016.08.24'
,p_release=>'5.1.4.00.08'
,p_default_workspace_id=>1820576413683175
,p_default_application_id=>101
,p_default_owner=>'TEST'
);
end;
/
 
prompt APPLICATION 101 - Gera 1
--
-- Application Export:
--   Application:     101
--   Name:            Gera 1
--   Date and Time:   10:35 Среда Апрель 4, 2018
--   Exported By:     TEST
--   Flashback:       0
--   Export Type:     Page Export
--   Version:         5.1.4.00.08
--   Instance ID:     218235226215706
--

prompt --application/pages/delete_00001
begin
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>1);
end;
/
prompt --application/pages/page_00001
begin
wwv_flow_api.create_page(
 p_id=>1
,p_user_interface_id=>wwv_flow_api.id(2285791393299796)
,p_name=>'Balance'
,p_page_mode=>'NORMAL'
,p_step_title=>'Баланс по счету'
,p_step_sub_title=>'Home'
,p_step_sub_title_type=>'TEXT_WITH_SUBSTITUTIONS'
,p_first_item=>'NO_FIRST_ITEM'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_overwrite_navigation_list=>'N'
,p_page_is_public_y_n=>'Y'
,p_cache_mode=>'NOCACHE'
,p_last_updated_by=>'GERA'
,p_last_upd_yyyymmddhh24miss=>'20180403223334'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(2292494594308039)
,p_name=>'Баланс по счету капремонта'
,p_template=>wwv_flow_api.id(2252176321299756)
,p_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_display_point=>'BODY'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    PERIOD,',
'    CHARGE_SUM_MN,',
'    NULLIF(PAY_SUM_MN, 0) PAY_SUM_MN,',
'    CHARGE_SUM_TOTAL,',
'    PAY_SUM_TOTAL,',
'    CASE WHEN -1 * DOLG_SUM_TOTAL < 0',
'        THEN ''red''',
'    ELSE ''green'' END      THE_COLOR,',
'    -1 * DOLG_SUM_TOTAL   BALANCE_SUM_TOTAL',
'FROM',
'    T#TOTAL_ACCOUNT',
'WHERE',
'    ACCOUNT_ID = (select P#WWW.GET#ACC_ID_BY_ANY_ACC_NUM(:P1_NEW2) from dual)',
'ORDER BY MN desc',
''))
,p_source_type=>'NATIVE_SQL_REPORT'
,p_ajax_enabled=>'Y'
,p_query_row_template=>wwv_flow_api.id(2262163560299768)
,p_query_num_rows=>500
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_show_nulls_as=>'-'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(2292582062308040)
,p_query_column_id=>1
,p_column_alias=>'PERIOD'
,p_column_display_sequence=>1
,p_column_heading=>'Период'
,p_use_as_row_header=>'N'
,p_column_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(2292688958308041)
,p_query_column_id=>2
,p_column_alias=>'CHARGE_SUM_MN'
,p_column_display_sequence=>2
,p_column_heading=>'Начислено<br>за период'
,p_use_as_row_header=>'N'
,p_column_format=>'999G999G999G999G990D00'
,p_column_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(2292819336308043)
,p_query_column_id=>3
,p_column_alias=>'PAY_SUM_MN'
,p_column_display_sequence=>3
,p_column_heading=>'Оплачено<br>за период'
,p_use_as_row_header=>'N'
,p_column_format=>'999G999G999G999G990D00'
,p_column_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(2292718689308042)
,p_query_column_id=>4
,p_column_alias=>'CHARGE_SUM_TOTAL'
,p_column_display_sequence=>4
,p_column_heading=>'Начислено<br>всего <br>за все время'
,p_use_as_row_header=>'N'
,p_column_format=>'999G999G999G999G990D00'
,p_column_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(2292975506308044)
,p_query_column_id=>5
,p_column_alias=>'PAY_SUM_TOTAL'
,p_column_display_sequence=>5
,p_column_heading=>'Оплачено<br>всего <br>за все время'
,p_use_as_row_header=>'N'
,p_column_format=>'999G999G999G999G990D00'
,p_column_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(2374672632885501)
,p_query_column_id=>6
,p_column_alias=>'THE_COLOR'
,p_column_display_sequence=>7
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(2293480675308049)
,p_query_column_id=>7
,p_column_alias=>'BALANCE_SUM_TOTAL'
,p_column_display_sequence=>6
,p_column_heading=>'Состояние счета <br>на конец периода'
,p_use_as_row_header=>'N'
,p_column_format=>'999G999G999G999G990D00'
,p_column_html_expression=>'<span style="color:#THE_COLOR#;">#BALANCE_SUM_TOTAL#</span>'
,p_column_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(2329976193322727)
,p_name=>'New'
,p_template=>wwv_flow_api.id(2252176321299756)
,p_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_display_point=>'BODY'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'with',
'  function get_acc_id return number is',
'  BEGIN',
'    return 92022;',
'  END;',
'',
'  function get_mn return number is',
'  BEGIN',
'    return 207;',
'  END;',
'  ',
'  qqq AS (',
'    select ACCOUNT_ID, MN, DOLG_SUM_TOTAL from T#TOTAL_ACCOUNT',
'  )',
'select',
'  *',
'FROM',
'  qqq',
'WHERE',
'  account_id = get_acc_id',
'  and mn = get_mn',
';',
''))
,p_source_type=>'NATIVE_SQL_REPORT'
,p_ajax_enabled=>'Y'
,p_query_row_template=>wwv_flow_api.id(2262163560299768)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_show_nulls_as=>'-'
,p_query_num_rows_type=>'ROW_RANGES_IN_SELECT_LIST'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(2330046352322728)
,p_query_column_id=>1
,p_column_alias=>'ACCOUNT_ID'
,p_column_display_sequence=>1
,p_column_heading=>'Account id'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(2330109456322729)
,p_query_column_id=>2
,p_column_alias=>'MN'
,p_column_display_sequence=>2
,p_column_heading=>'Mn'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(2330246090322730)
,p_query_column_id=>3
,p_column_alias=>'DOLG_SUM_TOTAL'
,p_column_display_sequence=>3
,p_column_heading=>'Dolg sum total'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(2375493774885509)
,p_name=>'P1_NEW2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(2292494594308039)
,p_prompt=>'Номер счета'
,p_placeholder=>'введите счет и нажмите Enter'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>50
,p_field_template=>wwv_flow_api.id(2274479359299782)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
end;
/
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false));
commit;
end;
/
set verify on feedback on define on
prompt  ...done
