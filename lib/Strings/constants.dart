const int birthday_page_idx = 0;
const int category_preference_page_idx = 1;
const int gender_page_idx = 2;
const int preference_page_idx = 3;
const int location_page_idx = 4;

//Auth error codes
const String auth_invalid_email_error_code = "ERROR : Your email is invalid, check and try again.";
const String auth_wrong_password_error_code = "ERROR : Your email or password is incorrect.";
const String auth_no_user_error_code = "ERROR : No account exists with this email.";
const String auth_user_diabled_error_code = "ERROR : Your account is disabled. Contact support or try again.";
const String auth_too_many_request_error_code = "ERROR : too many attempts... try again later...";
const String auth_operation_not_allowed_error_code = "ERROR : Nice try, but that's not allowed :/";
const String auth_email_exists_error_code = "ERROR : An account with this email already exists.\nLogin or use a different email.";

//TAGS FOR EVENTS AND NAV ARGS
const String CREATE_LITUATION_TAG = 'create';
//DB Constants
const String db_users_collection = 'users';
const String db_lituations_categories_collection = 'users_lituations';
const String db_user_lituations_collection = 'users_lituations';
const String db_lituations_collection = 'lituations';
const String db_vibed_collection = 'vibed';
const String db_vibing_collection = 'vibing';
const String db_user_vibe_collection = 'userVibe';
const String db_user_status_collection = 'status';
const String db_user_settings_collection = 'users_settings';
const String db_user_activity_collection = 'users_activity';
const String db_user_setting_vibe = 'vibe_visibility';
const String db_user_setting_lituation = 'lituation_visibility';
const String db_user_setting_activity = 'activity_visibility';
const String db_user_setting_location = 'location_visibility';
const String db_user_setting_invitation_notifications = 'invitation_notifications';
const String db_user_setting_lituation_notifications = 'lituation_notifications';
const String db_user_setting_general_notifications = 'general_notifications';
const String db_user_setting_chat_notifications = 'chat_notifications';
const String db_user_setting_vibe_notifications = 'vibe_notifications';
const String db_user_setting_adult_lituations = 'adult_lituations';
const String db_user_setting_theme = 'theme';
String logo = 'assets/images/litlogo.png';