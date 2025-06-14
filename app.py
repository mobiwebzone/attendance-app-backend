from flask import Flask, jsonify, request
from flask_cors import CORS
import pyodbc
from config import Config

app = Flask(__name__)
CORS(app, resources={r"/api/*": {"origins": "*"}})

def get_db_connection():
    return pyodbc.connect(Config.CONNECTION_STRING)

@app.route('/api/schools', methods=['GET'], strict_slashes=False)
def get_schools():
    try:
        with get_db_connection() as conn:
            cursor = conn.cursor()
            cursor.execute("SELECT SCHOOL_ID, SCHOOL_NAME FROM SCHOOL WHERE ISDELETED = 0")
            schools = [{'id': row[0], 'name': row[1]} for row in cursor.fetchall()]
        return jsonify(schools)
    except Exception as e:
        return jsonify({'error': 'Failed to fetch schools'}), 500

@app.route('/api/classes/<int:school_id>', methods=['GET'], strict_slashes=False)
def get_classes(school_id):
    try:
        with get_db_connection() as conn:
            cursor = conn.cursor()
            cursor.execute("SELECT CLASS_CD, CLASS FROM SCHOOL_CLASSES WHERE SCHOOL_ID = ? AND ISDELETED = 0", (school_id,))
            classes = [{'code': row[0], 'name': row[1]} for row in cursor.fetchall()]
        return jsonify(classes)
    except Exception as e:
        return jsonify({'error': 'Failed to fetch classes'}), 500

@app.route('/api/teachers/<int:school_id>', methods=['GET'], strict_slashes=False)
def get_teachers(school_id):
    try:
        with get_db_connection() as conn:
            cursor = conn.cursor()
            cursor.execute("SELECT TEACHER_ID, TEACHER_NAME FROM TEACHER WHERE ISDELETED = 0 AND SCHOOL_ID = ?", (school_id,))
            teachers = [{'id': row[0], 'name': row[1]} for row in cursor.fetchall()]
        return jsonify(teachers)
    except Exception as e:
        return jsonify({'error': 'Failed to fetch teachers'}), 500

@app.route('/api/students/<int:school_id>/<int:class_cd>', methods=['GET'], strict_slashes=False)
def get_students(school_id, class_cd):
    try:
        with get_db_connection() as conn:
            cursor = conn.cursor()
            cursor.execute("""
                SELECT A.STUDENT_ID, (B.STUDENT_FIRST_NAME + ' ' + B.STUDENT_LAST_NAME) AS STUDENT_NAME
                FROM STUDENT_CLASSES A, STUDENT B
                WHERE A.SCHOOL_ID = B.SCHOOL_ID
                AND A.CLASS_CD = B.CLASS_CD
                AND A.STUDENT_ID = B.STUDENT_ID
                AND A.SCHOOL_ID = ?
                AND A.CLASS_CD = ?
                AND A.ISDELETED = 0
            """, (school_id, class_cd))
            students = [{'id': row[0], 'name': row[1]} for row in cursor.fetchall()]
        return jsonify(students)
    except Exception as e:
        return jsonify({'error': 'Failed to fetch students'}), 500

@app.route('/api/attendance', methods=['POST'], strict_slashes=False)
def save_attendance():
    try:
        data = request.json
        with get_db_connection() as conn:
            cursor = conn.cursor()
            status_desc = 'Present' if data['status'] == 1 else 'Absent'
            cursor.execute("""
                INSERT INTO Attendance (
                    STUDENT_ID, CLASS_CD, SCHOOL_ID, ATTENDANCE_DATE,
                    STATUS, ATTENDANCE_STATUS_DESC, TEACHER_ID
                ) VALUES (?, ?, ?, ?, ?, ?, ?)
            """, (
                data['studentId'],
                data['classCode'],
                data['schoolId'],
                data['attendanceDate'],
                data['status'],
                status_desc,
                data['teacherId']
            ))
            conn.commit()
        return jsonify({'message': 'Attendance saved successfully'})
    except Exception as e:
        return jsonify({'error': 'Failed to save attendance'}), 500

if __name__ == '__main__':
    app.run(debug=True)