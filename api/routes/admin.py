"""
Rotas administrativas para gerenciamento de usuários
"""
from flask import Blueprint, request, jsonify
from api.middleware.auth import admin_required, token_required
from api.db import get_db_connection
from datetime import datetime
import bcrypt
from reportlab.lib.pagesizes import letter
from reportlab.lib import colors
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.platypus import SimpleDocTemplate, Table, TableStyle, Paragraph, Spacer, PageBreak
from reportlab.lib.units import inch
import io
import base64

admin_bp = Blueprint('admin', __name__)


@admin_bp.route('/auth/me', methods=['GET'])
@token_required
def get_current_user():
    """Retorna informações do usuário logado, incluindo is_admin"""
    try:
        user_id = request.user_id
        
        conn = get_db_connection()
        cursor = conn.cursor()
        
        cursor.execute('''
            SELECT id, nome, email, telefone, data_nascimento, sexo, 
                   diagnostico, comorbidades, created_at, is_admin
            FROM users 
            WHERE id = %s
        ''', (user_id,))
        
        user = cursor.fetchone()
        cursor.close()
        conn.close()
        
        if not user:
            return jsonify({'error': 'Usuário não encontrado'}), 404
        
        # Formata data de nascimento
        if user.get('data_nascimento'):
            if hasattr(user['data_nascimento'], 'strftime'):
                user['data_nascimento'] = user['data_nascimento'].strftime('%Y-%m-%d')
            else:
                data_str = str(user['data_nascimento'])
                user['data_nascimento'] = None if data_str.startswith('0000-00-00') else data_str
        
        # Formata created_at
        if user.get('created_at'):
            if hasattr(user['created_at'], 'strftime'):
                user['created_at'] = user['created_at'].strftime('%Y-%m-%d %H:%M:%S')
            else:
                data_str = str(user['created_at'])
                user['created_at'] = None if data_str.startswith('0000-00-00') else data_str
        
        return jsonify({'user': user}), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@admin_bp.route('/admin/users', methods=['GET'])
@admin_required
def get_all_users():
    """Lista todos os usuários (apenas admin)"""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        # Busca opcional por nome ou email
        search = request.args.get('search', '')
        
        if search:
            query = '''
                SELECT id, nome, email, telefone, data_nascimento, sexo,
                       diagnostico, comorbidades, created_at, is_admin
                FROM users 
                WHERE nome LIKE %s OR email LIKE %s
                ORDER BY created_at DESC
            '''
            cursor.execute(query, (f'%{search}%', f'%{search}%'))
        else:
            query = '''
                SELECT id, nome, email, telefone, data_nascimento, sexo,
                       diagnostico, comorbidades, created_at, is_admin
                FROM users 
                ORDER BY created_at DESC
            '''
            cursor.execute(query)
        
        users = cursor.fetchall()
        cursor.close()
        conn.close()
        
        # Formata datas
        for user in users:
            if user.get('data_nascimento'):
                if hasattr(user['data_nascimento'], 'strftime'):
                    user['data_nascimento'] = user['data_nascimento'].strftime('%Y-%m-%d')
                else:
                    data_str = str(user['data_nascimento'])
                    user['data_nascimento'] = None if data_str.startswith('0000-00-00') else data_str
            if user.get('created_at'):
                if hasattr(user['created_at'], 'strftime'):
                    user['created_at'] = user['created_at'].strftime('%Y-%m-%d %H:%M:%S')
                else:
                    data_str = str(user['created_at'])
                    user['created_at'] = None if data_str.startswith('0000-00-00') else data_str
        
        return jsonify({'users': users}), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@admin_bp.route('/admin/users/<int:user_id>', methods=['GET'])
@admin_required
def get_user_details(user_id):
    """Retorna detalhes de um usuário específico (apenas admin)"""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        cursor.execute('''
            SELECT id, nome, email, telefone, data_nascimento, sexo,
                   diagnostico, comorbidades, created_at, is_admin
            FROM users 
            WHERE id = %s
        ''', (user_id,))
        
        user = cursor.fetchone()
        cursor.close()
        conn.close()
        
        if not user:
            return jsonify({'error': 'Usuário não encontrado'}), 404
        
        # Formata datas
        if user.get('data_nascimento'):
            if hasattr(user['data_nascimento'], 'strftime'):
                user['data_nascimento'] = user['data_nascimento'].strftime('%Y-%m-%d')
            else:
                data_str = str(user['data_nascimento'])
                user['data_nascimento'] = None if data_str.startswith('0000-00-00') else data_str
        if user.get('created_at'):
            if hasattr(user['created_at'], 'strftime'):
                user['created_at'] = user['created_at'].strftime('%Y-%m-%d %H:%M:%S')
            else:
                data_str = str(user['created_at'])
                user['created_at'] = None if data_str.startswith('0000-00-00') else data_str
        
        return jsonify({'user': user}), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@admin_bp.route('/admin/users/<int:user_id>/password', methods=['PUT'])
