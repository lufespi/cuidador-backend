from datetime import datetime, time
from app.extensions import db


class UserPreferences(db.Model):
    """User preferences model"""
    __tablename__ = 'user_preferences'
    
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), unique=True, nullable=False)
    language = db.Column(db.String(10), default='pt', nullable=False)  # 'pt', 'en', 'es'
    theme = db.Column(db.String(10), default='light', nullable=False)  # 'light', 'dark', 'system'
    notifications_enabled = db.Column(db.Boolean, default=True, nullable=False)
    notification_time = db.Column(db.Time, nullable=True)  # Daily reminder time
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)
    
    # Relationships
    user = db.relationship('User', back_populates='preferences')
    
    def __repr__(self):
        return f'<UserPreferences user_id={self.user_id} language={self.language}>'
    
    @staticmethod
    def validate_language(language):
        """Validate language is supported"""
        valid_languages = ['pt', 'en', 'es']
        return language in valid_languages
    
    @staticmethod
    def validate_theme(theme):
        """Validate theme is valid"""
        valid_themes = ['light', 'dark', 'system']
        return theme in valid_themes
    
    def to_dict(self):
        """Convert to dictionary"""
        return {
            'id': self.id,
            'user_id': self.user_id,
            'language': self.language,
            'theme': self.theme,
            'notifications_enabled': self.notifications_enabled,
            'notification_time': self.notification_time.isoformat() if self.notification_time else None,
            'created_at': self.created_at.isoformat(),
            'updated_at': self.updated_at.isoformat()
        }
