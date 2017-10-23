/*-------------------------------------
 * toastr Functions
 * Version: 1.0.1 (24.10.2017)
 * Author:  Daniel Hochleitner
 *-------------------------------------
*/
FUNCTION render_toastr(p_dynamic_action IN apex_plugin.t_dynamic_action,
                       p_plugin         IN apex_plugin.t_plugin)
  RETURN apex_plugin.t_dynamic_action_render_result IS
  --
  l_toastr_type        VARCHAR2(100) := p_dynamic_action.attribute_01;
  l_text               VARCHAR2(500) := p_dynamic_action.attribute_02;
  l_position_class     VARCHAR2(100) := p_dynamic_action.attribute_03;
  l_close_btn          VARCHAR2(50) := p_dynamic_action.attribute_04;
  l_newest_ontop       VARCHAR2(50) := p_dynamic_action.attribute_05;
  l_progress_bar       VARCHAR2(50) := p_dynamic_action.attribute_06;
  l_prevent_duplicates VARCHAR2(50) := p_dynamic_action.attribute_07;
  l_show_duration      VARCHAR2(50) := p_dynamic_action.attribute_08;
  l_hide_duration      VARCHAR2(50) := p_dynamic_action.attribute_09;
  l_timeout            VARCHAR2(50) := p_dynamic_action.attribute_10;
  l_extended_timeout   VARCHAR2(50) := p_dynamic_action.attribute_11;
  --
  l_result apex_plugin.t_dynamic_action_render_result;
  --
  l_toastr_options_string VARCHAR2(4000);
  l_toastr_type_string    VARCHAR2(2000);
BEGIN
  -- Debug
  IF apex_application.g_debug THEN
    apex_plugin_util.debug_dynamic_action(p_plugin         => p_plugin,
                                          p_dynamic_action => p_dynamic_action);
  END IF;
  --
  -- Escaping
  l_text := apex_escape.json(l_text);
  --
  -- toastr CSS
  apex_css.add_file(p_name      => 'toastr.min',
                    p_directory => p_plugin.file_prefix);
  --
  -- toastr JS
  apex_javascript.add_library(p_name           => 'toastr.min',
                              p_directory      => p_plugin.file_prefix,
                              p_version        => NULL,
                              p_skip_extension => FALSE);
  --
  -- toastr options
  l_toastr_options_string := 'toastr.options = { ' ||
                             apex_javascript.add_attribute(p_name      => 'closeButton',
                                                           p_value     => l_close_btn, -- true/false
                                                           p_add_comma => TRUE) ||
                             apex_javascript.add_attribute(p_name      => 'newestOnTop',
                                                           p_value     => l_newest_ontop, -- true/false
                                                           p_add_comma => TRUE) ||
                             apex_javascript.add_attribute(p_name      => 'progressBar',
                                                           p_value     => l_progress_bar, -- true/false
                                                           p_add_comma => TRUE) ||
                             apex_javascript.add_attribute(p_name      => 'positionClass',
                                                           p_value     => l_position_class, -- CSS class
                                                           p_add_comma => TRUE) ||
                             apex_javascript.add_attribute(p_name      => 'preventDuplicates',
                                                           p_value     => l_prevent_duplicates, -- true/false
                                                           p_add_comma => TRUE) ||
                             apex_javascript.add_attribute(p_name      => 'showDuration',
                                                           p_value     => l_show_duration, -- number time ms
                                                           p_add_comma => TRUE) ||
                             apex_javascript.add_attribute(p_name      => 'hideDuration',
                                                           p_value     => l_hide_duration, -- number time ms
                                                           p_add_comma => TRUE) ||
                             apex_javascript.add_attribute(p_name      => 'timeOut',
                                                           p_value     => l_timeout, -- number time ms
                                                           p_add_comma => TRUE) ||
                             apex_javascript.add_attribute(p_name      => 'extendedTimeOut',
                                                           p_value     => l_extended_timeout, -- number time ms
                                                           p_add_comma => TRUE) ||
                             apex_javascript.add_attribute(p_name      => 'showEasing',
                                                           p_value     => 'swing',
                                                           p_add_comma => TRUE) ||
                             apex_javascript.add_attribute(p_name      => 'hideEasing',
                                                           p_value     => 'linear',
                                                           p_add_comma => TRUE) ||
                             apex_javascript.add_attribute(p_name      => 'showMethod',
                                                           p_value     => 'fadeIn',
                                                           p_add_comma => TRUE) ||
                             apex_javascript.add_attribute(p_name      => 'hideMethod',
                                                           p_value     => 'fadeOut',
                                                           p_add_comma => FALSE) || '} ';
  -- Replace true/false quotes
  l_toastr_options_string := REPLACE(REPLACE(l_toastr_options_string,
                                             '"true"',
                                             'true'),
                                     '"false"',
                                     'false');
  -- 
  -- toastr text per type
  IF l_toastr_type = 'info' THEN
    l_toastr_type_string := 'toastr.info("' || l_text || '");';
  ELSIF l_toastr_type = 'success' THEN
    l_toastr_type_string := 'toastr.success("' || l_text || '");';
  ELSIF l_toastr_type = 'warning' THEN
    l_toastr_type_string := 'toastr.warning("' || l_text || '");';
  ELSIF l_toastr_type = 'error' THEN
    l_toastr_type_string := 'toastr.error("' || l_text || '");';
  END IF;
  --
  -- function per DA that calls options + type
  apex_javascript.add_inline_code(p_code => 'function call_toastr_' ||
                                            p_dynamic_action.id || '() { ' ||
                                            l_toastr_options_string ||
                                            chr(10) || l_toastr_type_string ||
                                            chr(10) || ' }');
  --
  l_result.javascript_function := 'function(){call_toastr_' ||
                                  p_dynamic_action.id || '();}';
  l_result.attribute_01        := l_toastr_type;
  l_result.attribute_02        := l_text;
  l_result.attribute_03        := l_position_class;
  l_result.attribute_04        := l_close_btn;
  l_result.attribute_05        := l_newest_ontop;
  l_result.attribute_06        := l_progress_bar;
  l_result.attribute_07        := l_prevent_duplicates;
  l_result.attribute_08        := l_show_duration;
  l_result.attribute_09        := l_hide_duration;
  l_result.attribute_10        := l_timeout;
  l_result.attribute_11        := l_extended_timeout;
  --
  RETURN l_result;
  --
END render_toastr;