@admin_required
def reset_user_password(user_id):
    """Redefine a senha de um usuário (apenas admin)"""
    try:
        data = request.get_json()
        
        if 'new_password' not in data:
            return jsonify({'error': 'Nova senha não fornecida'}), 400
        
        new_password = data['new_password']
        
        if len(new_password) < 6:
            return jsonify({'error': 'Senha deve ter no mínimo 6 caracteres'}), 400
        
        # Hash da nova senha
        hashed_password = bcrypt.hashpw(new_password.encode('utf-8'), bcrypt.gensalt())
        
        conn = get_db_connection()
        cursor = conn.cursor()
        
        # Verifica se usuário existe
        cursor.execute('SELECT id FROM users WHERE id = %s', (user_id,))
        if not cursor.fetchone():
            cursor.close()
            conn.close()
            return jsonify({'error': 'Usuário não encontrado'}), 404
        
        # Atualiza senha
        cursor.execute('''
            UPDATE users 
            SET password_hash = %s
            WHERE id = %s
        ''', (hashed_password, user_id))
        
        conn.commit()
        cursor.close()
        conn.close()
        
        return jsonify({'message': 'Senha redefinida com sucesso'}), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@admin_bp.route('/admin/users/<int:user_id>/pain-records', methods=['GET'])
@admin_required
def get_user_pain_records(user_id):
    """Retorna registros de dor de um usuário (apenas admin)"""
    try:
        limit = request.args.get('limit', 10, type=int)
        
        conn = get_db_connection()
        cursor = conn.cursor()
        
        # Verifica se usuário existe
        cursor.execute('SELECT id FROM users WHERE id = %s', (user_id,))
        if not cursor.fetchone():
            cursor.close()
            conn.close()
            return jsonify({'error': 'Usuário não encontrado'}), 404
        
        # Busca registros de dor
        cursor.execute('''
            SELECT intensidade, descricao, body_parts, data_registro
            FROM pain_records
            WHERE user_id = %s
            ORDER BY data_registro DESC
            LIMIT %s
        ''', (user_id, limit))
        
        records = cursor.fetchall()
        cursor.close()
        conn.close()
        
        # Formata datas
        for record in records:
            if record.get('data_registro'):
                if hasattr(record['data_registro'], 'strftime'):
                    record['data_registro'] = record['data_registro'].strftime('%Y-%m-%d %H:%M:%S')
                else:
                    data_str = str(record['data_registro'])
                    record['data_registro'] = None if data_str.startswith('0000-00-00') else data_str
        
        return jsonify({'records': records}), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@admin_bp.route('/admin/users/<int:user_id>/export', methods=['GET'])
