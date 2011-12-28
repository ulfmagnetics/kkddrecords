require "./app/middleware/flash_session_cookie"

Killkilldiedie::Application.config.session_store :active_record_store

Rails.application.config.middleware.insert_before(ActiveRecord::SessionStore, Killkilldiedie::Middleware::FlashSessionCookie)