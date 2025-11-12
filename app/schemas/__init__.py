from app.schemas.auth_schema import RegisterSchema, LoginSchema, UserUpdateSchema
from app.schemas.pain_schema import (
    PainRecordSchema,
    PainRecordUpdateSchema,
    PainRecordQuerySchema,
    StatisticsQuerySchema
)
from app.schemas.user_schema import UserPreferencesSchema

__all__ = [
    'RegisterSchema',
    'LoginSchema',
    'UserUpdateSchema',
    'PainRecordSchema',
    'PainRecordUpdateSchema',
    'PainRecordQuerySchema',
    'StatisticsQuerySchema',
    'UserPreferencesSchema'
]