@admin_required
def export_user_report(user_id):
    """Exporta relatório de dados do usuário em PDF (apenas admin)"""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        # Busca dados do usuário
        cursor.execute('''
            SELECT id, nome, email, telefone, data_nascimento, sexo,
                   diagnostico, comorbidades, created_at
            FROM users 
            WHERE id = %s
        ''', (user_id,))
        
        user = cursor.fetchone()
        
        if not user:
            cursor.close()
            conn.close()
            return jsonify({'error': 'Usuário não encontrado'}), 404
        
        # Busca registros de dor dos últimos 90 dias
        cursor.execute('''
            SELECT intensidade, descricao, body_parts, data_registro
            FROM pain_records
            WHERE user_id = %s 
            AND data_registro >= DATE_SUB(NOW(), INTERVAL 90 DAY)
            ORDER BY data_registro DESC
        ''', (user_id,))
        
        pain_records = cursor.fetchall()
        cursor.close()
        conn.close()
        
        # Gera PDF em memória
        buffer = io.BytesIO()
        doc = SimpleDocTemplate(buffer, pagesize=letter)
        elements = []
        styles = getSampleStyleSheet()
        
        # Título
        title_style = ParagraphStyle(
            'CustomTitle',
            parent=styles['Heading1'],
            fontSize=24,
            textColor=colors.HexColor('#28BDBD'),
            spaceAfter=30,
        )
        elements.append(Paragraph(f"Relatório do Usuário: {user['nome']}", title_style))
        elements.append(Spacer(1, 0.2*inch))
        
        # Informações pessoais
        elements.append(Paragraph("Dados Pessoais", styles['Heading2']))
        # Formata datas para exibição
        data_nascimento_str = 'Não informado'
        if user.get('data_nascimento'):
            if hasattr(user['data_nascimento'], 'strftime'):
                data_nascimento_str = user['data_nascimento'].strftime('%d/%m/%Y')
            else:
                data_nascimento_str = str(user['data_nascimento'])
        
        created_at_str = 'Não informado'
        if user.get('created_at'):
            if hasattr(user['created_at'], 'strftime'):
                created_at_str = user['created_at'].strftime('%d/%m/%Y %H:%M')
            else:
                created_at_str = str(user['created_at'])
        
        personal_data = [
            ['Email:', user['email']],
            ['Telefone:', user.get('telefone') or 'Não informado'],
            ['Data de Nascimento:', data_nascimento_str],
            ['Sexo:', user.get('sexo') or 'Não informado'],
            ['Diagnóstico:', user.get('diagnostico') or 'Não informado'],
            ['Comorbidades:', user.get('comorbidades') or 'Nenhuma'],
            ['Data de Cadastro:', created_at_str],
        ]
        
        personal_table = Table(personal_data, colWidths=[2*inch, 4*inch])
        personal_table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (0, -1), colors.HexColor('#F5F5F5')),
            ('TEXTCOLOR', (0, 0), (-1, -1), colors.black),
            ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
            ('FONTNAME', (0, 0), (0, -1), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, -1), 10),
            ('BOTTOMPADDING', (0, 0), (-1, -1), 12),
            ('GRID', (0, 0), (-1, -1), 1, colors.grey),
        ]))
        elements.append(personal_table)
        elements.append(Spacer(1, 0.3*inch))
        
        # Histórico de dor
        elements.append(Paragraph(f"Histórico de Dor (Últimos 90 dias) - {len(pain_records)} registros", styles['Heading2']))
        elements.append(Spacer(1, 0.1*inch))
        
        if pain_records:
            pain_data = [['Data', 'Intensidade', 'Descrição']]
            for record in pain_records[:50]:  # Limita a 50 registros mais recentes
                pain_data.append([
                    record['data_registro'].strftime('%d/%m/%Y %H:%M'),
                    str(record['intensidade']),
                    record['descricao'][:50] + '...' if record['descricao'] and len(record['descricao']) > 50 else (record['descricao'] or 'Sem descrição')
                ])
            
            pain_table = Table(pain_data, colWidths=[1.5*inch, 1*inch, 3.5*inch])
            pain_table.setStyle(TableStyle([
                ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor('#28BDBD')),
                ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
                ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
                ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
                ('FONTSIZE', (0, 0), (-1, -1), 9),
                ('BOTTOMPADDING', (0, 0), (-1, 0), 12),
                ('BACKGROUND', (0, 1), (-1, -1), colors.beige),
                ('GRID', (0, 0), (-1, -1), 1, colors.grey),
            ]))
            elements.append(pain_table)
        else:
            elements.append(Paragraph("Nenhum registro de dor encontrado nos últimos 90 dias.", styles['Normal']))
        
        # Rodapé
        elements.append(Spacer(1, 0.5*inch))
        footer_text = f"Relatório gerado em: {datetime.now().strftime('%d/%m/%Y %H:%M:%S')}"
        elements.append(Paragraph(footer_text, styles['Normal']))
        
        # Gera o PDF
        doc.build(elements)
        
        # Retorna PDF em base64
        pdf_data = buffer.getvalue()
        buffer.close()
        
        pdf_base64 = base64.b64encode(pdf_data).decode('utf-8')
        
        return jsonify({
            'pdf': pdf_base64,
            'filename': f'relatorio_{user["nome"].replace(" ", "_")}_{datetime.now().strftime("%Y%m%d")}.pdf'
        }), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500
