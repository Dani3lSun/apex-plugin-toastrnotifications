set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_050000 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2013.01.01'
,p_release=>'5.0.4.00.12'
,p_default_workspace_id=>42937890966776491
,p_default_application_id=>600
,p_default_owner=>'APEX_PLUGIN'
);
end;
/
prompt --application/ui_types
begin
null;
end;
/
prompt --application/shared_components/plugins/dynamic_action/de_danielh_toastrnotifications
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(22202715987744999699)
,p_plugin_type=>'DYNAMIC ACTION'
,p_name=>'DE.DANIELH.TOASTRNOTIFICATIONS'
,p_display_name=>'toastr Notifications'
,p_category=>'INIT'
,p_supported_ui_types=>'DESKTOP'
,p_plsql_code=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'/*-------------------------------------',
' * toastr Functions',
' * Version: 1.0.1 (24.10.2017)',
' * Author:  Daniel Hochleitner',
' *-------------------------------------',
'*/',
'FUNCTION render_toastr(p_dynamic_action IN apex_plugin.t_dynamic_action,',
'                       p_plugin         IN apex_plugin.t_plugin)',
'  RETURN apex_plugin.t_dynamic_action_render_result IS',
'  --',
'  l_toastr_type        VARCHAR2(100) := p_dynamic_action.attribute_01;',
'  l_text               VARCHAR2(500) := p_dynamic_action.attribute_02;',
'  l_position_class     VARCHAR2(100) := p_dynamic_action.attribute_03;',
'  l_close_btn          VARCHAR2(50) := p_dynamic_action.attribute_04;',
'  l_newest_ontop       VARCHAR2(50) := p_dynamic_action.attribute_05;',
'  l_progress_bar       VARCHAR2(50) := p_dynamic_action.attribute_06;',
'  l_prevent_duplicates VARCHAR2(50) := p_dynamic_action.attribute_07;',
'  l_show_duration      VARCHAR2(50) := p_dynamic_action.attribute_08;',
'  l_hide_duration      VARCHAR2(50) := p_dynamic_action.attribute_09;',
'  l_timeout            VARCHAR2(50) := p_dynamic_action.attribute_10;',
'  l_extended_timeout   VARCHAR2(50) := p_dynamic_action.attribute_11;',
'  --',
'  l_result apex_plugin.t_dynamic_action_render_result;',
'  --',
'  l_toastr_options_string VARCHAR2(4000);',
'  l_toastr_type_string    VARCHAR2(2000);',
'BEGIN',
'  -- Debug',
'  IF apex_application.g_debug THEN',
'    apex_plugin_util.debug_dynamic_action(p_plugin         => p_plugin,',
'                                          p_dynamic_action => p_dynamic_action);',
'  END IF;',
'  --',
'  -- Escaping',
'  l_text := apex_escape.json(l_text);',
'  --',
'  -- toastr CSS',
'  apex_css.add_file(p_name      => ''toastr.min'',',
'                    p_directory => p_plugin.file_prefix);',
'  --',
'  -- toastr JS',
'  apex_javascript.add_library(p_name           => ''toastr.min'',',
'                              p_directory      => p_plugin.file_prefix,',
'                              p_version        => NULL,',
'                              p_skip_extension => FALSE);',
'  --',
'  -- toastr options',
'  l_toastr_options_string := ''toastr.options = { '' ||',
'                             apex_javascript.add_attribute(p_name      => ''closeButton'',',
'                                                           p_value     => l_close_btn, -- true/false',
'                                                           p_add_comma => TRUE) ||',
'                             apex_javascript.add_attribute(p_name      => ''newestOnTop'',',
'                                                           p_value     => l_newest_ontop, -- true/false',
'                                                           p_add_comma => TRUE) ||',
'                             apex_javascript.add_attribute(p_name      => ''progressBar'',',
'                                                           p_value     => l_progress_bar, -- true/false',
'                                                           p_add_comma => TRUE) ||',
'                             apex_javascript.add_attribute(p_name      => ''positionClass'',',
'                                                           p_value     => l_position_class, -- CSS class',
'                                                           p_add_comma => TRUE) ||',
'                             apex_javascript.add_attribute(p_name      => ''preventDuplicates'',',
'                                                           p_value     => l_prevent_duplicates, -- true/false',
'                                                           p_add_comma => TRUE) ||',
'                             apex_javascript.add_attribute(p_name      => ''showDuration'',',
'                                                           p_value     => l_show_duration, -- number time ms',
'                                                           p_add_comma => TRUE) ||',
'                             apex_javascript.add_attribute(p_name      => ''hideDuration'',',
'                                                           p_value     => l_hide_duration, -- number time ms',
'                                                           p_add_comma => TRUE) ||',
'                             apex_javascript.add_attribute(p_name      => ''timeOut'',',
'                                                           p_value     => l_timeout, -- number time ms',
'                                                           p_add_comma => TRUE) ||',
'                             apex_javascript.add_attribute(p_name      => ''extendedTimeOut'',',
'                                                           p_value     => l_extended_timeout, -- number time ms',
'                                                           p_add_comma => TRUE) ||',
'                             apex_javascript.add_attribute(p_name      => ''showEasing'',',
'                                                           p_value     => ''swing'',',
'                                                           p_add_comma => TRUE) ||',
'                             apex_javascript.add_attribute(p_name      => ''hideEasing'',',
'                                                           p_value     => ''linear'',',
'                                                           p_add_comma => TRUE) ||',
'                             apex_javascript.add_attribute(p_name      => ''showMethod'',',
'                                                           p_value     => ''fadeIn'',',
'                                                           p_add_comma => TRUE) ||',
'                             apex_javascript.add_attribute(p_name      => ''hideMethod'',',
'                                                           p_value     => ''fadeOut'',',
'                                                           p_add_comma => FALSE) || ''} '';',
'  -- Replace true/false quotes',
'  l_toastr_options_string := REPLACE(REPLACE(l_toastr_options_string,',
'                                             ''"true"'',',
'                                             ''true''),',
'                                     ''"false"'',',
'                                     ''false'');',
'  -- ',
'  -- toastr text per type',
'  IF l_toastr_type = ''info'' THEN',
'    l_toastr_type_string := ''toastr.info("'' || l_text || ''");'';',
'  ELSIF l_toastr_type = ''success'' THEN',
'    l_toastr_type_string := ''toastr.success("'' || l_text || ''");'';',
'  ELSIF l_toastr_type = ''warning'' THEN',
'    l_toastr_type_string := ''toastr.warning("'' || l_text || ''");'';',
'  ELSIF l_toastr_type = ''error'' THEN',
'    l_toastr_type_string := ''toastr.error("'' || l_text || ''");'';',
'  END IF;',
'  --',
'  -- function per DA that calls options + type',
'  apex_javascript.add_inline_code(p_code => ''function call_toastr_'' ||',
'                                            p_dynamic_action.id || ''() { '' ||',
'                                            l_toastr_options_string ||',
'                                            chr(10) || l_toastr_type_string ||',
'                                            chr(10) || '' }'');',
'  --',
'  l_result.javascript_function := ''function(){call_toastr_'' ||',
'                                  p_dynamic_action.id || ''();}'';',
'  l_result.attribute_01        := l_toastr_type;',
'  l_result.attribute_02        := l_text;',
'  l_result.attribute_03        := l_position_class;',
'  l_result.attribute_04        := l_close_btn;',
'  l_result.attribute_05        := l_newest_ontop;',
'  l_result.attribute_06        := l_progress_bar;',
'  l_result.attribute_07        := l_prevent_duplicates;',
'  l_result.attribute_08        := l_show_duration;',
'  l_result.attribute_09        := l_hide_duration;',
'  l_result.attribute_10        := l_timeout;',
'  l_result.attribute_11        := l_extended_timeout;',
'  --',
'  RETURN l_result;',
'  --',
'END render_toastr;'))
,p_render_function=>'render_toastr'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_help_text=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'Dynamic Action Plugin using OpenSource JS framework "toastr" to display notifications.',
'This plugin can be used to display info, success, warning or error messages.',
'Original from: https://github.com/CodeSeven/toastr'))
,p_version_identifier=>'1.0.1'
,p_about_url=>'https://github.com/Dani3lSun/apex-plugin-toastrnotifications'
,p_files_version=>23
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(11159155291935799439)
,p_plugin_id=>wwv_flow_api.id(22202715987744999699)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Type'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'info'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'Select the type of the notification. This preferences controls the color.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(11159155575468800162)
,p_plugin_attribute_id=>wwv_flow_api.id(11159155291935799439)
,p_display_sequence=>10
,p_display_value=>'Info'
,p_return_value=>'info'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(11159155976589801059)
,p_plugin_attribute_id=>wwv_flow_api.id(11159155291935799439)
,p_display_sequence=>20
,p_display_value=>'Success'
,p_return_value=>'success'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(11159156394874801704)
,p_plugin_attribute_id=>wwv_flow_api.id(11159155291935799439)
,p_display_sequence=>30
,p_display_value=>'Warning'
,p_return_value=>'warning'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(11159156810978802258)
,p_plugin_attribute_id=>wwv_flow_api.id(11159155291935799439)
,p_display_sequence=>40
,p_display_value=>'Error'
,p_return_value=>'error'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(11159157214550805980)
,p_plugin_id=>wwv_flow_api.id(22202715987744999699)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Text'
,p_attribute_type=>'TEXTAREA'
,p_is_required=>true
,p_is_translatable=>true
,p_help_text=>'Enter the text which is displayed in the notification. Page-Items &P100_ITEM_NAME. can be used.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(11159157517642813076)
,p_plugin_id=>wwv_flow_api.id(22202715987744999699)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Position'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'toast-top-right'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'Choose the position/location of the notification.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(11159157806994814361)
,p_plugin_attribute_id=>wwv_flow_api.id(11159157517642813076)
,p_display_sequence=>10
,p_display_value=>'Top Right'
,p_return_value=>'toast-top-right'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(11159158181010815010)
,p_plugin_attribute_id=>wwv_flow_api.id(11159157517642813076)
,p_display_sequence=>20
,p_display_value=>'Top Left'
,p_return_value=>'toast-top-left'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(11159158620686816974)
,p_plugin_attribute_id=>wwv_flow_api.id(11159157517642813076)
,p_display_sequence=>30
,p_display_value=>'Bottom Right'
,p_return_value=>'toast-bottom-right'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(11159159001546818392)
,p_plugin_attribute_id=>wwv_flow_api.id(11159157517642813076)
,p_display_sequence=>40
,p_display_value=>'Bottom Left'
,p_return_value=>'toast-bottom-left'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(11159159358903819879)
,p_plugin_attribute_id=>wwv_flow_api.id(11159157517642813076)
,p_display_sequence=>50
,p_display_value=>'Top Full Width'
,p_return_value=>'toast-top-full-width'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(11159159801166821355)
,p_plugin_attribute_id=>wwv_flow_api.id(11159157517642813076)
,p_display_sequence=>60
,p_display_value=>'Bottom Full Width'
,p_return_value=>'toast-bottom-full-width'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(11159160144636825189)
,p_plugin_id=>wwv_flow_api.id(22202715987744999699)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'Show Close Button'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'true'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'Should a close button be displayed?'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(11159160507544825738)
,p_plugin_attribute_id=>wwv_flow_api.id(11159160144636825189)
,p_display_sequence=>10
,p_display_value=>'True'
,p_return_value=>'true'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(11159160896296826318)
,p_plugin_attribute_id=>wwv_flow_api.id(11159160144636825189)
,p_display_sequence=>20
,p_display_value=>'False'
,p_return_value=>'false'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(11159161304330830296)
,p_plugin_id=>wwv_flow_api.id(22202715987744999699)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'Newest on top'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'true'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'When using multiple notifications on 1 page, should the newest be on top?'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(11159161557439831191)
,p_plugin_attribute_id=>wwv_flow_api.id(11159161304330830296)
,p_display_sequence=>10
,p_display_value=>'True'
,p_return_value=>'true'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(11159161953455831642)
,p_plugin_attribute_id=>wwv_flow_api.id(11159161304330830296)
,p_display_sequence=>20
,p_display_value=>'False'
,p_return_value=>'false'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(11159162496772837130)
,p_plugin_id=>wwv_flow_api.id(22202715987744999699)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_prompt=>'Show Progress Bar'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'false'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'Show a progress bar to visualize the time when a notification disappears.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(11159162829965837582)
,p_plugin_attribute_id=>wwv_flow_api.id(11159162496772837130)
,p_display_sequence=>10
,p_display_value=>'True'
,p_return_value=>'true'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(11159163235586838028)
,p_plugin_attribute_id=>wwv_flow_api.id(11159162496772837130)
,p_display_sequence=>20
,p_display_value=>'False'
,p_return_value=>'false'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(11159163760888843384)
,p_plugin_id=>wwv_flow_api.id(22202715987744999699)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>70
,p_prompt=>'Prevent Duplicates'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>false
,p_default_value=>'true'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'Block notifications with the same text/content to display multiple times.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(11159164079351844015)
,p_plugin_attribute_id=>wwv_flow_api.id(11159163760888843384)
,p_display_sequence=>10
,p_display_value=>'True'
,p_return_value=>'true'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(11159164536283844463)
,p_plugin_attribute_id=>wwv_flow_api.id(11159163760888843384)
,p_display_sequence=>20
,p_display_value=>'False'
,p_return_value=>'false'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(11159164929461850756)
,p_plugin_id=>wwv_flow_api.id(22202715987744999699)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>8
,p_display_sequence=>120
,p_prompt=>'Show Duration'
,p_attribute_type=>'NUMBER'
,p_is_required=>false
,p_default_value=>'300'
,p_is_translatable=>false
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(11159165233403851928)
,p_plugin_id=>wwv_flow_api.id(22202715987744999699)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>9
,p_display_sequence=>130
,p_prompt=>'Hide Duration'
,p_attribute_type=>'NUMBER'
,p_is_required=>false
,p_default_value=>'1000'
,p_is_translatable=>false
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(11159165531381854116)
,p_plugin_id=>wwv_flow_api.id(22202715987744999699)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>10
,p_display_sequence=>100
,p_prompt=>'Timeout'
,p_attribute_type=>'NUMBER'
,p_is_required=>true
,p_default_value=>'5000'
,p_is_translatable=>false
,p_help_text=>'How long the toast will display without user interaction (in ms). A value of 0 makes a sticky notification.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(11159165785685855785)
,p_plugin_id=>wwv_flow_api.id(22202715987744999699)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>11
,p_display_sequence=>110
,p_prompt=>'Extended Timeout'
,p_attribute_type=>'NUMBER'
,p_is_required=>true
,p_default_value=>'1000'
,p_is_translatable=>false
,p_help_text=>'How long the toast will display after a user hovers over it (in ms).'
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2E746F6173742D7469746C657B666F6E742D7765696768743A3730307D2E746F6173742D6D6573736167657B2D6D732D776F72642D777261703A627265616B2D776F72643B776F72642D777261703A627265616B2D776F72647D2E746F6173742D6D6573';
wwv_flow_api.g_varchar2_table(2) := '7361676520612C2E746F6173742D6D657373616765206C6162656C7B636F6C6F723A236666667D2E746F6173742D6D65737361676520613A686F7665727B636F6C6F723A236363633B746578742D6465636F726174696F6E3A6E6F6E657D2E746F617374';
wwv_flow_api.g_varchar2_table(3) := '2D636C6F73652D627574746F6E7B706F736974696F6E3A72656C61746976653B72696768743A2D2E33656D3B746F703A2D2E33656D3B666C6F61743A72696768743B666F6E742D73697A653A323070783B666F6E742D7765696768743A3730303B636F6C';
wwv_flow_api.g_varchar2_table(4) := '6F723A236666663B2D7765626B69742D746578742D736861646F773A3020317078203020236666663B746578742D736861646F773A3020317078203020236666663B6F7061636974793A2E383B2D6D732D66696C7465723A616C706861284F7061636974';
wwv_flow_api.g_varchar2_table(5) := '793D3830293B66696C7465723A616C706861286F7061636974793D3830297D2E746F6173742D636C6F73652D627574746F6E3A666F6375732C2E746F6173742D636C6F73652D627574746F6E3A686F7665727B636F6C6F723A233030303B746578742D64';
wwv_flow_api.g_varchar2_table(6) := '65636F726174696F6E3A6E6F6E653B637572736F723A706F696E7465723B6F7061636974793A2E343B2D6D732D66696C7465723A616C706861284F7061636974793D3430293B66696C7465723A616C706861286F7061636974793D3430297D627574746F';
wwv_flow_api.g_varchar2_table(7) := '6E2E746F6173742D636C6F73652D627574746F6E7B70616464696E673A303B637572736F723A706F696E7465723B6261636B67726F756E643A3020303B626F726465723A303B2D7765626B69742D617070656172616E63653A6E6F6E657D2E746F617374';
wwv_flow_api.g_varchar2_table(8) := '2D746F702D63656E7465727B746F703A303B72696768743A303B77696474683A313030257D2E746F6173742D626F74746F6D2D63656E7465727B626F74746F6D3A303B72696768743A303B77696474683A313030257D2E746F6173742D746F702D66756C';
wwv_flow_api.g_varchar2_table(9) := '6C2D77696474687B746F703A303B72696768743A303B77696474683A313030257D2E746F6173742D626F74746F6D2D66756C6C2D77696474687B626F74746F6D3A303B72696768743A303B77696474683A313030257D2E746F6173742D746F702D6C6566';
wwv_flow_api.g_varchar2_table(10) := '747B746F703A313270783B6C6566743A313270787D2E746F6173742D746F702D72696768747B746F703A313270783B72696768743A313270787D2E746F6173742D626F74746F6D2D72696768747B72696768743A313270783B626F74746F6D3A31327078';
wwv_flow_api.g_varchar2_table(11) := '7D2E746F6173742D626F74746F6D2D6C6566747B626F74746F6D3A313270783B6C6566743A313270787D23746F6173742D636F6E7461696E65727B706F736974696F6E3A66697865643B7A2D696E6465783A3939393939397D23746F6173742D636F6E74';
wwv_flow_api.g_varchar2_table(12) := '61696E6572202A7B2D6D6F7A2D626F782D73697A696E673A626F726465722D626F783B2D7765626B69742D626F782D73697A696E673A626F726465722D626F783B626F782D73697A696E673A626F726465722D626F787D23746F6173742D636F6E746169';
wwv_flow_api.g_varchar2_table(13) := '6E65723E6469767B706F736974696F6E3A72656C61746976653B6F766572666C6F773A68696464656E3B6D617267696E3A302030203670783B70616464696E673A313570782031357078203135707820353070783B77696474683A33303070783B2D6D6F';
wwv_flow_api.g_varchar2_table(14) := '7A2D626F726465722D7261646975733A3370783B2D7765626B69742D626F726465722D7261646975733A3370783B626F726465722D7261646975733A3370783B6261636B67726F756E642D706F736974696F6E3A313570782063656E7465723B6261636B';
wwv_flow_api.g_varchar2_table(15) := '67726F756E642D7265706561743A6E6F2D7265706561743B2D6D6F7A2D626F782D736861646F773A302030203132707820233939393B2D7765626B69742D626F782D736861646F773A302030203132707820233939393B626F782D736861646F773A3020';
wwv_flow_api.g_varchar2_table(16) := '30203132707820233939393B636F6C6F723A236666663B6F7061636974793A2E383B2D6D732D66696C7465723A616C706861284F7061636974793D3830293B66696C7465723A616C706861286F7061636974793D3830297D23746F6173742D636F6E7461';
wwv_flow_api.g_varchar2_table(17) := '696E65723E3A686F7665727B2D6D6F7A2D626F782D736861646F773A302030203132707820233030303B2D7765626B69742D626F782D736861646F773A302030203132707820233030303B626F782D736861646F773A302030203132707820233030303B';
wwv_flow_api.g_varchar2_table(18) := '6F7061636974793A313B2D6D732D66696C7465723A616C706861284F7061636974793D313030293B66696C7465723A616C706861286F7061636974793D313030293B637572736F723A706F696E7465727D23746F6173742D636F6E7461696E65723E2E74';
wwv_flow_api.g_varchar2_table(19) := '6F6173742D696E666F7B6261636B67726F756E642D696D6167653A75726C28646174613A696D6167652F706E673B6261736536342C6956424F5277304B47676F414141414E535568455567414141426741414141594341594141414467647A3334414141';
wwv_flow_api.g_varchar2_table(20) := '4141584E535230494172733463365141414141526E51553142414143786A777638595155414141414A6345685A6377414144734D4141413744416364767147514141414777535552425645684C745A613953674E42454D63397355787852636F554B537A';
wwv_flow_api.g_varchar2_table(21) := '535749685870464D68685957466861426734795059695743585A78424C4552734C52533345516B456677434B646A574A4177534B43676F4B4363756476344F35594C727437457A6758686955332F342B6232636B6D77566A4A53704B6B51367741693467';
wwv_flow_api.g_varchar2_table(22) := '7768542B7A3377524263457A30796A53736555547263527966734873586D4430416D62484F433949693856496D6E75584250676C48705135777753564D37734E6E5447375A61344A774464436A7879416948336E7941326D7461544A756669445A356443';
wwv_flow_api.g_varchar2_table(23) := '61716C4974494C68314E486174664E35736B766A78395A33386D363943677A75586D5A675672504947453736334A7839714B73526F7A57597736784F486445522B6E6E324B6B4F2B42622B55563543424E36574336517442676252566F7A72616841626D';
wwv_flow_api.g_varchar2_table(24) := '6D364874557367745043313974466478585A59424F666B626D464A3156614841315641486A6430707037306F545A7A76522B455672783259676664737136657535354248595238686C636B692B6E2B6B4552554647384272413042776A654176324D3857';
wwv_flow_api.g_varchar2_table(25) := '4C51427463792B534436664E736D6E4233416C424C726754745657316332514E346256574C415461495336304A32447535793154694A676A53427646565A67546D7743552B64415A466F507847454573386E79484339427765324776454A763257585A62';
wwv_flow_api.g_varchar2_table(26) := '30766A647946543443786B33652F6B49716C4F476F564C7777506576705948542B3030542B68577758446634414A414F557157634468627741414141415355564F524B35435949493D2921696D706F7274616E747D23746F6173742D636F6E7461696E65';
wwv_flow_api.g_varchar2_table(27) := '723E2E746F6173742D6572726F727B6261636B67726F756E642D696D6167653A75726C28646174613A696D6167652F706E673B6261736536342C6956424F5277304B47676F414141414E535568455567414141426741414141594341594141414467647A';
wwv_flow_api.g_varchar2_table(28) := '33344141414141584E535230494172733463365141414141526E51553142414143786A777638595155414141414A6345685A6377414144734D414141374441636476714751414141484F535552425645684C725A612F53674E42454D5A7A6830574B4343';
wwv_flow_api.g_varchar2_table(29) := '6C53434B6149594F45442B41414B6551514C473848577A744C43496D4272596164674964592B67494B4E596B42465377753743416F7143676B6B6F4742492F4532385064624C5A6D65444C677A5A7A637838332F7A5A3253535843316A3966722B493148';
wwv_flow_api.g_varchar2_table(30) := '71393367327978483469774D31766B6F4257416478436D707A5478666B4E325263795A4E614846496B536F31302B386B67786B584955525635484778546D467563373542325266516B707848473861416761414661307441487159466651374977653279';
wwv_flow_api.g_varchar2_table(31) := '684F446B382B4A34433779416F5254574933772F346B6C47526752346C4F3752706E392B67764D7957702B75784668382B482B41526C674E316E4A754A75514159764E6B456E774746636B31384572347133656745632F6F4F2B6D684C644B6752796864';
wwv_flow_api.g_varchar2_table(32) := '4E466961634330726C4F4362684E567A344839466E41596744427655335149696F5A6C4A464C4A74736F4859524466695A6F557949787143745270566C414E71304555346441706A727467657A504661643553313957676A6B6330684E566E754634486A';
wwv_flow_api.g_varchar2_table(33) := '56413643375172534962796C422B6F5A65336148674273716C4E714B594834386A58794A4B4D7541626979564A384B7A61423365526330706739567751346E6946727949363871694F693341626A776473666E41746B3062436A544C4A4B72366D724439';
wwv_flow_api.g_varchar2_table(34) := '673869712F532F4238316867754F4D6C51546E56794734307741636A6E6D6773434E455344726A6D653777666674503450375350344E33434A5A64767A6F4E79477132632F48574F584A47737656672B52412F6B324D432F774E36493259413250743847';
wwv_flow_api.g_varchar2_table(35) := '6B41414141415355564F524B35435949493D2921696D706F7274616E747D23746F6173742D636F6E7461696E65723E2E746F6173742D737563636573737B6261636B67726F756E642D696D6167653A75726C28646174613A696D6167652F706E673B6261';
wwv_flow_api.g_varchar2_table(36) := '736536342C6956424F5277304B47676F414141414E535568455567414141426741414141594341594141414467647A33344141414141584E535230494172733463365141414141526E51553142414143786A777638595155414141414A6345685A637741';
wwv_flow_api.g_varchar2_table(37) := '4144734D4141413744416364767147514141414473535552425645684C593241594266514D67662F2F2F3350382B2F657641496776412F467349462B426176594444574D4247726F61534D4D42694538564337415A44724946614D466E696933415A546A';
wwv_flow_api.g_varchar2_table(38) := '556773555557554441384F644148366951625145687734487947735045634B425842494334415268657834473442736A6D77655531736F49466147672F57746F465A52495A644576494D68786B43436A5849567341545636674647414373345273773045';
wwv_flow_api.g_varchar2_table(39) := '476749494833514A594A6748534152515A44725741422B6A61777A67732B5132554F343944376A6E525352476F454652494C63646D454D57474930636D304A4A325170594131524476636D7A4A455768414268442F7071724C30533043577541424B676E';
wwv_flow_api.g_varchar2_table(40) := '526B69396C4C736553376732416C7177485751534B48346F4B4C72494C7052476845514377324C6952554961346C7741414141424A52553545726B4A6767673D3D2921696D706F7274616E747D23746F6173742D636F6E7461696E65723E2E746F617374';
wwv_flow_api.g_varchar2_table(41) := '2D7761726E696E677B6261636B67726F756E642D696D6167653A75726C28646174613A696D6167652F706E673B6261736536342C6956424F5277304B47676F414141414E535568455567414141426741414141594341594141414467647A333441414141';
wwv_flow_api.g_varchar2_table(42) := '41584E535230494172733463365141414141526E51553142414143786A777638595155414141414A6345685A6377414144734D4141413744416364767147514141414759535552425645684C355A537654734E51464D62585A4749434D5947596D4A6841';
wwv_flow_api.g_varchar2_table(43) := '51494A41494359515041414369534442384169494351514A54344371514577674A76594153415143695A69596D4A6841494241544341524A792B397254736C646438734B75314D302B644C6230353776362F6C62712F32724B306D532F54524E6A396357';
wwv_flow_api.g_varchar2_table(44) := '4E414B5059494A494937674978436351353163767149442B4749455838415347344231624B3567495A466551666F4A6445584F6667583451415167376B4832413635795138376C79786232377367676B417A41754668626267314B326B67436B42316256';
wwv_flow_api.g_varchar2_table(45) := '77794952396D324C37505250496844554958674774794B77353735797A336C544E733658344A586E6A562B4C4B4D2F6D334D79646E5462744F4B496A747A3656684342713476536D336E63647244326C6B305667555853564B6A56444A584A7A696A5731';
wwv_flow_api.g_varchar2_table(46) := '5251647355374637374865387536386B6F4E5A547A384F7A35794761364A3348336C5A3078596758424B3251796D6C5757412B52576E5968736B4C427632766D452B68424D43746241374B58356472577952542F324A73715A3249766642395934625744';
wwv_flow_api.g_varchar2_table(47) := '4E4D46624A52466D4339453734536F53304371756C776A6B43302B356270635631435A384E4D656A34706A7930552B646F44517347796F31687A564A7474496A685137476E427452464E31556172556C48384633786963742B4859303772457A6F554750';
wwv_flow_api.g_varchar2_table(48) := '6C57636A52465272342F6743685A6763335A4C3264386F41414141415355564F524B35435949493D2921696D706F7274616E747D23746F6173742D636F6E7461696E65722E746F6173742D626F74746F6D2D63656E7465723E6469762C23746F6173742D';
wwv_flow_api.g_varchar2_table(49) := '636F6E7461696E65722E746F6173742D746F702D63656E7465723E6469767B77696474683A33303070783B6D617267696E3A6175746F7D23746F6173742D636F6E7461696E65722E746F6173742D626F74746F6D2D66756C6C2D77696474683E6469762C';
wwv_flow_api.g_varchar2_table(50) := '23746F6173742D636F6E7461696E65722E746F6173742D746F702D66756C6C2D77696474683E6469767B77696474683A3936253B6D617267696E3A6175746F7D2E746F6173747B6261636B67726F756E642D636F6C6F723A233033303330337D2E746F61';
wwv_flow_api.g_varchar2_table(51) := '73742D737563636573737B6261636B67726F756E642D636F6C6F723A233531613335317D2E746F6173742D6572726F727B6261636B67726F756E642D636F6C6F723A236264333632667D2E746F6173742D696E666F7B6261636B67726F756E642D636F6C';
wwv_flow_api.g_varchar2_table(52) := '6F723A233266393662347D2E746F6173742D7761726E696E677B6261636B67726F756E642D636F6C6F723A236638393430367D2E746F6173742D70726F67726573737B706F736974696F6E3A6162736F6C7574653B6C6566743A303B626F74746F6D3A30';
wwv_flow_api.g_varchar2_table(53) := '3B6865696768743A3470783B6261636B67726F756E642D636F6C6F723A233030303B6F7061636974793A2E343B2D6D732D66696C7465723A616C706861284F7061636974793D3430293B66696C7465723A616C706861286F7061636974793D3430297D40';
wwv_flow_api.g_varchar2_table(54) := '6D6564696120616C6C20616E6420286D61782D77696474683A3234307078297B23746F6173742D636F6E7461696E65723E6469767B70616464696E673A387078203870782038707820353070783B77696474683A3131656D7D23746F6173742D636F6E74';
wwv_flow_api.g_varchar2_table(55) := '61696E6572202E746F6173742D636C6F73652D627574746F6E7B72696768743A2D2E32656D3B746F703A2D2E32656D7D7D406D6564696120616C6C20616E6420286D696E2D77696474683A32343170782920616E6420286D61782D77696474683A343830';
wwv_flow_api.g_varchar2_table(56) := '7078297B23746F6173742D636F6E7461696E65723E6469767B70616464696E673A387078203870782038707820353070783B77696474683A3138656D7D23746F6173742D636F6E7461696E6572202E746F6173742D636C6F73652D627574746F6E7B7269';
wwv_flow_api.g_varchar2_table(57) := '6768743A2D2E32656D3B746F703A2D2E32656D7D7D406D6564696120616C6C20616E6420286D696E2D77696474683A34383170782920616E6420286D61782D77696474683A3736387078297B23746F6173742D636F6E7461696E65723E6469767B706164';
wwv_flow_api.g_varchar2_table(58) := '64696E673A313570782031357078203135707820353070783B77696474683A3235656D7D7D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(11159153831964537628)
,p_plugin_id=>wwv_flow_api.id(22202715987744999699)
,p_file_name=>'toastr.min.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2166756E6374696F6E2865297B65285B226A7175657279225D2C66756E6374696F6E2865297B72657475726E2066756E6374696F6E28297B66756E6374696F6E207428652C742C6E297B72657475726E2066287B747970653A4F2E6572726F722C69636F';
wwv_flow_api.g_varchar2_table(2) := '6E436C6173733A6728292E69636F6E436C61737365732E6572726F722C6D6573736167653A652C6F7074696F6E734F766572726964653A6E2C7469746C653A747D297D66756E6374696F6E206E28742C6E297B72657475726E20747C7C28743D67282929';
wwv_flow_api.g_varchar2_table(3) := '2C763D65282223222B742E636F6E7461696E65724964292C762E6C656E6774683F763A286E262628763D63287429292C76297D66756E6374696F6E206928652C742C6E297B72657475726E2066287B747970653A4F2E696E666F2C69636F6E436C617373';
wwv_flow_api.g_varchar2_table(4) := '3A6728292E69636F6E436C61737365732E696E666F2C6D6573736167653A652C6F7074696F6E734F766572726964653A6E2C7469746C653A747D297D66756E6374696F6E206F2865297B773D657D66756E6374696F6E207328652C742C6E297B72657475';
wwv_flow_api.g_varchar2_table(5) := '726E2066287B747970653A4F2E737563636573732C69636F6E436C6173733A6728292E69636F6E436C61737365732E737563636573732C6D6573736167653A652C6F7074696F6E734F766572726964653A6E2C7469746C653A747D297D66756E6374696F';
wwv_flow_api.g_varchar2_table(6) := '6E206128652C742C6E297B72657475726E2066287B747970653A4F2E7761726E696E672C69636F6E436C6173733A6728292E69636F6E436C61737365732E7761726E696E672C6D6573736167653A652C6F7074696F6E734F766572726964653A6E2C7469';
wwv_flow_api.g_varchar2_table(7) := '746C653A747D297D66756E6374696F6E20722865297B76617220743D6728293B767C7C6E2874292C6C28652C74297C7C752874297D66756E6374696F6E20642874297B76617220693D6728293B72657475726E20767C7C6E2869292C742626303D3D3D65';
wwv_flow_api.g_varchar2_table(8) := '28223A666F637573222C74292E6C656E6774683F766F696420682874293A766F696428762E6368696C6472656E28292E6C656E6774682626762E72656D6F76652829297D66756E6374696F6E20752874297B666F7228766172206E3D762E6368696C6472';
wwv_flow_api.g_varchar2_table(9) := '656E28292C693D6E2E6C656E6774682D313B693E3D303B692D2D296C2865286E5B695D292C74297D66756E6374696F6E206C28742C6E297B72657475726E20742626303D3D3D6528223A666F637573222C74292E6C656E6774683F28745B6E2E68696465';
wwv_flow_api.g_varchar2_table(10) := '4D6574686F645D287B6475726174696F6E3A6E2E686964654475726174696F6E2C656173696E673A6E2E68696465456173696E672C636F6D706C6574653A66756E6374696F6E28297B682874297D7D292C2130293A21317D66756E6374696F6E20632874';
wwv_flow_api.g_varchar2_table(11) := '297B72657475726E20763D6528223C6469762F3E22292E6174747228226964222C742E636F6E7461696E65724964292E616464436C61737328742E706F736974696F6E436C617373292E617474722822617269612D6C697665222C22706F6C6974652229';
wwv_flow_api.g_varchar2_table(12) := '2E617474722822726F6C65222C22616C65727422292C762E617070656E64546F286528742E74617267657429292C767D66756E6374696F6E207028297B72657475726E7B746170546F4469736D6973733A21302C746F617374436C6173733A22746F6173';
wwv_flow_api.g_varchar2_table(13) := '74222C636F6E7461696E657249643A22746F6173742D636F6E7461696E6572222C64656275673A21312C73686F774D6574686F643A2266616465496E222C73686F774475726174696F6E3A3330302C73686F77456173696E673A227377696E67222C6F6E';
wwv_flow_api.g_varchar2_table(14) := '53686F776E3A766F696420302C686964654D6574686F643A22666164654F7574222C686964654475726174696F6E3A3165332C68696465456173696E673A227377696E67222C6F6E48696464656E3A766F696420302C657874656E64656454696D654F75';
wwv_flow_api.g_varchar2_table(15) := '743A3165332C69636F6E436C61737365733A7B6572726F723A22746F6173742D6572726F72222C696E666F3A22746F6173742D696E666F222C737563636573733A22746F6173742D73756363657373222C7761726E696E673A22746F6173742D7761726E';
wwv_flow_api.g_varchar2_table(16) := '696E67227D2C69636F6E436C6173733A22746F6173742D696E666F222C706F736974696F6E436C6173733A22746F6173742D746F702D7269676874222C74696D654F75743A3565332C7469746C65436C6173733A22746F6173742D7469746C65222C6D65';
wwv_flow_api.g_varchar2_table(17) := '7373616765436C6173733A22746F6173742D6D657373616765222C7461726765743A22626F6479222C636C6F736548746D6C3A273C627574746F6E20747970653D22627574746F6E223E2674696D65733B3C2F627574746F6E3E272C6E65776573744F6E';
wwv_flow_api.g_varchar2_table(18) := '546F703A21302C70726576656E744475706C6963617465733A21312C70726F67726573734261723A21317D7D66756E6374696F6E206D2865297B772626772865297D66756E6374696F6E20662874297B66756E6374696F6E20692874297B72657475726E';
wwv_flow_api.g_varchar2_table(19) := '216528223A666F637573222C6C292E6C656E6774687C7C743F28636C65617254696D656F7574284F2E696E74657276616C4964292C6C5B722E686964654D6574686F645D287B6475726174696F6E3A722E686964654475726174696F6E2C656173696E67';
wwv_flow_api.g_varchar2_table(20) := '3A722E68696465456173696E672C636F6D706C6574653A66756E6374696F6E28297B68286C292C722E6F6E48696464656E26262268696464656E22213D3D622E73746174652626722E6F6E48696464656E28292C622E73746174653D2268696464656E22';
wwv_flow_api.g_varchar2_table(21) := '2C622E656E6454696D653D6E657720446174652C6D2862297D7D29293A766F696420307D66756E6374696F6E206F28297B28722E74696D654F75743E307C7C722E657874656E64656454696D654F75743E3029262628753D73657454696D656F75742869';
wwv_flow_api.g_varchar2_table(22) := '2C722E657874656E64656454696D654F7574292C4F2E6D61784869646554696D653D7061727365466C6F617428722E657874656E64656454696D654F7574292C4F2E686964654574613D286E65772044617465292E67657454696D6528292B4F2E6D6178';
wwv_flow_api.g_varchar2_table(23) := '4869646554696D65297D66756E6374696F6E207328297B636C65617254696D656F75742875292C4F2E686964654574613D302C6C2E73746F702821302C2130295B722E73686F774D6574686F645D287B6475726174696F6E3A722E73686F774475726174';
wwv_flow_api.g_varchar2_table(24) := '696F6E2C656173696E673A722E73686F77456173696E677D297D66756E6374696F6E206128297B76617220653D284F2E686964654574612D286E65772044617465292E67657454696D652829292F4F2E6D61784869646554696D652A3130303B662E7769';
wwv_flow_api.g_varchar2_table(25) := '64746828652B222522297D76617220723D6728292C643D742E69636F6E436C6173737C7C722E69636F6E436C6173733B69662822756E646566696E656422213D747970656F6620742E6F7074696F6E734F76657272696465262628723D652E657874656E';
wwv_flow_api.g_varchar2_table(26) := '6428722C742E6F7074696F6E734F76657272696465292C643D742E6F7074696F6E734F766572726964652E69636F6E436C6173737C7C64292C722E70726576656E744475706C696361746573297B696628742E6D6573736167653D3D3D43297265747572';
wwv_flow_api.g_varchar2_table(27) := '6E3B433D742E6D6573736167657D542B2B2C763D6E28722C2130293B76617220753D6E756C6C2C6C3D6528223C6469762F3E22292C633D6528223C6469762F3E22292C703D6528223C6469762F3E22292C663D6528223C6469762F3E22292C773D652872';
wwv_flow_api.g_varchar2_table(28) := '2E636C6F736548746D6C292C4F3D7B696E74657276616C49643A6E756C6C2C686964654574613A6E756C6C2C6D61784869646554696D653A6E756C6C7D2C623D7B746F61737449643A542C73746174653A2276697369626C65222C737461727454696D65';
wwv_flow_api.g_varchar2_table(29) := '3A6E657720446174652C6F7074696F6E733A722C6D61703A747D3B72657475726E20742E69636F6E436C61737326266C2E616464436C61737328722E746F617374436C617373292E616464436C6173732864292C742E7469746C65262628632E61707065';
wwv_flow_api.g_varchar2_table(30) := '6E6428742E7469746C65292E616464436C61737328722E7469746C65436C617373292C6C2E617070656E64286329292C742E6D657373616765262628702E617070656E6428742E6D657373616765292E616464436C61737328722E6D657373616765436C';
wwv_flow_api.g_varchar2_table(31) := '617373292C6C2E617070656E64287029292C722E636C6F7365427574746F6E262628772E616464436C6173732822746F6173742D636C6F73652D627574746F6E22292E617474722822726F6C65222C22627574746F6E22292C6C2E70726570656E642877';
wwv_flow_api.g_varchar2_table(32) := '29292C722E70726F6772657373426172262628662E616464436C6173732822746F6173742D70726F677265737322292C6C2E70726570656E64286629292C6C2E6869646528292C722E6E65776573744F6E546F703F762E70726570656E64286C293A762E';
wwv_flow_api.g_varchar2_table(33) := '617070656E64286C292C6C5B722E73686F774D6574686F645D287B6475726174696F6E3A722E73686F774475726174696F6E2C656173696E673A722E73686F77456173696E672C636F6D706C6574653A722E6F6E53686F776E7D292C722E74696D654F75';
wwv_flow_api.g_varchar2_table(34) := '743E30262628753D73657454696D656F757428692C722E74696D654F7574292C4F2E6D61784869646554696D653D7061727365466C6F617428722E74696D654F7574292C4F2E686964654574613D286E65772044617465292E67657454696D6528292B4F';
wwv_flow_api.g_varchar2_table(35) := '2E6D61784869646554696D652C722E70726F67726573734261722626284F2E696E74657276616C49643D736574496E74657276616C28612C31302929292C6C2E686F76657228732C6F292C21722E6F6E636C69636B2626722E746170546F4469736D6973';
wwv_flow_api.g_varchar2_table(36) := '7326266C2E636C69636B2869292C722E636C6F7365427574746F6E2626772626772E636C69636B2866756E6374696F6E2865297B652E73746F7050726F7061676174696F6E3F652E73746F7050726F7061676174696F6E28293A766F69642030213D3D65';
wwv_flow_api.g_varchar2_table(37) := '2E63616E63656C427562626C652626652E63616E63656C427562626C65213D3D2130262628652E63616E63656C427562626C653D2130292C69282130297D292C722E6F6E636C69636B26266C2E636C69636B2866756E6374696F6E28297B722E6F6E636C';
wwv_flow_api.g_varchar2_table(38) := '69636B28292C6928297D292C6D2862292C722E64656275672626636F6E736F6C652626636F6E736F6C652E6C6F672862292C6C7D66756E6374696F6E206728297B72657475726E20652E657874656E64287B7D2C7028292C622E6F7074696F6E73297D66';
wwv_flow_api.g_varchar2_table(39) := '756E6374696F6E20682865297B767C7C28763D6E2829292C652E697328223A76697369626C6522297C7C28652E72656D6F766528292C653D6E756C6C2C303D3D3D762E6368696C6472656E28292E6C656E677468262628762E72656D6F766528292C433D';
wwv_flow_api.g_varchar2_table(40) := '766F6964203029297D76617220762C772C432C543D302C4F3D7B6572726F723A226572726F72222C696E666F3A22696E666F222C737563636573733A2273756363657373222C7761726E696E673A227761726E696E67227D2C623D7B636C6561723A722C';
wwv_flow_api.g_varchar2_table(41) := '72656D6F76653A642C6572726F723A742C676574436F6E7461696E65723A6E2C696E666F3A692C6F7074696F6E733A7B7D2C7375627363726962653A6F2C737563636573733A732C76657273696F6E3A22322E312E30222C7761726E696E673A617D3B72';
wwv_flow_api.g_varchar2_table(42) := '657475726E20627D28297D297D282266756E6374696F6E223D3D747970656F6620646566696E652626646566696E652E616D643F646566696E653A66756E6374696F6E28652C74297B22756E646566696E656422213D747970656F66206D6F64756C6526';
wwv_flow_api.g_varchar2_table(43) := '266D6F64756C652E6578706F7274733F6D6F64756C652E6578706F7274733D74287265717569726528226A71756572792229293A77696E646F772E746F617374723D742877696E646F772E6A5175657279297D293B0A2F2F2320736F757263654D617070';
wwv_flow_api.g_varchar2_table(44) := '696E6755524C3D746F617374722E6A732E6D61700A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(11159154155299538356)
,p_plugin_id=>wwv_flow_api.id(22202715987744999699)
,p_file_name=>'toastr.min.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false), p_is_component_import => true);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
