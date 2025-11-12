from marshmallow import Schema, fields, validate, validates, ValidationError
from datetime import datetime


class PainRecordSchema(Schema):
    """Schema for pain record"""
    body_part = fields.Str(
        required=True,
        validate=validate.OneOf([
            'head', 'torso',
            'left_arm', 'right_arm',
            'left_hand', 'right_hand',
            'left_leg', 'right_leg',
            'left_foot', 'right_foot'
        ])
    )
    intensity = fields.Int(required=True, validate=validate.Range(min=1, max=10))
    description = fields.Str(required=False, allow_none=True)
    symptoms = fields.List(fields.Str(), required=False, allow_none=True)
    timestamp = fields.DateTime(required=False, allow_none=True)
    
    @validates('timestamp')
    def validate_timestamp(self, value):
        """Validate timestamp is not in the future"""
        if value and value > datetime.utcnow():
            raise ValidationError('Timestamp cannot be in the future')


class PainRecordUpdateSchema(Schema):
    """Schema for updating pain record"""
    body_part = fields.Str(
        required=False,
        validate=validate.OneOf([
            'head', 'torso',
            'left_arm', 'right_arm',
            'left_hand', 'right_hand',
            'left_leg', 'right_leg',
            'left_foot', 'right_foot'
        ])
    )
    intensity = fields.Int(required=False, validate=validate.Range(min=1, max=10))
    description = fields.Str(required=False, allow_none=True)
    symptoms = fields.List(fields.Str(), required=False, allow_none=True)
    timestamp = fields.DateTime(required=False, allow_none=True)


class PainRecordQuerySchema(Schema):
    """Schema for querying pain records"""
    page = fields.Int(missing=1, validate=validate.Range(min=1))
    per_page = fields.Int(missing=20, validate=validate.Range(min=1, max=100))
    start_date = fields.Date(required=False, allow_none=True)
    end_date = fields.Date(required=False, allow_none=True)
    body_part = fields.Str(required=False, allow_none=True)
    min_intensity = fields.Int(required=False, validate=validate.Range(min=1, max=10))
    max_intensity = fields.Int(required=False, validate=validate.Range(min=1, max=10))


class StatisticsQuerySchema(Schema):
    """Schema for statistics query"""
    start_date = fields.Date(required=False, allow_none=True)
    end_date = fields.Date(required=False, allow_none=True)
