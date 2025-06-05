from flask import Flask, jsonify
from prometheus_flask_exporter import PrometheusMetrics
import psycopg2
import os

app = Flask(__name__)

# חשיפת מדדים עם קבוצת endpoint
metrics = PrometheusMetrics(app, group_by='endpoint')

@app.route('/')
def index():
    return "hello from Flask app!"

@app.route('/health')
def health():
    return jsonify({"status": "ok"})

@app.route('/db')
def db_check():
    try:
        # יצירת חיבור למסד הנתונים
        conn = psycopg2.connect(
            dbname=os.getenv("POSTGRES_DB", "app"),
            user=os.getenv("POSTGRES_USER", "user"),
            password=os.getenv("POSTGRES_PASSWORD", "password"),
            host=os.getenv("POSTGRES_HOST", "localhost"),
            port=os.getenv("POSTGRES_PORT", "5432")  # אופציונלי, ברירת מחדל
        )
        cur = conn.cursor()
        cur.execute("SELECT 1;")
        cur.close()
        conn.close()
        return jsonify({"db": "ok"})
    
    except Exception as e:
        return jsonify({"db": "error", "details": str(e)}), 500

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)
