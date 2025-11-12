from datetime import datetime, date


def paginate_query(query, page=1, per_page=20):
    """Paginate SQLAlchemy query"""
    pagination = query.paginate(
        page=page,
        per_page=per_page,
        error_out=False
    )
    
    return {
        'items': [item.to_dict() for item in pagination.items],
        'total': pagination.total,
        'page': pagination.page,
        'per_page': pagination.per_page,
        'pages': pagination.pages
    }


def format_datetime(dt):
    """Format datetime to ISO string"""
    if dt is None:
        return None
    if isinstance(dt, datetime):
        return dt.isoformat()
    if isinstance(dt, date):
        return dt.isoformat()
    return str(dt)


def parse_date(date_str):
    """Parse date string to date object"""
    if not date_str:
        return None
    try:
        return datetime.fromisoformat(date_str).date()
    except (ValueError, AttributeError):
        return None


def success_response(data=None, message=None, status_code=200):
    """Format success response"""
    response = {}
    if message:
        response['message'] = message
    if data is not None:
        response['data'] = data
    return response, status_code


def error_response(error, message=None, status_code=400):
    """Format error response"""
    response = {'error': error}
    if message:
        response['message'] = message
    return response, status_code
