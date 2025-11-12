from marshmallow import Schema, fields, validate, validates, ValidationError
from email_validator import validate_email as email_validate


class RegisterSchema(Schema):
    """Schema for user registration"""
    email = fields.Email(required=True)
    password = fields.Str(required=True, validate=validate.Length(min=6))
    first_name = fields.Str(required=True, validate=validate.Length(min=2, max=100))
    last_name = fields.Str(required=True, validate=validate.Length(min=2, max=100))
    birth_date = fields.Date(required=False, allow_none=True)
    phone = fields.Str(required=False, allow_none=True, validate=validate.Length(max=20))
    gender = fields.Str(
        required=False,
        allow_none=True,
        validate=validate.OneOf(['male', 'female', 'other'])
    )
    
    @validates('email')
    def validate_email(self, value):
        """Validate email format"""
        try:
            email_validate(value)
        except Exception:
            raise ValidationError('Invalid email address')


class LoginSchema(Schema):
    """Schema for user login"""
    email = fields.Email(required=True)
    password = fields.Str(required=True)


class UserUpdateSchema(Schema):
    """Schema for updating user profile"""
    first_name = fields.Str(required=False, validate=validate.Length(min=2, max=100))
    last_name = fields.Str(required=False, validate=validate.Length(min=2, max=100))
    birth_date = fields.Date(required=False, allow_none=True)
    phone = fields.Str(required=False, allow_none=True, validate=validate.Length(max=20))
    gender = fields.Str(
        required=False,
        allow_none=True,
        validate=validate.OneOf(['male', 'female', 'other'])
    )
