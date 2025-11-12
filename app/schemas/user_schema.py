from marshmallow import Schema, fields, validate


class UserPreferencesSchema(Schema):
    """Schema for user preferences"""
    language = fields.Str(
        required=False,
        validate=validate.OneOf(['pt', 'en', 'es'])
    )
    theme = fields.Str(
        required=False,
        validate=validate.OneOf(['light', 'dark', 'system'])
    )
    notifications_enabled = fields.Bool(required=False)
    notification_time = fields.Time(required=False, allow_none=True)
