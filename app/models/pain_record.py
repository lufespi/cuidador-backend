from datetime import datetime
from app.extensions import db


class PainRecord(db.Model):
    """Pain record model"""
    __tablename__ = 'pain_records'
    
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False, index=True)
    body_part = db.Column(db.String(50), nullable=False)
    intensity = db.Column(db.Integer, nullable=False)  # 1-10
    description = db.Column(db.Text, nullable=True)
    symptoms = db.Column(db.JSON, nullable=True)  # List of symptoms
    timestamp = db.Column(db.DateTime, default=datetime.utcnow, nullable=False, index=True)
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)
    
    # Relationships
    user = db.relationship('User', back_populates='pain_records')
    
    # Indexes
    __table_args__ = (
        db.Index('idx_user_timestamp', 'user_id', 'timestamp'),
    )
    
    def __repr__(self):
        return f'<PainRecord {self.id} - {self.body_part} - Intensity: {self.intensity}>'
    
    @staticmethod
    def validate_intensity(intensity):
        """Validate intensity is between 1-10"""
        return 1 <= intensity <= 10
    
    @staticmethod
    def validate_body_part(body_part):
        """Validate body part is in allowed list"""
        valid_parts = [
            'head', 'torso',
            'left_arm', 'right_arm',
            'left_hand', 'right_hand',
            'left_leg', 'right_leg',
            'left_foot', 'right_foot'
        ]
        return body_part in valid_parts
    
    def to_dict(self):
        """Convert to dictionary"""
        return {
            'id': self.id,
            'user_id': self.user_id,
            'body_part': self.body_part,
            'intensity': self.intensity,
            'description': self.description,
            'symptoms': self.symptoms,
            'timestamp': self.timestamp.isoformat(),
            'created_at': self.created_at.isoformat(),
            'updated_at': self.updated_at.isoformat()
        }
